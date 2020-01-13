#include "code_generate/CodeGenerator.hpp"
#include "AST/assignment.hpp"
#include "AST/ast.hpp"
#include "AST/binary_operator.hpp"
#include "AST/compound_statement.hpp"
#include "AST/constant_value.hpp"
#include "AST/declaration.hpp"
#include "AST/for.hpp"
#include "AST/function.hpp"
#include "AST/function_call.hpp"
#include "AST/if.hpp"
#include "AST/print.hpp"
#include "AST/program.hpp"
#include "AST/read.hpp"
#include "AST/return.hpp"
#include "AST/unary_operator.hpp"
#include "AST/variable.hpp"
#include "AST/variable_reference.hpp"
#include "AST/while.hpp"
#include "semantic/SymbolTable.hpp"
#include <cstdio>
#include <iomanip>
#include <iostream>
using namespace std;

void CodeGenerator::visit(ProgramNode *m) {
    // Put Symbol Table (Special Case)
    this->table_push();

    // Visit Child Nodes
    this->push_src_node(EnumNodeTable::PROGRAM_NODE);

        if (m->declaration_node_list != nullptr)
            for (uint i = 0; i < m->declaration_node_list->size(); i++) {
                (*(m->declaration_node_list))[i]->accept(*this);
            }

        if (m->function_node_list != nullptr)
            for (uint i = 0; i < m->function_node_list->size(); i++) {
                (*(m->function_node_list))[i]->accept(*this);
            }

        this->function_header(string("main"));
        this->stacking();

        if (m->compound_statement_node != nullptr)
            m->compound_statement_node->accept(*this);

        this->unstacking(string("main"));

    this->pop_src_node();

    // Pop Scope
    this->table_pop();
}

void CodeGenerator::visit(DeclarationNode *m) {
    // Visit Child Nodes
    this->push_src_node(EnumNodeTable::DECLARATION_NODE);
    if (m->variables_node_list != nullptr)
        for (uint i = 0; i < m->variables_node_list->size(); i++) {
            (*(m->variables_node_list))[i]->accept(*this);
        }
    this->pop_src_node();
}

void CodeGenerator::visit(VariableNode *m) {
    if(this->current_scope->level == 0) {
        // Global Scope
        if(m->constant_value_node == nullptr) { // Not Constant
            EMITSN("")
            EMITSN("# GLOBAL VARIABLE")
            EMITSN(".bss");
            EMITSN(string(m->variable_name+":").c_str());
            EMITSN("  .word 0");
        } else {
            EMITSN("")
            EMITSN("# GLOBAL CONSTANT")
            EMITSN(".text");
            EMITSN(string(m->variable_name+":").c_str());
            EMITS("  .word ");
            EMITSN(to_string(m->type->int_literal).c_str());
        }
    } else {
        // Local Scope
        if(m->constant_value_node == nullptr) { // Not Constant
            this->offset_down_32bit();
            this->get_table_entry(m->variable_name)
                ->set_address_offset(this->s0_offset);

        } else {
            this->offset_down_32bit();
            this->get_table_entry(m->variable_name)
                ->set_address_offset(this->s0_offset);
            
            string value   = to_string(m->type->int_literal);
            string address = to_string(this->s0_offset)+string("(s0)");
            EMITS_2("  li  ","t0",value.c_str());
            EMITSN("  # local constant: load immediate");
            EMITS_2("  sw  ","t0",address.c_str());
            EMITSN("  # local_constant: save immediate");
        }
    }
}

void CodeGenerator::visit(ConstantValueNode *m) { // EXPRESSION
    EMITS_2("  li  ", "t0", to_string(m->constant_value->int_literal).c_str());
    EMITSN("  # constant_value: give value");
    STACK_PUSH_64("t0");
}

void CodeGenerator::visit(FunctionNode *m) {
    // Push Scope
    this->level_up();
    this->table_push();
    
    int label_return = this->new_label();

    this->function_header(m->function_name);
    this->stacking();

    // Visit Child Node
    this->push_src_node(EnumNodeTable::FUNCTION_NODE);
        // Parameter Declaratoin
        if (m->parameters != nullptr){
            for (uint i = 0; i < m->parameters->size(); i++) {
                (*(m->parameters))[i]->node->accept(*this);
            }

            if(m->prototype.size() <= 8){
                for (uint i = 0; i < m->prototype.size(); i++) {
                    string entry_name = this->current_scope->entry_name[i];
                    SymbolEntry* entry = 
                        &(this->current_scope->entry[entry_name]);
                    
                    string source = string("a")+to_string(i);
                    string target = to_string(entry->address_offset)+string("(s0)");
                    EMITS_2("  sw  ", source.c_str(), target.c_str());
                    EMITSN("  # param_save_to_local");
                }
            } else {
                int over_size = 8*(m->prototype.size());

                for (uint i = 0; i < m->prototype.size(); i++) {
                    string entry_name = this->current_scope->entry_name[i];
                    SymbolEntry* entry = 
                        &(this->current_scope->entry[entry_name]);
                    
                    string source = to_string(over_size-8)+string("(s0)");
                    string target = to_string(entry->address_offset)+string("(s0)");
                    EMITS_2("  lw  ", "t1", source.c_str());
                    EMITSN("  # param_save_to_local: stack load");
                    EMITS_2("  sw  ", "t1", target.c_str());
                    EMITSN("  # param_save_to_local: save");

                    over_size-=8;
                }
            }        
        }

        // Statement
        this->specify_return_label_on(label_return);
        if (m->body != nullptr)
            m->body->accept(*this);
        this->specify_return_label_off();

    this->pop_src_node();

    EMIT_LABEL(label_return);
    this->unstacking(m->function_name);

    // Pop Scope
    this->table_pop();
    this->level_down();
}

void CodeGenerator::visit(CompoundStatementNode *m) { // STATEMENT
    // Push Scope
    if (this->src_node.top() != EnumNodeTable::FUNCTION_NODE) {
        this->level_up();
        this->table_push();
    }

    // Visit Child Nodes
    this->push_src_node(EnumNodeTable::COMPOUND_STATEMENT_NODE);
    if (m->declaration_node_list != nullptr)
        for (uint i = 0; i < m->declaration_node_list->size(); i++) {
            (*(m->declaration_node_list))[i]->accept(*this);
        }

    if (m->statement_node_list != nullptr)
        for (uint i = 0; i < m->statement_node_list->size(); i++) {
            (*(m->statement_node_list))[i]->accept(*this);
        }
    this->pop_src_node();

    // Pop Scope
    if (this->src_node.top() != EnumNodeTable::FUNCTION_NODE) {
        this->table_pop();
        this->level_down();
    }
}

void CodeGenerator::visit(AssignmentNode *m) { // STATEMENT
    // Visit Child Node
    this->push_src_node(EnumNodeTable::ASSIGNMENT_NODE);
        // First, Compute RHS Value
        if (m->expression_node != nullptr)
            m->expression_node->accept(*this);

        // Second, Get LHS Address
        if (m->variable_reference_node != nullptr)
            m->variable_reference_node->accept(*this);
    this->pop_src_node();

    STACK_TOP("t0");
    STACK_POP_64;

    STACK_TOP("t1");
    STACK_POP_64;

    EMITS_2("  sw  ", "t1", "0(t0)");
    EMITSN("  # assign");
}

void CodeGenerator::visit(PrintNode *m) { // STATEMENT
    // Visit Child Node
    this->push_src_node(EnumNodeTable::PRINT_NODE);
        if (m->expression_node != nullptr)
            m->expression_node->accept(*this);
    this->pop_src_node();
    
    STACK_TOP("t0");
    STACK_POP_64;

    EMITS_2("  mv  ","a0","t0");
    EMITSN("  # print: move param to a0");
    EMITS_2("  jal ","ra","print");
    EMITSN("  # print: jump to print");
}

void CodeGenerator::visit(ReadNode *m) { // STATEMENT
    // Visit Child Node
    this->push_src_node(EnumNodeTable::READ_NODE);

        EMITSN("  jal  ra, read  # read: jump to read");

        if (m->variable_reference_node != nullptr)
            m->variable_reference_node->accept(*this);

        STACK_TOP("t0");
        STACK_POP_64;

        EMITSN("  sw   a0, 0(t0)  # read: move ret_val to var_ref");

    this->pop_src_node();

}

void CodeGenerator::visit(VariableReferenceNode *m) { // EXPRESSION
    this->push_src_node(EnumNodeTable::VARIABLE_REFERENCE_NODE);
        //if (m->expression_node_list != nullptr)
        //    for (int i = m->expression_node_list->size() - 1; i >= 0; i--) // REVERSE TRAVERSE
        //        (*(m->expression_node_list))[i]->accept(*this);
    this->pop_src_node();

    SymbolEntry* entry = this->get_table_entry(m->variable_name);
    if(this->src_node.top() == EnumNodeTable::READ_NODE ||
       this->src_node.top() == EnumNodeTable::ASSIGNMENT_NODE ){
        // GIVE THE ADDRESS OF THE VARIABLE
        if(entry->level == 0){
            EMITS_2("  la  ", "t0", m->variable_name.c_str());
            EMITSN("  # var_ref: give address");
            STACK_PUSH_64("t0");
        } else {
            string offset = to_string(entry->address_offset);
            EMITS_3("  addi", "t0", "s0", offset.c_str());
            EMITSN("  # var_ref: give address");
            STACK_PUSH_64("t0");
        }
    }
    else {
        if(entry->level == 0){
            EMITS_2("  la  ", "t1", m->variable_name.c_str());
            EMITSN("  # var_ref: load address");
            EMITS_2("  lw  ", "t0", "0(t1)");
            EMITSN("  # var_ref: give value");
            STACK_PUSH_64("t0");

        } else { 
            string address = to_string(entry->address_offset) + string("(s0)");
            EMITS_2("  lw  ", "t0", address.c_str());
            EMITSN("  # var_ref: give value");
            STACK_PUSH_64("t0");
        }
    }

}

void CodeGenerator::visit(BinaryOperatorNode *m) { // EXPRESSION
    // Visit Child Node
    this->push_src_node(EnumNodeTable::BINARY_OPERATOR_NODE);
        if (m->left_operand != nullptr)
            m->left_operand->accept(*this);
        
        if (m->right_operand != nullptr)
            m->right_operand->accept(*this);
    this->pop_src_node();

    STACK_TOP("t0"); // RHS
    STACK_POP_64;

    STACK_TOP("t1"); // LHS
    STACK_POP_64;

    if(this->is_specify_label == true){
        switch(m->op){
            
            // WE NEED EXACTLY INVERSE CASE
            // Since Branch invokes when the result is FALSE

            case EnumOperator::OP_LESS: { // need >=
                EMITS_3("  bge ", "t1", "t0", this->get_specify_label().c_str());
            } break;
            case EnumOperator::OP_LESS_OR_EQUAL: { // need >
                EMITS_3("  bgt ", "t1", "t0", this->get_specify_label().c_str());
            } break;
            case EnumOperator::OP_EQUAL: { // need !=
                EMITS_3("  bne ", "t1", "t0", this->get_specify_label().c_str());
            } break;
            case EnumOperator::OP_GREATER: { // need <=
                EMITS_3("  ble ", "t1", "t0", this->get_specify_label().c_str());
            } break;
            case EnumOperator::OP_GREATER_OR_EQUAL: { // need <
                EMITS_3("  blt ", "t1", "t0", this->get_specify_label().c_str());
            } break;
            case EnumOperator::OP_NOT_EQUAL: { // need ==
                EMITS_3("  beq ", "t1", "t0", this->get_specify_label().c_str());
            } break;
            default: break;
        }

        EMITSN("  # binary_op: branch expression");

    } else {
        switch(m->op){
            case EnumOperator::OP_PLUS: {
                EMITS_3("  addw", "t2", "t1", "t0");        
            } break;
            case EnumOperator::OP_MINUS: {
                EMITS_3("  subw", "t2", "t1", "t0");   
            } break;
            case EnumOperator::OP_MULTIPLY: {
                EMITS_3("  mulw", "t2", "t1", "t0");  
            } break;
            case EnumOperator::OP_DIVIDE: {
                EMITS_3("  divw", "t2", "t1", "t0");    
            } break;
            case EnumOperator::OP_MOD: {
                EMITS_3("  remw", "t2", "t1", "t0"); 
            } break;
            default: break;
        }

        EMITSN("  # binary_op: arithmatic expression");
        STACK_PUSH_64("t2");            
    }
}

void CodeGenerator::visit(UnaryOperatorNode *m) { // EXPRESSION
    // Visit Child Node
    this->push_src_node(EnumNodeTable::UNARY_OPERATOR_NODE);
        if (m->operand != nullptr)
            m->operand->accept(*this);
    this->pop_src_node();

    STACK_TOP("t0");
    STACK_POP_64;

    if(this->is_specify_label == true){
        ;
    } else {
        switch(m->op){
            case EnumOperator::OP_MINUS: {
                EMITS_3("  subw", "t1", "zero", "t0");
            } break;
            default: break;
        }

        EMITSN("  # unary_op: arithmatic expression");
        STACK_PUSH_64("t1");            
    }
}

void CodeGenerator::visit(IfNode *m) { // STATEMENT
    int label_1 = new_label(); // for entering if
    int label_2 = new_label(); // for entering else
    int label_3 = new_label(); // for entering end

    // Visit Child Nodes
    this->push_src_node(EnumNodeTable::IF_NODE);
        
        this->specify_label_on(label_2); // if FALSE jump to L2
        if (m->condition != nullptr)
            m->condition->accept(*this);
        this->specify_label_off();

        EMIT_LABEL(label_1);

        if (m->body != nullptr)
            for (uint i = 0; i < m->body->size(); i++)
                (*(m->body))[i]->accept(*this);

        EMITS_1("  j   ",this->label_convert(label_3).c_str());
        EMITSN("  # if: jump to end");
        EMIT_LABEL(label_2);

        if (m->body_of_else != nullptr)
            for (uint i = 0; i < m->body_of_else->size(); i++)
                (*(m->body_of_else))[i]->accept(*this);

        EMIT_LABEL(label_3);

    this->pop_src_node();
}

void CodeGenerator::visit(WhileNode *m) { // STATEMENT
    
    int label_1 = new_label();
    int label_2 = new_label();
    
    // Visit Child Nodes
    this->push_src_node(EnumNodeTable::WHILE_NODE);

        EMIT_LABEL(label_1);

        this->specify_label_on(label_2); // if FALSE jump to L2
        if (m->condition != nullptr)
            m->condition->accept(*this);
        this->specify_label_off();

        if (m->body != nullptr)
            for (uint i = 0; i < m->body->size(); i++)
                (*(m->body))[i]->accept(*this);

        EMITS_1("  j   ",this->label_convert(label_1).c_str()); // back edge
        EMITSN("  # while: jump back");
        EMIT_LABEL(label_2);

    this->pop_src_node();
}

void CodeGenerator::visit(ForNode *m) { // STATEMENT
    // Push Scope
    this->level_up();
    this->table_push();

    int label_1 = new_label();
    int label_2 = new_label();

    // Visit Child Node
    this->push_src_node(EnumNodeTable::FOR_NODE);
    
        // loop_var declaration
        if (m->loop_variable_declaration != nullptr)
            m->loop_variable_declaration->accept(*this);

        // assign initial_value to loop_var
        if (m->initial_statement != nullptr)
            m->initial_statement->accept(*this);

        SymbolEntry* loop_var_entry = this->get_loop_var();
        string loop_var = to_string(loop_var_entry->address_offset)+string("(s0)");

        EMIT_LABEL(label_1);

        // Just a Constant_Value Node
        if (m->condition != nullptr)
            m->condition->accept(*this);
        
        STACK_TOP("t0"); // UpperBound;
        STACK_POP_64;

        EMITS_2("  lw  ","t1",loop_var.c_str());
        EMITSN("  # for: load loop_var");
        EMITS_3("  bge ","t1", "t0",this->label_convert(label_2).c_str());
        EMITSN("  # for: branch");

        if (m->body != nullptr)
            for (uint i = 0; i < m->body->size(); i++)
                (*(m->body))[i]->accept(*this);

        EMITS_2("  lw  ","t1",loop_var.c_str());
        EMITSN("  # for: load loop_var");
        EMITS_3("  addi","t1","t1","1");
        EMITSN("  # for: loop_var++");
        EMITS_2("  sw  ","t1",loop_var.c_str());
        EMITSN("  # for: save loop_var");

        EMITS_1("  j   ",this->label_convert(label_1).c_str()); // back edge
        EMITSN("  # for: jump back");

        EMIT_LABEL(label_2);

    this->pop_src_node();

    // Pop Scope
    this->table_pop();
    this->level_down();
}

void CodeGenerator::visit(ReturnNode *m) { // STATEMENT
    // Visit Child Node
    this->push_src_node(EnumNodeTable::RETURN_NODE);
        if (m->return_value != nullptr)
            m->return_value->accept(*this);
    this->pop_src_node();

    STACK_TOP("t0");
    STACK_POP_64;

    EMITS_2("  mv  ","a0","t0");
    EMITSN("  # return: move ret_val");

    if(this->is_specify_return_label == true){
        EMITS_1("  j   ",this->label_convert(this->specify_return_label).c_str()); // jump unstacking
        EMITSN("  # return: jump to unstacking");
    }

}

void CodeGenerator::visit(FunctionCallNode *m) { // EXPRESSION //STATEMENT
    // Visit Child Node
    int over_size = 0;

    this->push_src_node(EnumNodeTable::FUNCTION_CALL_NODE);

        if (m->arguments != nullptr){
            if(m->arguments->size()<=8){
                for (uint i = 0; i < m->arguments->size(); i++){
                    (*(m->arguments))[i]->accept(*this);
                }

                for (int i=m->arguments->size()-1; i>=0; i--){
                    STACK_TOP("t0");
                    STACK_POP_64;   

                    string target = string("a")+to_string(i);
                    EMITS_2("  mv  ", target.c_str(), "t0");
                    EMITSN("  # function_call: move param")
                }

            } else {
                
                EMITSN("  # function_call: move param, over-eight")
                for (uint i = 0; i < m->arguments->size(); i++){
                    (*(m->arguments))[i]->accept(*this);
                }

                over_size = 8*(m->arguments->size());      
            }
        }
        
        EMITS_2("  jal ", "ra", m->function_name.c_str());
        EMITSN("  # function_call: jump to function");

        if(over_size > 0) {
            EMITS_3("  addi", "sp", "sp", to_string(over_size).c_str());
            EMITSN("  # pop_param")
        }

        STACK_PUSH_64("a0");

    this->pop_src_node();
}
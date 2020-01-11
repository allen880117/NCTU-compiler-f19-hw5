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
            EMITSN(".bss");
            EMITSN(string(m->variable_name+":").c_str());
            EMITSN("  .word 0");
            EMITSN("");
        } else {
            EMITSN(".text");
            EMITSN(string(m->variable_name+":").c_str());
            EMITS("  .word ");
            EMITDN(m->type->int_literal);
            EMITSN("");
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
            
            EMITS("  li  t0, ");
            EMITDN(m->type->int_literal);
            EMITS("  sw  t0, ");
            EMITD(this->s0_offset);
            EMITSN("(s0)");
            EMITSN("");
        }
    }
}

void CodeGenerator::visit(ConstantValueNode *m) { // EXPRESSION
    EMITSN_2("  li  ", "t0", to_string(m->constant_value->int_literal).c_str());
    STACK_PUSH_32("t0");
    EMITSN("");
}

void CodeGenerator::visit(FunctionNode *m) {
    // Push Scope
    this->level_up();
    this->table_push();
    
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
                        EMITSN_2("  sw  ", source.c_str(), target.c_str());
                    }
                } else {
                    for (uint i = 0; i < 8; i++) {
                        string entry_name = this->current_scope->entry_name[i];
                        SymbolEntry* entry = 
                            &(this->current_scope->entry[entry_name]);
                        
                        string source = string("a")+to_string(i);
                        string target = to_string(entry->address_offset)+string("(s0)");
                        EMITSN_2("  sw  ", source.c_str(), target.c_str());
                    }

                    int over_size = 4*(m->prototype.size()-8);

                    for (uint i = 8; i < m->prototype.size(); i++) {
                        string entry_name = this->current_scope->entry_name[i];
                        SymbolEntry* entry = 
                            &(this->current_scope->entry[entry_name]);
                        
                        string source = to_string(over_size)+string("(s0)");
                        string target = to_string(entry->address_offset)+string("(s0)");
                        EMITSN_2("  lw  ", "t1", source.c_str());
                        EMITSN_2("  sw  ", "t1", target.c_str());

                        over_size-=4;
                    }
                }
                
            }
            // Statement
            if (m->body != nullptr)
                m->body->accept(*this);
        this->pop_src_node();

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
    STACK_POP_32;

    STACK_TOP("t1");
    STACK_POP_32;

    EMITS_2("  sw  ", "t1", "0(t0)");
    EMITSN("");
    EMITSN("");
}

void CodeGenerator::visit(PrintNode *m) { // STATEMENT
    // Visit Child Node
    this->push_src_node(EnumNodeTable::PRINT_NODE);
        if (m->expression_node != nullptr)
            m->expression_node->accept(*this);
    this->pop_src_node();

    STACK_TOP("t0");
    STACK_POP_32;

    EMITSN("  mv   a0, t0   ");
    EMITSN("  jal  ra, print");
    EMITSN("");
}

void CodeGenerator::visit(ReadNode *m) { // STATEMENT
    // Visit Child Node
    this->push_src_node(EnumNodeTable::READ_NODE);
    
        EMITSN("  jal  ra, read");

        if (m->variable_reference_node != nullptr)
            m->variable_reference_node->accept(*this);

        STACK_TOP("t0");
        STACK_POP_32;

        EMITSN("  sw   a0, 0(t0)");

    this->pop_src_node();

    EMITSN("");
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
            EMITSN_2("  la  ", "t0", m->variable_name.c_str());
            STACK_PUSH_32("t0");

        } else {
            string offset = to_string(entry->address_offset);
            EMITSN_3("  addi", "t0", "s0", offset.c_str());
            STACK_PUSH_32("t0");
        
        }
    }
    else {
        if(entry->level == 0){
            EMITSN_2("  la  ", "t1", m->variable_name.c_str());
            EMITSN_2("  lw  ", "t0", "0(t1)");
            STACK_PUSH_32("t0");

        } else { 
            string address = to_string(entry->address_offset) + string("(s0)");
            EMITSN_2("  lw  ", "t0", address.c_str());
            STACK_PUSH_32("t0");
        }
    }

    EMITSN("");

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
    STACK_POP_32;

    STACK_TOP("t1"); // LHS
    STACK_POP_32;

    if(this->is_specify_label == true){
        switch(m->op){
            
            // WE NEED EXACTLY INVERSE CASE
            // Since Branch invokes when the result is FALSE

            case EnumOperator::OP_LESS: { // need >=
                EMITSN_3("  bge ", "t1", "t0", this->get_specify_label().c_str());
            } break;
            case EnumOperator::OP_LESS_OR_EQUAL: { // need >
                EMITSN_3("  bgt ", "t1", "t0", this->get_specify_label().c_str());
            } break;
            case EnumOperator::OP_EQUAL: { // need !=
                EMITSN_3("  bne ", "t1", "t0", this->get_specify_label().c_str());
            } break;
            case EnumOperator::OP_GREATER: { // need <=
                EMITSN_3("  ble ", "t1", "t0", this->get_specify_label().c_str());
            } break;
            case EnumOperator::OP_GREATER_OR_EQUAL: { // need <
                EMITSN_3("  blt ", "t1", "t0", this->get_specify_label().c_str());
            } break;
            case EnumOperator::OP_NOT_EQUAL: { // need ==
                EMITSN_3("  beq ", "t1", "t0", this->get_specify_label().c_str());
            } break;
            default: break;

        }
    } else {
        switch(m->op){
            case EnumOperator::OP_PLUS: {
                EMITSN_3("  addw", "t2", "t1", "t0");        
                STACK_PUSH_32("t2");            
            } break;
            case EnumOperator::OP_MINUS: {
                EMITSN_3("  subw", "t2", "t1", "t0");   
                STACK_PUSH_32("t2");            
            } break;
            case EnumOperator::OP_MULTIPLY: {
                EMITSN_3("  mulw", "t2", "t1", "t0");  
                STACK_PUSH_32("t2");            
            } break;
            case EnumOperator::OP_DIVIDE: {
                EMITSN_3("  divw", "t2", "t1", "t0");    
                STACK_PUSH_32("t2");            
            } break;
            case EnumOperator::OP_MOD: {
                EMITSN_3("  remw", "t2", "t1", "t0"); 
                STACK_PUSH_32("t2");            
            } break;
            default: break;
        }
    }

    EMITSN("");
    EMITSN("");
}

void CodeGenerator::visit(UnaryOperatorNode *m) { // EXPRESSION
    // Visit Child Node
    this->push_src_node(EnumNodeTable::UNARY_OPERATOR_NODE);
        if (m->operand != nullptr)
            m->operand->accept(*this);
    this->pop_src_node();

    STACK_TOP("t0");
    STACK_POP_32;

    if(this->is_specify_label == true){
        ;
    } else {
        switch(m->op){
            case EnumOperator::OP_MINUS: {
                EMITSN_3("  subw", "t1", "zero", "t0");
                STACK_PUSH_32("t1");            
            } break;
            default: break;
        }
    }
    
    EMITSN("");
    EMITSN("");
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
        EMITSN_1("  j   ",this->label_convert(label_3).c_str());

        if (m->body != nullptr)
            for (uint i = 0; i < m->body->size(); i++)
                (*(m->body))[i]->accept(*this);

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

        EMITSN_1("  j   ",this->label_convert(label_1).c_str()); // back edge

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

        EMIT_LABEL(label_1);

        this->specify_label_on(label_2); // if FALSE jump to L2
        if (m->condition != nullptr)
            m->condition->accept(*this);
        this->specify_label_off();

        if (m->body != nullptr)
            for (uint i = 0; i < m->body->size(); i++)
                (*(m->body))[i]->accept(*this);
        
        EMITSN_1("  j   ",this->label_convert(label_1).c_str()); // back edge

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
    STACK_POP_32;

    EMITS("  mv   a0, t0");
    EMITSN("  ;_return_");
}

void CodeGenerator::visit(FunctionCallNode *m) { // EXPRESSION //STATEMENT
    // Visit Child Node
    int over_size = 0;

    this->push_src_node(EnumNodeTable::FUNCTION_CALL_NODE);

        if (m->arguments != nullptr){
            if(m->arguments->size()<=8){
                for (uint i = 0; i < m->arguments->size(); i++){

                    (*(m->arguments))[i]->accept(*this);

                    STACK_TOP("t0");
                    STACK_POP_32;   

                    string target = string("a")+to_string(i);
                    EMITSN_2("  mv  ", target.c_str(), "t0");
                }

            } else {
                
                for (uint i = 0; i < 8; i++){

                    (*(m->arguments))[i]->accept(*this);

                    STACK_TOP("t0");
                    STACK_POP_32;  

                    string target = string("a")+to_string(i);
                    EMITSN_2("  mv  ", target.c_str(), "t0");
                }

                over_size = 4*(m->arguments->size()-8);                
                EMITSN_3("  addi", "sp", "sp", to_string(-over_size).c_str());

                for (uint i = 8; i < m->arguments->size(); i++){

                    (*(m->arguments))[i]->accept(*this);

                    STACK_TOP("t0");
                    STACK_POP_32;

                    int offset = -4*(i-8+1);
                    string target = to_string(offset)+string("(sp)");

                    EMITSN_2("  sw  ", "t0", target.c_str());
                }
            }
        }
        
        EMITSN_2("  jal ", "ra", m->function_name.c_str());

        if(over_size > 0) 
            EMITSN_3("  addi", "sp", "sp", to_string(over_size).c_str());

        STACK_PUSH_32("a0");

    this->pop_src_node();
}
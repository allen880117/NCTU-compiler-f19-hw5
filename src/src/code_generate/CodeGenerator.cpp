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
            EMITSN(";_GLOBAL_VARIABLE_");
            EMITSN(".bss");
            EMITSN(string(m->variable_name+":").c_str());
            EMITSN("  .word 0");
            EMITSN("");
        } else {
            EMITSN(";_GLOBAL_CONSTANT_");
            EMITSN(".bss");
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
            
            EMITSN("  ;_LOCAL_CONSTANT_");
            
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
}

void CodeGenerator::visit(FunctionNode *m) {
    // Push Scope
    this->level_up();
    this->table_push();
    
    // Visit Child Node
    this->push_src_node(EnumNodeTable::FUNCTION_NODE);
    if (m->parameters != nullptr)
        for (uint i = 0; i < m->parameters->size(); i++) {
            (*(m->parameters))[i]->node->accept(*this);
        }

    if (m->body != nullptr)
        m->body->accept(*this);
    this->pop_src_node();

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
    if (m->variable_reference_node != nullptr)
        m->variable_reference_node->accept(*this);

    if (m->expression_node != nullptr)
        m->expression_node->accept(*this);
    this->pop_src_node();
}

void CodeGenerator::visit(PrintNode *m) { // STATEMENT
    // Visit Child Node
    this->push_src_node(EnumNodeTable::PRINT_NODE);
    if (m->expression_node != nullptr)
        m->expression_node->accept(*this);
    this->pop_src_node();
}

void CodeGenerator::visit(ReadNode *m) { // STATEMENT
    // Visit Child Node
    this->push_src_node(EnumNodeTable::READ_NODE);
    if (m->variable_reference_node != nullptr)
        m->variable_reference_node->accept(*this);
    this->pop_src_node();
}

void CodeGenerator::visit(VariableReferenceNode *m) { // EXPRESSION
    this->push_src_node(EnumNodeTable::VARIABLE_REFERENCE_NODE);
    if (m->expression_node_list != nullptr)
        for (int i = m->expression_node_list->size() - 1; i >= 0;
                i--) // REVERSE TRAVERSE
            (*(m->expression_node_list))[i]->accept(*this);
    this->pop_src_node();
}

void CodeGenerator::visit(BinaryOperatorNode *m) { // EXPRESSION
    // Visit Child Node
    this->push_src_node(EnumNodeTable::BINARY_OPERATOR_NODE);
    if (m->left_operand != nullptr)
        m->left_operand->accept(*this);

    if (m->right_operand != nullptr)
        m->right_operand->accept(*this);
    this->pop_src_node();
}

void CodeGenerator::visit(UnaryOperatorNode *m) { // EXPRESSION
    // Visit Child Node
    this->push_src_node(EnumNodeTable::UNARY_OPERATOR_NODE);
    if (m->operand != nullptr)
        m->operand->accept(*this);
    this->pop_src_node();
}

void CodeGenerator::visit(IfNode *m) { // STATEMENT
    // Visit Child Nodes
    this->push_src_node(EnumNodeTable::IF_NODE);
    if (m->condition != nullptr)
        m->condition->accept(*this);

    if (m->body != nullptr)
        for (uint i = 0; i < m->body->size(); i++)
            (*(m->body))[i]->accept(*this);

    if (m->body_of_else != nullptr)
        for (uint i = 0; i < m->body_of_else->size(); i++)
            (*(m->body_of_else))[i]->accept(*this);
    this->pop_src_node();
}

void CodeGenerator::visit(WhileNode *m) { // STATEMENT
    // Visit Child Nodes
    this->push_src_node(EnumNodeTable::WHILE_NODE);
    if (m->condition != nullptr)
        m->condition->accept(*this);

    if (m->body != nullptr)
        for (uint i = 0; i < m->body->size(); i++)
            (*(m->body))[i]->accept(*this);
    this->pop_src_node();
}

void CodeGenerator::visit(ForNode *m) { // STATEMENT
    // Push Scope
    this->level_up();
    this->table_push();

    // Visit Child Node
    this->push_src_node(EnumNodeTable::FOR_NODE);
    if (m->loop_variable_declaration != nullptr)
        m->loop_variable_declaration->accept(*this);

    if (m->initial_statement != nullptr)
        m->initial_statement->accept(*this);

    if (m->condition != nullptr)
        m->condition->accept(*this);

    if (m->body != nullptr)
        for (uint i = 0; i < m->body->size(); i++)
            (*(m->body))[i]->accept(*this);
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
}

void CodeGenerator::visit(FunctionCallNode *m) { // EXPRESSION //STATEMENT
    // Visit Child Node
    this->push_src_node(EnumNodeTable::FUNCTION_CALL_NODE);
    if (m->arguments != nullptr)
        for (int i = m->arguments->size() - 1; i >= 0; i--) // REVERSE TRAVERSE
            (*(m->arguments))[i]->accept(*this);
    this->pop_src_node();
}

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
    SymbolTable *new_scope = new SymbolTable(0);
    this->push(new_scope, PROGRAM_NODE, VariableInfo(UNKNOWN_SET, TYPE_VOID));

    // Visit Child Nodes
    this->push_src_node(PROGRAM_NODE);
    if (m->declaration_node_list != nullptr)
        for (uint i = 0; i < m->declaration_node_list->size(); i++) {
            (*(m->declaration_node_list))[i]->accept(*this);
        }

    if (m->function_node_list != nullptr)
        for (uint i = 0; i < m->function_node_list->size(); i++) {
            (*(m->function_node_list))[i]->accept(*this);
        }

    if (m->compound_statement_node != nullptr)
        m->compound_statement_node->accept(*this);
    this->pop_src_node();

    // Pop Scope
    this->pop();
}

void CodeGenerator::visit(DeclarationNode *m) {
    // Visit Child Nodes
    this->push_src_node(DECLARATION_NODE);
    if (m->variables_node_list != nullptr)
        for (uint i = 0; i < m->variables_node_list->size(); i++) {
            (*(m->variables_node_list))[i]->accept(*this);
        }
    this->pop_src_node();
}

void CodeGenerator::visit(VariableNode *m) {
}

void CodeGenerator::visit(ConstantValueNode *m) { // EXPRESSION
}

void CodeGenerator::visit(FunctionNode *m) {
    // Push Scope
    this->level_up();
    SymbolTable *new_scope = new SymbolTable(this->level);
    this->push(new_scope, FUNCTION_NODE, *(m->return_type));

    // Visit Child Node
    this->push_src_node(FUNCTION_NODE);
    this->specify_on(KIND_PARAMETER);
    if (m->parameters != nullptr)
        for (uint i = 0; i < m->parameters->size(); i++) {
            (*(m->parameters))[i]->node->accept(*this);
        }
    this->specify_off();

    if (m->body != nullptr)
        m->body->accept(*this);
    this->pop_src_node();

    // Pop Scope
    this->pop();
    this->level_down();
}

void CodeGenerator::visit(CompoundStatementNode *m) { // STATEMENT
    // Push Scope
    if (this->src_node.top() != FUNCTION_NODE) {
        this->level_up();
        SymbolTable *new_scope = new SymbolTable(this->level);
        this->push(new_scope, COMPOUND_STATEMENT_NODE,
                   VariableInfo(UNKNOWN_SET, UNKNOWN_TYPE));
    }

    // Visit Child Nodes
    this->push_src_node(COMPOUND_STATEMENT_NODE);
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
    if (this->src_node.top() != FUNCTION_NODE) {
        this->pop();
        this->level_down();
    }
}

void CodeGenerator::visit(AssignmentNode *m) { // STATEMENT
    // Visit Child Node
    this->push_src_node(ASSIGNMENT_NODE);
    if (m->variable_reference_node != nullptr)
        m->variable_reference_node->accept(*this);

    if (m->expression_node != nullptr)
        m->expression_node->accept(*this);
    this->pop_src_node();
}

void CodeGenerator::visit(PrintNode *m) { // STATEMENT
    // Visit Child Node
    this->push_src_node(PRINT_NODE);
    if (m->expression_node != nullptr)
        m->expression_node->accept(*this);
    this->pop_src_node();
}

void CodeGenerator::visit(ReadNode *m) { // STATEMENT
    // Visit Child Node
    this->push_src_node(READ_NODE);
    if (m->variable_reference_node != nullptr)
        m->variable_reference_node->accept(*this);
    this->pop_src_node();
}

void CodeGenerator::visit(VariableReferenceNode *m) { // EXPRESSION
    this->push_src_node(VARIABLE_REFERENCE_NODE);
    if (m->expression_node_list != nullptr)
        for (int i = m->expression_node_list->size() - 1; i >= 0;
                i--) // REVERSE TRAVERSE
            (*(m->expression_node_list))[i]->accept(*this);
    this->pop_src_node();
}

void CodeGenerator::visit(BinaryOperatorNode *m) { // EXPRESSION
    // Visit Child Node
    this->push_src_node(BINARY_OPERATOR_NODE);
    if (m->left_operand != nullptr)
        m->left_operand->accept(*this);

    if (m->right_operand != nullptr)
        m->right_operand->accept(*this);
    this->pop_src_node();
}

void CodeGenerator::visit(UnaryOperatorNode *m) { // EXPRESSION
    // Visit Child Node
    this->push_src_node(UNARY_OPERATOR_NODE);
    if (m->operand != nullptr)
        m->operand->accept(*this);
    this->pop_src_node();
}

void CodeGenerator::visit(IfNode *m) { // STATEMENT
    // Visit Child Nodes
    this->push_src_node(IF_NODE);
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
    this->push_src_node(WHILE_NODE);
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
    SymbolTable *new_scope = new SymbolTable(this->level);
    this->push(new_scope, FOR_NODE, VariableInfo(UNKNOWN_SET, UNKNOWN_TYPE));

    // Visit Child Node
    this->push_src_node(FOR_NODE);
    this->specify_on(KIND_LOOP_VAR);
    if (m->loop_variable_declaration != nullptr)
        m->loop_variable_declaration->accept(*this);
    this->specify_off();

    this->specify_on(KIND_LOOP_VAR);
    if (m->initial_statement != nullptr)
        m->initial_statement->accept(*this);
    this->specify_off();

    if (m->condition != nullptr)
        m->condition->accept(*this);

    if (m->body != nullptr)
        for (uint i = 0; i < m->body->size(); i++)
            (*(m->body))[i]->accept(*this);
    this->pop_src_node();

    // Pop Scope
    this->pop();
    this->level_down();
}

void CodeGenerator::visit(ReturnNode *m) { // STATEMENT
    // Visit Child Node
    this->push_src_node(RETURN_NODE);
    if (m->return_value != nullptr)
        m->return_value->accept(*this);
    this->pop_src_node();
}

void CodeGenerator::visit(FunctionCallNode *m) { // EXPRESSION //STATEMENT
    // Visit Child Node
    this->push_src_node(FUNCTION_CALL_NODE);
    if (m->arguments != nullptr)
        for (int i = m->arguments->size() - 1; i >= 0; i--) // REVERSE TRAVERSE
            (*(m->arguments))[i]->accept(*this);
    this->pop_src_node();
}

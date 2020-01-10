#pragma once
#include "AST/ast.hpp"
#include "semantic/SymbolTable.hpp"
#include "visitor/visitor.hpp"
#include <cstdio>
#include <stack>
#include <string>
#include <vector>
using namespace std;

class CodeGenerator : public ASTVisitorBase {
  public:
    void visit(ProgramNode *m) override;
    void visit(DeclarationNode *m) override;
    void visit(VariableNode *m) override;
    void visit(ConstantValueNode *m) override;
    void visit(FunctionNode *m) override;
    void visit(CompoundStatementNode *m) override;
    void visit(AssignmentNode *m) override;
    void visit(PrintNode *m) override;
    void visit(ReadNode *m) override;
    void visit(VariableReferenceNode *m) override;
    void visit(BinaryOperatorNode *m) override;
    void visit(UnaryOperatorNode *m) override;
    void visit(IfNode *m) override;
    void visit(WhileNode *m) override;
    void visit(ForNode *m) override;
    void visit(ReturnNode *m) override;
    void visit(FunctionCallNode *m) override;

    CodeGenerator(string _filename, string _dirpath, SymbolTable* table_root);
    ~CodeGenerator(){}; // Don't Delete SymbolTable (it'll be deleted by SemanticAnalyzer)

    void out_file_create();
    void out_file_save();

  private:
    // FILE INFO
    FILE*        out_fp;
    string       out_file_name;
    
    // SEMANTIC INFO
    SymbolTable* table_root;
    SymbolTable *current_scope;
    void table_push();
    void table_pop();

    unsigned int level;
    void level_up();
    void level_down();

    // STACK INFO
    stack<EnumNodeTable> src_node;
    void push_src_node(EnumNodeTable);
    void pop_src_node();
};
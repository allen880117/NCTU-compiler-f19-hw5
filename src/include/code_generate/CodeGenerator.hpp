#pragma once
#include "AST/ast.hpp"
#include "semantic/SymbolTable.hpp"
#include "visitor/visitor.hpp"
#include <cstdio>
#include <stack>
#include <string>
#include <vector>
using namespace std;

#define EMITS(val) fprintf(this->out_fp, "%s",(val));
#define EMITSN(val) fprintf(this->out_fp, "%s\n",(val));
#define EMITD(val) fprintf(this->out_fp, "%d",(val));
#define EMITDN(val) fprintf(this->out_fp, "%d\n",(val));

#define EMITSN_1(instr, val1) \
  fprintf(this->out_fp, "%s %s\n",(instr),(val1));

#define EMITS_1(instr, val1) \
  fprintf(this->out_fp, "%s %s",(instr),(val1)); \

#define EMITSN_2(instr, val1, val2) \
  fprintf(this->out_fp, "%s %s, %s\n",(instr),(val1),(val2)); \

#define EMITS_2(instr, val1, val2) \
  fprintf(this->out_fp, "%s %s, %s",(instr),(val1),(val2));

#define EMITSN_3(instr, val1, val2, val3) \
  fprintf(this->out_fp, "%s %s, %s, %s\n",(instr),(val1),(val2),(val3));

#define EMITS_3(instr, val1, val2, val3) \
  fprintf(this->out_fp, "%s %s, %s, %s",(instr),(val1),(val2),(val3));

#define EMIT_LABEL(val) \
  fprintf(this->out_fp, "L%d:\n",(val));

#define INSERT_LABEL(val) \
  fprintf(this->out_fp, "L%d\n",(val));

#define STACK_POP_32 \
  EMITS_3("  addi", "sp", "sp", "4") \
  EMITSN("  # 32BITS STACK POP") \

#define STACK_PUSH_32(val) \
  { \
  EMITS_3("  addi", "sp", "sp", "-4") \
  EMITSN(" # 32BITS STACK PUSH STEP1") \
  EMITS_2("  sw  ", (val), "0(sp)")   \
  EMITSN("  # 32BITS STACK PUSH STEP2") \
  } \

#define STACK_TOP(target) \
  EMITS_2("  lw  ", (target), "0(sp)") \
  EMITSN("  # 32BITS STACK TOP") \

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
    string       in_file_name;
    string       out_file_name;
    
    // SEMANTIC INFO
    SymbolTable* table_root;
    SymbolTable *current_scope;
    void table_push();
    void table_pop();

    unsigned int level;
    void level_up();
    void level_down();

    // SYMBOL
    SymbolEntry* get_table_entry(string);
    SymbolEntry* get_loop_var();

    // STACK INFO
    stack<EnumNodeTable> src_node;
    void push_src_node(EnumNodeTable);
    void pop_src_node();

    // ADDRESS OFFSET
    int  s0_offset = 0;
    void offset_down_64bit();
    void offset_up_64bit();
    void offset_down_32bit();
    void offset_up_32bit();

    // COMMON ASSEMBLY CODE
    void function_header(string);
    void stacking();
    void unstacking(string);

    // LABEL MANAGER
    int  label;
    int  new_label();
    
    bool is_specify_label;
    int  specify_label;
    void specify_label_on(int);
    void specify_label_off();
    string get_specify_label();

    bool is_specify_return_label;
    int  specify_return_label;
    void specify_return_label_on(int);
    void specify_return_label_off();
    string get_specify_return_label();
    
    string label_convert(int);

};
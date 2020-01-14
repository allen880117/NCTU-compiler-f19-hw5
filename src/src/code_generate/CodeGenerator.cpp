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
    this->push_scope_stack(EnumNodeTable::PROGRAM_NODE);

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

        if(this->is_local_fp_constant == true){
            fprintf(this->out_fp, "\n%s\n", this->lc.c_str());
        }

    this->pop_scope_stack();
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
        switch(m->type->type_set){
            case EnumTypeSet::SET_ACCUMLATED:{
                // GLOBAL VARIABLE ARRAY
                int total_num = 1;
                for(uint i=0; i<m->type->array_range.size(); i++){
                    total_num *= m->type->array_range[i].end-m->type->array_range[i].start;
                }
                EMITSN("")
                EMITSN("# GLOBAL VARIABLE ARRAY")
                EMITSN(".bss");
                EMITSN(string(m->variable_name+":").c_str());
                if(m->type->type == EnumType::TYPE_REAL){
                    for(uint i=0; i<total_num; i++){
                        EMITSN("  .float 0");
                    }
                } else {
                    for(uint i=0; i<total_num; i++){
                        EMITSN("  .word 0");
                    }
                }
                
                EMITSN(".align 2");
            } break;
            case EnumTypeSet::SET_CONSTANT_LITERAL:{
                // GLOBAL CONSTANT
                EMITSN("")
                EMITSN("# GLOBAL CONSTANT")
                EMITSN(".text");
                EMITSN(string(m->variable_name+":").c_str());
                
                string value;
                switch(m->type->type){
                    case EnumType::TYPE_INTEGER: {
                        EMITS("  .word ");
                        value = to_string(m->type->int_literal);
                        EMITSN(value.c_str());
                        EMITSN(".align 2");
                    } break;
                    case EnumType::TYPE_BOOLEAN: {
                        EMITS("  .word ");

                        if ( m->type->boolean_literal == Boolean_TRUE)
                            value = string("1");
                        else 
                            value = string("0");

                        EMITSN(value.c_str());
                        EMITSN(".align 2");
                    } break;
                    case EnumType::TYPE_REAL: {
                        EMITS("  .float");
                        value = to_string(float(m->type->real_literal));
                        EMITSN(value.c_str());
                        EMITSN(".align 2");
                    } break;
                    default: break;
                }
                
            } break;
            case EnumTypeSet::SET_SCALAR:{
                // GLOBAL VARIABLE
                EMITSN("")
                EMITSN("# GLOBAL VARIABLE")
                EMITSN(".bss");
                EMITSN(string(m->variable_name+":").c_str());
                if(m->type->type == EnumType::TYPE_REAL){
                    EMITSN("  .float 0");
                } else {
                    EMITSN("  .word 0");
                }
                
                EMITSN(".align 2");
            } break;
            default: break;
        }
    } else {
        // Local Scope
        switch(m->type->type_set){
            case EnumTypeSet::SET_ACCUMLATED:{
                // Special Case : Function Parameter
                // We need address only, so just allocate 8bytes(64bits) only
                if( this->scope_stack.top() ==EnumNodeTable::FUNCTION_NODE &&
                    this->is_specify_kind == true &&
                    this->specify_kind == FieldKind::KIND_PARAMETER ){
                    this->offset_down_64bit();
                    this->get_table_entry(m->variable_name)
                        ->set_address_offset(this->s0_offset);
                    
                    return;
                }

                // LOCAL VARIABLE ARRAY
                int total_num = 1;
                for(uint i=0; i<m->type->array_range.size(); i++){
                    total_num *= m->type->array_range[i].end-m->type->array_range[i].start;
                }
                for(uint i=0; i<total_num; i++){
                    this->offset_down_32bit();
                }
                this->get_table_entry(m->variable_name)
                    ->set_address_offset(this->s0_offset);
            } break;
            case EnumTypeSet::SET_CONSTANT_LITERAL:{
                // LOCAL CONSTANT
                this->offset_down_32bit();
                this->get_table_entry(m->variable_name)
                    ->set_address_offset(this->s0_offset);
                
                string value;
                string address = to_string(this->s0_offset)+string("(s0)");

                int fp_constant_label;
                switch(m->type->type){
                    case EnumType::TYPE_INTEGER: {
                        value = to_string(m->type->int_literal);

                        EMITS_2("  li  ","t0",value.c_str());
                        EMITSN("  # local constant: load immediate");
                        EMITS_2("  sw  ","t0",address.c_str());
                        EMITSN("  # local_constant: save immediate");
                    } break;
                    case EnumType::TYPE_BOOLEAN: {
                        if ( m->type->boolean_literal == Boolean_TRUE)
                            value = string("1");
                        else 
                            value = string("0");

                        EMITS_2("  li  ","t0",value.c_str());
                        EMITSN("  # local constant: load immediate");
                        EMITS_2("  sw  ","t0",address.c_str());
                        EMITSN("  # local_constant: save immediate");
                    } break;
                    case EnumType::TYPE_REAL: {
                        this->is_local_fp_constant = true;
                        fp_constant_label = this->new_lc(float(m->type->real_literal));
                        string hi = string("%hi(.LC")+to_string(fp_constant_label)+string(")");
                        string lo = string("%lo(.LC")+to_string(fp_constant_label)+string(")(a5)");
                        EMITS_2("  lui ","a5", hi.c_str());
                        EMITSN("  # local_constant: float-point");
                        EMITS_2("  flw ","fa5", lo.c_str());
                        EMITSN("  # local_constant: float-point");
                        EMITS_2( "  fsw ","fa5",address.c_str());
                        EMITSN("  # local_constant: float-point");
                    }
                    default: break;
                }
                
                
            } break;
            case EnumTypeSet::SET_SCALAR:{
                // LOCAL VARIABLE
                this->offset_down_32bit();
                this->get_table_entry(m->variable_name)
                    ->set_address_offset(this->s0_offset);
            } break;
            default: break;
        }
    }
}

void CodeGenerator::visit(ConstantValueNode *m) { // EXPRESSION
    string value;
    int fp_constant_label;
    switch(m->constant_value->type){
        case EnumType::TYPE_INTEGER:{
            value = to_string(m->constant_value->int_literal);
            EMITS_2("  li  ", "t0", value.c_str());
            EMITSN("  # constant_value: give value");
            STACK_PUSH_64("t0");

            this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_INTEGER));
        } break;
        case EnumType::TYPE_BOOLEAN:{
            if ( m->constant_value->boolean_literal == Boolean_TRUE)
                value = string("1");
            else 
                value = string("0");
            
            EMITS_2("  li  ", "t0", value.c_str());
            EMITSN("  # constant_value: give value");
            STACK_PUSH_64("t0");

            this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_BOOLEAN));
        } break;
        case EnumType::TYPE_REAL:{
            this->is_local_fp_constant = true;
            fp_constant_label = this->new_lc(float(m->constant_value->real_literal));
            string hi = string("%hi(.LC")+to_string(fp_constant_label)+string(")");
            string lo = string("%lo(.LC")+to_string(fp_constant_label)+string(")(a5)");
            EMITS_2("  lui ","a5", hi.c_str());
            EMITSN("  # constant_value: float-point");
            EMITS_2("  flw ","fa5", lo.c_str());
            EMITSN("  # constant_value: float-point");
            EMITS_2("  fmv.x.w","t0","fa5");
            EMITSN("  # constant_value: float-point")
            STACK_PUSH_64("t0");

            this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_REAL));
        } break;
        default: break;
    }

    
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
    this->push_scope_stack(EnumNodeTable::FUNCTION_NODE);
        // Parameter Declaration
        if (m->parameters != nullptr){
            for (uint i = 0; i < m->parameters->size(); i++) {
                this->specify_kind_on(FieldKind::KIND_PARAMETER);
                (*(m->parameters))[i]->node->accept(*this);
                this->specify_kind_off();
            }

            if(m->prototype.size() <= 8){
                int fa_num = 0;
                for (uint i = 0; i < m->prototype.size(); i++) {
                    string entry_name = this->current_scope->entry_name[i];
                    SymbolEntry* entry = 
                        &(this->current_scope->entry[entry_name]);
                    
                    string source = string("a")+to_string(i);
                    string target = to_string(entry->address_offset)+string("(s0)");
                    if(entry->type.type_set == EnumTypeSet::SET_ACCUMLATED){
                        EMITS_2("  sd  ", source.c_str(), target.c_str());
                    } else {
                        if (entry->type.type == EnumType::TYPE_REAL){
                            source = string("fa")+to_string(fa_num);
                            fa_num++;
                            EMITS_2("  fsw ", source.c_str(), target.c_str());
                        } else {
                            EMITS_2("  sw  ", source.c_str(), target.c_str());
                        }
                    }
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
                    if(entry->type.type_set == EnumTypeSet::SET_ACCUMLATED){
                        EMITS_2("  ld  ", "t1", source.c_str());
                        EMITSN("  # param_save_to_local: stack load");
                        EMITS_2("  sd  ", "t1", target.c_str());
                        EMITSN("  # param_save_to_local: save");
                    } else {
                         if (entry->type.type == EnumType::TYPE_REAL){
                            EMITS_2("  flw ", "ft1", source.c_str());
                            EMITSN("  # param_save_to_local: stack load");
                            EMITS_2("  fsw ", "ft1", target.c_str());
                            EMITSN("  # param_save_to_local: save");
                        } else {
                            EMITS_2("  lw  ", "t1", source.c_str());
                            EMITSN("  # param_save_to_local: stack load");
                            EMITS_2("  sw  ", "t1", target.c_str());
                            EMITSN("  # param_save_to_local: save");
                        }
                    }
                    over_size-=8;
                }
            }        
        }

        // Statement
        this->specify_return_label_on(label_return);
        if (m->body != nullptr)
            m->body->accept(*this);
        this->specify_return_label_off();
    
    this->pop_scope_stack();
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
        this->assignment_lhs = true;
        if (m->variable_reference_node != nullptr)
            m->variable_reference_node->accept(*this);
        this->assignment_lhs = false;
    this->pop_src_node();

    VariableInfo lhs = this->expression_stack.top();
    this->expression_stack.pop();

    VariableInfo rhs = this->expression_stack.top();
    this->expression_stack.pop();

    EMITSN("# ASSIGNMENT");

    // Address
    STACK_TOP("t0");
    STACK_POP_64;

    // Value
    STACK_TOP("t1");
    STACK_POP_64;

    int width = this->array_width.top() / 4;
    this->array_width.pop();

    if(width > 1){
        for(uint i=0; i<width; i++){
            if(rhs.type == EnumType::TYPE_REAL){
                string address = to_string(i)+string("(t1)");
                EMITS_2("  flw ", "ft2", address.c_str());
                EMITSN("  # assign: array step 1 fp");
                address = to_string(i)+string("(t0)");
                EMITS_2("  fsw ", "ft2", address.c_str());
                EMITSN("  # assign: array step 2 fp");
            } else {
                string address = to_string(i)+string("(t1)");
                EMITS_2("  lw  ", "t2", address.c_str());
                EMITSN("  # assign: array step 1");
                address = to_string(i)+string("(t0)");
                EMITS_2("  sw  ", "t2", address.c_str());
                EMITSN("  # assign: array step 2");
            }
        }
    } else {
        if(rhs.type == EnumType::TYPE_REAL){
            EMITS_2("  fmv.w.x", "ft1", "t1");
            EMITSN("  # assign fp");
            EMITS_2("  fsw ", "ft1", "0(t0)");
            EMITSN("  # assign fp");
        } else {
            EMITS_2("  sw  ", "t1", "0(t0)");
            EMITSN("  # assign");
        }
    }
}

void CodeGenerator::visit(PrintNode *m) { // STATEMENT
    // Visit Child Node
    this->push_src_node(EnumNodeTable::PRINT_NODE);
        if (m->expression_node != nullptr)
            m->expression_node->accept(*this);
    this->pop_src_node();

    EMITSN("# PRINT");

    STACK_TOP("t0");
    STACK_POP_64;

    VariableInfo rhs = this->expression_stack.top();
    this->expression_stack.pop();

    if(rhs.type == EnumType::TYPE_REAL){
        EMITS_2("  fmv.w.x","fa0","t0");
        EMITSN("  # print: move param to fa0");
    } else {
        EMITS_2("  mv  ","a0","t0");
        EMITSN("  # print: move param to a0");
    }
    if(rhs.type == EnumType::TYPE_REAL){
        EMITS_2("  jal ","ra","print_real");
        EMITSN("  # print: jump to print_real");
    } else {
        EMITS_2("  jal ","ra","print");
        EMITSN("  # print: jump to print");
    }

    EMITSN("# PRINT END");

}

void CodeGenerator::visit(ReadNode *m) { // STATEMENT
    // Visit Child Node
    this->push_src_node(EnumNodeTable::READ_NODE);

    EMITSN("# READ");

        if (m->variable_reference_node != nullptr)
            m->variable_reference_node->accept(*this);
        this->array_width.pop(); // Not Use Here, But Still Need POP

        VariableInfo rhs = this->expression_stack.top();
        this->expression_stack.pop();

        if(rhs.type == EnumType::TYPE_REAL){
            EMITSN("  jal  ra, read_real  # read: jump to read_real");
        } else {
            EMITSN("  jal  ra, read       # read: jump to read");
        }

        STACK_TOP("t0");
        STACK_POP_64;
        
        if(rhs.type == EnumType::TYPE_REAL){
            EMITSN("  fsw  fa0, 0(t0)  # read: move ret_val to var_ref");
        } else {
            EMITSN("  sw   a0, 0(t0)   # read: move ret_val to var_ref");
        }
    EMITSN("# READ END");

    this->pop_src_node();

}

void CodeGenerator::visit(VariableReferenceNode *m) { // EXPRESSION
    this->push_src_node(EnumNodeTable::VARIABLE_REFERENCE_NODE);
        if (m->expression_node_list != nullptr)
            for (int i = m->expression_node_list->size() - 1; i >= 0; i--) // REVERSE TRAVERSE
                (*(m->expression_node_list))[i]->accept(*this);
    this->pop_src_node();

    SymbolEntry* entry = this->get_table_entry(m->variable_name);
    if(this->src_node.top() == EnumNodeTable::READ_NODE ||
       this->assignment_lhs == true ){
        EMITSN("# GIVE THE ADDRESS");
        // GIVE THE ADDRESS OF THE VARIABLE
        if(entry->level == 0){ // GLOBAL
            switch(entry->type.type_set){
                case EnumTypeSet::SET_ACCUMLATED:{
                    EMITS_2("  la  ", "t0", m->variable_name.c_str());
                    EMITSN("  # var_ref: get array base");
                    
                    int slice_size = 0;
                    if(m->expression_node_list != nullptr) 
                        slice_size = m->expression_node_list->size();

                    for(uint i=0; i<slice_size; i++){
                        int width = 4;
                        for(uint j=i+1; j<entry->type.array_range.size(); j++){
                            width *= entry->type.array_range[j].end - entry->type.array_range[j].start;
                        }

                        STACK_TOP("t1");
                        STACK_POP_64;

                        this->expression_stack.pop();

                        EMITS_3("  addi", "t1", "t1", to_string(-entry->type.array_range[i].start).c_str());
                        EMITSN("  # var_ref: minus dimension lower bound");

                        EMITS_2("  li  ", "t2", to_string(width).c_str());
                        EMITSN("  # var_ref: get dimension width");

                        EMITS_3("  mulw", "t1", "t1", "t2");
                        EMITSN("  # var_ref: calculate offset");

                        EMITS_3("  addw", "t0", "t0", "t1");
                        EMITSN("  # var_ref: add offset to base");
                    }
                    
                    STACK_PUSH_64("t0");

                    int width = 4;
                    for(int i=entry->type.array_range.size()-1; i>=slice_size; i--){
                        width *= entry->type.array_range[i].end - entry->type.array_range[i].start;
                    }

                    VariableInfo temp;
                    temp.type = entry->type.type;

                    if(slice_size == entry->type.array_range.size()){
                        temp.type_set = EnumTypeSet::SET_SCALAR;
                    } else {
                        temp.type_set = EnumTypeSet::SET_ACCUMLATED;
                    }

                    this->expression_stack.push(temp);

                    this->array_width.push(width);

                } break;
                case EnumTypeSet::SET_CONSTANT_LITERAL:{
                    EMITS_2("  la  ", "t0", m->variable_name.c_str());
                    EMITSN("  # var_ref: give address");
                    STACK_PUSH_64("t0");

                    this->expression_stack.push(entry->type);

                    this->array_width.push(4);
                } break;
                case EnumTypeSet::SET_SCALAR:{
                    EMITS_2("  la  ", "t0", m->variable_name.c_str());
                    EMITSN("  # var_ref: give address");
                    STACK_PUSH_64("t0");

                    this->expression_stack.push(entry->type);

                    this->array_width.push(4);
                } break;
                default: break;
            }
            
        } else { // LOCAL
            switch(entry->type.type_set){
                case EnumTypeSet::SET_ACCUMLATED:{
                    // Special Case : Function Parameter
                    if( this->scope_stack.top() == EnumNodeTable::FUNCTION_NODE &&
                        entry->kind == FieldKind::KIND_PARAMETER ){
                        string address = to_string(entry->address_offset)+string("(s0)");
                        EMITS_2("  ld  ", "t0", address.c_str());
                        EMITSN("  # var_ref: get array base");
                    }
                    // Normal Case
                    else {
                        string address = to_string(entry->address_offset);
                        EMITS_3("  addi", "t0", "s0", address.c_str());
                        EMITSN("  # var_ref: get array base");
                    }
                    
                    int slice_size = 0;
                    if(m->expression_node_list != nullptr) 
                        slice_size = m->expression_node_list->size();

                    for(uint i=0; i<slice_size; i++){
                        int width = 4;
                        for(uint j=i+1; j<entry->type.array_range.size(); j++){
                            width *= entry->type.array_range[j].end - entry->type.array_range[j].start;
                        }

                        STACK_TOP("t1");
                        STACK_POP_64;
                        
                        this->expression_stack.pop();

                        EMITS_3("  addi", "t1", "t1", to_string(-entry->type.array_range[i].start).c_str());
                        EMITSN("  # var_ref: minus dimension lower bound");

                        EMITS_2("  li  ", "t2", to_string(width).c_str());
                        EMITSN("  # var_ref: get dimension width");

                        EMITS_3("  mulw", "t1", "t1", "t2");
                        EMITSN("  # var_ref: calculate offset");

                        EMITS_3("  addw", "t0", "t0", "t1");
                        EMITSN("  # var_ref: add offset to base");
                    }

                    STACK_PUSH_64("t0");

                    int width = 4;
                    for(int i=entry->type.array_range.size()-1; i>=slice_size; i--){
                        width *= entry->type.array_range[i].end - entry->type.array_range[i].start;
                    }
                    
                    VariableInfo temp;
                    temp.type = entry->type.type;

                    if(slice_size == entry->type.array_range.size()){
                        temp.type_set = EnumTypeSet::SET_SCALAR;
                    } else {
                        temp.type_set = EnumTypeSet::SET_ACCUMLATED;
                    }

                    this->expression_stack.push(temp);

                    this->array_width.push(width);

                } break;
                case EnumTypeSet::SET_CONSTANT_LITERAL:{
                    string offset = to_string(entry->address_offset);
                    EMITS_3("  addi", "t0", "s0", offset.c_str());
                    EMITSN("  # var_ref: give address");
                    STACK_PUSH_64("t0");

                    this->expression_stack.push(entry->type);

                    this->array_width.push(4);

                } break;
                case EnumTypeSet::SET_SCALAR:{
                    string offset = to_string(entry->address_offset);
                    EMITS_3("  addi", "t0", "s0", offset.c_str());
                    EMITSN("  # var_ref: give address");
                    STACK_PUSH_64("t0");

                    this->expression_stack.push(entry->type);

                    this->array_width.push(4);

                } break;
                default: break;
            }
        }
    }
    else {
        EMITSN("# GIVE THE VALUE");
        // GIVE THE VALUE
        if(entry->level == 0){ // GLOBAL
            switch(entry->type.type_set){
                case EnumTypeSet::SET_ACCUMLATED:{
                    EMITS_2("  la  ", "t0", m->variable_name.c_str());
                    EMITSN("  # var_ref: get array base");

                    int slice_size = 0;
                    if(m->expression_node_list != nullptr) 
                        slice_size = m->expression_node_list->size();

                    for(uint i=0; i<slice_size; i++){
                        int width = 4;
                        for(uint j=i+1; j<entry->type.array_range.size(); j++){
                            width *= entry->type.array_range[j].end - entry->type.array_range[j].start;
                        }

                        STACK_TOP("t1");
                        STACK_POP_64;

                        this->expression_stack.pop();

                        EMITS_3("  addi", "t1", "t1", to_string(-entry->type.array_range[i].start).c_str());
                        EMITSN("  # var_ref: minus dimension lower bound");

                        EMITS_2("  li  ", "t2", to_string(width).c_str());
                        EMITSN("  # var_ref: get dimension width");

                        EMITS_3("  mulw", "t1", "t1", "t2");
                        EMITSN("  # var_ref: calculate offset");

                        EMITS_3("  addw", "t0", "t0", "t1");
                        EMITSN("  # var_ref: add offset to base");
                    }

                    VariableInfo temp;
                    temp.type = entry->type.type;

                    if(slice_size == entry->type.array_range.size()){
                        // Give Value
                        EMITS_2("  lw  ", "t0", "0(t0)");
                        EMITSN("  # var_ref: array, give value");
                        STACK_PUSH_64("t0");

                        temp.type_set = EnumTypeSet::SET_SCALAR;
                    } else {
                        // Give Address
                        STACK_PUSH_64("t0");

                        temp.type_set = EnumTypeSet::SET_ACCUMLATED;
                    }

                    this->expression_stack.push(temp);

                } break;
                case EnumTypeSet::SET_CONSTANT_LITERAL:{
                    EMITS_2("  la  ", "t1", m->variable_name.c_str());
                    EMITSN("  # var_ref: load address");
                    EMITS_2("  lw  ", "t0", "0(t1)");
                    EMITSN("  # var_ref: give value");
                    STACK_PUSH_64("t0");
                    this->expression_stack.push(entry->type);
                } break;
                case EnumTypeSet::SET_SCALAR:{
                    EMITS_2("  la  ", "t1", m->variable_name.c_str());
                    EMITSN("  # var_ref: load address");
                    EMITS_2("  lw  ", "t0", "0(t1)");
                    EMITSN("  # var_ref: give value");
                    STACK_PUSH_64("t0");
                    this->expression_stack.push(entry->type);
                } break;
                default: break;
            }
        } else {  // LOCAL
            switch(entry->type.type_set){
                case EnumTypeSet::SET_ACCUMLATED:{
                    // Special Case : Function Parameter
                    if( this->scope_stack.top() == EnumNodeTable::FUNCTION_NODE &&
                        entry->kind == FieldKind::KIND_PARAMETER ){
                        string address = to_string(entry->address_offset)+string("(s0)");
                        EMITS_2("  ld  ", "t0", address.c_str());
                        EMITSN("  # var_ref: get array base");
                    }
                    // Normal Case
                    else {
                         string address = to_string(entry->address_offset);
                        EMITS_3("  addi", "t0", "s0", address.c_str());
                        EMITSN("  # var_ref: get array base");
                    }

                    int slice_size = 0;
                    if(m->expression_node_list != nullptr) 
                        slice_size = m->expression_node_list->size();

                    for(uint i=0; i<slice_size; i++){
                        int width = 4;
                        for(uint j=i+1; j<entry->type.array_range.size(); j++){
                            width *= entry->type.array_range[j].end - entry->type.array_range[j].start;
                        }

                        STACK_TOP("t1");
                        STACK_POP_64;

                        this->expression_stack.pop();

                        EMITS_3("  addi", "t1", "t1", to_string(-entry->type.array_range[i].start).c_str());
                        EMITSN("  # var_ref: minus dimension lower bound");

                        EMITS_2("  li  ", "t2", to_string(width).c_str());
                        EMITSN("  # var_ref: get dimension width");

                        EMITS_3("  mulw", "t1", "t1", "t2");
                        EMITSN("  # var_ref: calculate offset");

                        EMITS_3("  addw", "t0", "t0", "t1");
                        EMITSN("  # var_ref: add offset to base");
                    }

                    VariableInfo temp;
                    temp.type = entry->type.type;

                    if(slice_size == entry->type.array_range.size()){
                        // Give Value
                        EMITS_2("  lw  ", "t0", "0(t0)");
                        EMITSN("  # var_ref: arrray, give value");
                        STACK_PUSH_64("t0");

                        temp.type_set = EnumTypeSet::SET_SCALAR;
                    } else {
                        // Give Address
                        STACK_PUSH_64("t0");

                        temp.type_set = EnumTypeSet::SET_ACCUMLATED;
                    }

                    this->expression_stack.push(temp);

                } break;
                case EnumTypeSet::SET_CONSTANT_LITERAL:{
                    string address = to_string(entry->address_offset) + string("(s0)");
                    EMITS_2("  lw  ", "t0", address.c_str());
                    EMITSN("  # var_ref: give value");
                    STACK_PUSH_64("t0");

                    this->expression_stack.push(entry->type);
                } break;
                case EnumTypeSet::SET_SCALAR:{
                    string address = to_string(entry->address_offset) + string("(s0)");
                    EMITS_2("  lw  ", "t0", address.c_str());
                    EMITSN("  # var_ref: give value");
                    STACK_PUSH_64("t0");

                    this->expression_stack.push(entry->type);
                } break;
                default: break;
            }
           
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

    VariableInfo rhs=this->expression_stack.top();
    this->expression_stack.pop();

    STACK_TOP("t1"); // LHS
    STACK_POP_64;

    VariableInfo lhs=this->expression_stack.top();
    this->expression_stack.pop();

    int label_t0_true;
    int label_t0_false;
    int label_t1_true;
    int label_t1_false;
    int label_true;
    int label_out;
    switch(m->op){
        case EnumOperator::OP_OR: {
            label_out = this->new_label();
            label_true = this->new_label();
            label_t0_true = this->new_label();
            label_t0_false = this->new_label();
            label_t1_true = this->new_label();
            label_t1_false = this->new_label();
            EMITSN_2("  beqz ", "t0", this->label_convert(label_t0_false).c_str());
            EMITSN_1("  j  ", this->label_convert(label_t0_true).c_str());

            EMIT_LABEL(label_t0_false);
            EMITSN_2("  beqz ", "t1", this->label_convert(label_t1_false).c_str());
            EMITSN_1("  j  ", this->label_convert(label_t1_true).c_str());

            EMIT_LABEL(label_t1_false); 
            EMITSN_2("  li  ", "t2", "0");
            EMITSN_1("  j   ", this->label_convert(label_out).c_str());
           
            EMIT_LABEL(label_t0_true);
            EMIT_LABEL(label_t1_true);
            EMITSN_2("  li  ", "t2", "1");
            EMITSN_1("  j   ", this->label_convert(label_out).c_str());

            EMIT_LABEL(label_out);

            this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_BOOLEAN));
            
        } break;
        case EnumOperator::OP_AND: {
            label_out = this->new_label();
            label_true = this->new_label();
            label_t0_true = this->new_label();
            label_t0_false = this->new_label();
            label_t1_true = this->new_label();
            label_t1_false = this->new_label();
            EMITSN_2("  beqz ", "t0", this->label_convert(label_t0_false).c_str());
            EMITSN_1("  j  ", this->label_convert(label_t0_true).c_str());

            EMIT_LABEL(label_t0_true);
            EMITSN_2("  beqz ", "t1", this->label_convert(label_t1_false).c_str());
            EMITSN_1("  j  ", this->label_convert(label_t1_true).c_str());

            EMIT_LABEL(label_t1_true); 
            EMITSN_2("  li  ", "t2", "1");
            EMITSN_1("  j   ", this->label_convert(label_out).c_str());
           
            EMIT_LABEL(label_t0_false);
            EMIT_LABEL(label_t1_false);
            EMITSN_2("  li  ", "t2", "0");
            EMITSN_1("  j   ", this->label_convert(label_out).c_str());

            EMIT_LABEL(label_out);

            this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_BOOLEAN));

        } break;
        case EnumOperator::OP_LESS: {
            label_out = this->new_label();
            label_true = this->new_label();

            if(lhs.type == EnumType::TYPE_REAL || rhs.type == EnumType::TYPE_REAL){
                if(lhs.type == EnumType::TYPE_INTEGER){
                    EMITSN_2(" fcvt.s.w","ft1","t1");
                } else {
                    EMITSN_2(" fmv.w.x","ft1","t1");
                }

                if(rhs.type == EnumType::TYPE_INTEGER){
                    EMITSN_2(" fcvt.s.w","ft0","t0");
                } else {
                    EMITSN_2(" fmv.w.x","ft0","t0");
                }

                EMITSN_3("  flt", "t2", "ft1", "ft0");
                EMITSN_2("  li  ", "t3", "1");
                EMITSN_3("  beq ", "t2", "t3", this->label_convert(label_true).c_str());

            } else {
                EMITSN_3("  blt ", "t1", "t0", this->label_convert(label_true).c_str());            
            }

            EMITSN_2("  li  ", "t2", "0");
            EMITSN_1("  j   ", this->label_convert(label_out).c_str());
            EMIT_LABEL(label_true);
            EMITSN_2("  li  ", "t2", "1");
            EMITSN_1("  j   ", this->label_convert(label_out).c_str());
            EMIT_LABEL(label_out);

            this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_BOOLEAN));

        } break;
        case EnumOperator::OP_LESS_OR_EQUAL: {
            label_out = this->new_label();
            label_true = this->new_label();
            if(lhs.type == EnumType::TYPE_REAL || rhs.type == EnumType::TYPE_REAL){
                if(lhs.type == EnumType::TYPE_INTEGER){
                    EMITSN_2(" fcvt.s.w","ft1","t1");
                } else {
                    EMITSN_2(" fmv.w.x","ft1","t1");
                }

                if(rhs.type == EnumType::TYPE_INTEGER){
                    EMITSN_2(" fcvt.s.w","ft0","t0");
                } else {
                    EMITSN_2(" fmv.w.x","ft0","t0");
                }

                EMITSN_3("  fle", "t2", "ft1", "ft0");
                EMITSN_2("  li  ", "t3", "1");
                EMITSN_3("  beq ", "t2", "t3", this->label_convert(label_true).c_str());

            } else {
                EMITSN_3("  ble ", "t1", "t0", this->label_convert(label_true).c_str());            
            }
            EMITSN_2("  li  ", "t2", "0");
            EMITSN_1("  j   ", this->label_convert(label_out).c_str());
            EMIT_LABEL(label_true);
            EMITSN_2("  li  ", "t2", "1");
            EMITSN_1("  j   ", this->label_convert(label_out).c_str());
            EMIT_LABEL(label_out);

            this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_BOOLEAN));

        } break;
        case EnumOperator::OP_EQUAL: { 
            label_out = this->new_label();
            label_true = this->new_label();
            if(lhs.type == EnumType::TYPE_REAL || rhs.type == EnumType::TYPE_REAL){
                if(lhs.type == EnumType::TYPE_INTEGER){
                    EMITSN_2(" fcvt.s.w","ft1","t1");
                } else {
                    EMITSN_2(" fmv.w.x","ft1","t1");
                }

                if(rhs.type == EnumType::TYPE_INTEGER){
                    EMITSN_2(" fcvt.s.w","ft0","t0");
                } else {
                    EMITSN_2(" fmv.w.x","ft0","t0");
                }

                EMITSN_3("  feq", "t2", "ft1", "ft0");
                EMITSN_2("  li  ", "t3", "1");
                EMITSN_3("  beq ", "t2", "t3", this->label_convert(label_true).c_str());

            } else {
                EMITSN_3("  beq ", "t1", "t0", this->label_convert(label_true).c_str());            
            }
            EMITSN_2("  li  ", "t2", "0");
            EMITSN_1("  j   ", this->label_convert(label_out).c_str());
            EMIT_LABEL(label_true);
            EMITSN_2("  li  ", "t2", "1");
            EMITSN_1("  j   ", this->label_convert(label_out).c_str());
            EMIT_LABEL(label_out);

            this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_BOOLEAN));

        } break;
        case EnumOperator::OP_GREATER: { 
            label_out = this->new_label();
            label_true = this->new_label();
            if(lhs.type == EnumType::TYPE_REAL || rhs.type == EnumType::TYPE_REAL){
                if(lhs.type == EnumType::TYPE_INTEGER){
                    EMITSN_2(" fcvt.s.w","ft1","t1");
                } else {
                    EMITSN_2(" fmv.w.x","ft1","t1");
                }

                if(rhs.type == EnumType::TYPE_INTEGER){
                    EMITSN_2(" fcvt.s.w","ft0","t0");
                } else {
                    EMITSN_2(" fmv.w.x","ft0","t0");
                }

                EMITSN_3("  fle", "t2", "ft1", "ft0");
                EMITSN_2("  beqz", "t2", this->label_convert(label_true).c_str());

            } else {
                EMITSN_3("  bgt ", "t1", "t0", this->label_convert(label_true).c_str());            
            }
            EMITSN_2("  li  ", "t2", "0");
            EMITSN_1("  j   ", this->label_convert(label_out).c_str());
            EMIT_LABEL(label_true);
            EMITSN_2("  li  ", "t2", "1");
            EMITSN_1("  j   ", this->label_convert(label_out).c_str());
            EMIT_LABEL(label_out);

            this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_BOOLEAN));

        } break;
        case EnumOperator::OP_GREATER_OR_EQUAL: { 
            label_out = this->new_label();
            label_true = this->new_label();
            if(lhs.type == EnumType::TYPE_REAL || rhs.type == EnumType::TYPE_REAL){
                if(lhs.type == EnumType::TYPE_INTEGER){
                    EMITSN_2(" fcvt.s.w","ft1","t1");
                } else {
                    EMITSN_2(" fmv.w.x","ft1","t1");
                }

                if(rhs.type == EnumType::TYPE_INTEGER){
                    EMITSN_2(" fcvt.s.w","ft0","t0");
                } else {
                    EMITSN_2(" fmv.w.x","ft0","t0");
                }

                EMITSN_3("  flt", "t2", "ft1", "ft0");
                EMITSN_2("  beqz", "t2", this->label_convert(label_true).c_str());

            } else {
                EMITSN_3("  bge ", "t1", "t0", this->label_convert(label_true).c_str());            
            }
            EMITSN_2("  li  ", "t2", "0");
            EMITSN_1("  j   ", this->label_convert(label_out).c_str());
            EMIT_LABEL(label_true);
            EMITSN_2("  li  ", "t2", "1");
            EMITSN_1("  j   ", this->label_convert(label_out).c_str());
            EMIT_LABEL(label_out);

            this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_BOOLEAN));

        } break;
        case EnumOperator::OP_NOT_EQUAL: { 
            label_out = this->new_label();
            label_true = this->new_label();
            if(lhs.type == EnumType::TYPE_REAL || rhs.type == EnumType::TYPE_REAL){
                if(lhs.type == EnumType::TYPE_INTEGER){
                    EMITSN_2(" fcvt.s.w","ft1","t1");
                } else {
                    EMITSN_2(" fmv.w.x","ft1","t1");
                }

                if(rhs.type == EnumType::TYPE_INTEGER){
                    EMITSN_2(" fcvt.s.w","ft0","t0");
                } else {
                    EMITSN_2(" fmv.w.x","ft0","t0");
                }

                EMITSN_3("  feq", "t2", "ft1", "ft0");
                EMITSN_2("  beqz", "t2", this->label_convert(label_true).c_str());

            } else {
                EMITSN_3("  bne ", "t1", "t0", this->label_convert(label_true).c_str());            
            }
            EMITSN_2("  li  ", "t2", "0");
            EMITSN_1("  j   ", this->label_convert(label_out).c_str());
            EMIT_LABEL(label_true);
            EMITSN_2("  li  ", "t2", "1");
            EMITSN_1("  j   ", this->label_convert(label_out).c_str());
            EMIT_LABEL(label_out);

            this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_BOOLEAN));

        } break;

        case EnumOperator::OP_PLUS: {
            if(lhs.type == EnumType::TYPE_REAL || rhs.type == EnumType::TYPE_REAL){
                if(lhs.type == EnumType::TYPE_INTEGER){
                    EMITSN_2(" fcvt.s.w","ft1","t1");
                } else {
                    EMITSN_2(" fmv.w.x","ft1","t1");
                }

                if(rhs.type == EnumType::TYPE_INTEGER){
                    EMITSN_2(" fcvt.s.w","ft0","t0");
                } else {
                    EMITSN_2(" fmv.w.x","ft0","t0");
                }

                EMITSN_3("  fadd.s", "ft2", "ft1", "ft0");
                EMITSN_2("  fmv.x.w", "t2", "ft2");
                this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_REAL));

            } else {
                EMITS_3("  addw", "t2", "t1", "t0");     
                EMITSN("  # binary_op: arithmatic expression");
                this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_INTEGER));
            }   
        } break;
        case EnumOperator::OP_MINUS: {
            if(lhs.type == EnumType::TYPE_REAL || rhs.type == EnumType::TYPE_REAL){
                if(lhs.type == EnumType::TYPE_INTEGER){
                    EMITSN_2(" fcvt.s.w","ft1","t1");
                } else {
                    EMITSN_2(" fmv.w.x","ft1","t1");
                }

                if(rhs.type == EnumType::TYPE_INTEGER){
                    EMITSN_2(" fcvt.s.w","ft0","t0");
                } else {
                    EMITSN_2(" fmv.w.x","ft0","t0");
                }

                EMITSN_3("  fsub.s", "ft2", "ft1", "ft0");
                EMITSN_2("  fmv.x.w", "t2", "ft2");
                this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_REAL));

            } else {
                EMITS_3("  subw", "t2", "t1", "t0");   
                EMITSN("  # binary_op: arithmatic expression");
                this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_INTEGER));
            }
        } break;
        case EnumOperator::OP_MULTIPLY: {
            if(lhs.type == EnumType::TYPE_REAL || rhs.type == EnumType::TYPE_REAL){
                if(lhs.type == EnumType::TYPE_INTEGER){
                    EMITSN_2(" fcvt.s.w","ft1","t1");
                } else {
                    EMITSN_2(" fmv.w.x","ft1","t1");
                }

                if(rhs.type == EnumType::TYPE_INTEGER){
                    EMITSN_2(" fcvt.s.w","ft0","t0");
                } else {
                    EMITSN_2(" fmv.w.x","ft0","t0");
                }

                EMITSN_3("  fmul.s", "ft2", "ft1", "ft0");
                EMITSN_2("  fmv.x.w", "t2", "ft2");
                this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_REAL));

            } else {
                EMITS_3("  mulw", "t2", "t1", "t0");  
                EMITSN("  # binary_op: arithmatic expression");
                this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_INTEGER));
            }
        } break;
        case EnumOperator::OP_DIVIDE: {
            if(lhs.type == EnumType::TYPE_REAL || rhs.type == EnumType::TYPE_REAL){
                if(lhs.type == EnumType::TYPE_INTEGER){
                    EMITSN_2(" fcvt.s.w","ft1","t1");
                } else {
                    EMITSN_2(" fmv.w.x","ft1","t1");
                }

                if(rhs.type == EnumType::TYPE_INTEGER){
                    EMITSN_2(" fcvt.s.w","ft0","t0");
                } else {
                    EMITSN_2(" fmv.w.x","ft0","t0");
                }

                EMITSN_3("  fdiv.s", "ft2", "ft1", "ft0");
                EMITSN_2("  fmv.x.w", "t2", "ft2");
                this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_REAL));

            } else {
                EMITS_3("  divw", "t2", "t1", "t0"); 
                EMITSN("  # binary_op: arithmatic expression");
                this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_INTEGER));
            }
        } break;
        case EnumOperator::OP_MOD: {
            EMITS_3("  remw", "t2", "t1", "t0"); 
            EMITSN("  # binary_op: arithmatic expression");
            this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_INTEGER));
        } break;
        default: break;
    }

    STACK_PUSH_64("t2");            
}

void CodeGenerator::visit(UnaryOperatorNode *m) { // EXPRESSION
    // Visit Child Node
    this->push_src_node(EnumNodeTable::UNARY_OPERATOR_NODE);
        if (m->operand != nullptr)
            m->operand->accept(*this);
    this->pop_src_node();

    STACK_TOP("t0");
    STACK_POP_64;
    
    VariableInfo rhs=this->expression_stack.top();
    this->expression_stack.pop();

    int label_true;
    int label_out;
    switch(m->op){
        case EnumOperator::OP_NOT: {
            label_true = new_label();
            label_out  = new_label();
            EMITSN_2("  bnez", "t0", this->label_convert(label_true).c_str());
            EMITSN_2("  li  ", "t1", "1");
            EMITSN_1("  j   ", this->label_convert(label_out).c_str());
            EMIT_LABEL(label_true);
            EMITSN_2("  li  ", "t1", "0");
            EMITSN_1("  j   ", this->label_convert(label_out).c_str());
            EMIT_LABEL(label_out);

            this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_BOOLEAN));

        } break;
        case EnumOperator::OP_MINUS: {
            if(rhs.type == EnumType::TYPE_REAL){
                this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_REAL));
                if(rhs.type == EnumType::TYPE_INTEGER){
                    EMITSN_2(" fcvt.s.w","ft0","t0");
                } else {
                    EMITSN_2(" fmv.w.x","ft0","t0");
                }

                EMITSN_3("  fsub.s", "ft1", "zero", "ft0");
                EMITSN_2("  fmv.x.w", "t1", "ft1");
                this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_REAL));
            } else {
                EMITS_3("  subw", "t1", "zero", "t0");
                EMITSN("  # unary_op: arithmatic expression");
                this->expression_stack.push(VariableInfo(EnumTypeSet::SET_SCALAR, EnumType::TYPE_INTEGER));
            }
        } break;
        default: break;
    }

    STACK_PUSH_64("t1");            

}

void CodeGenerator::visit(IfNode *m) { // STATEMENT
    int label_1 = new_label(); // for entering if
    int label_2 = new_label(); // for entering else
    int label_3 = new_label(); // for entering end

    // Visit Child Nodes
    this->push_src_node(EnumNodeTable::IF_NODE);
        
        if (m->condition != nullptr)
            m->condition->accept(*this);
        
        this->expression_stack.pop(); // Still Need Pop

        STACK_TOP("t0");
        STACK_POP_64;
        
        EMITS_2("  beqz", "t0", this->label_convert(label_2).c_str());
        EMITSN("  # if: jump to else");
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

        if (m->condition != nullptr)
            m->condition->accept(*this);
        
        this->expression_stack.pop(); // Still Need Pop
        
        STACK_TOP("t0");
        STACK_POP_64;
        
        EMITS_2("  beqz ", "t0", this->label_convert(label_2).c_str());
        EMITSN("  # while: jump to out");

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

        this->expression_stack.pop(); // Still Need Pop
        
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
                    this->expression_stack.pop();

                    string target = string("a")+to_string(i);
                    EMITS_2("  mv  ", target.c_str(), "t0");
                    EMITSN("  # function_call: move param")
                }

            } else {
                
                EMITSN("  # function_call: move param, over-eight")
                for (uint i = 0; i < m->arguments->size(); i++){
                    (*(m->arguments))[i]->accept(*this);
                    this->expression_stack.pop();
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

        VariableInfo temp;
        SymbolEntry* entry = get_table_entry(m->function_name);
        temp = entry->type;
        this->expression_stack.push(temp);

    this->pop_src_node();
}
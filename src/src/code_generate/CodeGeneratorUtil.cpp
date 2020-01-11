#include "code_generate/CodeGenerator.hpp"

CodeGenerator::CodeGenerator(string _filename, string _dirpath, SymbolTable* _table_root){    
    // FILE INFO
    this->out_fp = NULL;
    _filename = _filename.substr(0, _filename.length() - 2);
    for (int i = _filename.length() - 1; i >= 0; i--) {
        if (_filename[i] == '/') {
            _filename = _filename.substr(i + 1, _filename.length() - i);
            break;
        }
    }
    this->in_file_name = _filename+".p";
    this->out_file_name = _dirpath+"/"+_filename+".s";

    // SEMANTIC INFO
    this->table_root    = _table_root;
    this->current_scope = _table_root;
    this->level         = 0;
}

void CodeGenerator::out_file_create(){
    this->out_fp = fopen(this->out_file_name.c_str(), "w");
    fprintf(this->out_fp,"%s%s%s\n", 
        "   .file \"", this->in_file_name.c_str(), "\"" );
    fprintf(this->out_fp,"%s\n",
        "   .option nopic" );
}

void CodeGenerator::out_file_save(){
    fclose(this->out_fp);
}

void CodeGenerator::table_push() {
    this->current_scope = this->current_scope->get_next_scope();
}

void CodeGenerator::table_pop(){
    this->current_scope = this->current_scope->get_parent_scope();
}

void CodeGenerator::level_up() { 
    this->level++; 
}

void CodeGenerator::level_down() { 
    this->level--; 
}

void CodeGenerator::push_src_node(EnumNodeTable _node) {
    this->src_node.push(_node);
}

void CodeGenerator::pop_src_node() { 
    this->src_node.pop(); 
}

void CodeGenerator::function_header(string _label_name) {
    fprintf(this->out_fp,"%s%s%s%s%s%s%s\n",
        ".text\n"
        "   .align 2\n"
        "   .global ",_label_name.c_str(),"\n"
        "   .type ",_label_name.c_str(),", @function\n" 
        "\n",
        _label_name.c_str(),":"
    );
}

void CodeGenerator::stacking() {
    fprintf(this->out_fp, "%s\n",
        "   addi sp, sp, -64\n"
        "   sd ra, 56(sp)   \n"
        "   sd s0, 48(sp)   \n"
        "   addi s0, sp, 64 \n"
    );
}

void CodeGenerator::unstacking(string _lable_name) {
    fprintf(this->out_fp, "%s\n",
        "   ld ra, 56(sp)  \n"      
        "   ld s0, 48(sp)  \n"          
        "   addi sp, sp, 64\n"    
        "   jr ra          \n"              
    );
    fprintf(this->out_fp, "%s%s%s%s%s\n",
        "   .size ",_lable_name.c_str(),", .-",_lable_name.c_str(),"\n"
    );
}
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
    this->out_file_name = _dirpath+"/"+_filename+".s";

    // SEMANTIC INFO
    this->table_root    = _table_root;
    this->current_scope = _table_root;
    this->level         = 0;
}

void CodeGenerator::out_file_create(){
    this->out_fp = fopen(this->out_file_name.c_str(), "w");
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
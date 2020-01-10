#include "code_generate/CodeGenerator.hpp"

CodeGenerator::CodeGenerator(string _filename, string _dirpath, SymbolTable* _table_root){    
    _filename = _filename.substr(0, _filename.length() - 2);
    for (int i = _filename.length() - 1; i >= 0; i--) {
        if (_filename[i] == '/') {
            _filename = _filename.substr(i + 1, _filename.length() - i);
            break;
        }
    }
    this->out_file_name = _dirpath+"/"+_filename+".s";

    this->table_root = _table_root;
}

void CodeGenerator::out_file_create(){
    this->out_fp = fopen(this->out_file_name.c_str(), "w");
}

void CodeGenerator::out_file_save(){
    fclose(this->out_fp);
}
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
    this->label         = 0;

    this->is_specify_label = false;
    this->specify_label    = 0;
}

void CodeGenerator::out_file_create(){
    this->out_fp = fopen(this->out_file_name.c_str(), "w");
    
    SEPERATE; 
    EMITSN("  ;_HEADER_PART_");
    SEPERATE; 
    
    fprintf(this->out_fp,"%s%s%s\n", 
        "  .file   \"", this->in_file_name.c_str(), "\"" );
    fprintf(this->out_fp,"%s\n",
        "  .option nopic\n" );
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

SymbolEntry* CodeGenerator::get_table_entry(string _name){
    SymbolTable *current = this->current_scope;
    while (true) {
        if (current->entry[_name].is_used == true) {
            return &(current->entry[_name]);
        } else {
            if (current->level == 0)
                break;
            else
                current = current->prev_scope;
        }
    }
    return nullptr; // Won't Happen .... Maybe
}


void CodeGenerator::push_src_node(EnumNodeTable _node) {
    this->src_node.push(_node);
}

void CodeGenerator::pop_src_node() { 
    this->src_node.pop(); 
}

void CodeGenerator::push_target_reg(int _reg_num){
    this->target_reg.push(_reg_num);
}

void CodeGenerator::pop_target_reg(){
    this->target_reg.pop();
}

string CodeGenerator::get_target_reg(){
    return string("t")+to_string(this->target_reg.top());
}

void CodeGenerator::offset_down_64bit(){
    this->s0_offset-=8;
}
void CodeGenerator::offset_up_64bit(){
    this->s0_offset+=8;
}
void CodeGenerator::offset_down_32bit(){
    this->s0_offset-=4;
}
void CodeGenerator::offset_up_32bit(){
    this->s0_offset+=4;
}

void CodeGenerator::function_header(string _label_name) {
    SEPERATE;
    EMITSN("  ;_MAIN_/_FUNCTION_");
    SEPERATE; 

    fprintf(this->out_fp,"%s%s%s%s%s%s%s\n",
        ".text\n"
        "  .align  2\n"
        "  .global ",_label_name.c_str(),"\n"
        "  .type   ",_label_name.c_str(),", @function\n" 
        "\n",
        _label_name.c_str(),":"
    );
}

void CodeGenerator::stacking() {

    this->s0_offset = 0;

    this->offset_down_64bit();
    this->offset_down_64bit();

    EMITSN("");
    EMITSN("  ;_STACKING_");
    fprintf(this->out_fp, "%s\n",
        "  addi sp, sp, -64\n"
        "  sd   ra, 56(sp) ; ra is 8bytes(64bits)\n"
        "  sd   s0, 48(sp) ; s0 is 8bytes(64bits)\n"
        "  addi s0, sp, 64 "
    );
    EMITSN("");
}

void CodeGenerator::unstacking(string _lable_name) {

    EMITSN("");
    EMITSN("  ;_UNSTACKING_");
    fprintf(this->out_fp, "%s\n",
        "  ld   ra, 56(sp) ; ra is 8bytes(64bits)\n"      
        "  ld   s0, 48(sp) ; s0 is 8bytes(64bits)\n"          
        "  addi sp, sp, 64\n"    
        "  jr   ra        "              
    );
    fprintf(this->out_fp, "%s%s%s%s\n",
        "  .size ",_lable_name.c_str(),", .-",_lable_name.c_str()
    );
    EMITSN("");

    this->offset_up_64bit();
    this->offset_up_64bit();
}

int CodeGenerator::new_label(){
    this->label++;
    return this->label;
}

void CodeGenerator::specify_label_on(int _label){
    this->is_specify_label = true;
    this->specify_label = _label;
}

void CodeGenerator::specify_label_off(){
    this->is_specify_label = false;
}

string CodeGenerator::get_specify_label(){
    return string("L")+to_string(this->specify_label);
}

string CodeGenerator::label_convert(int _label){
    return string("L")+to_string(_label);
}
#include "semantic/SymbolTable.hpp"
#include "semantic/DumpSymbolTable.hpp"

Attribute::Attribute() { this->attr_type = AttributeType::UNKNOWN_ATTRIBUTE; }

Attribute::Attribute(AttributeType _attr_type) { this->attr_type = _attr_type; }

Attribute::Attribute(vector<VariableInfo> _parameters) {
    this->parameter_type = _parameters;
    this->attr_type = AttributeType::ATTRIBUTE_PARAMETERS;
}

Attribute::Attribute(VariableInfo _value) {
    this->value_of_constant = _value;
    this->attr_type = AttributeType::ATTRIBUTE_VALUE_OF_CONSTANT;
}

void Attribute::set_parameter_type(vector<VariableInfo> _parameters) {
    this->parameter_type = _parameters;
    this->attr_type = AttributeType::ATTRIBUTE_PARAMETERS;
}

void Attribute::set_value_of_constant(VariableInfo _value) {
    this->value_of_constant = _value;
    this->attr_type = AttributeType::ATTRIBUTE_VALUE_OF_CONSTANT;
}

SymbolEntry::SymbolEntry() {
    this->kind = FieldKind::KIND_UNKNOWN;
    this->is_used = false;
}

SymbolEntry::SymbolEntry(string _name, FieldKind _kind, unsigned int _level,
                         VariableInfo _type, Attribute _attribute,
                         enum EnumNodeTable _node_type,
                         class ProgramNode *_program_node,
                         class VariableNode *_variable_node,
                         class FunctionNode *_function_node) {
    this->name = name_cut(_name);
    this->kind = _kind;
    this->level = _level;
    this->type = _type;
    this->attribute = _attribute;
    this->node_type = _node_type;
    this->program_node = _program_node;
    this->variable_node = _variable_node;
    this->function_node = _function_node;

    this->is_used = true;
    this->is_arr_decl_error = false;

    this->address_offset = 0;
}

void SymbolEntry::set_address_offset(int _offset){
    this->address_offset = _offset;
}

SymbolTable::SymbolTable(unsigned int _level) {
    this->prev_scope = NULL;
    this->in_node_type = EnumNodeTable::UNKNOWN_NODE;
    this->in_node_return_type = VariableInfo(EnumTypeSet::UNKNOWN_SET, EnumType::UNKNOWN_TYPE);
    this->next_scope_list.clear();
    this->next_scope_cur_idx = -1;

    this->level = _level;
    this->entry.clear();
    this->entry_name.clear();
}

SymbolTable::~SymbolTable() {
    for (uint i = 0; i < this->next_scope_list.size(); i++) {
        SAFE_DELETE(this->next_scope_list[i])
    }
}

void SymbolTable::put(SymbolEntry _symbol_entry) {
    this->entry[_symbol_entry.name] = _symbol_entry;
    this->entry_name.push_back(_symbol_entry.name);
}

// Check the Variable is Redeclared Before
// false -> redeclare happen
bool SymbolTable::redeclare_check(string _name) {
    if (_name.length() > 32)
        _name = _name.substr(0, 32);
    if (this->entry[_name].is_used == true) {
        return false;
    } else {
        return true;
    }
}

void SymbolTable::next_scope_cur_idx_increase(){
    this->next_scope_cur_idx++;
}

SymbolTable* SymbolTable::get_next_scope(){
    // Start by -1
    this->next_scope_cur_idx_increase();
    return this->next_scope_list[this->next_scope_cur_idx];
}

SymbolTable* SymbolTable::get_parent_scope(){
    return this->prev_scope;
}
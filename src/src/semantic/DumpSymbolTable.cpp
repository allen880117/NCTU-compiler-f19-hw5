#include "semantic/DumpSymbolTable.hpp"
#include <cstdio>
#include <iomanip>
#include <iostream>
using namespace std;

string name_cut(string _name) {
    if (_name.length() > 32)
        return _name.substr(0, 32);
    else
        return _name;
}

// true -> two type are same
bool array_size_check(VariableInfo lhs, VariableInfo rhs) {
    if (lhs.type_set == rhs.type_set) {
        if (lhs.type == rhs.type) {
            if (lhs.array_range.size() == rhs.array_range.size()) {
                for (uint i = 0; i < lhs.array_range.size(); i++) {
                    int lhs_size = (int)lhs.array_range[i].end -
                                   (int)lhs.array_range[i].start;
                    int rhs_size = (int)rhs.array_range[i].end -
                                   (int)rhs.array_range[i].start;
                    if (lhs_size != rhs_size)
                        return false;
                }
                return true;
            }
        }
    }
    return false;
}

// false -> error has happened
bool fault_type_check(VariableInfo input) {
    if (input.type_set == EnumTypeSet::UNKNOWN_SET || input.type == EnumType::UNKNOWN_TYPE)
        return false;
    else
        return true;
}

string op_convert(enum EnumOperator op) {
    string temp = "";
    switch (op) {
    case EnumOperator::OP_OR:
        temp = "or";
        break;
    case EnumOperator::OP_AND:
        temp = "and";
        break;
    case EnumOperator::OP_NOT:
        temp = "not";
        break;
    case EnumOperator::OP_LESS:
        temp = "<";
        break;
    case EnumOperator::OP_LESS_OR_EQUAL:
        temp = "<=";
        break;
    case EnumOperator::OP_EQUAL:
        temp = "=";
        break;
    case EnumOperator::OP_GREATER:
        temp = ">";
        break;
    case EnumOperator::OP_GREATER_OR_EQUAL:
        temp = ">=";
        break;
    case EnumOperator::OP_NOT_EQUAL:
        temp = "<>";
        break;
    case EnumOperator::OP_PLUS:
        temp = "+";
        break;
    case EnumOperator::OP_MINUS:
        temp = "-";
        break;
    case EnumOperator::OP_MULTIPLY:
        temp = "*";
        break;
    case EnumOperator::OP_DIVIDE:
        temp = "/";
        break;
    case EnumOperator::OP_MOD:
        temp = "mod";
        break;
    default:
        temp = "unknown";
        break;
    }
    return temp;
}

string info_convert(VariableInfo input) {
    string msg = "";
    switch (input.type_set) {
    case EnumTypeSet::SET_SCALAR:
    case EnumTypeSet::SET_CONSTANT_LITERAL:
        switch (input.type) {
        case EnumType::TYPE_INTEGER:
            msg = "integer";
            break;
        case EnumType::TYPE_REAL:
            msg = "real";
            break;
        case EnumType::TYPE_STRING:
            msg = "string";
            break;
        case EnumType::TYPE_BOOLEAN:
            msg = "boolean";
            break;
        case EnumType::TYPE_VOID:
            msg = "void";
            break;
        default:
            msg = "unknown";
            break;
        }
        break;
    case EnumTypeSet::SET_ACCUMLATED:
        switch (input.type) {
        case EnumType::TYPE_INTEGER:
            msg = "integer";
            break;
        case EnumType::TYPE_REAL:
            msg = "real";
            break;
        case EnumType::TYPE_STRING:
            msg = "string";
            break;
        case EnumType::TYPE_BOOLEAN:
            msg = "boolean";
            break;
        case EnumType::TYPE_VOID:
            msg = "void";
            break;
        default:
            msg = "unknown";
            break;
        }
        msg += " ";
        for (uint i = 0; i < input.array_range.size(); i++) {
            msg += "[";
            msg += to_string((int)input.array_range[i].end -
                             (int)input.array_range[i].start);
            msg += "]";
        }
        break;
    case EnumTypeSet::UNKNOWN_SET:
        switch (input.type) {
        case EnumType::TYPE_VOID:
            msg = "void";
            break;
        default:
            msg = "unknown";
            break;
        }
        break;
    default:
        msg = "unknown";
        break;
    }
    return msg;
}

void dumpDemarcation(const char chr) {
    for (size_t i = 0; i < 110; ++i) {
        cout << chr;
    }
    cout << endl;
}

void dumpSymbol_Header() {
    dumpDemarcation('=');
    printf("%-33s%-11s%-11s%-17s%-11s\n", "Name", "Kind", "Level", "Type",
           "Attribute");
    dumpDemarcation('-');
}

void dumpSymbol_Body(SymbolEntry symbol_entry) {
    cout << std::right << std::left << setw(33) << symbol_entry.name;

    switch (symbol_entry.kind) {
    case FieldKind::KIND_PROGRAM:
        cout << std::right << std::left << setw(11) << "program";
        break;
    case FieldKind::KIND_FUNCTION:
        cout << std::right << std::left << setw(11) << "function";
        break;
    case FieldKind::KIND_PARAMETER:
        cout << std::right << std::left << setw(11) << "parameter";
        break;
    case FieldKind::KIND_VARIABLE:
        cout << std::right << std::left << setw(11) << "variable";
        break;
    case FieldKind::KIND_LOOP_VAR:
        cout << std::right << std::left << setw(11) << "loop_var";
        break;
    case FieldKind::KIND_CONSTANT:
        cout << std::right << std::left << setw(11) << "constant";
        break;
    default:
        cout << std::right << std::left << setw(33) << "unknown";
        break;
    }

    switch (symbol_entry.level) {
    case 0:
        cout << std::right << 0 << std::left << setw(10) << "(global)";
        break;
    default:
        cout << std::right << symbol_entry.level << std::left << setw(10)
             << "(local)";
        break;
    }

    cout << std::right << std::left << setw(17)
         << info_convert(symbol_entry.type);

    string msg = "";
    switch (symbol_entry.attribute.attr_type) {
    case AttributeType::ATTRIBUTE_PARAMETERS:
        for (uint i = 0; i < symbol_entry.attribute.parameter_type.size();
             i++) {
            if (i != 0)
                msg += ", ";
            msg += info_convert(symbol_entry.attribute.parameter_type[i]);
        }
        cout << std::right << std::left << setw(11) << msg;
        break;
    case AttributeType::ATTRIBUTE_VALUE_OF_CONSTANT:
        switch (symbol_entry.attribute.value_of_constant.type) {
        case EnumType::TYPE_INTEGER:
            std::cout << std::right << std::left << setw(11)
                      << symbol_entry.attribute.value_of_constant.int_literal;
            break;
        case EnumType::TYPE_REAL:
            std::cout << std::right << std::left << setw(11) << fixed
                      << setprecision(6)
                      << symbol_entry.attribute.value_of_constant.real_literal;
            break;
        case EnumType::TYPE_STRING:
            std::cout
                << std::right << std::left << setw(11)
                << "\"" +
                       symbol_entry.attribute.value_of_constant.string_literal +
                       "\"";
            break;
        case EnumType::TYPE_BOOLEAN:
            switch (symbol_entry.attribute.value_of_constant.boolean_literal) {
            case Boolean_TRUE:
                std::cout << std::right << std::left << setw(11) << "true";
                break;
            case Boolean_FALSE:
                std::cout << std::right << std::left << setw(11) << "false";
                break;
            default:
                std::cout << std::right << std::left << setw(11) << "unknown";
                break;
            }
            break;
        default:
            std::cout << std::right << std::left << setw(11) << "unknown";
            break;
        }
        break;
    case AttributeType::NO_ATTRIBUTE:
    case AttributeType::UNKNOWN_ATTRIBUTE:
    default:
        break;
    }

    cout << std::right << endl;
}

void dumpSymbol_Bottom() { dumpDemarcation('-'); }

//&S-
//&T-
//&D-

Array;

var gd: array 1 to 4 of array 2 to 5 of integer;


gg(tt:array 2 to 4 of integer): integer;
begin
    tt[3] := gd[2][3];
    return tt[3];
end
end gg

begin

var inner: array 3 to 5 of integer;

read inner[3];
print inner[3];


gd[2][3] := 7;
gd[1][2] := 8;
gd[3][4] := 9;
print gg(inner);
print gd[2][3];
print gd[1][2];
print gd[3][4];

end
end Array

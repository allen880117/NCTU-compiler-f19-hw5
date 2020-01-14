//&S-
//&T-
//&D-

bool;

var gar:array 2 to 4 of boolean;
var gd:boolean;
var jj:true;

botest(tt:boolean): integer;
begin
    if (tt) then
        return 3;
    else
        return 2;
    end if
end
end botest

arrtest(tt:array 0 to 2 of boolean): integer;
begin
    tt[1] := true;
    if tt[0] and tt[1] then
        return 1719; 
    else 
        return 1555;
    end if
end
end arrtest


begin

var lar:array 3 to 5 of  boolean;
var kk:boolean;
var pk:boolean;
var ck:true;
var dk:false;

gd := false;

if not jj then
    print 32; // NOT PRINT
else 
    print 33;
end if

if not gd then
    print 22;
else
    print 121; // NOT PRINT
end if

if not ( gd and jj ) then
    print 55; 
else
    print 21; // NOT PRINT
end if

if gd or jj then
    print 56;
else
    print 17; // NOT PRINT
end if

kk := true;
pk := false;

if kk and ck then
    print 77;
end if

if kk and pk then
    print 78; // NOT PRINT
end if

print botest(ck); // 3
print botest(dk); // 2

lar[3] := true;
print arrtest(lar);
gar[2] := true;
print arrtest(gar);
gar[2] := false;
print arrtest(gar);

if lar[4] then
    print 1;
end if

if not gar[3] then
    print 3;
end if

end
end bool

// PRINT
// 33
// 22
// 55
// 56
// 77
// 3
// 2
// 1719
// 1719
// 1555
// 1

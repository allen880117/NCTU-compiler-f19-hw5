//&S-
//&T-
//&D-

bool;

var gd:boolean;
var jj:true;

begin

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

end
end bool

// PRINT
// 33
// 22
// 55
// 56
// 77

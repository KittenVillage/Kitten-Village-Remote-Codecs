function rotate(r,g) 
local ng={{},{},{},{},{},{},{},{}} 
local rx=0
for ve=1,8 do for ho=1,8 do 
	if r==2 then
		ng[ve][ho]=g[ho][9-ve] -- 1cw
	elseif r==3 then
		ng[ve][ho]=g[9-ve][9-ho] --2cw
	elseif r==4 then
		ng[ve][ho]=g[9-ho][ve] --3cw
	elseif r>4 and r<9 then
		ng[ve][ho]=g[9-ve][ho] --flip v
	elseif r>8 and r<13 then 
		ng[ve][ho]=g[ve][9-ho] --flip h
	elseif r>12 and r<17 then 
		ng[ve][ho]=g[ho][ve] -- flip v and h
	else
		ng[ve][ho]=g[ve][ho] -- no change 1 or gt 16
	end
end end
if r>5 and r<9 then -- 6,7,8 flip h then rot
	rx=r-4
elseif r>9 and r<13 then -- 10,11,12 flip v then rot
	rx=r-8
elseif r>13 and r<17 then -- 14,15,16 flip h and v then rot
	rx=r-12
end
if rx > 0 then
	ng=rotate(rx,ng)
end
--error(gridprint(gridprint('\nrotate '..r,g),ng))
return ng end

function gridprint(strng,grid)
	local a='\n'
	for xxx=1,8 do
		a=table.concat(grid[xxx],",") .. '\n' .. a
	end
	a=strng..'\n'..a
	return a..'\n'
end
test={{},{},{},{},{},{},{},{}}
for ve=1,8 do for ho=1,8 do 
test[ve][ho]=ho+(10*ve)
end end
print(gridprint("default",test))
print(gridprint("1",rotate(1,test)))
print(gridprint("2 1cw",rotate(2,test)))
print(gridprint("3 2cw",rotate(3,test)))
print(gridprint("4 3cw",rotate(4,test)))
print(gridprint("5 fv",rotate(5,test)))
print(gridprint("6 fv 1cw",rotate(6,test)))
print(gridprint("7 fv 2cw",rotate(7,test)))
print(gridprint("8 fv 3cw",rotate(8,test)))
print(gridprint("9 fh ",rotate(9,test)))
print(gridprint("10 fh 1cw",rotate(10,test)))
print(gridprint("11 fh 2cw",rotate(11,test)))
print(gridprint("12 fh 3cw",rotate(12,test)))
print(gridprint("13 fhv",rotate(13,test)))
print(gridprint("14 fhv 1cw",rotate(14,test)))
print(gridprint("15 fhv 2cw",rotate(15,test)))
print(gridprint("16 fhv 3cw",rotate(16,test)))
print(gridprint("17",rotate(17,test)))

for o = 1,16 do for i = 1,16 do
local otest={}
local itest={}
 otest=rotate(o,test)
 itest=rotate(i,test)
local check=false
for ve=1,8 do  
if table.concat(otest[ve])==table.concat(itest[ve]) then
check=true
end
end
if check==true and o~=i then print(o.." is the same as "..i) end
end end














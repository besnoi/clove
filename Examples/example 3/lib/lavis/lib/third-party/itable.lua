--[[
	iTable Library for Lua/Love2D
	By Neer (https://github.com/YoungNeer/) and Chris H. (https://github.com/Pyutaro)
	:-A very very simple library but can be very useful.
	By default Lua doesn't support many table operations even important ones such
	as indexOf and slice, etc. So this library is to fill that gap. 
	Just require it and then u can use table.indexOf/table.firstIndexOf,table.slice,etc...
	
	P.S. : Note that most of the functions here will work only with tables as arrays (those working with all types of table will have a *generic* written above) and i guess
	that's why they dont have these functions in the standard table library - cause they are not generic enough.
	(i.e. these functions wont work with hashtables or associative arrays -- name's same)
	But most luaites use tables as array, so this library should prove useful I believe
]]


--[[
	Asserts the type of a given variable.
	So that you get the power of what happens when a table is nil
	(sometimes you don't want any reaction so simply have an empty return statement in the body)
	Arguments:
	- (any) var
	- (string) fncname - used for error messages.
	- (string) [_type] = "table" - Type to compare var to.
]]
local function assertType(var,fncname,_type)
	_type = _type or "table"
	assert(type(var)==_type,("Oops! %s expected in table.%s, got '%s'"):format(_type,fncname,type(var)))	
end

--[[
	Finds the first instance of an element in a given array.
	Arguments:
	- (table) tbl
	- (any) element
	Returns: int? index (nil if not found)
]]
function table.firstIndexOf(tbl,element)
	assertType(tbl,"firstIndexOf")
	for i,el in ipairs(tbl) do
		if el==element then return i end
	end
end

-- Alias of firstIndexOf
table.indexOf = table.firstIndexOf

--[[
	Finds the last index of an element in a given array.
	Arguments:
	- (table) tbl
	- (any) element
	Returns: int? index (nil if not found)
]]
function table.lastIndexOf(tbl,element)
	local tbl_size = #tbl
	assertType(tbl,"lastIndexOf")
	for i=#tbl,1,-1 do
		if tbl[i]==element then return i end
	end
end

--[[
	Finds whether a given element exists in a table or not.
	Arguments:
	- (table) tbl
	- (any) element
]]
function table.exists(tbl, element)
	return (table.indexOf(tbl,element) ~= nil)
end

--[[
	Returns the maximum element of an array
	Arguments:
	- (table) tbl (must be linear array of numbers)
]]
function table.max(tbl)
	assertType(tbl,"max")
	local max=tbl[1]
	for i=2,#tbl do if tbl[i]>max then max=tbl[i] end end
	return max
end

--[[
	Returns the minimum element of an array
	Arguments:
	- (table) tbl (must be linear array of numbers)
]]
function table.min(tbl)
	assertType(tbl,"min")
	local min=tbl[1]
	for i=2,#tbl do if tbl[i]<min then min=tbl[i] end end
	return min
end

--[[
	Returns a copy of the given table rather than reference
	Arguments:
	- (table) srcTbl
]]

function table.copy(srcTbl)
	local destTbl,el={}
	for i in pairs(srcTbl) do
		if type(srcTbl[i])~='table' then
			destTbl[i]=srcTbl[i]
		else
			destTbl[i]=table.copy(srcTbl[i])
		end
	end
	return destTbl
end

--[[
	Returns a range of numbers in the form of table
	Arguments:
	- (int) [from] = 1
	- (int) [to] = (no default value)
	- (int) [skip] = 1
	See ReadMe for possible overloads
]]

function table.range(from,to,skip)
	skip=skip or 1
	if not to then from,to=1,from end
	local tbl={}
	for i=from,to,skip do  table.insert(tbl,i) end
	return tbl
end

--[[
	Removes all the occurences of an element in table (in-place doesn't return)
	Arguments:
	- (table) tbl (table)
	- (int) el (element)
]]

function table.removeAll(tbl,el)
	assertType(tbl,"removeAll")
	local removetbl,count={},0
	for i=1,#tbl do if tbl[i]==el then table.insert(removetbl,i) end end
	for i=1,#removetbl do table.remove(tbl,removetbl[i]-count) count=count+1 end
end

--[[
	Removes only the duplicates of an element in table (in-place doesn't return)
	Arguments:
	- (table) tbl (table)
	- (int) el (element)
]]

function table.removeDuplicates(tbl,el)
	assertType(tbl,"removeDuplicates")
	local pos=table.indexOf(tbl,el)
	table.removeAll(tbl,el)
	table.insert(tbl,pos,el)
end

--[[
	Removes all the duplicate elements from a table (NOT in-place)
	Arguments:
	- (table) tbl
]]

function table.removeAllDuplicates(tbl)
	assertType(tbl,"removeAllDuplicates")
	local hashtable={}
	local result={}
	for i=1,#tbl do
		if not hashtable[tbl[i]] then
			table.insert(result,tbl[i])
			hashtable[tbl[i]]=true
		end
	end
	return result
end


--[[
	Gets a random element in a table (trivial yet useful)
	Arguments:
	-(table) tbl
]]

function table.random(tbl)
	assertType(tbl,'random')
	return tbl[math.random(#tbl)]
end

--[[
	Shuffles the provided table (in-place: shuffles the original table)
	Arguments:
	- (table) tbl
]]

function table.mix(tbl)
	local j
	for i=1,#tbl do
		j=math.random(#tbl)
		tbl[i],tbl[j]=tbl[j],tbl[i]
	end
end

--[[
	Shuffles the provided table (not in-place: returns the shuffled table)
	Arguments:
	- (table) tbl
 ]]

function table.shuffle(tbl)
	local tmp=table.copy(tbl)
	table.mix(tmp)
	return tmp
end

--[[
	Reverses the provided table (in-place: doesn't return anything)
	Arguments:
	- (table) tbl
--]]

function table.reverse(tbl)
	assertType(tbl,"reverse")
	local i,j=1,#tbl
	while i<j do
		arr[i],arr[j]=arr[j],arr[i]
		i,j=i+1,j-1
	end
end

--[[
	Returns a subset of a table.
	Arguments:
	- (table) tbl
	- (int) [first] = 1
	- (int) [last] = #tbl
	- (int) [skip] = 1
        Note skip is most of the time useless but sometimes (really) you want to set value another than one - to skip some elements periodically
	See the Readme file for more details.
	Returns: (table) subset
]]
function table.slice(tbl, first, last, skip)
    assertType(tbl,"slice")	
    local sliced = {}
    for i = first or 1, last or #tbl, skip or 1 do
      sliced[#sliced+1] = tbl[i]
    end
    return sliced
end

-- Alias of table.slice
table.subset = table.slice

--[[
	Pushes every vararg to the end of an array.
	Arguments:
	- (table) tbl
	- (any) varargs...
]]
function table.append(tbl,...)
	assertType(tbl,"append")
	for _,i in ipairs{...} do
		tbl[#tbl+1]=i
	end
end

--[[
	Merges tables with the first table.
	Arguments:
	- (table) tbl
	- (table) varargs...
]]
function table.merge(tbl,...)
	assertType(tbl,"merge")
	for _,i in ipairs{...} do
		if type(i)=='table' then 
			for _,j in ipairs(i) do
				tbl[#tbl+1]=j
			end
		end
	end
end

--[[
	Sets key-value pairs in the first table using the other tables.
	Different from table.merge in the sense that it supports hashtables.
	Arguments:
	- (table) tbl
	- (table) varargs...
]]
function table.join(tbl,...)
	assertType(tbl,"join")
	for _,i in pairs{...} do
		if type(i)=='table' then 
			for k,j in pairs(i) do
				tbl[k]=j
			end
		end
	end
end

--[[
	Divides a table into an array of subsets. (Each subset containing less than or n number of elements) of the original table.concat
	E.g. if tbl={1,2,3,4,5} then subdivide(tbl,2) will return {{1,2},{['3']=3,['4']=4},{['5']=5}}
	and if tbl={['a']=5,['b']=6,c=8} then subdivide(tbl,1) will return {{['a']=5},{['b']=6},{['c']=8}}
	Arguments:
	- (table) tbl
	- (int) n
	Returns:
	- (table) array
	- (int) index
]]
function table.subdivide(tbl,n)
	assertType(tbl,"subdivide")
	local array,index,i={},1,1
	for key,value in pairs(tbl) do
		if i==n+1 then i=1 index=index+1 end
		if not array[index] then array[index]={} end
		array[index][key]=value
		i=i+1
	end
	return array,index
end

--[[
	Unlike table.subdivide, divide works only on arrays. It differs from subdivide only in one aspect here illustrated by eg
	e.g. if tbl={1,2,3,4,5} then subdivide(tbl,2) will return {{1,2},{['3']=3,['4']=4},{['5']=5}}
	but divide(tbl,2) will return {{1,2},{3,4},{5,6}}
	Arguments:
	- (table) tbl
	- (int) n
	Returns:
	- (table) array
	- (int) index
]]
function table.divide(tbl,n)
	assertType(tbl,"divide")	
	local array,index,i={},1,1
	for key,value in ipairs(tbl) do
		if i==n+1 then i=1 index=index+1 end
		if not array[index] then array[index]={} end
		array[index][i]=value
		i=i+1
	end
	return array,index
end

--[[
	table.sort except it returns a new table without modifying the original.
	Arguments:
	- (table) tbl
	- (function?) funcn
	Returns: (table) sorted_table
]]
function table.isort(tbl,funcn)
	assertType(tbl,'isort')
	local tmp=table.copy(tbl)
	table.sort(tmp,funcn)
	return tmp
end



--[[
	Clove  : A generous LÖVE library using which you can easily (super-easily) loads huge amount of assets.
	Author: Neer
	(https://github.com/YoungNeer/clove)
]]

local clove={}
local delim=package.config:sub(1,1) --path delimiter: '/' or '\'

local imgExt={"png","jpg","gif","jpeg","tga","bmp"}
local fontExt={"ttf","otf"}
local audioExt={"mp3","wav","midi","ogg"}
local vidExt={"vid"} --since ogg is reserved for audio

local allExt={"png","jpg","ttf","ogg","mp3","wav","otf","midi","jpeg","bmp","gif","vid"}

local function isAFile(url)
	return love.filesystem.getInfo(url).type=="file"
end

local function lastIndexOf(str,char)
	for i=str:len(),1,-1 do if str:sub(i,i)==char then return i end end
end

local function removeExtension(filename)
	return filename:sub(1,lastIndexOf(filename,".")-1)
end

local function getExtension(filename)
	return filename:sub((lastIndexOf(filename,".") or filename:len()) +1)
end

--[[ the next two functions borrowed from itable library's
     table.join and table.exist with some slight modification
]]
local function mergeTables(tbl1,...)
	for _,i in ipairs({...}) do
		for k,j in pairs(i) do tbl1[k]=j end
	end
end

local function existsInList(tbl,element)
	for i,el in ipairs(tbl) do if el==element then return true end end
	return false
end

--[[
	clove.loadAsset:-
	    Description: Loads an asset automatically. You specify the URL and it would detect
	    what type of asset it is and then return it after loading

	    Parameters:
		  url         - the URL of the asset (string)
]]
function clove.loadAsset(url,...)

	assert(url,"Clove can't load the Asset! It is nil")
	local filetype=getExtension(url)

	if existsInList(imgExt,filetype) then
		return love.graphics.newImage(url,...)
		
	elseif existsInList(audioExt,filetype) then
		return love.audio.newSource(url,... or 'static')

	elseif existsInList(fontExt,filetype) then
		return love.graphics.newFont(url,...)

	
	elseif existsInList(vidExt,filetype) then
		return love.graphics.newVideo(url,...)

	else
		--[[
			Here clove will try to help the programmer if he forgets the extension- eg. "hello" 
			- if it doesn't exist - will be mapped to hello.png - if hello.png exists.
			And BTW this has no effect if you are using clove.load since the flow would
			never reach here (cause the file will exist).
		]]
		for i=1,#allExt do
			if love.filesystem.getInfo(url..'.'..allExt[i]) then
				if love.filesystem.getInfo(url..'.'..allExt[i]).type=="file" then
					return clove.loadAsset(url..'.'..allExt[i],...)
				end
			end
		end

		-- a message just to inform the programmer
		print("Sorry, Clove couldn't load the asset :(")
	end
end

--[[clove.requireLib:- (The Master Function for requiring Library)
	
	    Description: Loads all the libraries in the path (except those defined by `except`) 
					 and (depending on `simple`) either adds it to a hashtable (which it returns)
					 with the filenames as the key (custom key could be used with the help of `rename`)
					 or simply requires the library thus avoiding allocation of any extra memory

	    Parameters:
	      path         - the directory to look up for modules (with .lua extension) (string)
	      recurse      - whether to keep looking for modules in the sub-directories (bool)
	      rename       - a function which takes in a filename and returns the key string
	      except       - a function which takes in a filename and returns a boolean
						 for whether the asset should be added or not
		  simple       - if the library is a simple one which doesn't return something.
						 In case it does then it will create and return a table of libraries
						 Otherwise no memory is created and nothing is returned

	    Please note that only the path argument is mandatory- and please check
	    if filenames are not same when recursively adding files.
	    See ReadMe.md for more info on the possible problems with recurse (when simple is false)
]]

function clove.requireLib(path,recurse,rename,except,simple)

	assert(love.filesystem.getInfo(path),"Clove Error! Directory '"..path.."' doesn't exist!")

	local libTbl={}

	local dir=love.filesystem.getDirectoryItems(path)

	rename=rename or removeExtension
	except=except or function() return false end

	for _,file in ipairs(dir) do
		if isAFile(path..delim..file) then
			if getExtension(file)=="lua" and not except(file) then
				if simple then
					require(path..delim..removeExtension(file))
				else
					libTbl[rename(file)]=require(path..delim..removeExtension(file))
				end
			end
		else
			if recurse then
				mergeTables(
					libTbl,
					clove.requireLib(path..delim..file,recurse,rename,except,simple)
				)
			end
		end
	end
	return libTbl
end

function clove.require(path,recurse,except)
	clove.requireLib(path,recurse,nil,except,true)
end


--[[
	clove.load:- (The Master Function for importing assets)
	
	    Description: Loads all the assets in the path (except those defined by `except`) 
	    			 and adds it to a hashtable (which it returns) with the filenames 
	    			 as the key (custom key could be used with the help of `rename`).

	    Parameters:
	      assetType    - a table which consists of the filetype of the asset to load
	    				 (eg. {'png','jpg'} for images and {'mp3'} for audio you could possibly
	    				 even mix assets like {'ttf','ogg'})
	      path         - the directory to look up for images (string)
	      recurse      - whether to keep looking for images in the sub-directories (bool)
	      rename       - a function which takes in a filename and returns the key string
	      except       - a function which takes in a filename and returns a boolean
						 for whether the asset should be added or not
		  ....         - varargs for more control (eg. loading fonts with size 18,etc)

	    Please note that only the type & path argument is mandatory- and please check
	    if filenames are not same when recursively adding files.
	    See ReadMe.md for more info on the possible problems with recurse
]]
function clove.load(assetType,path,recurse,rename,except,...)

	assert(love.filesystem.getInfo(path),"Clove Error! Directory '"..path.."' doesn't exist!")

	recurse=recurse or false
	rename=rename or removeExtension
	except=except or function() return false end
	
	local dir,assetTbl=love.filesystem.getDirectoryItems(path),{}

	for i=1,#dir do
		if isAFile(path..delim..dir[i]) then

			if not except(dir[i]) and existsInList(assetType,getExtension(dir[i])) then
				assetTbl[rename(dir[i])]=clove.loadAsset(path..delim..dir[i],...)
			end
			
		else
			if recurse then
				mergeTables(
					assetTbl,
					clove.load(assetType,path..delim..dir[i],recurse,rename,except,...)
				)
			end
		end
	end

	return assetTbl
end

function clove.loadFonts(...) return clove.load(fontExt,...) end

function clove.loadSounds(...) return clove.load(audioExt,...) end

function clove.loadImages(...) return clove.load(imgExt,...) end

function clove.loadVideos(...) return clove.load(vidExt,...) end

function clove.loadAll(...)
	local tbl={}
	mergeTables(
		tbl,
		clove.loadFonts(...),
		clove.loadSounds(...),
		clove.loadImages(...),
		clove.loadVideos(...)
	)
	return tbl
end


clove.import=clove.load
clove.importAsset=clove.loadAsset
clove.importAll=clove.loadAll
clove.importFonts=clove.loadFonts
clove.importGraphics=clove.loadImages
clove.importAudio=clove.loadSounds
clove.importVideo=clove.loadVideos
clove.loadAudio=clove.loadSounds
clove.loadSprites=clove.loadImages

return clove

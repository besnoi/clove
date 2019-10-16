# The Clove Library for LÖVE

Clove is a useful LÖVE library using which you can easily (super-easily) loads huge amount of assets.
It also makes the process of requiring libraries super-easy. So two birds with one shot- libraries and assets!
And please note here asset means "images,fonts,sounds and videos"

## Table Of Contents

- [How to use Clove for asset loading?](#how-to-use-clove)
	- [A quick walkthrough](#a-quick-walkthrough)
	- [Load an arbitrary asset using Clove](#load-an-arbitrary-asset)	    
	- [Load up all the assets at once](#load-up-all-the-assets-at-once)
	- [Load specific type of assets](#load-specific-type-of-assets)
	- [The Master Function for importing Assets](#the-master-function-for-importing-assets)
- [How to use Clove for requiring libraries?](#how-to-use-clove-for-requiring-libraries)
	- [Requiring Packages](#Requiring-packages)
	- [Requiring Modules](#Requiring-modules)
	- [Requiring both modules and packages](#Requiring-both-modules-and-packages)
- [Debugging](#Debugging)
- [Auto-Correction Ability](#auto-correction-ability)
- [Aliases used in Clove](#aliases-used-in-clove)
- [Caveats](#caveats)

## How to use Clove?

So how to use clove? First of all, since it's a module, require it:-
```lua
	clove=require 'clove'
```
Before we start looking at each function individually let's have a walkthrough of Clove - so you'd appreciate its capabilities and perhaps realise its limitations.

### A Quick Wakthrough

Let's for context say you want to create a typing game and you have a folder with the following sprites:-

<p align="center">
	<img src="Images/img_keyboard.png" width=440 height=245/><br/>
	<span style="align:center">Your folder of images (Credit- <a href="https://gameartguppy.com">GameArt Guppy</a>)</span>
</p>


So basically every file is named in the format "A.png", "B.png" and so on..

Now how would you load all this? Individually, right. Assuming you want all of them in a well organized format you would do something like this:-
```lua
	keyboardImages={}
	keyboardImages['a']=love.graphics.newImage("assets/a.png")
	-- ... and so on
```
And that would be **27 lines of code!!** just to load the assets But with Clove all you would do is:-

```lua
	keyboardImages=clove.importImages("assets")
```

And *that's it*!!! __27 lines of code versus 1 line of clove__. Which is better? You decide

#### Quick FAQ

Some questions to clear the doubt before you move on-

**Q. But what if you had a spritesheet and not individiual images?**

Ans. There's no way for clove to know if the image is an atlas. Well presence of a metafile by the same name can be an indicator but then clove can't load the metafile. You got to use either [iffy](https://github.com/YoungNeer/iffy) or [animX](https://github.com/YoungNeer/animX)!

**Q. What if I don't want a table but rather global assets which i can access individually?**

Ans. Hmm...let me see can you do that in Clove..? Well- turns out - *you could*!! Head over to [Load up all the assets at once](#Load up all the assets at once).

### Load an arbitrary asset

Clove can even load an arbitrary asset- meaning you can load an individual asset without having to know what type of asset it is. An example might do good here:-

```lua
	asset=clove.loadAsset("audio.ogg")
```

And that would be the exact same as saying:-
```lua
	asset=love.audio.newSource("audio.ogg","static")
```

Now which one's better - you decide. 

> Now I'd like to point out here that `clove.importAsset` which is really just an alias of `clove.loadAsset`. For more information see [Aliases used in Clove](#aliases-in-clove)

Now let's get into detail. `clove.loadAsset` actually takes in *a number of* parameters, first ofcourse the URL of the asset and the rest are optional varargs. These varargs are plugged in the load function directly so if you wanted "stream" source instead of "static" then you just have to do this:-

```lua
	asset=clove.loadAsset("audio.ogg","stream") --same as the next line of code
	asset=love.audio.newSource("audio.ogg","stream")
```

And just to very clear here. It's not just for audio but for any type of asset - image, font, whatever. So for example the next two lines of code does the same thing

```lua
	font=clove.loadAsset("Kenney Mini",45)
	font=love.graphics.newFont("Kenney Mini.ttf",45)
```

And yes that's not a typo - you could write "font" instead of "font.ttf" or "font.otf" and that'd be just thing - just note one thing that there's a priority list - like png then jpg then ttf, *et cetera, et cetera* (look at source FMI).

### Load up all the assets at once

`clove.importAll()` will load up all the assets from images to sound to font to videos - everything will be imported and wrapped up in a table that it's gonna return.

Let's start with a simple example.

Let's say you have a directory structure like this:-


<img src="Images/img_asset.png" width=214 height=300/><br/>

You bet with such a complicated directory structure (directories within directories and their long and unfriendly names) importing the assets manually is really going to be a pain in the neck but with Clove it's not-
```lua
	clove.importAll('assets',true,_G)
```

And really that's it. For proof-of-concept, here's the entire code from [example 2](https://github.com/YoungNeer/lovelib/clove/blob/master/Examples/example%202)
```lua
clove=require 'clove'

clove.importAll("assets",true,_G)
ready:play()

function love.draw()
	love.graphics.draw(mountain_range)

	love.graphics.setFont(Kenney_Mini)
	love.graphics.print("Hello World")
end
```

You may already have realised from where these keys come from. They are just the extension removed version of the filename and also note the spaces are converted into underscores (this is only because we passed in ``_G``). Now let's understand what we did-

We first required clove which is trivial and then we used the importAll function and passed the path where all our assets reside (you could see the directory structure for proof) and in the second parameter we passed in true. We'll get to this in a moment but what this does is bascially says to clove- "Hey Clove check for assets in the sub-directories as well" and clove does just that. You must be careful when setting it to true because filenames could be same and if the are then the asset that was loaded first will *not* be overwritten by the one that was loaded later, instead the original one will remain intact and new one will vanish into space - and you bet it *may* cause problems. So please check if asset names are not the same *in any directory*, also if you are passing ``_G`` then make sure the asset name is not something like 'jit.mp3','rawset.png',etc

Now let's look at the function prototype of `clove.importAll`:- (ignore what's under <>)

```html
<table> clove.importAll(<string> path, <boolean> recurse, <table> tbl, <function> rename, <function> except, <function> param )
```

Let's break down what each parameter means:-

 Parameter Name| Description
---------------|------------------
    path       | the directory to look up for images, note that *its the only                  mandatory argument*
	recurse    | whether to keep looking for images in the sub-directories
	tbl        | all assets will go in this table
	rename     | a function which takes in a filename and returns the key string
	except     | a function which takes in a filename and returns a boolean for               whether the asset should be added or not
	param      | a function which returns the parameters to pass in when loading              a particular asset (useful when loading fonts of specific size)


Now many other functions like `clove.importImages`,`clove.importFonts`,etc are going to follow the same modus operandi so let's take a close hard-look at the parameters.

`path` and `recurse` are trivial. The param section simply returns the parameters when an asset is loaded (see [this](#load-an-arbitrary-asset) section FMI). So the odd-ones are perhaps `tbl` and `rename` and `except`

`tbl` is nothing but the table you want to add the assets to! If you pass in `_G` then that's going to create *global assets*, it is `{}` by default!

If you remember from [example 2](https://github.com/YoungNeer/lovelib/clove/blob/master/Examples/example%202), the key-names were not exactly the filenames. For instance for asset `grass.png` the key would be `grass`. And if you wish you could make the key identical to the filename - just pass in an empty function as the third parameter! So basically the default value for `rename` is a function which takes in a filename and returns filename minus the extension *if `tbl` is nil*. If it's not then it also replaces spaces with underscores and also wordifies the filename (basically following the rules of naming an identifier - since you could have global assets by passing `_G`).

Now for context let's say you have assets - with everything in weird case (like "aNImAge.pNg") so accessing keys like `gImages['aNImAge']` is going to be very difficult and so you want all in lower-case. Well the way you'd do it is very simple. Just make a function that takes in a string and returns the lower-case of it and pass that function as `rename` i.e. as the third parameter and that'd do the task. Just for proof-of-concept here's what it would look like:- 

```lua
	gImages=clove.importAll(
		"images", -- assuming path is "images"
		false,    -- assuming we only want the images in the main directory
		nil,      -- an empty table would also work in *this* case
		function(filename) return filename:reverse() end
	)
```

Now you may access the image like `gImages['animage']` instead of `gImages['aNImAGE']` (*assuming the filename is aNImAGE and not aNImAGE.png - since we didn't remove the extension from the file) And if you want `gImages['anImage']` then you'll perhaps have to get particular - like checking if the file name is 'aNImAGE' and then returning 'anImage' if it is. Hope you get the idea.

Before we move on to `except` I'd like to point out the problem with the default rename method- By default as you know it removes the extension from the file-name making it more easier to type. But this could cause problems in some cases- let's say you have two files 'grass.png' and grass.jpg'. With the default rename function you will have either one of these files mapped on to the 'grass' key - meaning you would *lose* assets these way. So the solution to this - if you think it's a problem - is: simply pass in an empty function in `rename`. That way you'll have a unique key - 'grass.png' and 'grass.jpg' in our context.

Now about `except` - by default it's an empty function which returns *false* in all cases. Basically this decides which file should be included and which shouldn't be. Say you want 'grass.png' (and all other images) but you donot want 'background.png' then what you migh do is return true if the file name (BTW if i didn't already mention it - the function takes in a filename as an argument similar to `rename` callback function) is "background.png" and return *false* in all other cases. And note false means that the file *will be included* because as the name of the parameter suggests - include all files `except` *this* one. A proof-of-concept might make things easier

```lua
	clove.importAll(
		"images",
		false,
		nil,  -- default value for tbl
		nil,  -- use the default function for rename
		function(filename) return filename=="background.png" and true or false end
	)
```

### Load specific type of assets

So `clove.importAll` imports all types of assets - but what if you wanted only images, or only sounds - a specific type of asset in general. Worry not you have a bunch of functions that work the same as `clove.importAll` only difference being what's already stated here. So in a quick glance the functions are:-

```lua
clove.importFonts()     -- loads fonts only
clove.importGraphics()  -- loads images only
clove.importAudio()     -- loads sounds only
clove.importVideo()     -- loads videos only
```

> A note here that they have the exact same parameters as `clove.importAll`

### The Master Function for importing Assets

"Okay so I could load images and graphics specifically - but what if I wanted to load specific formats like png, ogg, ttf etc?" Well one way is that you would work around with the except parameter in either `clove.importAll` or the specific ones (and combine them). But that's a lot of work- so a quick solution to this is - *use the master function* - `clove.load` which takes in one extra parameter and that being the filetypes. This parameter is the first parameter and so the other parameters are shifted by one. A proof-of-concept is mandatory here I guess:-

```lua
	assets=clove.load({"png","jpg","ttf"},"assets")  -- assets is the main directory
```

Now `assets` table contains the images with the file-format "png" or "jpg" as well as fonts of the format "ttf".

> Please note that only those extensions are supported which are supported by LÖVE for eg. gif is supported but svg is not

## How to use Clove for requiring libraries?

Until now we have been loading assets but Clove is not all about that. It can also make the process of requiring modules (and even packages) easier. And we'll just see how

### Requiring Packages

Packages are groups of [modules](#requiring-modules). You'll know in a moment why we are learning about packages first and not modules. So anyways here's the prototype

```html
	<table> clove.requirePackage(<string> path, <table> tbl, <function> except)
```

So `path` is the path the packages are in - it's cumplusory that you pass in a valid path! The second argument is `tbl` which is not mandatory but if you want globals then you can pass in `_G`. The `except` parameter is a function which tells Clove whether or not should a package be included! It is also not mandatory.

Let's for context say you have a GUI library and the themes are stored as packages much like in LoveFrames. So what you could do is simply say-

```lua
	loveFrames[themes]=clove.requirePackage('themes')
	--for context
	setTheme(loveFrames[theme][grey])
```

### Requiring modules

Modules are simply single-file libraries and you require them by their names (unlike packages which are required by their containing folder name). Now modules can be of two types- returning and non-returning. An example of non-returning library is [iTable](https://github.com/YoungNeer/lovelib/blob/master/itable) created by yours truly. The newer version of Clove loads both type of libraries smartly. If it's returning then require it and add what's returned to the table that it'll return or that's being passed to it (just like before). If it's not returning like iTable then just require it!

```lua
	clove.requireLib('lib')  -- please note here that lib is a directory of libraries
```

Here's the prototype:-

```html
<table> clove.requireLib(<string> path, <boolean> recurse, <table> tbl, <function> rename, <function> except)
```

> Note that the `except` parameter works exactly as `clove.importAll` and `recurse` too is the same

An interesting fact to note is that this function doesn't require packages. And if some module is *inside a package* then also it won't require it (even if `recurse` is set to true) It has simply been assumed that you will never want to require internal modules

Let's see an example:-

```lua
	clove.requireLib('lib',true,_G)
	--for context
	hump=Class() --lib.hump.Class
	timer.after(1,function() print('lib.knife.timer is required') end)
```

### Requiring both modules and packages

You could require both libraries and packages at one go using `require`  :-

```html
	<table> clove.require(<string> path, <boolean> recurse, <table> tbl, <function> except)
```

So much like [`clove.requirePackage`](#Requiring-Packages) except that now you have an extra `recurse` parameter. This is for modules (like `class.lua` is inside `hump`) but packages will be unaffected by that (since packages have their own folder and *very* rarely would you find a package within a package unless it's used internally for that particular package)

We'll see an example of this function in the next section

Before we end this section this is the actual prototype for `clove.requireLib`:-

```html
<table> clove.requireLib(<string> p, <boolean> p, <table> t, <function> r, e, <boolean> isPackage, <string> dT)
```

> Some parameter names are reduced to their initials so that you don't see that ugly scrollbar!

So from where came this `isPackage` and `dT`?. `isPackage` when true loads only packages non-recursively and when false loads only modules recursively/non-recursively depending on `recurse`. So `clove.requirePackage` is just a subset of `clove.requireLib` and `clove.require` simply calls `clove.requireLib` two times with alternating `isPackage`. So in that sense `clove.requireLib` is the master function for loading libraries just like [`clove.load`](#the-master-function-for-importing-assets) is the master function for loading assets! Oh! and about `dT` well - it stands for *debugTab*. It is meant to be used internally. So don't worry about it!

## Debugging

What if a library couldn't by loaded because it was inside a package or because it *was* a package? What if a library wasn't loaded To clear your doubts you can turn on debugging feature which will beautifully print all the notes/warnings/errors for you. Just say `clove.debug=true` before you begin. Here's an example:-

```lua
clove=require 'clove'
clove.debug=true
clove.require("lib",true,_G)
print(hello_world)
print(lavis,flux,class,timer,chain)
```

And the following result will be printed
```
----------DEBUG INFORMATION----------
[NOTE: 'lib/flux' is ignored (as it's a package)]
[+] Recursing.. lib/hump
	Loaded module class (lib/hump/class) ...
[+] Recursing.. lib/knife
	Loaded module chain (lib/knife/chain) ...
	Loaded module timer (lib/knife/timer) ...
[NOTE: 'lib/lavis' is ignored (as it's a package)]
[+] Recursing.. lib/sub
	[+] Recursing.. lib/sub/more
		Loaded module hello_world (lib/sub/more/hello world) ...
----------DEBUG INFORMATION----------
Loaded package lib/flux...
[NOTE: lib/lavis is a non-returning package]
hello world
table: 0x40540820	table: 0x4101c050	table: 0x41011260	table: 0x41017390	function: 0x41012888
```

Note that at first we get the message that `flux` is not loaded, then we get the message that it is loaded. This is because under the hood it first requires modules and then packages.

Also note that `hello world.lua` is renamed to `hello_world`!

## Auto-correction Ability 

I wanted to keep this seperate but since I talked about it in the ending of the [this](#load-an-arbitrary-asset) section so please look up there. Sorry for being lazy

## Aliases in Clove

Well I wanted to make it a detailed section but since I dont' have much time as of now I can only copy-paste from the source

```lua
	clove.import=clove.load
	clove.importAsset=clove.loadAsset
	clove.importAll=clove.loadAll
	clove.importFonts=clove.loadFonts
	clove.importGraphics=clove.loadImages
	clove.importAudio=clove.loadSounds
	clove.loadAudio=clove.loadSounds
	clove.loadSprites=clove.loadImages
```

## Caveats

You can't load image font in Clove!! Infact I don't even recommend using clove to load fonts unless size doesn't matter to you. Cause then you'd have to use the `param` function. If all fonts are going to have the same size then `param` function can simply return that size and in other cases things are going to be bit messy with all those branches and stuff going on... Also in case of fonts you might have to change the `rename` function since the fonts name would be something like `orbiton.ttf` and you'd want `scoreFont.ttf`,etc and ofcourse many fonts would map to the same file!
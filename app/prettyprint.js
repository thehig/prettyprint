var hljs = require('highlight.js');
var promise = require('promise');
var walk = require('walk');
var _ = require('underscore');
var fs = require('fs');
var read = promise.denodeify(fs.readFile);

prettyprint = {
	utilities: {

		endsWith: function(str, suffix) {
    		return str.indexOf(suffix, str.length - suffix.length) !== -1;
    	},
    	debug: false,
    	log: function(string){
    		if(prettyprint.utilities.debug) console.log(string);
    	}
	}, //utilities

	scan: function(options){
		endsWith = prettyprint.utilities.endsWith;
		log = prettyprint.utilities.log;

		if(!options) throw new Error('Required parameter: options');
		if(!options.directory) throw new Error('Missing parameter: directory');

		var workingdirectory, absolutedirectory;
		var cwd = process.cwd();

		if(options.directory.indexOf(cwd) > -1){
			absolutedirectory = options.directory.replace(/\\/g, "/");
			// strip the CWD and add a .
			workingdirectory = '.' + absolutedirectory.substr(cwd.length, absolutedirectory.length).replace(/\\/g, "/");
		}
		else
		{
			//this is a relative URI
			workingdirectory = options.directory.replace(/\\/g, "/");		// replace \\ with /
			
			//add leading . if necessary
			if(workingdirectory[0] !== '.'){
				// add leading / if necessary
				if(workingdirectory[0] !== '/') workingdirectory = '/' + workingdirectory;
				workingdirectory = '.' + workingdirectory;
			}

			absolutedirectory = cwd + workingdirectory.substring(1, workingdirectory.length);
		}

		if(endsWith(workingdirectory, '/')) workingdirectory = workingdirectory.substring(0, workingdirectory.length - 1);

		return new promise(function(success, error){
			var files = [],
				walker = walk.walk(workingdirectory, { followLinks: false }),
				pushfile = function(root, stat){
					// log("root: " + JSON.stringify(root));
					// log("stat: " + JSON.stringify(stat));

					folder = root.replace(/\\/g, "/") + "/";
					abs = cwd.replace(/\\/g, "/") + folder.substring(1, folder.length);

					log("abs: " + abs);

					files.push({
						filename: stat.name,
						relativepath: folder,
						absolutepath: abs
					});
				};


			walker.on('file', function(root, stat, next) {

				// if patterns were provided, check the filename to see if any of the extensions match
				// patterns are just the file extensions (lazy), and this code checks to see if the filename ends with the extension			
				if(options.patterns){
					for(var i = 0; i < options.patterns.length; i++)
					{
						if(endsWith(stat.name.toLowerCase(), options.patterns[i].toLowerCase())){
							pushfile(root, stat);
							break;
						}
					}
					
				}else{
					// given no patterns, just get all the files
					pushfile(root, stat);
				}
			    
			    next();
			});

			walker.on('end', function() {
				// when the walker is done walking the structure, we call our promise success callback
				success({
					workingdirectory: workingdirectory,
					absolutedirectory: absolutedirectory,
					files: files
				});
			});

		});
	}, //scan
	load: function (options){
		log = prettyprint.utilities.log;
		if(!options) throw new Error('Required parameter');
		if(!options.workingdirectory) throw new Error('Missing parameter: workingdirectory');
		var filelist = options.files;
		
		if(!filelist) throw new Error('Missing parameter: files');
		if(!Array.isArray(filelist)) throw new Error('Invalid parameter: files is not an array');
		if(filelist.length === 0) throw new Error('Invalid parameter: files is empty array');

		var readPromises = [];
		_.each(filelist, function(item){
			if(!item.filename) throw new Error('File parameter missing: filename');
			if(!item.relativepath) throw new Error('File parameter missing: relativepath');
			if(!item.absolutepath) throw new Error('File parameter missing: absolutepath');

			readPromises.push(read(item.relativepath + item.filename, "utf-8").then(function(str){
				item.content = str;
				return item;
			}));
		});

		return promise.all(readPromises).then(function (filelist){
			return {
				workingdirectory: options.workingdirectory,
				absolutedirectory: options.absolutedirectory,
				files: filelist
			}
		});
	}, //load
	highlight: function(options){
		log = prettyprint.utilities.log;
		if(!options) throw new Error('Required parameter: options');
		if(!options.workingdirectory) throw new Error('Missing parameter: workingdirectory');

		var filelist = options.files;

		if(!filelist) throw new Error('Missing parameter: files');
		if(!Array.isArray(filelist)) throw new Error('Invalid parameter: files is not an array');
		if(filelist.length === 0) throw new Error('Invalid parameter: files is empty array');

		var highlightPromises = [];
		_.each(filelist, function(item){
			if(!item.filename) throw new Error('File parameter missing: filename');
			if(!item.relativepath) throw new Error('File parameter missing: relativepath');
			if(!item.absolutepath) throw new Error('File parameter missing: absolutepath');
			if(!item.content) throw new Error('File parameter missing: content');

			highlightPromises.push(new promise(function(success, error){
				item.highlight = hljs.highlightAuto(item.content);
				item.output = hljs.fixMarkup(item.highlight.value);
				success(item);
			}));
		});

		return promise.all(highlightPromises).then(function (filelist){
			return {
				workingdirectory: options.workingdirectory,
				absolutedirectory: options.absolutedirectory,
				files: filelist
			}
		});
	}, //highlight
	output: function(filelist){
		log = prettyprint.utilities.log;

		if(!filelist) throw new Error('Required parameter: filelist');
		if(!Array.isArray(filelist)) throw new Error('Invalid parameter: filelist not an array');
		if(filelist.length === 0) throw new Error('Invalid parameter: filelist is empty array');

		_.each(filelist, function(item){
			if(!item.filename) throw new Error('File parameter missing: filename');
			if(!item.relativepath) throw new Error('File parameter missing: relativepath');
			if(!item.absolutepath) throw new Error('File parameter missing: absolutepath');
			if(!item.content) throw new Error('File parameter missing: content');
			if(!item.highlight) throw new Error('File parameter missing: highlight');

		});
	} //output
};

module.exports = prettyprint;
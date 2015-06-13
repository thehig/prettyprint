var hljs = require('highlight.js');
var promise = require('promise');
var walk = require('walk');
var _ = require('underscore');

prettyprint = {
	utilities: {
		endsWith: function(str, suffix) {
    		return str.indexOf(suffix, str.length - suffix.length) !== -1;
    	},
    	debug: false,
    	log: function(string){
    		if(prettyprint.utilities.debug) console.log(string);
    	}
	},

	scan: function(options){
		endsWith = prettyprint.utilities.endsWith;
		log = prettyprint.utilities.log;

		if(!options) throw new Error('Required parameter: options');
		if(!options.directory) throw new Error('Missing parameter: directory');

		var workingdirectory, absolutedirectory;
		var cwd = process.cwd();

		if(options.directory.indexOf(cwd) > -1){
			absolutedirectory = options.directory;
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
		}
		
		return new promise(function(success, error){
			var files = [],
				walker = walk.walk(workingdirectory, { followLinks: false }),
				pushfile = function(root, stat){
					log("root: " + JSON.stringify(root));
					log("stat: " + JSON.stringify(stat));

					files.push({
						filename: stat.name,
						relativepath: root,
						absolutepath: ""
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
					files: files
				});
			});

		});
	}
};

module.exports = prettyprint;
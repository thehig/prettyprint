var hljs = require('highlight.js');
var P = require('promise');
var walk = require('walk');
var _ = require('underscore');

function endsWith(str, suffix) {
    return str.indexOf(suffix, str.length - suffix.length) !== -1;
}

module.exports = {

	scan: function(options){

		if(!options) throw new Error('Required parameter: options');
		if(!options.directory) throw new Error('Missing parameter: directory');

		var workingdirectory = options.directory;


		if(workingdirectory.indexOf(process.cwd()) > -1){
			// strip the absolute url from the working directory
			workingdirectory = workingdirectory.substr(process.cwd().length, workingdirectory.length);
		}


		return new P(function(success, error){
			var files = [],
				walker = walk.walk(workingdirectory, { followLinks: false }),
				pushfile = function(root, stat){
					console.log("root: " + JSON.stringify(root));
					console.log("stat: " + JSON.stringify(stat));

					files.push({
						filename: stat.name,
						relativepath: root,
						absolutepath: ""
					});
				}


			walker.on('file', function(root, stat, next) {

				// if patterns were provided, check the filename to see if any of the extensions match
				// patterns are just the extensions, and this code checks to see if the filename ends with the extension			
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
				success({
					workingdirectory: workingdirectory,
					files: files
				});
			});

		});
	}
};
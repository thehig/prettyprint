var http = require('http');
var _ = require('underscore');
var prettyprint = require('./prettyprint');
var hljs = require('highlight.js');

// Stylesheets: 
//	highlightjs official repo 	- 	"https://github.com/isagalaev/highlight.js/tree/master/src/styles"
//  highlightjs default css 	- 	"//cdnjs.cloudflare.com/ajax/libs/highlight.js/8.6/styles/default.min.css"
//  3rd party highlightjs skins -	"//jmblog.github.io/color-themes-for-highlightjs/css/themes/tomorrow.css"


var port = 1337;
var highlightJsSkins = ["agate", "androidstudio", "arta", "ascetic", "atelier-cave.dark", "atelier-cave.light", "atelier-dune.dark", "atelier-dune.light", "atelier-estuary.dark", "atelier-estuary.light", "atelier-forest.dark", "atelier-forest.light", "atelier-heath.dark", "atelier-heath.light", "atelier-lakeside.dark", "atelier-lakeside.light", "atelier-plateau.dark", "atelier-plateau.light", "atelier-savanna.dark", "atelier-savanna.light", "atelier-seaside.dark", "atelier-seaside.light", "atelier-sulphurpool.dark", "atelier-sulphurpool.light", "brown_paper", "codepen-embed", "color-brewer", "dark", "darkula", "default", "docco", "far", "foundation", "github-gist", "github", "googlecode", "hybrid", "idea", "ir_black", "kimbie.dark", "kimbie.light", "magula", "mono-blue", "monokai", "monokai_sublime", "obsidian", "paraiso.dark", "paraiso.light", "pojoaque", "railscasts", "rainbow", "school_book", "solarized_dark", "solarized_light", "sunburst", "tomorrow-night-blue", "tomorrow-night-bright", "tomorrow-night-eighties", "tomorrow-night", "tomorrow", "vs", "xcode", "zenburn"];
var stylesheet = highlightJsSkins[60]; //vs


ppConfig = {
	directory: "./app",
	patterns: ["js"]
};

// hljs.configure({
// 	tabReplace: '   '
// });

prettyprint.scan(ppConfig).then(prettyprint.load).then(prettyprint.highlight).done(function(data){		
	http.createServer(function (req, res) {
		// write the opening html and stylesheet
		res.write('<html><head><link type="text/css" rel="stylesheet" href="https://raw.githubusercontent.com/isagalaev/highlight.js/master/src/styles/' + stylesheet + '.css"></link></head><body>');

		// write each highlighted code chunk into its own "<div><pre class='hljs'>"
		_.each(data.files, function(file){
			res.write('<div> <h2>'+ file.filename + "</h2><br><pre class='hljs'>" + file.output + '</pre></div>');
		});

		//write the html closers
		res.end('</body></html>');
	}).listen(port);	
	console.log("Server running on port: " + port);	
});

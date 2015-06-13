var http = require('http');
var _ = require('underscore');
var prettyprint = require('./prettyprint')
var hljs = require('highlight.js');

// Stylesheets: https://github.com/isagalaev/highlight.js/tree/master/src/styles
// var stylesheet = "//cdnjs.cloudflare.com/ajax/libs/highlight.js/8.6/styles/default.min.css"
var directoryToScan = "./app";
var fileTypesToShow = ["js"]
var stylesheet = "https://raw.githubusercontent.com/isagalaev/highlight.js/master/src/styles/vs.css";
// var stylesheet = "//jmblog.github.io/color-themes-for-highlightjs/css/themes/tomorrow.css"

// hljs.configure({
// 	tabReplace: '   '
// });

prettyprint
	.scan({directory:directoryToScan, patterns: fileTypesToShow})
	.then(prettyprint.load)
	.then(prettyprint.highlight)
	.done(function(data){		
		console.log("starting server");
		
		http.createServer(function (req, res) {
			res.write('<html><head><link rel="stylesheet" href="' + stylesheet + '"></head><body>');
			// res.write('<html><head><style>' + stylesheet + '</style></head><body>');
			_.each(data.files, function(file){
				res.write('<div> <h2>'+ file.filename + "</h2><br><pre class='hljs'>" + file.output + '</pre></div>');
			});
			res.end('</body></html>');
		}).listen(1337);		
	})

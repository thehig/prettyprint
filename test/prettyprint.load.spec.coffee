prettyprint = require('../app/prettyprint')
load = prettyprint.load

mocha = require('mocha')
chai = require('chai')
chai.use(require('chai-as-promised')) # allows us to use 'eventually' to assert against promise results without expressly resolving the promise manually
expect = chai.expect

exampleFileList = {
	"workingdirectory": "./test/fixtures",
	"files": [{
		"filename": "1.js",
		"relativepath": "./test/fixtures/countfiles/fivefiles/one/",
		"absolutepath": "C:/Users/David/Documents/GitHub/prettyprint/test/fixtures/countfiles/fivefiles/one/"
	}, {
		"filename": "2.js",
		"relativepath": "./test/fixtures/countfiles/fivefiles/four/",
		"absolutepath": "C:/Users/David/Documents/GitHub/prettyprint/test/fixtures/countfiles/fivefiles/four/"
	}, {
		"filename": "3.css",
		"relativepath": "./test/fixtures/countfiles/fivefiles/four/",
		"absolutepath": "C:/Users/David/Documents/GitHub/prettyprint/test/fixtures/countfiles/fivefiles/four/"
	}, {
		"filename": "4.html",
		"relativepath": "./test/fixtures/countfiles/fivefiles/four/",
		"absolutepath": "C:/Users/David/Documents/GitHub/prettyprint/test/fixtures/countfiles/fivefiles/four/"
	}, {
		"filename": "5.js",
		"relativepath": "./test/fixtures/countfiles/fivefiles/four/",
		"absolutepath": "C:/Users/David/Documents/GitHub/prettyprint/test/fixtures/countfiles/fivefiles/four/"
	}]
}

dummyobject = {filename: 'aaa', relativepath: 'bbb', absolutepath: 'ccc'};

describe "loading the files", ->
	describe "parameters", ->
		it "should throw an error given no parameter", -> expect(-> load()).to.throw(/Required parameter/)
		it "should throw an error given no directory parameter", -> expect(-> load({})).to.throw(/Missing parameter: workingdirectory/)
		it "should throw an error given no files parameter", -> expect(-> load({workingdirectory: "aaa"})).to.throw(/Missing parameter: files/)
		it "should throw an error given empty files array", -> expect(-> load({workingdirectory: "aaa", files: []})).to.throw(/Invalid parameter: files is empty/)
		it "should throw an error given non-array files", -> expect(-> load({workingdirectory: "aaa", files: {}})).to.throw(/Invalid parameter: files is not an array/)

		it "should throw an error if any filename is missing", -> expect(-> load({workingdirectory: "aaa", files: [dummyobject, {absolutepath: "bbb", relativepath: "ccc"}]})).to.throw(/missing: filename/)
		it "should throw an error if any absolutepath is missing", -> expect(-> load({workingdirectory: "aaa", files: [{filename: "aaa", relativepath: "ccc"}]})).to.throw(/missing: absolutepath/)
		it "should throw an error if any relativepath is missing", -> expect(-> load({workingdirectory: "aaa", files: [dummyobject, {filename: "aaa", absolutepath: "bbb"}, dummyobject, dummyobject]})).to.throw(/missing: relativepath/)

	describe "reading the files", ->
		it "should take an array as parameter and return a promise", ->
			promise = load({workingdirectory: "aaa", files:[dummyobject]})
			expect(promise).to.have.property('then')
			expect(promise).to.have.property('done')

		it "should be able to read the CSS file", (done)->
			load({workingdirectory: "aaa", files:[exampleFileList.files[2]]}).done (data) ->
				expect(data.files[0]).to.have.property('content', 'body { background-color: #b0c4de; }')
				done()
		it "should be able to read multiple files", (done)->
			load(exampleFileList).done (data) ->			
				expect(data.files[2]).to.have.property('content', 'body { background-color: #b0c4de; }')
				expect(data.files[1]).to.have.property('content', '(function(){})();')
				done()

		it.only "should have multiple lines in 5.js", (done)->
			load({workingdirectory: "aaa", files:[exampleFileList.files[4]]}).done (data) ->
				expect(data.files[0]).to.have.property('content', 'body { background-color: #b0c4de; }')
				done()
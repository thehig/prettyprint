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
		it "should throw an error if no parameter provided", -> expect( -> load() ).to.throw(/Required parameter/)
		it "should throw an error if an empty parameter is provided", -> expect( -> load([]) ).to.throw(/empty array/)
		it "should throw an error if an invalid parameter is provided", -> expect( -> load("something") ).to.throw(/not an array/)
		it "should throw an error if the filename is missing", -> expect( -> load([{}]) ).to.throw(/missing: filename/)
		it "should throw an error if any filename is missing", -> expect( -> load([dummyobject, {absolutepath: "bbb", relativepath: "ccc"}]) ).to.throw(/missing: filename/)
		it "should throw an error if any absolutepath is missing", -> expect( -> load([{filename: "aaa", relativepath: "ccc"}]) ).to.throw(/missing: absolutepath/)
		it "should throw an error if any relativepath is missing", -> expect( -> load([dummyobject, {filename: "aaa", absolutepath: "bbb"}, dummyobject, dummyobject]) ).to.throw(/missing: relativepath/)

	describe "reading the files", ->
		it "should take an array as parameter and return a promise", ->
			promise = load([dummyobject])
			expect(promise).to.have.property('then')
			expect(promise).to.have.property('done')

		it "should be able to read the CSS file", (done)->
			load([exampleFileList.files[2]]).done (data) ->
				expect(data[0]).to.have.property('content', 'body { background-color: #b0c4de; }')
				done()
		it "should be able to read multiple files", (done)->
			load(exampleFileList.files).done (data) ->			
				expect(data[2]).to.have.property('content', 'body { background-color: #b0c4de; }')
				expect(data[1]).to.have.property('content', '(function(){})();')
				done()
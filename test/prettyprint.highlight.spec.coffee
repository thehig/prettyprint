prettyprint = require('../app/prettyprint')
highlight = prettyprint.highlight

mocha = require('mocha')
chai = require('chai')
chai.use(require('chai-as-promised')) # allows us to use 'eventually' to assert against promise results without expressly resolving the promise manually
expect = chai.expect

exampleFileContents = {
	"workingdirectory": "./test/fixtures",
	"files": [{
		"filename": "1.js",
		"relativepath": "./test/fixtures/countfiles/fivefiles/one/",
		"absolutepath": "C:/Users/David/Documents/GitHub/prettyprint/test/fixtures/countfiles/fivefiles/one/",
		"content": ""
	}, {
		"filename": "2.js",
		"relativepath": "./test/fixtures/countfiles/fivefiles/four/",
		"absolutepath": "C:/Users/David/Documents/GitHub/prettyprint/test/fixtures/countfiles/fivefiles/four/",
		"content": "(function(){})();"
	}, {
		"filename": "3.css",
		"relativepath": "./test/fixtures/countfiles/fivefiles/four/",
		"absolutepath": "C:/Users/David/Documents/GitHub/prettyprint/test/fixtures/countfiles/fivefiles/four/",
		"content": "body { background-color: #b0c4de; }"
	}, {
		"filename": "4.html",
		"relativepath": "./test/fixtures/countfiles/fivefiles/four/",
		"absolutepath": "C:/Users/David/Documents/GitHub/prettyprint/test/fixtures/countfiles/fivefiles/four/",
		"content": ""
	}, {
		"filename": "5.js",
		"relativepath": "./test/fixtures/countfiles/fivefiles/four/",
		"absolutepath": "C:/Users/David/Documents/GitHub/prettyprint/test/fixtures/countfiles/fivefiles/four/",
		"content": ""
	}]
}

dummyobject = {filename: 'aaa', relativepath: 'bbb', absolutepath: 'ccc', content: 'ddd'};


describe "highlighting the files", ->
	describe "parameters", ->
		it "should throw an error if no parameter provided", -> expect( -> highlight() ).to.throw(/Required parameter/)
		it "should throw an error if an empty parameter is provided", -> expect( -> highlight([]) ).to.throw(/empty array/)
		it "should throw an error if an invalid parameter is provided", -> expect( -> highlight("something") ).to.throw(/not an array/)
		it "should throw an error if the filename is missing", -> expect( -> highlight([{}]) ).to.throw(/missing: filename/)
		it "should throw an error if any filename is missing", -> expect( -> highlight([dummyobject, {absolutepath: "bbb", relativepath: "ccc"}]) ).to.throw(/missing: filename/)
		it "should throw an error if any absolutepath is missing", -> expect( -> highlight([{filename: "aaa", relativepath: "ccc"}]) ).to.throw(/missing: absolutepath/)
		it "should throw an error if any relativepath is missing", -> expect( -> highlight([dummyobject, {filename: "aaa", absolutepath: "bbb"}, dummyobject, dummyobject]) ).to.throw(/missing: relativepath/)
		it "should throw an error if any content is missing", -> expect( -> highlight([dummyobject, {filename: "aaa", absolutepath: "bbb", relativepath: "ccc"}, dummyobject, dummyobject]) ).to.throw(/missing: content/)

	describe "highlight content", ->
		it "should return a promise", ->
			prm = highlight([exampleFileContents.files[1]])
			expect(prm).to.have.property('then')
			expect(prm).to.have.property('done')

		it "should highlight the content", (done)->
			highlight([exampleFileContents.files[1]]).done (data)->
				expect(data[0].highlight).to.have.property('value', '<span class="hljs-list">(<span class="hljs-keyword">function</span><span class="hljs-list">()</span><span class="hljs-collection">{}</span>)</span><span class="hljs-list">()</span><span class="hljs-comment">;</span>')
				done()

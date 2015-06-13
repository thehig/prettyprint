prettyprint = require('../app/prettyprint')
output = prettyprint.output

mocha = require('mocha')
chai = require('chai')
chai.use(require('chai-as-promised')) # allows us to use 'eventually' to assert against promise results without expressly resolving the promise manually
expect = chai.expect

dummyobject = {filename: 'aaa', relativepath: 'bbb', absolutepath: 'ccc', content: 'ddd', highlight: 'eee'};

describe "outputting to html", ->
	describe "parameters", ->
		it "should throw an error if no parameter provided", -> expect( -> output() ).to.throw(/Required parameter/)
		it "should throw an error if an empty parameter is provided", -> expect( -> output([]) ).to.throw(/empty array/)
		it "should throw an error if an invalid parameter is provided", -> expect( -> output("something") ).to.throw(/not an array/)
		it "should throw an error if the filename is missing", -> expect( -> output([{}]) ).to.throw(/missing: filename/)
		it "should throw an error if any filename is missing", -> expect( -> output([dummyobject, {absolutepath: "bbb", relativepath: "ccc"}]) ).to.throw(/missing: filename/)
		it "should throw an error if any absolutepath is missing", -> expect( -> output([{filename: "aaa", relativepath: "ccc"}]) ).to.throw(/missing: absolutepath/)
		it "should throw an error if any relativepath is missing", -> expect( -> output([dummyobject, {filename: "aaa", absolutepath: "bbb"}, dummyobject, dummyobject]) ).to.throw(/missing: relativepath/)
		it "should throw an error if any content is missing", -> expect( -> output([dummyobject, {filename: "aaa", absolutepath: "bbb", relativepath: "ccc"}, dummyobject, dummyobject]) ).to.throw(/missing: content/)
		it "should throw an error if any highlight is missing", -> expect( -> output([dummyobject, {filename: "aaa", absolutepath: "bbb", relativepath: "ccc", content: "ddd"}, dummyobject, dummyobject]) ).to.throw(/missing: highlight/)

	# describe "output content", ->
	# 	it "should return a promise", ->
	# 		prm = output([exampleFileContents.files[1]])
	# 		expect(prm).to.have.property('then')
	# 		expect(prm).to.have.property('done')
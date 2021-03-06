prettyprint = require('../app/prettyprint')

mocha = require('mocha')
chai = require('chai')
expect = chai.expect

nope = expect.fail	# shorthand for scaffolding failing tests

describe "the mocha and chai testing frameworks", ->
	it "should have Mocha", -> expect(mocha).to.exist
	it "should have Chai", -> expect(chai).to.exist
	it "should pass basic assertations", -> expect(true).to.equal(true, "How did you even get here?")


describe "uncategorised", ->

	describe.skip "preparing output", ->
		it "should create a html output file", -> nope()
		it "should create a html output file with a new name if it already exists", -> nope()
		it "should output the css for the highlightjs selected syntax", -> nope()

	describe.skip "mapping the data", ->
		it "should prepare a list of files", -> nope()
		it "should highlight each of the files in turn", -> nope()
		it "should write each highlighted piece of code into the output file", -> nope()
		it "should try and close files ASAP to minimize locking", -> nope()
		it "should try not to hold code chunks in memory for efficiency", -> nope()

	describe.skip "dumping the gathered files", ->
		it "should insert each relative file name into the html document", -> nope()
		it "should insert .. the code from the file", -> nope()
		it "should open the file in the browser", -> nope()

	describe.skip "optional niceties", ->
		describe "frontend", ->
			it "could have a UI/frontend", -> nope()
			it "could have some options for selecting which highlight format you want", -> nope()
			it "could attempt to match the rest of the page with your highlight format", -> nope()

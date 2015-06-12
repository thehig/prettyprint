mocha = require('mocha')
chai = require('chai')
expect = chai.expect

describe "the mocha, chai and chai testing frameworks", ->
	it "should have Mocha", -> expect(mocha).to.exist
	it "should have Chai", -> expect(chai).to.exist
	it "should pass basic assertations", -> expect(true).to.equal(true, "How did you even get here?")
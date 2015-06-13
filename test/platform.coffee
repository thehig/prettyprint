prettyprint = require('../app/prettyprint')

mocha = require('mocha')
chai = require('chai')
expect = chai.expect

nope = expect.fail	# shorthand for scaffolding failing tests

describe "the mocha and chai testing frameworks", ->
	it "should have Mocha", -> expect(mocha).to.exist
	it "should have Chai", -> expect(chai).to.exist
	it "should pass basic assertations", -> expect(true).to.equal(true, "How did you even get here?")

describe "scan", ->
	it "should throw an error given no parameter", -> expect(-> prettyprint.scan()).to.throw(/Required parameter/)
	it "should throw an error given no directory parameter", -> expect(-> prettyprint.scan({})).to.throw(/Missing parameter/)
	it "should take an absolute URI as parameter", (done) -> 
		targetDirectory = process.cwd() + "\\test\\fixtures"

		prettyprint.scan({directory: targetDirectory}).done (result)-> 
			expect(result.workingdirectory).to.equal('\\test\\fixtures')
			done()
	it "should take a relative URI as parameter", (done)->
		prettyprint.scan({directory: './test/fixtures'}).done (result)-> 
			expect(result.workingdirectory).to.equal('./test/fixtures')
			done()
	it.skip "should allow for selection of highlightjs syntax formatting", -> nope()

describe "gathering files", ->
	it "should count the number of files in a folder", (done)-> 
		prettyprint.scan({directory: './test/fixtures/countfiles/fivefiles/four'}).done (result)-> 
			expect(result.files).to.have.length(4)
			done()
	it "should count .. recursively", (done)-> 
		prettyprint.scan({directory: './test/fixtures/countfiles/fivefiles/'}).done (result)-> 
			expect(result.files).to.have.length(5)
			done()
	it "should count .. recursively that match a pattern", (done)-> 
		prettyprint.scan({
			directory: './test/fixtures/countfiles/fivefiles/',
			patterns: ['js']
		}).done (result)-> 
			expect(result.files).to.have.length(3)
			done()
	it "should count .. recursively that match one of multple patterns", (done)->
		prettyprint.scan({
			directory: './test/fixtures/countfiles/fivefiles/',
			patterns: ['js', 'css']
		}).done (result)-> 
			expect(result.files).to.have.length(4)
			done()
	it "should not matter if the pattern is upper or lower case", (done)->
		prettyprint.scan({
			directory: './test/fixtures/countfiles/fivefiles/',
			patterns: ['JS', 'CsS']
		}).done (result)-> 
			expect(result.files).to.have.length(4)
			done()
	it.skip "should retain a filename relative to the starting path", -> nope()

describe.only "each file", ->
	source = undefined;

	beforeEach (done)->
		prettyprint.scan({directory: './test/fixtures/countfiles/fivefiles/four'}).done (result)->
			source = result
			done()
	it "should have a filename", -> expect(source.files[0]).to.have.property('filename', '2.js')
	it "should have the relative folder URI", -> expect(source.files[0]).to.have.property('relativepath', './test/fixtures/countfiles/fivefiles/four')
	it "should have the absolute folder URI", -> expect(source.files[0]).to.have.property('absolutepath', process.cwd() + '/test/fixtures/countfiles/fivefiles/four')

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

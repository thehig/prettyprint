scan = require('../app/prettyprint').scan
mocha = require('mocha')
chai = require('chai')
chai.use(require('chai-as-promised')) # allows us to use 'eventually' to assert against promise results without expressly resolving the promise manually
expect = chai.expect

describe "scan parameters", ->

	describe "invalid/missing parameters", ->
		it "should throw an error given no parameter", -> expect(-> prettyprint.scan()).to.throw(/Required parameter/)
		it "should throw an error given no directory parameter", -> expect(-> prettyprint.scan({})).to.throw(/Missing parameter/)

	describe "uri parameters", ->
		it "should take an absolute URI as parameter", -> expect(scan({directory: process.cwd() + "\\test\\fixtures\\"})).to.eventually.have.property('workingdirectory', './test/fixtures');
		it "should take a relative URI as parameter", -> expect(scan({directory: './test/fixtures'})).to.eventually.have.property('workingdirectory', './test/fixtures');
		it "should convert backslashes to forwardslashes", -> expect(scan({directory: '.\\test\\fixtures'})).to.eventually.have.property('workingdirectory', './test/fixtures');
		it "should add a leading dot if not provided", -> expect(scan({directory: '/test/fixtures'})).to.eventually.have.property('workingdirectory', './test/fixtures');
		it "should add a leading dot and slash if not provided", -> expect(scan({directory: 'test\\fixtures\\'})).to.eventually.have.property('workingdirectory', './test/fixtures');

	describe "gathering files", ->
		relativeuri = './test/fixtures/countfiles/fivefiles/'
		absuri = process.cwd() + '/test/fixtures/countfiles/fivefiles/'

		it "should count the number of files in a folder", -> expect(scan({directory: './test/fixtures/countfiles/fivefiles/four'})).to.eventually.have.property('files').with.length(4)
		it "should count .. recursively", -> expect(scan({directory: relativeuri})).to.eventually.have.property('files').with.length(5)
		it "should count .. recursively that match a pattern", -> expect(scan({directory: absuri, patterns: ['js']})).to.eventually.have.property('files').with.length(3)
		it "should count .. recursively that match one of multple patterns", ->expect(scan({directory: relativeuri, patterns: ['js', 'css']})).to.eventually.have.property('files').with.length(4)
		it "should not matter if the pattern is upper or lower case", ->expect(scan({directory: absuri, patterns: ['JS', 'CsS']})).to.eventually.have.property('files').with.length(4)
		it.skip "should retain a filename relative to the starting path", -> expect.fail()

	describe.skip "other parameters", ->
		it "should allow for selection of highlightjs syntax formatting", -> expect.fail()

describe "scan results", ->
	data = undefined
	beforeEach (done)->
		prettyprint.scan({directory: './test/fixtures/countfiles/fivefiles/'}).done (result)->
			data = result
			done()

	it "should have a filename", -> expect(data.files[0]).to.have.property('filename', '1.js')
	it "should have the relative folder URI", -> expect(data.files[0]).to.have.property('relativepath', './test/fixtures/countfiles/fivefiles/one/')
	it "should have the absolute folder URI", -> expect(data.files[0]).to.have.property('absolutepath', process.cwd().replace(/\\/g, "/") + '/test/fixtures/countfiles/fivefiles/one/')


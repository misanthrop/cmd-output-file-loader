fs = require 'fs'
path = require 'path'
cp = require 'child_process'
lu = require 'loader-utils'

mkdir = (dir, mode) -> if not fs.existsSync dir
	try fs.mkdirSync dir, mode
	catch e
		if e.code == 'ENOENT'
			mkdir path.dirname(dir), mode
			mkdir dir, mode

module.exports = (content) ->
	@cacheable?()
	mkdir @options.output.path
	name = lu.interpolateName @, @query.name or '[hash].[ext]', {@context, @regExp, content}
	target = path.join @options.output.path, name
	cmd = @query.command
		.replace /\[input\]/, @resourcePath
		.replace /\[output\]/, target
	console.log cmd
	cp.execSync cmd
	@emitFile name, fs.readFileSync target
	@callback null, "module.exports = '#{name}'"

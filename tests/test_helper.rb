require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/reporters'

_stderr, $stderr = $stderr, StringIO.new
require 'openstudio'
$stderr = _stderr

require 'pathname'

include Minitest

Reporters.use! Reporters::SpecReporter.new

require_relative '../resources/weather'
require_relative '../measure'

require "amp"
require "test_helper"
require "test/unit"
require "shoulda"

def test(input, expected_output, filename="index.html")
  input = input.strip
  expected_output = expected_output.strip
  output = Amp.compile(input, filename, 'current', 'current-parent')
  assert_equal expected_output, output
end
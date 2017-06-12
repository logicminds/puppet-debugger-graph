require 'spec_helper'
require 'puppet-debugger'
require 'puppet-debugger/plugin_test_helper'

describe :graph do
  include_examples "plugin_tests"
  let(:args) { [] }

  it 'works' do
    plugin.create_graph_content
    # plugin.handle_input("file{'/tmp/test': }")
    # expect(output.string).to eq('sdafsda')
  end

end

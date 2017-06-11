require 'spec_helper'
require 'puppet-debugger'
require 'puppet-debugger/input_responders/graph'
require 'puppet-debugger/plugin_test_helper'

describe :graph do
  include_examples "plugin_tests"
  let(:args) { [] }

  it 'works' do
    expect(plugin.run(args)).to eq('sdafsda')
  end

end

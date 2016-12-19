require 'spec_helper'
describe 'veritas_infoscale' do

  context 'with default values for all parameters' do
    it { should contain_class('veritas_infoscale') }
  end
end

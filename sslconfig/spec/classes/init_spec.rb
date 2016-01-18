require 'spec_helper'
describe 'sslconfig' do

  context 'with defaults for all parameters' do
    it { should contain_class('sslconfig') }
  end
end

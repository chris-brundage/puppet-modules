require 'spec_helper'
describe 'extrarepos' do

  context 'with defaults for all parameters' do
    it { should contain_class('extrarepos') }
  end
end

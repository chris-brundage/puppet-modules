require 'spec_helper'
describe 'generalenv' do

  context 'with defaults for all parameters' do
    it { should contain_class('generalenv') }
  end
end

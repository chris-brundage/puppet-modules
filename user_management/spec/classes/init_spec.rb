require 'spec_helper'
describe 'user_management' do

  context 'with defaults for all parameters' do
    it { should contain_class('user_management') }
  end
end

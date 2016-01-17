require 'spec_helper'
describe 'amavis' do

  context 'with defaults for all parameters' do
    it { should contain_class('amavis') }
  end
end

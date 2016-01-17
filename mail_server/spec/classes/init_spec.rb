require 'spec_helper'
describe 'mail_server' do

  context 'with defaults for all parameters' do
    it { should contain_class('mail_server') }
  end
end

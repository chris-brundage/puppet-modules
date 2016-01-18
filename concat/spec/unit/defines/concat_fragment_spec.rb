require 'spec_helper'

describe 'concat::fragment', :type => :define do

  shared_examples 'fragment' do |title, params|
    params = {} if params.nil?

    p = {
      :content => nil,
      :source  => nil,
      :order   => 10,
      :ensure  => 'present',
    }.merge(params)

    safe_name        = title.gsub(/[\/\n]/, '_')
    safe_target_name = p[:target].gsub(/[\/\n]/, '_')
    concatdir        = '/var/lib/puppet/concat'
    fragdir          = "#{concatdir}/#{safe_target_name}"
    id               = 'root'
    gid              = 'root'
    if p[:ensure] == 'absent'
      safe_ensure = p[:ensure] 
    else
      safe_ensure = 'file'
    end

    let(:title) { title }
    let(:facts) do
      {
        :concat_basedir => concatdir,
        :id             => id,
        :gid            => gid,
        :osfamily       => 'Debian',
        :path           => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        :is_pe          => false,
      }
    end
    let(:params) { params }
    let(:pre_condition) do
      "concat{ '#{p[:target]}': }"
    end

    it do
      should contain_class('concat::setup')
      should contain_concat(p[:target])
      should contain_file("#{fragdir}/fragments/#{p[:order]}_#{safe_name}").with({
        :ensure  => safe_ensure,
        :owner   => id,
        :mode    => '0640',
        :source  => p[:source],
        :content => p[:content],
        :alias   => "concat_fragment_#{title}",
        :backup  => 'puppet',
      })
      # The defined() function doesn't seem to work properly with puppet 3.4 and rspec.
      # defined() works on its own, rspec works on its own, but together they
      # determine that $gid is not defined and cause errors here. Work around
      # it by ignoring this check for older puppet version.
      if Puppet::Util::Package.versioncmp(Puppet.version, '3.5.0') >= 0
        should contain_file("#{fragdir}/fragments/#{p[:order]}_#{safe_name}").with({
          :group   => gid,
        })
      end
    end
  end

  context 'title' do
    ['0', '1', 'a', 'z'].each do |title|
      it_behaves_like 'fragment', title, {
        :target  => '/etc/motd',
      }
    end
  end # title

  context 'target =>' do
    ['./etc/motd', 'etc/motd', 'motd_header'].each do |target|
      context target do
        it_behaves_like 'fragment', target, {
          :target  => '/etc/motd',
        }
      end
    end

    context 'false' do
      let(:title) { 'motd_header' }
      let(:facts) {{ :concat_basedir => '/tmp', :is_pe => false }}
      let(:params) {{ :target => false }}

      it 'should fail' do
        expect { catalogue }.to raise_error(Puppet::Error, /is not a string/)
      end
    end
  end # target =>

  context 'ensure =>' do
    ['present', 'absent'].each do |ens|
      context ens do
        it_behaves_like 'fragment', 'motd_header', {
          :ensure => ens,
          :target => '/etc/motd',
        }
      end
    end

    context 'any value other than \'present\' or \'absent\'' do
      let(:title) { 'motd_header' }
      let(:facts) {{ :concat_basedir => '/tmp', :is_pe => false }}
      let(:params) {{ :ensure => 'invalid', :target => '/etc/motd' }}

      it 'should create a warning' do
        skip('rspec-puppet support for testing warning()')
      end
    end
  end # ensure =>

  context 'content =>' do
    ['', 'ashp is our hero'].each do |content|
      context content do
        it_behaves_like 'fragment', 'motd_header', {
          :content => content,
          :target  => '/etc/motd',
        }
      end
    end

    context 'false' do
      let(:title) { 'motd_header' }
      let(:facts) {{ :concat_basedir => '/tmp', :is_pe => false }}
      let(:params) {{ :content => false, :target => '/etc/motd' }}

      it 'should fail' do
        expect { catalogue }.to raise_error(Puppet::Error, /is not a string/)
      end
    end
  end # content =>

  context 'source =>' do
    ['', '/foo/bar', ['/foo/bar', '/foo/baz']].each do |source|
      context source do
        it_behaves_like 'fragment', 'motd_header', {
          :source => source,
          :target => '/etc/motd',
        }
      end
    end

    context 'false' do
      let(:title) { 'motd_header' }
      let(:facts) {{ :concat_basedir => '/tmp', :is_pe => false }}
      let(:params) {{ :source => false, :target => '/etc/motd' }}

      it 'should fail' do
        expect { catalogue }.to raise_error(Puppet::Error, /is not a string or an Array/)
      end
    end
  end # source =>

  context 'order =>' do
    ['', '42', 'a', 'z'].each do |order|
      context '\'\'' do
        it_behaves_like 'fragment', 'motd_header', {
          :order  => order,
          :target => '/etc/motd',
        }
      end
    end

    context 'false' do
      let(:title) { 'motd_header' }
      let(:facts) {{ :concat_basedir => '/tmp', :is_pe => false }}
      let(:params) {{ :order => false, :target => '/etc/motd' }}

      it 'should fail' do
        expect { catalogue }.to raise_error(Puppet::Error, /is not a string or integer/)
      end
    end

    context '123:456' do
      let(:title) { 'motd_header' }
      let(:facts) {{ :concat_basedir => '/tmp', :is_pe => false }}
      let(:params) {{ :order => '123:456', :target => '/etc/motd' }}

      it 'should fail' do
        expect { catalogue }.to raise_error(Puppet::Error, /cannot contain/)
      end
    end
    context '123/456' do
      let(:title) { 'motd_header' }
      let(:facts) {{ :concat_basedir => '/tmp', :is_pe => false }}
      let(:params) {{ :order => '123/456', :target => '/etc/motd' }}

      it 'should fail' do
        expect { catalogue }.to raise_error(Puppet::Error, /cannot contain/)
      end
    end
    context '123\n456' do
      let(:title) { 'motd_header' }
      let(:facts) {{ :concat_basedir => '/tmp', :is_pe => false }}
      let(:params) {{ :order => "123\n456", :target => '/etc/motd' }}

      it 'should fail' do
        expect { catalogue }.to raise_error(Puppet::Error, /cannot contain/)
      end
    end
  end # order =>

  context 'more than one content source' do
    error_msg = 'You cannot specify more than one of $content, $source, $ensure => /target'

    context 'ensure => target and source' do
      let(:title) { 'motd_header' }
      let(:facts) do
        {
          :concat_basedir => '/tmp',
          :osfamily       => 'Debian',
          :id             => 'root',
          :is_pe          => false,
          :gid            => 'root',
        }
      end
      let(:params) do
        {
          :target  => '/etc/motd',
          :ensure  => '/foo',
          :source  => '/bar',
        }
      end

      it 'should fail' do
        expect { catalogue }.to raise_error(Puppet::Error, /#{Regexp.escape(error_msg)}/m)
      end
    end

    context 'ensure => target and content' do
      let(:title) { 'motd_header' }
      let(:facts) do
        {
          :concat_basedir => '/tmp',
          :osfamily       => 'Debian',
          :id             => 'root',
          :is_pe          => false,
          :gid            => 'root',
        }
      end
      let(:params) do
        {
          :target  => '/etc/motd',
          :ensure  => '/foo',
          :content => 'bar',
        }
      end

      it 'should fail' do
        expect { catalogue }.to raise_error(Puppet::Error, /#{Regexp.escape(error_msg)}/m)
      end
    end

    context 'source and content' do
      let(:title) { 'motd_header' }
      let(:facts) do
        {
          :concat_basedir => '/tmp',
          :osfamily       => 'Debian',
          :id             => 'root',
          :is_pe          => false,
          :gid            => 'root',
        }
      end
      let(:params) do
        {
          :target => '/etc/motd',
          :source => '/foo',
          :content => 'bar',
        }
      end

      it 'should fail' do
        expect { catalogue }.to raise_error(Puppet::Error, /#{Regexp.escape(error_msg)}/m)
      end
    end

  end # more than one content source

  describe 'deprecated parameter' do
    context 'mode =>' do
      context '1755' do
        it_behaves_like 'fragment', 'motd_header', {
          :mode   => '1755',
          :target => '/etc/motd',
        }

        it 'should create a warning' do
          skip('rspec-puppet support for testing warning()')
        end
      end
    end # mode =>

    context 'owner =>' do
      context 'apenny' do
        it_behaves_like 'fragment', 'motd_header', {
          :owner  => 'apenny',
          :target => '/etc/motd',
        }

        it 'should create a warning' do
          skip('rspec-puppet support for testing warning()')
        end
      end
    end # owner =>

    context 'group =>' do
      context 'apenny' do
        it_behaves_like 'fragment', 'motd_header', {
          :group  => 'apenny',
          :target => '/etc/motd',
        }

        it 'should create a warning' do
          skip('rspec-puppet support for testing warning()')
        end
      end
    end # group =>

    context 'backup =>' do
      context 'foo' do
        it_behaves_like 'fragment', 'motd_header', {
          :backup => 'foo',
          :target => '/etc/motd',
        }

        it 'should create a warning' do
          skip('rspec-puppet support for testing warning()')
        end
      end
    end # backup =>
  end # deprecated params

end

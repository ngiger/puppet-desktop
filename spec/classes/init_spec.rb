require 'spec_helper'

describe 'desktop' do
  let(:facts) { WheezyFacts }

  context 'when running with default parameters' do
    it {
     should compile
     should compile.with_all_deps
     should contain_desktop
    }
  end

  context 'when running with ensure true' do
    let(:params) { { :ensure => 'true',}}
    it {
      should compile
      should compile.with_all_deps
      should create_class('desktop')
    }
    it { should contain_package('awesome').with_ensure(/present|installed/) }
  end

  context 'when running with ensure absent' do
    let(:params) { { :ensure => 'absent' } }
    it { should compile }
    it { should compile.with_all_deps }
    it { should contain_package('awesome').with_ensure(/present|installed/) }
  end
end

describe 'desktop' do
  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }
  let(:facts)  { { :osfamily => 'Debian', :lsbdistcodename => 'wheezy', :lsbdistid => 'debian'} }
  context 'when running with changed parameters' do
    it { should compile }
    it { should compile.with_all_deps }
    it { should contain_exec('update_locale') }
    it { should_not contain_package('lyx') }
    it { should_not contain_package('awesome') }
    it { should contain_package('gdm') }
    it { should contain_package('slim') }
    it { should contain_package('scribus') }
    it { should contain_file('/etc/default/locale').with_content(/#\s*managed by puppet/i) }
    it { should contain_file('/etc/default/locale').with_content(/LANG='de_CH.UTF-8'
LANGUAGE=de_CH
LC_MESSAGES=POSIX
/) }
  end
end

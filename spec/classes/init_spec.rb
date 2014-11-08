require 'spec_helper'

describe 'desktop' do
  let(:facts) { WheezyFacts }

  context 'when running with default parameters' do
    it {
     should compile
     should compile.with_all_deps
     should contain_desktop
     should_not contain_file('/etc/default/locale')
     should_not contain_package('awesome')
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
    it { should contain_file('/etc/default/locale').with_content(/#\s*managed by puppet/i) }
    it { should contain_file('/etc/default/locale').with_content(/
LANG='de_CH.UTF8'
LANGUAGE=de_CH
LC_MESSAGES=POSIX
/) }
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
#  let(:facts)  { WheezyFacts }
  let(:facts)  { { :osfamily => 'Debian', :lsbdistcodename => 'wheezy', :lsbdistid => 'debian', :operatingsystem => 'Debian'} }

  context 'when running with changed parameters' do
    it { should compile }
    it { should compile.with_all_deps }
    it { should contain_exec('update_locale_fr_CH.UTF8') }
    it { should_not contain_package('lyx') }
    it { should_not contain_package('awesome') }
    it { should contain_package('gdm') }
    it { should contain_package('slim') }
    it { should contain_package('scribus') }
    it { should contain_file('/etc/default/locale').with_content(/#\s*managed by puppet/i) }
    it { should contain_file('/etc/default/locale').with_content(/
LANG='fr_CH.UTF8'
LANGUAGE=fr_CH
LC_MESSAGES=
/) }
  end
end

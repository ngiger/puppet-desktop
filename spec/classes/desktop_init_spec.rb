#
#    Copyright (C) 2014 Niklaus Giger <niklaus.giger@member.fsf.org>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
require 'spec_helper'

describe 'desktop::client' do
  let(:node) { 'testhost.example.com' }

  context 'when running on Debian GNU/Linux' do
    it {
      should contain_package('rsync').with_ensure(/present|installed/)
    }
  end
end

describe 'desktop::client' do
  let(:node) { 'testhost.example.com' }
  let(:params) { {:ensure => 'present' } }
  context 'when given present as ensure' do

    it {
      should contain_package('desktop').with_ensure(/present|installed/)
    }
      
  end

end
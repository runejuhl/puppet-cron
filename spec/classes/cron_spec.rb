require 'spec_helper'

describe 'cron' do
  it {
    should contain_class( 'cron::install' ).with({
      'before' => ['Class[Cron::Service]'],
    })
    should contain_class( 'cron::service' )
  }

  context 'unclean' do
    it { should include_class( 'cron::install' ) }
  end

  context 'absent' do
    let(:params) { {:ensure => 'absent'} }
    it { should contain_file( '/etc/cron.d' ) }
  end
end

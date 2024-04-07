# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VpnCheck, type: :service do
  describe '#call' do
    let(:ip) { '8.8.8.8' }
    let(:vpnapi_url) { "https://vpnapi.io/api/#{ip}?key=#{ENV['VPNAPIIO_API_KEY']}" }

    context 'when the response is successful' do
      let(:success_body) do
        {
          ip:,
          security: {
            vpn: false,
            proxy: false,
            tor: false,
            relay: false
          },
          location: {
            country: 'United States',
            continent: 'North America',
            country_code: 'US',
            continent_code: 'NA',
            latitude: '37.7510',
            longitude: '-97.8220',
            time_zone: 'America/Chicago',
            locale_code: 'en',
            is_in_european_union: false
          },
          network: {
            network: '8.8.8.0/24',
            autonomous_system_number: 'AS15169',
            autonomous_system_organization: 'GOOGLE'
          }
        }.to_json
      end

      before do
        stub_request(:get, vpnapi_url).to_return(status: 200, body: success_body)
      end

      it 'returns Success with false' do
        expect(subject.call(ip:)).to be_success.and have_attributes(value!: false)
      end
    end

    context 'when the VPNAPI service returns a 500 error' do
      before do
        stub_request(:get, vpnapi_url).to_return(status: 500)
      end

      it 'returns Success with false due to error handling' do
        expect(subject.call(ip:)).to be_success.and have_attributes(value!: false)
      end
    end
  end
end

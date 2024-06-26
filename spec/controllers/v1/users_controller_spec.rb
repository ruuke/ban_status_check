# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Users', type: :request do
  describe 'POST /v1/user/check_status' do
    let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'CF-IPCountry' => 'US' } }
    let(:user_params) { { idfa: 'some_idfa', rooted_device: false }.to_json }
    let(:vpn_check_instance) { instance_double(VpnCheck) }

    before do
      RedisClient.client.sadd('whitelisted_countries', %w[US CA GB])
      allow(VpnCheck).to receive(:new).and_return(vpn_check_instance)
      allow(vpn_check_instance).to receive(:call).with(ip: anything)
                                                 .and_return(Dry::Monads::Result::Success.new(
                                                               { is_vpn_or_tor: false, proxy: false, vpn: false }
                                                             ))
    end

    context 'when the user is not banned' do
      it 'returns ban_status as not_banned' do
        post('/v1/user/check_status', params: user_params, headers:)

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq('ban_status' => 'not_banned')
      end
    end

    context 'when CF-IPCountry not whitelisted' do
      let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'CF-IPCountry' => 'RR' } }

      it 'returns ban_status as banned' do
        post('/v1/user/check_status', params: user_params, headers:)

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq('ban_status' => 'banned')
      end
    end

    context 'when request params are invalid' do
      let(:user_params) { { idfa: 1, rooted_device: 1 }.to_json }

      it 'returns ban_status as error' do
        post('/v1/user/check_status', params: user_params, headers:)

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body))
          .to eq('errors' => { 'idfa' => ['must be a string'], 'rooted_device' => ['must be boolean'] })
      end
    end
  end
end

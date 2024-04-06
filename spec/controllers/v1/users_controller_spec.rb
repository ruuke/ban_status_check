# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Users', type: :request do
  describe 'POST /v1/user/check_status' do
    let(:ban_check_instance) { instance_double(BanCheck) }

    before do
      allow(BanCheck).to receive(:new).and_return(ban_check_instance)
    end

    context 'when the user is not banned' do
      let(:user_params) { { idfa: 'some_idfa', rooted_device: false } }

      before do
        allow(ban_check_instance).to receive(:call).and_return(Dry::Monads::Success('not_banned'))
      end

      it 'returns ban_status as not_banned' do
        post '/v1/user/check_status', params: user_params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq('ban_status' => 'not_banned')
      end
    end

    context 'when there is an error in checking ban status' do
      let(:user_params) { { idfa: 'unknown_idfa', rooted_device: true } }

      before do
        allow(ban_check_instance).to receive(:call).and_return(Dry::Monads::Failure(:error))
      end

      it 'returns ban_status as error' do
        post '/v1/user/check_status', params: user_params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq('ban_status' => 'error')
      end
    end
  end
end

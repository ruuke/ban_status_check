# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BanCheck, type: :service do
  subject(:service_call) { described_class.new.call(params) }

  let(:idfa) { 'unique_idfa' }
  let(:rooted_device) { false }
  let(:cf_ipcountry) { 'US' }
  let(:params) { { idfa:, rooted_device:, cf_ipcountry: } }

  before do
    RedisClient.client.sadd('whitelisted_countries', %w[US CA GB])
  end

  describe 'validating parameters' do
    context 'when parameters are missing' do
      let(:params) { {} }

      it 'fails due to missing parameters' do
        expect(service_call).to be_a(Dry::Monads::Result::Failure)
        expect(service_call.failure.errors.to_h.keys).to include(:idfa, :rooted_device, :cf_ipcountry)
      end
    end
  end

  describe 'rooted device check' do
    let(:rooted_device) { true }

    context 'when the device is rooted' do
      it 'bans the user' do
        expect(service_call).to be_a(Dry::Monads::Result::Success)
        expect(service_call.value!).to eq('banned')
      end
    end
  end

  context 'user exists validation' do
    describe 'creating a new user' do
      context 'when IDFA does not exist' do
        it 'creates a new user' do
          expect { service_call }.to change(User, :count).by(1)
          expect(service_call).to be_a(Dry::Monads::Result::Success)
          expect(service_call.value!).to eq('not_banned')
        end
      end
    end

    describe 'updating an existing user' do
      let!(:existing_user) { create(:user, idfa:, ban_status: 'not_banned') }

      context 'when IDFA exists' do
        it 'updates the user record' do
          expect { service_call }.not_to change(User, :count)
          expect(service_call).to be_a(Dry::Monads::Result::Success)
        end
      end
    end

    describe 'handling an already banned user' do
      let!(:banned_user) { create(:user, idfa:, ban_status: 'banned') }

      context 'when the user is already banned' do
        it 'returns banned status without updating' do
          expect { service_call }.not_to(change { banned_user.reload.attributes })
          expect(service_call).to be_a(Dry::Monads::Result::Success)
          expect(service_call.value!).to eq('banned')
        end
      end
    end
  end

  describe 'CF-IPCountry check' do
    context 'when the country is whitelisted' do
      it 'does not ban the user based on country' do
        expect(service_call).to be_success
        expect(service_call.value!).to eq('not_banned')
      end
    end

    context 'when the country is not whitelisted' do
      let(:cf_ipcountry) { 'ZZ' }

      it 'bans the user based on country' do
        expect(service_call).to be_success
        expect(service_call.value!).to eq('banned')
      end
    end
  end
end

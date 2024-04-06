require 'rails_helper'

RSpec.describe BanCheck, type: :service do
  subject(:service_call) { described_class.new(user_repository: User).call(params) }

  let(:user_repository) { User }
  let(:idfa) { "unique_idfa" }
  let(:rooted_device) { false }
  let(:params) { { idfa: idfa, rooted_device: rooted_device } }

  describe 'validating parameters' do
    context 'when parameters are missing' do
      let(:params) { {} }

      it 'fails due to missing parameters' do
        expect(service_call).to be_a(Dry::Monads::Result::Failure)
        expect(service_call.failure.errors.to_h.keys).to include(:idfa, :rooted_device)
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
      let!(:existing_user) { create(:user, idfa: idfa, ban_status: 'not_banned') }

      context 'when IDFA exists' do
        it 'updates the user record' do
          expect { service_call }.not_to change(User, :count)
          expect(service_call).to be_a(Dry::Monads::Result::Success)
        end
      end
    end

    describe 'handling an already banned user' do
      let!(:banned_user) { create(:user, idfa: idfa, ban_status: 'banned') }

      context 'when the user is already banned' do
        it 'returns banned status without updating' do
          expect { service_call }.not_to change { banned_user.reload.attributes }
          expect(service_call).to be_a(Dry::Monads::Result::Success)
          expect(service_call.value!).to eq('banned')
        end
      end
    end
  end
end

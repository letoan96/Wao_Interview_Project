require 'rails_helper'

module TransferService
  RSpec.describe SendMoney do

    context 'when sender or receiver is not valid' do
      let(:sender) { create(:user) }
      let(:receiver) { create(:user) }
      let(:sender_balance) { create(:balance, user_id: sender.id, amount: 80000) }
      let(:receiver_balance) { create(:balance, user_id: receiver.id, amount: 0) }
      it 'succeeds' do
        expect(sender.valid?).to be true
        expect(receiver.valid?).to be true
      end
    end
    
  end
end

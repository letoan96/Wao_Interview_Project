require 'rails_helper'

module TransferService
  RSpec.describe SendMoney do
    let(:sender) { create(:user) }
    let(:receiver) { create(:user) }
    let(:sender_balance) { create(:balance, user_id: sender.id, amount: 80000) }
    let(:receiver_balance) { create(:balance, user_id: receiver.id, amount: 0) }

    context 'when sender is not valid' do
      it 'will fall' do
        result = SendMoney.call(
          sender_id: sender.id + 100, #invalid user id
          receiver_id: receiver.id,
          amount: 50000
        )
        expect(result.success?).to eq(false)
        expect(result.errors[:user][0]).to eq('Tài khoản người dùng không đúng!')
      end
    end

    context 'when receiver is not valid' do
      it 'will fall' do
        result = SendMoney.call(
          sender_id: sender.id,
          receiver_id: receiver.id + 100, #invalid user id
          amount: 50000
        )
        expect(result.success?).to eq(false)
        expect(result.errors[:user][0]).to eq('Tài khoản người dùng không đúng!')
      end
    end

    context 'when amount is negative number' do
      it 'will fall' do
        result = SendMoney.call(
          sender_id: sender.id,
          receiver_id: receiver.id,
          amount: -10000 #invalid amount
        )
        expect(result.success?).to eq(false)
        expect(result.errors[:amount][0]).to eq('Số tiền chuyển không hợp lệ!')
      end
    end

    context 'when amount is not a number' do
      it 'will fall' do
        result = SendMoney.call(
          sender_id: sender.id,
          receiver_id: receiver.id,
          amount: '12asd123afs' #invalid amount
        )
        expect(result.success?).to eq(false)
        expect(result.errors[:amount][0]).to eq('Số tiền chuyển không hợp lệ!')
      end
    end

    context "when sender's balance is less than amount" do
      it 'will fall' do
        sender_balance # invoke user's balance
        receiver_balance # invoke user's balance
        result = SendMoney.call(
          sender_id: sender.id,
          receiver_id: receiver.id,
          amount: 100000 #invalid amount ( 100k > 80k )
        )
        expect(result.success?).to eq(false)
        expect(result.errors[:balance][0]).to eq('Số dư tài khoản không đủ!')
      end
    end

    context "when everything is fine" do
      it 'will success' do
        sender_balance # invoke user's balance
        receiver_balance # invoke user's balance
        result = SendMoney.call(
          sender_id: sender.id,
          receiver_id: receiver.id,
          amount: 50000
        )
        expect(result.success?).to eq(true)
        expect(sender.balances.first.amount.to_i).to eql(30000)
        expect(receiver.balances.first.amount.to_i).to eql(50000)
      end
    end

  end
end

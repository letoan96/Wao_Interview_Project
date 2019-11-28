module TransferService
  class SendMoney
    prepend SimpleCommand
    attr_reader :sender,
                :receiver,
                :amount

    def initialize(sender_id:, receiver_id:, amount: )
      # accept that we can pass in user objects. However, I prefer using sender_id and receiver_id in this case for better illustration
      @sender = User.find_by(id: sender_id)
      @receiver = User.find_by(id: receiver_id)
      @amount = to_big_decimal(amount) #  return 'nil' if amount is not a number nor is positive
    end

    def call
      return user_not_found_err if sender.nil? | receiver.nil?
      return amount_err unless amount && amount.positive?
      return user_balance_err unless amount < sender.balances.first.amount

      Balance.transaction do
        sender_balance = sender.balances.first
        sender_balance.with_lock do
          sender_balance.amount -= amount
          sender_balance.save!
        end

        receiver_balance = receiver.balances.first
        receiver_balance.with_lock do
          receiver_balance.amount += amount
          receiver_balance.save!
        end
      end
    end

    def user_balance_err
      errors.add(:balance, "Số dư tài khoản không đủ!")
    end

    def amount_err
      errors.add(:amount, "Số tiền chuyển không hợp lệ!")
    end

    def user_not_found_err
      errors.add(:user, 'Tài khoản người dùng không đúng!')
    end

    private
    def to_big_decimal amount
       BigDecimal(amount.to_s) if Float(amount) rescue nil
    end
  end
end

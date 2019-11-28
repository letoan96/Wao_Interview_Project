module TransferService
  class SendMoney
    prepend SimpleCommand
    attr_reader :sender,
                :receiver,
                :amount

    def initialize(sender_id:, receiver_id:, amount: )
      @sender = User.find_by(id: sender_id)
      @receiver = User.find_by(id: receiver_id)
      @amount = to_big_decimal(amount)
    end

    def call
      return user_not_found_err if sender.nil? | receiver.nil?
      return amount_err unless amount && amount.positive?
      p sender.balances.first
      p "---------------------"
      return user_balance_err unless sender.balances.first.amount >= amount

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

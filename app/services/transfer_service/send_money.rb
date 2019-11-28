module TransferService
  class SendMoney
    prepend SimpleCommand
    attr_reader :sender,
                :receiver,
                :amount

    def initialize(sender_id:, receiver_id:, amount: )
      @sender = User.find_by(id: sender_id)
      @receiver = User.find_by(id: receiver_id)
      @amount = amount
    end

    def call

    end

    def user_balance_err
      errors.add(:balance, "Số dư tài khoản không đủ!")
    end

    def amount_err
      errors.add(:amount, "Số tiền chuyển không hợp lệ!")
    end


  end
end

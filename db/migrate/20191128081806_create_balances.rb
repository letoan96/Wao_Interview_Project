class CreateBalances < ActiveRecord::Migration[5.2]
  def change
    create_table :balances do |t|
      t.string :balance_name
      t.decimal :amount, default: 0
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end

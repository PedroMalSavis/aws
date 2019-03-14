class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.references :user, index: true, foreign_key: {on_delete: :nullify}
      t.text :message
      
      t.timestamps
    end
  end
end

class CreateServices < ActiveRecord::Migration[6.0]
  def change
    create_table :services do |t|
      t.references :user, index: true, foreign_key: {on_delete: :nullify}
      t.string :name
      t.string :photo
      t.timestamps
    end
  end
end

class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.references :user, index: true, foreign_key: {on_delete: :nullify}
      t.boolean :published
      t.text :content
      t.text :photo
      t.timestamps
    end
  end
end

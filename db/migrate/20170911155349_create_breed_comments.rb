class CreateBreedComments < ActiveRecord::Migration[5.1]
  def change
    create_table :breed_comments do |t|
      t.integer :breed_id
      t.integer :comment_id

      t.timestamps
    end
  end
end

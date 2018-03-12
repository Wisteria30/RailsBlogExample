class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.string :create_user

      t.timestamps
    end
  end
end

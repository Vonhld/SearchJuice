class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :summary
      t.string :author_name
      t.text :content
      t.string :category    
      t.datetime :published_at
      
      t.timestamps
    end

    add_index :articles, :title
    add_index :articles, :author_name
    add_index :articles, :published_at
  end
end

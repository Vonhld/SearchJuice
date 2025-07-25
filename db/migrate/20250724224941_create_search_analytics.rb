class CreateSearchAnalytics < ActiveRecord::Migration[6.1]
  def change
    create_table :search_analytics do |t|
      t.string :query
      t.string :user_ip

      t.timestamps
    end
  end
end

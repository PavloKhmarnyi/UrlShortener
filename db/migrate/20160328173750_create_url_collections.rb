class CreateUrlCollections < ActiveRecord::Migration
  def change
    create_table :url_collections do |t|
      t.string :shortUrl
      t.string :longUrl

      t.timestamps
    end
  end
end

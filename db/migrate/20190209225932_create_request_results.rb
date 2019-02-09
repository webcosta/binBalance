class CreateRequestResults < ActiveRecord::Migration[5.2]
  def change
    create_table :request_results do |t|
      t.text :raw_data
      t.text :parsed_data
      
      t.timestamps
    end
  end
end

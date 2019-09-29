class CreatePdfs < ActiveRecord::Migration[5.1]
  def change
    create_table :pdfs do |t|
      t.string :pdf

      t.timestamps
    end
  end
end

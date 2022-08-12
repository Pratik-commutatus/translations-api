class CreateGlossaries < ActiveRecord::Migration[7.0]
  def change
    create_table :glossaries do |t|
      t.string :source_language_code
      t.string :target_language_code

      t.timestamps
    end
  end
end

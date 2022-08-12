class CreateTranslations < ActiveRecord::Migration[7.0]
  def change
    create_table :translations do |t|
      t.references :glossary, null: false, foreign_key: true
      t.text :source_text
      t.text :target_text

      t.timestamps
    end
  end
end

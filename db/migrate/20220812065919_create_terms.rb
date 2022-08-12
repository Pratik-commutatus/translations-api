class CreateTerms < ActiveRecord::Migration[7.0]
  def change
    create_table :terms do |t|
      t.references :glossary, null: false, foreign_key: true
      t.string :source_term
      t.string :target_term

      t.timestamps
    end
  end
end

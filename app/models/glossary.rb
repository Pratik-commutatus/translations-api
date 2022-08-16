class Glossary < ApplicationRecord
  require 'csv'

  has_many :terms
  has_many :translations
  
  file_data = CSV.open('imports/language-codes.csv', headers: :first_row).map(&:to_h)
  AVAILABLE_LANGUAGE_CODES = file_data.map {|h| h['code']}

  validates :source_language_code, :target_language_code, presence: true, inclusion: { in: AVAILABLE_LANGUAGE_CODES }
  validate :glossary_uniqueness

  def glossary_uniqueness
    duplicate_records = Glossary.where(source_language_code: source_language_code, target_language_code: target_language_code)
    errors.add(:base, :invalid, message: 'A glossary with the entered combination of language codes already exists.') if duplicate_records.present?
  end

  scope :that_have_terms, -> { joins(:terms).distinct } 
end

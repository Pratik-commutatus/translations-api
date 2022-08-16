class Glossary < ApplicationRecord
  include GlossaryConcerns

  has_many :terms
  has_many :translations

  validates :source_language_code, :target_language_code, presence: true, inclusion: { in: Glossary.available_language_codes }
  validate :glossary_uniqueness

  def glossary_uniqueness
    identical_records = Glossary.records_with_codes(source_language_code, target_language_code)
    errors.add(:base, :invalid, message: 'A glossary with the entered combination of language codes already exists.') if identical_records.present?
  end

  scope :records_with_codes, lambda { |source_language_code, target_language_code|
    return nil if (source_language_code.blank? && target_language_code.blank?)
    where(source_language_code: source_language_code, target_language_code: target_language_code)
  }

  scope :that_have_terms, -> { joins(:terms).distinct }
end

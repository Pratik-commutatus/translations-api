class Translation < ApplicationRecord
  belongs_to :glossary
  
  validates :source_text, presence: true
  validates :source_text, length: {maximum: @source_text_char_limit = 5000, too_long: "is too long. Accepted character length is %{count}."}

  def get_matching_source_terms
    glossary_source_terms = glossary.terms.pluck(:source_term).map(&:downcase)
    source_text_terms = source_text.split
    matching_terms = source_text_terms.map{|t| remove_spl_chars(t) if glossary_source_terms.include?(remove_spl_chars(t.downcase))}.compact
    matching_terms.present? ? matching_terms : nil
  end

  def highlight_source_text(matching_terms)
    source_text_terms = source_text.split

    highlighted_text_terms = source_text_terms.map do |term|
      term_without_spl_chars = remove_spl_chars(term)
      matching_terms.include?(term_without_spl_chars) ? term.gsub(term_without_spl_chars, "<HIGHLIGHT>#{term_without_spl_chars}</HIGHLIGHT>") : term
    end

    highlighted_text = highlighted_text_terms.join(' ')
  end

  def remove_spl_chars(term)
    term.gsub(/[^0-9A-Za-z]/, '')
  end

  class << self
    attr_reader :source_text_char_limit
  end  
end

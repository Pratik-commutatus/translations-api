class Translation < ApplicationRecord
  belongs_to :glossary

  validates :source_text, presence: true
  validates :source_text, length: {maximum: 5000, too_long: "is too long. Accepted character length is %{count}."}

  def get_matching_source_terms
    glossary_source_terms = self.glossary.terms.pluck(:source_term)
    source_text_terms = self.source_text.split
    matching_terms = source_text_terms.select{|t| glossary_source_terms.include?(t)}
    matching_terms.present? ? matching_terms : nil
  end

  def highlight_source_text(matching_terms)
    source_text_terms = self.source_text.split

    highlighted_text_terms = source_text_terms.map do |term|
      term_without_spl_chars = term.gsub(/[^0-9A-Za-z]/, '')
      matching_terms.include?(term_without_spl_chars) ? term.gsub(term_without_spl_chars, "<HIGHLIGHT>#{term_without_spl_chars}</HIGHLIGHT>") : term
    end

    highlighted_text = highlighted_text_terms.join(' ')
  end
end

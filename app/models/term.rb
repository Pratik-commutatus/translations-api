class Term < ApplicationRecord
  belongs_to :glossary

  validates :source_term, :target_term, presence: true
end

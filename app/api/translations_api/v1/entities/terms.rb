module TranslationsAPI::V1::Entities
  class Terms < Grape::Entity
    expose :id,          documentation: { desc: "ID of the Term object"}
    expose :glossary_id, documentation: { desc: "ID of the associated Glossary object"}
    expose :source_term, documentation: { desc: "Source term"}
    expose :target_term, documentation: { desc: "Target term"}
  end
end
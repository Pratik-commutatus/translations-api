module TranslationsAPI::V1::Entities
  class Translations < Grape::Entity
    expose :id,          documentation: { desc: "ID of the Translation object"}
    expose :glossary_id, documentation: { desc: "ID of the associated Glossary object"}
    expose :source_text, documentation: { desc: "Text to be translated"}
  end
end
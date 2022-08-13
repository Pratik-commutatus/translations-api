module TranslationsAPI::V1::Entities
  class Glossaries < Grape::Entity
    expose :id,                                                 documentation: { desc: "ID of the Glossary object"}
    expose :source_language_code,                               documentation: { desc: "Source language code"}
    expose :target_language_code,                               documentation: { desc: "Target language code"}
    expose :terms, using: TranslationsAPI::V1::Entities::Terms, documentation: { desc: "All terms associated with the glossary."}
  end
end
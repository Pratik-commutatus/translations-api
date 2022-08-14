module TranslationsAPI::V1
  class Translations < Grape::API
    format :json
    prefix :api
    version 'v1', using: :path

    resource :translations do
      desc 'Creates a translation(note: the translation process will not take place within this application).'
      params do
        requires :source_language_code, type: String,  desc: 'an ISO 639-1 source language code', values: Glossary.available_language_codes
        requires :target_language_code, type: String,  desc: 'an ISO 639-1 target language code', values: Glossary.available_language_codes
        requires :source_text,          type: String,  desc: 'a source text to be translated'
        optional :glossary_id,          type: Integer, desc: 'glossary ID'
      end
      post do
        if params[:glossary_id].present?
          glossary = Glossary.find(params[:glossary_id])
          if glossary.source_language_code.eql?(params[:source_language_code]) && glossary.target_language_code.eql?(params[:target_language_code])
            translation = glossary.translations.create!(source_text: params[:source_text])
          else
            error! "Could not find a glossary record with the glossary_id, source_language_code and target_language_code provided", 404
          end
        else
          glossary = Glossary.find_or_create_by!(source_language_code: params[:source_language_code], target_language_code: params[:target_language_code])
          translation = glossary.translations.create!(source_text: params[:source_text])
        end
        present :translation, translation, with: Entities::Translations
      end

      desc 'Returns the translation.'
      params do
        requires :id, type: Integer, desc: 'translation ID'
      end
      get '/:id' do
        translation = Translation.find(params[:id])
        present :translation, translation, with: Entities::Translations

        matching_terms = translation.get_matching_source_terms
        present :matching_terms, matching_terms

        if matching_terms.present?
          highlighted_text = translation.highlight_source_text(matching_terms)
          present :highlighted_text, highlighted_text
        end
        
      end
    end
  end
end
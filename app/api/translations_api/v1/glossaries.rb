module TranslationsAPI::V1
  class Glossaries < Grape::API
    format :json
    prefix :api
    version 'v1', using: :path

    resource :glossaries do
      desc 'Creates a glossary.'
      params do
        requires :source_language_code, type: String, desc: 'an ISO 639-1 source language code', values: Glossary.available_language_codes
        requires :target_language_code, type: String, desc: 'an ISO 639-1 target language code', values: Glossary.available_language_codes
      end
      post do
        glossary = Glossary.create!(params)
        present :glossary, glossary, with: Entities::Glossaries
      end

      desc 'Returns the glossary with all terms.'
      params do
        requires :id, type: Integer, desc: 'glossary ID'
      end
      get '/:id' do
        glossary = Glossary.find(params[:id])
        present :glossary, glossary, with: Entities::Glossaries
      end

      desc 'Returns all glossaries with terms.'
      get do
        glossaries = Glossary.that_have_terms
        present :glossaries, glossaries, with: Entities::Glossaries
      end

      desc 'Creates a term in the given glossary.'
      params do
        requires :id,          type: Integer, desc: 'glossary ID'
        requires :source_term, type: String,  desc: 'a source term'
        requires :target_term, type: String,  desc: 'a target term'
      end
      post '/:id/terms' do
        term = Glossary.find(params[:id]).terms.create!(source_term: params[:source_term], target_term: params[:target_term])
        present :term, term, with: Entities::Terms
      end
    end
  end
end
require 'rails_helper'

RSpec.describe 'Translations', type: :request do
  describe '.find' do
    source_language_code = 'en'
    target_language_code = 'es'

    source_text = 'Hello, how are you?'

    let!(:principal_glossary) { Glossary.create(source_language_code: source_language_code, target_language_code: target_language_code) }
    let!(:principal_translation) { principal_glossary.translations.create(source_text: source_text) }

    context 'When matching terms are not present' do
      before { get "/api/v1/translations/#{principal_translation.id}" }

      it "returns a 'success' status" do
        expect(response).to have_http_status(:success)
      end

      it 'returns only the translation details' do
        expect(json).to eq({
          "translation" => {
            "id" => principal_translation.id, 
            "glossary_id" => principal_glossary.id, 
            "source_text" => source_text
          },
          "matching_terms" => nil
        })
      end
    end
    
    context 'When matching terms are present' do
      source_term = 'Hello'
      target_term = 'Hola'

      let!(:principal_term) { principal_glossary.terms.create(source_term: source_term, target_term: target_term) }

      before { get "/api/v1/translations/#{principal_translation.id}" }

      it "returns a 'success' status" do
        expect(response).to have_http_status(:success)
      end

      it 'returns the translation object' do
        expect(json['translation']).to include(
          "id" => principal_translation.id,
          "glossary_id" => principal_glossary.id,
          "source_text" => source_text
        )
      end

      it 'returns the array of matching terms' do
        expect(json['matching_terms']).to be_an(Array)
      end

      it 'returns highlighted text' do
        expect(json).to have_key('highlighted_text')
      end
    end

    context 'With a non-existent ID' do
      before { get "/api/v1/translations/#{principal_translation.id+1}" }

      it "returns a 'not_found' error status" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
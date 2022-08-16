require 'rails_helper'

RSpec.describe 'Translations', type: :request do
  describe '.create' do
    source_language_code = Glossary::AVAILABLE_LANGUAGE_CODES.sample
    target_language_code = Glossary::AVAILABLE_LANGUAGE_CODES.sample
    source_text = 'Please translate this text.'

    let!(:principal_glossary) { Glossary.create(source_language_code: source_language_code, target_language_code: target_language_code) }

    context 'With valid parameters, without glossary ID' do
      before do
        post '/api/v1/translations', params: {
          source_language_code: source_language_code,
          target_language_code: target_language_code,
          source_text: source_text
        }
      end

      it 'returns a created status' do
        expect(response).to have_http_status(:created)
      end

      it 'returns the created attributes' do
        expect(json['translation']).to include(
          "glossary_id"  => principal_glossary.id,
          "source_text" => source_text
        )
      end      
    end

    context 'With invalid parameters' do
      before do
        post '/api/v1/translations', params: {
          source_language_code: '',
          target_language_code: ''
        }
      end

      it "returns a 'bad request' status" do
        expect(response).to have_http_status(:bad_request)
      end

      it "returns an error for each invalid attribute" do
        expect(json['error']).to include(
          'source_language_code does not have a valid value', 
          'target_language_code does not have a valid value',
          'source_text is missing'
        )
      end      
    end

    context 'When source text exceeds character limit' do
      source_text_char_limit = Translation.source_text_char_limit

      before do
        post '/api/v1/translations', params: {
          source_language_code: source_language_code,
          target_language_code: target_language_code,
          glossary_id: principal_glossary.id,
          source_text: SecureRandom.alphanumeric(source_text_char_limit + 1)
        }
      end

      it "returns an 'unprocessable entity' status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end     
      
      it "returns a max-length error for source_text" do
        expect(json['error']).to include('Source text is too long.')
      end
    end

    context 'With non-matching glossary ID and language codes' do
      unused_source_language_code = (Glossary::AVAILABLE_LANGUAGE_CODES - ([]<<source_language_code)).sample
      unused_target_language_code = (Glossary::AVAILABLE_LANGUAGE_CODES - ([]<<target_language_code)).sample

      before do
        post '/api/v1/translations', params: {
          source_language_code: unused_source_language_code,
          target_language_code: unused_target_language_code,
          source_text: source_text,
          glossary_id: principal_glossary.id
        }
      end

      it "returns a 'not found' status" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
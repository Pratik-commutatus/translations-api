require 'rails_helper'

RSpec.describe 'Glossaries', type: :request do
  describe '.create' do
    source_language_code = Glossary.available_language_codes.sample
    target_language_code = Glossary.available_language_codes.sample

    let!(:principal_glossary) { Glossary.create(source_language_code: source_language_code, target_language_code: target_language_code) }

    context 'With valid parameters' do

      unused_source_language_code = (Glossary.available_language_codes - ([]<<source_language_code)).sample
      unused_target_language_code = (Glossary.available_language_codes - ([]<<target_language_code)).sample

      before do
        post '/api/v1/glossaries', params: {
          source_language_code: unused_source_language_code,
          target_language_code: unused_target_language_code
        }
      end

      it 'returns the source_language_code' do
        expect(json['glossary']['source_language_code']).to eq(unused_source_language_code)
      end

      it 'returns the target_language_code' do
        expect(json['glossary']['target_language_code']).to eq(unused_target_language_code)
      end

      it 'returns a created status' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'With an existing language codes combination' do
      before do
        post '/api/v1/glossaries', params: {
          source_language_code: source_language_code,
          target_language_code: target_language_code
        }
      end

      it "returns an 'unprocessable entity' status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'With invalid parameters' do
      before do
        post '/api/v1/glossaries', params: {
          source_language_code: '',
          target_language_code: 'xx'
        }
      end

      it "returns a 'bad request' status" do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error for source_language_code' do
        expect(json['error']).to include('source_language_code does not have a valid value')
      end

      it 'returns an error for target_language_code' do
        expect(json['error']).to include('target_language_code does not have a valid value')
      end
    end
  end
end

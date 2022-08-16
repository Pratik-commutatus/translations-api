require 'rails_helper'

RSpec.describe 'Gloassaries', type: :request do
  source_language_code = Glossary.available_language_codes.sample
  target_language_code = Glossary.available_language_codes.sample

  describe '.find' do
  
    let!(:principal_glossary) { Glossary.create(source_language_code: source_language_code, target_language_code: target_language_code) }

    context 'With valid parameters' do
      before { get "/api/v1/glossaries/#{principal_glossary.id}" }

      it "returns a 'success' status" do
        expect(response).to have_http_status(:success)
      end

      it 'returns the specified source_language_code value' do
        expect(json['glossary']['source_language_code']).to eq(source_language_code)
      end

      it 'returns the specified target_language_code value' do
        expect(json['glossary']['target_language_code']).to eq(target_language_code)
      end

      it 'returns an array of associated terms' do
        expect(json['glossary']['terms']).to be_an(Array) 
      end
    end

    context 'When trying to fetch with an ID that does not exist' do
      before { get "/api/v1/glossaries/#{principal_glossary.id+1}" }

      it "returns a 'not_found' error status" do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'With an invalid ID parameter' do
      before { get '/api/v1/glossaries/!' }

      it "returns a 'bad_request' error status" do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe '.that_have_terms' do
    context 'When glossaries are present' do

      let!(:principal_glossary) { Glossary.create(source_language_code: source_language_code, target_language_code: target_language_code) }
      let!(:principal_glossary_term) {principal_glossary.terms.create(source_term: 'hello', target_term: 'hola')}

      before { get '/api/v1/glossaries' }
      
      it "returns a 'success' status" do
        expect(response).to have_http_status(:success)
      end

      it 'returns a glossaries array' do
        expect(json['glossaries']).to be_an(Array) 
      end

      it 'returns an array with atleast one object' do
        expect(json['glossaries'].size).to be > 0
      end
    end

    context 'When glossaries are not present' do
      before { get '/api/v1/glossaries' }
      
      it "returns a 'success' status" do
        expect(response).to have_http_status(:success)
      end

      it 'returns a glossaries array' do
        expect(json['glossaries']).to be_an(Array) 
      end

      it 'returns an empty array' do
        expect(json['glossaries'].size).to be == 0
      end
    end
  end
end
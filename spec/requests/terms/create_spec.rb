require 'rails_helper'

RSpec.describe 'Terms', type: :request do
  describe '.create' do
    source_language_code = Glossary::AVAILABLE_LANGUAGE_CODES.sample
    target_language_code = Glossary::AVAILABLE_LANGUAGE_CODES.sample
    source_term = 'term-first'
    target_term = 'term-last'

    let!(:principal_glossary) { Glossary.create(source_language_code: source_language_code, target_language_code: target_language_code) }

    context 'With valid parameters' do
      before do
        post "/api/v1/glossaries/#{principal_glossary.id}/terms", params: {
          source_term: source_term,
          target_term: target_term
        }
      end

      it "returns a 'created' status" do
        expect(response).to have_http_status(:created)
      end

      it 'returns the ID of parent glossary object' do
        expect(json['term']['glossary_id']).to eq(principal_glossary.id)
      end

      it 'returns the source_term provided' do
        expect(json['term']['source_term']).to eq(source_term)
      end

      it 'returns the target_term provided' do
        expect(json['term']['target_term']).to eq(target_term)
      end
    end

    context 'With invalid parameters' do
      before do
        post "/api/v1/glossaries/#{principal_glossary.id}/terms", params: {
          source_term: '',
          target_term: '',
        }
      end

      it "returns an 'unprocessable entity' status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns an en error for source_term" do
        expect(json['error']).to include("Source term can't be blank")
      end

      it "returns an en error for target_term" do
        expect(json['error']).to include("Target term can't be blank")
      end
    end

    context 'With invalid glossary ID' do
      before do
        post "/api/v1/glossaries/#{principal_glossary.id+1}/terms", params: {
          source_term: source_term,
          target_term: target_term,
        }
      end

      it "returns a 'not found' status" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
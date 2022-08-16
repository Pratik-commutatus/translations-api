require 'grape-swagger'
module TranslationsAPI
  class Root < Grape::API
    rescue_from ActiveRecord::RecordNotFound do |e|
      error_response(message: e.message, status: 404)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      error_response(message: e.message, status: 422)
    end

    rescue_from ActiveRecord::StatementInvalid do |e|
      error_response(messae: e.message, status: 422)
    end

    rescue_from ActiveRecord::RecordNotUnique do |e|
      error_response(message: e.message, status: 422)
    end

    mount TranslationsAPI::V1::Glossaries
    mount TranslationsAPI::V1::Translations
  end
end
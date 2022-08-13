Rails.application.routes.draw do 
  mount TranslationsAPI::API  => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'

  get 'health/index'
end

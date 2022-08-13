module TranslationsAPI
  class API < Grape::API
    format :json
    prefix :api

    mount TranslationsAPI::Root

    add_swagger_documentation \
      mount_path: '/docs',
      info: {title: 'Translations API'}
  end
end
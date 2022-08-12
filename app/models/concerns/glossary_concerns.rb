module GlossaryConcerns
  extend ActiveSupport::Concern
  require 'csv'

  class_methods do
    def available_language_codes
      file_data = CSV.open('imports/language-codes.csv', headers: :first_row).map(&:to_h)
      language_codes_array = file_data.map {|h| h['code']}
    end
  end
end
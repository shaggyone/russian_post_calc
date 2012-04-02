# coding: UTF-8
require "russian_post_calc/version"
require "net/http"
require "nokogiri"

module RussianPostCalc
  extend ActiveSupport::Concern

  ACTION_URL           = "http://russianpostcalc.ru/"
  MAGIC_FIELD          = "russianpostcalc"
  FROM_INDEX_FIELD     = "from_index"
  TO_INDEX_FIELD       = "to_index"
  WEIGHT_FIELD         = "weight"
  DECLARED_VALUE_FIELD = "ob_cennost_rub"
  # Other field for future use:
  #   "from_country"                          => "RU",
  #   "from_city"                             => "",
  #   "from_state"                            => "",
  #   "to_country"                            => "RU",
  #   "to_city"                               => "",
  #   "to_state"                              => "",

  READ_PRICE_REGEX = /Доставка\s+Почтой\s+России:\s+([\d\.]+)\s+руб./

  module ClassMethods

    # Calculates delivery price from sender to destination.
    #
    # @param [String] sender_post_code
    # @param [String] destination_post_code
    # @param [Float]  weight                Weight of the box in kilograms.
    # @param [Float]  declared_value        Declared value of the box [RUR]
    #
    # @return [Float] Delivery price [RUR].
    def calculate_delivery_price sender_post_code, destination_post_code, weight, declared_value = 0
      uri = URI.parse(::RussianPostCalc::ACTION_URL)
      response = Net::HTTP.post_form uri,
          ::RussianPostCalc::MAGIC_FIELD          => 1,
          ::RussianPostCalc::FROM_INDEX_FIELD     => sender_post_code,

          ::RussianPostCalc::TO_INDEX_FIELD       => destination_post_code,
          ::RussianPostCalc::WEIGHT_FIELD         => weight,
          ::RussianPostCalc::DECLARED_VALUE_FIELD => declared_value

      # Parse response for nokogiri.
      doc = Nokogiri::HTML(response.body)

      # If error was returned
      unless (node = doc.css("#content .errors")).empty?
        raise node.css("ul li").text.strip
      end

      ::RussianPostCalc::READ_PRICE_REGEX.match(doc.css('#content').text)[1].to_f
    end
  end
end

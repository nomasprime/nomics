# frozen_string_literal: true

module Nomics
  class Api
    class V1
      class Currencies
        def initialize(client:)
          self.client = client
        end

        def ticker(
          attributes: nil,
          ids: nil
        )
          response = client.get(
            path: "v1/currencies/ticker",
            params: { ids: serialize_attribute(ids) }
          )

          filter_attributes(response, attributes)
        end

        def metadata(
          attributes: nil,
          ids: nil
        )
          client.get(
            path: "v1/currencies",
            params: {
              attributes: serialize_attribute(attributes),
              ids: ids.join(",")
            }
          )
        end

        def sparkline(
          convert: nil,
          ids: nil,
          start: (DateTime.now - 1).rfc3339
        )
          client.get(
            path: "v1/currencies/sparkline",
            params: {
              convert: convert,
              ids: serialize_attribute(ids),
              start: start
            }
          )
        end

        private

        attr_accessor :client

        def filter_attributes(response, attributes)
          return response unless attributes

          response.map do |hash|
            hash.select do |key, _value|
              attributes.include? key
            end
          end
        end

        def serialize_attribute(attribute)
          return attribute unless attribute

          attribute.join(",")
        end
      end
    end
  end
end

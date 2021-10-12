# frozen_string_literal: true

module Nomics
  class Api
    class V1
      def initialize(client:)
        self.client = client
      end

      def currencies
        @currencies ||= Currencies.new(client: client)
      end

      private

      attr_accessor :client
    end
  end
end

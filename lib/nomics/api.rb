# frozen_string_literal: true

module Nomics
  class Api
    extend Forwardable

    def_delegators :v1, :currencies

    def initialize(client:)
      self.client = client
    end

    private

    attr_accessor :client

    def v1
      @v1 ||= V1.new(client: client)
    end
  end
end

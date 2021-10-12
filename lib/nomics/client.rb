# frozen_string_literal: true

module Nomics
  class Client
    class ResponseError < StandardError; end

    extend Forwardable

    def_delegators(
      :api,
      :currencies
    )

    def initialize(
      host:,
      params: {}
    )
      self.host = host
      self.params = params
    end

    def get(path: "", params: {})
      request(method: :get, path: path, params: params)
    end

    private

    attr_accessor :host, :params

    def api
      @api ||= Api.new(client: self)
    end

    # rubocop:disable Metrics/MethodLength
    def request(method:, path: "/", params: {}, body: "")
      body = { request: body }.to_json unless body.empty?
      params = params.merge(send(:params)).compact

      response = Typhoeus.public_send(
        method,
        url(path),
        headers: { "Content-Type": "application/json" },
        params: params,
        body: body
      )

      raise ResponseError, "#{response.code}: #{response.body}" if [*0..199, *300..403,
                                                                    *405..599].include? response.code

      JSON.parse(response.body, symbolize_names: true)
    rescue JSON::ParserError
      response.body
    end
    # rubocop:enable Metrics/MethodLength

    def url(path)
      "#{host}/#{path}"
    end
  end
end

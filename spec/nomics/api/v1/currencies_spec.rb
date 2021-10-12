# frozen_string_literal: true

module Nomics
  class Api
    class V1
      RSpec.describe Currencies do
        subject(:currencies) { described_class.new(client: Client.new(host: "http://test")) }

        let(:client) { Client.new(**client_args) }
        let(:client_args) { { host: "http://test" } }

        describe "#ticker" do
          subject(:ticker) { currencies.ticker(**ticker_args) }

          let(:ticker_args) do
            {
              ids: %w[
                BTC
                XRP
                ETH
              ]
            }
          end

          it "makes correct request" do
            stub = stub_request(:get, "#{client_args[:host]}/v1/currencies/ticker").with(
              query: { ids: ticker_args[:ids].join(",") }
            )

            ticker

            expect(stub).to have_been_requested
          end

          context "with attributes" do
            let(:ticker_args) do
              {
                attributes: %i[
                  circulating_supply
                  max_supply
                  name
                  symbol
                  price
                ],
                ids: %w[
                  BTC
                  ETH
                ]
              }
            end

            it "filters response by attributes" do
              stub_request(:get, "#{client_args[:host]}/v1/currencies/ticker")
                .with(
                  query: { ids: ticker_args[:ids].join(",") }
                )
                .to_return(
                  body: [
                    {
                      id: "BTC",
                      currency: "BTC",
                      symbol: "BTC",
                      name: "Bitcoin",
                      logo_url: "https://s3.us-east-2.amazonaws.com/nomics-api/static/images/currencies/btc.svg",
                      status: "active",
                      price: "56688.68913684",
                      price_date: "2021-10-12T00:00:00Z",
                      price_timestamp: "2021-10-12T15:26:00Z",
                      circulating_supply: "18841781",
                      max_supply: "21000000",
                      market_cap: "1068115865893",
                      market_cap_dominance: "0.4126",
                      num_exchanges: "392",
                      num_pairs: "66076",
                      num_pairs_unmapped: "5168",
                      first_candle: "2011-08-18T00:00:00Z",
                      first_trade: "2011-08-18T00:00:00Z",
                      frst_order_book: "2017-01-06T00:00:00Z",
                      rank: "1",
                      rank_delta: "0",
                      high: "63661.34963610",
                      high_timestamp: "2021-04-13T00:00:00Z"
                    },
                    {
                      id: "XRP",
                      currency: "XRP",
                      symbol: "XRP",
                      name: "XRP",
                      logo_url: "https://s3.us-east-2.amazonaws.com/nomics-api/static/images/currencies/XRP.svg",
                      status: "active",
                      price: "1.09381206",
                      price_date: "2021-10-12T00:00:00Z",
                      price_timestamp: "2021-10-12T15:26:00Z",
                      circulating_supply: "46805773456",
                      max_supply: "100000000000",
                      market_cap: "51196719668",
                      market_cap_dominance: "0.0198",
                      num_exchanges: "260",
                      num_pairs: "1766",
                      num_pairs_unmapped: "55",
                      first_candle: "2013-05-09T00:00:00Z",
                      first_trade: "2013-05-09T00:00:00Z",
                      first_order_book: "2018-08-29T00:00:00Z",
                      rank: "7",
                      rank_delta: "0",
                      high: "2.75739571",
                      high_timestamp: "2018-01-07T00:00:00Z"
                    }
                  ].to_json
                )

              expect(ticker).to eql(
                [
                  {
                    circulating_supply: "18841781",
                    max_supply: "21000000",
                    name: "Bitcoin",
                    price: "56688.68913684",
                    symbol: "BTC"
                  },
                  {
                    circulating_supply: "46805773456",
                    max_supply: "100000000000",
                    name: "XRP",
                    price: "1.09381206",
                    symbol: "XRP"
                  }
                ]
              )
            end
          end
        end

        describe "#metadata" do
          subject(:metadata) { currencies.metadata(**metadata_args) }

          let(:metadata_args) do
            {
              ids: %w[
                ETH
                BTC
              ],
              attributes: %w[
                id
                name
                logo_url
              ]
            }
          end

          it "makes correct request" do
            stub = stub_request(:get, "#{client_args[:host]}/v1/currencies").with(
              query: {
                attributes: metadata_args[:attributes].join(","),
                ids: metadata_args[:ids].join(",")
              }
            )

            metadata

            expect(stub).to have_been_requested
          end
        end

        describe "#sparkline" do
          subject(:sparkline) { currencies.sparkline(**sparkline_args) }

          let(:start_arg) { (DateTime.now - 1).rfc3339 }

          let(:sparkline_args) do
            {
              convert: "USD",
              ids: %w[
                ETH
                BTC
              ],
              start: start_arg
            }
          end

          it "makes correct request" do
            stub = stub_request(:get, "#{client_args[:host]}/v1/currencies/sparkline").with(
              query: {
                convert: sparkline_args[:convert],
                ids: sparkline_args[:ids].join(","),
                start: start_arg
              }
            )

            sparkline

            expect(stub).to have_been_requested
          end
        end
      end
    end
  end
end

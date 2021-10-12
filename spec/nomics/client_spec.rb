# frozen_string_literal: true

module Nomics
  RSpec.describe Client do
    subject(:client) { described_class.new(**client_args) }

    let(:client_args) do
      {
        host: "http://test"
      }
    end

    shared_examples "a request" do |method|
      it "makes a request to a host" do
        stub = stub_request(method, client_args[:host])
        client.public_send(method)

        expect(stub).to have_been_requested
      end

      it "add content type header" do
        stub = stub_request(method, client_args[:host]).with(
          headers: {
            "Content-Type": "application/json"
          }
        )

        client.public_send(method)

        expect(stub).to have_been_requested
      end

      context "with JSON body" do
        before do
          stub_request(method, client_args[:host]).to_return(
            body: body_args.to_json
          )
        end

        let(:body_args) do
          {
            response: {
              reason_code: "ACODE",
              reason_text: "sometext",
              key1: "value1"
            }
          }
        end

        it "translates response into Ruby" do
          expect(client.public_send(method)).to eq(body_args)
        end
      end

      context "with empty body" do
        before { stub_request(method, client_args[:host]).to_return(body: "") }

        it "translates response into Ruby" do
          expect(client.public_send(method)).to eql ""
        end
      end

      context "with not found status" do
        before { stub_request(method, client_args[:host]).to_return(status: 404) }

        it "returns nil" do
          expect(client.public_send(method)).to eql ""
        end
      end

      context "with invalid response status" do
        before { stub_request(method, client_args[:host]).to_return(status: response_status) }
        let(:response_status) { [*0..199, *300..403, *405..599].sample }

        it "raises an error" do
          expect { client.public_send(method) }.to raise_error(Client::ResponseError)
        end
      end

      context "with client params" do
        before { client_args[:params] = { some_param: "somevalue" } }

        it "makes a request with those params" do
          stub = stub_request(method, client_args[:host]).with(
            query: hash_including({ some_param: "somevalue" })
          )

          client.public_send(method)

          expect(stub).to have_been_requested
        end
      end
    end

    describe "#currencies" do
      subject(:currencies) { client.currencies }

      it { is_expected.to be_an_instance_of(Api::V1::Currencies) }
      it { is_expected.to equal(subject) }
    end

    describe "#get" do
      subject(:get) { client.get(**args) }

      it_behaves_like "a request", :get

      it "should not send body" do
        stub = stub_request(:get, client_args[:host]).with(
          body: nil
        )

        client.get

        expect(stub).to have_been_requested
      end

      context "with body param" do
        let(:params) { { body: "something" } }

        it "raises an error" do
          expect { client.get(params) }.to raise_error ArgumentError
        end
      end

      context "with params" do
        let(:args) do
          {
            params: {
              test: "value"
            }
          }
        end

        it "adds params to URL" do
          stub = stub_request(:get, client_args[:host]).with(
            query: hash_including(args[:params])
          )

          get

          expect(stub).to have_been_requested
        end
      end

      context "with nil params" do
        let(:args) do
          {
            params: {
              test: "value",
              other: nil
            }
          }
        end

        it "subtracts nil params from URL" do
          stub = stub_request(:get, client_args[:host]).with(
            query: hash_including(args[:params].compact)
          )

          get

          expect(stub).to have_been_requested
        end
      end
    end
  end
end

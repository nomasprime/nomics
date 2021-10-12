# frozen_string_literal: true

module Nomics
  RSpec.describe Api do
    subject(:api) { described_class.new(client: double("client")) }

    describe "#currencies" do
      subject(:currencies) { api.currencies }

      it { is_expected.to be_an_instance_of(described_class::V1::Currencies) }
      it { is_expected.to equal(subject) }
    end
  end
end

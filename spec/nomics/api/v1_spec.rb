# frozen_string_literal: true

module Nomics
  class Api
    RSpec.describe V1 do
      subject(:v1) { described_class.new(client: double("client")) }

      describe "#currencies" do
        subject(:currencies) { v1.currencies }

        it { is_expected.to be_an_instance_of(described_class::Currencies) }
        it { is_expected.to equal(subject) }
      end
    end
  end
end

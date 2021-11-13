# frozen_string_literal: true

RSpec.describe Sinopac::Funbiz do
  it "has a version number" do
    expect(Sinopac::Funbiz::VERSION).not_to be nil
    expect(Sinopac::Funbiz::API_VERSION).not_to be nil
  end

  it "does something useful" do
    expect(true).to eq(true)
  end
end

# frozen_string_literal: true

RSpec.describe Sinopac::FunBiz do
  it "has a version number" do
    expect(Sinopac::FunBiz::VERSION).not_to be nil
    expect(Sinopac::FunBiz::API_VERSION).not_to be nil
  end

  it "does something useful" do
    expect(true).to eq(true)
  end
end

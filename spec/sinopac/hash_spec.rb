RSpec::describe Sinopac::FunBiz::Hash do
  it "can calculate XOR value for two strings" do
    a1 = "65960834240E44B7"
    a2 = "2831076A098E49E7"

    result = Sinopac::FunBiz::Hash.string_xor(str1: a1, str2: a2)

    expect(result).to eq "4DA70F5E2D800D50"
  end

  it "can calculate hash id with given hashes" do
    a1 = "65960834240E44B7"
    a2 = "2831076A098E49E7"
    b1 = "CB1AFFBF915A492B"
    b2 = "7F242C0AA612454F"

    result = Sinopac::FunBiz::Hash.hash_id(a1: a1, a2: a2, b1: b1, b2: b2)

    expect(result).to eq "4DA70F5E2D800D50B43ED3B537480C64"
  end
end

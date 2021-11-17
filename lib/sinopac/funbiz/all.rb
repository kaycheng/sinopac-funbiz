[
  "sinopac/funbiz/version",
  "sinopac/funbiz/hash",
  "sinopac/funbiz/nonce",
].each do |mod|
  begin
    require mod
  rescue LoadError
  end
end
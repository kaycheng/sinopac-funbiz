[
  "sinopac/funbiz/version",
  "sinopac/funbiz/hash",
].each do |mod|
  begin
    require mod
  rescue LoadError
  end
end
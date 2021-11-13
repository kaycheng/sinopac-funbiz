[
  "sinopac/funbiz/version",
].each do |mod|
  begin
    require mod
  rescue LoadError
  end
end
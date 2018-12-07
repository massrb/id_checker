Gem::Specification.new do |s|
  s.name = 'id_checker'
  s.version = "0.1.2"
  s.date = '2018-12-07'
  s.summary = 'check for duplicate ids in CSV'
  s.files = [
    "lib/id_checker.rb"
  ]
  s.homepage = 'https://github.com/massrb/id_checker'
  s.authors = ['L Guild']
  s.require_paths = ["lib"]
  s.add_dependency("phonetic")
end
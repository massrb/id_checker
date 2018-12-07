# id_checker

## Basic Install
```
gem install specific_install
gem specific_install -l  https://github.com/massrb/id_checker.git

```

## Run

```
require 'id_checker'

Path = '/mnt/share/validity/advanced.csv'

result = IdChecker::FileReader.read(Path)

data = result.data

puts result.out

```
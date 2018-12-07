require 'csv'
require 'phonetic'

module IdChecker

  class ResultSet

  	def initialize(attr)
  	  @out = attr[:out]
  	  @data = attr[:data]
    end

    def out
      @out
    end

    def data
      @data
    end

  end

  class FileReader
    def self.read(fpath)
      out = ''
      map = {}
      data = {uniq: [], dup: []}

	  CSV.foreach(fpath, :headers => true) do |row|
		ky = row['first_name'].metaphone + row['last_name'].metaphone
		row_el = {} 
		row.headers.each{|fld| row_el[fld] = row[fld]}
		map[ky] = map[ky] ? map[ky].push(row_el) : [row_el]  
	  end

	  map.keys.each do |element|
	    if map[element].length > 1
	  	  data[:dup] << map[element]
	      out << 'dupes:' + map[element].inspect + "\n\n"
	    else
	      data[:uniq] << map[element][0]    
	    end
	  end

      out << "UNIQUE:\n\n" + data[:uniq].join("\n\n")
      out << "\n\n=============================\n\n"
      out << "DUPLICATES:\n\n" + data[:dup].join("\n\n")
      ResultSet.new(data: data, out: out)
    end
  end
end
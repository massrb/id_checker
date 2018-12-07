

require 'csv'
require 'phonetic'

module IdChecker

  class Row

    def to_hash
      @row
    end

    def phone
      @row['phone']
    end

    def email
      @row['email']
    end

    def addr
      @row['address'].to_s + @row['city'].to_s + @row['zip'].to_s
    end 

    def initialize(csv_row)
      @row = {} 
      csv_row.headers.each{|fld| @row[fld] = csv_row[fld]}
    end

    def [](ind)
      @row[ind]
    end
  end
 
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


   def self.match_el(el, rows) 
    matched = false
    rows.each do |row|
      if el.phone == row.phone
        matched = true
      elsif el.addr == row.addr
        matched = true
      elsif el.phone == row.email
        matched = true
      end
    end
    matched = true if !matched && el.phone.blank? && el.addr.blank? && el.email.blank? 
    matched
  end
     

  def self.read(fpath)
    out = ''
    map = {}
    data = {uniq: [], dup: []}

    CSV.foreach(fpath, :headers => true) do |row|
      ky = row['first_name'].metaphone + row['last_name'].metaphone
      row_el = Row.new(row)
      if map[ky] && match_el(row_el, map[ky])
        map[ky].push(row_el)
      else
        map[ky] = [row_el]
      end
    end

     map.keys.each do |element|
      if map[element].length > 1
        data[:dup] << map[element].map(&:to_hash)
      else
        data[:uniq] << map[element][0].to_hash    
      end
      end

    out << "UNIQUE:\n\n" 
    data[:uniq].each{|r| out << r.to_yaml + "\n\n"}
    out << "\n\n=============================\n\n"
    out << "DUPLICATES:\n\n"
    data[:dup].each_with_index do |ar,idx|
      out << "Duplicate set #{idx.to_s}:\n\n"
      ar.each{|r| out << r.to_yaml + "\n\n"}
    end 
    ar = data[:uniq]
    check = ar.map{|el| el['id']}.detect{|e| ar.rindex(e) != ar.index(e)}
    out << "\n\nFAILED FOR ID #{check} ! ! !" if check
    ResultSet.new(data: data, out: out)
   end
  end
end


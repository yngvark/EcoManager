require 'fileutils'

class LineInserter
	
  @@temp_filename = "file_23f234f.tmp"

	def initialize(filename)
		@filename = filename
	end

  def overwrite(search_for, strings)
    @search_for = search_for
    @strings = strings

    temp_file=File.open(@@temp_filename, 'w')
    file=File.new(@filename)
    edit(temp_file, file)
    file.close
    temp_file.close

    FileUtils.mv(@@temp_filename, @filename)
  end


  private


  def edit(temp_file, file)
    overwrite = false
    overwritten_lines = 0

    file.each do |line|

      if line.include?(@search_for)
        overwrite = true
      end

      if overwrite && overwritten_lines < @strings.length
        line = @strings[overwritten_lines]
        overwritten_lines += 1
      end

      temp_file << line

    end
  end
  
end

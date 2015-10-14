module NewsHelper

  def check_links(link, conditions)
    result = true

    conditions.each do |condition|
      if link.include? condition
        result = false
        break
      end
    end

    result
  end

end

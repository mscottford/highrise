module Highrise
  # Access upcoming, assigned and completed tasks by calling find with the corresponding :from value.
  #    find(:all, :from => :upcoming)
  #    find(:all, :from => :assigned)  
  #    find(:all, :from => :completed)  
  class Task < Base
    def complete!
      load_attributes_from_response(post(:complete))
    end
  end
end
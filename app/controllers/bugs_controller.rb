class BugsController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  
  def show
    @bug = Bug.find(params[:id])
  end
  
  def index 
    @bugs = Bug.all
    
    @logs = Log.all 
  end
  
  
  def new
   @bug = Bug.new
  end
  
  def create #taken from the POST form method of new.html
    @bug = Bug.new(bug_params) 
    if @bug.save #handle a successful save
    
    #add log entry for 'create' and save 
    @log_entry = Log.new
    
    time1 = Time.new.to_s
    @log_entry.a_log = time1 + "| " + current_user.name + " created Bug ID: " + @bug.id.to_s 
    @log_entry.save
    
   @bug.update_attribute(:done, false)
  
    redirect_to @bug
    else
      render 'new'
    end
  end
  
  def edit
    @bug = Bug.find(params[:id])
     
  end  
    
  def update
    @bug = Bug.find(params[:id])
    
    #Store 'past state' bug information here 
    @past_bug = @bug.dup
    changed_states = ""
    
    if @bug.update_attributes(bug_params)
      # Handle a successful update.
    
      if @bug.name != @past_bug.name
      changed_states += "NAME: [" + @past_bug.name + " -> " + @bug.name + "] "
      end
      if @bug.description != @past_bug.description
      changed_states += " [updated description] "
      end
      if @bug.precedense != @past_bug.precedense
      changed_states += "PRECEDENSE: [" + @past_bug.precedense + " -> " + @bug.precedense + "] "
      end
          
    #add log entry for 'update' and save 
    @log_entry = Log.new
    time1 = Time.new.to_s
    @log_entry.a_log = time1 + "| " + current_user.name + " updated Bug ID: " + @bug.id.to_s + " CHANGED: " + changed_states
    @log_entry.save
      
      
      redirect_to @bug
    else
      render 'edit'
    end
  end
  
  def destroy
    @bug = Bug.find(params[:id])
  
    @log_entry = Log.new
    time1 = Time.new.to_s
    @log_entry.a_log = time1 + "| " + current_user.name + " deleted Bug ID: " + @bug.id.to_s 
    @log_entry.save
  
    
    @bug.destroy
    flash[:success] = "Bug deleted"
    
    
    redirect_to bugs_url
  end
    
  def close
    @bug = Bug.find(params[:id])
    @bug.done = true
    
    redirect_to bugs_url
  end
  
    private
  
   def bug_params
    params.require(:bug).permit(:name,:precedense,:description, :done)
   end
  
end

#generates a Chef paste config template for the specified variable names
define :generate_paste_template do

  ruby_block "customize #{params[:package]} paste config" do
    block do
      data = IO.read(params[:source])
      params[:variables].each_pair do |name, value|
        #NOTE: value isn't used here since we are just generating a template
        regex = Regexp.new("^#{name}.*")
        data.sub!(regex, "#{name} = <%= @#{name} %>")
      end
      File.open(params[:name], 'w') {|f| f.write(data) }
    end
    action :create
  end

end

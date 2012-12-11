# Opscode recipes

remember this: https://github.com/websterclay/knife-github-cookbooks

and take a look at this: git://github.com/matschaffer/chef-loves-windows.git

Candidates are sql_express, powershell, (windows, chef_handler)
These are meant to be managed with `knife`:

    # -o, --cookbook-path PATH (we use ../.chef/knife.rb to set default cookbook path)
    # -B, --branch BRANCH

    knife cookbook site install sql_server
    # or
    knife cookbook site install sql_server -o opscodecookbooks

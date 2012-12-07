# Opscode recipes

Candidates are sql_express, powershell, (windows, chef_handler)
These are meant to be managed with `knife`:

    # -o, --cookbook-path PATH (we use ../.chef/knife.rb to set default cookbook path)
    # -B, --branch BRANCH

    knife cookbook site install sql_server
    # or
    knife cookbook site install sql_server -o opscodecookbooks

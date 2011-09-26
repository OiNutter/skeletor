Skeletor
========

Skeletor is a Ruby Library for setting up quick project skeletons based on code templates. It uses YAML templates to specify a directory structure of files and 
folders, a list of includes to pull and any tasks to run. It also contains built in templates

Installation
------------

	gem install skeletor
	
Usage
-----

Skeletor has 3 actions it can perform for you.  You can also call `skeletor -h|--help` to list the available functions.

###Build###

	skeletor build TEMPLATE [options]
	
This will build the project skeleton for you based on TEMPLATE.  It takes the following options

* `-d --directory DIRECTORY` Specifies the directory to build the skeleton in. If it doesn't exist Skeletor will create it for you. Defaults to the current directory.
* `-p --project PROJECT` Specifies the name of the project to use in output.  I also intend to add in the functionality to add include parsing so you can dynamically insert the project name.  Defaults to the directory name.

###Clean###

	skeletor clean [options]
	
Cleans the entire project directory.  A helper method to let you start again. Useful when creating you templates. Takes the following options

* `-d --directory` Specifies the directory to clean.  Defaults to the current directory.

###Validate###

	skeletor validate TEMPLATE
	
Validates that TEMPLATE is a valid YAML file and that it matches the expected schema (see below).

###Help###

	skeletor -h|--help TASK
	
Shows help information for TASK.

Templates
---------

###Creating Templates###

A Skeletor template is a YAML file in a folder with the same name as the file so for instance, a basic template on file would look like this:

	sample-template/
		- sample-template.yml
	
The yaml structure looks like this:

	directory_structure:
		-
			dirname:
				-
					subdir:
				-
					NESTEDFILE
		-
			FILENAME
	includes:
		FILENAME: path/to/file
		NESTEDFILE: remoteurloffile
	tasks:
		- TASKANDARGUMENTS
		- ANOTHERTASKANDARGUMENTS
		
It should match the following schema:

	sections:
      - name: directory_structure
        required: yes
    	type: Array
    	ok_empty: yes
        accepts:
          - directory_list
          - file_list
      - name: tasks
        required: no
        type: Array
        accepts: 
          - String
      - name: includes
        required: no
        type: Hash
        accepts:
          - String
    types:
      directory_list:
        type: Hash
        ok_empty: no
        accepts:
          - directory
      file_list:
        type: Array
        ok_empty: no
        accepts:
          - file
      directory:
        type: Array
        ok_empty: yes
        accepts:
          - empty
          - directory_list
          - file_list
      file:
        type: String


It contains 3 optional sections:

####directory_structure####

This is the main part of the template, but you can still leave it out if you just want skeletor to run tasks for you. In YAML parlance the directory_structure is a sequence 
that contains either sequences or mappings. What this basically means is that it can contain a list of directories and a list of files.  The directory lists are mappings as
well, with the directory name being the mapping name and the contents being another sequence defining a list of directories and/or a list of files.  The file list is a sequence
of strings that define the file names. If the filenames are not listed in the includes section blank files will be created, otherwise the include will be copied from the given location.
To specify an empty directory just create an empty mapping but remember to still put a space after the colon as YAML seems to be funny about parsing without that. You can use the built in
validate action to check your template and the build action will also validate the template on load.

####includes####

This is a mapping of filenames to include locations.  The include locations can be anywhere on disk or a remote location accessible through either HTTP or HTTPS. Generally I would recommend
storing these in subfolders in your template directory.

####tasks####

This denotes a list of tasks to run once the skeleton is set up. They are a string in the following format:

	task[, argument...]
	
So for example to call the built in git_init task the tasks section would look like this

	tasks:
		- git_init, <skeleton_path>
		
You can pass any arguments you want but there are 3 placeholders that can be used to populate with data from the skeleton:

* `<skeleton_path>` passes the location of the created skeleton to the task
* `<skeleton_project>` passes the project name to the task
* `<skeleton_template>` passes the name of the template used to the task
 
There are also 2 built in tasks:
 
* `git_init` Initializes a git repository in the newly created project
* `capify` Generates capistrano deployment files

The parser will look for built in tasks with the names supplied first so if you want to provide your own versions you will need to change the names. To supply your own tasks
put them in a `tasks.rb` file in the root of your template directory.

###Storing Templates###

You can store the templates anywhere you like and just pass the path to them to the function but for ease of use you can create a `.skeletor` folder in your home directory and
put your templates in a `templates` folder under that.  This way you just have to pass the template name and Skeletor will look here for the template.

###Supplied Templates###

Skeletor comes with 1 presupplied template but I'll be adding a few more as I have time.

* `js-lib` Creates a skeleton for a Javascript library.  This is based on the structure I use for most Javascript projects which is in turn based on the structures of libraries such
as Prototype and Scriptaculous.

Coming Soon
-----------

* Add rDoc comments so rubygems.org can generate proper documentation
* Add Tests
* More Templates
* Option to turn off or lessen output
* Include parsing
* Option to deal with file/folder existing conflicts.

Notes
-----

This is my first gem and my first major work with ruby, so I'd be really grateful for any constructive feedback, input, suggestions etc. Also if anybody wants to
contribute feel free, just check out the guidelines below (pretty standard stuff but it kinda makes sense).

Contributing to Skeletor
------------------------
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
---------

Copyright (c) 2011 OiNutter. See LICENSE.txt for
further details.


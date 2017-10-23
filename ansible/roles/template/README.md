ansible `template` role
==================

# Usage

```
- include_role:
	name: template
  vars:
	_template_src_dir: path #template files will be copied from here
	_template_tmp_dir: path #temporary templates folder where replaces will be performed
	_template_items:
		- orig_name: filename
		  dest_path: path #full path to destination, if you want to rename the file also include the dest filename
		  owner: dest_file_owner_user_name
		  replaces:
		  	- {srch: ____SRCH1____, replace: "replace value"}
		  	- {srch: ____SRCH2____, replace: "replace value"}
```

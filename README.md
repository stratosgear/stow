Working with stow
-----------------


* From within the `~/stow` directory
* `stow gimp`, for example, in order to create a symlink at `~/.config/GIMP`
  pointing at ~/stow/gimp/.config/GIMP`


In order to "stowify" an application:

* Create app name in ~/stow
* recreate under that directory a directory structure that you would like to recreate
    * The root directory under that `/stow/appname` would be created under `~`
* (I bet there is a stow command that can do all that on it own, that I'm stupid 
  enough to not know about)
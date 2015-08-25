# Version 2.0 #
## Released 11/12/2010 ##
  * Added [enhancement #3](http://code.google.com/p/crt-resync/issues/detail?id=3) to the [rets\_data\_fetch](UserManual#RETS_DATA_FETCH.md) component.  You can now define any number of parameters that can be passed in to the DMQL query from the command line.  See the [User Manual](UserManual.md) for more information about how to define and pass in parameters.  **IMPORTANT NOTE!**  This feature breaks backwards compatibility for people that used date entry parameters in prior versions of RESync.  Date parameters must be defined the same as any other parameter.
  * Added [enhancement #4](http://code.google.com/p/crt-resync/issues/detail?id=4) for the [rets\_data\_fetch](UserManual#RETS_DATA_FETCH.md) component.  This allows you to define the delimiter for your output file in the config file.  If the delimiter is not defined then ',' will be used.
  * Changed name of README to UserManual to avoid confusion.

# Version 1.5 #
## Released 06/24/2010 ##
  * Added [enhancement #1](http://code.google.com/p/crt-resync/issues/detail?id=1) to the [metadata](UserManual#METADATA.md) component.  List of tables for a resource and class now displays the data type.
  * Fixed [bug #2](http://code.google.com/p/crt-resync/issues/detail?id=2) for the [object\_fetch](UserManual#OBJECT_FETCH.md) component
  * Darwin executables now run on libRETS 1.5.1.
  * Due to changes that need to be made in libRETS for the Windows Ruby bindings, the Windows executables run on libRETS 1.4.1
  * Removed Linux executable download and added a build from source download.  This was done due to issues with the library incompatibilities with the version that I built vs. the Linux distributions in the field.
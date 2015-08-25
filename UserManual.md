# OVERVIEW #
Welcome to REsync, the bare bones get-you-your-data-quickly RETS client from the Center for REALTOR Technology.  REsync consists of 3 command-line programs that use YAML configuration files to conntect to a RETS server.  The [metadata](#METADATA.md) program is a simple RETS metadata browser, while [rets\_data\_fetch](#RETS_DATA_FETCH.md) is the program that will pull the data from the RETS server.  Finally the [object\_fetch](#OBJECT_FETCH.md) program pulls the object data like photos for the items downloaded in a data fetch.

## FEATURES ##
  * Simple Setup, one YAML configuration file is all you need.
  * Can be run from a scheduler or a cron job
  * Output in CSV.  This means you can use the many CSV to database mappers out there to get you data into your database easily.
  * Column headers can be either the RETS System Name or user defined.
  * Query Parameters.  REsync supports adding query parameters passed in via the command line.
  * Object download tool.  Can pull objects like photos from the RETS server.

## REQUIREMENTS ##
The binary releases are built using _rubyscript2exe_ and contain all the supporting libraries you need and should run out of the box with no dependencies.  Right now there are binary builds to Win32, Mac OSX (darwin) and Linux.

The source release contains all the ruby files you need to run the scripts in ruby

  * rets\_helper.rb
  * progressbar.rb
  * metadata.rb
  * rets\_data\_fetch.rb
  * object\_fetch.rb
  * zip library

You will need to have [Ruby](http://www.ruby-lang.org/) and [libRETS](http://www.crt.realtors.org/projects/rets/librets/), with the Ruby bindings, installed to run these scripts.

Some familiarity with [http://www.rets.org RETS](.md) is suggested.  In particular you should understand the concepts of Resource, Class, Lookup and System Names as well as how to build a simple DMQL query.  If you indeed to use [object\_fetch](#OBJECT_FETCH.md) you should understand how Get Object requests work.  If you need help in these areas, please go to the forums at http://www.rets.org.  Also available is the [Doozer DMQL Query Builder](http://code.google.com/p/crt-doozer/) which can be used to help build your DMQL queries.

## Component Programs ##

### METADATA ###
This program allows you to browse the metadata on a defined server.  This program will always display the following information

```
System ID: <System ID>
Description: <Description>
Comment: <Comment>
```

#### Usage ####

`metadata <configuration_yaml_file>`

Lists all of the Resources available.

```
Resources:
- <System Name> (<StandardName, <Visible Name>)
```


---


`metadata <configuration_yaml_file> <Resource System Name>`

Lists all of the Classes for the given Resource

```
Classes for <Resource>:
- <System Name> (<StandardName, <Visible Name>)
```


---


`metadata <configuration_yaml_file> <Resource System Name> <Class System Name>`

Lists all of the Tables for the given Resource and Class

```
Tables for <Resource>-<Class>:
- <System Name> (<Standard Name> <Short Name> (<Long Name>)) - Required: <Required Number>
```


---


`metadata <configuration_yaml_file> <Resource System Name> LOOKUPS`

Lists all of the Lookups for the given Resource

```
Lookups for <Resource>: 
- <System Name>(<Standard Name>)
```


---


`metadata <configuration_yaml_file> <Resource System Name> LOOKUPS <Lookup System Name>`

Lists all of the Lookup Values for the given Resource and Lookup

```
Lookup Types for <Resource>-<Lookup>(<Lookup Standard Name>):

Lookup value: <Value> (<Short Value>, <Long Value>)
```

### RETS\_DATA\_FETCH ###
This program allows you to pull data from a RETS server defined in a config file using the query information also defined there.  Parameters may be passed to the query using

#### Usage ####

`rets_data_fetch  <config file> parameter1=value1 parameter2=value2`

Pulls the data from the RETS server using the given config file.  The parameters passed in will replace the placeholders with the same parameter name with the respective value in the DMQL of the query.  See the [Configuration](#CONFIGURATION.md) section for details on parameter placeholders.

#### Output ####
  * All output is to standard out.
  * Format is of field delimited file, comma delimited is the default.
  * Redirect output to save to file.

Standard error will display progress information.
```
	Fetching X of Y items
Progress:      100% |oooooooooooooooooooooooooooooooooooooooooo| ETA:  00:00:00
Done!
```

### OBJECT\_FETCH ###
This program will perform get object requests based on the data in the config file as well as data inside the the CSV output of a prior [rets\_data\_fetch](#RETS_DATA_FETCH.md) request.

#### Usage ####

`object_fetch <config file> <CSV file from prior rets_data_fetch>`

Performs the get object request.  item\_id field in the config file will identify the column in the CSV file that contains the item ids for the request.

#### Output ####
For each object type defined in the config file, a zip file called <object type>.zip will be created.  In this zip file is a directory for each item id, and in that directory is all the objects of that type for the item.

Standard error will display the following progress information

```
Zipping <Object Type> to <Object Type>.zip
Progress:      100% |oooooooooooooooooooooooooooooooooooooooooo| ETA:  00:00:00
Done zipping <Object Type>.zip
DONE!
```

## CONFIGURATION ##
The configuration file is used by all components to connect to and query the RETS server.  It is a YAML file using the following layout.

```
#Stuff used by everyone
:rets_info: 
  :url: http://demo.crt.realtors.org:6103/rets/login
  :username: Joe
  :password: Schmoe
  :user_agent: CRT-Data-Fetch/1.0
  :user_agent_password: yourUserAgentPassword
  :user_agent_auth_interealty: yes
  :rets_version: 1.7.2
  :log_file: yourlogfile.log
  
#Stuff needed for rets_data_fetch 
:resource: Property
:delimiter: ; 
:class: RES
:limit: 100000
:select:
    - ListingID: ID
    - ListDate: Listing Date
    - ClosePrice: Final Sale Price
    - ListPrice
:dmql: (ListPrice=<<price>>+)

#Stuff used by object_fetch
:item_id: ID
:object_types:
    - Photo
```

  * **Rets Info Section: _:rets\_info:_**
    * _:url:_ the URL of the RETS server
    * _:username:_ the username to access the RETS server
    * _:password:_ the password for the user to access the RETS server
    * _:user\_agent:_ optional parameter that some RETS servers require for access
    * _:user\_agent\_password:_ optional parameter that some RETS servers require for access, only sent if _:user\_agent:_ is also sent.
    * _:user\_agent\_auth\_interealty:_ optional parameter that says to use the modified version of UA Auth supported by Interealty.  Defaults to no.
    * _:rets\_version:_ optional parameter to define the RETS version to use.  Allowed values: 1.5, 1.7 and 1.7.2.  Defaults to 1.5.
    * _:log\_file:_ where the details of the RETS interactions will be logged to. Optional and no logging is done if this parameter is not present.
  * **Delimiter: _:delimiter:_** The field delimiter to use in the output file, a comma is used if this is not defined.
  * **Resource: _:resource:_** The system name of the resource you are pulling data from
  * **Class: _:class:_** The system name of the class your are pulling data from
  * **Limit: _:limit:_** An optional parameter that can be used to pull a subset of the data requested.  Useful when constructing the query, it will allow you to not pull large data sets while at the same time seeing how many items matched your query since the output will tell you that it is pulling `<limit> of X items` where X is the total number of items that matched the query.
  * **Select Section: _:select:_** This is an array of the system names of the table (fields) you wish to pull from the resource and class.  If you just have the system name the column for that field will be the system name.  However if you use the format of `<SystemName>: <Mapping Name>` the column header for that field will be the mapping name.
  * **DMQL Section: _:dmql:_** The DQML query that controls what data is pulled from the RETS server.  You can define parameter place holders in the format of `<<parameter name>>`.  The [rets\_data\_fetch](#RETS_DATA_FETCH.md) section talks more about passing in parameters.
  * **Item ID: _:item\_id:_** The id in the list of selected fields that uniquely identifies an object.  This is used by [object\_fetch](#OBJECT_FETCH.md) to make it's get object requests.
  * **Object Types: _:object\_types:_** A list of the types of objects you wish to run GetObject requests for.  For each type a zipfile with the name `<object type>.zip` will be created.

Take a look at example\_config.yaml to get started.  The file is configured to connect to the demo RETS server.

## LOGGING ##
If you are having trouble, turn on logging by defining the logfile rets\_info parameter in the configuration file as discussed above. This will give wealth of information about what libRETS is doing to communicate with the RETS server.

## SUPPORT ##
If you need help, check out the discussion group for [REsync](http://groups.google.com/group/crt-resync-discuss).  Help with RETS can be obtained on at http://www.rets.org.
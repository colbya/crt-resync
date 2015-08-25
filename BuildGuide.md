# Introduction #

REsync uses the rubyscript2exe tool to create the self-contained executable.  In doing so it pulls in all the dependent libraries so that the executables can be run on a computer without Ruby or libRETS.  However, lower level library incompatibilities, often with the C libraries, can often cause an executable built with rubyscript2exe to not be runnable on some computers.  This problem is particularly prevalent with Linux distributions.  As a result, I no longer create self contained Linux executables for download and instead provide a download that can be used to create your own.  These instructions discuss how to build your own set REsync self-contained executables either Linux or OSX.

# Requirements #

Since you are going to be running the scripts through rubyscript2exe, you will need to have the machine you are building the executables on be able to run REsync as a Ruby script as described [here](RunningAsRubyScript#Requirements.md).

# Steps #
  1. Download the build from source archive.
  1. Uncompress and enter the resync-build-src directory
  1. Run build.sh

You should now see three executable files called metadata, rets\_data\_sync and object\_fetch.

# Deploying #

You can now run the executables on any computer without the need of installing Ruby or libRETS.  However, you should make sure that the machine that built the executables on and the ones that are running them on do not have incompatible libraries.
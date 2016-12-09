# Technologies

* [Discord Reason](https://facebook.github.io/reason/)
* [Mirage](https://mirage.io)
* [Xen](https://www.xenproject.org/)

## Reason

* Reason is a new interface to OCaml - a highly expressive dialect of the ML language featuring type inference and static type checking.
* It offers the tools to convert code transparently from Ocaml to Reason and from Reason to Ocaml.
* It can be installed either through npm or opam (the Ocaml package manager)

## Mirage

* MirageOS is a library operating system that constructs unikernels. Code can be developed on a normal OS such as Linux or MacOS X to a native binary and then compiled into a fully-standalone, specialised unikernel that runs under the Xen hypervisor.

* This means that we can create very lightweight applications that are imported directly on the hypervisor without the need of a virtual machine that will host it.
* camlOfreason binary size was 7.5mb
* MirageOS language of choice is Ocaml

## Xen

* Xen project is one of the most prominent open source enterprise level hypervisors.
* It is being used by many cloud providers and for the management of our Edingurgh virtual machines.
* Since 2014 it has native support Mirage unikernels.

# Why

This technology stack allows us to create very lightweight full applications. Ocaml is a robust and fast programming language.
All these combined with the small size of the unikernel and the fact that we do not need an intermediate operating system (as we would in case of a docker container) allows us to deploy unikernels a lot faster.


# Implementation details

## Client side

A reason app

## Server side

An ocaml server side app based on Mirage. It contains its own web server that accepts connections on an endpoint and responds with a json file, that is going to be consumed by the Reason client.

The architecture of it is:
```
Mirage ->
 config.ml ->
  handler ->
   dispatcher ->
    endpoint1 ->
     counter
```   


In order to build the project we use mirage to create the configuration files and then make:

```bash
mirage configure -t unix --kv_ro crunch --net socket
make
```
```bash
mirage configure -t unix --kv_ro crunch --dhcp false --net direct
make
```

```bash
mirage configure -t xen --kv_ro crunch --dhcp false --net direct
make
```


```bash
mirage configure -t xen --kv_ro crunch --dhcp true --net direct
make
```

After compilation then execution with
```bash
./mir-www
```
  

## Deployment system

The deployment system we are using is one of the [official vagrant](https://github.com/mirage/mirage-vagrant-vms) based systems released by the mirage project. It is semi automated (meaning that some of the automated parts do not work), based on:

* Ubuntu 14.04
* Xen 4.4
* Ocaml 4.02.3
* Reason 1.19.3
* Mirage 2.9.1


# Results

## Client side

## Server side

A mirage project can be compiled in a variety of ways. We have
* unix native
  * socket based networking (--net sock)
  * direct networking without dhcp (--dhcp false --net direct)
  * direct networking with dhcp (--dhcp true --net direct)
* xen
  * direct networking with dhcp (--dhcp true --net direct)

During development unix native with socked based networking is used. Any ocaml networking library will work, but we will be restricted to unix native mode with socket based networking.

If we want to use the xen networking backend, then we need to use the STACK_V4 (or STACK_V6) module, that provides xen with a tcp/ip stack. Anything else will fail to retrieve an IP, although it may be compiled and imported to Xen succesfully.


## Deployment system

The vagrant files released by mirage project, does not work very well. The converge fails, during vagrant up, but if we execute the scripts manually, eventually we get a system that has all the components.

Some manual steps are required to configure Xen bridge interface for networking.

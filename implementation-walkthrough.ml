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

This technology stack allows us to create very lightweight full applications. Ocaml is a robust and fast programming language. All these combined with the small size of the unikernel and the fact that we do not need an intermediate operating system (as we would in case of a docker container) allows us to deploy unikernels a lot faster.


# Implementation details

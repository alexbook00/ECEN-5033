# Homework 2, ECEN 5033

## How to run
You will need to install vagrant, directions can be found [here](https://www.vagrantup.com/downloads). You will also need a VM that is supported by Vagrant, information can be found [here](https://www.vagrantup.com/docs/providers).


Once the above requirements have been met, run the following command from within the main project directory:

```
$ vagrant up
```

You may need to run the same command once more after running it for the first time, as detailed in the output (Docker-related plugins are installed on the first run, and must be followed by a rerun).

Then, run the following command to enter the VM:

```
$ vagrant ssh default
```

Once in the VM, run the following command:

```
$ docker-compose up
```

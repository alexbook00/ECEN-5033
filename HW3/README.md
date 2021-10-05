# Homework 3, ECEN 5033

## How to run
You will need to install vagrant, directions can be found [here](https://www.vagrantup.com/downloads). You will also need a VM that is supported by Vagrant, information can be found [here](https://www.vagrantup.com/docs/providers).


Once the above requirements have been met, run the following command from within the main project directory:

```
$ vagrant up
```

Then, run the following command to enter the VM:

```
$ vagrant ssh default
```

Once in the VM, run the following command to initialize etcd and the registrator, as well as initialize the key/value pairs that track the current color and version:

```
$ ./startup.sh
```

Run the following command to initialize nginx and confd, as well as upgrade from version 0 to version 1, and from no color to blue.

```
$ ./upgrade.sh
```

Run the following command to output the message of version 1 of the Flask app.

```
$ curl "192.168.33.10:80" -w "\n"
```

Upgrade to version 2, switch colors.

```
$ ./upgrade.sh
```

Output the message of version 2 of the Flask app.

```
$ curl "192.168.33.10:80" -w "\n"
```

Upgrade to version 3, switch colors.

```
$ ./upgrade.sh
```

Output the message of version 3 of the Flask app.

```
$ curl "192.168.33.10:80" -w "\n"
```

## Shell Script

>The following documentation is made according to my understanding while practicing the follwoing tutorials[Shell Script!](https://www.shellscript.sh/). This is one of the most simple and descriptive tutorial on shell which I have found online.
>Anyone can follow or learn from it without any restriction. 

While creating a script through terminal instead of writing the codes in a file and running it using terminal the files permission is to be changed bfore it can be executed or run else it will require *root* login.
Use the following command to change the file permission to execute the file locally.

```shell
$ chmod 755 my-script.sh
```

where *my-script.sh* is the file name.

Now we will write a simple *Hello World* script code in terminal and execute it to print an output **Hello World**

```shell
$ echo '#!/bin/sh' > my-script.sh
$ echo 'echo Hello World' >> my-script.sh
$ chmod 755 my-script.sh
$ ./my-script.sh
Hello World
$
```

In Shell script a *comment* is written with leading **#**

```shell
#!/bin/sh
# This is a comment!
echo Hello World	# This is a comment, too!
```

> Note that to make a file executable, you must set the eXecutable bit, and for a shell script, the Readable bit must also be set: 

```shell
$ chmod a+rx my-script.sh
$ ./my-script.sh
```

>**This is the most basic part to Write, Change Permission (if required) and executing a shell script.** 
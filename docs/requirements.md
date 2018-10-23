# Requirements
## Operating System
The installation script is written for Linux; for other operating systems, you will need to adapt the installation of some component dependencies, notably the Alpino parser.

## Component dependencies
Not all component dependencies are installed by `install.sh`. This notably applies to Timbl and low-level dependencies.

## Python components and environment
The pipeline is written for python 3, and was tested with python 3.5. The wrapper is not compatible with python 2. The python pipeline components are ported to python 3 by `install.sh` when relevant. Required python packages for the pipeline are recorded under `env/requirements.txt`.

Within the python environment of your choice (the pipeline was tested with python 3.5.2), do:
```
pip install -r ./env/requirements.txt
```

## Java components 
The pipeline also depends on a number of java components, most of which must be compiled with Maven. We tested the compilation of these components with Maven 3.5.4 and Java 1.8.

You should set `$MAVEN_HOME`, `$JAVA_HOME` and `$PATH` in, e.g., `~/.bash_profile`:
```shell
export JAVA_HOME=<path-to-jdk>/jdk1.8.0_x
export MAVEN_HOME=<path-to-maven>/apache-maven-3.5.4
export PATH=${MAVEN_HOME}/bin:${JAVA_HOME}/bin:${PATH}
``` 
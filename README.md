# yaml2env

Pass the value from the yaml file to the environment variable.

## Install

``` shell
curl -sL https://github.com/daichirata/yaml2env/releases/download/v0.1.0/yaml2env-v0.1.0-$(uname)-amd64 \
  && mv yaml2env-v0.1.0-$(uname)-amd64 /usr/local/bin/yaml2env \
  && chmod +x /usr/local/bin/yaml2env
```

or

``` shell
go install github.com/daichirata/yaml2env
```

## Useage

``` shell
$ yaml2env --help
Usage of yaml2env:
  -e string
    	Environment
  -s	Do not suppress error output
```

**Basic useage**

``` shell
$ cat env.yaml
TEST_KEY_1: test-value-1
TEST_KEY_2: test-value-2

$ yaml2env env.yaml
export TEST_KEY_1=test-value-1
export TEST_KEY_2=test-value-2

# Load
$ eval $(yaml2env env.yaml)
```

**Specific environment name**

``` shell
$ cat env.yaml
development:
  TEST_KEY_1: test-value-development-1

staging:
  TEST_KEY_1: test-value-staging-1
  TEST_KEY_2: test-value-staging-2

$ yaml2env -e development env.yaml
export TEST_KEY_1=test-value-development-1

$ yaml2env -e staging env.yaml
export TEST_KEY_1=test-value-staging-1
export TEST_KEY_2=test-value-staging-2
```

**Common setting items**

``` shell
$ cat env.yaml
default: &default
  DEFAULT_KEY: default-value

development:
  <<: *default
  TEST_KEY_1: test-value-development-1

$ yaml2env -e development env.yaml
export DEFAULT_KEY=default-value
export TEST_KEY_1=test-value-development-1
```

**Error**

``` shell
$ cat env.yaml
default: &default
  DEFAULT_KEY: default-value

development:
  <<: *default
  TEST_KEY_1: test-value-development-1

# suppress error
$ yaml2env -e xxx env.yaml

# show error
$ yaml2env -s -e xxx env.yaml
Environment: xxx not found
```

# License

MIT

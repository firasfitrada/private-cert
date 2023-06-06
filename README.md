### 1. Description
This repo is to help create private certificate files with .pem, .crt, .pfx, .pfx, .p12, and .jks formats in Ubuntu/Debian Linux.

### 2. Getting Started
Before using the following private ssl generator, make sure your linux has OpenSSL and Java installed first.

### 3. Getting Started
1. In order to use the scripts from this repo do a git clone first.
    ```
    $ sudo git clone https://github.com/firasfitrada/private-cert.git
    ```
2. Go to the downloaded private-cert folder
    ```
    $ cd private-cert/
    ```
3. Edit .env file and adjust with your project.
    ```
    $ sudo nano .env
    ```
4. Example .env file.
    ```
    #You can change it according to what the application/project needs during development.
    CERT_NAME="mycertificate"
    KEYSTORE_PASSWORD="password1234"

    CONTRY_CODE="ID"
    STATE="My State"
    LOCALITY="My City"
    ORGANIZATION="My Organization"
    ORGANIZATIONAL_UNIT="My Teams"
    COMMON_NAME="www.example.com"

    SUB_ALT_NAMES="DNS=www.example.com\nIP.1=192.168.1.254\nIP.2=10.1.1.254"

    DEFAULT_BITS="2048"
    PROMPT="no"
    DEFAULT_MD="sha256"
    X509_EXTENSIONS="v3_req"

    EXPIRE_DATE="365"

    ```
5. Run ./generate.sh
    ```
    $ sudo ./generate.sh
    ```

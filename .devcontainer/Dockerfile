FROM hashicorp/terraform:0.14.10
RUN wget https://github.com/wata727/tflint/releases/download/v0.22.0/tflint_linux_amd64.zip \
    && unzip tflint_linux_amd64.zip \
    && mkdir -p /usr/local/bin \
    && install tflint /usr/local/bin
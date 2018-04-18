S3 Secrets
==========

S3 Secrets (S3S) is ansible role for creating encrypted S3 buckets and users with access to these buckets.

# Features

- create private encrypted S3 bucket
- create IAM user
- create user access keys (and generate AWS credentials file)
- grant user access to S3 bucket

# How to

## Create encrypted S3 bucket

Include this role in your playbook, example:

```yaml
- include_role:
    name: s3-secrets
  vars:
    _tag: cb
    bname: your-bucket-name
    region: aws-region
```

## Create IAM user

Include this role in your playbook, example:

```yaml
- include_role:
    name: s3-secrets
  vars:
    _tag: cu
    uname: your-user-name
```

## Create user access keys

Include this role in your playbook, example:

```yaml
- include_role:
    name: s3-secrets
  vars:
    _tag: cuak
    uname: your-user-name
    credentials_file_dest: /path/to/newly/created/credentials/file # optional
```

If you don't specify `credentials_file_dest` variable, credentials file will be saved to playbook dir by default.

## Grant user access to bucket

Include this role in your playbook, example:

```yaml
- include_role:
    name: s3-secrets
  vars:
    _tag: ugba
    uname: your-user-name
    bname: your-bucket-name
```

## Run full setup

Include this role in your playbook, example:

```yaml
- include_role:
    name: s3-secrets
  vars:
    _tag: full
    uname: your-user-name
    bname: your-bucket-name
    region: aws-region # for S3 bucket
    credentials_file_dest: /path/to/newly/created/credentials/file # optional
```

This will create new private encrypted S3 bucket, create new user with access to that bucket and generate user AWS credentials file.

# AWS CloudTrail API

AWS CloudTrail Service module for [ex_aws](https://github.com/ex-aws/ex_aws).

## Installation

The package can be installed by adding ex_aws_cloud_trail to your list of dependencies in mix.exs along with :ex_aws and your preferred JSON codec / http client. Example:

```elixir
def deps do
  [
    {:ex_aws, "~> 2.0"},
    {:ex_aws_cloud_trail, "~> 2.0"},
    {:poison, "~> 3.0"},
    {:hackney, "~> 1.9"},
  ]
end
```

## Documentation

* [ex_aws](https://hexdocs.pm/ex_aws)
* [AWS CloudTrail API](https://docs.aws.amazon.com/awscloudtrail/latest/APIReference/Welcome.html)
* [Go API for CloudTrail](https://github.com/aws/aws-sdk-go/blob/master/models/apis/cloudtrail/2013-11-01/api-2.json)

## License

[LICENSE](LICENSE)
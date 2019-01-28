# AWS CloudTrail API (work in progress)

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
* [Go API for CodePipeline](https://github.com/aws/aws-sdk-go/blob/master/models/apis/cloudtrail/2013-11-01/api-2.json)

## License

The MIT License (MIT)

Copyright (c) 2019 Vonage

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
defmodule StartLoggingTest do
  use ExUnit.Case

  test "start logging" do
    arn = "arn:aws:cloudtrail:us-east-2:123456789012:trail/MyTrail"
    op = ExAws.CloudTrail.start_logging(arn)

    assert op.headers == [
             {"x-amz-target", "CloudTrail_20131101.StartLogging"},
             {"content-type", "application/x-amz-json-1.1"}
           ]

    assert op.data == %{
             "Name" => "arn:aws:cloudtrail:us-east-2:123456789012:trail/MyTrail"
           }
  end
end

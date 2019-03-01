defmodule LookupEventsTest do
  use ExUnit.Case

  test "lookup all events" do
    op = ExAws.CloudTrail.lookup_events()

    assert op.headers == [
             {"x-amz-target", "CloudTrail_20131101.LookupEvents"},
             {"content-type", "application/x-amz-json-1.1"}
           ]

    assert op.data == %{}
  end

  test "returns events in which the value of EventSource is iam.amazonaws.com" do
    op =
      ExAws.CloudTrail.lookup_events(
        lookup_attributes: [attribute_key: "EventSource", attribute_value: "iam.amazonaws.com"],
        max_results: 50
      )

    assert op.headers == [
             {"x-amz-target", "CloudTrail_20131101.LookupEvents"},
             {"content-type", "application/x-amz-json-1.1"}
           ]

    assert op.data == %{
             "LookupAttributes" => [
               %{
                 "AttributeKey" => "EventSource",
                 "AttributeValue" => "iam.amazonaws.com"
               }
             ],
             "MaxResults" => 50
           }
  end

  test "return only write events" do
    op =
      ExAws.CloudTrail.lookup_events(
        lookup_attributes: [attribute_key: "ReadOnly", attribute_value: "false"]
      )

    assert op.headers == [
             {"x-amz-target", "CloudTrail_20131101.LookupEvents"},
             {"content-type", "application/x-amz-json-1.1"}
           ]

    assert op.data == %{
             "LookupAttributes" => [
               %{
                 "AttributeKey" => "ReadOnly",
                 "AttributeValue" => "false"
               }
             ]
           }
  end

  test "formatting handles a list of lists in lookup_attributes" do
    # try and pass multiple lookup attributes. should ignore all but first
    op =
      ExAws.CloudTrail.lookup_events(
        lookup_attributes: [
          [attribute_key: "ReadOnly", attribute_value: "false"],
          [attribute_key: "AnotherKey", attribute_value: "Another Value"]
        ]
      )

    assert op.headers == [
             {"x-amz-target", "CloudTrail_20131101.LookupEvents"},
             {"content-type", "application/x-amz-json-1.1"}
           ]

    assert op.data == %{
             "LookupAttributes" => [
               %{
                 "AttributeKey" => "ReadOnly",
                 "AttributeValue" => "false"
               }
             ]
           }
  end
end

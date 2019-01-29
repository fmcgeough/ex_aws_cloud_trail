defmodule PutEventSelectorsTest do
  use ExUnit.Case

  test "normal op" do
    selectors = [
      [
        include_management_events: true,
        read_write_type: "All"
      ]
    ]

    op = ExAws.CloudTrail.put_event_selectors("Default", selectors)

    assert op.headers == [
             {"x-amz-target", "CloudTrail_20131101.PutEventSelectors"},
             {"content-type", "application/x-amz-json-1.1"}
           ]

    assert op.data == %{
             "EventSelectors" => [
               %{"IncludeManagementEvents" => true, "ReadWriteType" => "All"}
             ],
             "TrailName" => "Default"
           }
  end

  test "data resources" do
    lambda_func1 = "arn:aws:lambda:us-west-2:111111111111:function:helloworld"
    lambda_func2 = "arn:aws:lambda:us-west-2:111111111111:function:goodbyeworld"

    selectors = [
      [
        data_resources: [
          %{
            type: "AWS::Lambda::Function",
            values: [lambda_func1, lambda_func2]
          }
        ],
        read_write_type: "All"
      ]
    ]

    op = ExAws.CloudTrail.put_event_selectors("Default", selectors)

    assert op.headers == [
             {"x-amz-target", "CloudTrail_20131101.PutEventSelectors"},
             {"content-type", "application/x-amz-json-1.1"}
           ]

    assert op.data == %{
             "EventSelectors" => [
               %{
                 "ReadWriteType" => "All",
                 "DataResources" => [
                   %{"Type" => "AWS::Lambda::Function", "Values" => [lambda_func1, lambda_func2]}
                 ]
               }
             ],
             "TrailName" => "Default"
           }
  end
end

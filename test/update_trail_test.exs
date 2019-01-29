defmodule UpdateTrailTest do
  use ExUnit.Case

  test "update trail" do
    opts = [
      cloud_watch_logs_log_group_arn: "LogGroupArn",
      cloud_watch_logs_role_arn: "LogsRoleArn",
      enable_log_file_validation: true,
      include_global_service_events: true,
      is_multi_region_trail: false,
      is_organization_trail: false,
      kms_key_id: "alias/MyAliasName",
      sns_topic_name: "SNSTopic"
    ]

    op = ExAws.CloudTrail.update_trail("TestTrail", opts)

    assert op.headers == [
             {"x-amz-target", "CloudTrail_20131101.UpdateTrail"},
             {"content-type", "application/x-amz-json-1.1"}
           ]

    assert op.data == %{
             "CloudWatchLogsLogGroupArn" => "LogGroupArn",
             "CloudWatchLogsRoleArn" => "LogsRoleArn",
             "EnableLogFileValidation" => true,
             "IncludeGlobalServiceEvents" => true,
             "IsMultiRegionTrail" => false,
             "IsOrganizationTrail" => false,
             "KmsKeyId" => "alias/MyAliasName",
             "Name" => "TestTrail",
             "SnsTopicName" => "SNSTopic"
           }
  end
end

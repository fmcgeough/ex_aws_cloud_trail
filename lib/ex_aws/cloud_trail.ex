defmodule ExAws.CloudTrail do
  @moduledoc """
    Implementation of AWS CloudTrail API
  """
  import ExAws.Utils, only: [camelize_keys: 1, camelize_keys: 2]

  alias ExAws.Operation.JSON, as: ExAwsOperationJSON

  @version "20131101"
  @namespace "CloudTrail"
  @key_spec %{
    trail_name_list: "trailNameList",
    include_shadow_trails: "includeShadowTrails"
  }

  @type tag :: %{
          key: binary,
          value: binary
        }

  @type create_trail_opts :: [
          cloud_watch_logs_log_group_arn: binary,
          cloud_watch_logs_role_arn: binary,
          enable_log_file_validation: boolean,
          include_global_service_events: boolean,
          is_multi_region_trail: boolean,
          is_organization_trail: boolean,
          kms_key_id: binary,
          sns_topic_name: binary
        ]

  @type update_trail_opts :: [
          cloud_watch_logs_log_group_arn: binary,
          cloud_watch_logs_role_arn: binary,
          enable_log_file_validation: boolean,
          include_global_service_events: boolean,
          is_multi_region_trail: boolean,
          is_organization_trail: boolean,
          kms_key_id: binary,
          s3_bucket_name: binary,
          s3_key_prefix: binary,
          sns_topic_name: binary
        ]

  @type describe_trails_opts :: [
          include_shadow_trails: boolean,
          trail_name_list: [binary, ...]
        ]

  @type list_public_keys_opts :: [
          end_time: binary,
          next_token: binary,
          start_time: binary
        ]

  @type paging_options :: [
          next_token: binary
        ]

  @type lookup_attribute :: [attribute_key: binary, attribute_value: binary]
  @type lookup_events_opts :: [
          end_time: binary,
          lookup_attributes: [lookup_attribute, ...] | lookup_attribute,
          max_results: integer,
          next_token: binary,
          start_time: binary
        ]

  @type data_resource :: %{
          contents: binary,
          values: [binary, ...]
        }

  @type event_selector :: [
          data_resources: [data_resource, ...],
          include_management_events: boolean,
          read_write_type: binary
        ]

  @doc """
    Adds one or more tags to a trail, up to a limit of 50

    Tags must be unique per trail. Overwrites an existing tag's value
    when a new value is specified for an existing tag key. If you
    specify a key without a value, the tag will be created with the
    specified key and a value of null. You can tag a trail that applies
    to all regions only from the region in which the trail was
    created (that is, from its home region).

  ## Parameters

    * resource_id (string) - Required. Specifies the ARN of the trail to which one
    or more tags will be added. The format of a trail ARN is:
    `arn:aws:cloudtrail:us-east-2:123456789012:trail/MyTrail`

    * tags_list (List) - Contains a list of CloudTrail tags, up to a limit of 50. Each
    tag must have a key. The key must be must be no longer than 128 Unicode characters.
    The key must be unique for the resource to which it applies. The tag value must
    be no longer than 256 Unicode characters. Each element in the tags_list is supplied as:
    `[%{key: "Key", value: "Value"}]`
  """
  @spec add_tags(resource_id :: binary) :: ExAws.Operation.JSON.t()
  @spec add_tags(resource_id :: binary, tag_list :: [tag, ...] | []) :: ExAws.Operation.JSON.t()
  def add_tags(resource_id, tag_list \\ []) do
    tag_data = tag_list |> Enum.map(fn x -> camelize_keys(x) end)

    %{"ResourceId" => resource_id, "TagsList" => tag_data}
    |> request(:add_tags)
  end

  @doc """
    Creates a trail that specifies the settings for delivery of log data to
    an Amazon S3 bucket

    A maximum of five trails can exist in a region, irrespective of the
    region in which they were created.

  ## Parameters

    * name (string) - Required. Specifies the name of the trail. The name must meet the
    following requirements:

      * Contains only ASCII letters (a-z, A-Z), numbers (0-9), periods (.),
      underscores (_), or dashes (-)
      * Start with a letter or number, and end with a letter or number
      * Be between 3 and 128 characters
      * Have no adjacent periods, underscores or dashes. Names like
      my-_namespace and my--namespace are invalid.
      * Not be in IP address format (for example, 192.168.5.4)

   * s3_bucket_name (string) - Required. Specifies the name of the Amazon S3 bucket designated
   for publishing log files. See [Amazon S3 Bucket Naming Requirements](https://amzn.to/2RkmbzH).

   * cloud_watch_logs_log_group_arn (string) - Specifies a log group name using an Amazon Resource
   Name (ARN), a unique identifier that represents the log group to which CloudTrail logs
   will be delivered. Not required unless you also supply cloud_watch_logs_role_arn.

   * cloud_watch_logs_role_arn (string) - Specifies the role for the CloudWatch Logs endpoint to
   assume to write to a user's log group

   * enable_log_file_validation (boolean) - Specifies whether log file integrity validation is enabled.
   The default is false.

   * include_global_service_events (boolean) - Specifies whether the trail is publishing events from
   global services such as IAM to the log files

   * is_multi_region_trail (boolean) - Specifies whether the trail is created in the current
   region or in all regions. The default is false.

   * is_organization_trail (boolean) - Specifies whether the trail is created for all accounts
   in an organization in AWS Organizations, or only for the current AWS account. The default is
   false, and cannot be true unless the call is made on behalf of an AWS account that is the
   master account for an organization in AWS Organizations.

   * kms_key_id (string) - Specifies the KMS key ID to use to encrypt the logs delivered by
   CloudTrail. The value can be an alias name prefixed by "alias/", a fully specified ARN to
   an alias, a fully specified ARN to a key, or a globally unique identifier.

   * sns_topic_name (string) - Specifies the name of the Amazon SNS topic defined for notification
   of log file delivery. The maximum length is 256 characters.

  """
  @spec create_trail(name :: binary, s3_bucket_name :: binary) :: ExAws.Operation.JSON.t()
  @spec create_trail(name :: binary, s3_bucket_name :: binary, opts :: create_trail_opts) ::
          ExAws.Operation.JSON.t()
  def create_trail(name, s3_bucket_name, opts \\ []) do
    opts
    |> camelize_keys()
    |> Map.merge(%{"Name" => name, "S3BucketName" => s3_bucket_name})
    |> request(:create_trail)
  end

  @doc """
    Deletes a trail

    This operation must be called from the region in which the trail was
    created. delete_trail cannot be called on the shadow trails (replicated
    trails in other regions) of a trail that is enabled in all regions.

  ## Parameters

    * name (string) - Required. Specifies the name or the CloudTrail ARN of
    the trail to be deleted. The format of a trail ARN is:
    `arn:aws:cloudtrail:us-east-2:123456789012:trail/MyTrail`
  """
  @spec delete_trail(name :: binary) :: ExAws.Operation.JSON.t()
  def delete_trail(name) do
    %{"Name" => name}
    |> request(:delete_trail)
  end

  @doc """
    Retrieves settings for the trail associated with the current region for
    your account

  ## Parameters

    * include_shadow_trails (boolean) - Specifies whether to include shadow
    trails in the response. A shadow trail is the replication in a region of
    a trail that was created in a different region, or in the case of an
    organization trail, the replication of an organization trail in member
    accounts. If you do not include shadow trails, organization trails in a
    member account and region replication trails will not be returned.
    The default is true.

    * trail_name_list (list of string) - Specifies a list of trail names,
    trail ARNs, or both, of the trails to describe.
  """
  @spec describe_trails() :: ExAws.Operation.JSON.t()
  @spec describe_trails(opts :: describe_trails_opts) :: ExAws.Operation.JSON.t()
  def describe_trails(opts \\ []) do
    opts
    |> camelize_keys(spec: @key_spec)
    |> request(:describe_trails)
  end

  @doc """
    Describes the settings for the event selectors that you configured for
    your trail

    The information returned for your event selectors includes the following:

    * If your event selector includes read-only events, write-only events,
    or all events. This applies to both management events and data events.

    * If your event selector includes management events.

    * If your event selector includes data events, the Amazon S3 objects or
    AWS Lambda functions that you are logging for data events.

    For more information, see
    [Logging Data and Management Events for Trails](https://amzn.to/2DGkWY9)
    in the AWS CloudTrail User Guide.

  ## Parameters

  * trail_name (string) - Required. Specifies the name of the trail or trail ARN.
  If you specify a trail name, the string must meet the following requirements:

    * Contain only ASCII letters (a-z, A-Z), numbers (0-9), periods (.), underscores (_), or dashes (-)
    * Start with a letter or number, and end with a letter or number
    * Be between 3 and 128 characters
    * Have no adjacent periods, underscores or dashes. Names like my-_namespace and my--namespace are not valid.
    * Not be in IP address format (for example, 192.168.5.4)

    * If you specify a trail ARN, it must be in the format:
    `arn:aws:cloudtrail:us-east-2:123456789012:trail/MyTrail`
  """
  @spec get_event_selectors(trail_name :: binary) :: ExAws.Operation.JSON.t()
  def get_event_selectors(trail_name) do
    %{"TrailName" => trail_name}
    |> request(:get_event_selectors)
  end

  @doc """
    Returns a JSON-formatted list of information about the specified trail

    Fields include information on delivery errors, Amazon SNS and Amazon S3 errors,
    and start and stop logging times for each trail. This operation returns trail
    status from a single region. To return trail status from all regions, you must
    call the operation on each region.

  ## Parameters

    * Name (string) - Required. Specifies the name or the CloudTrail ARN of the trail
    for which you are requesting status. To get the status of a shadow trail (a
    replication of the trail in another region), you must specify its ARN.
    The format of a trail ARN is:

        `arn:aws:cloudtrail:us-east-2:123456789012:trail/MyTrail`
  """
  @spec get_trail_status(name :: binary) :: ExAws.Operation.JSON.t()
  def get_trail_status(name) do
    %{"Name" => name}
    |> request(:get_trail_status)
  end

  @doc """
    Returns all public keys whose private keys were used to sign the digest
    files within the specified time range

    The public key is needed to validate digest files that were signed with
    its corresponding private key.

  ## Note

    CloudTrail uses different private/public key pairs per region. Each digest
    file is signed with a private key unique to its region. Therefore, when you
    validate a digest file from a particular region, you must look in the same
    region for its corresponding public key.

  ## Parameters

    * end_time - Optionally specifies, in UTC, the end of the time range to
    look up public keys for CloudTrail digest files. If not specified, the
    current time is used. Passed in milliseconds since epoch.

    * next_token (string) - Reserved for future use

    * start_time - Optionally specifies, in UTC, the start of the time range
    to look up public keys for CloudTrail digest files. If not specified,
    the current time is used, and the current public key is returned.
    Passed in milliseconds since epoch.
  """
  @spec list_public_keys() :: ExAws.Operation.JSON.t()
  @spec list_public_keys(opts :: list_public_keys_opts) :: ExAws.Operation.JSON.t()
  def list_public_keys(opts \\ []) do
    opts
    |> camelize_keys()
    |> request(:list_public_keys)
  end

  @doc """
    Lists the tags for the trail in the current region

  ## Parameters

    * resource_id_list (list) - Required. Specifies a list of trail ARNs whose tags
    will be listed. The list has a limit of 20 ARNs.

    * next_token (string) - Reserved for future use
  """
  @spec list_tags(resource_id_list :: [binary, ...]) :: ExAws.Operation.JSON.t()
  @spec list_tags(resource_id_list :: [binary, ...], opts :: paging_options) ::
          ExAws.Operation.JSON.t()
  def list_tags(resource_id_list, opts \\ []) do
    opts
    |> camelize_keys()
    |> Map.merge(%{"ResourceTagList" => resource_id_list})
    |> request(:list_tags)
  end

  @doc """
    Looks up management events captured by CloudTrail

    Events for a region can be looked up in that region during the last
    90 days. Lookup supports the following attributes:

    * AWS access key
    * Event ID
    * Event name
    * Event source
    * Read only
    * Resource name
    * Resource type
    * User name

    All attributes are optional. The default number of results returned is
    50, with a maximum of 50 possible. The response includes a token that you can
    use to get the next page of results.

  ## Important

    The rate of lookup requests is limited to one per second per account. If this
    limit is exceeded, a throttling error occurs.

  ## Important

    Events that occurred during the selected time range will not be available for
    lookup if CloudTrail logging was not enabled when the events occurred.

  ## Parameters

    * end_time - Specifies that only events that occur before or at the specified
    time are returned. If the specified end time is before the specified start time,
    an error is returned.

    * lookup_attributes - Contains a list of lookup attributes. Currently the list
    can contain only one item.

    * max_results (integer) - The number of events to return. 1-50. The default is 50.

    * next_token (string) - The token to use to get the next page of results after a
    previous API call. This token must be passed in with the same parameters that were
    specified in the the original call. For example, if the original call specified an
    AttributeKey of 'Username' with a value of 'root', the call with next_token should
    include those same parameters.

    * start_time - Specifies that only events that occur after or at the specified time
    are returned. If the specified start time is after the specified end time, an error
    is returned.
  """
  @spec lookup_events() :: ExAws.Operation.JSON.t()
  @spec lookup_events(opts :: lookup_events_opts) :: ExAws.Operation.JSON.t()
  def lookup_events(opts \\ []) do
    data =
      case Keyword.get(opts, :lookup_attributes) do
        nil ->
          camelize_keys(opts)

        val ->
          opts
          |> Keyword.delete(:lookup_attributes)
          |> camelize_keys()
          |> Map.merge(handle_lookup_attributes(val))
      end

    request(data, :lookup_events)
  end

  @doc """
    Configures an event selector for your trail

    Use event selectors to further specify the management and data event
    settings for your trail. By default, trails created without specific event
    selectors will be configured to log all read and write management events,
    and no data events.

    When an event occurs in your account, CloudTrail evaluates the event selectors
    in all trails. For each trail, if the event matches any event selector, the
    trail processes and logs the event. If the event doesn't match any event
    selector, the trail doesn't log the event.

  ## Example

    1. You create an event selector for a trail and specify that you want write-only events.
    2. The EC2 GetConsoleOutput and RunInstances API operations occur in your account.
    3. CloudTrail evaluates whether the events match your event selectors.
    4.  The RunInstances is a write-only event and it matches your event selector. The
    trail logs the event.
    5. The GetConsoleOutput is a read-only event but it doesn't match your event selector.
    The trail doesn't log the event.

    The `put_event_selectors/2` operation must be called from the region in which the trail
    was created; otherwise, an InvalidHomeRegionException is thrown.

    You can configure up to five event selectors for each trail. For more information,
    see [Logging Data and Management Events for Trails](https://amzn.to/2DGkWY9) and
    [Limits in AWS CloudTrail](https://amzn.to/2H39FVw) in the AWS CloudTrail User Guide.

  ## Parameters

    * trail_name (string) - Required. Specifies the name of the trail or trail ARN.

    * event_selectors (list) - Specifies the settings for your event selectors.
    You can configure up to five event selectors for a trail. Format is:

          ```
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
          ```

  """
  @spec put_event_selectors(trail_name :: binary, event_selectors :: [event_selector, ...]) ::
          ExAws.Operation.JSON.t()
  def put_event_selectors(trail_name, event_selectors) when is_list(event_selectors) do
    event_selectors_data =
      event_selectors |> Enum.map(fn x -> camelize_keys(x, %{deep: true}) end)

    %{"TrailName" => trail_name, "EventSelectors" => event_selectors_data}
    |> request(:put_event_selectors)
  end

  @doc """
    Removes the specified tags from a trail

  ## Parameters

    * resource_id (string) - Required. Specifies the ARN of the trail from which
    tags should be removed.

    * tags_list (list) - Specifies a list of tags to be removed. See `list_tags/2`
  """
  @spec remove_tags(resource_id :: binary) :: ExAws.Operation.JSON.t()
  @spec remove_tags(resource_id :: binary, []) :: ExAws.Operation.JSON.t()
  @spec remove_tags(resource_id :: binary, tags_list :: [tag, ...]) :: ExAws.Operation.JSON.t()
  def remove_tags(resource_id, tags_list \\ []) do
    tags_list_data = camelize_keys(tags_list)

    %{"ResourceId" => resource_id, "TagsList" => tags_list_data}
    |> request(:remove_tags)
  end

  @doc """
    Starts the recording of AWS API calls and log file delivery for a trail

    For a trail that is enabled in all regions, this operation must be called from
    the region in which the trail was created. This operation cannot be called on
    the shadow trails (replicated trails in other regions) of a trail that is
    enabled in all regions

  ## Parameters

    * name (string) - Required. Specifies the name or the CloudTrail ARN of the
    trail for which CloudTrail will log AWS API calls
  """
  @spec start_logging(name :: binary) :: ExAws.Operation.JSON.t()
  def start_logging(name) do
    %{"Name" => name}
    |> request(:start_logging)
  end

  @doc """
    Suspends the recording of AWS API calls and log file delivery for the specified trail

    Under most circumstances, there is no need to use this action. You can update a trail
    without stopping it first. This action is the only way to stop recording. For a trail
    enabled in all regions, this operation must be called from the region in which the
    trail was created, or an InvalidHomeRegionException will occur. This operation cannot
    be called on the shadow trails (replicated trails in other regions) of a trail
    enabled in all regions.

  ## Parameters

    * name (string) - Required. Specifies the name or the CloudTrail ARN of the
    trail for which CloudTrail will stop logging AWS API calls
  """
  @spec stop_logging(name :: binary) :: ExAws.Operation.JSON.t()
  def stop_logging(name) do
    %{"Name" => name}
    |> request(:stop_logging)
  end

  @doc """
    Updates the settings that specify delivery of log files

    Changes to a trail do not require stopping the CloudTrail service. Use this action to
    designate an existing bucket for log delivery. If the existing bucket has previously
    been a target for CloudTrail log files, an IAM policy exists for the bucket. update_trail
    must be called from the region in which the trail was created; otherwise, an
    InvalidHomeRegionException is thrown.

  ## Parameters

    * name (string) - Required. Specifies the name of the trail or trail ARN (see `create_trail/2`)

    * cloud_watch_logs_log_group_arn (string) - Specifies a log group name using an Amazon Resource
    Name (ARN), a unique identifier that represents the log group to which CloudTrail logs
    will be delivered. Not required unless you also supply cloud_watch_logs_role_arn.

    * cloud_watch_logs_role_arn (string) - Specifies the role for the CloudWatch Logs endpoint to
    assume to write to a user's log group

    * enable_log_file_validation (boolean) - Specifies whether log file integrity validation is enabled.
    The default is false.

    * include_global_service_events (boolean) - Specifies whether the trail is publishing events from
    global services such as IAM to the log files

    * is_multi_region_trail (boolean) - Specifies whether the trail is created in the current
    region or in all regions. The default is false.

    * is_organization_trail (boolean) - Specifies whether the trail is created for all accounts
    in an organization in AWS Organizations, or only for the current AWS account. The default is
    false, and cannot be true unless the call is made on behalf of an AWS account that is the
    master account for an organization in AWS Organizations.

    * kms_key_id (string) - Specifies the KMS key ID to use to encrypt the logs delivered by
    CloudTrail. The value can be an alias name prefixed by "alias/", a fully specified ARN to
    an alias, a fully specified ARN to a key, or a globally unique identifier.

    * sns_topic_name (string) - Specifies the name of the Amazon SNS topic defined for notification
    of log file delivery. The maximum length is 256 characters.

    * s3_bucket_name (string) - Specifies the name of the Amazon S3 bucket designated
    for publishing log files. See [Amazon S3 Bucket Naming Requirements](https://amzn.to/2RkmbzH).

    * s3_key_prefix (string) - Specifies the Amazon S3 key prefix that comes after the name
    of the bucket you have designated for log file delivery. For more information, see
    [Finding Your CloudTrail Log Files](https://amzn.to/2TjVdd9). The maximum length is 200 characters.
  """
  @spec update_trail(name :: binary) :: ExAws.Operation.JSON.t()
  @spec update_trail(name :: binary, opts :: update_trail_opts) :: ExAws.Operation.JSON.t()
  def update_trail(name, opts \\ []) do
    opts
    |> camelize_keys()
    |> Map.merge(%{"Name" => name})
    |> request(:update_trail)
  end

  defp request(data, action) do
    operation = action |> Atom.to_string() |> Macro.camelize()

    ExAwsOperationJSON.new(
      :cloudtrail,
      %{
        data: data,
        headers: [
          {"x-amz-target", "#{@namespace}_#{@version}.#{operation}"},
          {"content-type", "application/x-amz-json-1.1"}
        ]
      }
    )
  end

  # AWS only accepts one lookup attribute on lookup_events
  defp handle_lookup_attributes(input_val) do
    [h | _t] = input_val

    val =
      case is_list(h) do
        true -> Enum.at(input_val, 0)
        false -> input_val
      end

    %{"LookupAttributes" => [camelize_keys(val)]}
  end
end

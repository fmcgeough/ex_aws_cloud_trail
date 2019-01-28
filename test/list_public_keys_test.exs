defmodule ListPublicKeysTest do
  use ExUnit.Case

  test "no params" do
    op = ExAws.CloudTrail.list_public_keys()

    assert op.headers == [
             {"x-amz-target", "CloudTrail_20131101.ListPublicKeys"},
             {"content-type", "application/x-amz-json-1.1"}
           ]

    assert op.data == %{}
  end
end

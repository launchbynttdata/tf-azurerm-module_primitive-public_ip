package common

import (
	"context"
	"fmt"
	"log"
	"os"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore/arm"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/compute/armcompute"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/network/armnetwork/v5"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
)

func TestComposableComplete(t *testing.T, ctx types.TestContext) {
	subscriptionId := os.Getenv("ARM_SUBSCRIPTION_ID")
	if subscriptionId == "" {
		t.Fatalf("ARM_SUBSCRIPTION_ID must be set for acceptance tests")
	}
	cred, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		t.Fatalf("Error getting credentials: %e\n", err)
	}

	computeClient, err := armcompute.NewVirtualMachinesClient(subscriptionId, cred, nil)
	if err != nil {
		log.Fatal(err)
	}

	publicIPClient, err := armnetwork.NewPublicIPAddressesClient(subscriptionId, cred, nil)
	if err != nil {
		log.Fatal(err)
	}

	nicClient, err := armnetwork.NewInterfacesClient(subscriptionId, cred, nil)
	if err != nil {
		fmt.Println(err)
	}

	rgName := terraform.Output(t, ctx.TerratestTerraformOptions(), "resource_group_name")
	expectedPublicIPId := terraform.Output(t, ctx.TerratestTerraformOptions(), "public_ip_id")
	expectedPublicIPName := terraform.Output(t, ctx.TerratestTerraformOptions(), "public_ip_name")

	bgCtx := context.Background()

	t.Run("TestAlwaysSucceeds", func(t *testing.T) {
		assert.Equal(t, "foo", "foo", "Should always be the same!")
		assert.NotEqual(t, "foo", "bar", "Should never be the same!")
	})

	t.Run("PublicIPWasCreated", func(t *testing.T) {
		publicIP, err := publicIPClient.Get(bgCtx, rgName, expectedPublicIPName, nil)
		if err != nil {
			t.Error(err)
		}

		assert.Equal(t, expectedPublicIPId, *publicIP.ID, "Public IP ID didn't match expected.")
		assert.Equal(t, expectedPublicIPName, *publicIP.Name, "Public IP Name didn't match expected.")
	})

	t.Run("PublicNotAllocatedByDefault", func(t *testing.T) {
		ctx.EnabledOnlyForTests(t, "standalone")
		expectedPublicIPAddress := terraform.Output(t, ctx.TerratestTerraformOptions(), "ip_address")
		assert.Empty(t, expectedPublicIPAddress, "Expected public IP address to be empty, but it was allocated!")
	})

	t.Run("VirtualMachineIsAssignedPublicIP", func(t *testing.T) {
		ctx.EnabledOnlyForTests(t, "complete")

		vmId := terraform.Output(t, ctx.TerratestTerraformOptions(), "virtual_machine_id")
		vmName := terraform.Output(t, ctx.TerratestTerraformOptions(), "virtual_machine_name")

		vm, err := computeClient.Get(bgCtx, rgName, vmName, nil)
		if err != nil {
			t.Error(err)
		}

		assert.Equal(t, vmId, *vm.ID, "Unexpected Virtual Machine ID!")
		assert.Equal(t, vmName, *vm.Name, "Unexpected Virtual Machine Name!")

		for _, nicRef := range vm.Properties.NetworkProfile.NetworkInterfaces {
			nicID, _ := arm.ParseResourceID(*nicRef.ID)
			nic, _ := nicClient.Get(context.Background(), nicID.ResourceGroupName, nicID.Name, nil)
			for _, ipCfg := range nic.Properties.IPConfigurations {
				assert.NotNil(t, ipCfg.Properties.PrivateIPAddress, "Private IP address must exist!")
				assert.NotNil(t, ipCfg.Properties.PublicIPAddress, "Public IP address must exist!")

			}
		}
	})
}

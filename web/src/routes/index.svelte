<script lang=ts>
  import {
    Button,
    Modal,
    DataTable,
    OverflowMenu,
    OverflowMenuItem,
    TextInput,
    Toolbar,
    ToolbarContent,
    ToolbarMenu,
    ToolbarMenuItem,
    DataTableSkeleton
  } from "carbon-components-svelte"
  import { SCHEDULES } from "../apollo/queries"
  import { UPDATE_SCHEDULE, CREATE_SCHEDULE } from "../apollo/mutations"
  import { browser } from '$app/env'
  import { query, mutation, subscribe, getClient } from "svelte-apollo"

  const headers = [
    { key: "id", value: "ID" },
    { key: "message", value: "Message" },
    { key: "job.state", value: "状態"},
    { key: "overflow", empty: true },
  ];

  let open = false

  const scheduleList = query(SCHEDULES)
  const updateSchedule = mutation(UPDATE_SCHEDULE)
  const createSchedule = mutation(CREATE_SCHEDULE)

  scheduleList.refetch();

  const submitSchedule = async () => {
    createSchedule({
      variables: {
        attrs: {
          message: formData.message
        }
      },
      refetchQueries: [{
        query: SCHEDULES
      }]
    })
  }

  const handleUpdateSchedule = async () => {
    await updateSchedule({
      variables: {
        attrs: {
        scheduleId: editItem.id,
        message: editItem.message
        }
      },
      refetchQueries: [{
        query: SCHEDULES
      }]
    })
  }

  let editItem = null

  const openEditModal = (row) => {
    editItem = row
    open = true 
  }

  let createModal = false

  const formData = {
    message: ""
  }
</script>

<svelte:head>
  <title>Home</title>
</svelte:head>

{#if browser }
  {#if $scheduleList.loading}
    <DataTableSkeleton showHeader={false} showToolbar={false} size="tall" />
  {:else}
    <DataTable sortable {headers} rows={$scheduleList.data['schedules']} >

      <Toolbar size="default">
        <ToolbarContent>
          <ToolbarMenu>
            <ToolbarMenuItem primaryFocus>Restart all</ToolbarMenuItem>
            <ToolbarMenuItem href="https://cloud.ibm.com/docs/loadbalancer-service">
              API documentation
            </ToolbarMenuItem>
            <ToolbarMenuItem danger>Stop all</ToolbarMenuItem>
          </ToolbarMenu>
          <Button on:click={() => (createModal = true)}>Create Schedule</Button>
        </ToolbarContent>
      </Toolbar>
      <span slot="cell" let:cell let:row>
        {#if cell.key === 'overflow'}
          <OverflowMenu flipped>
            <OverflowMenuItem text="Edit" on:click="{() => openEditModal(row)}" />
            <OverflowMenuItem danger text="Re-run" />
            <OverflowMenuItem text="Delete" />
          </OverflowMenu>
        {:else}
          {cell.value}
        {/if}
      </span>
    </DataTable>
  {/if}
{/if}

<Modal
  modalHeading="Update Schedule"
  primaryButtonText="Confirm"
  secondaryButtonText="Cancel"
  bind:open
  on:click:button--secondary={() => (open = false)}
  on:open
  on:close
  on:submit={ async () => ( await handleUpdateSchedule())}
>
  {#if editItem}
    <p>ID: </p>
    <TextInput bind:value="{editItem.id}" />
    <p>Message: </p>
    <TextInput bind:value="{editItem.message}" />
  {/if}
</Modal>

<Modal
  modalHeading="Create Schedule"
  primaryButtonText="Confirm"
  secondaryButtonText="Cancel"
  bind:open={createModal}
  on:click:button--secondary={() => (createModal = false)}
  on:open
  on:close
  on:submit={ async () => ( await submitSchedule())}
>
  <p>Message:</p>
  <TextInput bind:value="{formData.message}" />
</Modal>

<script lang=ts>
	import { Button, Modal } from "carbon-components-svelte"
  import { updateTheme } from "../stores/app"
  import { client } from "../apollo"
  import { SCHEDULES } from "../apollo/queries"
  import {
    DataTable,
    OverflowMenu,
    OverflowMenuItem,
    TextInput
  } from "carbon-components-svelte";
  import { onMount } from 'svelte';

  const headers = [
    { key: "id", value: "ID" },
    { key: "message", value: "Message" },
    { key: "job.state", value: "状態"},
    { key: "overflow", empty: true },
  ];

  let rows: Array<{id: number, message: string}>

  const fetchSchedules = async () => {
    const {
      data: { schedules }
    } = await client.query({
      query: SCHEDULES,
    })

    console.log(schedules)

    rows = schedules
  }

  onMount(async () => {
    await fetchSchedules()
    console.log(rows)
  })

	let open = false
</script>

<svelte:head>
	<title>Home</title>
</svelte:head>

<DataTable sortable {headers} {rows}>
  <span slot="cell" let:cell>
    {#if cell.key === 'overflow'}
      <OverflowMenu flipped>
        <OverflowMenuItem text="Restart" on:click="{() => (open = true)}" />
        <OverflowMenuItem
          href="https://cloud.ibm.com/docs/loadbalancer-service"
          text="API documentation"
        />
        <OverflowMenuItem danger text="Stop" />
      </OverflowMenu>
    {:else}{cell.value}{/if}
  </span>
</DataTable>

<Modal
	modalHeading="Create database"
	primaryButtonText="Confirm"
	secondaryButtonText="Cancel"
	bind:open
	on:click:button--secondary
	on:open
	on:close
	on:submit
>
  <p>Create a new Cloudant database in the US South region.</p>
  <TextInput labelText="User name" placeholder="Enter user name..." />
</Modal>

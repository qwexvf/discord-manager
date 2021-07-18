<script lang=ts>
	import { Button, Modal } from "carbon-components-svelte"
	import { updateTheme } from "../stores/app"

	let open = false
</script>

<svelte:head>
	<title>Home</title>
</svelte:head>

<button on:click="{updateTheme}">Update theme</button>
<Button kind="tertiary" on:click={() => (open = true)}>Learn more</Button>

<Modal
	size="xs"
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
</Modal>

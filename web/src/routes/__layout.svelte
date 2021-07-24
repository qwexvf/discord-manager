<script lang="ts">
  import { onMount } from "svelte"
  import { page } from "$app/stores"
  import "carbon-components-svelte/css/g80.css"
  import {
    Header,
    SideNav,
    SideNavItems,
    HeaderNavItem,
    SideNavLink,
    SkipToContent,
    Content,
    Grid,
    Row,
    Column,
    Modal,
    HeaderUtilities,
    HeaderNav,
    Form,
    FormGroup,
    TextInput,
    PasswordInput
  } from "carbon-components-svelte"
  import { goto } from "$app/navigation"
  import { client } from "../apollo"
  import { mutation, setClient, query, subscribe } from "svelte-apollo"
  import { REGISTER_MUTATION, LOGIN_MUTATION } from "../apollo/mutations"
  import router from "../router"
  import { session } from "$app/stores"

  let isSideNavOpen: boolean = false
  let openRegisterForm = false

  setClient(client)

  type FormData = {
    email: string
    password: string
    passwordConfirm: string
  }

  const formData: FormData = {
    email: null,
    password: null,
    passwordConfirm: null
  } 

  $: path = $page.path

  let mode = 'login'

  const register = async () => {
    const {
      data: { authenticate }
    } = await client.mutate({
      mutation: REGISTER_MUTATION,
      variables: { ...formData }
    })

    if (authenticate.successful) {
      $session.user = authenticate.result
      localStorage.setItem('token', authenticate.result.token)
    }

    await goto('/')
  } 

  const handleLogin = mutation(LOGIN_MUTATION)

  const login = async () => {
    const result = await handleLogin({
      variables: { ...formData }
    })

    const login = result.data

    if (login["login"]["successful"]) {
      $session.user = login["login"]["result"]["user"]
      localStorage.setItem('token', login["login"]["result"]["token"])
    }

    await goto('/')
  } 

  async function submitForm() {
    console.log(mode)
    if (mode === 'login') {
      await login()
    } else {
      await register()
    }
  }
</script>

<Header
  persistentHamburgerMenu={true}
  platformName="Server number"
  bind:isSideNavOpen
>
  <div slot="skip-to-content">
    <SkipToContent />
  </div>
  <HeaderUtilities>
    <HeaderNav>
      {#if !$session.user}
        <HeaderNavItem text="Register" on:click={() => (openRegisterForm = true)}/>
      {/if}
    </HeaderNav>
  </HeaderUtilities>
</Header>

<SideNav bind:isOpen={isSideNavOpen}>
  <SideNavItems>
    {#each router as {name, url}}
      <SideNavLink text="{name}" href="{url}" isSelected="{path === name}" />
    {/each}
  </SideNavItems>
</SideNav>

<Content>
  <Grid>
    <Row>
      <Column>
        <slot />
      </Column>
    </Row>
  </Grid>
</Content>

<Modal
  bind:open={openRegisterForm}
  modalHeading="Login/Resiger"
  primaryButtonText="Confirm"
  secondaryButtonText="Cancel"
  on:click:button--secondary={() => (openRegisterForm = false)}
  on:open
  on:close
  on:submit="{() => submitForm()}">

  <Form on:submit>
    {#if mode === 'login'}
      <FormGroup>
        <TextInput bind:value="{formData.email}" labelText="Email" placeholder="Enter email..." />
        <PasswordInput bind:value="{formData.password}" labelText="Password" placeholder="Enter password..." />
      </FormGroup>
    {:else}
      <FormGroup>
        <TextInput
          bind:value="{formData.email}"
          labelText="Email"
          placeholder="Enter email..." />
        <PasswordInput
          bind:value="{formData.password}"
          labelText="Password"
          placeholder="Enter password..." />
        <PasswordInput
          bind:value="{formData.passwordConfirm}"
          labelText="Password"
          placeholder="Enter password..."
        />
      </FormGroup>
    {/if}
  </Form>
</Modal>

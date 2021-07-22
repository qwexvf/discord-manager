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
  import { setClient } from "svelte-apollo"
  import { AUTHENTICATE_MUTAITON } from "../apollo/mutations"
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


  const register = async () => {
    const {
      data: { authenticate }
    } = await client.mutate({
      mutation: AUTHENTICATE_MUTAITON,
      variables: { ...formData }
    })

    if (authenticate.successful) {
      $session.user = authenticate.result
      localStorage.setItem('token', authenticate.result.token)
    }

    await goto('/')
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
      <HeaderNavItem text="Register" on:click={() => (openRegisterForm = true)}/>
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
  on:click:button--secondary={() => (openRegisterForm = false)} on:open
  on:close
  on:submit="{register}">
  <Form on:submit>
    <FormGroup>
      <TextInput bind:value="{formData.email}" labelText="Email" placeholder="Enter email..." />
      <PasswordInput bind:value="{formData.password}" labelText="Password" placeholder="Enter password..." />
      <PasswordInput bind:value="{formData.passwordConfirm}" labelText="Password" placeholder="Enter password..." />
    </FormGroup>
  </Form>
</Modal>

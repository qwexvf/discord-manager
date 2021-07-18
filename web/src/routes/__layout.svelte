<script lang="ts">
  import { page } from "$app/stores"
  import "carbon-components-svelte/css/g80.css"
  import {
    Header,
    SideNav,
    SideNavItems,
    SideNavMenu,
    SideNavMenuItem,
    SideNavLink,
    SkipToContent,
    Content, Grid, Row, Column,
  } from "carbon-components-svelte"

  let isSideNavOpen: boolean = false

  $: path = $page.path

  const routes = [
    {url: "/", name: "Home"},
    {url: "/schedules", name: "Schedules"}
  ]
</script>

<Header
  persistentHamburgerMenu={true}
  platformName="Server number"
  bind:isSideNavOpen
>
  <div slot="skip-to-content">
    <SkipToContent />
  </div>
</Header>

<SideNav bind:isOpen={isSideNavOpen}>
  <SideNavItems>
    {#each routes as {name, url}}
      <SideNavLink text="{name}" href="{url}" isSelected="{path === name}"/>
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

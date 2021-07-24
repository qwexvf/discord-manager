import { InMemoryCache, ApolloClient, HttpLink, from, split,  } from "@apollo/client/core"
import { onError } from "@apollo/client/link/error"
import { setContext } from "@apollo/client/link/context"
import { WebSocketLink } from "@apollo/client/link/ws"
import { browser } from "$app/env"
import { get } from "svelte/store"
import { session } from "$app/stores"
import { getMainDefinition } from "@apollo/client/utilities"



const wsLink = browser ? new WebSocketLink({
  uri: 'ws://192.168.2.103:4000/socket',
  options: {
    reconnect: true,
    headers: {
      Authorization: localStorage.getItem('token')
    }
  }
}) : null
 
const httpLink = new HttpLink({
  uri: "http://192.168.2.103:4000/graphql"
})

const authLink = setContext((_, { headers }) => {
  // get the authentication token from local storage if it exists
  const token = localStorage.getItem('token')
  // return the headers to the context so httpLink can read them
  return {
    headers: {
      ...headers,
      Authorization: token ? `Bearer ${token}` : "",
    }
  }
})

const errorLink = onError(({ graphQLErrors, networkError }) => {
  if (graphQLErrors)
    graphQLErrors.forEach(({ message, locations, path }) => {
      console.log(`[GraphQL error]: Message: ${message}, Location: ${locations}, Path: ${path}`)
    })

    if (networkError) console.log(`[Network error]: ${networkError}`)
})


const splitLink = browser ? split(
  ({ query }) => {
    const definition = getMainDefinition(query);
    return (
      definition.kind === 'OperationDefinition' &&
      definition.operation === 'subscription'
    );
  },
  wsLink,
  from([errorLink, authLink.concat(httpLink)])
) : from([errorLink, authLink.concat(httpLink)])

const client = new ApolloClient({
  link: splitLink,
  cache: new InMemoryCache()
})

export {
  client
}

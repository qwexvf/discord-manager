import { InMemoryCache, ApolloClient, HttpLink, from } from "@apollo/client/core"
import { onError } from "@apollo/client/link/error"
import { session } from "$app/stores"
import { setContext } from "@apollo/client/link/context"
 
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

const client = new ApolloClient({
  link: from([errorLink, authLink.concat(httpLink)]),
  cache: new InMemoryCache()
})

export {
  client
}

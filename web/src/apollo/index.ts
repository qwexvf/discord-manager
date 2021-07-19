import { InMemoryCache, ApolloClient, HttpLink, from } from "@apollo/client/core"
import { onError } from "@apollo/client/link/error"
 
const httpLink = new HttpLink({
  uri: "http://192.168.2.102:4000/graphql"
})

const errorLink = onError(({ graphQLErrors, networkError }) => {
  if (graphQLErrors)
    graphQLErrors.forEach(({ message, locations, path }) => {
      console.log(`[GraphQL error]: Message: ${message}, Location: ${locations}, Path: ${path}`)
    })

    if (networkError) console.log(`[Network error]: ${networkError}`)
})

const client = new ApolloClient({
  link: from([errorLink, httpLink]),
  cache: new InMemoryCache()
})

export {
  client
}

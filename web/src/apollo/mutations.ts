import { gql } from "@apollo/client/core"

export const AUTHENTICATE_MUTAITON = gql`
mutation  authenticate($email: String!, $password: String!, $passwordConfirm: String!) {
  authenticate(email: $email, password: $password, passwordConfirm: $passwordConfirm) {
    messages {
      field
      message
      code
    }
    result {
      token
      user {
        id
        email
      }
    }
    successful
  }
}
`

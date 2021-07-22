import { gql } from "@apollo/client/core"

export const AUTHENTICATE_MUTAITON = gql`
mutation authenticate($email: String!, $password: String!, $passwordConfirm: String!) {
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

export const UPDATE_SCHEDULE = gql`
mutation updateSchedule($attrs: UpdateSchedule){
  updateSchedule(attrs: $attrs){
    messages {
      code
      message
    }
    result {
      message
    }
    successful
  }
}
`
export const CREATE_SCHEDULE = gql`
mutation createSchedule($attrs: CreateSchedule){
  createSchedule(attrs: $attrs){
    messages {
      field
      code
      message
    }
    result {
      message
    }
    successful
  }
}
`

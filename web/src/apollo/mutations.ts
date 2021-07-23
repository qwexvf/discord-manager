import { gql } from "@apollo/client/core"

export const REGISTER_MUTATION = gql`
mutation register($email: String!, $password: String!, $passwordConfirm: String!) {
  register(email: $email, password: $password, passwordConfirm: $passwordConfirm) {
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
export const LOGIN_MUTATION = gql`
mutation login($email: String!, $password: String!) {
  login(email: $email, password: $password) {
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

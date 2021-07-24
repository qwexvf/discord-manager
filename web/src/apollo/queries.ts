import { gql } from "@apollo/client/core"

export const SCHEDULES = gql`
query schedules {
  schedules {
    id
    message
    job {
      state
    }
  }
}
`

export const NEW_SCHEDULES = gql`
query schedules {
  schedules {
    id
    message
    job {
      state
    }
  }
}
`

import { writable } from "svelte/store"

export const theme = writable("white")

function updateTheme() {
	theme.update(_current => {
		return "g80"
	})
}

function createAuth() {
	const { subscribe, set, update } = writable({
		jwtToken: null
	})

	return {
		subscribe,
		login: (jwtToken) => update((state) => state.jwtToken = jwtToken),
		logout: () => set({jwtToken: null}),
	}
}

export const authStore = createAuth()

import { writable } from "svelte/store"

export const theme = writable("white")

export function updateTheme() {
	theme.update(_current => {
		console.log(_current)
		return "g80"
	})
}

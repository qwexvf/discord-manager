import preprocess from 'svelte-preprocess'

/** @type {import('@sveltejs/kit').Config} */
const config = {
	// Consult https://github.com/sveltejs/svelte-preprocess
	// for more information about preprocessors
	preprocess: preprocess(),

	kit: {
		// hydrate the <div id="svelte"> element in src/app.html
		target: '#svelte',
		vite: {
			resolve: {
				alias: {
					'svelte-apollo': '/node_modules/svelte-apollo/dist/svelte-apollo.es.js'
				}
			},
			optimizeDeps: {
				exclude: ["svelte-apollo"],
			}
		},
	},
}

export default config

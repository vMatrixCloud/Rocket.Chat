Template.oembedTwitterWidget.helpers
	description: ->
		console.log this
		console.log JSON.stringify this, null, '  '
		if not this.meta?
			return

		description = this.meta.ogDescription or this.meta.twitterDescription or this.meta.description
		if not description?
			return

		return description.replace /(^“)|(”$)/g, ''

	title: ->
		if not this.meta?
			return

		return this.meta.ogTitle or this.meta.twitterTitle or this.meta.title or this.meta.pageTitle

	image: ->
		if not this.meta?
			return

		return this.meta.ogImage or this.meta.twitterImage
Template.usernamePrompt.onCreated ->
	self = this
	self.username = new ReactiveVar
	self.password = new ReactiveVar

	Meteor.call 'getUsernameSuggestion', (error, username) ->
		self.username.set
			ready: true
			username: username
		Meteor.defer ->
			self.find('input').focus()

Template.usernamePrompt.helpers
	username: ->
		return Template.instance().username.get()
	showPassword: ->
		return 'hidden' unless Template.instance().password.get()

Template.usernamePrompt.events
	'submit #login-card': (event, instance) ->
		event.preventDefault()

		username = instance.username.get()
		username.empty = false
		username.error = false
		username.invalid = false
		instance.username.set username
		instance.password.set false

		button = $(event.target).find('button.login')
		RocketChat.Button.loading(button)

		value = $("input[name=username]").val().trim()
		if value is ''
			username.empty = true
			instance.username.set username
			instance.password.set false
			RocketChat.Button.reset(button)
			return

		password = $("input[name=pass]")[0]? && $("input[name=pass]").val().trim()
		if password
			Meteor.loginWithPassword value, password, (err, result) ->
				if err?
					username.error = true
					$("input[name=pass]").val('')

				RocketChat.Button.reset(button)
				instance.username.set(username)
		else
			Meteor.call 'setUsername', value, (err, result) ->
				if err?
					if err.error is 'username-invalid'
						username.invalid = true
					else if err.error is 'username-unavaliable' and RocketChat.settings.get('Accounts_RegistrationRequired') is false
						instance.password.set true
						Meteor.defer ->
							$('input[name=pass]').focus()
					else
						username.error = true
					username.username = value
				
				RocketChat.Button.reset(button)
				instance.username.set(username)
				
				if RocketChat.settings.get('Accounts_RegistrationRequired') is false and not err?
					Meteor.loginWithPassword value, result, ->

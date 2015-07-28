Meteor.methods
	setPassword: (password) ->
		if Meteor.userId()
			Accounts.setPassword Meteor.userId(), password, { logout: false }
			if RocketChat.settings.get('Accounts_RegistrationRequired') is false
				Meteor.users.update { _id: Meteor.userId() }, { $set: { passwordSet: true } }
			return true
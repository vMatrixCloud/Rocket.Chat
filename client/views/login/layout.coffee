Template.loginLayout.rendered = ->
	$('html').addClass("scroll").removeClass "noscroll"
	if RocketChat.settings.get('Accounts_RegistrationRequired') is true
		particlesJS.load 'particles-js', '/scripts/particles.json', ->
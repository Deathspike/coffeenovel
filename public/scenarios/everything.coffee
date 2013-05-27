# ==================================================
# Export the scenario.
# --------------------------------------------------
module.exports = (controller) ->
	# Initialize the Boy's Love boolean.
	bl	= false
	# Declare a background alias (for convenience).
	b = controller.background
	# Declare the sylvie_marry character.
	l = controller.character 'sylvie_marry'
	# Declare the me character.
	m = controller.character 'me'
	# Declare the sylvie character.
	s = controller.character 'sylvie'
	# Declare a text alias (for convenience).
	t = controller.text

	# ==============================================
	#
	# ----------------------------------------------
	controller.label 'normal', ->
		# controller.playStart 'illurock'

		b 'lecturehall', 'fade'
		t 'Well, professor Eileen\'s lecture was interesting.'
		t 'But to be honest, I couldn\'t concentrate on it very much.'
		t 'I had a lot of other thoughts on my mind.'
		t 'And they all ended up with a question.'
		t 'A question, I\'ve been meaning to ask someone.'

		b 'university', 'fade'
		t 'When we came out of the university, I saw her.'

		s.show 'normal', 'dissolve'
		t 'She was a wonderful person.'
		t 'I\'ve known her ever since we were children.'
		t 'And she\'s always been a good friend.'
		t 'But...'
		t 'Recently...'
		t 'I think...'
		t '... that I wanted more.'
		t 'More than just talking... more than just walking home together when our classes ended.'
		t 'And I decided...'

		controller.choose
			rightaway: '... to ask her right away.'
			later: '... to ask her later.'

	# ==============================================
	#
	# ----------------------------------------------
	controller.label 'rightaway', ->
		s.show 'smile'
		s 'Oh, hi, do we walk home together?'
		m 'Yes...'
		t 'I said and my voice was already shaking.'

		b 'meadow', 'fade'
		t 'We reached the meadows just outside our hometown.'
		t 'Autumn was so beautiful here.'
		t 'When we were children, we often played here.'
		m 'Hey... ummm...'

		s.show 'smile', 'dissolve'
		t 'She turned to me and smiled.'
		t 'I\'ll ask her...'
		m 'Ummm... will you...'
		m 'Will you be my artist for a visual novel?'

		s.show 'surprised'
		t 'Silence.'
		t 'She is shocked. And then...'

		s.show 'smile'
		s 'Sure, but what is a \'visual novel?\''

		controller.choose
			vn: 'It\'s a story with pictures.'
			hentai: 'It\'s a hentai game.'

	# ==============================================
	#
	# ----------------------------------------------
	controller.label 'vn', ->
		m 'It\'s a story with pictures and music.'
		m 'And you\'ll be able to make choices that influence the outcome of the story.'
		s 'So it\'s like those choose-your-adventure books?'
		m 'Exactly! I plan on making a small romantic story.'
		m 'And I figured you could help me... since I know how you like to draw.'

		s.show 'normal'
		s 'Well, I can try. I hope I don\'t disappoint you.'
		m 'You can\'t disappoint me, you know that.'
		controller.jump 'marry'

	# ==============================================
	#
	# ----------------------------------------------
	controller.label 'hentai', ->
		bl = true

		m 'Why it\'s a game with lots of sex.'
		s 'You mean, like a boy\'s love game?'
		s 'I\'ve always wanted to make one of those.'
		s 'I\'ll get right on it!'

		s.hide 'dissolve'
		t '...'

		m 'That wasn\'t what I meant!'
		controller.jump 'marry'

	# ==============================================
	#
	# ----------------------------------------------
	controller.label 'marry', ->
		b null, 'dissolve'
		t '--- years later ---'

		b 'club', 'dissolve'
		t 'And so, we became a visual novel creating team.'
		t 'We made games and had a lot of fun making them.'
		if bl then t 'Well, apart from that Boy\'s Love game she insisted on making.'

		t 'And one day...'
		l.show 'normal', 'dissolve'
		l 'Hey...'
		m 'Yes?'

		l.show 'giggle'
		l 'Marry me!'
		m 'What???'

		l.show 'surprised'
		l 'Well, don\'t you love me?'
		m 'I do, actually.'

		l.show 'smile'
		l 'See? We\'ve been making romantic visual novels, spending time together, helping each other....'
		l '... and when you give love to others, love will come to you.'
		m 'Hmmm, that\'s a nice thought.'

		l.show 'giggle'
		l 'I just made that up.'
		m 'But it\'s good.'

		l.show 'normal'
		l 'I know. So, will you marry me?'
		m 'Ummm, of course I will. I\'ve actually been meaning to ask you, but since you brought it up...'
		l 'I know, but you are so indecisive, that I thought I\'d take the initiative. '
		m 'I guess... It\'s all all about asking the right question... at the right time.'

		l.show 'giggle'
		l 'It is. But now, stop being theoretical, and give me a kiss!'

		b null, 'dissolve'
		t 'And we got married shortly after that.'
		t 'In fact, we made many more visual novels.'
		t 'And together, we lived happily ever after.'

	# ==============================================
	#
	# ----------------------------------------------
	controller.label 'later', ->
		b null, 'dissolve'
		t 'And so I decided to ask her later.'
		t 'But I was indecisive.'
		t 'I couldn\'t ask her that day, and I couldn\'t ask her later.'
		t 'I guess I will never know now.'

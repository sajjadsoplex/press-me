class PressStage {
  final int number;
  final String text;
  final String atmosphere;

  const PressStage({
    required this.number,
    required this.text,
    required this.atmosphere,
  });
}

const List<PressStage> stages = [
  PressStage(
    number: 0,
    text: 'There is only one way to find out.',
    atmosphere: 'beginning',
  ),

  PressStage(
    number: 1,
    text: 'Hmm. You actually pressed it.',
    atmosphere: 'mystery',
  ),

  PressStage(
    number: 2,
    text: 'Interesting… I wonder how curious you are.',
    atmosphere: 'stars',
  ),

  PressStage(
    number: 3,
    text: "Okay, you're committed now. Let's see where this goes.",
    atmosphere: 'mountains',
  ),

  PressStage(
    number: 4,
    text: 'A little rain never hurt an adventure.',
    atmosphere: 'rain',
  ),

  PressStage(
    number: 5,
    text:
        "Some people look at the sky. Some people wonder what's beyond it.",
    atmosphere: 'sky',
  ),

  PressStage(
    number: 6,
    text: 'No turning back now.',
    atmosphere: 'trail',
  ),

  PressStage(
    number: 7,
    text:
        'Every adventure starts with one small step. Even the crazy ones.',
    atmosphere: 'poetry',
  ),

  PressStage(
    number: 8,
    text:
        'Apparently, you have excellent button-pressing skills.',
    atmosphere: 'analysis',
  ),

  PressStage(
    number: 9,
    text: '',
    atmosphere: 'final',
  ),
];
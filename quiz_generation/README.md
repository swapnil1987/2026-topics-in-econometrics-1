# Quiz generation code

Quiz-generation code is kept separate from the quiz artifacts students may download.

Run the mock generator from the repository root:

```powershell
python quiz_generation/generate_mock_quiz.py
```

It writes the five-form mock quiz and mock instructor key to `quiz/mock_quiz/`. Future generators should write each quiz only to its corresponding local `quiz/quizN/` folder. Those numbered folders are ignored by Git until the instructor explicitly authorizes a commit and push.

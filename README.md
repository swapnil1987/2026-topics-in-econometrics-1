# Econometric Theory and Practice I (2026/27)

This repository contains teaching materials for **Econometric Theory and Practice I**.

## Course source

The initial course context comes from the Google Doc [Syllabus (2026/27) – Swapnil Singh](https://docs.google.com/document/d/1Hd96R5cFeWp88_j5khsMh3OnWdnjoY2MtuhkvKZpSxM). The textbook, lecture materials, and problem sets will be added as they become available.

## Quizzes

Quizzes are short, in-class assessments based only on material already taught and exercises already made available to students. The working format is three multiple-choice questions, seven choices per question, and five coded forms. Each question is worth **one point**. Scores are reported as points, not percentages.

### Quiz rules

> **Critical student-ID rule:** Fill in all three digits of your student ID correctly and carefully. An incorrect, incomplete, or unreadable ID cannot be corrected after submission under any circumstances. If the sheet cannot be assigned using the ID that was bubbled, the student receives **zero points for that quiz**.

1. **Academic integrity is a zero-tolerance requirement.** Copying, attempting to copy, sharing answers, communicating with another student, exchanging papers, or giving or receiving unauthorized help is prohibited. A student caught cheating on a quiz or midterm receives **zero for that assessment**, in addition to any further action required by university rules.
2. **AI tools are prohibited.** ChatGPT, Copilot, Gemini, and every other generative-AI or automated answer tool may not be used during a quiz or midterm.
3. **Electronic devices must be put away.** Phones, smartwatches, tablets, laptops, headphones, and similar devices may not be used unless the instructor explicitly authorizes a device for that assessment.
4. **Mark exactly one answer per question.** Fill the selected bubble clearly. Multiple, ambiguous, incomplete, or stray marks may be treated as an unanswered question. Answers written elsewhere are not graded unless the instructor explicitly states otherwise.
5. **Do not damage the machine-readable areas.** Do not write on the QR code, the small form code, or the corner alignment marks. Do not detach, exchange, or replace quiz pages.
6. **Follow the announced materials policy.** Notes, books, calculators, software, and other aids are prohibited unless the instructor explicitly permits them for that assessment.
7. **Stop when time is called.** Continuing to write, alter bubbles, or communicate after collection begins is not permitted.
8. **Scoring is by points.** Each correct answer earns one point; an incorrect or blank answer earns zero points. There is no negative marking unless a later quiz explicitly says otherwise.
9. **Approved accommodations remain valid.** Students with formally approved accommodations should arrange them through the established university process before the assessment.

### Mock quiz materials

The following files are a practice prototype, not a live graded quiz:

- [Five-form mock quiz](quiz/mock_quiz/mock_quiz_five_forms.pdf) — five one-page A4 versions with QR-based form identification;
- [Completed mock answer sheets](quiz/mock_quiz/mock_quiz_answer_sheets.pdf) — the scanned practice sheets used to test recognition;
- [Mock quiz instructor key](quiz/mock_quiz/mock_quiz_instructor_key.pdf) — the answer mapping for the practice forms; and
- [Grade Excel](quiz/grades.xlsx) — the simple points record produced from the mock scans.

The cumulative grade workbook at `quiz/grades.xlsx` will be updated after each quiz. It will retain three-digit student IDs, including leading zeroes, and record points rather than percentages.

### Quiz folders and release control

```text
quiz/
  grades.xlsx
  mock_quiz/
  quiz1/
  quiz2/
  quiz3/
  quiz4/
quiz_generation/
```

Each numbered quiz folder is reserved for that quiz's print files, answer materials, key, and related records. Numbered weekly quiz content must remain local and must **not** be committed or pushed to GitHub until the instructor explicitly authorizes that particular quiz. The repository's `.gitignore` enforces this rule while retaining a placeholder README in each folder.

The generator code is kept separately in [`quiz_generation`](quiz_generation/README.md). The full design and scan-to-grade workflow are documented in [the quiz-system plan](docs/quiz-system-plan.md).

## Working principle

No numbered quiz is a live assessment until its content, version equivalence, answer keys, print layout, and scanning behavior have been checked. Once a quiz is printed, its released forms and key mapping must be frozen; any later correction must be documented rather than silently overwriting the administered version.

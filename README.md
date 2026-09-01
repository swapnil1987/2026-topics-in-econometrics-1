# Econometric Theory and Practice I (2026/27)

This repository contains teaching materials for **Econometric Theory and Practice I**.

## Lectures

- [Lecture 1: Asking Questions with Data](slides/lecture-01.qmd)

## Reproducible R and Quarto environment

Course examples use R and lecture slides use Quarto Reveal.js. Work from WSL with the Miniconda environment declared in [`environment.yml`](environment.yml).

```bash
source "$HOME/miniconda3/etc/profile.d/conda.sh"
conda env create --file environment.yml
conda activate topics-econometrics
quarto check
```

If the environment already exists, synchronize it after changes with:

```bash
conda env update --name topics-econometrics --file environment.yml --prune
```

Render the reusable example deck from the repository root:

```bash
./scripts/render-slides.sh
```

For live editing and browser refresh:

```bash
conda run --name topics-econometrics quarto preview slides/template.qmd
```

The shared 16:9 theme uses a clean white canvas with coral-red, charcoal, and warm-grey accents. Equations use bundled Latin Modern Math for a consistent Computer Modern–style appearance without a network dependency. Its Reveal.js techniques build on Emil Hvitfeldt's [Creating Stunning Presentations with Quarto](https://emilhvitfeldt.github.io/talk-jsm-stunning-presentations/#/revealjs-api). Copy `slides/template.qmd` for a new lecture and keep common styling in `slides/theme/course.scss`.

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

- [Mock quiz](quiz/mock_quiz/mock_quiz_five_forms.pdf)
- [Mock answers](quiz/mock_quiz/mock_quiz_instructor_key.pdf)
- [Example of a filled mock quiz](quiz/mock_quiz/mock_quiz_answer_sheets.pdf)

**[Grade Excel](quiz/grades.xlsx)**

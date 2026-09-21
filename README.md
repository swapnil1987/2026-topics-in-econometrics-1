# Econometric Theory and Practice I (2026/27)

## News

**21 September 2026 — Quiz 2 solutions and grades are available.** [Read the answer key and worked solutions](quiz/quiz2/quiz2_instructor_key.pdf) and [download the grades workbook](quiz/grades.xlsx) (see the **Quiz 2** sheet).

**18 September 2026 — Practice Set 3 is uploaded!** [Open the 25 practice questions and worked solutions](https://swapnil1987.github.io/2026-topics-in-econometrics-1/practice-03.html), progressing from easy to hard and covering regression through the causal-diagram slide.

## Syllabus and grading

This course introduces econometrics: the statistical study of economic data. We will use simulations and real-world data to understand how econometric methods work, while also studying the mathematical ideas, derivations, and assumptions behind them. By the end of the course, students should be able to conduct basic regression analysis and explain the assumptions on which it depends.

- **Instructors:** Dr. Swapnil Singh ([ssingh@lb.lt](mailto:ssingh@lb.lt)) and Dr. Soroosh Soofi Siavas ([soroosh.siavash@evaf.vu.lt](mailto:soroosh.siavash@evaf.vu.lt))
- **Class:** Wednesday, 10:00–13:00, room 803
- **Textbook:** James H. Stock and Mark W. Watson, *Introduction to Econometrics*, 3rd edition
- **Programming language:** R
- **Full syllabus and calendar:** [Syllabus (2026/27)](https://docs.google.com/document/d/e/2PACX-1vTls61OE6I2-90skH63PY-iX5-ka8NfcWcShoPk1v32Qh-qD_GDCB91KTIiAfvEgbCM1mFpAEWBdBYE/pub)

### Grading scheme

| Assessment | Weight |
|---|---:|
| In-class quizzes | 30% |
| Midterm exam | 20% |
| Final exam | 50% |

Problem sets are not graded, but students are expected to complete them. Quiz questions will be based on the problem sets and material already covered in class. Consult the current syllabus and Moodle announcements for confirmed assessment dates, rooms, and any schedule changes.

## Questions

Students can ask course-related questions by creating a [GitHub issue](https://github.com/swapnil1987/2026-topics-in-econometrics-1/issues). You must be logged in to a GitHub account to create or comment on an issue.

## Lectures

Open a lecture below to view the slides directly in your browser. Use the arrow keys, space bar, or swipe to move through them. **No installation or compilation is required.**

### Lecture 1: Introduction and probability review

2 September · Stock and Watson, Chapters 1–2

- [View the slides](https://swapnil1987.github.io/2026-topics-in-econometrics-1/lecture-01.html)
- [Practice set 1: questions and worked solutions](https://swapnil1987.github.io/2026-topics-in-econometrics-1/practice-01.html)
- [View the R code](codes/lecture-1/)

### Lecture 2: From Means to Regression

9 September · Stock and Watson, Chapters 3–4 (selected sections)

Estimation, hypothesis testing, and simple linear regression.

- [View the slides](https://swapnil1987.github.io/2026-topics-in-econometrics-1/lecture-02.html)
- [Slide source](slides/lecture-02.qmd)
- [Practice set 2: 15 questions and worked solutions](https://swapnil1987.github.io/2026-topics-in-econometrics-1/practice-02.html) — through slide 49, plus the law of large numbers and central limit theorem; easy to hard.
- [Notebook instructions](colab/lecture-2/README.md)

#### Classroom code

Run these five examples in order. Each includes intuition, a reproducible simulation,
a plot, and a suggested live edit. All examples use R and require no external dataset.

| Topic | R script | Notebook | Google Colab |
|---|---|---|---|
| Law of large numbers | [R code](R/colab-lecture-02/01_law_of_large_numbers.R) | [Notebook](colab/lecture-2/01_law_of_large_numbers.ipynb) | [Open in Colab](https://colab.research.google.com/drive/1bc-U8zp2-wSPcCQBV03lEiF6S5VsX8B9) |
| Central limit theorem | [R code](R/colab-lecture-02/02_central_limit_theorem.R) | [Notebook](colab/lecture-2/02_central_limit_theorem.ipynb) | [Open in Colab](https://colab.research.google.com/drive/1vNQyiIP-wjZOYhVhTkP2dFj1bUzqZ-Kw) |
| Unbiasedness | [R code](R/colab-lecture-02/03_unbiasedness.R) | [Notebook](colab/lecture-2/03_unbiasedness.ipynb) | [Open in Colab](https://colab.research.google.com/drive/1ZRuvLvt-fgXOnEFe9pOcYrq2YV22M6zJ) |
| Consistency | [R code](R/colab-lecture-02/04_consistency.R) | [Notebook](colab/lecture-2/04_consistency.ipynb) | [Open in Colab](https://colab.research.google.com/drive/1avT-lxplEVddmugvAVSJXofZAqsk-cnr) |
| P-value | [R code](R/colab-lecture-02/05_p_value.R) | [Notebook](colab/lecture-2/05_p_value.ipynb) | [Open in Colab](https://colab.research.google.com/drive/1enFm6U0JiTwVmNjBeBbhsW4LDVYHEA7W) |

The Google Colab copies are in the [private Lecture 2 Drive folder](https://drive.google.com/drive/folders/14kl89bVpSLaW7zJXhDrDociIUmVBkhsQ)
and require permission to access. Alternatively, download a notebook from this repository
and upload it to your own Colab session. Use **Runtime → Run all** to execute the full example.

Earlier [combined examples](codes/lecture-2/) and [reusable R functions](R/lecture-02.R)
remain available as reference material; they are not the current classroom sequence.

### Lecture 3: Regression and causal interpretation

Continues the regression material in the [Lecture 2 slide deck](https://swapnil1987.github.io/2026-topics-in-econometrics-1/lecture-02.html), from “The linear regression model” through “A causal diagram makes the omitted path visible.”

- [Practice set 3: 25 questions and worked solutions](https://swapnil1987.github.io/2026-topics-in-econometrics-1/practice-03.html) — easy to hard, with selected Stock and Watson adaptations; covers OLS, fit, prediction, and the causal assumptions taught so far.
- [Practice set 3 source](slides/practice-03.qmd)

## Quizzes

Quizzes are short, in-class assessments based only on material already taught and exercises already made available. The working format is three multiple-choice questions, seven answer choices per question, and five equivalent coded forms. Each correct answer earns one point. Incorrect and blank answers receive zero points; there is no negative marking unless announced otherwise.

> **Student ID is essential.** Fill in all three digits of your student ID correctly and clearly. An incorrect, incomplete, or unreadable ID cannot be corrected after submission. If the quiz cannot be assigned using the bubbled ID, the score is zero.

### Quiz rules

1. Work independently. Copying, communicating, sharing answers, exchanging papers, or giving or receiving unauthorized help results in zero for the assessment and may lead to further action under university rules.
2. AI and automated answer tools, including ChatGPT, Copilot, and Gemini, are prohibited during quizzes and exams.
3. Phones, smartwatches, tablets, laptops, headphones, and similar devices must be put away unless the instructor explicitly authorizes them.
4. Mark exactly one answer per question and keep the QR code, form code, and corner alignment marks clean and unobstructed.
5. Notes, books, calculators, software, and other aids are prohibited unless explicitly permitted for that assessment.
6. Stop writing and communicating when time is called.
7. Formally approved accommodations remain valid and should be arranged through the established university process.

### Practice materials

- [Mock quiz](quiz/mock_quiz/mock_quiz_five_forms.pdf)
- [Mock quiz answer key](quiz/mock_quiz/mock_quiz_instructor_key.pdf)
- [Example completed answer sheets](quiz/mock_quiz/mock_quiz_answer_sheets.pdf)

### Quiz 1: Probability review

- [Quiz 1: all five forms](quiz/quiz1/quiz1_five_forms.pdf)
- [Quiz 1: answer key and worked solutions](quiz/quiz1/quiz1_instructor_key.pdf)
- [Quiz 1 grades (Excel)](quiz/grades.xlsx)

### Quiz 2: Estimation and inference

- [Quiz 2: answer key and worked solutions](quiz/quiz2/quiz2_instructor_key.pdf)
- [Quiz 2 grades (Excel)](quiz/grades.xlsx) — open the **Quiz 2** sheet.

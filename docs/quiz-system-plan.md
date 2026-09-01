# Five-Version Quiz and Automated Grading Plan

**Course:** Econometric Theory and Practice I
**Academic year:** 2026/27
**Status:** Mock-format, scan, and points-workbook prototype produced - no live graded quiz has been approved
**Syllabus source:** [Syllabus (2026/27) – Swapnil Singh](https://docs.google.com/document/d/1Hd96R5cFeWp88_j5khsMh3OnWdnjoY2MtuhkvKZpSxM)

## 1. Purpose

The aim is to run short, frequent, low-administration in-class quizzes that:

- test material taught in the previous class;
- discourage copying in a large classroom;
- are fair across students receiving different versions;
- can be marked from scanned bubble sheets rather than by hand; and
- produce a transparent Excel record that can be checked and corrected.

The working format is **three multiple-choice questions per quiz** and **five underlying forms**. Students see a randomized alphanumeric form code rather than A–E or 1–5. They enter a three-digit numeric student ID and mark their answers using bubbles; they do not need to identify their form separately.

## 2. Course facts that constrain the design

The syllabus currently states that:

- in-class quizzes given by Swapnil Singh account for 30% of the final grade;
- quizzes are based on the problem sets;
- the main textbook is Stock and Watson, *Introduction to Econometrics*, with syllabus chapter numbers based on the third edition;
- R is used for applied work; and
- the first teaching block covers Sep 3 through Oct 1, followed by the midterm on Oct 8.

The first class on Sep 3 covers introduction and probability review. If a quiz begins in the next class and continues through the pre-midterm teaching block, the current working assumption is four quizzes:

| Working quiz | Class date | Primarily assesses |
| --- | --- | --- |
| Quiz 1 | Sep 10 | Sep 3: introduction and probability review |
| Quiz 2 | Sep 17 | Sep 10: statistics review and simple linear regression |
| Quiz 3 | Sep 24 | Sep 17: properties of the OLS estimator |
| Quiz 4 | Oct 1 | Sep 24: hypothesis testing |

This schedule is provisional. It does not assume a quiz on the Oct 8 midterm date.

### Calendar issue to resolve

The syllabus logistics say the class meets on **Wednesday**, but Sep 3, Sep 10, Sep 17, Sep 24, Oct 1, and Oct 8 all fall on **Thursday in 2026**. The meeting day and the calendar dates should be reconciled before any dated quiz files are produced.

### Problem-set timing issue to resolve

The syllabus says quizzes will be based on problem sets, but the calendar appears to mention a problem set on some of the same dates on which a quiz would occur. Each assessed problem set must be released early enough for students to attempt it before the relevant quiz. The content rule should therefore be:

> A quiz may assess only material already taught and exercises already made available before the quiz.

## 3. Recommended anti-cheating design

### Recommendation: a controlled hybrid

Start with one canonical three-question quiz, then produce five versions using the following hierarchy:

1. **Reorder the three questions** across versions.
2. **Reorder the answer choices** within each question using a constrained shuffle.
3. **Vary numerical inputs or examples only when equivalence is easy to prove.**

This gives neighboring students visibly different papers without creating five independently written assessments. It also limits the risk that one version is unintentionally harder.

For conceptual questions, answer-choice and question-order changes should normally be enough. For numerical questions, a small parameter change can strengthen version separation, provided that:

- the same reasoning steps are required;
- arithmetic complexity is comparable;
- rounding conventions are identical;
- distractors represent the same mistakes; and
- the intended learning objective is unchanged.

Free-form rewriting of stems merely to make versions look different should be avoided. It adds ambiguity and makes equivalence harder to defend.

### Constrained rather than manual shuffling

Version generation should be systematic. The generator should avoid patterns such as all correct answers being the same letter, identical answer sequences across adjacent versions, or a correct option being moved while a phrase such as “all of the above” is left incoherent.

Each version must be linked to an explicit answer-key manifest. The printed label “Version C,” for example, should never be the only record of how C was constructed.

### Classroom distribution

The five forms can be distributed in a repeating seating pattern so that adjacent students are unlikely to receive the same form. Papers should be handed out face down and students should be told not to begin until distribution is complete. Collection can keep all forms together; the grading workflow will identify each form from its QR code.

The QR code is the primary form identifier. Its randomized form code should appear only in very small, low-contrast type beside the QR marker and again in the footer as a recovery fallback, making it difficult to read from a neighboring seat. The QR code encodes only the course, quiz ID, form code, and revision. It must not contain a student’s identity or any answer information.

## 4. Fairness and content-control standard

Every canonical question should have a short item specification before versions are produced:

- learning objective;
- source lecture and, when relevant, problem-set reference;
- skill being tested (definition, interpretation, calculation, assumption, or application);
- canonical stem, options, correct answer, and explanation;
- permitted transformations across versions;
- common misconception represented by each distractor; and
- expected solution time.

The five versions should then pass an equivalence check:

- same learning objectives and points;
- same number of reasoning steps;
- similar reading and arithmetic burden;
- exactly one defensible answer per question;
- no dependence on material not yet taught; and
- no accidental clue created by wording, length, units, or option order.

The answer key and explanation should be solved independently once after the versions are generated. This is especially important for parameterized numerical questions.

## 5. Recommended paper format

Because there are only three questions, the selected prototype format is a **single-sided A4 sheet per student**:

- quiz title and date, with QR-based form identification and only a very small low-contrast fallback code;
- three questions with multiple-choice options;
- a clearly separated response panel;
- permission to use the blank reverse side for calculations; and
- four corner marks or similar alignment anchors for reliable scanning.

The response panel should contain:

1. exactly three student-ID columns, with bubbles 0–9 in each column;
2. one response row for each of Questions 1–3, with seven answer choices A–G;
3. a QR code containing the course, quiz, randomized form code, and revision, but no answers;
4. a printed randomized alphanumeric form code that serves as a human-readable fallback;
5. brief marking instructions.

Students do not bubble or receive a simple A–E or 1–5 version label. The QR code and the randomized form code identify the answer-key mapping. If those two identifiers disagree, the sheet should be sent to review rather than silently graded.

Student IDs must always display as three digits in the grading workbook so that leading zeroes are preserved.

### Marking instructions to standardize later

Students should use one specified writing instrument, fill bubbles fully, erase cleanly, and make exactly one mark per question. These instructions must be tested against the actual printer and scanner; visual neatness alone does not guarantee reliable recognition.

## 6. Source-of-truth files for each future quiz

Each live quiz should eventually have four synchronized outputs generated from the same source:

1. **Canonical item file** — the three underlying questions, explanations, sources, and transformation rules.
2. **Five print-ready versions** — A through E.
3. **Answer-key manifest** — for each printed position, the item shown and its correct answer.
4. **Grading configuration** — layout coordinates and recognition settings for the response panel.

This separation matters. Question 1 on Version A may be the same underlying item as Question 3 on Version D, and its correct letter may differ after options are shuffled. The answer-key manifest must resolve both mappings.

For auditability, every quiz release should receive a stable quiz ID and revision. Once papers are printed, the version files and answer keys should be frozen. Any correction should create a recorded revision rather than overwriting the evidence of what students received.

## 7. Scan-to-Excel grading workflow

### Inputs

- one PDF or a set of images containing completed sheets;
- the quiz’s frozen answer-key manifest;
- the response-panel layout configuration; and
- optionally, an official class roster used only to validate student IDs.

### Processing

The grading workflow should:

1. split a batch scan into individual pages;
2. detect the page anchors, correct rotation/perspective, and locate the response panel;
3. read the quiz/version code from the QR marker and tiny printed fallback code;
4. read the numeric student ID and the three responses;
5. compare responses with the key for that version;
6. calculate item correctness and total score; and
7. attach recognition confidence and any validation flags.

The system must not guess when a mark is ambiguous. Blank answers, multiple marks, weak marks, invalid IDs, unreadable pages, unknown versions, or version mismatches should enter a **human-review queue**. A reviewer’s correction should be recorded separately from the originally detected value.

### Excel workbook

The public-facing cumulative workbook is `quiz/grades.xlsx`. It is intentionally minimal: one row per student, a three-digit `Student ID`, and point totals. Each question earns one point, and the workbook reports points rather than percentages. The current mock workbook contains only the mock result; a new points column can be added after each approved live quiz.

Detailed responses, answer-key mappings, scan confidence, and review decisions should remain in the relevant local numbered quiz folder. They are grading evidence, not part of the student-facing summary workbook. A large score gap by version should still trigger an internal review of item equivalence or the key/layout, but it should not automatically change grades.

## 8. Quality assurance before the first live quiz

The blank form and grader should be tested end to end before being used with students:

1. print all five versions on the actual printer;
2. mark a test set with light, dark, erased, double, and stray marks;
3. include pages rotated slightly and scanned in mixed order;
4. scan using the actual device and settings;
5. compare every detected ID, version, and answer with the known truth;
6. verify that ambiguous cases are flagged rather than guessed;
7. open the Excel file and check leading zeroes, formulas, filters, and totals; and
8. retain the test evidence and agreed recognition thresholds.

For live use, conduct two checks before releasing grades:

- reconcile the number of processed sheets with the number collected; and
- manually sample a small set of unflagged sheets across all five versions.

## 9. Course workflow for creating later quizzes

After each class, the intended handoff is:

1. provide the lecture slides/notes, relevant textbook pages, and the problem set students received;
2. record exactly what was and was not covered in class;
3. agree on the three learning objectives for the next quiz;
4. draft and review the three canonical questions;
5. generate five coded forms under the controlled hybrid rules;
6. validate all answers, explanations, and version mappings;
7. produce the print files, frozen key, and grading configuration together; and
8. after the quiz, process scans, review exceptions, and export the final workbook.

The “material actually taught” note is essential. The syllabus and textbook define the planned scope, but the quiz should follow the delivered class when the two differ.

## 10. Grading-policy decisions still needed

Before the first quiz becomes grade-bearing, decide and tell students:

- whether four quizzes is the correct count for this teaching block;
- how the 30% quiz component is divided across instructors and quizzes;
- whether all quizzes count or the lowest score is dropped;
- the policy for absence, late arrival, and make-up quizzes;
- whether calculators, notes, or devices are allowed;
- quiz duration; and
- how and when answers or explanations will be released.

The settled scoring rule is one point per correct answer, zero for an incorrect or blank answer, and no percentages. The prototype fixes the response layout at three ID digits and seven answer choices. Those settings should change only if the official student-ID system or teaching policy requires it.

## 11. Main risks and controls

| Risk | Control |
| --- | --- |
| One version is harder | Canonical items, restricted transformations, equivalence review, and post-quiz version comparison |
| Wrong answer key | Generate print files and keys from one source, independently solve, and freeze revisions |
| Students receive the same nearby form | Planned five-form seating distribution and randomized visible form codes |
| Form cannot be identified | QR code plus tiny printed fallback code; unreadable or inconsistent identifiers go to review |
| Scanner misreads marks | Alignment anchors, fixed layout, confidence thresholds, human-review queue, and preflight tests |
| Leading zeroes disappear from IDs | Apply a three-digit ID format and validate against the roster if available |
| A problem-set question is assessed too early | Require a release-before-assessment check for every item |
| Grade cannot be audited | Preserve source page, detected values, corrections, key revision, and timestamps |
| Personal data is exposed | Use student IDs rather than names on sheets, restrict raw scans/workbooks, and define retention rules |

## 12. Repository structure

The implemented quiz structure is:

```text
docs/
  quiz-system-plan.md
quiz/
  grades.xlsx
  mock_quiz/
    mock_quiz_five_forms.pdf
    mock_quiz_answer_sheets.pdf
    mock_quiz_instructor_key.pdf
  quiz1/
  quiz2/
  quiz3/
  quiz4/
quiz_generation/
  generate_mock_quiz.py
```

The `.gitignore` keeps numbered weekly quiz content local until the instructor explicitly authorizes that quiz for GitHub. Raw live-student scans remain excluded by default. The mock answer sheets and mock grade workbook contain only prototype data and are intentionally included for demonstration.

## 13. Staged implementation plan

### Stage 1 — Inputs and policy

Receive the textbook/course materials, confirm the meeting calendar, quiz count, grading policy, ID format, and answer-choice count.

### Stage 2 — Format prototype (completed for review)

Create a one-page A4 prototype, five randomized form codes, and a provisional Excel schema. The PDF prototype and a completed mock scan batch have been checked; testing with the actual classroom printer and scanner remains outstanding.

### Stage 3 — Generation and grading prototype

Implement the single-source version mapping and a repeatable scan grader. The mock batch has been read and reconciled manually; full automated recognition and deliberate faint/double-mark stress tests remain to be implemented.

### Stage 4 — First live quiz

Create Quiz 1 from the Sep 3 material actually taught, run content/equivalence checks, freeze the release, print, administer, scan, review exceptions, and export the workbook.

### Stage 5 — Routine operation

Repeat the same frozen-source workflow for later quizzes and refine recognition thresholds only from documented evidence, never by silently changing how an already-administered quiz is graded.

## 14. Current stopping point

The repository now includes five one-page mock forms, completed mock answer sheets, a mock instructor key, a simple points workbook, and separate generation code. Their three questions are illustrative layout content, not approved course-assessment items. No live numbered quiz has been approved. The next safe step is to test the form with the actual classroom printer and scanner, incorporate the textbook and delivered lecture material, and resolve the remaining policy decisions in Sections 2 and 10 before producing Quiz 1. Numbered quiz content must remain local until the instructor explicitly authorizes its commit and push.

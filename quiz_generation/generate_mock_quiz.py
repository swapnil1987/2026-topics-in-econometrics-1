from pathlib import Path

from reportlab.graphics import renderPDF
from reportlab.graphics.barcode.qr import QrCodeWidget
from reportlab.graphics.shapes import Drawing
from reportlab.lib import colors
from reportlab.lib.enums import TA_LEFT
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.pdfbase.pdfmetrics import stringWidth
from reportlab.pdfgen import canvas
from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "quiz" / "mock_quiz"
STUDENT_PDF = OUTPUT_DIR / "mock_quiz_five_forms.pdf"
KEY_PDF = OUTPUT_DIR / "mock_quiz_instructor_key.pdf"

PAGE_W, PAGE_H = A4
INK = colors.HexColor("#17233C")
BLUE = colors.HexColor("#235D9F")
PALE_BLUE = colors.HexColor("#EAF2FA")
MID_BLUE = colors.HexColor("#B9D0E8")
LIGHT_GREY = colors.HexColor("#F3F5F7")
MID_GREY = colors.HexColor("#98A2B3")


FORMS = [
    {
        "code": "K7M2",
        "order": ["data", "expectation", "variance"],
        "target_letters": ["B", "E", "G"],
        "expectation": {
            "p_zero": 0.75,
            "high": 4,
            "correct": 1,
            "distractors": [0, 2, 3, 4, 0.25, 0.75],
        },
        "variance": {
            "var_y": 2,
            "a": 3,
            "b": 1,
            "correct": 18,
            "distractors": [2, 3, 6, 9, 17, 19],
        },
    },
    {
        "code": "R4X9",
        "order": ["expectation", "variance", "data"],
        "target_letters": ["A", "F", "C"],
        "expectation": {
            "p_zero": 0.60,
            "high": 5,
            "correct": 2,
            "distractors": [0, 1, 3, 4, 5, 0.40],
        },
        "variance": {
            "var_y": 3,
            "a": 2,
            "b": -4,
            "correct": 12,
            "distractors": [2, 3, 6, 8, 10, 16],
        },
    },
    {
        "code": "T8Q3",
        "order": ["variance", "data", "expectation"],
        "target_letters": ["D", "B", "F"],
        "expectation": {
            "p_zero": 0.20,
            "high": 5,
            "correct": 4,
            "distractors": [0, 1, 2, 3, 5, 8],
        },
        "variance": {
            "var_y": 4,
            "a": 3,
            "b": 2,
            "correct": 36,
            "distractors": [3, 4, 12, 16, 34, 38],
        },
    },
    {
        "code": "V6N1",
        "order": ["data", "variance", "expectation"],
        "target_letters": ["G", "C", "E"],
        "expectation": {
            "p_zero": 0.40,
            "high": 5,
            "correct": 3,
            "distractors": [0, 1, 2, 4, 5, 0.60],
        },
        "variance": {
            "var_y": 5,
            "a": 2,
            "b": 7,
            "correct": 20,
            "distractors": [5, 7, 10, 13, 27, 35],
        },
    },
    {
        "code": "Z3P7",
        "order": ["expectation", "data", "variance"],
        "target_letters": ["F", "D", "A"],
        "expectation": {
            "p_zero": 0.25,
            "high": 8,
            "correct": 6,
            "distractors": [0, 2, 4, 5, 8, 0.75],
        },
        "variance": {
            "var_y": 2,
            "a": 4,
            "b": -3,
            "correct": 32,
            "distractors": [2, 4, 8, 16, 29, 35],
        },
    },
]


def format_probability(value):
    return f"{value:.2f}"


def arrange_options(correct, distractors, target_letter, rotation):
    letters = "ABCDEFG"
    target_index = letters.index(target_letter)
    wrong = [str(value) for value in distractors]
    shift = rotation % len(wrong)
    wrong = wrong[shift:] + wrong[:shift]
    options = []
    wrong_iter = iter(wrong)
    for index in range(7):
        options.append(str(correct) if index == target_index else next(wrong_iter))
    assert len(set(options)) == 7, options
    return options


def question_spec(form, topic, target_letter, rotation):
    if topic == "data":
        text = (
            "An economist records Lithuania's unemployment rate in every month "
            "from January 2016 through December 2025. What type of dataset is this?"
        )
        correct = "A time-series dataset"
        distractors = [
            "A cross-sectional dataset",
            "A panel dataset",
            "An experimental dataset",
            "A pooled cross-sectional dataset",
            "A matched-pairs experiment",
            "None of the above",
        ]
        short = "Data type"
    elif topic == "expectation":
        values = form["expectation"]
        p_zero = values["p_zero"]
        p_high = 1 - p_zero
        high = values["high"]
        correct = str(values["correct"])
        distractors = values["distractors"]
        text = (
            f"A discrete random variable X equals 0 with probability "
            f"{format_probability(p_zero)} and equals {high} with probability "
            f"{format_probability(p_high)}. What is E[X]?"
        )
        short = f"Expectation: P(X=0)={format_probability(p_zero)}, high={high}"
    elif topic == "variance":
        values = form["variance"]
        var_y = values["var_y"]
        a = values["a"]
        b = values["b"]
        correct = str(values["correct"])
        sign = "+" if b >= 0 else "-"
        b_text = abs(b)
        distractors = values["distractors"]
        text = (
            f"Suppose Var(Y) = {var_y} and X = {a}Y {sign} {b_text}. "
            "What is Var(X)?"
        )
        short = f"Variance: Var(Y)={var_y}, multiplier={a}"
    else:
        raise ValueError(topic)

    options = arrange_options(correct, distractors, target_letter, rotation)
    return {
        "topic": topic,
        "short": short,
        "text": text,
        "options": options,
        "correct_letter": target_letter,
    }


def build_form_questions(form, form_index):
    questions = []
    for q_index, topic in enumerate(form["order"]):
        target = form["target_letters"][q_index]
        questions.append(question_spec(form, topic, target, form_index + q_index))
    return questions


def draw_qr(c, payload, x, y, size):
    widget = QrCodeWidget(payload)
    x1, y1, x2, y2 = widget.getBounds()
    width = x2 - x1
    height = y2 - y1
    drawing = Drawing(size, size, transform=[size / width, 0, 0, size / height, 0, 0])
    drawing.add(widget)
    renderPDF.draw(drawing, c, x, y)


def draw_fiducials(c):
    size = 3.2 * mm
    offset = 6 * mm
    c.setFillColor(colors.black)
    for x, y in [
        (offset, offset),
        (PAGE_W - offset - size, offset),
        (offset, PAGE_H - offset - size),
        (PAGE_W - offset - size, PAGE_H - offset - size),
    ]:
        c.rect(x, y, size, size, stroke=0, fill=1)


def draw_id_panel(c):
    x = 142 * mm
    y = 224 * mm
    w = 55 * mm
    h = 62 * mm

    c.setFillColor(LIGHT_GREY)
    c.setStrokeColor(MID_BLUE)
    c.roundRect(x, y, w, h, 3 * mm, stroke=1, fill=1)

    c.setFillColor(INK)
    c.setFont("Helvetica-Bold", 9)
    c.drawString(x + 4 * mm, y + h - 6 * mm, "STUDENT ID - 3 DIGITS")
    c.setFont("Helvetica", 6.5)
    c.setFillColor(colors.HexColor("#475467"))
    c.drawString(x + 4 * mm, y + h - 10 * mm, "Write each digit, then fill its bubble.")

    centers = [x + 21 * mm, x + 34 * mm, x + 47 * mm]
    box_y = y + h - 23 * mm
    for position, center in enumerate(centers, start=1):
        c.setStrokeColor(MID_GREY)
        c.setFillColor(colors.white)
        c.rect(center - 4 * mm, box_y, 8 * mm, 7 * mm, stroke=1, fill=1)
        c.setFillColor(colors.HexColor("#667085"))
        c.setFont("Helvetica", 5.8)
        label = f"digit {position}"
        c.drawCentredString(center, box_y + 8 * mm, label)

    row_top = y + h - 28.5 * mm
    row_step = 3.10 * mm
    bubble_r = 1.60 * mm
    for digit in range(10):
        row_y = row_top - digit * row_step
        c.setFillColor(INK)
        c.setFont("Helvetica", 6.8)
        c.drawRightString(x + 12 * mm, row_y - 2, str(digit))
        for center in centers:
            c.setStrokeColor(colors.HexColor("#475467"))
            c.setLineWidth(0.75)
            c.circle(center, row_y, bubble_r, stroke=1, fill=0)


def draw_response_panel(c):
    x = 13 * mm
    y = 195 * mm
    w = 184 * mm
    h = 27 * mm
    c.setFillColor(PALE_BLUE)
    c.setStrokeColor(MID_BLUE)
    c.roundRect(x, y, w, h, 3 * mm, stroke=1, fill=1)

    c.setFillColor(INK)
    c.setFont("Helvetica-Bold", 8.5)
    c.drawString(x + 5 * mm, y + h - 6 * mm, "RESPONSE PANEL")
    c.setFont("Helvetica", 6.8)
    c.setFillColor(colors.HexColor("#475467"))
    c.drawString(x + 37 * mm, y + h - 6 * mm, "Fill exactly one bubble in each row.")

    option_x = [x + (62 + 17.5 * index) * mm for index in range(7)]
    row_ys = [y + 15.5 * mm, y + 10 * mm, y + 4.5 * mm]
    for q_index, row_y in enumerate(row_ys, start=1):
        c.setFillColor(INK)
        c.setFont("Helvetica-Bold", 8)
        c.drawString(x + 8 * mm, row_y - 2.5, f"Question {q_index}")
        for letter, center in zip("ABCDEFG", option_x):
            c.setStrokeColor(colors.HexColor("#344054"))
            c.setLineWidth(0.8)
            c.circle(center, row_y, 2 * mm, stroke=1, fill=0)
            c.setFillColor(INK)
            c.setFont("Helvetica", 7)
            c.drawString(center + 3.2 * mm, row_y - 2.5, letter)


def paragraph(c, text, x, y_top, width, style):
    p = Paragraph(text, style)
    _, h = p.wrap(width, PAGE_H)
    p.drawOn(c, x, y_top - h)
    return y_top - h


def draw_questions(c, questions):
    styles = getSampleStyleSheet()
    q_style = ParagraphStyle(
        "Question",
        parent=styles["BodyText"],
        fontName="Helvetica-Bold",
        fontSize=10.4,
        leading=14,
        textColor=INK,
        spaceAfter=3,
    )
    option_style = ParagraphStyle(
        "Option",
        parent=styles["BodyText"],
        fontName="Helvetica",
        fontSize=8.5,
        leading=10.5,
        textColor=colors.HexColor("#25324A"),
        leftIndent=5 * mm,
        firstLineIndent=-5 * mm,
    )

    x = 15 * mm
    width = 180 * mm
    y = 187 * mm
    for q_number, question in enumerate(questions, start=1):
        y = paragraph(c, f"{q_number}. {question['text']}", x, y, width, q_style)
        y -= 2 * mm
        for letter, option in zip("ABCDEFG", question["options"]):
            y = paragraph(c, f"<b>{letter}.</b>&nbsp;&nbsp;{option}", x + 4 * mm, y, width - 4 * mm, option_style)
            y -= 0.3 * mm
        if q_number < len(questions):
            y -= 2.5 * mm
            c.setStrokeColor(colors.HexColor("#D0D5DD"))
            c.setLineWidth(0.5)
            c.line(x, y, x + width, y)
            y -= 5 * mm


def draw_student_page(c, form, form_index):
    questions = build_form_questions(form, form_index)
    code = form["code"]
    payload = f"course=ETP1;quiz=MOCK01;form={code};rev=1"

    draw_fiducials(c)

    c.setFillColor(PALE_BLUE)
    c.rect(13 * mm, 287 * mm, 184 * mm, 5.5 * mm, stroke=0, fill=1)
    c.setFillColor(BLUE)
    c.setFont("Helvetica-Bold", 7.5)
    c.drawCentredString(
        PAGE_W / 2,
        288.7 * mm,
        "PRACTICE MOCK - LAYOUT PROTOTYPE - NOT FOR GRADING",
    )

    c.setFillColor(INK)
    c.setFont("Helvetica-Bold", 10)
    c.drawString(13 * mm, 281.5 * mm, "ECONOMETRIC THEORY AND PRACTICE I")
    c.setFont("Helvetica-Bold", 18)
    c.drawString(13 * mm, 272.5 * mm, "Probability Review - Mock Quiz")
    c.setFont("Helvetica", 8.5)
    c.setFillColor(colors.HexColor("#475467"))
    c.drawString(13 * mm, 266.5 * mm, "3 questions  |  10 minutes  |  1 point each  |  No negative marking")

    draw_qr(c, payload, 13 * mm, 230.5 * mm, 28 * mm)
    c.setFillColor(INK)
    c.setFont("Helvetica-Bold", 7.5)
    c.drawString(44 * mm, 254 * mm, "MACHINE MARKER - DO NOT WRITE")
    c.setFont("Helvetica", 4.2)
    c.setFillColor(colors.HexColor("#98A2B3"))
    c.drawString(44 * mm, 248.2 * mm, f"form ref: {code}")
    c.setFont("Helvetica", 7)
    c.setFillColor(colors.HexColor("#475467"))
    c.drawString(44 * mm, 240.5 * mm, "Do not write on the QR code or corner squares.")
    c.drawString(44 * mm, 236.2 * mm, "Record all answers in the response panel below.")

    draw_id_panel(c)
    draw_response_panel(c)
    draw_questions(c, questions)

    c.setStrokeColor(colors.HexColor("#D0D5DD"))
    c.line(13 * mm, 13 * mm, 197 * mm, 13 * mm)
    c.setFillColor(colors.HexColor("#667085"))
    c.setFont("Helvetica", 5.3)
    c.drawString(15 * mm, 9 * mm, "Mock quiz - layout prototype")
    footer = f"Form {code}  |  Page 1 of 1  |  rev 1"
    c.drawRightString(195 * mm, 9 * mm, footer)
    c.showPage()
    return questions


def create_student_pdf():
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    c = canvas.Canvas(str(STUDENT_PDF), pagesize=A4, pageCompression=1)
    c.setTitle("Econometric Theory and Practice I - Mock Quiz - Five Forms")
    c.setAuthor("Course teaching team")
    all_questions = {}
    for form_index, form in enumerate(FORMS):
        all_questions[form["code"]] = draw_student_page(c, form, form_index)
    c.save()
    return all_questions


def create_key_pdf(all_questions):
    styles = getSampleStyleSheet()
    title = ParagraphStyle(
        "KeyTitle",
        parent=styles["Title"],
        fontName="Helvetica-Bold",
        fontSize=19,
        leading=23,
        textColor=INK,
        alignment=TA_LEFT,
        spaceAfter=10,
    )
    heading = ParagraphStyle(
        "KeyHeading",
        parent=styles["Heading2"],
        fontName="Helvetica-Bold",
        fontSize=11,
        leading=14,
        textColor=BLUE,
        spaceBefore=8,
        spaceAfter=5,
    )
    body = ParagraphStyle(
        "KeyBody",
        parent=styles["BodyText"],
        fontName="Helvetica",
        fontSize=8.6,
        leading=12,
        textColor=INK,
    )
    small = ParagraphStyle(
        "KeySmall",
        parent=body,
        fontSize=7.4,
        leading=10,
    )
    table_header = ParagraphStyle(
        "TableHeader",
        parent=small,
        fontName="Helvetica-Bold",
        textColor=colors.white,
    )

    doc = SimpleDocTemplate(
        str(KEY_PDF),
        pagesize=A4,
        rightMargin=15 * mm,
        leftMargin=15 * mm,
        topMargin=15 * mm,
        bottomMargin=15 * mm,
        title="Mock Quiz Instructor Key",
        author="Course teaching team",
    )

    story = [
        Paragraph("Mock Quiz - Instructor Key", title),
        Paragraph(
            "The student print pack contains five one-page A4 forms. Students never need "
            "to identify an A-E or 1-5 version. The QR code and the repeated randomized "
            "form code identify the correct mapping. The QR payload contains only the "
            "course, quiz, form code, and revision - never an answer key.",
            body,
        ),
        Spacer(1, 5 * mm),
    ]

    table_data = [
        [
            Paragraph("Form code", table_header),
            Paragraph("Question 1", table_header),
            Paragraph("Question 2", table_header),
            Paragraph("Question 3", table_header),
            Paragraph("Key", table_header),
        ]
    ]
    for form in FORMS:
        code = form["code"]
        questions = all_questions[code]
        table_data.append(
            [
                Paragraph(f"<b>{code}</b>", body),
                Paragraph(questions[0]["short"], small),
                Paragraph(questions[1]["short"], small),
                Paragraph(questions[2]["short"], small),
                Paragraph(" - ".join(q["correct_letter"] for q in questions), body),
            ]
        )

    table = Table(
        table_data,
        colWidths=[22 * mm, 40 * mm, 40 * mm, 40 * mm, 22 * mm],
        repeatRows=1,
    )
    table.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), INK),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("GRID", (0, 0), (-1, -1), 0.45, colors.HexColor("#C7CDD4")),
                ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.white, LIGHT_GREY]),
                ("LEFTPADDING", (0, 0), (-1, -1), 4),
                ("RIGHTPADDING", (0, 0), (-1, -1), 4),
                ("TOPPADDING", (0, 0), (-1, -1), 5),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 5),
            ]
        )
    )
    story.extend(
        [
            table,
            Spacer(1, 5 * mm),
            Paragraph("Operational rule", heading),
            Paragraph(
                "Use new randomized form codes for every live quiz. Freeze the mapping "
                "when printing. The scan grader first reads the QR code and then uses the "
                "printed form code as a fallback. A mismatch or unreadable code must enter "
                "manual review; the grader must not infer a form from the student's answers.",
                body,
            ),
            Paragraph("Mock content note", heading),
            Paragraph(
                "These questions demonstrate the planned version logic: question order and "
                "answer order change across forms, while numerical values vary only within "
                "the same expectation or variance calculation. They are illustrative and "
                "are not approved course-assessment items.",
                body,
            ),
            Paragraph("Preflight before live use", heading),
            Paragraph(
                "Confirm the 3-digit ID rule, print at 100% scale, test the actual scanner, "
                "verify QR detection, and deliberately test light marks, erasures, double "
                "marks, rotation, and leading-zero IDs before the first graded quiz.",
                body,
            ),
        ]
    )
    doc.build(story)


def main():
    all_questions = create_student_pdf()
    create_key_pdf(all_questions)
    print(STUDENT_PDF)
    print(KEY_PDF)


if __name__ == "__main__":
    main()

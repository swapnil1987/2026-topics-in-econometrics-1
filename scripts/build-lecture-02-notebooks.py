"""Build standalone R notebooks from the paired teaching scripts. No dependencies."""
from pathlib import Path
import hashlib
import json

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'R' / 'colab-lecture-02'
OUTPUT = ROOT / 'colab' / 'lecture-2'


def build(path):
    cells, lines, kind = [], [], None
    def flush():
        if kind is None or not ''.join(lines).strip():
            return
        content = ''.join(lines).strip() + '\n'
        index = len(cells)
        cell = {'cell_type': kind, 'id': f'cell-{index:03d}',
                'metadata': {'id': f'cell-{index:03d}'}, 'source': content}
        if kind == 'code':
            cell.update(execution_count=None, outputs=[])
        cells.append(cell)
    for line in path.read_text().splitlines(keepends=True):
        if line.startswith('# %%'):
            flush()
            kind = 'markdown' if '[markdown]' in line else 'code'
            lines = []
        elif kind == 'markdown':
            if line.strip() and not line.startswith('#'):
                raise ValueError(f'Uncommented Markdown in {path}: {line}')
            lines.append(line[2:] if line.startswith('# ') else line[1:] if line.startswith('#') else line)
        else:
            lines.append(line)
    flush()
    assert cells and cells[0]['cell_type'] == 'markdown'
    notebook = {'nbformat': 4, 'nbformat_minor': 5, 'metadata': {
        'kernelspec': {'name': 'ir', 'display_name': 'R', 'language': 'R'},
        'language_info': {'name': 'R', 'file_extension': '.r', 'mimetype': 'text/x-r-source',
                          'codemirror_mode': 'r', 'pygments_lexer': 'r'},
        'colab': {'name': path.with_suffix('.ipynb').name, 'provenance': []},
        'course_source': {'path': path.relative_to(ROOT).as_posix(),
                          'sha256': hashlib.sha256(path.read_bytes()).hexdigest()}}, 'cells': cells}
    return notebook


if __name__ == '__main__':
    OUTPUT.mkdir(parents=True, exist_ok=True)
    expected = ['01_law_of_large_numbers', '02_central_limit_theorem',
                '03_unbiasedness', '04_consistency', '05_p_value']
    assert sorted(p.stem for p in SOURCE.glob('[0-9][0-9]_*.R')) == expected
    for path in sorted(SOURCE.glob('[0-9][0-9]_*.R')):
        notebook = build(path)
        target = OUTPUT / path.with_suffix('.ipynb').name
        target.write_text(json.dumps(notebook, indent=1, ensure_ascii=False) + '\n')
        print(f'{target.relative_to(ROOT)}: {len(notebook["cells"])} cells')

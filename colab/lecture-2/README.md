# Lecture 2: Five classroom demonstrations

## Private Google Colab copies

Open the [Lecture 2 Drive folder](https://drive.google.com/drive/folders/14kl89bVpSLaW7zJXhDrDociIUmVBkhsQ), or an individual notebook:

- [law of large numbers](https://colab.research.google.com/drive/1bc-U8zp2-wSPcCQBV03lEiF6S5VsX8B9)
- [central limit theorem](https://colab.research.google.com/drive/1vNQyiIP-wjZOYhVhTkP2dFj1bUzqZ-Kw)
- [unbiasedness](https://colab.research.google.com/drive/1ZRuvLvt-fgXOnEFe9pOcYrq2YV22M6zJ)
- [consistency](https://colab.research.google.com/drive/1avT-lxplEVddmugvAVSJXofZAqsk-cnr)
- [p value](https://colab.research.google.com/drive/1enFm6U0JiTwVmNjBeBbhsW4LDVYHEA7W)

The previous six notebooks are preserved in the folder's Archive subfolder.
Drive permissions remain private. Uploads and metadata were verified on 2026-09-09;
the five notebooks passed local R execution and plot inspection, not hosted Colab execution.

## Classroom sequence

Run the notebooks in this order. Each is standalone R with a visible seed,
explanatory text, a plot, and a suggested live edit. No external datasets are needed.
Use **Runtime → Run all** in Colab, or run cells one at a time for discussion.

| Topic | Local notebook | Paired R script | Live edit |
| --- | --- | --- | --- |
| Law of large numbers | [Notebook](01_law_of_large_numbers.ipynb) | [R](../../R/colab-lecture-02/01_law_of_large_numbers.R) | Increase the path length |
| Central limit theorem | [Notebook](02_central_limit_theorem.ipynb) | [R](../../R/colab-lecture-02/02_central_limit_theorem.R) | Change sample sizes, then repetitions |
| Unbiasedness | [Notebook](03_unbiasedness.ipynb) | [R](../../R/colab-lecture-02/03_unbiasedness.R) | Shift the estimator by -2 instead of +2 |
| Consistency | [Notebook](04_consistency.ipynb) | [R](../../R/colab-lecture-02/04_consistency.R) | Tighten the error tolerance |
| P-value | [Notebook](05_p_value.ipynb) | [R](../../R/colab-lecture-02/05_p_value.R) | Change the null, then the significance level |

The first four use invented earnings: Y = 10 + Exponential(mean 10),
with population mean 20 and SD 10 (currency units per hour). The p-value example
uses the lecture's summary statistics and labels its extra normal-sampling assumption.
Simulation illustrates the theory; finite runs do not prove limiting results.
Increasing repetitions reduces Monte Carlo noise, not an estimator's sampling variance.

## Rebuild and check

Edit the paired R scripts, then regenerate the notebooks from the repository root:

```bash
~/miniconda3/bin/conda run --name topics-econometrics python scripts/build-lecture-02-notebooks.py
~/miniconda3/bin/conda run --name topics-econometrics Rscript scripts/check-lecture-02-notebooks.R
```

The checker uses fresh environments, compares notebook code with its paired source,
checks formulas and simulation results, and saves plots, a log, and a run record
in a new temporary directory. Inspect the plots as well as the test result.
Notebooks are saved without outputs. Local execution is not a hosted Colab runtime test.

The earlier six-notebook sequence has been retired. The separate combined
scripts under `codes/lecture-2` remain reference material, not the delivery sequence.

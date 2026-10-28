Help file for the PFC Tutorial application.  This repository contains the source code.  The help file in CHM or PDF format can be downloaded directly from the [latest release](https://github.com/OpenSourcePFCLibraries/PFCTUTOR-help-file-and-source/releases/latest).

The tutorial itself is [Generating a PFC Application](https://github.com/OpenSourcePFCLibraries/docs/blob/main/user-guide/09-generate-a-pfc-application.md), chapter 9 of the PFC User's Guide, which sets `pfctutor.pdf` as the tutorial application's help file.

## Building

`pfctutor.chm` and `pfctutor.pdf` are built from the topic in `src` (`pfctutor.htm`, with `style.css`, and the HTML Help project `pfctutor.hhp` and `toc.hhc`):

```
pwsh -File build.ps1
```

This needs [HTML Help Workshop](https://learn.microsoft.com/previous-versions/windows/desktop/htmlhelp/microsoft-html-help-downloads) (for `hhc.exe`) and Microsoft Edge (which prints the PDF).  `-NoPdf` builds only the CHM.  The generated files are in `build`, which isn't kept in the repository.

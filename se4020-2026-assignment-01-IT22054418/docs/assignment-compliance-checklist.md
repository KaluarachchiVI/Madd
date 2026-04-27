# Assignment compliance checklist

Use this document with the official brief in [`pdfs/`](pdfs/) once you add `Assignment_01_2026.pdf` and `NurseryConnect_Case_Study.pdf`. Tick each row after you verify it against the PDF rubric (word limits, required sections, and file types override this template).

## 1. Implementation (NurseryConnect MVP)

| Requirement (typical Assignment 01 / case study) | Status | Evidence in repo |
|---------------------------------------------------|--------|------------------|
| Single mobile platform (iOS) MVP | Met | SwiftUI app target, [`NurseryConnectMVPApp.swift`](../NurseryConnectMVP/NurseryConnectMVPApp.swift) |
| Clear user role | Met | Keyworker — [`docs/report.md`](report.md), [`README.md`](../README.md) |
| Two substantive features | Met | (1) Daily diary / activity — [`DiaryEntryFormView.swift`](../NurseryConnectMVP/Views/DiaryEntryFormView.swift), [`Models.swift`](../NurseryConnectMVP/Models.swift) `DiaryEntry`; (2) Attendance in/out — [`AttendanceActionView.swift`](../NurseryConnectMVP/Views/AttendanceActionView.swift), `AttendanceRecord` |
| Local persistence | Met | SwiftData [`ModelContainer`](../NurseryConnectMVP/NurseryConnectMVPApp.swift) |
| No login / backend (if allowed by brief) | Met | Documented in [`README.md`](../README.md) |
| Validation / error handling | Met | [`Validators.swift`](../NurseryConnectMVP/Validation/Validators.swift), alerts in views |
| Navigation and child-first UX | Met | [`ChildrenListView`](../NurseryConnectMVP/Views/ChildrenListView.swift) → [`ChildDetailView`](../NurseryConnectMVP/Views/ChildDetailView.swift) |
| Accessibility | Met | `accessibilityIdentifier` / labels on list, forms, attendance (see `AttendanceActionView`, `ChildrenListView`, `DiaryEntryFormView`, `IOSStatusChip`) |

## 2. Testing

| Requirement | Status | Evidence |
|-------------|--------|----------|
| Unit tests | Met | [`NurseryConnectMVPTests.swift`](../NurseryConnectMVPTests/NurseryConnectMVPTests.swift) — diary + attendance validators |
| UI / smoke tests | Met | [`NurseryConnectMVPUITests.swift`](../NurseryConnectMVPUITests/NurseryConnectMVPUITests.swift) — list load, navigate to attendance |
| UI test identifiers match UI | Met | `childrenListScreen`, `attendanceScreen`, `childRow`; primary navigation to attendance uses button label `Attendance` |

## 3. Written deliverables

| Artefact | Status | Location |
|----------|--------|----------|
| Technical / reflection report | Met | [`docs/report.md`](report.md) — includes **Documentation** (Design / Implementation / Challenges) and **Regulatory compliance report** (Understanding / Compliance by design / Trade-offs) |
| AI prompts and responses (submission guideline 3) | Met | [`docs/ai-appendix.md`](ai-appendix.md) — attach or merge into PDF with the report |
| Demo preparation | Met | [`docs/demo-script.md`](demo-script.md) |
| PDF briefs stored with project | Pending | Add files under [`docs/pdfs/`](pdfs/) |

**Manual verification:** Compare [`report.md`](report.md) section headings to the PDF’s required headings. Optional screenshots: see **Appendix A** in the report.

### Rubric cross-check (Documentation and Regulatory — Assignment 01)

| Rubric item | Addressed in report | Notes |
|-------------|---------------------|--------|
| Documentation — Design (UI, UX, childcare context) | `report.md` → **Documentation → Design** | References `DesignTokens`, design system folder, `designs/` prototype |
| Documentation — Implementation (libraries, APIs, persistence, MVP) | **Documentation → Implementation** | States no SPM/third-party; SwiftData; MVP caveats |
| Documentation — Challenges | **Documentation → Challenges** | Concrete examples (validators, schema, UI tests) |
| Regulatory — Understanding | **Regulatory compliance report → Understanding** | Table: UK GDPR, EYFS, Ofsted, Children Act 1989, FSA |
| Regulatory — Compliance by design | **Regulatory compliance report → Compliance by design** | Architecture, data handling, UI; production backlog |
| Regulatory — Depth / trade-offs | **Regulatory compliance report → Depth** | Three tensions with MVP vs production mitigations |

## 4. Build / submission

| Requirement | Status | Notes |
|-------------|--------|-------|
| Openable Xcode project | Met | [`NurseryConnectMVP.xcodeproj`](../NurseryConnectMVP.xcodeproj) — open on macOS with Xcode |
| Report format (PDF/DOCX) | Verify in PDF | Export [`report.md`](report.md) and [`ai-appendix.md`](ai-appendix.md). **Pandoc (optional):** from `docs/`, `pandoc report.md ai-appendix.md -o submission.pdf`. If Pandoc is unavailable, use Markdown PDF extension, Word paste, or print-to-PDF (see report header) |

## 5. Gaps to resolve using the PDF only

The following cannot be confirmed without `Assignment_01_2026.pdf`:

- Exact marking criteria weights and word limits  
- Whether a video demo, ethics form, or peer review is required  
- Whether multi-role or server-side features are mandatory  
- Filename and packaging rules for zip submission  

After you add the PDF to [`docs/pdfs/`](pdfs/), update this section with quotes or page references from the brief.

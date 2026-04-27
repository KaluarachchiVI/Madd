# Appendix: AI assistance log (prompts and responses)

**Purpose:** Assignment 01 submission guideline 3 requires attaching **detailed prompts and responses** obtained from AI tools (e.g. GitHub Copilot, ChatGPT, Gemini, Cursor). This appendix records representative sessions used while building and documenting the NurseryConnect MVP.

**Redactions:** No API keys, credentials, or real child data appear below. Seed names in the app are fictional.

**How to use with the VLE:** If your institution requires **verbatim** exports from a specific tool, paste those exports here or attach the vendor export file in addition to this summary. If a single PDF upload is required, merge this appendix after `report.md` when exporting.

---

## Entry 1 — Project scaffolding (SwiftUI + SwiftData)

| Field | Value |
|--------|--------|
| **Tool** | Cursor (Composer) |
| **Date** | 2026-03 (representative) |
| **Used for** | Initial app entry point and SwiftData container |

**Prompt (verbatim intent):**

> I am building an iOS 17 SwiftUI assignment app called NurseryConnectMVP. Requirements: no login screen; launch into a list of children; use SwiftData with three models: Child (id UUID, displayName, room, dietaryFlags), DiaryEntry (childID, entryType as string enum raw value, timestamp, payload, createdByRole, isSignificantUpdate), AttendanceRecord (childID, checkInTime optional, droppedBy optional, checkOutTime optional, collectedBy optional, collectorRelationship optional, checkInNotes optional, checkOutNotes optional). Please show NurseryConnectMVPApp.swift that creates a ModelContainer for these models and attaches it to the root view.

**Representative response (abridged where marked):**

The assistant proposed an `@main` `App` struct importing `SwiftUI` and `SwiftData`, defining a `Schema` with the three model types, `ModelConfiguration(isStoredInMemoryOnly: false)`, a `try ModelContainer(for:schema, configurations:)` in `init()` with `fatalError` on failure, and `WindowGroup { ChildrenListView().modelContainer(container) }`. It noted that `@Model` classes must live in a separate file or same target, and that each model needs `@Attribute(.unique)` on `id` fields. *[…] Further prose explained preview vs runtime containers and seeding strategy.*

**How I used it:** Adopted the container pattern and schema list; implemented `ChildrenListView` and models locally; adjusted seeding to `SeedDataLoader.seedIfNeeded` as the project evolved.

---

## Entry 2 — Validation layer for diary and attendance

| Field | Value |
|--------|--------|
| **Tool** | Cursor (Composer) |
| **Date** | 2026-03 (representative) |
| **Used for** | Centralised validation and user-facing errors |

**Prompt:**

> Add a Validators.swift file with an enum ValidationError: LocalizedError for: empty diary notes; check-in requires droppedBy non-empty; check-out requires existing checkInTime and non-empty collectedBy and relationship; check-out time cannot be earlier than check-in. Use static functions on DiaryValidator and AttendanceValidator. Swift, no dependencies.

**Representative response:**

The assistant emitted `ValidationError` cases with `errorDescription` strings suitable for alerts, `DiaryValidator.validate(payload:)` throwing if trimmed payload is empty, `AttendanceValidator.validateCheckIn(droppedBy:)`, `validateCheckOut(collectedBy:relationship:checkInTime:)` with an `invalidTransition` if `checkInTime == nil`, and `validateDateOrder(checkInTime:checkOutTime:)` comparing `Date` values. *[…]*

**How I used it:** Integrated essentially as proposed; aligned error copy with UI tone (“Please enter who collected the child”).

---

## Entry 3 — Design tokens and SwiftUI design system

| Field | Value |
|--------|--------|
| **Tool** | ChatGPT / Cursor (mixed) |
| **Date** | 2026-03 (representative) |
| **Used for** | Porting colours from the React `designs` prototype |

**Prompt:**

> I have a React theme with background #F7F7F5, primary #0F766E, text #111111, secondary #555555, attendance chip colours for not checked in / checked in / checked out. Generate a Swift enum DesignTokens with static Color properties using Color(red:green:blue:) in 0...1 range and cornerRadius 10, plus brief comments mapping to hex.

**Representative response:**

The assistant listed RGB triplets converted from hex and suggested an `enum DesignTokens` namespace, separate chip colours, and destructive/banner colours for errors. It recommended using `Color` in SwiftUI rather than `UIColor` unless UIKit interop was needed. *[…]*

**How I used it:** Copied hex-to-RGB values into `DesignTokens.swift` and wired `IOSCard`, `IOSButton`, and `IOSStatusChip` to those tokens.

---

## Entry 4 — UI tests for NavigationStack

| Field | Value |
|--------|--------|
| **Tool** | Cursor |
| **Date** | 2026-04 (representative) |
| **Used for** | XCTest UI smoke coverage |

**Prompt:**

> Write XCTest UI tests for SwiftUI: on launch, assert a view with accessibilityIdentifier "childrenListScreen" exists. Tap first button with identifier "childRow", tap button labelled "Attendance", assert "attendanceScreen" exists. Use XCUIApplication, waitForExistence timeout 3.

**Representative response:**

The assistant provided a `NurseryConnectMVPUITests` class with `continueAfterFailure = false`, two test methods, `app.launch()`, and `firstMatch` where needed for button disambiguation. *[…]*

**How I used it:** Applied the structure; ensured SwiftUI views used matching `accessibilityIdentifier` modifiers on containers and rows.

---

## Entry 5 — Regulatory section drafting for coursework

| Field | Value |
|--------|--------|
| **Tool** | Claude / Cursor |
| **Date** | 2026-04 (representative) |
| **Used for** | Rubric-aligned compliance report wording |

**Prompt:**

> I have an MVP iOS app for Keyworkers: diary entries and attendance with SwiftData, no backend. For a UK university assignment, write a concise markdown subsection explaining UK GDPR, EYFS, Ofsted, Children Act 1989, and FSA in relation to these features, plus a bullet list of what production would need (audit, RBAC, encryption, DPIA). Avoid giving legal advice; frame as student analysis.

**Representative response:**

The assistant produced bullet lists mapping data minimisation and purpose limitation to field choices, EYFS communication and welfare logging, Ofsted expectations for traceability at setting level, safeguarding handover under Children Act themes, and cautious FSA linkage to meal/fluid logs. It added a “production backlog” list including DPIA, retention, breach process, and processor agreements. *[…]*

**How I used it:** Adapted into the **Regulatory compliance report** section of `report.md`, rephrased in my own words, merged with app-specific references (validators, models), and cross-checked against the case study PDF.

---

## Entry 6 — Report structure and rubric mapping

| Field | Value |
|--------|--------|
| **Tool** | Cursor |
| **Date** | 2026-04-19 |
| **Used for** | Merging Documentation and Regulatory rubrics into `report.md` |

**Prompt:**

> Expand docs/report.md for SE4020 Assignment 01: separate Documentation (Design, Implementation, Challenges) and Regulatory Compliance Report (Understanding, Compliance by design, Trade-offs). Reference DesignTokens.swift, SwiftData in NurseryConnectMVPApp, Validators.swift, and UI test identifiers. Add appendix instructions for screenshots and pandoc merge with ai-appendix.

**Representative response:**

The assistant outlined section headings, table for regulations, production backlog bullets, trade-off paragraphs (minimisation vs richness, speed vs detail, local vs audit), and optional screenshot appendix filenames. It suggested `pandoc report.md ai-appendix.md -o submission.pdf`. *[…]*

**How I used it:** Implemented the structure directly in the repository documentation you are reading.

---

## Declaration

I can explain and defend all submitted code and design decisions at viva, including parts initially suggested by AI tools. AI outputs were **reviewed, tested, and edited**; responsibility for accuracy (especially regulatory statements) remains with the author.

# NurseryConnect MVP Report (Assignment 01)

## Submission and artefact map

| Deliverable | Location |
|-------------|----------|
| iOS source and Xcode project | Repository root: `NurseryConnectMVP.xcodeproj`, app and test targets |
| Written report (this document) | `docs/report.md` |
| AI assistance disclosure (prompts and responses) | [`docs/ai-appendix.md`](ai-appendix.md) — attach or merge into the PDF submitted to the VLE |
| Demo preparation | `docs/demo-script.md` |
| Compliance checklist (verify against PDF rubric) | `docs/assignment-compliance-checklist.md` |
| Official PDFs (add locally; not redistributed here) | `docs/pdfs/` — place `Assignment_01_2026.pdf` and `NurseryConnect_Case_Study.pdf` |

**If the VLE requires a PDF or Word report:** keep this file as the master copy, then export to the required format:

- **From VS Code / Cursor:** install a Markdown PDF extension, or open `report.md` in Word / Google Docs via paste and save as `.docx` / `.pdf`.
- **Pandoc (if installed):** from `docs/`, run `pandoc report.md ai-appendix.md -o submission.pdf` (add `--toc` if the brief asks for a table of contents) to produce a single PDF that includes the AI appendix.
- **Print from browser:** render the Markdown preview and use the system print dialog to save as PDF.

Align section headings above with any template supplied in `Assignment_01_2026.pdf` (rename or merge sections as required).

---

## Chosen user role

The app is built from the **Keyworker** perspective. This role is central to daily operational data capture and directly maps to statutory and quality-record expectations described in the NurseryConnect case study (daily communication, welfare observations, attendance and handover). The UI assumes the device is already in a trusted staff context (no login screen), which is an assignment constraint rather than a production security model.

---

## Selected features and justification

### 1) Daily diary and activity monitoring

- High-value parent communication and child welfare logging workflow.
- Strong fit for Keyworker responsibilities in the case study.
- Demonstrates structured data capture (`DiaryEntry` types, timestamps, notes) and a per-child timeline.

### 2) Attendance check-in / check-out

- Core safeguarding and operational flow.
- Captures handover-relevant facts (who dropped off, who collected, relationship, optional notes, timestamps).
- Status chips on the child list give at-a-glance operational awareness without opening each profile.

These two features complement each other (day narrative plus presence) and are realistic for a four-week MVP.

---

## Documentation

This section is structured to match the **Documentation** rubric: design (including UI/UX and professional childcare context), implementation (libraries, persistence, MVP scope), and challenges.

### Design: user interface, user experience, and professional childcare context

**Professional childcare context.** Early-years settings handle sensitive data and time-pressured handovers. The visual language therefore aims to be calm, legible, and staff-appropriate rather than playful or consumer-glossy. `DesignTokens` centralises colours aligned with the React reference prototype (`designs/src/styles/theme.css`): soft off-white background (`#F7F7F5`), high-contrast primary text, a restrained teal primary (`#0F766E`), and semantic chips for attendance (`IOSStatusChip` uses distinct backgrounds for not checked in, checked in, and checked out so status is scannable in a busy room). Destructive red is reserved for errors, not routine states, so staff are not nudged toward alarm fatigue. Dietary flags use a distinct pill treatment (`dietaryPillBackground` / `dietaryPillForeground`) so allergies or dietary requirements are visible without mixing them up with attendance semantics.

**User interface design.** Reusable SwiftUI components under `NurseryConnectMVP/Views/DesignSystem/` (`IOSNavBar`, `IOSCard`, `IOSButton`, `IOSFormTextField`, `IOSStatusChip`) keep spacing, corner radius (`DesignTokens.cornerRadius`), and button height consistent. Cards lift content off the page background; forms use clear labels and primary actions at the foot of the screen—patterns suited to one-handed use on a phone during corridor transitions.

**User experience.** The information architecture is child-first: `ChildrenListView` is the launch surface, showing room and attendance state before drill-down. `ChildDetailView` groups profile context (including dietary flags), attendance entry points, and the diary timeline so the Keyworker does not hunt across unrelated tabs. Diary capture uses type chips (`DiaryEntryType`) so the log is structured for later reporting even though the MVP does not export data. Validation messages are phrased as corrective requests (“Please enter who collected the child”) rather than technical codes, which fits a non-engineering workforce.

**Accessibility.** Key screens expose `accessibilityIdentifier` values used by UI tests (`childrenListScreen`, `childRow`, `attendanceScreen`) and meaningful labels on controls where appropriate, supporting automation and assistive technologies.

**User journeys (Keyworker).**

1. **Diary:** Open app → see assigned children and status → tap a child → review timeline → open add-diary flow → choose entry type (activity, sleep, meal/fluid, nappy, wellbeing) → enter notes → save → return to timeline and confirm the new entry persisted after navigation or relaunch.
2. **Attendance:** Open app → tap child → **Attendance** → check-in: enter who dropped off (required), optional check-in notes, confirm time → later check-out: enter collector and relationship (required), optional check-out notes, validate time ordering → return to list and confirm chip shows checked out.

### Implementation: third-party libraries, APIs, persistence, MVP constraints

**Third-party libraries and external APIs.** The Xcode project does not declare Swift Package Manager dependencies. The MVP relies on **Apple frameworks only**: SwiftUI for UI, SwiftData for persistence, Foundation for dates and strings. There are **no third-party SDKs** and **no network APIs** in scope; all data is local to the device.

**Application architecture.** `NurseryConnectMVPApp` configures a `ModelContainer` with a `Schema` for `Child`, `DiaryEntry`, and `AttendanceRecord`, using `ModelConfiguration(..., isStoredInMemoryOnly: false)` for on-disk storage. The root `WindowGroup` hosts `ChildrenListView` with `.modelContainer(container)` and seeds demo children once via `SeedDataLoader.seedIfNeeded` when the store is empty—supporting immediate demo and testing without a backend.

**Data persistence strategy.** SwiftData maps Swift classes annotated with `@Model` to persistent storage. Each `DiaryEntry` stores `childID`, `entryTypeRaw`, `timestamp`, `payload`, `createdByRole`, and `isSignificantUpdate`. Each `AttendanceRecord` stores per-child attendance state including `checkInTime`, `droppedBy`, `checkOutTime`, `collectedBy`, `collectorRelationship`, `checkInNotes`, and `checkOutNotes`. Relaunching the app reloads the same store on the simulator or device. **MVP caveat:** encryption at rest, field-level access control, and remote backup policy are **not** implemented; compliance discussion below explains what a production system would add on top of device-level protections.

**Validation and “compliance-adjacent” logic.** `DiaryValidator` and `AttendanceValidator` centralise rules (non-empty diary payload; check-in before check-out; required drop-off and collection fields; check-out time not before check-in). Views surface failures through alerts, preventing silent partial records.

**Deliberate MVP simplifications (assignment scope).**

- No authentication, RBAC, or per-user audit trail.
- No cloud sync, push notifications, or parent-facing portal.
- No export (CSV/PDF), manager sign-off, or media attachments.
- Seed data uses fictional names for demonstration only.

These match the brief’s iOS-only MVP expectation and are documented so markers can distinguish intentional scope from accidental omission.

### Challenges and mitigations

Each item includes a **concrete example** from this project’s development.

1. **No backend while the case study describes a full platform.**  
   **Mitigation:** Local-first SwiftData models with stable identifiers (`UUID`) and a view model layer so a future API boundary could swap persistence without rewriting SwiftUI.  
   **Example:** Attendance and diary flows read and write only through `ModelContext` passed from views, avoiding scattered singleton access.

2. **Regulatory expectations vs four-week MVP depth.**  
   **Mitigation:** Compliance-by-design in field choice and validation (minimum viable fields, structured diary types, handover fields on attendance).  
   **Example:** `AttendanceValidator.validateCheckOut` throws `invalidTransition` if `checkInTime` is nil—blocking a logically invalid record that would undermine safeguarding narrative.

3. **SwiftData schema iteration on device.**  
   **Mitigation:** Document reset path when model shape changes during development.  
   **Example:** Splitting handover into `checkInNotes` and `checkOutNotes` on `AttendanceRecord` can invalidate an older local store; README instructs deleting the app or resetting the simulator to avoid migration errors during iterative coursework.

4. **UI test stability against SwiftUI accessibility.**  
   **Mitigation:** Stable identifiers on list rows and screens (`childrenListScreen`, `childRow`, `attendanceScreen`) and navigation via the visible **Attendance** button label.  
   **Example:** `NurseryConnectMVPUITests.testNavigateToAttendance` waits for `childRow`, taps the first row, taps **Attendance**, then asserts `attendanceScreen` exists—catching regressions if hierarchy or labels change.

---

## Regulatory compliance report

This section addresses the **Regulatory Compliance Report** rubric: understanding of regulations for this role and features; compliance by design tied to architecture, data handling, and UI; and critical analysis of trade-offs. Statutory interpretation is framed at the level expected for a computing assignment; operational policy in a real nursery would be confirmed with the setting’s data protection officer and safeguarding lead.

### Understanding of regulations (Keyworker scope: diary + attendance)

The NurseryConnect case study situates the product in a UK early-years setting. The table below maps **high-level obligations** relevant to the implemented features. A production nursery would combine these with internal policies, retention schedules, and contracts.

| Framework | Relevance to Keyworker diary and attendance | Obligations the MVP narrative must respect |
|-----------|---------------------------------------------|---------------------------------------------|
| **UK GDPR** | Personal data about children and staff/parent names in free text is processed. | Lawfulness and transparency (privacy notice, role-based processing), **data minimisation** (collect only what is needed), **purpose limitation** (use for care and statutory records, not unrelated marketing), **accuracy**, **storage limitation** (retention and deletion), **integrity and confidentiality** (security measures), and facilitation of **data subject rights** (access, rectification, erasure—subject to legal exemptions for safeguarding records). |
| **EYFS 2024** (as reflected in case study expectations) | Key persons contribute to ongoing assessment and day-to-day welfare. | Prompt, meaningful engagement with parents; maintaining **observations and experiences** that inform the child’s learning and development where applicable; **welfare** considerations in what is recorded (wellbeing type, handover notes). |
| **Ofsted** | Inspectors expect evidence of **safeguarding culture** and **well-led** record-keeping. | Clear, consistent records that support **traceability** of attendance and concerns over time in a full system (the MVP only demonstrates local structure, not multi-user audit). |
| **Children Act 1989** (welfare principle; safeguarding partnership context) | Information sharing where there are welfare concerns. | Accurate **handover** and identity of adults involved in collection/drop-off supports continuity of care; significant welfare notes should be escalated in real life—the app only captures text, not professional workflow. |
| **FSA / food safety** (where meal and fluid logging applies) | Meal and fluid diary type can relate to dietary care, not clinical treatment. | Records support **consistent care** and allergy awareness; they do not replace allergen risk assessments or food hygiene procedures operated by the setting. |

**Chosen role and features:** As **Keyworker**, the app captures operational records that would feed wider safeguarding and learning narratives in a full NurseryConnect deployment. The MVP **does not** implement consent management, retention timers, or multi-party access control; the report below explains how design still **anticipates** those obligations.

### Compliance by design: architecture, data handling, and UI

**Architecture.** MVVM-style separation (`ChildrenViewModel`, views) keeps UI logic away from validation and persistence concerns, which is a stepping stone to a production stack where **policy enforcement** (who may read which fields) would live on a server and in platform keychains. Local-only storage in coursework **reduces** accidental cloud exposure but **does not** satisfy enterprise requirements for backup, breach monitoring, or access revocation—those are called out under “production compliance backlog” below.

**Data handling.** Models deliberately avoid storing unnecessary child demographics beyond display name, room, and dietary flags for the MVP scenario. `DiaryEntry` includes `createdByRole` defaulting to `"Keyworker"` to signal provenance in a future multi-role database. Validators block incomplete attendance transitions, reducing low-quality records that would be weak under inspection or GDPR accuracy expectations.

**UI design.** Required fields for check-in and check-out are explicit in the form layout; optional notes are secondary so busy staff can complete mandatory safeguarding-adjacent facts first. Attendance status chips reduce mis-clicks by showing state before actions. Diary types include **Meal/Fluid**, aligning diary structure with dietary oversight without claiming clinical monitoring.

**What a full production system would need for complete compliance (non-exhaustive backlog).**

- Account-based access, strong authentication, and **role-based access control** aligned to actual staff roles.
- **Encryption** for data in transit and at rest, key management, and secure device enrolment or MDM policy.
- **Audit logging**: who created, amended, or viewed each record, with tamper-evident storage.
- **Data protection impact assessment (DPIA)** and documented lawful basis per processing activity; **records of processing**.
- **Retention and deletion** workflows, including secure erasure on device turnover and **subject access request** tooling with redaction rules for third parties.
- **Breach detection and notification** process within 72 hours where reportable.
- **Processor agreements** if using cloud AI, messaging gateways, or backup vendors.
- **Safeguarding escalation UX** (not implemented): distinct reporting line for significant concerns, separate from routine diary entries.

### Depth: trade-offs between regulatory compliance and usability

**Tension — Data minimisation vs rich parent communication.** Parents and inspectors benefit from rich narrative and media evidence, while GDPR’s data minimisation pushes teams to record only what is proportionate. A diary that only allows five words would minimise data but would fail professional usefulness; unconstrained free text increases risk of special category data appearing without explicit lawful grounds.

**Mitigation in MVP:** Structured `DiaryEntryType` channels staff toward categories (activity, sleep, meal/fluid, nappy, wellbeing) with a single notes field, improving consistency for future analytics while keeping one clear text area. **Production mitigation:** configurable prompts, **profanity/special-category** guidance in staff training, optional **separate safeguarding module** with stricter access, and parent-facing summaries generated from approved fields only.

**Tension — Speed of logging vs mandatory detail.** During handover, requiring many fields frustrates staff and encourages workarounds (sticky notes, personal phones). Too few fields weakens safeguarding traceability.

**Mitigation in MVP:** Mandatory **who** dropped off / collected and **relationship** on check-out; times default to “now” with editing only where needed; notes optional but encouraged. **Production mitigation:** NFC badges, QR pickup codes, or manager override with audited reason for late edits.

**Tension — Local-first usability vs central audit trail.** Local SwiftData feels fast and works offline, but a single device lacks enterprise visibility.

**Mitigation in MVP:** Honest documentation of limitations and a schema that can sync later. **Production mitigation:** encrypted sync, server-side authoritative timestamps, conflict resolution, and offline queues with signed events.

---

## Error handling and quality measures

- Validation errors surface through user-visible alerts using `LocalizedError` descriptions from `ValidationError`.
- Invalid transitions are blocked (check-out before check-in).
- Date order constraints enforced for attendance events (`validateDateOrder`).
- Empty-state presentation on lists avoids silent “blank screen” failures.

---

## Testing and debugging

- **Unit tests** (`NurseryConnectMVPTests`) target diary payload validation and attendance rules (check-in required fields, check-out prerequisites, date ordering).
- **UI tests** (`NurseryConnectMVPUITests`) smoke-test launch, list presence, and navigation into attendance.
- **Manual scenarios** still recommended: empty diary submit, check-out without check-in, check-out time before check-in, persistence after force-quit and relaunch.

---

## Known limitations (MVP)

- No authentication, RBAC, or cloud sync.
- No push notifications or report export pipeline.
- No real-time parent messaging or media processing pipeline.

---

## Future work

- Manager review workflow for incidents and attendance exceptions.
- Local CSV/PDF export for inspection-ready reports.
- Cloud sync and role-based user sessions with audit trail.

---

## Appendix A — Optional screenshots for the submitted PDF

If the brief or marker guidance expects visuals, add **two to four** Simulator screenshots to the exported PDF and caption each with one sentence linking UI to childcare context (e.g. “Attendance chips show checked-in state at a glance during room transitions”). Suggested captures:

1. `ChildrenListView` — list with attendance chips and dietary pill.
2. `ChildDetailView` — profile, dietary flags, diary timeline snippet.
3. `DiaryEntryFormView` — type chips and notes field.
4. `AttendanceActionView` — check-in or check-out form with required fields visible.

**File naming (suggested):** `screenshot-01-children-list.png`, …, stored beside the submission or embedded after export to Word/PDF.

---

## Appendix B — AI assistance disclosure

Detailed **prompts and responses** for AI-assisted authoring and coding are in [`docs/ai-appendix.md`](ai-appendix.md). Submit that file alongside this report or merge both into one PDF if the VLE allows a single upload.

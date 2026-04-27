# NurseryConnect MVP Demo Script (5-7 minutes)

## 1) Opening (30s)
- Introduce assignment scope: iOS MVP, Keyworker role, 2 implemented features.
- Mention exclusions: authentication and backend integrations are out of scope.

## 2) Home Screen: Assigned Children (45s)
- Show `ChildrenListView`.
- Explain status chips (Not in / Checked in / Checked out).
- Open a child profile.

## 3) Attendance Workflow (2 min)
- From child detail, open **Attendance** (secondary outline button), then `AttendanceActionView`.
- Perform check-in with arrival time + dropped-by details.
- Return and show updated status.
- Perform check-out with collector name + relationship.
- Explain invalid transition guard (cannot check out before check in).

## 4) Daily Diary Workflow (2 min)
- Open `DiaryEntryFormView`.
- Select diary type (Activity/Sleep/Meal/Nappy/Wellbeing).
- Add timestamp + note and save.
- Show diary timeline update in `ChildDetailView`.
- Demonstrate validation by attempting empty note submission.

## 5) Persistence + Quality (1 min)
- Explain SwiftData local persistence across relaunch.
- Mention unit tests and UI smoke tests included.
- Mention accessibility labels/identifiers and empty-state handling.

## 6) Compliance-by-Design Close (45s)
- UK GDPR: data minimisation and purpose-scoped fields.
- EYFS/Ofsted: timestamped daily records for accountability.
- Children Act safeguarding: mandatory collector details at check-out.
- FSA support: meal/fluid diary type ready for nutritional logs.

## 7) Final Wrap (30s)
- Summarize delivered features and architecture.
- Mention planned future enhancements (report export, cloud sync, notifications).

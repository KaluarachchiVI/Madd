# NurseryConnect iOS MVP (Keyworker)

This project implements a SwiftUI MVP for the NurseryConnect case study from the **Keyworker** perspective.

## Implemented Features
- Daily Diary & Activity Monitoring
- Attendance Check-In / Check-Out

## Scope
- iOS app only
- Local persistence via SwiftData
- No login/authentication flow (per assignment constraints)
- No backend/cloud integrations

## UI design reference
Visual layout, colours, and component behaviour are aligned with the sibling **React + Tailwind** prototype in [`../designs/`](../designs/) (see `designs/src/styles/theme.css` and `designs/src/app/screens/`). This iOS target implements the same Keyworker flows in SwiftUI.

## Structure
- `NurseryConnectMVP.xcodeproj/` - Xcode project (open on macOS with Xcode 15+; iOS 17 deployment target for SwiftData)
- `NurseryConnectMVP/` - app source
- `NurseryConnectMVP/Design/` - `DesignTokens` (colours, radii)
- `NurseryConnectMVP/Utilities/` - shared formatters
- `NurseryConnectMVP/ViewModels/` - state and business logic
- `NurseryConnectMVP/Views/` - UI screens
- `NurseryConnectMVP/Views/DesignSystem/` - `IOSNavBar`, `IOSCard`, buttons, chips, form fields
- `NurseryConnectMVP/Validation/` - validation and error rules
- `NurseryConnectMVPTests/` - unit tests
- `NurseryConnectMVPUITests/` - UI smoke tests
- `docs/` - report (`report.md`), AI disclosure (`ai-appendix.md`), demo script, compliance checklist, and `docs/pdfs/` for the assignment PDFs

## Core Screens
- `ChildrenListView` - assigned children and current attendance status
- `ChildDetailView` - profile summary, attendance snapshot, diary timeline
- `DiaryEntryFormView` - create diary logs by type
- `AttendanceActionView` - check-in and check-out workflow

## Validation Included
- Required diary note
- Required drop-off details for check-in
- Required collector details for check-out
- Prevent check-out before check-in
- Prevent check-out time earlier than check-in

## Testing Included
- Unit tests for validation rules and attendance state constraints
- UI tests for list load and attendance navigation smoke flows

## Notes
- `AttendanceRecord` now stores separate **`checkInNotes`** and **`checkOutNotes`** (replacing the older single handover field). If an older build’s SwiftData store causes issues, delete the app or reset the simulator and relaunch.
- Set your **Team** in Xcode (Signing & Capabilities) before running on a device; the simulator works without a paid developer account.
- Assignment PDFs are not bundled here: copy `Assignment_01_2026.pdf` and `NurseryConnect_Case_Study.pdf` into `docs/pdfs/` and follow `docs/assignment-compliance-checklist.md`.

export type AttendanceStatus = 'not-in' | 'checked-in' | 'checked-out';

export type DiaryEntryType = 'activity' | 'sleep' | 'meal' | 'nappy' | 'wellbeing';

export interface Child {
  id: string;
  name: string;
  room: string;
  dietary: string[];
  status: AttendanceStatus;
  checkInTime?: string;
  checkOutTime?: string;
  droppedBy?: string;
  collectedBy?: string;
  collectorRelationship?: string;
  checkInNotes?: string;
  checkOutNotes?: string;
}

export interface DiaryEntry {
  id: string;
  childId: string;
  type: DiaryEntryType;
  timestamp: string;
  notes: string;
  significant: boolean;
}

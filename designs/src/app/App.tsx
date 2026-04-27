import { useState } from 'react';
import { MyChildrenScreen } from './screens/MyChildrenScreen';
import { ChildDetailScreen } from './screens/ChildDetailScreen';
import { AddDiaryEntryScreen } from './screens/AddDiaryEntryScreen';
import { AttendanceScreen } from './screens/AttendanceScreen';
import { Child, DiaryEntry, AttendanceStatus, DiaryEntryType } from './types';

type Screen = 'my-children' | 'child-detail' | 'add-diary' | 'attendance';

export default function App() {
  const [currentScreen, setCurrentScreen] = useState<Screen>('my-children');
  const [selectedChildId, setSelectedChildId] = useState<string | null>(null);

  const [children, setChildren] = useState<Child[]>([
    {
      id: '1',
      name: 'Aarav Perera',
      room: 'Butterflies',
      dietary: ['Nut-free'],
      status: 'checked-in',
      checkInTime: '08:42',
      droppedBy: 'Priya Perera (mum)',
      checkInNotes: 'Had a good breakfast. No allergies handed over today.',
    },
    {
      id: '2',
      name: 'Mia Fernando',
      room: 'Ladybirds',
      dietary: ['Dairy-free'],
      status: 'not-in',
    },
    {
      id: '3',
      name: 'Noah Silva',
      room: 'Butterflies',
      dietary: [],
      status: 'checked-out',
      checkInTime: '07:30',
      checkOutTime: '17:10',
      droppedBy: 'Sofia Silva (mum)',
      collectedBy: 'Maria Silva',
      collectorRelationship: 'Aunt',
      checkOutNotes: 'Had a great day. Ate all his lunch.',
    },
  ]);

  const [diaryEntries, setDiaryEntries] = useState<DiaryEntry[]>([
    {
      id: '1',
      childId: '1',
      type: 'meal',
      timestamp: new Date(2026, 3, 19, 12, 15).toISOString(),
      notes: 'Ate full lunch: pasta, vegetables, and fruit. Drank 150ml water.',
      significant: false,
    },
    {
      id: '2',
      childId: '1',
      type: 'sleep',
      timestamp: new Date(2026, 3, 19, 13, 30).toISOString(),
      notes: 'Napped for 45 minutes. Woke up happy and refreshed.',
      significant: false,
    },
  ]);

  const selectedChild = children.find((c) => c.id === selectedChildId);

  const updateChildStatus = (
    childId: string,
    status: AttendanceStatus,
    data: Partial<Child>
  ) => {
    setChildren((prev) =>
      prev.map((child) =>
        child.id === childId ? { ...child, status, ...data } : child
      )
    );
  };

  const addDiaryEntry = (
    type: DiaryEntryType,
    timestamp: string,
    notes: string,
    significant: boolean
  ) => {
    if (!selectedChildId) return;

    const newEntry: DiaryEntry = {
      id: Date.now().toString(),
      childId: selectedChildId,
      type,
      timestamp,
      notes,
      significant,
    };

    setDiaryEntries((prev) => [...prev, newEntry]);
  };

  const goBack = () => {
    if (currentScreen === 'child-detail') {
      setCurrentScreen('my-children');
      setSelectedChildId(null);
    } else if (currentScreen === 'add-diary' || currentScreen === 'attendance') {
      setCurrentScreen('child-detail');
    }
  };

  return (
    <div className="w-full h-screen bg-[#F7F7F5] overflow-hidden flex items-center justify-center">
      <div className="w-full max-w-[393px] h-full bg-[#F7F7F5] shadow-2xl overflow-hidden flex flex-col">
        <div className="h-[47px] bg-[#F7F7F5]" />

        <div className="flex-1 overflow-y-auto">
          {currentScreen === 'my-children' && (
            <MyChildrenScreen
              children={children}
              onSelectChild={(id) => {
                setSelectedChildId(id);
                setCurrentScreen('child-detail');
              }}
            />
          )}

          {currentScreen === 'child-detail' && selectedChild && (
            <ChildDetailScreen
              child={selectedChild}
              diaryEntries={diaryEntries.filter((e) => e.childId === selectedChild.id)}
              onBack={goBack}
              onAddDiary={() => setCurrentScreen('add-diary')}
              onAttendance={() => setCurrentScreen('attendance')}
            />
          )}

          {currentScreen === 'add-diary' && selectedChild && (
            <AddDiaryEntryScreen
              childName={selectedChild.name}
              onBack={goBack}
              onSave={addDiaryEntry}
            />
          )}

          {currentScreen === 'attendance' && selectedChild && (
            <AttendanceScreen
              child={selectedChild}
              onBack={goBack}
              onUpdate={updateChildStatus}
            />
          )}
        </div>

        <div className="h-[34px] bg-[#F7F7F5]" />
      </div>
    </div>
  );
}

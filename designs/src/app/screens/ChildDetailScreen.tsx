import { IOSNavBar } from '../components/IOSNavBar';
import { IOSCard, IOSCardRow } from '../components/IOSCard';
import { IOSButton } from '../components/IOSButton';
import { StatusChip } from '../components/StatusChip';
import { Child, DiaryEntry } from '../types';
import { Activity, Moon, UtensilsCrossed, Baby, Heart, ChevronRight } from 'lucide-react';

interface ChildDetailScreenProps {
  child: Child;
  diaryEntries: DiaryEntry[];
  onBack: () => void;
  onAddDiary: () => void;
  onAttendance: () => void;
}

const diaryIcons = {
  activity: Activity,
  sleep: Moon,
  meal: UtensilsCrossed,
  nappy: Baby,
  wellbeing: Heart,
};

const diaryLabels = {
  activity: 'Activity',
  sleep: 'Sleep/Nap',
  meal: 'Meal/Fluid',
  nappy: 'Nappy/Toilet',
  wellbeing: 'Wellbeing',
};

export function ChildDetailScreen({
  child,
  diaryEntries,
  onBack,
  onAddDiary,
  onAttendance,
}: ChildDetailScreenProps) {
  const todayEntries = diaryEntries.filter((entry) => {
    const entryDate = new Date(entry.timestamp);
    const today = new Date();
    return entryDate.toDateString() === today.toDateString();
  }).sort((a, b) => new Date(b.timestamp).getTime() - new Date(a.timestamp).getTime());

  const formatTime = (timestamp: string) => {
    return new Date(timestamp).toLocaleTimeString('en-GB', {
      hour: '2-digit',
      minute: '2-digit',
    });
  };

  const getAttendanceText = () => {
    if (child.status === 'not-in') {
      return 'Not checked in yet.';
    }
    if (child.status === 'checked-in') {
      return `Checked in · ${child.checkInTime}`;
    }
    if (child.status === 'checked-out') {
      return `Checked out · ${child.checkOutTime}`;
    }
  };

  return (
    <div className="min-h-full pb-8">
      <IOSNavBar title={child.name} onBack={onBack} />

      <div className="px-4 pt-6 space-y-6">
        <IOSCard title="Profile">
          <IOSCardRow label="Room" value={child.room} />
          <IOSCardRow
            label="Dietary"
            value={child.dietary.length > 0 ? child.dietary.join(', ') : 'None'}
            showDivider={false}
          />
        </IOSCard>

        <IOSCard title="Attendance">
          <div className="px-4 py-4">
            <div className="flex items-center justify-between mb-3">
              <span className="text-[17px] font-semibold text-[#111111]">Status</span>
              <StatusChip status={child.status} large />
            </div>
            <p className="text-[15px] text-[#555555] mb-1">{getAttendanceText()}</p>
            {child.status === 'checked-in' && child.droppedBy && (
              <p className="text-[15px] text-[#888888]">Dropped by · {child.droppedBy}</p>
            )}
            {child.status === 'checked-out' && child.collectedBy && (
              <p className="text-[15px] text-[#888888]">
                Collected by · {child.collectedBy} ({child.collectorRelationship})
              </p>
            )}
          </div>
        </IOSCard>

        <div className="space-y-2">
          <IOSButton onClick={onAddDiary} fullWidth>
            Add diary entry
          </IOSButton>
          <IOSButton onClick={onAttendance} variant="secondary" fullWidth>
            Attendance
          </IOSButton>
        </div>

        <div>
          <div className="flex items-center justify-between px-4 mb-3">
            <h3 className="text-[13px] font-semibold uppercase tracking-wide text-[#888888]">
              Diary today
            </h3>
            {todayEntries.length > 0 && (
              <span className="text-[13px] font-semibold text-[#888888]">
                {todayEntries.length} {todayEntries.length === 1 ? 'entry' : 'entries'}
              </span>
            )}
          </div>

          {todayEntries.length > 0 ? (
            <div className="bg-white rounded-[10px] shadow-sm overflow-hidden">
              {todayEntries.map((entry, index) => {
                const Icon = diaryIcons[entry.type];
                return (
                  <div
                    key={entry.id}
                    className={`px-4 py-4 flex gap-3 ${
                      index < todayEntries.length - 1 ? 'border-b border-[#E5E7EB]' : ''
                    }`}
                  >
                    <div className="w-10 h-10 rounded-full bg-[#F0FDFA] flex items-center justify-center flex-shrink-0">
                      <Icon className="w-5 h-5 text-[#0F766E]" />
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center justify-between mb-1">
                        <span className="text-[17px] font-semibold text-[#111111]">
                          {diaryLabels[entry.type]}
                        </span>
                        <span className="text-[15px] text-[#888888]">
                          {formatTime(entry.timestamp)}
                        </span>
                      </div>
                      <p className="text-[17px] text-[#555555] line-clamp-2">{entry.notes}</p>
                    </div>
                  </div>
                );
              })}
            </div>
          ) : (
            <div className="bg-white rounded-[10px] shadow-sm px-4 py-8 text-center">
              <p className="text-[17px] text-[#888888] mb-1">No entries yet</p>
              <p className="text-[15px] text-[#AAAAAA]">
                Log meals, sleep, and wellbeing notes.
              </p>
            </div>
          )}
        </div>

        <div className="px-4 py-2">
          <p className="text-[12px] text-[#888888] text-center leading-relaxed">
            Only record information needed for care and safeguarding. Avoid unnecessary personal
            details.
          </p>
        </div>
      </div>
    </div>
  );
}

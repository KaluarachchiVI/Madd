import { useState } from 'react';
import { IOSNavBar } from '../components/IOSNavBar';
import { IOSButton } from '../components/IOSButton';
import { IOSTextField } from '../components/IOSTextField';
import { DiaryEntryType } from '../types';
import { Activity, Moon, UtensilsCrossed, Baby, Heart } from 'lucide-react';

interface AddDiaryEntryScreenProps {
  childName: string;
  onBack: () => void;
  onSave: (type: DiaryEntryType, timestamp: string, notes: string, significant: boolean) => void;
}

const diaryTypes: { type: DiaryEntryType; label: string; icon: any }[] = [
  { type: 'activity', label: 'Activity', icon: Activity },
  { type: 'sleep', label: 'Sleep', icon: Moon },
  { type: 'meal', label: 'Meal', icon: UtensilsCrossed },
  { type: 'nappy', label: 'Nappy', icon: Baby },
  { type: 'wellbeing', label: 'Wellbeing', icon: Heart },
];

export function AddDiaryEntryScreen({ childName, onBack, onSave }: AddDiaryEntryScreenProps) {
  const [selectedType, setSelectedType] = useState<DiaryEntryType>('activity');
  const [notes, setNotes] = useState('');
  const [significant, setSignificant] = useState(false);
  const [showSuccess, setShowSuccess] = useState(false);
  const [errors, setErrors] = useState<{ notes?: string }>({});

  const now = new Date();
  const [date, setDate] = useState(now.toISOString().split('T')[0]);
  const [time, setTime] = useState(
    `${now.getHours().toString().padStart(2, '0')}:${now.getMinutes().toString().padStart(2, '0')}`
  );

  const handleSave = () => {
    const newErrors: { notes?: string } = {};

    if (!notes.trim()) {
      newErrors.notes = 'Please add notes about what happened';
    }

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }

    const timestamp = new Date(`${date}T${time}`).toISOString();
    onSave(selectedType, timestamp, notes, significant);

    setShowSuccess(true);
    setTimeout(() => {
      onBack();
    }, 800);
  };

  return (
    <div className="min-h-full pb-8">
      <IOSNavBar title="New diary entry" onBack={onBack} />

      <div className="px-4 pt-6 space-y-6">
        <div>
          <label className="block text-[15px] font-medium text-[#111111] mb-3">
            Entry type
          </label>
          <div className="flex gap-2 overflow-x-auto pb-2">
            {diaryTypes.map(({ type, label, icon: Icon }) => (
              <button
                key={type}
                onClick={() => setSelectedType(type)}
                className={`flex flex-col items-center gap-2 px-4 py-3 rounded-[10px] transition-all flex-shrink-0 ${
                  selectedType === type
                    ? 'bg-[#0F766E] text-white'
                    : 'bg-white text-[#111111] border border-[#E5E7EB]'
                }`}
              >
                <Icon className="w-6 h-6" />
                <span className="text-[13px] font-medium whitespace-nowrap">{label}</span>
              </button>
            ))}
          </div>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div className="space-y-2">
            <label className="block text-[15px] font-medium text-[#111111]">Date</label>
            <input
              type="date"
              value={date}
              onChange={(e) => setDate(e.target.value)}
              className="w-full px-4 py-3 bg-white rounded-[10px] text-[17px] text-[#111111] border border-[#E5E7EB] focus:border-[#0F766E] outline-none"
            />
          </div>
          <div className="space-y-2">
            <label className="block text-[15px] font-medium text-[#111111]">Time</label>
            <input
              type="time"
              value={time}
              onChange={(e) => setTime(e.target.value)}
              className="w-full px-4 py-3 bg-white rounded-[10px] text-[17px] text-[#111111] border border-[#E5E7EB] focus:border-[#0F766E] outline-none"
            />
          </div>
        </div>

        <IOSTextField
          label="Notes"
          value={notes}
          onChange={(val) => {
            setNotes(val);
            if (errors.notes && val.trim()) {
              setErrors({ ...errors, notes: undefined });
            }
          }}
          placeholder="What happened? Include enough detail for handover."
          multiline
          rows={5}
          required
          error={errors.notes}
        />

        <div className="flex items-start gap-3 p-4 bg-white rounded-[10px] border border-[#E5E7EB]">
          <button
            onClick={() => setSignificant(!significant)}
            className={`w-6 h-6 rounded-md border-2 flex items-center justify-center flex-shrink-0 transition-colors ${
              significant
                ? 'bg-[#0F766E] border-[#0F766E]'
                : 'bg-white border-[#D1D5DB]'
            }`}
          >
            {significant && (
              <svg className="w-4 h-4 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" />
              </svg>
            )}
          </button>
          <div className="flex-1">
            <span className="block text-[17px] text-[#111111] font-medium mb-1">
              Significant update
            </span>
            <span className="block text-[12px] text-[#888888]">
              Flag if parents should be alerted in a full system.
            </span>
          </div>
        </div>

        <div className="pt-4">
          <IOSButton onClick={handleSave} fullWidth>
            Save entry
          </IOSButton>
        </div>

        <div className="px-4 py-2">
          <p className="text-[12px] text-[#888888] text-center leading-relaxed">
            Only record information needed for care and safeguarding. Avoid unnecessary personal
            details.
          </p>
        </div>
      </div>

      {showSuccess && (
        <div className="fixed top-20 left-1/2 -translate-x-1/2 bg-[#111111] text-white px-6 py-3 rounded-[10px] shadow-lg">
          <span className="text-[17px] font-medium">Saved</span>
        </div>
      )}
    </div>
  );
}

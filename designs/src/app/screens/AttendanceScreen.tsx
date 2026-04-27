import { useState } from 'react';
import { IOSNavBar } from '../components/IOSNavBar';
import { IOSButton } from '../components/IOSButton';
import { IOSTextField } from '../components/IOSTextField';
import { IOSCard } from '../components/IOSCard';
import { StatusChip } from '../components/StatusChip';
import { Child, AttendanceStatus } from '../types';
import { AlertCircle } from 'lucide-react';

interface AttendanceScreenProps {
  child: Child;
  onBack: () => void;
  onUpdate: (childId: string, status: AttendanceStatus, data: Partial<Child>) => void;
}

export function AttendanceScreen({ child, onBack, onUpdate }: AttendanceScreenProps) {
  const now = new Date();
  const [checkInTime, setCheckInTime] = useState(
    `${now.getHours().toString().padStart(2, '0')}:${now.getMinutes().toString().padStart(2, '0')}`
  );
  const [droppedBy, setDroppedBy] = useState('');
  const [checkInNotes, setCheckInNotes] = useState('');

  const [checkOutTime, setCheckOutTime] = useState(
    `${now.getHours().toString().padStart(2, '0')}:${now.getMinutes().toString().padStart(2, '0')}`
  );
  const [collectedBy, setCollectedBy] = useState('');
  const [relationship, setRelationship] = useState('');
  const [checkOutNotes, setCheckOutNotes] = useState('');

  const [errors, setErrors] = useState<{
    droppedBy?: string;
    collectedBy?: string;
    relationship?: string;
    checkOutTime?: string;
  }>({});

  const [showBanner, setShowBanner] = useState(false);

  const getStatusText = () => {
    if (child.status === 'not-in') return 'Child is not currently checked in.';
    if (child.status === 'checked-in') return 'Child is currently checked in.';
    if (child.status === 'checked-out') return 'Child has been checked out today.';
  };

  const handleCheckIn = () => {
    const newErrors: { droppedBy?: string } = {};

    if (!droppedBy.trim()) {
      newErrors.droppedBy = 'Please enter who dropped off the child';
    }

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }

    onUpdate(child.id, 'checked-in', {
      checkInTime,
      droppedBy,
      checkInNotes,
    });

    setTimeout(() => onBack(), 500);
  };

  const handleCheckOut = () => {
    if (child.status !== 'checked-in') {
      setShowBanner(true);
      return;
    }

    const newErrors: {
      collectedBy?: string;
      relationship?: string;
      checkOutTime?: string;
    } = {};

    if (!collectedBy.trim()) {
      newErrors.collectedBy = 'Please enter who collected the child';
    }

    if (!relationship.trim()) {
      newErrors.relationship = 'Please enter relationship to child';
    }

    if (child.checkInTime && checkOutTime < child.checkInTime) {
      newErrors.checkOutTime = 'Check-out time cannot be earlier than check-in time';
    }

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }

    onUpdate(child.id, 'checked-out', {
      checkOutTime,
      collectedBy,
      collectorRelationship: relationship,
      checkOutNotes,
    });

    setTimeout(() => onBack(), 500);
  };

  return (
    <div className="min-h-full pb-8">
      <IOSNavBar title="Attendance" onBack={onBack} />

      <div className="px-4 pt-6 space-y-6">
        <div className="bg-white rounded-[10px] shadow-sm px-4 py-4">
          <div className="flex items-center justify-between mb-2">
            <span className="text-[17px] font-semibold text-[#111111]">Current status</span>
            <StatusChip status={child.status} large />
          </div>
          <p className="text-[15px] text-[#555555]">{getStatusText()}</p>
        </div>

        {showBanner && child.status !== 'checked-in' && (
          <div className="bg-[#FEF2F2] border border-[#FCA5A5] rounded-[10px] px-4 py-3 flex gap-3">
            <AlertCircle className="w-5 h-5 text-[#DC2626] flex-shrink-0 mt-0.5" />
            <p className="text-[15px] text-[#DC2626]">
              Cannot check out. Child must be checked in first.
            </p>
          </div>
        )}

        <IOSCard title="Check in">
          <div className="px-4 py-4 space-y-4">
            <div className="space-y-2">
              <label className="block text-[15px] font-medium text-[#111111]">Time</label>
              <input
                type="time"
                value={checkInTime}
                onChange={(e) => setCheckInTime(e.target.value)}
                className="w-full px-4 py-3 bg-white rounded-[10px] text-[17px] text-[#111111] border border-[#E5E7EB] focus:border-[#0F766E] outline-none"
              />
            </div>

            <IOSTextField
              label="Dropped by"
              value={droppedBy}
              onChange={(val) => {
                setDroppedBy(val);
                if (errors.droppedBy && val.trim()) {
                  setErrors({ ...errors, droppedBy: undefined });
                }
              }}
              placeholder="Name and relationship, e.g. Maya Fernando (mum)"
              required
              error={errors.droppedBy}
              helper="Name and relationship, e.g. Maya Fernando (mum)"
            />

            <IOSTextField
              label="Handover notes"
              value={checkInNotes}
              onChange={setCheckInNotes}
              placeholder="Include allergies handed over, sleep, mood."
              multiline
              rows={3}
              helper="Include allergies handed over, sleep, mood."
            />

            <IOSButton onClick={handleCheckIn} fullWidth disabled={child.status === 'checked-in'}>
              Confirm check-in
            </IOSButton>
          </div>
        </IOSCard>

        <IOSCard title="Check out">
          <div className="px-4 py-4 space-y-4">
            <div className="space-y-2">
              <label className="block text-[15px] font-medium text-[#111111]">Time</label>
              <input
                type="time"
                value={checkOutTime}
                onChange={(e) => {
                  setCheckOutTime(e.target.value);
                  if (errors.checkOutTime) {
                    setErrors({ ...errors, checkOutTime: undefined });
                  }
                }}
                className={`w-full px-4 py-3 bg-white rounded-[10px] text-[17px] text-[#111111] outline-none transition-all ${
                  errors.checkOutTime
                    ? 'border-2 border-[#DC2626]'
                    : 'border border-[#E5E7EB] focus:border-[#0F766E]'
                }`}
              />
              {errors.checkOutTime && (
                <p className="text-[12px] text-[#DC2626]">{errors.checkOutTime}</p>
              )}
            </div>

            <IOSTextField
              label="Collected by"
              value={collectedBy}
              onChange={(val) => {
                setCollectedBy(val);
                if (errors.collectedBy && val.trim()) {
                  setErrors({ ...errors, collectedBy: undefined });
                }
              }}
              placeholder="Full name"
              required
              error={errors.collectedBy}
            />

            <IOSTextField
              label="Relationship to child"
              value={relationship}
              onChange={(val) => {
                setRelationship(val);
                if (errors.relationship && val.trim()) {
                  setErrors({ ...errors, relationship: undefined });
                }
              }}
              placeholder="e.g. Aunt / Grandparent / Childminder"
              required
              error={errors.relationship}
              helper="e.g. Aunt / Grandparent / Childminder"
            />

            <IOSTextField
              label="Handover notes"
              value={checkOutNotes}
              onChange={setCheckOutNotes}
              placeholder="Summary of the day"
              multiline
              rows={3}
            />

            <IOSButton
              onClick={handleCheckOut}
              fullWidth
              disabled={child.status === 'checked-out'}
            >
              Confirm check-out
            </IOSButton>
          </div>
        </IOSCard>

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

interface StatusChipProps {
  status: 'not-in' | 'checked-in' | 'checked-out';
  large?: boolean;
}

export function StatusChip({ status, large = false }: StatusChipProps) {
  const styles = {
    'not-in': 'bg-[#F3F4F6] text-[#6B7280]',
    'checked-in': 'bg-[#D1FAE5] text-[#065F46]',
    'checked-out': 'bg-[#DBEAFE] text-[#1E40AF]',
  };

  const labels = {
    'not-in': 'Not in',
    'checked-in': 'Checked in',
    'checked-out': 'Checked out',
  };

  return (
    <span
      className={`inline-flex items-center justify-center px-3 rounded-full font-semibold ${
        large ? 'text-[15px] h-8' : 'text-[13px] h-6'
      } ${styles[status]}`}
    >
      {labels[status]}
    </span>
  );
}

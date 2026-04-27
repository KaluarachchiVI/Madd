interface IOSCardProps {
  children: React.ReactNode;
  title?: string;
  className?: string;
}

export function IOSCard({ children, title, className = '' }: IOSCardProps) {
  return (
    <div className={className}>
      {title && (
        <h3 className="text-[13px] font-semibold uppercase tracking-wide text-[#888888] px-4 mb-2">
          {title}
        </h3>
      )}
      <div className="bg-white rounded-[10px] shadow-sm overflow-hidden">
        {children}
      </div>
    </div>
  );
}

interface IOSCardRowProps {
  label: string;
  value: string | React.ReactNode;
  showDivider?: boolean;
}

export function IOSCardRow({ label, value, showDivider = true }: IOSCardRowProps) {
  return (
    <div className={`px-4 py-3 ${showDivider ? 'border-b border-[#E5E7EB]' : ''}`}>
      <div className="flex justify-between items-center">
        <span className="text-[17px] text-[#111111]">{label}</span>
        <span className="text-[17px] text-[#888888]">{value}</span>
      </div>
    </div>
  );
}

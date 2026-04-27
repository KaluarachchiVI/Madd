interface IOSTextFieldProps {
  label: string;
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  multiline?: boolean;
  rows?: number;
  error?: string;
  helper?: string;
  required?: boolean;
}

export function IOSTextField({
  label,
  value,
  onChange,
  placeholder,
  multiline = false,
  rows = 3,
  error,
  helper,
  required = false,
}: IOSTextFieldProps) {
  const baseInputStyles = `w-full px-4 py-3 bg-white rounded-[10px] text-[17px] text-[#111111] placeholder:text-[#888888] outline-none transition-all ${
    error ? 'border-2 border-[#DC2626]' : 'border border-[#E5E7EB] focus:border-[#0F766E]'
  }`;

  return (
    <div className="space-y-2">
      <label className="block text-[15px] font-medium text-[#111111]">
        {label}
        {required && <span className="text-[#DC2626] ml-1">*</span>}
      </label>
      {multiline ? (
        <textarea
          value={value}
          onChange={(e) => onChange(e.target.value)}
          placeholder={placeholder}
          rows={rows}
          className={`${baseInputStyles} resize-none`}
        />
      ) : (
        <input
          type="text"
          value={value}
          onChange={(e) => onChange(e.target.value)}
          placeholder={placeholder}
          className={baseInputStyles}
        />
      )}
      {error && <p className="text-[12px] text-[#DC2626]">{error}</p>}
      {helper && !error && <p className="text-[12px] text-[#888888]">{helper}</p>}
    </div>
  );
}

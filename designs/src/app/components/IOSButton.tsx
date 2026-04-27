interface IOSButtonProps {
  children: React.ReactNode;
  onClick?: () => void;
  variant?: 'primary' | 'secondary';
  fullWidth?: boolean;
  type?: 'button' | 'submit';
  disabled?: boolean;
}

export function IOSButton({
  children,
  onClick,
  variant = 'primary',
  fullWidth = false,
  type = 'button',
  disabled = false,
}: IOSButtonProps) {
  const baseStyles = 'h-[50px] rounded-[10px] font-semibold text-[17px] active:opacity-70 transition-opacity disabled:opacity-40';

  const variantStyles = {
    primary: 'bg-[#0F766E] text-white',
    secondary: 'bg-white text-[#0F766E] border border-[#0F766E]',
  };

  return (
    <button
      type={type}
      onClick={onClick}
      disabled={disabled}
      className={`${baseStyles} ${variantStyles[variant]} ${fullWidth ? 'w-full' : 'px-6'}`}
    >
      {children}
    </button>
  );
}

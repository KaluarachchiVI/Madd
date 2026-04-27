import { ChevronLeft } from 'lucide-react';

interface IOSNavBarProps {
  title: string;
  onBack?: () => void;
  largeTitle?: boolean;
}

export function IOSNavBar({ title, onBack, largeTitle = false }: IOSNavBarProps) {
  return (
    <div className="bg-[#F7F7F5] border-b border-[#E5E7EB]">
      <div className="h-11 flex items-center px-4">
        {onBack && (
          <button
            onClick={onBack}
            className="flex items-center gap-1 -ml-2 px-2 py-1 active:opacity-50"
          >
            <ChevronLeft className="w-5 h-5 text-[#0F766E]" strokeWidth={2.5} />
            <span className="text-[17px] text-[#0F766E]">Back</span>
          </button>
        )}
        {!largeTitle && !onBack && (
          <h1 className="flex-1 text-center text-[17px] font-semibold text-[#111111]">
            {title}
          </h1>
        )}
      </div>
      {largeTitle && (
        <div className="px-4 pt-2 pb-3">
          <h1 className="text-[34px] font-semibold text-[#111111] leading-[41px]">
            {title}
          </h1>
        </div>
      )}
    </div>
  );
}

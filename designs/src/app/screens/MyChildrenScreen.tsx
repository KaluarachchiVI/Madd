import { IOSNavBar } from '../components/IOSNavBar';
import { StatusChip } from '../components/StatusChip';
import { Child } from '../types';

interface MyChildrenScreenProps {
  children: Child[];
  onSelectChild: (id: string) => void;
}

export function MyChildrenScreen({ children, onSelectChild }: MyChildrenScreenProps) {
  return (
    <div className="min-h-full">
      <IOSNavBar title="My Children" largeTitle />

      <div className="px-4 pt-4 space-y-2">
        {children.map((child, index) => (
          <button
            key={child.id}
            onClick={() => onSelectChild(child.id)}
            className="w-full bg-white rounded-[10px] p-4 flex items-center gap-3 active:opacity-70 transition-opacity shadow-sm"
          >
            <div className="w-12 h-12 rounded-full bg-gradient-to-br from-[#0F766E] to-[#14B8A6] flex items-center justify-center flex-shrink-0">
              <span className="text-white font-semibold text-[17px]">
                {child.name.split(' ').map((n) => n[0]).join('')}
              </span>
            </div>

            <div className="flex-1 text-left">
              <h3 className="text-[17px] font-semibold text-[#111111]">{child.name}</h3>
              <p className="text-[15px] text-[#555555]">Room: {child.room}</p>
              {child.dietary.length > 0 && (
                <div className="flex gap-1 mt-1">
                  {child.dietary.map((diet) => (
                    <span
                      key={diet}
                      className="text-[12px] bg-[#FEF3C7] text-[#92400E] px-2 py-0.5 rounded-full"
                    >
                      {diet}
                    </span>
                  ))}
                </div>
              )}
            </div>

            <StatusChip status={child.status} />
          </button>
        ))}
      </div>

      {children.length === 0 && (
        <div className="flex flex-col items-center justify-center py-16 px-8 text-center">
          <h3 className="text-[20px] font-semibold text-[#111111] mb-2">
            No children assigned
          </h3>
          <p className="text-[15px] text-[#888888] mb-6">
            Ask your manager to assign key children.
          </p>
        </div>
      )}
    </div>
  );
}

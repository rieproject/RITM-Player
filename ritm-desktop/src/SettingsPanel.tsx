import { X } from 'lucide-react';
import { LOCALE_ORDER, LOCALES, useI18n, type Locale } from './i18n';

/** Pengaturan edisi standar: hanya bahasa. Pemutaran memakai mesin audio otomatis. */
export function SettingsPanel({ onClose }: { onClose: () => void }) {
  const { t, locale, setLocale } = useI18n();

  const localeOptions = LOCALE_ORDER.map((l): [Locale, string, boolean] => [l, LOCALES[l].name, false]);

  return (
    <div className="fixed inset-0 z-[60] flex justify-end" role="dialog" aria-modal="true" aria-label={t('settings.title')}>
      <button type="button" tabIndex={-1} aria-label={t('common.close')} className="absolute inset-0 bg-black/30 backdrop-blur-[2px]" onClick={onClose} />
      <div className="relative flex h-full w-full max-w-md flex-col overflow-y-auto bg-neutral-50 px-6 py-5 shadow-[0_0_64px_rgba(0,0,0,0.2)] dark:bg-neutral-950">
        <div className="flex items-center justify-between">
          <h2 className="text-lg font-semibold tracking-tight">{t('settings.title')}</h2>
          <button type="button" className="btn-icon" aria-label={t('settings.close')} onClick={onClose}>
            <X className="size-4" />
          </button>
        </div>

        <section className="mt-6">
          <p className="label mb-2">{t('settings.language')}</p>
          <Segmented label={t('settings.language')} value={locale} onChange={setLocale} options={localeOptions} />
        </section>

        <p className="mt-auto pt-10 text-center text-xs text-neutral-400">{t('settings.credit')}</p>
      </div>
    </div>
  );
}

function Segmented<T extends string>({
  label,
  value,
  onChange,
  options,
}: {
  label: string;
  value: T;
  onChange: (v: T) => void;
  options: [T, string, boolean][];
}) {
  return (
    <div className="grid grid-cols-2 gap-1 rounded-2xl bg-neutral-200/70 p-1 dark:bg-neutral-900" role="radiogroup" aria-label={label}>
      {options.map(([v, text, disabled]) => {
        const on = value === v;
        return (
          <button
            key={v}
            type="button"
            role="radio"
            aria-checked={on}
            disabled={disabled}
            onClick={() => onChange(v)}
            className={`rounded-xl px-3 py-2 text-sm font-medium transition-colors disabled:opacity-40 ${
              on ? 'bg-white shadow-sm dark:bg-neutral-800' : 'text-neutral-600 hover:text-neutral-900 dark:text-neutral-400 dark:hover:text-white'
            }`}
          >
            {text}
          </button>
        );
      })}
    </div>
  );
}

import { SettingItem } from '../models/SettingItem';

export function createDefaultSettings(): SettingItem[] {
  return [
    new SettingItem('Wi-Fi', 'On', false),
    new SettingItem('Bluetooth', 'On', false),
    new SettingItem('Brightness', 'Auto', false),
    new SettingItem('Do Not Disturb', 'Off', false),
    new SettingItem('Factory Reset', '', true)
  ];
}

export function toggleSettingValue(value: string): string {
  if (value === 'On') {
    return 'Off';
  }
  if (value === 'Off') {
    return 'On';
  }
  return value;
}

export function applySetting(settings: SettingItem[], name: string): SettingItem[] {
  let i: number = settings.findIndex((s: SettingItem) => s.name === name);
  if (i < 0) {
    return settings;
  }
  let current: SettingItem = settings[i];
  let newValue: string = toggleSettingValue(current.value);
  let updated: SettingItem[] = settings.slice();
  updated.splice(i, 1, new SettingItem(current.name, newValue, current.destructive));
  return updated;
}

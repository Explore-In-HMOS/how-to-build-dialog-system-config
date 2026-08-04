export class SettingItem {
  readonly name: string;
  readonly value: string;
  readonly destructive: boolean;

  constructor(name: string, value: string, destructive: boolean) {
    this.name = name;
    this.value = value;
    this.destructive = destructive;
  }
}
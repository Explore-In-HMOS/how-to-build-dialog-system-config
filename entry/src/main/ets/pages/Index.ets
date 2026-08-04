import { PromptAction } from '@kit.ArkUI';
import { SettingItem } from '../models/SettingItem';
import { createDefaultSettings, applySetting } from '../helpers/SettingsHelper';
import { openConfirm, openInterstitial } from '../helpers/DialogHelper';

@Entry
@Component
struct Index {
  @State result: string = 'Select a setting';
  @State settings: SettingItem[] = createDefaultSettings();

  // Built-in environment variables: system state provided by ArkUI through
  // AppStorage. colorMode reflects light/dark, languageCode the system language.
  @StorageProp('colorMode') colorMode: number = -1;
  @StorageProp('languageCode') languageCode: string = '';

  private promptAction: PromptAction = this.getUIContext().getPromptAction();

  // Renders the environment info line, e.g. "dark · en".
  private envText(): string {
    let mode: string = this.colorMode === 0 ? 'dark' : this.colorMode === 1 ? 'light' : 'unknown';
    return `${mode}`;
  }

  build() {
    Column({ space: 8 }) {
      Text($r('app.string.settings_title'))
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))

      // System environment line, driven by built-in environment variables.
      Text(this.envText())
        .fontSize(9)
        .fontColor($r('app.color.text_secondary'))

      Text(this.result)
        .fontSize(11)
        .fontColor($r('app.color.color_accent'))

      List({ space: 6 }) {
        Repeat<SettingItem>(this.settings)
          .each((obj: RepeatItem<SettingItem>) => {
            ListItem() {
              Row() {
                Text(obj.item.name)
                  .fontSize(13)
                  .fontColor(obj.item.destructive ? $r('app.color.color_destructive') : $r('app.color.text_primary'))
                Blank()
                Text(obj.item.value)
                  .fontSize(11)
                  .fontColor($r('app.color.text_secondary'))
              }
              .width('100%')
              .height(38)
              .padding({ left: 12, right: 12 })
              .borderRadius(10)
              .backgroundColor($r('app.color.card_bg'))
              .onClick(() => {
                if (obj.item.destructive) {
                  openInterstitial(this.getUIContext(), obj.item.name, (msg: string) => {
                    this.result = msg;
                  });
                } else {
                  openConfirm(this.promptAction, obj.item.name, obj.item.value, (msg: string) => {
                    if (msg.endsWith(': applied')) {
                      this.settings = applySetting(this.settings, obj.item.name);
                    }
                    this.result = msg;
                  });
                }
              })
            }
          })
          .key((item: SettingItem) => `${item.name}:${item.value}`)
      }
      .width('86%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .contentEndOffset(40)
    }
    .padding({ top: 14, bottom: 10 })
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_bg'))
  }
}
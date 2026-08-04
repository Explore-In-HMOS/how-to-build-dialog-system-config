import { PromptAction, InterstitialDialogAction, IconStyle, TitlePosition, BottomOffset } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

const COLOR_HINT: string = '#999999';
const COLOR_ACCENT: string = '#4CAF50';
const COLOR_DESTRUCTIVE: string = '#EF4444';

export function openConfirm(
  promptAction: PromptAction,
  name: string,
  currentValue: string,
  onResult: (msg: string) => void
): void {
  let nextValue: string = currentValue === 'On' ? 'Off' : 'On';
  promptAction.showDialog({
    title: `${name}: ${currentValue}`,
    message: `Turn ${nextValue}?`,
    buttons: [
      { text: 'No', color: COLOR_HINT },
      { text: nextValue, color: nextValue === 'Off' ? COLOR_DESTRUCTIVE : COLOR_ACCENT }
    ]
  })
    .then((data) => {
      if (data.index === 1) {
        onResult(`${name}: applied`);
      } else {
        onResult(`${name}: cancelled`);
      }
      console.info(`[DLG] ${name} index=${data.index}`);
    })
    .catch((err: BusinessError) => {
      onResult(`error ${err.code}`);
      console.error(`[DLG] showDialog failed code=${err.code} msg=${err.message}`);
    });
}

export function openInterstitial(
  uiContext: UIContext,
  name: string,
  onResult: (msg: string) => void
): void {
  try {
    let action: InterstitialDialogAction = new InterstitialDialogAction({
      uiContext: uiContext,
      title: 'Reset?',
      subtitle: 'Tap to confirm',
      titleColor: COLOR_DESTRUCTIVE,
      subtitleColor: COLOR_HINT,
      iconStyle: IconStyle.LIGHT,
      titlePosition: TitlePosition.TOP,
      bottomOffsetType: BottomOffset.OFFSET_FOR_NONE,
      onDialogClick: () => {
        onResult(`${name}: confirmed`);
        console.info(`[INT] ${name} confirmed`);
      },
      onDialogClose: () => {
        onResult(`${name}: cancelled`);
        console.info(`[INT] ${name} closed`);
      }
    });
    action.openDialog();
  } catch (err) {
    let e: BusinessError = err as BusinessError;
    onResult(`interstitial error ${e.code}`);
    console.error(`[INT] failed code=${e.code} msg=${e.message}`);
  }
}

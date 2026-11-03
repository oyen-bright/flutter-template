# Shared UI component registry

The source of truth for what UI already exists. **Read this before building any UI.**
`tool/check_structure.dart` fails if a file in `components/` is missing from this table.

| Component | File | Base (shadcn) | Use for | Variants / key params |
|---|---|---|---|---|
| AppButton | components/app_button.dart | ShadButton | Every tappable button | default (primary), `.secondary`, `.outline`, `.ghost`, `.destructive`, `.link`; `icon`, `isLoading`, `expand` |
| AppTextField | components/app_text_field.dart | ShadInputFormField | Text inputs inside forms | default, `.password`; `label`, `placeholder`, `description`, `validator`, `leading`, `trailing`, `maxLines` |
| AppScaffold | components/app_scaffold.dart | Material Scaffold | Root of every page | `title`, `actions`, `bottomBar` (sticky CTA), `floatingAction`, `padded` |
| AppCard | components/app_card.dart | ShadCard | Grouped content surfaces, tappable rows | `title`, `description`, `leading`, `trailing`, `footer`, `onTap` |
| AppToast | components/app_toast.dart | ShadToast | Transient feedback from a BlocListener | `AppToast.success`, `AppToast.error` |
| AppSkeletonList / AppSkeleton | components/app_state_views.dart | skeletonizer | Loading placeholders (never a bare spinner for lists) | `itemCount`; `AppSkeleton(loading:, child:)` |
| AppEmptyView | components/app_state_views.dart | - | Empty list / no data | `message`, `icon` |
| AppErrorView | components/app_state_views.dart | - | Failed load with retry | `message`, `onRetry` |
<!-- [components] - `mason make ui_component` appends rows above this line. -->

## shadcn components not wrapped yet

Wrap with `mason make ui_component --name <name> --base <ShadWidget>` before first use:
ShadAccordion, ShadAlert, ShadAvatar, ShadBadge, ShadCalendar, ShadCheckbox(FormField),
ShadDatePicker, ShadDialog, ShadInputOTP, ShadPopover, ShadProgress, ShadRadioGroup,
ShadSelect, ShadSheet, ShadSlider, ShadSwitch, ShadTable, ShadTabs, ShadTextarea,
ShadTimePicker, ShadTooltip.

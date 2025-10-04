import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_selector/flutter_country_selector.dart';

@Deprecated('Use [CountryButton] instead')
typedef CountryChip = CountryButton;

class CountryButton extends StatelessWidget {
  final Function()? onTap;
  final IsoCode isoCode;
  final TextStyle? textStyle;
  final EdgeInsets padding;
  final double flagSize;
  final bool showFlag;
  final bool showDialCode;
  final bool showIsoCode;
  final bool showDropdownIcon;
  final BorderRadius? borderRadius;
  final Color? dropdownIconColor;
  final bool enabled;
  final bool useEmoji;

  const CountryButton({
    super.key,
    required this.isoCode,
    required this.onTap,
    this.textStyle,
    this.padding = const EdgeInsets.all(0),
    this.flagSize = 20,
    this.showFlag = true,
    this.showDialCode = true,
    this.showIsoCode = false,
    this.showDropdownIcon = true,
    this.dropdownIconColor,
    this.enabled = true,
    this.borderRadius,
    this.useEmoji = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = this.textStyle ??
        Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16) ??
        const TextStyle();
    final countryLocalization = CountrySelectorLocalization.of(context) ??
        CountrySelectorLocalizationEn();
    final countryDialCode = '+ ${countryLocalization.countryDialCode(isoCode)}';

    return Transform(
      transform: Matrix4.translationValues(0, 5, 0),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (showIsoCode) ...[
                Text(
                  isoCode.name,
                  style: textStyle.copyWith(
                    color: enabled ? null : Theme.of(context).disabledColor,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (showFlag) ...[
                ExcludeSemantics(
                  child: GrayScale(
                    visible: !enabled,
                    child: useEmoji
                        ? Text(
                            generateFlagEmojiUnicode(isoCode.name),
                            style: TextStyle(fontSize: flagSize),
                          )
                        : CircleFlag(
                            isoCode.name,
                            size: flagSize,
                          ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (showDialCode) ...[
                Text(
                  countryDialCode,
                  style: textStyle.copyWith(
                    color: enabled ? null : Theme.of(context).disabledColor,
                  ),
                ),
              ],
              if (showDropdownIcon)
                ExcludeSemantics(
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: dropdownIconColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class GrayScale extends StatelessWidget {
  final bool visible;
  final Widget child;

  const GrayScale({
    super.key,
    required this.child,
    this.visible = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return child;
    }

    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        0.2126, 0.7152, 0.0722, 0, 0, //
        0.2126, 0.7152, 0.0722, 0, 0,
        0.2126, 0.7152, 0.0722, 0, 0,
        0, 0, 0, 1, 0,
      ]),
      child: child,
    );
  }
}

/// Returns a [String] which will be the unicode of a Flag Emoji,
/// from a country [countryCode] passed as a parameter.
String generateFlagEmojiUnicode(String countryCode) {
  const base = 127397;

  return countryCode.codeUnits
      .map((e) => String.fromCharCode(base + e))
      .toList()
      .reduce((value, element) => value + element)
      .toString();
}

import 'package:calendar_view/calendar_view.dart';
import 'package:cliary_test/cubit/events_cubit.dart';
import 'package:cliary_test/model/models.dart';
import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:cliary_test/resources/cliary_strings.dart';
import 'package:cliary_test/resources/cliary_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cliary_ink_well.dart';

class CliaryDayView extends StatefulWidget {
  const CliaryDayView({
    Key? key,
    this.dayViewState,
    this.width,
    this.startFromToday = false,
    this.initialDay,
    this.onEventTap,
    this.onPageChange,
    this.initialOffset,
    this.header,
    this.scrollController,
  }) : super(key: key);

  final GlobalKey<DayViewState>? dayViewState;
  final double? width;
  final bool startFromToday;
  final DateTime? initialDay;
  final int? initialOffset;
  final void Function(CalendarEventData<Event> event)? onEventTap;
  final void Function(DateTime date, int page)? onPageChange;
  final Widget? header;
  final ScrollController? scrollController;

  @override
  State<CliaryDayView> createState() => _CliaryDayViewState();
}

class _CliaryDayViewState extends State<CliaryDayView> {
  late GlobalKey<DayViewState>? dayViewState;

  @override
  void initState() {
    super.initState();
    dayViewState = widget.dayViewState ?? GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return BlocBuilder<AllEventsCubit, IAllEventsState>(
        builder: (context, state) {
          return DayView<Event>(
            key: dayViewState,
            minDay: widget.startFromToday ? today : null,
            initialDay: widget.initialDay,
            heightPerMinute: 1.4,
            width: widget.width,
            initialOffset: widget.initialOffset ?? (_isToday(widget.initialDay) ? DateTime.now().hour : 8),
            onPageChange: widget.onPageChange,
            eventTileBuilder: _buildEventTile,
            timeLineBuilder: _buildTimelineItem,
            dayTitleBuilder: _buildDateTitle,
            scrollController: widget.scrollController,
          );
        });
  }

  Widget _buildTimelineItem(DateTime date) {
    return Transform.translate(
      offset: const Offset(2.5, -7.5),
      child: Text(
        '${date.hour}:${date.minute < 10 ? '0${date.minute}' : date.minute}',
        textAlign: TextAlign.center,
        style: CliaryTextStyle.get(
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildDateTitle(DateTime date) {
    final today = DateTime.now();
    return Column(
      children: [
        if (widget.header != null) widget.header!,
        CliaryInkWell(
          onTap: () async {
            final chosenDate = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: widget.startFromToday ? DateTime.now() : DateTime(2021, 1, 1),
                lastDate: DateTime(2025, 12, 31),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      primaryColor: CliaryColors.cliaryMainBlue,
                      colorScheme: const ColorScheme.light(
                        primary: CliaryColors.cliaryMainBlue,
                      ),
                      buttonTheme: const ButtonThemeData(
                        textTheme: ButtonTextTheme.primary,
                      ),
                    ),
                    child: child!,
                  );
                },
                helpText: 'Wybierz datę',
                cancelText: 'Cofnij',
                confirmText: 'Wybierz');
            if (chosenDate != null) {
              dayViewState!.currentState!.animateToDate(chosenDate);
            }
          },
          child: Material(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => dayViewState!.currentState!.previousPage(),
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  icon: const Icon(
                    Icons.chevron_left,
                    size: 30,
                    color: CliaryColors.textBlack,
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 9),
                        child: Text(
                          '${date.day}',
                          style: CliaryTextStyle.get(
                            fontSize: 54,
                            color: date.day == today.day &&
                                date.month == today.month &&
                                date.year == today.year
                                ? const Color(0xFFB00020)
                                : CliaryColors.textBlack,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${CliaryStrings.months[date.month]}${date.year == today.year ? '' : ', ${date.year}'}',
                            style: CliaryTextStyle.get(
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            CliaryStrings.weekdays[date.weekday]!,
                            style: CliaryTextStyle.get(
                              fontSize: 18,
                              color: date.weekday == 6 || date.weekday == 7
                                  ? const Color(0xFFB00020)
                                  : CliaryColors.cliaryMainBlue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => dayViewState!.currentState!.nextPage(),
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  icon: const Icon(
                    Icons.chevron_right,
                    size: 30,
                    color: CliaryColors.textBlack,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventTile(date, events, boundry, start, end) {
    final title = events.first.title;
    final client = events.first.description;
    final duration = start.difference(end).inMinutes;
    final cost = events.first.event!.cost;
    final color = events.first.color;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => widget.onEventTap == null ? {} : widget.onEventTap!(events.first),
      child: Container(
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.all(2),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: events.first.event!.isCurrentlyEdited
            ? Border.all(
              color: CliaryColors.cliaryMainBlue,
              width: 2,
            )
            : Border.all(
              color: CliaryColors.descriptionTextGray,
              width: 0.5,
            ),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(title),
                    _buildAdditionalInfo(client, true),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: (cost != null)
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildAdditionalInfo('$duration min', false),
                  if (cost != null) _buildAdditionalInfo('$cost PLN', false)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: CliaryTextStyle.get(
        // color: Colors.white,
        color: CliaryColors.textBlack,
        fontSize: 14,
      ),
    );
  }

  Widget _buildAdditionalInfo(String text, bool isOnLeft) {
    return Text(
      text,
      overflow: TextOverflow.fade,
      style: CliaryTextStyle.get(
        fontSize: 12,
        // color: Colors.white.withOpacity(0.8),
        color: CliaryColors.descriptionTextGray,
      ),
    );
  }

  bool _isToday(DateTime? day) {
    if (day == null) return true;

    final today = DateTime.now();
    return day.day == today.day && day.month == today.month && day.year == today.year;
  }
}

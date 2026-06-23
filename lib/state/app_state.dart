import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models.dart';
import '../data/seed.dart' as seed;

class AppState extends ChangeNotifier {
  String screen = 'welcome';
  List<String> stack = [];
  String tab = 'home';
  String? catId;
  // User profile (set at sign-in / sign-up)
  String userName = '';
  String userEmail = '';
  String userCompany = '';
  String filter = 'all';
  String search = '';
  String itemId = 'marquee';
  int gallery = 0;
  List<String> favs = ['festoon', 'chiavari'];
  List<String> onboardSel = ['Weddings', 'Corporate'];
  String teamSize = '6–20';
  int calYear = 2026;
  int calMonth = 5; // 0-indexed: June
  String? startDate;
  String? endDate;
  int qty = 1;
  String delivery = 'delivery';
  bool protection = true;
  String payMethod = 'card1';
  String checkTab = 'pickup';
  Map<String, bool> checks = {};
  List<Booking> bookings = [];
  String? activeBookingId;
  String? chatId;
  Map<String, List<ChatMessage>> messages = {};
  String toast = '';
  Timer? _toastTimer;

  static const today = '2026-06-22';

  void bump() => notifyListeners();

  void go(String s) {
    stack = [...stack, screen];
    screen = s;
    toast = '';
    notifyListeners();
  }

  void back() {
    if (stack.isNotEmpty) {
      screen = stack.last;
      stack = stack.sublist(0, stack.length - 1);
    } else {
      screen = 'home';
    }
    notifyListeners();
  }

  void setTab(String t, String s) {
    tab = t;
    screen = s;
    stack = [];
    notifyListeners();
  }

  void toggleFav(String id) {
    if (favs.contains(id)) {
      favs = favs.where((f) => f != id).toList();
    } else {
      favs = [...favs, id];
    }
    notifyListeners();
  }

  void toggleCheck(String key) {
    checks = {...checks, key: !(checks[key] ?? false)};
    notifyListeners();
  }

  void flashToast(String msg) {
    toast = msg;
    _toastTimer?.cancel();
    notifyListeners();
    _toastTimer = Timer(const Duration(milliseconds: 2600), () {
      toast = '';
      notifyListeners();
    });
  }

  Item get currentItem => seed.items.firstWhere((i) => i.id == itemId, orElse: () => seed.items.first);

  int get rentalDays {
    if (startDate == null) return 0;
    if (endDate == null) return 1;
    final a = DateTime.parse(startDate!);
    final b = DateTime.parse(endDate!);
    return b.difference(a).inDays + 1;
  }

  int get subtotal => currentItem.price * qty * (rentalDays == 0 ? 1 : rentalDays);
  int get deliveryFee => delivery == 'delivery' ? 65 : 0;
  int get protectionFee => protection ? (subtotal * 0.09).round() : 0;
  int get serviceFee => (subtotal * 0.06).round();
  int get orderTotal => subtotal + deliveryFee + protectionFee + serviceFee;
  int get dueToday => orderTotal + currentItem.deposit;

  void addBooking() {
    final item = currentItem;
    final id = 'BK${DateTime.now().millisecondsSinceEpoch}';
    final b = Booking(
      id: id,
      itemId: item.id,
      itemName: item.name,
      itemCode: item.code,
      ownerName: item.owner,
      datesStr: '${formatDate(startDate)} – ${formatDate(endDate)}',
      total: formatPrice(dueToday),
      status: 'pickup_pending',
      sa: item.sa,
      sb: item.sb,
    );
    bookings = [...bookings, b];
    activeBookingId = id;
    checks = {};
    notifyListeners();
  }

  void startReturn(String bookingId) {
    final b = bookings.firstWhere((b) => b.id == bookingId, orElse: () => bookings.first);
    itemId = b.itemId;
    activeBookingId = bookingId;
    checkTab = 'return';
    checks = {};
    go('checklist');
  }

  void confirmPickup() {
    if (activeBookingId == null) return;
    for (final b in bookings) {
      if (b.id == activeBookingId) b.status = 'active';
    }
    notifyListeners();
  }

  void confirmReturn() {
    if (activeBookingId == null) return;
    for (final b in bookings) {
      if (b.id == activeBookingId) b.status = 'returned';
    }
    activeBookingId = null;
    notifyListeners();
  }

  Booking? get activeBooking {
    if (activeBookingId == null) return null;
    try { return bookings.firstWhere((b) => b.id == activeBookingId); } catch (_) { return null; }
  }

  bool isDayBooked(int day) {
    final s = currentItem.id.length;
    return ((day * 7) + s * 3) % 11 < 2;
  }

  String formatPrice(int n) => '\$${n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

  String formatDate(String? key) {
    if (key == null) return '—';
    final d = DateTime.parse(key);
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    const days = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
    return '${days[d.weekday % 7]} ${months[d.month - 1]} ${d.day}';
  }

  void pickDay(int year, int month, int day) {
    final key = '$year-${month.toString().padLeft(2,'0')}-${day.toString().padLeft(2,'0')}';
    if (startDate == null || (startDate != null && endDate != null)) {
      startDate = key;
      endDate = null;
    } else if (key.compareTo(startDate!) < 0) {
      startDate = key;
      endDate = null;
    } else if (key == startDate) {
      return;
    } else {
      endDate = key;
    }
    notifyListeners();
  }

  void shiftMonth(int dir) {
    calMonth += dir;
    if (calMonth < 0) { calMonth = 11; calYear--; }
    if (calMonth > 11) { calMonth = 0; calYear++; }
    notifyListeners();
  }

  void sendMessage() {
    final id = chatId;
    if (id == null) return;
    final extra = messages[id] ?? [];
    final next = [...extra, const ChatMessage(from: 'me', text: 'Sounds great, thank you! See you then.', time: 'Now')];
    messages = {...messages, id: next};
    notifyListeners();
    Timer(const Duration(milliseconds: 1400), () {
      final cur = messages[id] ?? [];
      messages = {...messages, id: [...cur, const ChatMessage(from: 'them', text: 'Anytime — we\'ll be in touch the day before. 👍', time: 'Now')]};
      notifyListeners();
    });
  }

  List<Item> get filteredItems {
    var result = seed.items.toList();
    if (catId != null) result = result.where((i) => i.cat == catId).toList();
    if (filter == 'delivery') result = result.where((i) => i.tags.contains('Delivery')).toList();
    if (filter == 'pro') result = result.where((i) => i.pro).toList();
    if (filter == 'nearby') result = result.where((i) => double.parse(i.distance.split(' ')[0]) < 3.5).toList();
    if (search.isNotEmpty) {
      final q = search.toLowerCase();
      result = seed.items.where((i) => i.name.toLowerCase().contains(q) || i.owner.toLowerCase().contains(q)).toList();
    }
    return result;
  }

  List<ChecklistItem> get currentChecklist => checkTab == 'pickup' ? seed.pickupChecks : seed.returnChecks;
  int get doneCount => currentChecklist.where((c) => checks[c.key] == true).length;
  bool get allChecked => doneCount == currentChecklist.length;

  Chat? get currentChat {
    if (chatId == null) return null;
    try { return seed.chats.firstWhere((c) => c.id == chatId); } catch (_) { return null; }
  }

  List<ChatMessage> get chatThread {
    final chat = currentChat;
    if (chat == null) return [];
    return [...chat.msgs, ...(messages[chat.id] ?? [])];
  }

  @override
  void dispose() {
    _toastTimer?.cancel();
    super.dispose();
  }
}

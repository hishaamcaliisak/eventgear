import 'package:flutter/material.dart';

class Category {
  final String id, code, name;
  final int count;
  final Color tint, line, ink;
  const Category({required this.id, required this.code, required this.name, required this.count, required this.tint, required this.line, required this.ink});
}

class Item {
  final String id, cat, code, name, owner, ownerId;
  final double rating;
  final int reviews, price, deposit, qty;
  final String distance, loc, desc;
  final bool pro;
  final Color sa, sb;
  final List<String> tags;
  final List<List<String>> specs;
  const Item({required this.id, required this.cat, required this.code, required this.name, required this.owner, required this.ownerId, required this.rating, required this.reviews, required this.price, required this.deposit, required this.qty, required this.distance, required this.loc, required this.desc, required this.pro, required this.sa, required this.sb, required this.tags, required this.specs});
}

class Review {
  final String author, co, date, text;
  final int rating, helpful;
  const Review({required this.author, required this.co, required this.date, required this.text, required this.rating, required this.helpful});
  String get initials => author.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join();
  String get starsStr => '★' * rating + '☆' * (5 - rating);
}

class ChatMessage {
  final String from, text, time;
  const ChatMessage({required this.from, required this.text, required this.time});
  bool get isMe => from == 'me';
}

class Chat {
  final String id, name, item, last, time;
  final int unread;
  final bool online;
  final List<ChatMessage> msgs;
  const Chat({required this.id, required this.name, required this.item, required this.last, required this.time, required this.unread, required this.online, required this.msgs});
  String get initials => name.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join();
}

class HistoryEntry {
  final String id, itemId, code, name, owner, dates, status, statusLabel, total;
  final Color sa, sb;
  const HistoryEntry({required this.id, required this.itemId, required this.code, required this.name, required this.owner, required this.dates, required this.status, required this.statusLabel, required this.total, required this.sa, required this.sb});
}

class ChecklistItem {
  final String key, title, desc;
  const ChecklistItem({required this.key, required this.title, required this.desc});
}

class Booking {
  final String id, itemId, itemName, itemCode, ownerName, datesStr, total;
  String status; // 'pickup_pending' | 'active' | 'returned'
  final Color sa, sb;

  Booking({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.itemCode,
    required this.ownerName,
    required this.datesStr,
    required this.total,
    required this.status,
    required this.sa,
    required this.sb,
  });

  String get statusLabel {
    switch (status) {
      case 'pickup_pending': return 'Pickup pending';
      case 'active': return 'Active hire';
      case 'returned': return 'Returned';
      default: return status;
    }
  }
}

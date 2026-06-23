import 'package:flutter/material.dart';
import 'models.dart';

const cats = [
  Category(id:'tents', code:'TN', name:'Tents & Marquees', count:48, tint:Color(0xFFE7EFE9), line:Color(0xFFD3E2D8), ink:Color(0xFF1F6B4A)),
  Category(id:'furniture', code:'FN', name:'Tables & Seating', count:126, tint:Color(0xFFECEEE9), line:Color(0xFFDCE0D8), ink:Color(0xFF5D6B63)),
  Category(id:'lighting', code:'LT', name:'Lighting & FX', count:74, tint:Color(0xFFEFECE4), line:Color(0xFFE2DCCD), ink:Color(0xFFA07C2B)),
  Category(id:'audio', code:'AU', name:'Audio & Staging', count:39, tint:Color(0xFFE7ECEF), line:Color(0xFFD4DDE2), ink:Color(0xFF3A6B86)),
  Category(id:'decor', code:'DC', name:'Decor & Linens', count:91, tint:Color(0xFFEFE9EC), line:Color(0xFFE2D6DB), ink:Color(0xFF8A5168)),
  Category(id:'catering', code:'CT', name:'Catering & Bar', count:57, tint:Color(0xFFE9EEEC), line:Color(0xFFD6E0DB), ink:Color(0xFF2F7D63)),
];

const items = [
  Item(id:'marquee', cat:'tents', code:'TN', name:'Clearspan Marquee 6×12m', owner:'Summit Event Hire', ownerId:'summit', rating:4.9, reviews:213, price:240, deposit:600, distance:'2.4 mi', qty:3, loc:'Eastside Depot', pro:true, sa:Color(0xFFCFE0D5), sb:Color(0xFFDCEBE1), tags:['Delivery','Insured','Pro seller'], specs:[['Footprint','6m × 12m (72 m²)'],['Capacity','Seats 60 banquet'],['Walls','Solid + window panels'],['Setup','Crew install available']], desc:'Heavy-duty clearspan structure with no internal poles — ideal for wedding receptions and corporate marquees. Includes flooring rails and weighted feet.'),
  Item(id:'sailcloth', cat:'tents', code:'TN', name:'Sailcloth Peg & Pole Tent', owner:'Atelier Canvas Co.', ownerId:'atelier', rating:4.8, reviews:88, price:320, deposit:800, distance:'5.1 mi', qty:1, loc:'Harbor Yard', pro:true, sa:Color(0xFFD8E2DA), sb:Color(0xFFE6EFE8), tags:['Delivery','Insured'], specs:[['Footprint','9m × 15m'],['Capacity','Seats 90'],['Aesthetic','Translucent sailcloth'],['Lighting','Glows at dusk']], desc:'A romantic translucent sailcloth tent with sculpted peaks and wooden centre poles. The fabric glows beautifully when lit from within.'),
  Item(id:'chiavari', cat:'furniture', code:'FN', name:'Chiavari Chairs · Set of 20', owner:'Maison Seating', ownerId:'maison', rating:4.7, reviews:341, price:64, deposit:160, distance:'1.8 mi', qty:14, loc:'Midtown Store', pro:true, sa:Color(0xFFDFE1DB), sb:Color(0xFFEBEDE7), tags:['Delivery','Stackable'], specs:[['Quantity','20 per set'],['Finish','Gold / limewash'],['Seat pads','Ivory included'],['Stacking','Flat-pack trolley']], desc:'Classic gold Chiavari ballroom chairs with ivory seat pads. Supplied in protective stacks of 20 on a wheeled trolley.'),
  Item(id:'banquet', cat:'furniture', code:'FN', name:'Farmhouse Banquet Tables', owner:'Timber & Co.', ownerId:'timber', rating:4.8, reviews:127, price:38, deposit:90, distance:'3.6 mi', qty:22, loc:'West Workshop', pro:false, sa:Color(0xFFE0DED7), sb:Color(0xFFECEBE4), tags:['Solid oak'], specs:[['Length','2.4m trestle'],['Seats','8–10 per table'],['Top','Reclaimed oak'],['Folding','Yes']], desc:'Rustic reclaimed-oak banquet trestle tables with folding steel legs. Each seats up to ten guests.'),
  Item(id:'festoon', cat:'lighting', code:'LT', name:'Festoon Lighting Run · 50m', owner:'Lumen Rentals', ownerId:'lumen', rating:4.9, reviews:402, price:45, deposit:120, distance:'2.0 mi', qty:8, loc:'Eastside Depot', pro:true, sa:Color(0xFFE6DDC7), sb:Color(0xFFEFE9D8), tags:['Delivery','Weatherproof'], specs:[['Length','50m, 80 lamps'],['Bulb','Warm 2200K LED'],['Rating','IP44 outdoor'],['Dimmer','Included']], desc:'Warm-white weatherproof festoon strings on black cable. Includes a dimmer and spare lamps — the fastest way to make a space feel magic.'),
  Item(id:'uplight', cat:'lighting', code:'LT', name:'Uplighter Kit · 12 units', owner:'Lumen Rentals', ownerId:'lumen', rating:4.7, reviews:156, price:90, deposit:240, distance:'2.0 mi', qty:5, loc:'Eastside Depot', pro:true, sa:Color(0xFFE3DCC9), sb:Color(0xFFECE6D6), tags:['Delivery','App control'], specs:[['Units','12 LED PARs'],['Colour','RGBA, 16M'],['Control','Wireless DMX'],['Battery','10 hr runtime']], desc:'Battery-powered wireless uplighters controllable from your phone. Wash walls and marquee linings in any colour, no cabling required.'),
  Item(id:'pa', cat:'audio', code:'AU', name:'Line Array PA System', owner:'Resonance AV', ownerId:'resonance', rating:4.8, reviews:74, price:180, deposit:500, distance:'4.3 mi', qty:2, loc:'North Bay Unit', pro:true, sa:Color(0xFFD4DDE2), sb:Color(0xFFE3EAEE), tags:['Delivery','Engineer'], specs:[['Coverage','Up to 300 guests'],['Mixer','16-ch digital'],['Mics','2 wireless inc.'],['Power','Single 16A']], desc:'Compact line-array system with subs, digital mixer and wireless mics. Optional sound engineer for the evening.'),
  Item(id:'stage', cat:'audio', code:'AU', name:'Modular Stage Deck 6×4m', owner:'Riser Pro', ownerId:'riser', rating:4.6, reviews:53, price:150, deposit:400, distance:'6.0 mi', qty:1, loc:'South Depot', pro:false, sa:Color(0xFFD8DEE2), sb:Color(0xFFE6EBEE), tags:['Adjustable height'], specs:[['Size','6m × 4m'],['Height','200–600mm'],['Load','750 kg/m²'],['Surface','Anti-slip']], desc:'Aluminium-frame modular staging with adjustable legs, skirting and step unit. Rated for bands and head tables alike.'),
  Item(id:'linens', cat:'decor', code:'DC', name:'Linen Tablecloth Bundle', owner:'Maison Seating', ownerId:'maison', rating:4.7, reviews:198, price:52, deposit:80, distance:'1.8 mi', qty:30, loc:'Midtown Store', pro:true, sa:Color(0xFFE6DCE0), sb:Color(0xFFEFE7EA), tags:['Laundered','Delivery'], specs:[['Pieces','20 cloths + 20 runners'],['Fabric','Washed linen'],['Colours','Sand / sage / chalk'],['Size','Fits 2.4m tables']], desc:'Premium washed-linen cloths and runners, professionally laundered and pressed. Mix three muted colourways across your tables.'),
  Item(id:'arch', cat:'decor', code:'DC', name:'Dried Floral Arch', owner:'Bloom Atelier', ownerId:'bloom', rating:4.9, reviews:64, price:140, deposit:200, distance:'7.2 mi', qty:1, loc:'Garden Studio', pro:true, sa:Color(0xFFE7DBD0), sb:Color(0xFFF0E7DF), tags:['Handmade','Delivery'], specs:[['Span','2.2m arch'],['Style','Pampas + bleached'],['Frame','Steel, freestanding'],['Reusable','Restyled per hire']], desc:'A freestanding dried-flower ceremony arch in soft neutral tones. Restyled and refreshed by the florist before every booking.'),
  Item(id:'heater', cat:'catering', code:'CT', name:'Commercial Patio Heater ×4', owner:'Summit Event Hire', ownerId:'summit', rating:4.6, reviews:91, price:80, deposit:160, distance:'2.4 mi', qty:9, loc:'Eastside Depot', pro:true, sa:Color(0xFFD6E0DB), sb:Color(0xFFE5ECE8), tags:['Delivery','Gas inc.'], specs:[['Quantity','4 heaters'],['Output','13kW each'],['Fuel','Propane (inc.)'],['Coverage','~20 m² each']], desc:'Free-standing propane patio heaters with safety tilt cut-off. Gas bottles and weighted bases included.'),
  Item(id:'bar', cat:'catering', code:'CT', name:'Mobile Bar Unit', owner:'Pour House Hire', ownerId:'pour', rating:4.8, reviews:112, price:175, deposit:350, distance:'3.1 mi', qty:2, loc:'Trade Park', pro:true, sa:Color(0xFFD8E0DC), sb:Color(0xFFE6ECE9), tags:['Delivery','Sink + ice well'], specs:[['Size','3m frontage'],['Features','Twin sink, ice wells'],['Power','13A, LED lit'],['Back bar','Shelving inc.']], desc:'A timber-clad mobile bar with running-water sinks, ice wells and integrated lighting. Staff and glassware available as add-ons.'),
];

const reviews = [
  Review(author:'Priya M.', co:'Lustre Events', rating:5, date:'2 weeks ago', text:'Flawless. Delivered on time, spotless condition, and the crew helped us position everything. Booked again for August already.', helpful:24),
  Review(author:'Daniel O.', co:'Northwind Co.', rating:5, date:'1 month ago', text:'Exactly as listed. The clearspan handled a windy coastal site without issue. Communication through the app was instant.', helpful:18),
  Review(author:'Clara V.', co:'Freelance planner', rating:4, date:'1 month ago', text:'Great quality and well maintained. Knocked one star only because collection ran 30 mins late, but the owner kept me posted.', helpful:9),
  Review(author:'Marcus T.', co:'Bayside Weddings', rating:5, date:'2 months ago', text:'My go-to supplier now. The deposit hold released the next day and the damage cover gave my client real peace of mind.', helpful:31),
  Review(author:'Imogen R.', co:'The Social Table', rating:5, date:'3 months ago', text:'Premium kit, fair price. Photos do not do it justice — looked stunning under festoon lighting.', helpful:12),
  Review(author:'Theo S.', co:'Corporate AV', rating:4, date:'4 months ago', text:'Reliable and clean. Would love a slightly larger delivery window but otherwise excellent service.', helpful:7),
];

const chats = [
  Chat(id:'summit', name:'Summit Event Hire', item:'Clearspan Marquee 6×12m', last:'Perfect — the crew will arrive 9am Saturday.', time:'09:24', unread:0, online:true, msgs:[
    ChatMessage(from:'them', text:'Hi! Thanks for booking the 6×12m marquee. Is the site accessible for a 3.5t van?', time:'Yesterday'),
    ChatMessage(from:'me', text:'Yes, there\'s a gravel track right up to the lawn. Gate is 3m wide.', time:'Yesterday'),
    ChatMessage(from:'them', text:'Brilliant. We\'ll install Friday afternoon then so it\'s ready for your Saturday setup.', time:'08:58'),
    ChatMessage(from:'them', text:'Perfect — the crew will arrive 9am Saturday.', time:'09:24'),
  ]),
  Chat(id:'lumen', name:'Lumen Rentals', item:'Festoon Lighting Run · 50m', last:'No problem, I\'ll add the extra 20m.', time:'Mon', unread:2, online:false, msgs:[
    ChatMessage(from:'me', text:'Could I extend the festoon run to 70m total?', time:'Mon'),
    ChatMessage(from:'them', text:'No problem, I\'ll add the extra 20m.', time:'Mon'),
  ]),
  Chat(id:'pour', name:'Pour House Hire', item:'Mobile Bar Unit', last:'We can include 3 bar staff for the evening.', time:'Jun 14', unread:0, online:true, msgs:[
    ChatMessage(from:'them', text:'We can include 3 bar staff for the evening.', time:'Jun 14'),
  ]),
];

const history = [
  HistoryEntry(id:'h1', itemId:'marquee', code:'TN', name:'Clearspan Marquee 6×12m', owner:'Summit Event Hire', dates:'Jun 27 – Jun 29, 2026', status:'active', statusLabel:'Pickup Sat', total:'\$1,240', sa:Color(0xFFCFE0D5), sb:Color(0xFFDCEBE1)),
  HistoryEntry(id:'h2', itemId:'festoon', code:'LT', name:'Festoon Lighting Run · 50m', owner:'Lumen Rentals', dates:'Jul 11 – Jul 13, 2026', status:'upcoming', statusLabel:'Confirmed', total:'\$210', sa:Color(0xFFE6DDC7), sb:Color(0xFFEFE9D8)),
  HistoryEntry(id:'h3', itemId:'chiavari', code:'FN', name:'Chiavari Chairs · Set of 20', owner:'Maison Seating', dates:'May 3 – May 4, 2026', status:'completed', statusLabel:'Returned', total:'\$128', sa:Color(0xFFDFE1DB), sb:Color(0xFFEBEDE7)),
  HistoryEntry(id:'h4', itemId:'pa', code:'AU', name:'Line Array PA System', owner:'Resonance AV', dates:'Apr 18 – Apr 19, 2026', status:'completed', statusLabel:'Returned', total:'\$360', sa:Color(0xFFD4DDE2), sb:Color(0xFFE3EAEE)),
];

const pickupChecks = [
  ChecklistItem(key:'p_id', title:'Show booking QR & photo ID', desc:'Owner verifies your reservation'),
  ChecklistItem(key:'p_count', title:'Confirm item count & components', desc:'72 m² canopy, 4 walls, flooring rails'),
  ChecklistItem(key:'p_cond', title:'Inspect for existing damage', desc:'Note any marks before you leave'),
  ChecklistItem(key:'p_photo', title:'Capture pickup condition photos', desc:'4 angles recommended'),
  ChecklistItem(key:'p_deposit', title:'Confirm \$600 deposit hold', desc:'Refundable on undamaged return'),
];

const returnChecks = [
  ChecklistItem(key:'r_clean', title:'Clean & repack components', desc:'Remove debris, fold walls'),
  ChecklistItem(key:'r_count', title:'Recount against manifest', desc:'All 5 line items present'),
  ChecklistItem(key:'r_photo', title:'Capture return condition photos', desc:'Match the pickup angles'),
  ChecklistItem(key:'r_sign', title:'Owner sign-off on condition', desc:'Digital signature in app'),
  ChecklistItem(key:'r_release', title:'Deposit release confirmed', desc:'\$600 back within 1–2 days'),
];

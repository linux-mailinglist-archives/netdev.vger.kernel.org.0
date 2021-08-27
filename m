Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F4D3F9CA6
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 18:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhH0QkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 12:40:21 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:23108 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229675AbhH0QkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 12:40:20 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-119-AmHsJiYQNE60SSoh-YP6Hw-1; Fri, 27 Aug 2021 17:39:29 +0100
X-MC-Unique: AmHsJiYQNE60SSoh-YP6Hw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Fri, 27 Aug 2021 17:39:27 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Fri, 27 Aug 2021 17:39:27 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     David Laight <David.Laight@ACULAB.COM>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: IP routing sending local packet to gateway.
Thread-Topic: IP routing sending local packet to gateway.
Thread-Index: AdebRgbMhfPTX4NbSQqr56kVCuK30gAGAC7A
Date:   Fri, 27 Aug 2021 16:39:27 +0000
Message-ID: <adaaf38562be4c0ba3e8fe13b90f2178@AcuMS.aculab.com>
References: <15a53d9cc54d42dca565247363b5c205@AcuMS.aculab.com>
In-Reply-To: <15a53d9cc54d42dca565247363b5c205@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTGFpZ2h0DQo+IFNlbnQ6IDI3IEF1Z3VzdCAyMDIxIDE1OjEyDQo+IA0KPiBJ
J3ZlIGFuIG9kZCBJUCByb3V0aW5nIGlzc3VlLg0KPiBBIHBhY2tldCB0aGF0IHNob3VsZCBiZSBz
ZW50IG9uIHRoZSBsb2NhbCBzdWJuZXQgKHRvIGFuIEFSUGVkIGFkZHJlc3MpDQo+IGlzIGJlaW5n
IHNlbmQgdG8gdGhlIGRlZmF1bHQgZ2F0ZXdheSBpbnN0ZWFkLg0KDQpJJ3ZlIGRvbmUgc29tZSB0
ZXN0cyBvbiBhIGRpZmZlcmVudCBuZXR3b3JrIHdoZXJlIGl0IGFsbCBhcHBlYXJzIHRvIHdvcmsu
DQoNCkJ1dCBydW5uaW5nICd0Y3BkdW1wIC1wZW4nIHNob3dzIHRoYXQgYWxsIHRoZSBvdXRib3Vu
ZCBwYWNrZXRzIGZvciB0aGUNClRDUCBjb25uZWN0aW9ucyBhcmUgYmVpbmcgc2VudCB0byB0aGUg
ZGVmYXVsdCBnYXRld2F5Lg0KDQo1LjEwLjMwLCA1LjEwLjYxIGFuZCA1LjE0LjAtcmM3IGFsbCBi
ZWhhdmUgdGhlIHNhbWUgd2F5Lg0KDQpJZiBkbyBhIHBpbmcgKGluIGVpdGhlciBkaXJlY3Rpb24p
IEkgZ2V0IGFuIEFSUCB0YWJsZSBlbnRyeS4NCkJ1dCBUQ1AgY29ubmVjdGlvbnMgKGluIG9yIG91
dCkgYWx3YXlzIHVzZSB0aGUgZGVmYXVsdCBnYXRld2F5Lg0KDQpJJ20gbm93IGdldHRpbmcgbW9y
ZSBjb25mdXNlZC4NCkkgbm90aWNlZCB0aGF0IHRoZSAnZGVmYXVsdCByb3V0ZScgd2FzIG1pc3Np
bmcgdGhlICdtZXRyaWMgMTAwJyBiaXQuDQpUaGF0IG1pZ2h0IGdpdmUgdGhlIGJlaGF2aW91ciBJ
J20gc2VlaW5nIGlmIHRoZSBuZXRtYXNrIHdpZHRoIGlzIGlnbm9yZWQuDQoNCkJ1dCBpZiBJIGRl
bGV0ZSB0aGUgZGVmYXVsdCByb3V0ZSAobmVpdGhlciBuZXRzdGF0IC1yIG9yIGlwIHJvdXRlIHNo
b3cNCml0KSB0aGVuIHBhY2tldHMgYXJlIHN0aWxsIGJlaW5nIHNlbnQgdG8gdGhlIGRlbGV0ZWQg
Z2F0ZXdheS4NCklmIEkgZGVsZXRlIHRoZSBhcnAvbmVpZ2ggZW50cnkgZm9yIHRoZSBkZWxldGVk
IGRlZmF1bHQgZ2F0ZXdheSBhbg0Kb3V0d2FyZCBjb25uZWN0aW9uIHJlY3JlYXRlcyB0aGUgZW50
cnkgLSBsZWF2aW5nIHRoZSBvbmUgZm9yIHRoZSBhY3R1YWwNCmFkZHJlc3MgJ1NUQUxFJy4NCg0K
U29tZXRoaW5nIHZlcnkgb2RkIGlzIGdvaW5nIG9uLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJl
ZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXlu
ZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC132B0391
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgKLLK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:10:56 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:21322 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728076AbgKLLKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:10:37 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-10-SsfhdpSIMjO57IO_YfRPUg-1; Thu, 12 Nov 2020 11:10:30 +0000
X-MC-Unique: SsfhdpSIMjO57IO_YfRPUg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 12 Nov 2020 11:10:30 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 12 Nov 2020 11:10:30 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <eric.dumazet@gmail.com>,
        Kegl Rohit <keglrohit@gmail.com>,
        Fabio Estevam <festevam@gmail.com>
CC:     netdev <netdev@vger.kernel.org>
Subject: RE: net: fec: rx descriptor ring out of order
Thread-Topic: net: fec: rx descriptor ring out of order
Thread-Index: AQHWuOCJmdAQVIPIFkeWajz6wp3ZwanEVemw
Date:   Thu, 12 Nov 2020 11:10:30 +0000
Message-ID: <a3caa320811d4399808b6185dff79534@AcuMS.aculab.com>
References: <CAMeyCbh8vSCnr-9-odi0kg3E8BGCiETOL-jJ650qYQdsY0wxeA@mail.gmail.com>
 <CAMeyCbjuj2Q2riK2yzKXRfCa_mKToqe0uPXKxrjd6zJQWaXxog@mail.gmail.com>
 <CAOMZO5CYVDmCh-qxeKw0eOW6docQYxhZ5WA6ruxjcP+aYR6=LA@mail.gmail.com>
 <CAMeyCbhFfdONLEDYtqHxVZ59kBsH6vEaDBsvc5dWRinNY7RSgA@mail.gmail.com>
 <ba3b594f-bfdb-c8d6-ea1e-508040cf0414@gmail.com>
In-Reply-To: <ba3b594f-bfdb-c8d6-ea1e-508040cf0414@gmail.com>
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

RnJvbTogRXJpYyBEdW1hemV0DQo+IFNlbnQ6IDEyIE5vdmVtYmVyIDIwMjAgMTA6NDINCj4gDQo+
IE9uIDExLzEyLzIwIDc6NTIgQU0sIEtlZ2wgUm9oaXQgd3JvdGU6DQo+ID4gT24gV2VkLCBOb3Yg
MTEsIDIwMjAgYXQgMTE6MTggUE0gRmFiaW8gRXN0ZXZhbSA8ZmVzdGV2YW1AZ21haWwuY29tPiB3
cm90ZToNCj4gPj4NCj4gPj4gT24gV2VkLCBOb3YgMTEsIDIwMjAgYXQgMTE6MjcgQU0gS2VnbCBS
b2hpdCA8a2VnbHJvaGl0QGdtYWlsLmNvbT4gd3JvdGU6DQo+ID4+Pg0KPiA+Pj4gSGVsbG8hDQo+
ID4+Pg0KPiA+Pj4gV2UgYXJlIHVzaW5nIGEgaW14NnEgcGxhdGZvcm0uDQo+ID4+PiBUaGUgZmVj
IGludGVyZmFjZSBpcyB1c2VkIHRvIHJlY2VpdmUgYSBjb250aW51b3VzIHN0cmVhbSBvZiBjdXN0
b20gLw0KPiA+Pj4gcmF3IGV0aGVybmV0IHBhY2tldHMuIFRoZSBwYWNrZXQgc2l6ZSBpcyBmaXhl
ZCB+MTMyIGJ5dGVzIGFuZCB0aGV5IGdldA0KPiA+Pj4gc2VudCBldmVyeSAyNTDCtXMuDQo+ID4+
Pg0KPiA+Pj4gV2hpbGUgdGVzdGluZyBJIG9ic2VydmVkIHNwb250YW5lb3VzIHBhY2tldCBkZWxh
eXMgZnJvbSB0aW1lIHRvIHRpbWUuDQo+ID4+PiBBZnRlciBkaWdnaW5nIGRvd24gZGVlcGVyIEkg
dGhpbmsgdGhhdCB0aGUgZmVjIHBlcmlwaGVyYWwgZG9lcyBub3QNCj4gPj4+IHVwZGF0ZSB0aGUg
cnggZGVzY3JpcHRvciBzdGF0dXMgY29ycmVjdGx5Lg0KPiA+Pg0KPiA+PiBXaGF0IGlzIHRoZSBr
ZXJuZWwgdmVyc2lvbiB0aGF0IHlvdSBhcmUgdXNpbmc/DQo+ID4NCj4gPiBTYWRseSBzdHVjayBh
dCAzLjEwLjEwOC4NCg0KSWYgeW91IGJ1aWxkIGEgbmV3ZXIga2VybmVsIGl0IHNob3VsZCB3b3Jr
IHdpdGggeW91cg0KZXhpc3RpbmcgdXNlcnNwYWNlLg0KDQo+ID4gaHR0cHM6Ly9naXRodWIuY29t
L2dyZWdraC9saW51eC9ibG9iL3YzLjEwLjEwOC9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2Nh
bGUvZmVjX21haW4uYw0KPiA+IFRoZSByeCBxdWV1ZSBzdGF0dXMgaGFuZGxpbmcgZGlkIG5vdCBj
aGFuZ2UgbXVjaCBjb21wYXJlZCB0byA1LnguIE9ubHkNCj4gPiB0aGUgTkFQSSBoYW5kbGluZyAv
IGNsZWFyaW5nIElSUXMgd2FzIGNoYW5nZWQgbW9yZSB0aGFuIG9uY2UuDQo+ID4gSSBhbHNvIGJh
Y2twb3J0ZWQgdGhlIG5ld2VyIE5BUEkgaGFuZGxpbmcgc3R5bGUgLyBjbGVhcmluZyBpcnFzIG5v
dCBpbg0KPiA+IHRoZSBpcnEgaGFuZGxlciBidXQgaW4gbmFwaV9wb2xsKCkgPT4gc2FtZSBpc3N1
ZS4NCj4gPiBUaGUgaXNzdWUgaXMgcHJldHR5IHJhcmUgPT4gVG8gcmVwcm9kdWNlIGkgaGF2ZSB0
byByZWJvb3QgdGhlIHN5c3RlbQ0KPiA+IGV2ZXJ5IDMgbWluLiBTb21ldGltZXMgYWZ0ZXIgMX4y
bWluIG9uIHRoZSBmaXJzdCwgc29tZXRpbWVzIG9uIHRoZQ0KPiA+IH4xMHRoIHJlYm9vdCBpdCB3
aWxsIGhhcHBlbi4NCj4gPg0KPiANCj4gSXMgc2VlbXMgc29tZSBybWIoKSAmIHdtYigpIGFyZSBt
aXNzaW5nLg0KDQpUaGV5IGFyZSB1bmxpa2VseSB0byBtYWtlIGFueSBkaWZmZXJlbmNlIHNpbmNl
IHRoZSAnYmFkJw0Kcnggc3RhdHVzIHBlcnNpc3RzIGJldHdlZW4gY2FsbHMgdG8gdGhlIHJlY2Vp
dmUgZnVuY3Rpb24uDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUs
IEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJl
Z2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA4F4761D0
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 11:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfGZJXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 05:23:39 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:40872 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726193AbfGZJXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 05:23:39 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-213-_IbTtnJhNCekhz4rwLltKA-1; Fri, 26 Jul 2019 10:23:36 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 26 Jul 2019 10:23:35 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 26 Jul 2019 10:23:35 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jian-Hong Pan' <jian-hong@endlessm.com>
CC:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] rtw88: pci: Use general byte arrays as the elements of RX
 ring
Thread-Topic: [PATCH] rtw88: pci: Use general byte arrays as the elements of
 RX ring
Thread-Index: AQHVQsDFH4BG56wpwU66J+Fzxhx3XabbDGOQgAFRNgCAADuAcA==
Date:   Fri, 26 Jul 2019 09:23:35 +0000
Message-ID: <c2cdffd30923459e8773379fc2927e1d@AcuMS.aculab.com>
References: <20190725080925.6575-1-jian-hong@endlessm.com>
 <06d713fff7434dfb9ccab32c2e2112e2@AcuMS.aculab.com>
 <CAPpJ_ecAAw=1X=7+MOw-VVH0ZKBr6rcRub6JnEqgNbZ6Hxt=ag@mail.gmail.com>
In-Reply-To: <CAPpJ_ecAAw=1X=7+MOw-VVH0ZKBr6rcRub6JnEqgNbZ6Hxt=ag@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: _IbTtnJhNCekhz4rwLltKA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSmlhbi1Ib25nIFBhbiANCj4gU2VudDogMjYgSnVseSAyMDE5IDA3OjE4DQouLi4NCj4g
PiBXaGlsZSBhbGxvY2F0aW5nIGFsbCA1MTIgYnVmZmVycyBpbiBvbmUgYmxvY2sgKGp1c3Qgb3Zl
ciA0TUIpDQo+ID4gaXMgcHJvYmFibHkgbm90IGEgZ29vZCBpZGVhLCB5b3UgbWF5IG5lZWQgdG8g
YWxsb2NhdGVkIChhbmQgZG1hIG1hcCkNCj4gPiB0aGVuIGluIGdyb3Vwcy4NCj4gDQo+IFRoYW5r
cyBmb3IgcmV2aWV3aW5nLiAgQnV0IGdvdCBxdWVzdGlvbnMgaGVyZSB0byBkb3VibGUgY29uZmly
bSB0aGUgaWRlYS4NCj4gQWNjb3JkaW5nIHRvIG9yaWdpbmFsIGNvZGUsIGl0IGFsbG9jYXRlcyA1
MTIgc2ticyBmb3IgUlggcmluZyBhbmQgZG1hDQo+IG1hcHBpbmcgb25lIGJ5IG9uZS4gIFNvLCB0
aGUgbmV3IGNvZGUgYWxsb2NhdGVzIG1lbW9yeSBidWZmZXIgNTEyDQo+IHRpbWVzIHRvIGdldCA1
MTIgYnVmZmVyIGFycmF5cy4gIFdpbGwgdGhlIDUxMiBidWZmZXJzIGFycmF5cyBiZSBpbiBvbmUN
Cj4gYmxvY2s/ICBEbyB5b3UgbWVhbiBhZ2dyZWdhdGUgdGhlIGJ1ZmZlcnMgYXMgYSBzY2F0dGVy
bGlzdCBhbmQgdXNlDQo+IGRtYV9tYXBfc2c/DQoNCklmIHlvdSBtYWxsb2MgYSBidWZmZXIgb2Yg
c2l6ZSAoODE5MiszMikgdGhlIGFsbG9jYXRvciB3aWxsIGVpdGhlcg0Kcm91bmQgaXQgdXAgdG8g
YSB3aG9sZSBudW1iZXIgb2YgKG9mdGVuIDRrKSBwYWdlcyBvciB0byBhIHBvd2VyIG9mDQoyIG9m
IHBhZ2VzIC0gc28gZWl0aGVyIDEyayBvZiAxNmsuDQpJIHRoaW5rIHRoZSBMaW51eCBhbGxvY2F0
b3IgZG9lcyB0aGUgbGF0dGVyLg0KU29tZSBvZiB0aGUgYWxsb2NhdG9ycyBhbHNvICdzdGVhbCcg
YSBiaXQgZnJvbSB0aGUgZnJvbnQgb2YgdGhlIGJ1ZmZlcg0KZm9yICdyZWQgdGFwZScuDQoNCk9U
T0ggbWFsbG9jIHRoZSBzcGFjZSAxNSBidWZmZXJzIGFuZCB0aGUgYWxsb2NhdG9yIHdpbGwgcm91
bmQgdGhlDQoxNSooODE5MiArIDMyKSB1cCB0byAzMio0ayAtIGFuZCB5b3Ugd2FzdGUgdW5kZXIg
OGsgYWNyb3NzIGFsbCB0aGUNCmJ1ZmZlcnMuDQoNCllvdSB0aGVuIGRtYV9tYXAgdGhlIGxhcmdl
IGJ1ZmZlciBhbmQgc3BsaXQgaW50byB0aGUgYWN0dWFsIHJ4IGJ1ZmZlcnMuDQpSZXBlYXQgdW50
aWwgeW91J3ZlIGZpbGxlZCB0aGUgZW50aXJlIHJpbmcuDQpUaGUgb25seSBjb21wbGljYXRpb24g
aXMgcmVtZW1iZXJpbmcgdGhlIGJhc2UgYWRkcmVzcyAoYW5kIHNpemUpIGZvcg0KdGhlIGRtYV91
bm1hcCBhbmQgZnJlZS4NCkFsdGhvdWdoIHRoZXJlIGlzIHBsZW50eSBvZiBwYWRkaW5nIHRvIGV4
dGVuZCB0aGUgYnVmZmVyIHN0cnVjdHVyZQ0Kc2lnbmlmaWNhbnRseSB3aXRob3V0IHVzaW5nIG1v
cmUgbWVtb3J5Lg0KQWxsb2NhdGUgaW4gMTUncyBhbmQgeW91IChwcm9iYWJseSkgaGF2ZSA1MTIg
Ynl0ZXMgcGVyIGJ1ZmZlci4NCkFsbG9jYXRlIGluIDMxJ3MgYW5kIHlvdSBoYXZlIDI1NiBieXRl
cy4NCg0KVGhlIHByb2JsZW0gaXMgdGhhdCBsYXJnZXIgYWxsb2NhdGVzIGFyZSBtb3JlIGxpa2Vs
eSB0byBmYWlsDQooZXNwZWNpYWxseSBpZiB0aGUgc3lzdGVtIGhhcyBiZWVuIHJ1bm5pbmcgZm9y
IHNvbWUgdGltZSkuDQpTbyB5b3UgYWxtb3N0IGNlcnRhaW5seSB3YW50IHRvIGJlIGFibGUgdG8g
ZmFsbCBiYWNrIHRvIHNtYWxsZXINCmFsbG9jYXRlcyBldmVuIHRob3VnaCB0aGV5IHVzZSBtb3Jl
IG1lbW9yeS4NCg0KSSBhbHNvIHdvbmRlciBpZiB5b3UgYWN0dWFsbHkgbmVlZCA1MTIgOGsgcngg
YnVmZmVycyB0byBjb3Zlcg0KaW50ZXJydXB0IGxhdGVuY3k/DQpJJ3ZlIG5vdCBkb25lIGFueSBt
ZWFzdXJlbWVudHMgZm9yIDIwIHllYXJzIQ0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRy
ZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1L
MSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K


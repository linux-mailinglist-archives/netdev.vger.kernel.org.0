Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20DAE2D6B6B
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732389AbgLJXBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:01:42 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:36536 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731901AbgLJXAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 18:00:38 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-244-j0ChRN6fO0-QK_ictc5YEw-1; Thu, 10 Dec 2020 22:34:02 +0000
X-MC-Unique: j0ChRN6fO0-QK_ictc5YEw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 10 Dec 2020 22:34:02 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 10 Dec 2020 22:34:02 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Xie He' <xie.he.0141@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Martin Schiller" <ms@dev.tdt.de>
Subject: RE: [PATCH net-next] net: x25: Remove unimplemented X.25-over-LLC
 code stubs
Thread-Topic: [PATCH net-next] net: x25: Remove unimplemented X.25-over-LLC
 code stubs
Thread-Index: AQHWzdxRX1QgNEu/LUu372JTopy8S6nvRYJAgAAbHICAAKnREIAAFRSAgADJy6A=
Date:   Thu, 10 Dec 2020 22:34:02 +0000
Message-ID: <bd009efe08154dcd8f0ad2e893fb1bdc@AcuMS.aculab.com>
References: <20201209033346.83742-1-xie.he.0141@gmail.com>
 <801dc0320e484bf7a5048c0cddac12af@AcuMS.aculab.com>
 <CAJht_EMQFtR_-QH=QMHt9+cLcNO6LHBSy2fy=mgbic+=JUsR-Q@mail.gmail.com>
 <3e7fb08afd624399a7f689c2b507a01e@AcuMS.aculab.com>
 <CAJht_EMqO8cS3BSnqHA=ROqbkpum8JB_FjzRgPuW=up+e4bO1w@mail.gmail.com>
In-Reply-To: <CAJht_EMqO8cS3BSnqHA=ROqbkpum8JB_FjzRgPuW=up+e4bO1w@mail.gmail.com>
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

RnJvbTogWGllIEhlDQo+IFNlbnQ6IDEwIERlY2VtYmVyIDIwMjAgMTA6MTcNCj4gDQo+IE9uIFRo
dSwgRGVjIDEwLCAyMDIwIGF0IDE6MTQgQU0gRGF2aWQgTGFpZ2h0IDxEYXZpZC5MYWlnaHRAYWN1
bGFiLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiA+IFRvIG1lLCBMTEMxIGFuZCBMTEMyIGFyZSB0byBF
dGhlcm5ldCB3aGF0IFVEUCBhbmQgVENQIGFyZSB0byBJUA0KPiA+ID4gbmV0d29ya3MuIEkgdGhp
bmsgd2UgY2FuIHVzZSBMTEMxIGFuZCBMTEMyIHdoZXJldmVyIFVEUCBhbmQgVENQIGNhbiBiZQ0K
PiA+ID4gdXNlZCwgYXMgbG9uZyBhcyB3ZSBhcmUgaW4gdGhlIHNhbWUgTEFOIGFuZCBhcmUgd2ls
bGluZyB0byB1c2UgTUFDDQo+ID4gPiBhZGRyZXNzZXMgYXMgdGhlIGFkZHJlc3Nlcy4NCj4gPg0K
PiA+IEV4Y2VwdCB0aGF0IHlvdSBkb24ndCBoYXZlIGFueSB3aGVyZSBuZWFyIGVub3VnaCAncG9y
dHMnIHNvIHlvdSBuZWVkDQo+ID4gc29tZXRoaW5nIHRvIGRlbXVsdGlwbGV4IG1lc3NhZ2VzIHRv
IGRpZmZlcmVudCBhcHBsaWNhdGlvbnMuDQo+IA0KPiBZZXMsIExMQyBvbmx5IGhhcyAyNTYgInBv
cnRzIiBjb21wYXJlZCB0byBtb3JlIHRoYW4gNjAwMDAgZm9yIFVEUC9UQ1AuDQoNCkFuZCBJU08g
dHJhbnNwb3J0IHNlcGFyYXRlcyBvdXQgdGhlIGFkZHJlc3MgZnJvbSB0aGUgY29ubmVjdGlvbi1p
ZC4NClRoZSBUU0FQICh1c2VkIHRvIHNlbGVjdCB0aGUgbGlzdGVuaW5nIGFwcGxpY2F0aW9uKSBp
cyAzMiBieXRlcy4NCklmIHlvdSBydW4gdGhlIElTTyBOZXR3b3JrIGxheWVyICh3aGljaCBpc24n
dCBYLjI1IGxldmVsIDMpIG9uIGEgTEFODQp5b3UgaGF2ZSBhbiBhZGRpdGlvbmFsIDI0IGJ5dGUg
TlNBUC4NCg0KRm9yIFguMjUgbGV2ZWwgMyB3ZSByb3V0ZWQgY2FsbHMgdG8gYXBwbGljYXRpb25z
IHVzaW5nIGFueSBvZiAoSUlSQyk6DQotIGNhbGxlZCBudW1iZXIgc3ViLWFkZHJlc3MuDQotIENV
RyAoY2xvc2VkIHVzZXIgZ3JvdXAgbnVtYmVyKQ0KLSBTb21lIG90aGVyIEwzIHBhcmFtZXRlcnMg
SSBjYW4ndCByZW1lbWJlciA6LSkNCi0gVFNBUCBpZiB0cmFuc3BvcnQgbGF5ZXIgYWxzbyBpbiB1
c2UuDQpUaGUgb25seSB3YXkgdG8gcGFzcyB0aGF0IGRvd24gd2FzIGluIGEgVExWIGZvcm1hdC4N
CkZvcnR1bmF0ZWx5IHdlIHdlcmVuJ3QgZXZlbiB0cnlpbmcgdG8gdXNlIEJTRCBzdHlsZSBzb2Nr
ZXRzLg0KDQo+ID4gV2UgKElDTCkgYWx3YXlzIHJhbiBjbGFzcyA0IHRyYW5zcG9ydCAod2hpY2gg
ZG9lcyBlcnJvciByZWNvdmVyeSkNCj4gPiBkaXJlY3RseSBvdmVyIExMQzEgdXNpbmcgTUFDIGFk
ZHJlc3MgKGEgTlVMIGJ5dGUgZm9yIHRoZSBuZXR3b3JrIGxheWVyKS4NCj4gPiBUaGlzIHJlcXVp
cmVzIGEgYnJpZGdlZCBuZXR3b3JrIGFuZCBnbG9iYWxseSB1bmlxdWUgTUFDIGFkZHJlc3Nlcy4N
Cj4gPiBTZW5kaW5nIG91dCBhbiBMTEMgcmVmbGVjdCBwYWNrZXQgdG8gdGhlIGJyb2FkY2FzdCBN
QUMgYWRkcmVzcyB1c2VkIHRvDQo+ID4gZ2VuZXJhdGUgYSBjb3VwbGUgb2YgdGhvdXNhbmQgcmVz
cG9uc2VzIChtYW55IHdvdWxkIGdldCBkaXNjYXJkZWQNCj4gPiBiZWNhdXNlIHRoZSBicmlkZ2Vz
IGdvdCBvdmVybG9hZGVkKS4NCj4gDQo+IFdvdywgWW91IGhhdmUgYSByZWFsbHkgYmlnIExBTiEN
Cg0KSSB0aGluayBpdCAnb25seScgc3RyZXRjaGVkIGZyb20gTG9uZG9uIHRvIE1hbmNoZXN0ZXIu
DQpCdXQgaXQgbWlnaHQgaGF2ZSBnb25lIHVwIHRvIEVkaW5idXJnaC4NCkl0IHdhc24ndCBhIHNp
bmdsZSBjb2xsaXNpb24gZG9tYWluLCB0aGVyZSB3ZXJlIGJyaWRnZXMgZG9pbmcNCk1BQyBmaWx0
ZXJpbmcgLSBidXQgdGhleSBoYWQgdG8gYmUgb3BlbiB0byBicm9hZGNhc3QgdHJhZmZpYy4NCg0K
SXQgd2FzIGFjdHVhbGx5IGEgYmFkIElQIGJyb2FkY2FzdCBwYWNrZXQgdGhhdCB0b29rIG91dCBh
bGwgdGhlDQp1bml4IHNlcnZlcnMgaW4gc2V2ZXJhbCBjaXRpZXMhDQooWmVybyBsZW5ndGggaW4g
YSBJUCBvcHRpb25zIGZpZWxkIGNhdXNlZCB0aGUgY29kZSB0cnlpbmcgdG8gc2tpcA0KdGhlIG9w
dGlvbnMgdG8gZ2VuZXJhdGUgdGhlIElDTVAgZXJyb3IgdG8gc3Bpbi4NCkJ5IHRoZSB0aW1lIHRo
ZSBjb3Jwb3JhdGUgbmV0d29yayBndXlzIGNhbWUgc3Rvcm1pbmcgaW50byBvdXIgbGFiDQp3ZSdk
IGFscmVhZHkgZ290IGEgZHVtcCBmcm9tIG9uZSBzeXN0ZW0gYW5kIGhhZCBmb3VuZCB0aGUgYmFk
IHBhY2tldC4NCldlIG5ldmVyIGRpZCBmaW5kIG91dCB3aHkgaXQgZ290IHNlbnQgLSB0aGUgb3Jp
Z2luYXRpbmcgc3lzdGVtDQp3YXNuJ3QgZG9pbmcgYW55dGhpbmcgJ29kZCcuDQoNCglEYXZpZA0K
DQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFy
bSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAo
V2FsZXMpDQo=


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04CB02AAB00
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 13:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgKHMjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 07:39:09 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:34291 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726210AbgKHMjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 07:39:09 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-23-cvzoPkr0P8OQXUzDMaoxCg-1; Sun, 08 Nov 2020 12:39:04 +0000
X-MC-Unique: cvzoPkr0P8OQXUzDMaoxCg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sun, 8 Nov 2020 12:39:04 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sun, 8 Nov 2020 12:39:04 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Andrew Lunn' <andrew@lunn.ch>, Joe Perches <joe@perches.com>
CC:     Alex Shi <alex.shi@linux.alibaba.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "Vladimir Oltean" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net/dsa: remove unused macros to tame gcc warning
Thread-Topic: [PATCH] net/dsa: remove unused macros to tame gcc warning
Thread-Index: AQHWtVXzDoDYS6gyQUa+zdC/SmUjzqm+K9hg
Date:   Sun, 8 Nov 2020 12:39:03 +0000
Message-ID: <e0a266295d4e4e9b96546f99b2ebc3a5@AcuMS.aculab.com>
References: <1604641050-6004-1-git-send-email-alex.shi@linux.alibaba.com>
 <20201106141820.GP933237@lunn.ch>
 <24690741-cc10-eec1-33c6-7960c8b7fac6@gmail.com>
 <b3274bdb-5680-0c24-9800-8c025bfa119a@linux.alibaba.com>
 <6ed68a7898c5505d3106223b7ad47950a0c79dc3.camel@perches.com>
 <20201107223301.GY933237@lunn.ch>
In-Reply-To: <20201107223301.GY933237@lunn.ch>
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

RnJvbTogQW5kcmV3IEx1bm4NCj4gU2VudDogMDcgTm92ZW1iZXIgMjAyMCAyMjozMw0KPiANCj4g
T24gU2F0LCBOb3YgMDcsIDIwMjAgYXQgMDk6Mzk6NDJBTSAtMDgwMCwgSm9lIFBlcmNoZXMgd3Jv
dGU6DQo+ID4gT24gU2F0LCAyMDIwLTExLTA3IGF0IDIwOjU0ICswODAwLCBBbGV4IFNoaSB3cm90
ZToNCj4gPiA+IOWcqCAyMDIwLzExLzcg5LiK5Y2IMTI6MzksIEZsb3JpYW4gRmFpbmVsbGkg5YaZ
6YGTOg0KPiA+ID4gPiA+IEl0IGlzIGdvb2QgdG8gcmVtZW1iZXIgdGhhdCB0aGVyZSBhcmUgbXVs
dGlwbGUgcmVhZGVycyBvZiBzb3VyY2UNCj4gPiA+ID4gPiBmaWxlcy4gVGhlcmUgaXMgdGhlIGNv
bXBpbGVyIHdoaWNoIGdlbmVyYXRlcyBjb2RlIGZyb20gaXQsIGFuZCB0aGVyZQ0KPiA+ID4gPiA+
IGlzIHRoZSBodW1hbiB0cnlpbmcgdG8gdW5kZXJzdGFuZCB3aGF0IGlzIGdvaW5nIG9uLCB3aGF0
IHRoZSBoYXJkd2FyZQ0KPiA+ID4gPiA+IGNhbiBkbywgaG93IHdlIGNvdWxkIG1heWJlIGV4dGVu
ZCB0aGUgY29kZSBpbiB0aGUgZnV0dXJlIHRvIG1ha2UgdXNlDQo+ID4gPiA+ID4gb2YgYml0cyBh
cmUgY3VycmVudGx5IGRvbid0LCBldGMuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBUaGUgY29tcGls
ZXIgaGFzIG5vIHVzZSBvZiB0aGVzZSBtYWNyb3MsIGF0IHRoZSBtb21lbnQuIEJ1dCBpIGFzIGEN
Cj4gPiA+ID4gPiBodW1hbiBkby4gSXQgaXMgdmFsdWFibGUgZG9jdW1lbnRhdGlvbiwgZ2l2ZW4g
dGhhdCB0aGVyZSBpcyBubyBvcGVuDQo+ID4gPiA+ID4gZGF0YXNoZWV0IGZvciB0aGlzIGhhcmR3
YXJlLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gSSB3b3VsZCBzYXkgdGhlc2Ugd2FybmluZ3MgYXJl
IGJvZ3VzLCBhbmQgdGhlIGNvZGUgc2hvdWxkIGJlIGxlZnQNCj4gPiA+ID4gPiBhbG9uZS4NCj4g
PiA+ID4gQWdyZWVkLCB0aGVzZSBkZWZpbml0aW9ucyBhcmUgaW50ZW5kZWQgdG8gZG9jdW1lbnQg
d2hhdCB0aGUgaGFyZHdhcmUNCj4gPiA+ID4gZG9lcy4gVGhlc2Ugd2FybmluZ3MgYXJlIGdldHRp
bmcgdG9vIGZhci4NCj4gPiA+DQo+ID4gPiBUaGFua3MgZm9yIGFsbCBjb21tZW50cyEgSSBhZ3Jl
ZSB0aGVzZSBpbmZvIGFyZSBtdWNoIG1lYW5pbmdmdWwuDQo+ID4gPiBJcyB0aGVyZSBvdGhlciB3
YXkgdG8gdGFtZSB0aGUgZ2NjIHdhcm5pbmc/IGxpa2UgcHV0IHRoZW0gaW50byBhIC5oIGZpbGUN
Cj4gPiA+IG9yIGNvdmVyZWQgYnkgY29tbWVudHM/DQo+ID4NCj4gPiBEb2VzIF9hbnlfIHZlcnNp
b24gb2YgZ2NjIGhhdmUgdGhpcyB3YXJuaW5nIG9uIGJ5IGRlZmF1bHQ/DQo+ID4NCj4gPiBJIHN0
aWxsIHRoaW5rIG15IHByb3Bvc2FsIG9mIG1vdmluZyB0aGUgd2FybmluZyBmcm9tIFc9MiB0byBX
PTMNCj4gPiBxdWl0ZSByZWFzb25hYmxlLg0KPiA+DQo+ID4gQW5vdGhlciBwb3NzaWJpbGl0eSBp
cyB0byB0dXJuIHRoZSB3YXJuaW5nIG9mZiBhbHRvZ2V0aGVyLg0KPiANCj4gTGV0cyB0ZXJuIHRo
ZSBxdWVzdGlvbiBhcm91bmQgZmlyc3QuIEhvdyBtYW55IHJlYWwgYnVncyBoYXZlIHlvdSBmb3Vu
ZA0KPiB3aXRoIHRoaXMgd2FybmluZz8gUGxhY2VzIHdoZXJlIHRoZSAjZGVmaW5lIHNob3VsZCBv
ZiBiZWVuIHVzZWQsIGJ1dA0KPiB3YXMgbm90PyBUaGVuIHdlIGNhbiBnZXQgYW4gaWRlYSBvZiB0
aGUgdmFsdWUgb2YgdGhpcyB3YXJuaW5nLiBNeQ0KPiBndWVzcyB3b3VsZCBiZSwgaXRzIHZhbHVl
IGlzIH4gMCBmb3IgdGhlIGtlcm5lbC4gSWYgc28sIHdlIHNob3VsZCBqdXN0DQo+IHR1cm4gaXQg
b2ZmLg0KDQpTb21ldGltZXMgdGhlcmUgYXJlIGRlZmluZXMgZm9yIDAsIDEgYW5kIDIgKGVudW1l
cmF0aW9uIG9yIGJpdG1hcCkNCmFuZCB0aGUgb25lIGZvciAwIGlzIG5ldmVyIHVzZWQuDQpSYXRo
ZXIgdGhhbiBkZWxldGUgdGhlIGRlZmluZSBmb3IgMCAod2hpY2ggaGFzIGJlZW4gcHJvcG9zZWQg
YXQNCmxlYXN0IG9uY2UgaW4gdGhpcyBzZXJpZXMpIHRoZSAnZml4JyB3b3VsZCBiZSB0byBmaW5k
IHRoZQ0KaW5pdGlhbGlzYXRpb24gYW5kIHJlcGxhY2UgdGhlIGxpdGVyYWwgMCB3aXRoIHRoZSBk
ZWZpbmUuDQpPVE9IIGl0IGlzIHByb2JhYmx5IGltcGxpY2l0IGZyb20gYSBtZW1zZXQoKS4NCg0K
RXZlbiBpZiBuZXZlciBhY3R1YWxseSB1c2VkIHRoZSBkZWZpbmUgZm9yIDAgaGVscHMgdGhlDQpo
dW1hbiByZWFkaW5nIHRoZSBjb2RlLg0KDQpUaGUgc2FtZSBpcyB0cnVlIHdoZW4gdGhlcmUgYXJl
IGRlZmluZXMgZm9yIGhhcmR3YXJlIHJlZ2lzdGVyIGJpdHMuDQpJdCBpcyB1c2VmdWwgdG8ga25v
dyB3aGF0IHRoZXkgYWxsIG1lYW4gLSBldmVuIGlmIHNvbWUgYXJlbid0IHVzZWQuDQoNCglEYXZp
ZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQg
RmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4
NiAoV2FsZXMpDQo=


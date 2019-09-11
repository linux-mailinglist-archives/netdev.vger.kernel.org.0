Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7769AF871
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 11:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbfIKJEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 05:04:01 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:25828 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726857AbfIKJEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 05:04:01 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-115-kuVjJ9ezPgu4KB7gzrPISg-1; Wed, 11 Sep 2019 10:03:57 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 11 Sep 2019 10:03:57 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 11 Sep 2019 10:03:57 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Xin Long' <lucien.xin@gmail.com>
CC:     network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct
 sctp_paddrthlds
Thread-Topic: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct
 sctp_paddrthlds
Thread-Index: AQHVZuRCrtt5derbnkaX0GdcwfdxAKck5i9wgAE3h4CAABM4AA==
Date:   Wed, 11 Sep 2019 09:03:57 +0000
Message-ID: <1e5c3163e6c649b09137eeb62d193d87@AcuMS.aculab.com>
References: <cover.1568015756.git.lucien.xin@gmail.com>
 <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
 <9fc7ca1598e641cda3914840a4416aab@AcuMS.aculab.com>
 <CADvbK_d_Emw0K2Uq4P9OanRBr52tNjMsAOiJNi0TGsuWt6+81A@mail.gmail.com>
In-Reply-To: <CADvbK_d_Emw0K2Uq4P9OanRBr52tNjMsAOiJNi0TGsuWt6+81A@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: kuVjJ9ezPgu4KB7gzrPISg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWGluIExvbmcgW21haWx0bzpsdWNpZW4ueGluQGdtYWlsLmNvbV0NCj4gU2VudDogMTEg
U2VwdGVtYmVyIDIwMTkgMDk6NTINCj4gT24gVHVlLCBTZXAgMTAsIDIwMTkgYXQgOToxOSBQTSBE
YXZpZCBMYWlnaHQgPERhdmlkLkxhaWdodEBhY3VsYWIuY29tPiB3cm90ZToNCj4gPg0KPiA+IEZy
b206IFhpbiBMb25nDQo+ID4gPiBTZW50OiAwOSBTZXB0ZW1iZXIgMjAxOSAwODo1Nw0KPiA+ID4g
U2VjdGlvbiA3LjIgb2YgcmZjNzgyOTogIlBlZXIgQWRkcmVzcyBUaHJlc2hvbGRzIChTQ1RQX1BF
RVJfQUREUl9USExEUykNCj4gPiA+IFNvY2tldCBPcHRpb24iIGV4dGVuZHMgJ3N0cnVjdCBzY3Rw
X3BhZGRydGhsZHMnIHdpdGggJ3NwdF9wYXRoY3B0aGxkJw0KPiA+ID4gYWRkZWQgdG8gYWxsb3cg
YSB1c2VyIHRvIGNoYW5nZSBwc19yZXRyYW5zIHBlciBzb2NrL2Fzb2MvdHJhbnNwb3J0LCBhcw0K
PiA+ID4gb3RoZXIgMiBwYWRkcnRobGRzOiBwZl9yZXRyYW5zLCBwYXRobWF4cnh0Lg0KPiA+ID4N
Cj4gPiA+IE5vdGUgdGhhdCBwc19yZXRyYW5zIGlzIG5vdCBhbGxvd2VkIHRvIGJlIGdyZWF0ZXIg
dGhhbiBwZl9yZXRyYW5zLg0KPiA+ID4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFhpbiBMb25nIDxs
dWNpZW4ueGluQGdtYWlsLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gIGluY2x1ZGUvdWFwaS9saW51
eC9zY3RwLmggfCAgMSArDQo+ID4gPiAgbmV0L3NjdHAvc29ja2V0LmMgICAgICAgICB8IDEwICsr
KysrKysrKysNCj4gPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKykNCj4gPiA+
DQo+ID4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L3NjdHAuaCBiL2luY2x1ZGUv
dWFwaS9saW51eC9zY3RwLmgNCj4gPiA+IGluZGV4IGExNWNjMjguLmRmZDgxZTEgMTAwNjQ0DQo+
ID4gPiAtLS0gYS9pbmNsdWRlL3VhcGkvbGludXgvc2N0cC5oDQo+ID4gPiArKysgYi9pbmNsdWRl
L3VhcGkvbGludXgvc2N0cC5oDQo+ID4gPiBAQCAtMTA2OSw2ICsxMDY5LDcgQEAgc3RydWN0IHNj
dHBfcGFkZHJ0aGxkcyB7DQo+ID4gPiAgICAgICBzdHJ1Y3Qgc29ja2FkZHJfc3RvcmFnZSBzcHRf
YWRkcmVzczsNCj4gPiA+ICAgICAgIF9fdTE2IHNwdF9wYXRobWF4cnh0Ow0KPiA+ID4gICAgICAg
X191MTYgc3B0X3BhdGhwZnRobGQ7DQo+ID4gPiArICAgICBfX3UxNiBzcHRfcGF0aGNwdGhsZDsN
Cj4gPiA+ICB9Ow0KPiA+ID4NCj4gPiA+ICAvKg0KPiA+ID4gZGlmZiAtLWdpdCBhL25ldC9zY3Rw
L3NvY2tldC5jIGIvbmV0L3NjdHAvc29ja2V0LmMNCj4gPiA+IGluZGV4IDVlMjA5OGIuLjViOTc3
NGQgMTAwNjQ0DQo+ID4gPiAtLS0gYS9uZXQvc2N0cC9zb2NrZXQuYw0KPiA+ID4gKysrIGIvbmV0
L3NjdHAvc29ja2V0LmMNCj4gPiA+IEBAIC0zOTU0LDYgKzM5NTQsOSBAQCBzdGF0aWMgaW50IHNj
dHBfc2V0c29ja29wdF9wYWRkcl90aHJlc2hvbGRzKHN0cnVjdCBzb2NrICpzaywNCj4gPg0KPiA+
IFRoaXMgY29kZSBkb2VzOg0KPiA+ICAgICAgICAgaWYgKG9wdGxlbiA8IHNpemVvZihzdHJ1Y3Qg
c2N0cF9wYWRkcnRobGRzKSkNCj4gPiAgICAgICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+
IGhlcmUgd2lsbCBiZWNvbWU6DQo+IA0KPiAgICAgICAgIGlmIChvcHRsZW4gPj0gc2l6ZW9mKHN0
cnVjdCBzY3RwX3BhZGRydGhsZHMpKSB7DQo+ICAgICAgICAgICAgICAgICBvcHRsZW4gPSBzaXpl
b2Yoc3RydWN0IHNjdHBfcGFkZHJ0aGxkcyk7DQo+ICAgICAgICAgfSBlbHNlIGlmIChvcHRsZW4g
Pj0gQUxJR04ob2Zmc2V0b2Yoc3RydWN0IHNjdHBfcGFkZHJ0aGxkcywNCj4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzcHRfcGF0aGNwdGhsZCksIDQpKQ0KPiAg
ICAgICAgICAgICAgICAgb3B0bGVuID0gQUxJR04ob2Zmc2V0b2Yoc3RydWN0IHNjdHBfcGFkZHJ0
aGxkcywNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNwdF9wYXRo
Y3B0aGxkKSwgNCk7DQo+ICAgICAgICAgICAgICAgICB2YWwuc3B0X3BhdGhjcHRobGQgPSAweGZm
ZmY7DQo+ICAgICAgICAgZWxzZSB7DQo+ICAgICAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsN
Cj4gICAgICAgICB9DQoNCkhtbW0uLi4NCklmIHRoZSBrZXJuZWwgaGFzIHRvIGRlZmF1bHQgJ3Zh
bC5zcHRfcGF0aGNwdGhsZCA9IDB4ZmZmZicNCnRoZW4gcmVjb21waWxpbmcgYW4gZXhpc3Rpbmcg
YXBwbGljYXRpb24gd2l0aCB0aGUgbmV3IHVhcGkNCmhlYWRlciBpcyBnb2luZyB0byBsZWFkIHRv
IHZlcnkgdW5leHBlY3RlZCBiZWhhdmlvdXIuDQoNClRoZSBiZXN0IHlvdSBjYW4gaG9wZSBmb3Ig
aXMgdGhhdCB0aGUgYXBwbGljYXRpb24gbWVtc2V0IHRoZQ0Kc3RydWN0dXJlIHRvIHplcm8uDQpC
dXQgbW9yZSBsaWtlbHkgaXQgaXMgJ3JhbmRvbScgb24tc3RhY2sgZGF0YS4NCg0KCURhdmlkDQoN
Ci0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJt
LCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChX
YWxlcykNCg==


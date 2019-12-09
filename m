Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E279116B2A
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 11:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfLIKhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 05:37:31 -0500
Received: from mx21.baidu.com ([220.181.3.85]:36655 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727188AbfLIKhb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 05:37:31 -0500
Received: from BC-Mail-Ex31.internal.baidu.com (unknown [172.31.51.25])
        by Forcepoint Email with ESMTPS id DDF97787A00C;
        Mon,  9 Dec 2019 18:37:24 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex31.internal.baidu.com (172.31.51.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Mon, 9 Dec 2019 18:37:25 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Mon, 9 Dec 2019 18:37:25 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     Yunsheng Lin <linyunsheng@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>
Subject: =?gb2312?B?tPC4tDogtPC4tDogW1BBVENIXVt2Ml0gcGFnZV9wb29sOiBoYW5kbGUgcGFn?=
 =?gb2312?B?ZSByZWN5Y2xlIGZvciBOVU1BX05PX05PREUgY29uZGl0aW9u?=
Thread-Topic: =?gb2312?B?tPC4tDogW1BBVENIXVt2Ml0gcGFnZV9wb29sOiBoYW5kbGUgcGFnZSByZWN5?=
 =?gb2312?B?Y2xlIGZvciBOVU1BX05PX05PREUgY29uZGl0aW9u?=
Thread-Index: AQHVrBgioGDhH/MP9UuNcNvu7zNf3aeuC1gAgAJ3DgCAAKla4P//3HgAgACXhVA=
Date:   Mon, 9 Dec 2019 10:37:25 +0000
Message-ID: <34489f45039c428e8afea27ae7501a83@baidu.com>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
 <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
 <e724cb64-776d-176e-f55b-3c328d7c5298@huawei.com>
 <96bc5e8351a54adc8f00c18a61e2555d@baidu.com>
 <20191209093014.GA25360@apalos.home>
In-Reply-To: <20191209093014.GA25360@apalos.home>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.19]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex31_2019-12-09 18:37:25:936
x-baidu-bdmsfe-viruscheck: BC-Mail-Ex31_GRAY_Inside_WithoutAtta_2019-12-09
 18:37:25:905
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS3Tyrz+1K28/i0tLS0tDQo+ILeivP7IyzogSWxpYXMgQXBhbG9kaW1hcyBbbWFp
bHRvOmlsaWFzLmFwYWxvZGltYXNAbGluYXJvLm9yZ10NCj4gt6LLzcqxvOQ6IDIwMTnE6jEy1MI5
yNUgMTc6MzANCj4gytW8/sjLOiBMaSxSb25ncWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQo+
ILOty806IFl1bnNoZW5nIExpbiA8bGlueXVuc2hlbmdAaHVhd2VpLmNvbT47IFNhZWVkIE1haGFt
ZWVkDQo+IDxzYWVlZG1AbWVsbGFub3guY29tPjsgam9uYXRoYW4ubGVtb25AZ21haWwuY29tOw0K
PiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBicm91ZXJAcmVkaGF0LmNvbTsgaXZhbi5raG9yb256
aHVrQGxpbmFyby5vcmc7DQo+IGdyeWdvcmlpLnN0cmFzaGtvQHRpLmNvbQ0KPiDW98ziOiBSZTog
tPC4tDogW1BBVENIXVt2Ml0gcGFnZV9wb29sOiBoYW5kbGUgcGFnZSByZWN5Y2xlIGZvcg0KPiBO
VU1BX05PX05PREUgY29uZGl0aW9uDQo+IA0KPiBPbiBNb24sIERlYyAwOSwgMjAxOSBhdCAwMzo0
Nzo1MEFNICswMDAwLCBMaSxSb25ncWluZyB3cm90ZToNCj4gPiA+ID4NCj4gWy4uLl0NCj4gPiA+
ID4gQ2MnZWQgSmVzcGVyLCBJbGlhcyAmIEpvbmF0aGFuLg0KPiA+ID4gPg0KPiA+ID4gPiBJIGRv
bid0IHRoaW5rIGl0IGlzIGNvcnJlY3QgdG8gY2hlY2sgdGhhdCB0aGUgcGFnZSBuaWQgaXMgc2Ft
ZSBhcw0KPiA+ID4gPiBudW1hX21lbV9pZCgpIGlmIHBvb2wgaXMgTlVNQV9OT19OT0RFLiBJbiBz
dWNoIGNhc2Ugd2Ugc2hvdWxkDQo+ID4gPiA+IGFsbG93IGFsbCBwYWdlcyB0byByZWN5Y2xlLCBi
ZWNhdXNlIHlvdSBjYW4ndCBhc3N1bWUgd2hlcmUgcGFnZXMNCj4gPiA+ID4gYXJlIGFsbG9jYXRl
ZCBmcm9tIGFuZCB3aGVyZSB0aGV5IGFyZSBiZWluZyBoYW5kbGVkLg0KPiA+ID4gPg0KPiA+ID4g
PiBJIHN1Z2dlc3QgdGhlIGZvbGxvd2luZzoNCj4gPiA+ID4NCj4gPiA+ID4gcmV0dXJuICFwYWdl
X3BmbWVtYWxsb2MoKSAmJg0KPiA+ID4gPiAoIHBhZ2VfdG9fbmlkKHBhZ2UpID09IHBvb2wtPnAu
bmlkIHx8IHBvb2wtPnAubmlkID09IE5VTUFfTk9fTk9ERQ0KPiA+ID4gPiApOw0KPiA+ID4gPg0K
PiA+ID4gPiAxKSBuZXZlciByZWN5Y2xlIGVtZXJnZW5jeSBwYWdlcywgcmVnYXJkbGVzcyBvZiBw
b29sIG5pZC4NCj4gPiA+ID4gMikgYWx3YXlzIHJlY3ljbGUgaWYgcG9vbCBpcyBOVU1BX05PX05P
REUuDQo+ID4gPg0KPiA+ID4gQXMgSSBjYW4gc2VlLCBiZWxvdyBhcmUgdGhlIGNhc2VzIHRoYXQg
dGhlIHBvb2wtPnAubmlkIGNvdWxkIGJlDQo+ID4gPiBOVU1BX05PX05PREU6DQo+ID4gPg0KPiA+
ID4gMS4ga2VybmVsIGJ1aWx0IHdpdGggdGhlIENPTkZJR19OVU1BIGJlaW5nIG9mZi4NCj4gPiA+
DQo+ID4gPiAyLiBrZXJuZWwgYnVpbHQgd2l0aCB0aGUgQ09ORklHX05VTUEgYmVpbmcgb24sIGJ1
dCBGVy9CSU9TIGRvc2Ugbm90DQo+IHByb3ZpZGUNCj4gPiA+ICAgIGEgdmFsaWQgbm9kZSBpZCB0
aHJvdWdoIEFDUEkvRFQsIGFuZCBpdCBoYXMgdGhlIGJlbG93IGNhc2VzOg0KPiA+ID4NCj4gPiA+
ICAgIGEpLiB0aGUgaGFyZHdhcmUgaXRzZWxmIGlzIHNpbmdsZSBudW1hIG5vZGUgc3lzdGVtLCBz
byBtYXliZSBpdCBpcyB2YWxpZA0KPiA+ID4gICAgICAgIHRvIG5vdCBwcm92aWRlIGEgdmFsaWQg
bm9kZSBmb3IgdGhlIGRldmljZS4NCj4gPiA+ICAgIGIpLiB0aGUgaGFyZHdhcmUgaXRzZWxmIGlz
IG11bHRpIG51bWEgbm9kZXMgc3lzdGVtLCBhbmQgdGhlIEZXL0JJT1MgaXMNCj4gPiA+ICAgICAg
ICBicm9rZW4gdGhhdCBpdCBkb2VzIG5vdCBwcm92aWRlIGEgdmFsaWQgb25lLg0KPiA+ID4NCj4g
PiA+IDMuIGtlcm5lbCBidWlsdCB3aXRoIHRoZSBDT05GSUdfTlVNQSBiZWluZyBvbiwgYW5kIEZX
L0JJT1MgZG9zZSBwcm92aWRlDQo+IGENCj4gPiA+ICAgIHZhbGlkIG5vZGUgaWQgdGhyb3VnaCBB
Q1BJL0RULCBidXQgdGhlIGRyaXZlciBkb2VzIG5vdCBwYXNzIHRoZSB2YWxpZA0KPiA+ID4gICAg
bm9kZSBpZCB3aGVuIGNhbGxpbmcgcGFnZV9wb29sX2luaXQoKS4NCj4gPiA+DQo+ID4gPiBJIGFt
IG5vdCBzdXJlIHdoaWNoIGNhc2UgdGhpcyBwYXRjaCBpcyB0cnlpbmcgdG8gZml4LCBtYXliZSBS
b25ncWluZw0KPiA+ID4gY2FuIGhlbHAgdG8gY2xhcmlmeS4NCj4gPiA+DQo+ID4gPiBGb3IgY2Fz
ZSAxIGFuZCBjYXNlIDIgKGEpLCBJIHN1cHBvc2UgY2hlY2tpbmcgcG9vbC0+cC5uaWQgYmVpbmcN
Cj4gPiA+IE5VTUFfTk9fTk9ERSBpcyBlbm91Z2guDQo+ID4gPg0KPiA+ID4gRm9yIGNhc2UgMiAo
YiksIFRoZXJlIG1heSBiZSBhcmd1bWVudCB0aGF0IGl0IHNob3VsZCBiZSBmaXhlZCBpbiB0aGUN
Cj4gPiA+IEJJT1MvRlcsIEJ1dCBpdCBhbHNvIGNhbiBiZSBhcmd1ZWQgdGhhdCB0aGUgbnVtYV9t
ZW1faWQoKSBjaGVja2luZw0KPiA+ID4gaGFzIGJlZW4gZG9uZSBpbiB0aGUgZHJpdmVyIHRoYXQg
aGFzIG5vdCB1c2luZyBwYWdlIHBvb2wgeWV0IHdoZW4NCj4gPiA+IGRlY2lkaW5nIHdoZXRoZXIg
dG8gZG8gcmVjeWNsaW5nLCBzZWUgWzFdLiBJZiBJIHVuZGVyc3RhbmRpbmcNCj4gPiA+IGNvcnJl
Y3RseSwgcmVjeWNsaW5nIGlzIG5vcm1hbGx5IGRvbmUgYXQgdGhlIE5BUEkgcG9vbGluZywgd2hp
Y2ggaGFzDQo+ID4gPiB0aGUgc2FtZSBhZmZpbml0eSBhcyB0aGUgcnggaW50ZXJydXB0LCBhbmQg
cnggaW50ZXJydXB0IGlzIG5vdA0KPiA+ID4gY2hhbmdlZCB2ZXJ5IG9mdGVuLiBJZiBpdCBkb2Vz
IGNoYW5nZSB0byBkaWZmZXJlbnQgbWVtb3J5IG5vZGUsIG1heWJlIGl0DQo+IG1ha2VzIHNlbnNl
IG5vdCB0byByZWN5Y2xlIHRoZSBvbGQgcGFnZSBiZWxvbmdzIHRvIG9sZCBub2RlPw0KPiA+ID4N
Cj4gPiA+DQo+ID4gPiBGb3IgY2FzZSAzLCBJIGFtIG5vdCBzdXJlIGlmIGFueSBkcml2ZXIgaXMg
ZG9pbmcgdGhhdCwgYW5kIGlmIHRoZQ0KPiA+ID4gcGFnZSBwb29sIEFQSSBldmVuIGFsbG93IHRo
YXQ/DQo+ID4gPg0KPiA+DQo+ID4gSSB0aGluayBwb29sX3BhZ2VfcmV1c2FibGUgc2hvdWxkIHN1
cHBvcnQgTlVNQV9OT19OT0RFIG5vIG1hdHRlcg0KPiB3aGljaA0KPiA+IGNhc2VzDQo+ID4NCj4g
DQo+IFllcw0KPiANCj4gPg0KPiA+IEFuZCByZWN5Y2xpbmcgaXMgbm9ybWFsbHkgZG9uZSBhdCB0
aGUgTkFQSSBwb29saW5nLCBOVU1BX05PX05PREUgaGludA0KPiA+IHRvIHVzZSB0aGUgbG9jYWwg
bm9kZSwgZXhjZXB0IG1lbW9yeSB1c2FnZSBpcyB1bmJhbGFuY2UsIHNvIEkgYWRkIHRoZQ0KPiA+
IGNoZWNrIHRoYXQgdGhlIHBhZ2UgbmlkIGlzIHNhbWUgYXMgbnVtYV9tZW1faWQoKSBpZiBwb29s
IGlzDQo+ID4gTlVNQV9OT19OT0RFDQo+IA0KPiBJIGFtIG5vdCBzdXJlIGkgYW0gZm9sbG93aW5n
IGhlcmUuDQo+IFJlY3ljbGluZyBkb25lIGF0IE5BUEkgb3Igbm90IHNob3VsZCBoYXZlIG5vdGhp
bmcgdG8gZG8gd2l0aCBOVU1BLg0KPiBXaGF0IGRvIHlvdSBtZWFuIGJ5ICdtZW1vcnkgdXNhZ2Ug
aXMgdW5iYWxhbmNlJz8NCj4gDQo+IA0KDQpJIGFtIHNheWluZyB0aGUgcG9zc2libGUgcmVhc29u
IHRoYXQgYWxsb2NfcGFnZXNfbm9kZShOVU1BX05PX05PREUpIGNhbiBub3QNCmFsbG9jYXRlIGxv
Y2FsIHBhZ2UsIHdoaWNoIGNhdXNlcyB0aGUgcG9vbF9wYWdlX3JldXNhYmxlIGFsd2F5cyByZXR1
cm4gZmFsc2UgaWYgYWRkIHRoZQ0KY2hlY2sgdGhhdCB0aGUgcGFnZSBuaWQgaXMgc2FtZSBhcyBu
dW1hX21lbV9pZCgpDQoNCml0IHNob3VsZCByYXJlbHkgaGFwcGVuDQoNCi1MaQ0KPiBUaGFua3MN
Cj4gL0lsaWFzDQo=

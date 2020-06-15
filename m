Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCC11F8C54
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 04:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgFOCsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 22:48:52 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2521 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728028AbgFOCsv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Jun 2020 22:48:51 -0400
Received: from nkgeml706-chm.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id EC12415CEED1EBB318C2;
        Mon, 15 Jun 2020 10:48:47 +0800 (CST)
Received: from nkgeml708-chm.china.huawei.com (10.98.57.160) by
 nkgeml706-chm.china.huawei.com (10.98.57.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Mon, 15 Jun 2020 10:48:47 +0800
Received: from nkgeml708-chm.china.huawei.com ([10.98.57.160]) by
 nkgeml708-chm.china.huawei.com ([10.98.57.160]) with mapi id 15.01.1913.007;
 Mon, 15 Jun 2020 10:48:47 +0800
From:   "Guodeqing (A)" <geffrey.guo@huawei.com>
To:     David Ahern <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dsa@cumulusnetworks.com" <dsa@cumulusnetworks.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIG5ldDogRml4IHRoZSBhcnAgZXJyb3IgaW4gc29t?=
 =?utf-8?Q?e_cases?=
Thread-Topic: [PATCH] net: Fix the arp error in some cases
Thread-Index: AQHWQU9mEOe5BeP8Ykii34XgMRswaKjWFgkAgALcnXA=
Date:   Mon, 15 Jun 2020 02:48:47 +0000
Message-ID: <9ab7de80905e4417b6c1e196bb498e7b@huawei.com>
References: <1592030995-111190-1-git-send-email-geffrey.guo@huawei.com>
 <5679487d-cd17-fc91-2474-e12b182a59b7@gmail.com>
In-Reply-To: <5679487d-cd17-fc91-2474-e12b182a59b7@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.164.122.165]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCi0tLS0t6YKu5Lu25Y6f5Lu2LS0tLS0NCuWPkeS7tuS6ujogRGF2aWQgQWhlcm4gW21haWx0
bzpkc2FoZXJuQGdtYWlsLmNvbV0gDQrlj5HpgIHml7bpl7Q6IFNhdHVyZGF5LCBKdW5lIDEzLCAy
MDIwIDIyOjMyDQrmlLbku7bkuro6IEd1b2RlcWluZyAoQSkgPGdlZmZyZXkuZ3VvQGh1YXdlaS5j
b20+OyBkYXZlbUBkYXZlbWxvZnQubmV0DQrmioTpgIE6IGt1em5ldEBtczIuaW5yLmFjLnJ1OyBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkc2FAY3VtdWx1c25ldHdvcmtzLmNvbTsga3ViYUBrZXJu
ZWwub3JnDQrkuLvpopg6IFJlOiBbUEFUQ0hdIG5ldDogRml4IHRoZSBhcnAgZXJyb3IgaW4gc29t
ZSBjYXNlcw0KDQpPbiA2LzEzLzIwIDEyOjQ5IEFNLCBndW9kZXFpbmcgd3JvdGU6DQo+IGllLiwN
Cj4gJCBpZmNvbmZpZyBldGgwIDYuNi42LjYgbmV0bWFzayAyNTUuMjU1LjI1NS4wDQo+IA0KPiAk
IGlwIHJ1bGUgYWRkIGZyb20gNi42LjYuNiB0YWJsZSA2NjY2DQoNCndpdGhvdXQgYSBkZWZhdWx0
IGVudHJ5IGluIHRhYmxlIDY2NjYgdGhlIGxvb2t1cCBwcm9jZWVkcyB0byB0aGUgbmV4dCB0YWJs
ZSAtIHdoaWNoIGJ5IGRlZmF1bHQgaXMgdGhlIG1haW4gdGFibGUuIA0KDQotLS15ZXPvvIxpZiB3
aXRob3V0IHRoZSBydWxl77yMdGhpcyBwcm9ibGVtIHdpbGwgbm90IGhhcHBlbi4gDQogIEZvbGxv
dyB0aGUgc3RlcHM6DQogICQgaWZjb25maWcgZXRoMCA2LjYuNi42IG5ldG1hc2sgMjU1LjI1NS4y
NTUuMA0KICAkIGlwIHJvdXRlIGFkZCA5LjkuOS45IHZpYSA2LjYuNi42DQogICQgcGluZyAtSSA2
LjYuNi42IDkuOS45LjkNCiAgQW5kIFRoZSBhcnAgcmVxdWVzdCBhZGRyZXNzIGlzIDkuOS45Ljkg
YW5kIGlzIHJpZ2h0LigiIGdhdGV3YXkgY2FuIGJlIGFjdHVhbGx5IGxvY2FsIGludGVyZmFjZSBh
ZGRyZXNzLA0KICogICAgc28gdGhhdCBnYXRld2F5ZWQgcm91dGUgaXMgZGlyZWN0IikNCg0KPiAN
Cj4gJCBpcCByb3V0ZSBhZGQgOS45LjkuOSB2aWEgNi42LjYuNg0KPiANCj4gJCBwaW5nIC1JIDYu
Ni42LjYgOS45LjkuOQ0KPiBQSU5HIDkuOS45LjkgKDkuOS45LjkpIGZyb20gNi42LjYuNiA6IDU2
KDg0KSBieXRlcyBvZiBkYXRhLg0KPiANCj4gXkMNCj4gLS0tIDkuOS45LjkgcGluZyBzdGF0aXN0
aWNzIC0tLQ0KPiAzIHBhY2tldHMgdHJhbnNtaXR0ZWQsIDAgcmVjZWl2ZWQsIDEwMCUgcGFja2V0
IGxvc3MsIHRpbWUgMjA3OW1zDQo+IA0KPiAkIGFycA0KPiBBZGRyZXNzICAgICBIV3R5cGUgIEhX
YWRkcmVzcyAgICAgICAgICAgRmxhZ3MgTWFzayAgICAgICAgICAgIElmYWNlDQo+IDYuNi42LjYg
ICAgICAgICAgICAgKGluY29tcGxldGUpICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZXRo
MA0KPiANCj4gVGhlIGFycCByZXF1ZXN0IGFkZHJlc3MgaXMgZXJyb3IsIHRoaXMgcHJvYmxlbSBj
YW4gYmUgcmVwcm9kdWNlZCBlYXNpbHkuDQo+IA0KPiBGaXhlczogM2JmZDg0NzIwM2M2KCJuZXQ6
IFVzZSBwYXNzZWQgaW4gdGFibGUgZm9yIG5leHRob3AgbG9va3VwcyIpDQo+IFNpZ25lZC1vZmYt
Ynk6IGd1b2RlcWluZyA8Z2VmZnJleS5ndW9AaHVhd2VpLmNvbT4NCj4gLS0tDQo+ICBuZXQvaXB2
NC9maWJfc2VtYW50aWNzLmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24o
KyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9uZXQvaXB2NC9maWJfc2VtYW50
aWNzLmMgYi9uZXQvaXB2NC9maWJfc2VtYW50aWNzLmMgaW5kZXggDQo+IGU1Mzg3MWUuLjFmNzVk
YzYgMTAwNjQ0DQo+IC0tLSBhL25ldC9pcHY0L2ZpYl9zZW1hbnRpY3MuYw0KPiArKysgYi9uZXQv
aXB2NC9maWJfc2VtYW50aWNzLmMNCj4gQEAgLTExMDksNyArMTEwOSw3IEBAIHN0YXRpYyBpbnQg
ZmliX2NoZWNrX25oX3Y0X2d3KHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0IGZpYl9uaCAqbmgsIHUz
MiB0YWJsZSwNCj4gIAkJaWYgKGZsNC5mbG93aTRfc2NvcGUgPCBSVF9TQ09QRV9MSU5LKQ0KPiAg
CQkJZmw0LmZsb3dpNF9zY29wZSA9IFJUX1NDT1BFX0xJTks7DQo+ICANCj4gLQkJaWYgKHRhYmxl
KQ0KPiArCQlpZiAodGFibGUgJiYgdGFibGUgIT0gUlRfVEFCTEVfTUFJTikNCj4gIAkJCXRibCA9
IGZpYl9nZXRfdGFibGUobmV0LCB0YWJsZSk7DQo+ICANCj4gIAkJaWYgKHRibCkNCj4gDQoNCmhv
dyBkb2VzIGdhdGV3YXkgdmFsaWRhdGlvbiB3aGVuIHRoZSByb3V0ZSBpcyBpbnN0YWxsZWQgYWZm
ZWN0IGFycCByZXNvbHV0aW9uPw0KDQp5b3UgYXJlIG1pc3Npbmcgc29tZXRoaW5nIGluIGV4cGxh
aW5pbmcgdGhlIHByb2JsZW0geW91IGFyZSBzZWVpbmcuDQoNCi0tIFRoaXMgcHJvYmxlbSBjYW4g
b25seSBoYXBwZW4gaW4gc29tZSBjYXNlcyx0aGlzIDNiZmQ4NDcyMDNjNiBwYXRjaCB3aWxsIGRv
IHRoZSBtYWluIHRhYmxlIGxvb2t1cCBlcnJvciBpbiBzb21lIGNhc2VzLCBhbmQgSSB0aGluayBp
dCBzaG91bGQgbm90IGRvIHRoZSBtYWluIHRhYmxlIGxvb2t1cCBiZWNhdXNlIHRoZSBuZXh0IGZ1
bmN0aW9uIGZpYl9sb29rdXAgZG9lcyB0aGUgbWFpbnRhYmxlIGxvb2t1cC4NCg==

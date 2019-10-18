Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95BBDDD0DC
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 23:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408108AbfJRVIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 17:08:00 -0400
Received: from mail-eopbgr150058.outbound.protection.outlook.com ([40.107.15.58]:57563
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727508AbfJRVIA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 17:08:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XreHJ/0PeXk1IsSFMFtqSqGdSDA+dacuFE3GlSLYLcRxVXjD47c5DCGPjHMcdWlLaswxwpOuESnlwSfHCIXrlMXcwWD2veNOaqnMdTR3zX9CxgEnOzaCcwDuHKeko8klF7u8D7UVVT0v3aov71pIfIF7psNSnSzKyCKGPAdImf3i+oPRCZHMVPgKTomRGtZ6HXtlhVlF3FWAee34f1/sjV3LQGn0eYBB6gavBEA4vdblfOzsuoJiF5+/dEIQkIR1tn7EzHlBr+IMbManWQBU08Gjryod6+KiY0RMGno+gKeiI7qUF9oBUEmcaLDScdnBPeGjfe7kFSoNF45w77iGmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RlVHc7k7EF4xtl+6X6MqXUj3Dd7EIcTplg6D4b7cvM=;
 b=UHHyAx8+MGPnhqLqu9oUqoqXhRnkE5loHXep44kWSRxXGwaApWtsz3JZY6RB2defQ25OzEB/vg7/TCqtqUmTclFVDd16kU47YUGmu90O8Uthxo6SmJF6mz9NP9CYIo7peo27IWx65UX5FEp6VxMJ/aOuMMf0UhpFJiCzLCwOXBVNVF1uHZJJtq9qIjyJ5EcURFI+Tbt1+mGjalHeVxEpjSFB9CiUSYKt84KUZw82zt5iGAyLq8iEGkKNUQeUVlrEvv5fkQVJDWtuR1aHnMUJvRv+6U6sl++hSzHsK2xE79hg6ou/87BZIQStux1x7AExG0bHJUj+Yz6edny96bLDqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RlVHc7k7EF4xtl+6X6MqXUj3Dd7EIcTplg6D4b7cvM=;
 b=g/2178eIOySqALuIC3sPH4e6hcjNEtcwpnfGMsAylaI+VPoAodr+Q7qP/vws/ifl7a+YicXUK1F9yCEfVXMme0JIIbr+mCwxj47SOWkCndUZDAdHv5qJmOeWI4K5OEdg3zu32c99wOsL394PT3Sv9KalLSmg8ygVEQTtk58t8gM=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5039.eurprd05.prod.outlook.com (20.177.50.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Fri, 18 Oct 2019 21:07:56 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 21:07:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>
CC:     "kernel-team@fb.com" <kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        "brouer@redhat.com" <brouer@redhat.com>
Subject: Re: [PATCH 04/10 net-next] page_pool: Add API to update numa node and
 flush page caches
Thread-Topic: [PATCH 04/10 net-next] page_pool: Add API to update numa node
 and flush page caches
Thread-Index: AQHVhHQt6wCRvZHM1ku/SHxvufwLJadevaaAgAIpp4A=
Date:   Fri, 18 Oct 2019 21:07:55 +0000
Message-ID: <97c98884948c6221db50bb850bb03e3a4684f060.camel@mellanox.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
         <20191016225028.2100206-5-jonathan.lemon@gmail.com>
         <20191017120617.GA19322@apalos.home>
In-Reply-To: <20191017120617.GA19322@apalos.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 79626dc9-5b7a-4316-a8a2-08d7540f3f60
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR05MB5039:|VI1PR05MB5039:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5039221DD26B88AA2F43952EBE6C0@VI1PR05MB5039.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(199004)(189003)(66946007)(76116006)(66476007)(64756008)(66556008)(66446008)(81156014)(118296001)(81166006)(91956017)(316002)(25786009)(2501003)(8676002)(229853002)(58126008)(8936002)(110136005)(15650500001)(4001150100001)(54906003)(86362001)(2906002)(476003)(6486002)(11346002)(446003)(2616005)(99286004)(6246003)(6116002)(6436002)(36756003)(102836004)(305945005)(3846002)(478600001)(6506007)(486006)(5660300002)(4326008)(71190400001)(6512007)(14454004)(76176011)(186003)(26005)(71200400001)(14444005)(7736002)(256004)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5039;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HijDBCDG9oTgt3F5fK+7/qBGtcrMF+SOaCvylzSJRHhIBVZfJamDchM79ETty+OVKoTsPlT06+qYa6xkftFqpqhPficCMfi376tWmipnefQ79uJqKVWHuvvr9etYfrmyNm+MWutvK+e3J/oCraftnCnxDP2+KrqYwCp0tZ9nU8QUU/BpAFTHObyzaOnTiqEJ9Fbdj/wy4gSBnsScnaYv0PrJHoh94HJt+xWeDi0HAMMCL88BztYW5qKMlyazV55tmpuxiBvjCDCjZBX0wY9MEjFYkF7guX2u3HHR7XW0Lu4HqKKug7Bz2HQBTT2Y71A7L2TGvS0UvHqf7KM3arfAtwpKfpFqGdKrhSo/85ijHgyq2El2WScldiKOO7x6OYyF+3xoIczV3A6Q1Z9W989PkUMCq4eiKFwWTgwP/fns9zQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0F43CFFA401F964494FFA72570BB18A7@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79626dc9-5b7a-4316-a8a2-08d7540f3f60
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 21:07:55.9806
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7KOUIEp2cjXgsFXAscSWsLqWnevAVlpg/bBWn4sMsiLOq98br7FKXFIbRsQAyupZzRKahbL0xaqL3RMOBRohUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5039
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTEwLTE3IGF0IDE1OjA2ICswMzAwLCBJbGlhcyBBcGFsb2RpbWFzIHdyb3Rl
Og0KPiBIaSBTYWVlZCwNCj4gDQo+IE9uIFdlZCwgT2N0IDE2LCAyMDE5IGF0IDAzOjUwOjIyUE0g
LTA3MDAsIEpvbmF0aGFuIExlbW9uIHdyb3RlOg0KPiA+IEZyb206IFNhZWVkIE1haGFtZWVkIDxz
YWVlZG1AbWVsbGFub3guY29tPg0KPiA+IA0KPiA+IEFkZCBwYWdlX3Bvb2xfdXBkYXRlX25pZCgp
IHRvIGJlIGNhbGxlZCBmcm9tIGRyaXZlcnMgd2hlbiB0aGV5DQo+ID4gZGV0ZWN0DQo+ID4gbnVt
YSBub2RlIGNoYW5nZXMuDQo+ID4gDQo+ID4gSXQgd2lsbCBkbzoNCj4gPiAxKSBGbHVzaCB0aGUg
cG9vbCdzIHBhZ2UgY2FjaGUgYW5kIHB0cl9yaW5nLg0KPiA+IDIpIFVwZGF0ZSBwYWdlIHBvb2wg
bmlkIHZhbHVlIHRvIHN0YXJ0IGFsbG9jYXRpbmcgZnJvbSB0aGUgbmV3IG51bWENCj4gPiBub2Rl
Lg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFu
b3guY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEpvbmF0aGFuIExlbW9uIDxqb25hdGhhbi5sZW1v
bkBnbWFpbC5jb20+DQo+ID4gLS0tDQo+ID4gIGluY2x1ZGUvbmV0L3BhZ2VfcG9vbC5oIHwgMTAg
KysrKysrKysrKw0KPiA+ICBuZXQvY29yZS9wYWdlX3Bvb2wuYyAgICB8IDE2ICsrKysrKysrKysr
LS0tLS0NCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAyMSBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9u
cygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9wYWdlX3Bvb2wuaCBiL2lu
Y2x1ZGUvbmV0L3BhZ2VfcG9vbC5oDQo+ID4gaW5kZXggMmNiY2RiZGVjMjU0Li5mYjEzY2Y2MDU1
ZmYgMTAwNjQ0DQo+ID4gLS0tIGEvaW5jbHVkZS9uZXQvcGFnZV9wb29sLmgNCj4gPiArKysgYi9p
bmNsdWRlL25ldC9wYWdlX3Bvb2wuaA0KPiA+IEBAIC0yMjYsNCArMjI2LDE0IEBAIHN0YXRpYyBp
bmxpbmUgYm9vbCBwYWdlX3Bvb2xfcHV0KHN0cnVjdA0KPiA+IHBhZ2VfcG9vbCAqcG9vbCkNCj4g
PiAgCXJldHVybiByZWZjb3VudF9kZWNfYW5kX3Rlc3QoJnBvb2wtPnVzZXJfY250KTsNCj4gPiAg
fQ0KPiA+ICANCj4gPiArLyogT25seSBzYWZlIGZyb20gbmFwaSBjb250ZXh0IG9yIHdoZW4gdXNl
ciBndWFyYW50ZWVzIGl0IGlzDQo+ID4gdGhyZWFkIHNhZmUgKi8NCj4gPiArdm9pZCBfX3BhZ2Vf
cG9vbF9mbHVzaChzdHJ1Y3QgcGFnZV9wb29sICpwb29sKTsNCj4gDQo+IFRoaXMgc2hvdWxkIGJl
IGNhbGxlZCBwZXIgcGFja2V0IHJpZ2h0PyBBbnkgbm90aWNlYWJsZSBpbXBhY3Qgb24NCj4gcGVy
Zm9ybWFuY2U/DQo+IA0Kbm8sIG9uY2UgcGVyIG5hcGkgYW5kIG9ubHkgaWYgYSBjaGFuZ2UgaW4g
bnVtYSBub2RlIGlzIGRldGVjdGVkLCBzbw0KdmVyeSB2ZXJ5IHJhcmUgIQ0KDQo+ID4gK3N0YXRp
YyBpbmxpbmUgdm9pZCBwYWdlX3Bvb2xfdXBkYXRlX25pZChzdHJ1Y3QgcGFnZV9wb29sICpwb29s
LA0KPiA+IGludCBuZXdfbmlkKQ0KPiA+ICt7DQo+ID4gKwlpZiAodW5saWtlbHkocG9vbC0+cC5u
aWQgIT0gbmV3X25pZCkpIHsNCj4gPiArCQkvKiBUT0RPOiBBZGQgc3RhdGlzdGljcy90cmFjZSAq
Lw0KPiA+ICsJCV9fcGFnZV9wb29sX2ZsdXNoKHBvb2wpOw0KPiA+ICsJCXBvb2wtPnAubmlkID0g
bmV3X25pZDsNCj4gPiArCX0NCj4gPiArfQ0KPiA+ICAjZW5kaWYgLyogX05FVF9QQUdFX1BPT0xf
SCAqLw0KPiA+IGRpZmYgLS1naXQgYS9uZXQvY29yZS9wYWdlX3Bvb2wuYyBiL25ldC9jb3JlL3Bh
Z2VfcG9vbC5jDQo+ID4gaW5kZXggNWJjNjU1ODdmMWM0Li42NzhjZjg1ZjI3M2EgMTAwNjQ0DQo+
ID4gLS0tIGEvbmV0L2NvcmUvcGFnZV9wb29sLmMNCj4gPiArKysgYi9uZXQvY29yZS9wYWdlX3Bv
b2wuYw0KPiA+IEBAIC0zNzMsMTYgKzM3MywxMyBAQCB2b2lkIF9fcGFnZV9wb29sX2ZyZWUoc3Ry
dWN0IHBhZ2VfcG9vbCAqcG9vbCkNCj4gPiAgfQ0KPiA+ICBFWFBPUlRfU1lNQk9MKF9fcGFnZV9w
b29sX2ZyZWUpOw0KPiA+ICANCj4gPiAtLyogUmVxdWVzdCB0byBzaHV0ZG93bjogcmVsZWFzZSBw
YWdlcyBjYWNoZWQgYnkgcGFnZV9wb29sLCBhbmQNCj4gPiBjaGVjaw0KPiA+IC0gKiBmb3IgaW4t
ZmxpZ2h0IHBhZ2VzDQo+ID4gLSAqLw0KPiA+IC1ib29sIF9fcGFnZV9wb29sX3JlcXVlc3Rfc2h1
dGRvd24oc3RydWN0IHBhZ2VfcG9vbCAqcG9vbCkNCj4gPiArdm9pZCBfX3BhZ2VfcG9vbF9mbHVz
aChzdHJ1Y3QgcGFnZV9wb29sICpwb29sKQ0KPiA+ICB7DQo+ID4gIAlzdHJ1Y3QgcGFnZSAqcGFn
ZTsNCj4gPiAgDQo+ID4gIAkvKiBFbXB0eSBhbGxvYyBjYWNoZSwgYXNzdW1lIGNhbGxlciBtYWRl
IHN1cmUgdGhpcyBpcw0KPiA+ICAJICogbm8tbG9uZ2VyIGluIHVzZSwgYW5kIHBhZ2VfcG9vbF9h
bGxvY19wYWdlcygpIGNhbm5vdCBiZQ0KPiA+IC0JICogY2FsbCBjb25jdXJyZW50bHkuDQo+ID4g
KwkgKiBjYWxsZWQgY29uY3VycmVudGx5Lg0KPiA+ICAJICovDQo+ID4gIAl3aGlsZSAocG9vbC0+
YWxsb2MuY291bnQpIHsNCj4gPiAgCQlwYWdlID0gcG9vbC0+YWxsb2MuY2FjaGVbLS1wb29sLT5h
bGxvYy5jb3VudF07DQo+ID4gQEAgLTM5Myw2ICszOTAsMTUgQEAgYm9vbCBfX3BhZ2VfcG9vbF9y
ZXF1ZXN0X3NodXRkb3duKHN0cnVjdA0KPiA+IHBhZ2VfcG9vbCAqcG9vbCkNCj4gPiAgCSAqIGJl
IGluLWZsaWdodC4NCj4gPiAgCSAqLw0KPiA+ICAJX19wYWdlX3Bvb2xfZW1wdHlfcmluZyhwb29s
KTsNCj4gPiArfQ0KPiA+ICtFWFBPUlRfU1lNQk9MKF9fcGFnZV9wb29sX2ZsdXNoKTsNCj4gDQo+
IEEgbGF0ZXIgcGF0Y2ggcmVtb3ZlcyB0aGlzLCBkbyB3ZSBhY3R1YWxseSBuZWVkIGl0IGhlcmU/
DQoNCkkgYWdyZWUsIEpvbmF0aGFuIGNoYW5nZWQgdGhlIGRlc2lnbiBvZiBteSBsYXN0IHBhdGNo
IGluIHRoaXMgc2VyaWVzDQphbmQgdGhpcyBiZWNhbWUgcmVkdW5kYW50IGFzIGhlIGlzIGdvaW5n
IHRvIGRvIGxhenkgcmVsZWFzZSBvZiB1bndhbnRlZA0KcGFnZXMsIHJhdGhlciB0aGFuIGZsdXNo
aW5nIHRoZSBjYWNoZS4NCg0KPiANCj4gPiArDQo+ID4gKy8qIFJlcXVlc3QgdG8gc2h1dGRvd246
IHJlbGVhc2UgcGFnZXMgY2FjaGVkIGJ5IHBhZ2VfcG9vbCwgYW5kDQo+ID4gY2hlY2sNCj4gPiAr
ICogZm9yIGluLWZsaWdodCBwYWdlcw0KPiA+ICsgKi8NCj4gPiArYm9vbCBfX3BhZ2VfcG9vbF9y
ZXF1ZXN0X3NodXRkb3duKHN0cnVjdCBwYWdlX3Bvb2wgKnBvb2wpDQo+ID4gK3sNCj4gPiArCV9f
cGFnZV9wb29sX2ZsdXNoKHBvb2wpOw0KPiA+ICANCj4gPiAgCXJldHVybiBfX3BhZ2VfcG9vbF9z
YWZlX3RvX2Rlc3Ryb3kocG9vbCk7DQo+ID4gIH0NCj4gPiAtLSANCj4gPiAyLjE3LjENCj4gPiAN
Cj4gDQo+IFRoYW5rcw0KPiAvSWxpYXMNCg==

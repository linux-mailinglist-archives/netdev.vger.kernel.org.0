Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 047B813B3A5
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 21:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbgANUbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 15:31:03 -0500
Received: from mail-am6eur05on2073.outbound.protection.outlook.com ([40.107.22.73]:16608
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728346AbgANUbC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 15:31:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iH/BmHUJNPTUnuauJGNIzCgomphV0Of5rb0DOInDWlD3vVOG5ewNzo7/3PpeC/UnTyFgyXz7YAO7cOV8ejWqCqzMpK1w5izMGj76CAdVVpXKz2CsmivuyhC5tkUxOpYzNO6UWCXvFhiMakO+cpjfjMCcKus358ODIoRmST1IyXLY0w/4WV+0IO7FPK0iMTgtUZyWUJGoHfowLW87WHqNe0Ggyj38q67/x8zXuvhXvoy+EkKVOZOtk1q73Zh2e/60HFjt5IAScuizPpBiEMhf8GU1o/6KVTvCv4pvfMeyOiRSYiuDP4Eq2sKLHZ+LGg6XbzKyUbZcjOOkb2WoTGJyhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CRDT7Zd7H9aG3pn/S6ZiHQ70u3ymyqHF7x+Jsu/0hLE=;
 b=AjkmaRNjRTqrjs0W/vvtPuR/2kDAuTk0QFQQkRzrjTRauLC/GHitAKqxdEIcQcQCyXu1M0v/BIe29/FhoYhuTLz3y6HFqQ74veY+LqCCpb0y84Hut+KFCeT8CDo/cbAQCXaDApWE8/rD92aiLPwAvuxDt0ZDP70yVpgbb8rWSXttr/jqQuaz6VDrfVS1IPfL1mKPFsRco+tUsHdsaAL1y86p7dKu2x0AnmZFY70XD882gP3XprtkT+QBOeWxiHLbj9tnLcki+g3+OMCskDg5ltGVVhEy4r5TWbQiui/4uTa3posQXPN6TCtNVBTogaYGcU00KdLcVGxmh06p2G2ldQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CRDT7Zd7H9aG3pn/S6ZiHQ70u3ymyqHF7x+Jsu/0hLE=;
 b=Xi7WAD8Z8r2f9f6zKhfUaGig7gr25Z8uEusMboGgLIxYJ2c4E1plBxwwaLdVLkWMjrz5OEd04tg6N6qFXTmnOGD1F1HKMykAsrpHEgnQV27ZKj1KuuVnO+1IKvDsQTzE7s6TuPNg5sCsw+xHz1l+dp1EoXpun+MJK+LkETQMp/Y=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5600.eurprd05.prod.outlook.com (20.177.200.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Tue, 14 Jan 2020 20:30:55 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2623.017; Tue, 14 Jan 2020
 20:30:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "joe@perches.com" <joe@perches.com>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] mlx5: Use proper logging and tracing line
 terminations
Thread-Topic: [PATCH net-next] mlx5: Use proper logging and tracing line
 terminations
Thread-Index: AQHVyeOAdDYBrUAeLEaukP+w8EzTYafqnzeA
Date:   Tue, 14 Jan 2020 20:30:55 +0000
Message-ID: <8cc2d212a2cbad7f8a91e93d1da91494505d7321.camel@mellanox.com>
References: <3b91c274164d1ae9d81dce9f3b398d691cc6765e.camel@perches.com>
In-Reply-To: <3b91c274164d1ae9d81dce9f3b398d691cc6765e.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.2 (3.34.2-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 72f83ab4-fe93-4791-3d69-08d79930a862
x-ms-traffictypediagnostic: VI1PR05MB5600:
x-microsoft-antispam-prvs: <VI1PR05MB5600BEBFC46C9EF31E37F4FABE340@VI1PR05MB5600.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-forefront-prvs: 028256169F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(346002)(366004)(396003)(199004)(189003)(6486002)(8676002)(5660300002)(6512007)(81156014)(81166006)(86362001)(8936002)(66556008)(76116006)(66476007)(110136005)(66946007)(91956017)(54906003)(66446008)(36756003)(71200400001)(316002)(64756008)(26005)(478600001)(6506007)(186003)(4326008)(2616005)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5600;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NvY/hjaeYFacDQaQOlqVESFHUuMrN0t4FA4MIHFh3RFQ2MSm/rySbd/2lWyEu6vpA2HIU5RM723enE/zpw+8y+xAlqYOYfsLsf3LUnqcGx+x9eBWX7zrY2mRknHTIyB3MVmWq2t6/AcwM+nW1nxW0YavPGe5RV5UG8ViBLbvWh9rnB+KInRR9dwUnVbgFRVbmY88XTER4LsrzsFORctuw1S5L0qWiC4aYgEHeE/mjXraNwqrrresIiyT0YTr9GEbSmfCzpnQizIKcRBzqP06YB6XH/cWf8K8vHebtZxmPbLUJ5U1d7B/DRGoOgQmSI1/0/zmgGQzpp0Jar58NPXqie0UdrinNuL+qR2tt6DNNac3fXEiCxvRmHGYDUELfP8O4GjjU3jeOXsZsyq7+hGmDGcTPppNytLirn0tTH1Mrc6UP7EO2lJSP8OXF2WDlRsM
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A8A2461DB61F9C479B5EBD05DDEB405B@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72f83ab4-fe93-4791-3d69-08d79930a862
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2020 20:30:55.6856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kTiLuatCstzgY8tXwGHf9jko+jVw1q32TK4llzWrQM2PsCHkws/mxWsjEiNC0QAwk0fPuBlwl9CpNwbCt17o0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5600
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIwLTAxLTEyIGF0IDIzOjMwIC0wODAwLCBKb2UgUGVyY2hlcyB3cm90ZToNCj4g
bmV0ZGV2X2VyciBzaG91bGQgdXNlIG5ld2xpbmUgdGVybWluYXRpb24gYnV0IG1seDVfaGVhbHRo
X3JlcG9ydA0KPiBpcyB1c2VkIGluIGEgdHJhY2Ugb3V0cHV0IGZ1bmN0aW9uIGRldmxpbmtfaGVh
bHRoX3JlcG9ydCB3aGVyZQ0KPiBubyBuZXdsaW5lIHNob3VsZCBiZSB1c2VkLg0KPiANCj4gUmVt
b3ZlIHRoZSBuZXdsaW5lcyBmcm9tIGEgY291cGxlIGZvcm1hdHMgYW5kIGFkZCBhIGZvcm1hdCBz
dHJpbmcNCj4gb2YgIiVzXG4iIHRvIHRoZSBuZXRkZXZfZXJyIGNhbGwgdG8gbm90IGRpcmVjdGx5
IG91dHB1dCB0aGUNCj4gbG9nZ2luZyBzdHJpbmcuDQo+IA0KPiBBbHNvIHVzZSBzbnByaW50ZiB0
byBhdm9pZCBhbnkgcG9zc2libGUgb3V0cHV0IHN0cmluZyBvdmVycnVuLg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogSm9lIFBlcmNoZXMgPGpvZUBwZXJjaGVzLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vaGVhbHRoLmMgICAgICB8ICAyICst
DQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vcmVwb3J0ZXJf
cnguYyB8ICA5ICsrKysrLQ0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9lbi9yZXBvcnRlcl90eC5jIHwgMTAgKysrKystDQo+IC0tLS0NCj4gIDMgZmls
ZXMgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL2hlYWx0
aC5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL2hlYWx0
aC5jDQo+IGluZGV4IDNhOTc1Ni4uNzVhMzVmMSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL2hlYWx0aC5jDQo+ICsrKyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi9oZWFsdGguYw0KPiBAQCAtMTk3LDcg
KzE5Nyw3IEBAIGludCBtbHg1ZV9oZWFsdGhfcmVwb3J0KHN0cnVjdCBtbHg1ZV9wcml2ICpwcml2
LA0KPiAgCQkJc3RydWN0IGRldmxpbmtfaGVhbHRoX3JlcG9ydGVyICpyZXBvcnRlciwgY2hhcg0K
PiAqZXJyX3N0ciwNCj4gIAkJCXN0cnVjdCBtbHg1ZV9lcnJfY3R4ICplcnJfY3R4KQ0KPiAgew0K
PiAtCW5ldGRldl9lcnIocHJpdi0+bmV0ZGV2LCBlcnJfc3RyKTsNCj4gKwluZXRkZXZfZXJyKHBy
aXYtPm5ldGRldiwgIiVzXG4iLCBlcnJfc3RyKTsNCj4gIA0KPiAgCWlmICghcmVwb3J0ZXIpDQo+
ICAJCXJldHVybiBlcnJfY3R4LT5yZWNvdmVyKCZlcnJfY3R4LT5jdHgpOw0KPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3JlcG9ydGVyX3J4
LmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vcmVwb3J0
ZXJfcnguYw0KPiBpbmRleCA2YzcyYjU5Li42N2QyZjcwIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vcmVwb3J0ZXJfcnguYw0KPiArKysg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vcmVwb3J0ZXJfcngu
Yw0KPiBAQCAtMTEwLDcgKzExMCw3IEBAIHZvaWQgbWx4NWVfcmVwb3J0ZXJfaWNvc3FfY3FlX2Vy
cihzdHJ1Y3QNCj4gbWx4NWVfaWNvc3EgKmljb3NxKQ0KPiAgDQo+ICAJZXJyX2N0eC5jdHggPSBp
Y29zcTsNCj4gIAllcnJfY3R4LnJlY292ZXIgPSBtbHg1ZV9yeF9yZXBvcnRlcl9lcnJfaWNvc3Ff
Y3FlX3JlY292ZXI7DQo+IC0Jc3ByaW50ZihlcnJfc3RyLCAiRVJSIENRRSBvbiBJQ09TUTogMHgl
eCIsIGljb3NxLT5zcW4pOw0KPiArCXNucHJpbnRmKGVycl9zdHIsIHNpemVvZihlcnJfc3RyKSwg
IkVSUiBDUUUgb24gSUNPU1E6IDB4JXgiLA0KPiBpY29zcS0+c3FuKTsNCj4gIA0KPiAgCW1seDVl
X2hlYWx0aF9yZXBvcnQocHJpdiwgcHJpdi0+cnhfcmVwb3J0ZXIsIGVycl9zdHIsDQo+ICZlcnJf
Y3R4KTsNCj4gIH0NCj4gQEAgLTE3OSw3ICsxNzksNyBAQCB2b2lkIG1seDVlX3JlcG9ydGVyX3Jx
X2NxZV9lcnIoc3RydWN0IG1seDVlX3JxDQo+ICpycSkNCj4gIA0KPiAgCWVycl9jdHguY3R4ID0g
cnE7DQo+ICAJZXJyX2N0eC5yZWNvdmVyID0gbWx4NWVfcnhfcmVwb3J0ZXJfZXJyX3JxX2NxZV9y
ZWNvdmVyOw0KPiAtCXNwcmludGYoZXJyX3N0ciwgIkVSUiBDUUUgb24gUlE6IDB4JXgiLCBycS0+
cnFuKTsNCj4gKwlzbnByaW50ZihlcnJfc3RyLCBzaXplb2YoZXJyX3N0ciksICJFUlIgQ1FFIG9u
IFJROiAweCV4IiwgcnEtDQo+ID5ycW4pOw0KPiAgDQo+ICAJbWx4NWVfaGVhbHRoX3JlcG9ydChw
cml2LCBwcml2LT5yeF9yZXBvcnRlciwgZXJyX3N0ciwNCj4gJmVycl9jdHgpOw0KPiAgfQ0KPiBA
QCAtMjEwLDggKzIxMCw5IEBAIHZvaWQgbWx4NWVfcmVwb3J0ZXJfcnhfdGltZW91dChzdHJ1Y3Qg
bWx4NWVfcnENCj4gKnJxKQ0KPiAgDQo+ICAJZXJyX2N0eC5jdHggPSBycTsNCj4gIAllcnJfY3R4
LnJlY292ZXIgPSBtbHg1ZV9yeF9yZXBvcnRlcl90aW1lb3V0X3JlY292ZXI7DQo+IC0Jc3ByaW50
ZihlcnJfc3RyLCAiUlggdGltZW91dCBvbiBjaGFubmVsOiAlZCwgSUNPU1E6IDB4JXggUlE6DQo+
IDB4JXgsIENROiAweCV4XG4iLA0KPiAtCQlpY29zcS0+Y2hhbm5lbC0+aXgsIGljb3NxLT5zcW4s
IHJxLT5ycW4sIHJxLQ0KPiA+Y3EubWNxLmNxbik7DQo+ICsJc25wcmludGYoZXJyX3N0ciwgc2l6
ZW9mKGVycl9zdHIpLA0KPiArCQkgIlJYIHRpbWVvdXQgb24gY2hhbm5lbDogJWQsIElDT1NROiAw
eCV4IFJROiAweCV4LCBDUToNCj4gMHgleCIsDQo+ICsJCSBpY29zcS0+Y2hhbm5lbC0+aXgsIGlj
b3NxLT5zcW4sIHJxLT5ycW4sIHJxLQ0KPiA+Y3EubWNxLmNxbik7DQo+ICANCj4gIAltbHg1ZV9o
ZWFsdGhfcmVwb3J0KHByaXYsIHByaXYtPnJ4X3JlcG9ydGVyLCBlcnJfc3RyLA0KPiAmZXJyX2N0
eCk7DQo+ICB9DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZW4vcmVwb3J0ZXJfdHguYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lbi9yZXBvcnRlcl90eC5jDQo+IGluZGV4IGI0Njg1NC4uNWVjYjk4NiAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vu
L3JlcG9ydGVyX3R4LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2VuL3JlcG9ydGVyX3R4LmMNCj4gQEAgLTkwLDcgKzkwLDcgQEAgdm9pZCBtbHg1ZV9y
ZXBvcnRlcl90eF9lcnJfY3FlKHN0cnVjdCBtbHg1ZV90eHFzcQ0KPiAqc3EpDQo+ICANCj4gIAll
cnJfY3R4LmN0eCA9IHNxOw0KPiAgCWVycl9jdHgucmVjb3ZlciA9IG1seDVlX3R4X3JlcG9ydGVy
X2Vycl9jcWVfcmVjb3ZlcjsNCj4gLQlzcHJpbnRmKGVycl9zdHIsICJFUlIgQ1FFIG9uIFNROiAw
eCV4Iiwgc3EtPnNxbik7DQo+ICsJc25wcmludGYoZXJyX3N0ciwgc2l6ZW9mKGVycl9zdHIpLCAi
RVJSIENRRSBvbiBTUTogMHgleCIsIHNxLQ0KPiA+c3FuKTsNCj4gIA0KPiAgCW1seDVlX2hlYWx0
aF9yZXBvcnQocHJpdiwgcHJpdi0+dHhfcmVwb3J0ZXIsIGVycl9zdHIsDQo+ICZlcnJfY3R4KTsN
Cj4gIH0NCj4gQEAgLTExOCwxMCArMTE4LDEwIEBAIGludCBtbHg1ZV9yZXBvcnRlcl90eF90aW1l
b3V0KHN0cnVjdA0KPiBtbHg1ZV90eHFzcSAqc3EpDQo+ICANCj4gIAllcnJfY3R4LmN0eCA9IHNx
Ow0KPiAgCWVycl9jdHgucmVjb3ZlciA9IG1seDVlX3R4X3JlcG9ydGVyX3RpbWVvdXRfcmVjb3Zl
cjsNCj4gLQlzcHJpbnRmKGVycl9zdHIsDQo+IC0JCSJUWCB0aW1lb3V0IG9uIHF1ZXVlOiAlZCwg
U1E6IDB4JXgsIENROiAweCV4LCBTUSBDb25zOg0KPiAweCV4IFNRIFByb2Q6IDB4JXgsIHVzZWNz
IHNpbmNlIGxhc3QgdHJhbnM6ICV1XG4iLA0KPiAtCQlzcS0+Y2hhbm5lbC0+aXgsIHNxLT5zcW4s
IHNxLT5jcS5tY3EuY3FuLCBzcS0+Y2MsIHNxLQ0KPiA+cGMsDQo+IC0JCWppZmZpZXNfdG9fdXNl
Y3MoamlmZmllcyAtIHNxLT50eHEtPnRyYW5zX3N0YXJ0KSk7DQo+ICsJc25wcmludGYoZXJyX3N0
ciwgc2l6ZW9mKGVycl9zdHIpLA0KPiArCQkgIlRYIHRpbWVvdXQgb24gcXVldWU6ICVkLCBTUTog
MHgleCwgQ1E6IDB4JXgsIFNRIENvbnM6DQo+IDB4JXggU1EgUHJvZDogMHgleCwgdXNlY3Mgc2lu
Y2UgbGFzdCB0cmFuczogJXUiLA0KPiArCQkgc3EtPmNoYW5uZWwtPml4LCBzcS0+c3FuLCBzcS0+
Y3EubWNxLmNxbiwgc3EtPmNjLCBzcS0NCj4gPnBjLA0KPiArCQkgamlmZmllc190b191c2Vjcyhq
aWZmaWVzIC0gc3EtPnR4cS0+dHJhbnNfc3RhcnQpKTsNCj4gIA0KPiAgCXJldHVybiBtbHg1ZV9o
ZWFsdGhfcmVwb3J0KHByaXYsIHByaXYtPnR4X3JlcG9ydGVyLCBlcnJfc3RyLA0KPiAmZXJyX2N0
eCk7DQo+ICB9DQo+IA0KPiANCj4gDQoNCkxHVE0sIEFwcGxpZWQgdG8gbmV0LW5leHQtbWx4NS4N
Cg0KVGhhbmtzLA0KU2FlZWQuDQo=

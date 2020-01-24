Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E23DE149119
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 23:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgAXWmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 17:42:47 -0500
Received: from mail-db8eur05on2048.outbound.protection.outlook.com ([40.107.20.48]:31222
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729047AbgAXWmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 17:42:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fise2m8DdGi0tajM6laFrHlKqhH5A457QwllkzxSbUSaK6TYYNEUn4G8kPW0ZcsHrYv2ytpH3PbxtBP9nX+KDcjy+JmPC5Th3fPjqpT7cXCjOSlPjNjm5MPOiC0ajdTdkSypTBT5SlbYKYk+MRCEjDtpyTYigZVSp8KQHc6+C0BcgH/ewyuRPslYa716xtsymsBeDeCUqz6+WNBOBsoH1N4bDj4oHr9PC8HwnaemB1tZvID9ATKsbEGE1Eu+wqRgr1UQ6uTGwx5OpA9mZSzWHwmo1KdHN0PA+F0ykr5KvawGb/4uZ+6lm3WvLTCwEX9f9UQnIfqZIx5P/ce4nQCc7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2HPINBiLyzxpyPRcES5w2BY18ur5LxnxAZrHRGzsEE=;
 b=kCokfdYh7pdiEijlh7fHQ4/nCdaAYHGMy0dBZbNGiqa8Asu1x+al67EyzPS2qDTLI7oeV9sKk6396AGnqyoH5whShgP323GwN/NjtHcMB2j4ng6+Hvffysjh1bo4f+1QYUTxhtw3kvELShTz5eq8bNfNDGQN9Dx8Tp4oqRS37Yvl9lcmm0yjhg70w7R+PDB4x3Ww5hQa2ZRnjJfyCO/GS7msPLcvW8Gl1T/PgrO2UKBFaas/QZgXtyBNYXvWwhUwDCMXwjNkNif9BZWeUjutpUzLCbz6JBrRoGmcbJpbhAv7KabAVhmLMA4nguDVPxpjoNoI2sB+u0Az75L9EWV1eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2HPINBiLyzxpyPRcES5w2BY18ur5LxnxAZrHRGzsEE=;
 b=PQKKZLddk/KkqGChYnn8RdrlI/f0+ijqFMDn3pGtuzxhJypZoh+Ycbhnhw8vFoiO2fiIxi28Td9/BUkazumaGwhdcpA5TakIyN48HlwA33ZA/AojXLedcJJrdoHxKn6ceVH/pI+nmCknY4uyVisr0E9r4AgGmnuGaUT80r6ay7o=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4702.eurprd05.prod.outlook.com (20.176.1.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Fri, 24 Jan 2020 22:42:43 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 22:42:43 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "joe@perches.com" <joe@perches.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next 06/14] mlx5: Use proper logging and tracing line
 terminations
Thread-Topic: [net-next 06/14] mlx5: Use proper logging and tracing line
 terminations
Thread-Index: AQHV0wDwhVlKH3k3QUuFraNLfeJazKf6YZKAgAAHl4A=
Date:   Fri, 24 Jan 2020 22:42:43 +0000
Message-ID: <83a85bb8d25d08cb897d4af54b7a71f285238520.camel@mellanox.com>
References: <20200124215431.47151-1-saeedm@mellanox.com>
         <20200124215431.47151-7-saeedm@mellanox.com>
         <6713b0b5394cfcc5b2b2c6c2f2fb48920a3f2efa.camel@perches.com>
In-Reply-To: <6713b0b5394cfcc5b2b2c6c2f2fb48920a3f2efa.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.3 (3.34.3-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6fad67bf-974c-4555-aae3-08d7a11eb9c0
x-ms-traffictypediagnostic: VI1PR05MB4702:
x-microsoft-antispam-prvs: <VI1PR05MB47029C8FDE60FDB8F4DA5E35BE0E0@VI1PR05MB4702.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(39850400004)(346002)(136003)(396003)(199004)(189003)(186003)(26005)(86362001)(6506007)(36756003)(2616005)(71200400001)(2906002)(76116006)(66946007)(8676002)(64756008)(478600001)(81166006)(91956017)(66556008)(81156014)(66476007)(66446008)(8936002)(6512007)(316002)(110136005)(5660300002)(6486002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4702;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mSM4oTKUT41XYurnX1t1LQ5Jv0vQfExQDejr0TpHUyO85WlZ+eHUUYav+aRIoemC3PiVxz/gQDw4/bjVymnZtbMyfxnjvyBMY2aGSA/Sm8v5OkJ36EqJGIbBwyIALaY/y1ru4+1SuVHFd2AyURbxbaPbyfXQzx6b+aMBA+zo+LD7U14X8xdiiCfDk+rEdH5h0Velu4Se5H04Snk/Tfj22y3IbdKPjtffVQi1fKIloIObT5sHQLxDrElu3mbm7SwtAgRoGvHaB0BO/1zve/aLiG2dcJgdgHcM26J1CvfbpCb/PeTa8IV7kwfWpoXhQ+lMk8KjkISfPMIrGeeWpLOtcGyGHyyyD6lfLriclHemcvL14RScY3GFzOCU7sCaGLTmoNIr1kAjA+ojrAZHqzoxx9bFAmfV187rD7f6mJmX7wdwkqwU4rbkVHos5RA2Yg4Y
x-ms-exchange-antispam-messagedata: tnm4qHDUJ0wq9nVfcymOZ76l5ZSGG4yTDwIaA5tz3OQaNGTdq/r90Z2aN93Z8N06nZAnwJm5BgtavOWrXCtmZEVpE/Og8YMtU/mpKV8M+roB4R9FFTt5v8vH62yTRQbNYYR7oIE4GhlfhN8SZJcIkA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <64895D5E194B83478248FC8A1E661E0F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fad67bf-974c-4555-aae3-08d7a11eb9c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 22:42:43.2077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vTDRWwKNjvVLdz+uSEwcAHT3cVVFPW8p8BaZAuE6xN4X8zWWYmv7gksqQCzXkvQsljfuf08AmlVe7vBZ715dSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4702
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTAxLTI0IGF0IDE0OjE1IC0wODAwLCBKb2UgUGVyY2hlcyB3cm90ZToNCj4g
T24gRnJpLCAyMDIwLTAxLTI0IGF0IDIxOjU1ICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gPiBGcm9tOiBKb2UgUGVyY2hlcyA8am9lQHBlcmNoZXMuY29tPg0KPiANCj4gTm90IHJlYWxs
eSBmcm9tIG1lLg0KPiANCj4gPiBuZXRkZXZfZXJyIHNob3VsZCB1c2UgbmV3bGluZSB0ZXJtaW5h
dGlvbiBidXQgbWx4NV9oZWFsdGhfcmVwb3J0DQo+ID4gaXMgdXNlZCBpbiBhIHRyYWNlIG91dHB1
dCBmdW5jdGlvbiBkZXZsaW5rX2hlYWx0aF9yZXBvcnQgd2hlcmUNCj4gPiBubyBuZXdsaW5lIHNo
b3VsZCBiZSB1c2VkLg0KPiA+IA0KPiA+IFJlbW92ZSB0aGUgbmV3bGluZXMgZnJvbSBhIGNvdXBs
ZSBmb3JtYXRzIGFuZCBhZGQgYSBmb3JtYXQgc3RyaW5nDQo+ID4gb2YgIiVzXG4iIHRvIHRoZSBu
ZXRkZXZfZXJyIGNhbGwgdG8gbm90IGRpcmVjdGx5IG91dHB1dCB0aGUNCj4gPiBsb2dnaW5nIHN0
cmluZy4NCj4gPiANCj4gPiBBbHNvIHVzZSBzbnByaW50ZiB0byBhdm9pZCBhbnkgcG9zc2libGUg
b3V0cHV0IHN0cmluZyBvdmVycnVuLg0KPiBbXQ0KPiA+IGRpZmYgLS1naXQNCj4gPiBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi9yZXBvcnRlcl90eC5jDQo+ID4g
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vcmVwb3J0ZXJfdHgu
Yw0KPiBbXQ0KPiA+IEBAIC0zODksMTAgKzM4OSwxMCBAQCBpbnQgbWx4NWVfcmVwb3J0ZXJfdHhf
dGltZW91dChzdHJ1Y3QNCj4gPiBtbHg1ZV90eHFzcSAqc3EpDQo+ID4gIAllcnJfY3R4LmN0eCA9
IHNxOw0KPiA+ICAJZXJyX2N0eC5yZWNvdmVyID0gbWx4NWVfdHhfcmVwb3J0ZXJfdGltZW91dF9y
ZWNvdmVyOw0KPiA+ICAJZXJyX2N0eC5kdW1wID0gbWx4NWVfdHhfcmVwb3J0ZXJfZHVtcF9zcTsN
Cj4gPiAtCXNwcmludGYoZXJyX3N0ciwNCj4gPiAtCQkiVFggdGltZW91dCBvbiBxdWV1ZTogJWQs
IFNROiAweCV4LCBDUTogMHgleCwgU1EgQ29uczoNCj4gPiAweCV4IFNRIFByb2Q6IDB4JXgsIHVz
ZWNzIHNpbmNlIGxhc3QgdHJhbnM6ICV1XG4iLA0KPiA+IC0JCXNxLT5jaGFubmVsLT5peCwgc3Et
PnNxbiwgc3EtPmNxLm1jcS5jcW4sIHNxLT5jYywgc3EtDQo+ID4gPnBjLA0KPiA+IC0JCWppZmZp
ZXNfdG9fdXNlY3MoamlmZmllcyAtIHNxLT50eHEtPnRyYW5zX3N0YXJ0KSk7DQo+ID4gKwlzbnBy
aW50ZihlcnJfc3RyLCBzaXplb2YoZXJyX3N0ciksDQo+ID4gKwkJICJUWCB0aW1lb3V0IG9uIHF1
ZXVlOiAlZCwgU1E6IDB4JXgsIENROiAweCV4LCBTUSBDb25zOg0KPiA+IDB4JXggU1EgUHJvZDog
MHgleCwgdXNlY3Mgc2luY2UgbGFzdCB0cmFuczogJXVcbiIsDQo+ID4gKwkJIHNxLT5jaGFubmVs
LT5peCwgc3EtPnNxbiwgc3EtPmNxLm1jcS5jcW4sIHNxLT5jYywgc3EtDQo+ID4gPnBjLA0KPiA+
ICsJCSBqaWZmaWVzX3RvX3VzZWNzKGppZmZpZXMgLSBzcS0+dHhxLT50cmFuc19zdGFydCkpOw0K
PiANCj4gVGhpcyBpcyBub3QgdGhlIHBhdGNoIEkgc2VudC4NCj4gVGhlcmUgc2hvdWxkIG5vdCBi
ZSBhIG5ld2xpbmUgaGVyZSBhbmQNCj4gdGhlcmUgd2FzIG5vIG5ld2xpbmUgaW4gdGhlIHBhdGNo
IEkgc2VudC4NCj4gDQoNCkhpIEpvZSwNCg0KWW91ciBwYXRjaCBkaWRuJ3QgYXBwbHkgY2xlYW5s
eSBvbiB0b3Agb2YgbmV0LW5leHQtbWx4NSwgc2luY2UgdGhlcmUNCndlcmUgc29tZSBhbHJlYWR5
IGFjY2VwdGVkIHBhdGNoZXMgdG91Y2hpbmcgdGhlIHNhbWUgcGxhY2VzLCBzbyBpIHRvb2sNCnRo
ZSBsaWJlcnR5IHRvIG1ha2UgdGhlIG5lY2Vzc2FyeSBjaGFuZ2VzIGZvciBpdCB0byBhcHBseS4u
DQoNCnlvdSBtYWtlIHRoZSBjYWxsOg0KDQoxKSBJIGNhbiByZS1hcnJhbmdlIHRoaW5ncyBpbiBv
cmRlciB0byBtYWtlIHlvdXIgcGF0Y2ggYXBwZWFyIGFzIGl0DQp3YXMsIEFsdGhvdWdoIGRvbid0
IHNlZSBhbnkgcmVhc29uIG9mIGRvaW5nIHRoaXMsIHNpbmNlIGl0IHdpbGwgYmUgYQ0KbG90IG9m
IHdvcmsgZm9yIG5vdGhpbmcuLiANCg0KMikga2VlcCBpdCBhcyBpcywgYW5kIGZpeCB3aGF0ZXZl
ciB5b3UgZG9uJ3QgbGlrZSBhYm91dCB0aGUgY3VycmVudA0Kc3RhdGUgb2YgdGhlIHBhdGNoLiAo
cmVtb3ZlIHRoZSBuZXdsaW5lKS4uIA0KDQpUaGFua3MsDQpTYWVlZC4NCg==

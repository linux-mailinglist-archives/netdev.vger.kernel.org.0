Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0786DF0A6A
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 00:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730207AbfKEXsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 18:48:20 -0500
Received: from mail-eopbgr80058.outbound.protection.outlook.com ([40.107.8.58]:15175
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729583AbfKEXsU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 18:48:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jdfs9+8br+/f2mqjC6uMvKhg+zneclpeQuCVUQSltuIXDITHxmREIMiNKEcvaGWE4P1SOmfKXTTV2or3DNkk7fKP9cvE4SBE1yCUwrLJ1Qp7YnokNSZwB39Xh76ly3F25GdN1C4e4ZSMD86E+owtI7UPz1MI7odZd5y0mfqZdlDwkbW4h2QAJ7JAt1U5hgunp/9FGzVsNdfqgr/y6g4E/P7NXtIaN5CVl29pUGM0B/+mBM9nfQNIj2XP+PLDwUDdP6xDdBat7yr0fgO68V/CZVqP4x6DXCpU51mHj4zaNlFwe1NZxwAvYhJVVThyjV+WqRihZ9PCXOqsUMDSBMS/UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sPe67+505RXOzbtx2sgPFQXpztvMxwn1x8orGBrmQSM=;
 b=lyE+G7N+z/ShFpCSIiaL3edMR2fxLJxgaGLfVeM7oiv0gD+nbMWjZCt0WhtxRY6wu0o6EmjrEexklqzvp9S89O3fpRJAhLNQS38z8oeUIe7+vcRbcX+Rpchwcd7kGEHWBQ+aMs1xHoYqQ9kL5LXI644DkZ9kWt0P/kd9x0LnvIhGFpDlYTWnmLVgEtjxJvIcb8uq+4qk4mRlFNVUrQMlEHwCslZAZpz7fOV9IVT0zHda4QmOGyP/Ks97OP6Ua9Ras1PVnMNPAYL9jm+RFQgZScuoj9RuuUrc931LG7485QS94xJpVTuGb7xv1W2oHYPw2gWYU8ejGapJ1rh84jvqtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sPe67+505RXOzbtx2sgPFQXpztvMxwn1x8orGBrmQSM=;
 b=eTeLP3YF5d9SPGRxS3LodSQfhWmnoaZ2pR5aDh/ufxhe25EOCbrcb1tXr0it4XiKz7PGOWoyPePZMFfvHcRUkJ9Y4NoJIE3hc3sCK+861Shd6vDvdJe5Ez8XvyCA7nUeUT88vmjTHivxgODxh1QdfcTOlHMTPsUlZe8tyQYRPRg=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6224.eurprd05.prod.outlook.com (20.178.120.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Tue, 5 Nov 2019 23:48:15 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 23:48:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     "sbrivio@redhat.com" <sbrivio@redhat.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: Re: [PATCH net-next v2 0/3] VGT+ support
Thread-Topic: [PATCH net-next v2 0/3] VGT+ support
Thread-Index: AQHVkCQFGdJo5Spx4U2AGUa6mmGmtKd1dOQAgAFEboCAABz2AIAAMEAAgATMggCAAAKoAIAADVYAgAEmsACAAB2BAIAAD9YAgAAFGYCAAAqIgA==
Date:   Tue, 5 Nov 2019 23:48:15 +0000
Message-ID: <a4f5771089f23a5977ca14d13f7bfef67905dc0a.camel@mellanox.com>
References: <1572551213-9022-1-git-send-email-lariel@mellanox.com>
         <20191031172330.58c8631a@cakuba.netronome.com>
         <8d7db56c-376a-d809-4a65-bfc2baf3254f@mellanox.com>
         <6e0a2b89b4ef56daca9a154fa8b042e7f06632a4.camel@mellanox.com>
         <20191101172102.2fc29010@cakuba.netronome.com>
         <358c84d69f7d1dee24cf97cc0ad6fe59d5c313f5.camel@mellanox.com>
         <78befeac-24b0-5f38-6fd6-f7e1493d673b@gmail.com>
         <20191104183516.64ba481b@cakuba.netronome.com>
         <3da1761ec4a15db87800a180c521bbc7bf01a5b2.camel@mellanox.com>
         <20191105135536.5da90316@cakuba.netronome.com>
         <8c740914b7627a10e05313393442d914a42772d1.camel@mellanox.com>
         <20191105151031.1e7c6bbc@cakuba.netronome.com>
In-Reply-To: <20191105151031.1e7c6bbc@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cc23eb8d-ca37-41c9-a8b0-08d7624aa091
x-ms-traffictypediagnostic: VI1PR05MB6224:|VI1PR05MB6224:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB62249BF799C1ADCD827E50ADBE7E0@VI1PR05MB6224.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(189003)(199004)(2906002)(118296001)(316002)(6486002)(486006)(71200400001)(71190400001)(81166006)(186003)(36756003)(81156014)(8936002)(6506007)(229853002)(476003)(3846002)(66066001)(6116002)(26005)(58126008)(8676002)(64756008)(66446008)(6436002)(76176011)(102836004)(66476007)(5640700003)(66556008)(478600001)(5660300002)(25786009)(99286004)(2351001)(2501003)(107886003)(54906003)(66946007)(91956017)(76116006)(446003)(14454004)(305945005)(7736002)(256004)(6512007)(6246003)(11346002)(2616005)(86362001)(6916009)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6224;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: etoH20zmcVZLKT7lE+Go2eSC3hGaq4/9OTnmPb658kGBZ3nsB3UKLRFjUdE5LXnMjq/rFoC2W3L2oqQqsS/gSc0yEysyos8VQvBi69M5R9JVDvZPb7FRl++ws9oE1Qwf5c5LVh4jsaS82lxo3eRheFyR/dNsqIpLZezZwiVsESk0uUlNOByb4pGa67emdB/zPfRt0VGaCr8qtfR0JWx0GPZFGodI9n7zN8vdl7mWEPJAoxXgUTCcr4kZuVGfy885oNo2/AWuLxuQb9viJJNAjVCRPf6UY/Jj8NnDVV0YBco4i6ke4UHpDujuhYIFiLBoxDlCvRNrKAnDJmRp2MrMiHEDEHsMoUCReRyLkqLMeSKTtD9v+3gywnJfK1owB7KdSkl8i2ADeoal37xKH6EeLEdihScEvNopLjdKY7sfmfBy+BULMMtnZHCm6SOJ/tZT
Content-Type: text/plain; charset="utf-8"
Content-ID: <8F072A4AC26EE840835E0F6A1C6AF05E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc23eb8d-ca37-41c9-a8b0-08d7624aa091
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 23:48:15.5797
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ukKhMM0IybyPOSA4GakDXuZhazUz3RDAZA4jkaQOy7l6ibPuViq0OIaGOm/GvlkBV5EK2+mishVTJ8YePQ5EiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6224
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTExLTA1IGF0IDE1OjEwIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCA1IE5vdiAyMDE5IDIyOjUyOjE4ICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiA+ID4gaXQgc2hvdWxkIGJlIGp1c3QgbGlrZSBldGh0b29sIHdlIHdhbnQgdG8gdG8g
cmVwbGFjZSBpdCBidXQgd2UNCj4gPiA+ID4ga25vdw0KPiA+ID4gPiB3ZSBhcmUgbm90IHRoZXJl
IHlldCwgc28gd2UgY2FyZWZ1bGx5IGFkZCBvbmx5IG5lY2Vzc2FyeSB0aGluZ3MNCj4gPiA+ID4g
d2l0aA0KPiA+ID4gPiBsb3RzIG9mIGF1ZGl0aW5nLCBzYW1lIHNob3VsZCBnbyBoZXJlLiAgDQo+
ID4gPiANCj4gPiA+IFdvcmtlZCBvdXQgYW1hemluZ2x5IGZvciBldGh0b29sLCByaWdodD8gIA0K
PiA+IA0KPiA+IE9idmlvdXNseSwgbm8gb25lIHdvdWxkIGhhdmUgYWdyZWVkIHRvIHN1Y2ggdG90
YWwgc2h1dGRvd24gZm9yDQo+ID4gZXRodG9vbCwNCj4gPiB3ZSBldmVudHVhbGx5IGRlY2lkZWQg
bm90IHRvIGJsb2NrIGV0aHRvb2wgdW5sZXNzIHdlIGhhdmUgdGhlDQo+ID4gbmV0bGluaw0KPiA+
IGFkYXB0ZXIgd29ya2luZyAuLiBsZWdhY3kgbW9kZSBzaG91bGQgZ2V0IHRoZSBzYW1lIHRyZWF0
bWVudC4NCj4gPiANCj4gPiBCb3R0b20gbGluZSBmb3IgdGhlIHNhbWUgcmVhc29uIHdlIGRlY2lk
ZWQgdGhhdCBldGh0b29sIGlzIG5vdA0KPiA+IHRvdGFsbHkNCj4gPiBkZWFkIHVudGlsIGV0aHRv
b2wgbmV0bGluayBpbnRlcmZhY2UgaXMgY29tcGxldGUsIHdlIHNob3VsZCBzdGlsbA0KPiA+IHN1
cHBvcnQgc2VsZWN0aXZlIGFuZCBiYXNpYyBzcmlvdiBsZWdhY3kgbW9kZSBleHRlbnNpb25zIHVu
dGlsDQo+ID4gYnJpZGdlDQo+ID4gb2ZmbG9hZHMgaXMgY29tcGxldGUuIA0KPiANCj4gQnV0IHN3
aXRjaGRldiBfaXNfIF9oZXJlXy4gX1RvZGF5Xy4gRnJvbSB1QVBJIHBlcnNwZWN0aXZlIGl0J3Mg
ZG9uZSwNCj4gYW5kIHJlYWR5LiBXZSdyZSBtaXNzaW5nIHRoZSBkcml2ZXIgYW5kIHVzZXIgc3Bh
Y2UgcGFydHMsIGJ1dCBubyBjb3JlDQo+IGFuZCB1QVBJIGV4dGVuc2lvbnMuIEl0J3MganVzdCBM
MiBzd2l0Y2hpbmcgYW5kIHRoZXJlJ3MgcXVpdGUgYSBmZXcNCj4gc3dpdGNoIGRyaXZlcnMgdXBz
dHJlYW0sIGFzIEknbSBzdXJlIHlvdSBrbm93IDovIA0KPiANCg0KSSBjYW4gc2F5IHRoZSBzYW1l
IGFib3V0IG5ldGxpbmssIGl0IGFsc28gd2FzIHRoZXJlLCB0aGUgbWlzc2luZyBwYXJ0DQp3YXMg
dGhlIG5ldGxpbmsgZXRodG9vbCBjb25uZWN0aW9uIGFuZCB1c2Vyc3BhY2UgcGFydHMgLi4gDQoN
Ckp1c3QgYmVjYXVzZSBzd2l0Y2hkZXYgdUFQSSBpcyBwb3dlcmZ1bCBlbm91Z2ggdG8gZG8gYW55
dGhpbmcgaXQNCmRvZXNuJ3QgbWVhbiB3ZSBhcmUgcmVhZHksIHlvdSBzYWlkIGl0LCB1c2VyIHNw
YWNlIGFuZCBkcml2ZXJzIGFyZSBub3QNCnJlYWR5LCBhbmQgZnJhbmtseSBpdCBpcyBub3Qgb24g
dGhlIHJvYWQgbWFwLCBhbmQgd2UgYWxsIGtub3cgdGhhdCBpdA0KY291bGQgdGFrZSB5ZWFycyBi
ZWZvcmUgd2UgY2FuIHNpdCBiYWNrIGFuZCByZWxheCB0aGF0IHdlIGdvdCBvdXIgTDINCnN3aXRj
aGluZyAuLiBKdXN0IGxpa2Ugd2hhdCBpcyBoYXBwZW5pbmcgbm93IHdpdGggZXRodG9vbCwgaXQg
YmVlbg0KeWVhcnMgeW91IGtub3cuLiANCg0KPiBldGh0b29sIGlzIG5vdCByZWFkeSBmcm9tIHVB
UEkgcGVyc3BlY3RpdmUsIHN0aWxsLg0KPiANCg0KZXRob29sIGlzIGJ5IGRlZmluaXRpb24gYSB1
QVBJIG9ubHkgdG9vbCwgeW91IGNhbid0IGNvbXBhcmUgdGhlDQp0ZWNobmljYWwgZGV0YWlscyBh
bmQgY2hhbGxlbmdlcyBvZiBib3RoIGlzc3VlLCBlYWNoIG9uZSBoYXMgZGlmZmVyZW50DQpjaGFs
bGVuZ2VzLCB3ZSBuZWVkIHRvIGNvbXBhcmUgY29tcGxleGl0eSBhbmQgZGVwcmVjYXRpb24gcG9s
aWN5IGltcGFjdA0Kb24gY29uc3VtZXJzLg0KDQo+IEl0J2QgYmUgbW9yZSBhY2N1cmF0ZSB0byBj
b21wYXJlIHRvIGxlZ2FjeSBJT0NUTHMsIGxpa2UgYXJndWluZyB0aGF0IA0KPiB3ZSBuZWVkIGEg
c21hbGwgdHdlYWsgdG8gSU9DVExzIHdoZW4gTmV0bGluayBpcyBhbHJlYWR5IHRoZXJlLi4NCg0K
V2VsbCwgbm8sIFRoZSByaWdodCBhbmFsb2cgaGVyZSB3b3VsZCBiZToNCg0KbmV0bGluayA9PSBz
d2l0Y2hkZXYgbW9kZQ0KZXRodG9vbCA9PSBsZWdhY3kgbW9kZQ0KbmV0bGluay1ldGh0b29sLWlu
dGVyZmFjZSA9PSBMMiBicmlkZ2Ugb2ZmbG9hZHMgDQoNCnlvdSBkbyB0aGUgbWF0aC4NCg0KSXQg
aXMgbm90IGFib3V0IHVBUEksIHVBUEkgY291bGQgYmUgcmVhZHkgZm9yIHN3aXRjaGRldiBtb2Rl
LCBtYXliZSwgaXQNCmp1c3Qgbm8gb25lIGV2ZW4gZ2F2ZSB0aGlzIGEgcmVhbCBzZXJpb3VzIHRo
b3VnaHQsIHNvIGkgY2FuJ3QgYWNjZXB0DQp0aGF0IGJyaWRnZSBvZmZsb2FkcyBpcyBqdXN0IGFy
b3VuZCB0aGUgY29ybmVyIGp1c3QgYmVjYXVzZSBzd2l0Y2hkZXYNCnVBUEkgZmVlbHMgbGlrZSBy
ZWFkeSB0byBkbyBhbnl0aGluZywgaXQgaXMgc2VyaW91c2x5IG5vdC4NCg0KDQoNCg==

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 631B9F2189
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 23:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfKFWVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 17:21:42 -0500
Received: from mail-eopbgr30054.outbound.protection.outlook.com ([40.107.3.54]:17408
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726798AbfKFWVm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 17:21:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZF2Dw9g8jWhNdL4VvE46iwidvvqgUyTo2b6QQiH37vLTzCTtyLQunW5zV33nb3xTI9tEShdHyD0djnBx4Z/zRqZAH0C0QfZlaz5GirC4V4vZ+k47//f8Zl8fWYGrgvvWlIaB+dEvGqq9vx+zR+f+ezUNl60HBW0NB3ptbq+fMVpEBNAi+qx/tK15PotKK0HJnJOA6SaAB0JheF0MIu9/fgTUIRI75kwOyWeOYCwKaxoK8upSRl0/8Vno7CX2yKKQ8TpjqFmZOsscS+T4ZuaN4GGDmf+V5gh+eHCwbpKQ+KM8YagnQlY9tdi6Yb5w1g+XCGai1ddPuzXVsHx6zL8giA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/5ghtyqk3kZL+Du/lKwXEBBYwa5+YTbVBNYXHUQnF7o=;
 b=c7E11XsQaQ1nkVaiLZ1prwr3U6aJIJ/GselmhLphAchVjMwSJkFbvSyYrL/PZaJWKgc0hzHGLJ7rzVv9mSey0j0+uqZ4b3AklVzhhFksUnF/G4D3mPZ0cgMDwmtMgOisbjVWBWPEuDKCGHJlNfbysXlYPto01VdHN6brMRqOf30b2jLjuSDK2maMivpevvy4Z5zsyOAEkl3ooAUwWnKVEWoSMXWJ3vR3zRZcb6B1LTQ8SOv9xTbLQualJas7cnpG0wOiQ3QrOIeEuTcbtc2ddCMRlJv8sXLASaymzoVvCyv/nRsMcY3zzGtAE1eZUjJHSO1VSeObh7bfMZ+AzZPpbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/5ghtyqk3kZL+Du/lKwXEBBYwa5+YTbVBNYXHUQnF7o=;
 b=R8WAHIyq++1a4FpKCjoybB52I1WEZAHuElyJKBJEfJZA9y67b5ifJlf1qiMMSQCkDU2Y36zsXrD5zfUZwOyqztWmc16Mexti8vcdpTf7fTo94DHIhV9lCz4If9oHDouNcyHjY6ppUgMoHLi/6bv83hqxgJn0yCp6nWqZB7shFGA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4190.eurprd05.prod.outlook.com (52.134.30.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Wed, 6 Nov 2019 22:21:37 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Wed, 6 Nov 2019
 22:21:37 +0000
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
Thread-Index: AQHVkCQFGdJo5Spx4U2AGUa6mmGmtKd1dOQAgAFEboCAABz2AIAAMEAAgATMggCAAAKoAIAADVYAgAEmsACAAB2BAIAAD9YAgAAFGYCAAAqIgIAAHt6AgAFbQgA=
Date:   Wed, 6 Nov 2019 22:21:37 +0000
Message-ID: <c5bedde710b0667fd44213d8c64e65f6870a2f07.camel@mellanox.com>
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
         <a4f5771089f23a5977ca14d13f7bfef67905dc0a.camel@mellanox.com>
         <20191105173841.43836ad7@cakuba.netronome.com>
In-Reply-To: <20191105173841.43836ad7@cakuba.netronome.com>
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
x-ms-office365-filtering-correlation-id: 1ad2008d-0ea6-4136-44ab-08d76307b076
x-ms-traffictypediagnostic: VI1PR05MB4190:|VI1PR05MB4190:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4190CC835265DCE453CAE29DBE790@VI1PR05MB4190.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(199004)(189003)(486006)(6506007)(66066001)(71200400001)(71190400001)(476003)(6436002)(2616005)(6486002)(11346002)(6512007)(54906003)(107886003)(76116006)(118296001)(66946007)(446003)(316002)(66476007)(66556008)(66446008)(64756008)(58126008)(6246003)(256004)(91956017)(5640700003)(2906002)(26005)(478600001)(229853002)(86362001)(99286004)(4326008)(186003)(6916009)(25786009)(36756003)(14454004)(102836004)(2501003)(7736002)(8676002)(6116002)(81166006)(81156014)(3846002)(76176011)(305945005)(5660300002)(8936002)(2351001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4190;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1DVJjdMB/F77EBjau+o3MAtJwYpv+5KzaIBo2u8vSYmi1wxk7zvmhYIZg5seuARedhRqJQjDxrKG+vbYE8sBqF9NhtZa6q7YxCbN8Xt8EyYStDsQYf62wPdgYXIjYDAfP3BSYMin4pYUklA62TuQ4zNQPBaNuzdX+y9vcjwaccIc+PguwaojfwkWi07J0uXzt/K8ly2nUv+195zJ9Rq9/IYdpPGKPP1QXz5ctqHlagU3a3OsRmXcPooKIUsjut2Wf94vtyR6bUWG7uXi/Wcj+POx6ITlxS0+6X8O7YvoAJRarht4W98C3tnSGjnOWb8Dh+ybvst35ItFLI2D+f+CxzIa3wdexfVorlrKZCwQPekBrAjbGKBuOz6o/M2rdsGyGeVxW/5znHBQmFNEZQ69hnsnxl8Ye7CsM09ERFqGavA37l8RedrGSPOiX2V3jBBK
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A955ED71AF8C042B01A5B451E54288F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ad2008d-0ea6-4136-44ab-08d76307b076
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 22:21:37.1476
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MPnARA6AuaG22O9oJZRXcFkc2KwyJPzLsT+STfKO56O3U8aoDAnu7BlBiGokEX++BDa68uPs/WNKMl3q9X6DAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4190
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTExLTA1IGF0IDE3OjM4IC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCA1IE5vdiAyMDE5IDIzOjQ4OjE1ICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBPbiBUdWUsIDIwMTktMTEtMDUgYXQgMTU6MTAgLTA4MDAsIEpha3ViIEtpY2luc2tp
IHdyb3RlOg0KPiA+ID4gQnV0IHN3aXRjaGRldiBfaXNfIF9oZXJlXy4gX1RvZGF5Xy4gRnJvbSB1
QVBJIHBlcnNwZWN0aXZlIGl0J3MNCj4gPiA+IGRvbmUsDQo+ID4gPiBhbmQgcmVhZHkuIFdlJ3Jl
IG1pc3NpbmcgdGhlIGRyaXZlciBhbmQgdXNlciBzcGFjZSBwYXJ0cywgYnV0IG5vDQo+ID4gPiBj
b3JlDQo+ID4gPiBhbmQgdUFQSSBleHRlbnNpb25zLiBJdCdzIGp1c3QgTDIgc3dpdGNoaW5nIGFu
ZCB0aGVyZSdzIHF1aXRlIGENCj4gPiA+IGZldw0KPiA+ID4gc3dpdGNoIGRyaXZlcnMgdXBzdHJl
YW0sIGFzIEknbSBzdXJlIHlvdSBrbm93IDovIA0KPiA+IA0KPiA+IEkgY2FuIHNheSB0aGUgc2Ft
ZSBhYm91dCBuZXRsaW5rLCBpdCBhbHNvIHdhcyB0aGVyZSwgdGhlIG1pc3NpbmcNCj4gPiBwYXJ0
DQo+ID4gd2FzIHRoZSBuZXRsaW5rIGV0aHRvb2wgY29ubmVjdGlvbiBhbmQgdXNlcnNwYWNlIHBh
cnRzIC4uIA0KPiANCj4gdUFQSSBpcyB0aGUgcGFydCB0aGF0IG1hdHRlcnMuIE5vIGRyaXZlciBp
bXBsZW1lbnRzIGFsbCB0aGUgQVBJcy4gDQo+IEknbSB0ZWxsaW5nIHlvdSB0aGF0IHRoZSBBUEkg
Zm9yIHdoYXQgeW91J3JlIHRyeWluZyB0byBjb25maWd1cmUNCj4gYWxyZWFkeSBleGlzdHMsIGFu
ZCB5b3VyIGRyaXZlciBzaG91bGQgdXNlIGl0LiBEcml2ZXIncyB0ZWNobmljYWwgDQo+IGRlYnQg
aXMgbm90IG15IGNvbmNlcm4uDQo+IA0KPiA+IEp1c3QgYmVjYXVzZSBzd2l0Y2hkZXYgdUFQSSBp
cyBwb3dlcmZ1bCBlbm91Z2ggdG8gZG8gYW55dGhpbmcgaXQNCj4gPiBkb2Vzbid0IG1lYW4gd2Ug
YXJlIHJlYWR5LCB5b3Ugc2FpZCBpdCwgdXNlciBzcGFjZSBhbmQgZHJpdmVycyBhcmUNCj4gPiBu
b3QNCj4gPiByZWFkeSwgYW5kIGZyYW5rbHkgaXQgaXMgbm90IG9uIHRoZSByb2FkIG1hcCwgDQo+
IA0KPiBJIGJldCBpdCdzIG5vdCBvbiB0aGUgcm9hZCBtYXAuIFByb2R1Y3QgbWFya2V0aW5nIHNl
ZXMgb25seSBsZWdhY3kNCj4gU1ItSU9WICh0YWJsZSBzdGFrZXMpIGFuZCBPdlMgb2ZmbG9hZCA9
PSBzd2l0Y2hkZXYgKHZhbHVlIGFkZCkuIA0KPiBMMiBzd2l0Y2hkZXYgd2lsbCBuZXZlciBiZSBp
bXBsZW1lbnRlZCB3aXRoIHRoYXQgbWluZCBzZXQuDQo+IA0KPiBJbiB0aGUgdXBzdHJlYW0gY29t
bXVuaXR5LCBob3dldmVyLCB3ZSBjYXJlIGFib3V0IHRoZSB0ZWNobmljYWwNCj4gYXNwZWN0cy4N
Cj4gDQo+ID4gYW5kIHdlIGFsbCBrbm93IHRoYXQgaXQgY291bGQgdGFrZSB5ZWFycyBiZWZvcmUg
d2UgY2FuIHNpdCBiYWNrIGFuZA0KPiA+IHJlbGF4IHRoYXQgd2UgZ290IG91ciBMMiBzd2l0Y2hp
bmcgLi4gDQo+IA0KPiBMZXQncyBub3QgYmUgZHJhbWF0aWMuIEl0IHNob3VsZG4ndCB0YWtlIHll
YXJzIHRvIGltcGxlbWVudCBiYXNpYyBMMg0KPiBzd2l0Y2hpbmcgb2ZmbG9hZC4NCj4gDQo+ID4g
SnVzdCBsaWtlIHdoYXQgaXMgaGFwcGVuaW5nIG5vdyB3aXRoIGV0aHRvb2wsIGl0IGJlZW4geWVh
cnMgeW91DQo+ID4ga25vdy4uDQo+IA0KPiBFeGFjdGx5IG15IHBvaW50ISEhIE5vYm9keSBpcyBn
b2luZyB0byBsaWZ0IGEgZmluZ2VyIHVubGVzcyB0aGVyZSBpcw0KPiBhDQo+IGxvdWQgYW5kIHJl
c291bmRpbmcgIm5vIi4NCj4gDQoNCk9rIHRoZW4sICJubyIgbmV3IHVBUEksIGFsdGhvdWdoIGkg
c3RpbGwgdGhpbmsgdGhlcmUgc2hvdWxkIGJlIHNvbWUNCnNwZWNpYWwgY2FzZXMgdG8gYmUgYWxs
b3dlZCwgYnV0IC4uLiB5b3VyIGNhbGwuDQoNCkluIHRoZSBtZWFud2hpbGUgaSB3aWxsIGZpZ3Vy
ZSBvdXQgc29tZXRoaW5nIHRvIGJlIGRyaXZlciBvbmx5IGFzDQppbnRlcm1lZGlhdGUgc29sdXRp
b24gdW50aWwgd2UgaGF2ZSBmdWxsIGwyIG9mZmxvYWQsIHRoZW4gaSBjYW4gYXNrDQpldmVyeSBv
bmUgdG8gbW92ZSB0byBmdWxsIHN3aXRjaGRldiBtb2RlIHdpdGggYSBwcmVzcyBvZiBhIGJ1dHRv
bi4NCg0K

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E178FBAE6
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 22:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfKMVfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 16:35:51 -0500
Received: from mail-eopbgr50055.outbound.protection.outlook.com ([40.107.5.55]:63725
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726162AbfKMVfv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 16:35:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOp0ORx8RkxbRvd1c4L04O0C3TFJghIu7qQiLHZbbWox4SXOqwOh6tUK8JboatFBTxVhbawOhVfEr8pvQYVWZtCaE7llF3Y2DP8FJ6XpFPOO3wVpTtqjvwJUvxcEXWehsuRmMYFFUpJG83+v3HL5+H5JmCziqlv7hXL67rPt8Ms7M9IfwIHk+7S9tOIV4T1hHcFR+T1ugIXrl/36JfXMvhSpIs07yQ+pknlC8XQJI4n7YLf+Z8f8GwdU+3x7E8bLKMII85gPQUwbPmSoVFnjzkQRVtwdUa62/nF1EC/dANoDm7naQFI6LgkyBHZuhdVOkJt4klpybwrCmhZTMGhXwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3H9Pzrm8tnwdr83gtsLcIspFN/xiBeqDPVVvVXpjpRg=;
 b=fB3Fy24XkPsp3Hm4eb9DlhmvgfJ8wFitgf8Prt1KIqtQwwOE1znnDO79zU8lCPdI9G8bQCIE88AUKRAJ/PZ0Si/dy6Ll1SPKT15LmM6clj6QTdOZ7qlqHjzdczYYXB3eFQ8DpltB5WmCm0Xx49uzIXvfC+GUceuDkrqN4ssGSz2goXj6ZpvYD+6etjfxG7ozPEJBjQ+Ekt0jvSJn+tjzTRCV/qkNBXTV6gtvX9fEDPCkn1k7l+X1zAMQDFh8pubtgD7e16qGiHLF9pit+/sgpgAi0BgsiC0mCaqwE86LhRh37z5zMmvZFjufIKVfxIEXS3uLvSrl8MtT+94zHkr53Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3H9Pzrm8tnwdr83gtsLcIspFN/xiBeqDPVVvVXpjpRg=;
 b=TKqvXyL0wFWCem99Uv3+YJKth3hydqlMv/ZInGMLZ4zT8vWiqZOjzGWM6gk8ETDFC4I4JLgoSDHRCcNFfi1vxHIwsTvuOkQOAn5unOaPhRBsxgighjdw47BawtiuQeQUW8qs5gX+vaRVJsANIrMrHG4ktTTaCafcbCH1UkY+us0=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4799.eurprd05.prod.outlook.com (20.176.4.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Wed, 13 Nov 2019 21:35:46 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.028; Wed, 13 Nov 2019
 21:35:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "saeedm@dev.mellanox.co.il" <saeedm@dev.mellanox.co.il>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     Ariel Levkovich <lariel@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next 8/8] net/mlx5: Add vf ACL access via tc flower
Thread-Topic: [net-next 8/8] net/mlx5: Add vf ACL access via tc flower
Thread-Index: AQHVmXyPyqE/Va6H+0ubcUl9o7BswqeIMmoAgAAN8oCAAUwJgIAAFTyA
Date:   Wed, 13 Nov 2019 21:35:45 +0000
Message-ID: <964654710719bc5b88c18a55696e8c98ba4caff0.camel@mellanox.com>
References: <20191112171313.7049-1-saeedm@mellanox.com>
         <20191112171313.7049-9-saeedm@mellanox.com>
         <20191112154124.4f0f38f9@cakuba>
         <CALzJLG8ZiBdibjwY+xg0iBgqoEC1BFLcejTyHZYfsfbB7d20cQ@mail.gmail.com>
         <20191113121943.4df01958@cakuba>
In-Reply-To: <20191113121943.4df01958@cakuba>
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
x-ms-office365-filtering-correlation-id: 16b1e630-f458-4d5a-6130-08d768817179
x-ms-traffictypediagnostic: VI1PR05MB4799:|VI1PR05MB4799:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB47990AC11522DE562964AF9BBE760@VI1PR05MB4799.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(189003)(199004)(476003)(7736002)(446003)(58126008)(71190400001)(316002)(86362001)(26005)(99286004)(486006)(36756003)(102836004)(478600001)(186003)(118296001)(14454004)(76176011)(4001150100001)(53546011)(6506007)(2501003)(71200400001)(11346002)(64756008)(2616005)(66446008)(76116006)(91956017)(66476007)(66946007)(54906003)(305945005)(66556008)(110136005)(25786009)(256004)(14444005)(6486002)(229853002)(8676002)(2906002)(81156014)(81166006)(6436002)(6116002)(3846002)(6246003)(8936002)(66066001)(4326008)(6512007)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4799;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YQXlRfTdGAQNzpkoeoFqWSUCGquLDe8rQTPbGQTU7tId5haDunhdKMVI0sZxTeRxqSxOPHIzK3kr3fzUM3mZ0tjWT9Ouy5dlRl1BWGFLNREGqw/RVTcDJ01MYNlOutaTCSHBp0E2MUsfdoEkFoTd1tPyowWvbe4z9OtbB8pTgpflycS26weIAiGdD58tAPN+IWf3lt/3r3laHExRzahMB4cIJxMt2oxZXL9V30o9ScUoDpuJIeXdOpeQ17Lv7GTPXQ8VhlsHsBZHtR5JRcIspPcvGbtPm2Zp3vvtls9KPEFCxCeqbz+z9xOmiLiB7nOg8HppXCUfo5Kii7MLl/HxsKsynlPlzboozXwl3aFjHc2iEVAScwgZQ2jIRvPbhTAP1DaGr/smvXNdSCKhZTTSXBA9J3kMBmWthK4XkqJlZ6LUjXbtr+MC2veWd0s7NR3H
Content-Type: text/plain; charset="utf-8"
Content-ID: <43FA11C5D19F6046BAB7C78E7E377513@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16b1e630-f458-4d5a-6130-08d768817179
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 21:35:45.7965
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oRDIwVCmVusECukRcDM+2jyyonUBSu8mNnItnqb53AVQIqslbIFTwB3KG0UdyvOuWwuy4eNUC3+FtZywMEdPww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4799
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTExLTEzIGF0IDEyOjE5IC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCAxMiBOb3YgMjAxOSAxNjozMToxOSAtMDgwMCwgU2FlZWQgTWFoYW1lZWQgd3Jv
dGU6DQo+ID4gT24gVHVlLCBOb3YgMTIsIDIwMTkgYXQgMzo0MSBQTSBKYWt1YiBLaWNpbnNraSB3
cm90ZToNCj4gPiA+IE9uIFR1ZSwgMTIgTm92IDIwMTkgMTc6MTM6NTMgKzAwMDAsIFNhZWVkIE1h
aGFtZWVkIHdyb3RlOiAgDQo+ID4gPiA+IEZyb206IEFyaWVsIExldmtvdmljaCA8bGFyaWVsQG1l
bGxhbm94LmNvbT4NCj4gPiA+ID4gDQo+ID4gPiA+IEltcGxlbWVudGluZyB2ZiBBQ0wgYWNjZXNz
IHZpYSB0YyBmbG93ZXIgYXBpIHRvIGFsbG93DQo+ID4gPiA+IGFkbWlucyBjb25maWd1cmUgdGhl
IGFsbG93ZWQgdmxhbiBpZHMgb24gYSB2ZiBpbnRlcmZhY2UuDQo+ID4gPiA+IA0KPiA+ID4gPiBU
byBhZGQgYSB2bGFuIGlkIHRvIGEgdmYncyBpbmdyZXNzL2VncmVzcyBBQ0wgdGFibGUgd2hpbGUN
Cj4gPiA+ID4gaW4gbGVnYWN5IHNyaW92IG1vZGUsIHRoZSBpbXBsZW1lbnRhdGlvbiBpbnRlcmNl
cHRzIHRjIGZsb3dzDQo+ID4gPiA+IGNyZWF0ZWQgb24gdGhlIHBmIGRldmljZSB3aGVyZSB0aGUg
Zmxvd2VyIG1hdGNoaW5nIGtleXMgaW5jbHVkZQ0KPiA+ID4gPiB0aGUgdmYncyBtYWMgYWRkcmVz
cyBhcyB0aGUgc3JjX21hYyAoZXN3aXRjaCBpbmdyZXNzKSBvciB0aGUNCj4gPiA+ID4gZHN0X21h
YyAoZXN3aXRjaCBlZ3Jlc3MpIHdoaWxlIHRoZSBhY3Rpb24gaXMgYWNjZXB0Lg0KPiA+ID4gPiAN
Cj4gPiA+ID4gSW4gc3VjaCBjYXNlcywgdGhlIG1seDUgZHJpdmVyIGludGVycGV0cyB0aGVzZSBm
bG93cyBhcyBhZGRpbmcNCj4gPiA+ID4gYSB2bGFuIGlkIHRvIHRoZSB2ZidzIGluZ3Jlc3MvZWdy
ZXNzIEFDTCB0YWJsZSBhbmQgdXBkYXRlcw0KPiA+ID4gPiB0aGUgcnVsZXMgaW4gdGhhdCB0YWJs
ZSB1c2luZyBlc3dpdGNoIEFDTCBjb25maWd1cmF0aW9uIGFwaQ0KPiA+ID4gPiB0aGF0IGlzIGlu
dHJvZHVjZWQgaW4gYSBwcmV2aW91cyBwYXRjaC4gIA0KPiA+ID4gDQo+ID4gPiBOYWNrLCB0aGUg
bWFnaWMgaW50ZXJwcmV0YXRpb24gb2YgcnVsZXMgaW5zdGFsbGVkIG9uIHRoZSBQRiBpcyBhDQo+
ID4gPiBubyBnby4gIA0KPiA+IA0KPiA+IFBGIGlzIHRoZSBlc3dpdGNoIG1hbmFnZXIgaXQgaXMg
bGVnaXQgZm9yIHRoZSBQRiB0byBmb3J3YXJkIHJ1bGVzDQo+ID4gdG8NCj4gPiB0aGUgZXN3aXRj
aCBGREIsDQo+ID4gd2UgZG8gaXQgYWxsIG92ZXIgdGhlIHBsYWNlLCB0aGlzIGlzIGhvdyBBTEwg
bGVnYWN5IG5kb3Mgd29yaywgd2h5DQo+ID4gdGhpcyBzaG91bGQgYmUgdHJlYXRlZCBkaWZmZXJl
bnRseSA/DQo+IA0KPiBJdCdzIG5vdCBhIGxlZ2FjeSBORE8sIHRoZXJlJ3MgbGl0dGxlIHByZWNl
ZGVudCBmb3IgaXQsIGFuZCB5b3UncmUNCj4gaW52ZW50aW5nIGEgbmV3IG1lYW5pbmcgZm9yIGFu
IG9wZXJhdGlvbi4NCj4gDQo+ID4gQW55d2F5IGp1c3QgZm9yIHRoZSByZWNvcmQsIEkgZG9uJ3Qg
dGhpbmsgeW91IGFyZSBiZWluZyBmYWlyIGhlcmUsDQo+ID4geW91DQo+ID4ganVzdCBjb21lIHVw
IHdpdGggcnVsZXMgb24gdGhlIGdvIGp1c3QgdG8gYmxvY2sgYW55dGhpbmcgcmVsYXRlZCB0bw0K
PiA+IGxlZ2FjeSBtb2RlLg0KPiANCj4gSSB0cmllZCB0byBibG9jayBldmVyeXRoaW5nIHJlbGF0
ZWQgdG8gbGVnYWN5IE5ET3MgZm9yIGEgd2hpbGUgbm93LA0KPiBhbmQNCj4gSSdtIG5vdCB0aGUg
b25seSBvbmUgKC9tZSByZW1lbWJlcnMgT3IgaW4gbmV0ZGV2Y29uZiAxLjEpLiBJJ20gc29ycnkN
Cj4gYnV0DQo+IEkgd29uJ3QgZ28gYW5kIGRpZyBvdXQgdGhlIGxpbmtzIG5vdywgaXQncyBhIHdh
c3RlIG9mIHRpbWUuDQo+IA0KPiBNYXliZSB3ZSBkaWZmZXIgb24gdGhlIGRlZmluaXRpb24gb2Yg
ZmFpcm5lc3MuIEknbSBhZ2FpbnN0IHRoaXMNCj4gZXhhY3RseQ0KPiBfYmVjYXVzZV8gSSdtIGZh
aXIsIG5vYm9keSBnZXRzIGEgZnJlZSBwYXNzLCBubyBtYXR0ZXIgaG93IG11Y2ggd2UNCj4gb3Ro
ZXJ3aXNlIGFwcHJlY2lhdGUgZ2l2ZW4gY29tcGFueSBjb250cmlidXRpbmcgdG8gdGhlIGtlcm5l
bC4uLg0KDQpJIHdhc24ndCBsb29raW5nIGZvciBmcmVlIHBhc3Nlcywgd2UganVzdCBkaXNhZ3Jl
ZSBvbiBob3cgcGYgZHJpdmVyDQpzaG91bGQgaW50ZXJwcmV0IFRDIGZsb3dlciBpbiBjYXNlIG9m
IGxlZ2FjeSBzcmlvdiwgd2hpY2ggIHdhcyBuZXZlcg0KZGVmaW5lZCBhbmQgbm8gb25lIHJlYWxs
eSBjYXJlZCBhYm91dCBpdCB1bnRpbCB0aGlzIHBhdGNoLg0KDQpNeSBvbmx5IGNvbmNlcm4gaGVy
ZSBpcyB0aGF0IHBlb3BsZSB3aWxsIG1ha2UgdXAgdGhlaXIgb3duDQpydWxlcy9pbnRlcnByZXRh
dGlvbiBvbiB0aGUgZ28gYXMgdGhleSBzZWUgZml0IHRvIHByb21vdGUgdGhlaXIgb3duDQphZ2Vu
ZGEsIHRoaXMgYXBwbGllcyB0byBib3RoIG9mIHVzLCB0aGlzIHdoYXQgbWFrZXMgaXQgdW5mYWly
LCB3ZSBtdXN0DQpnbyB3aXRoIHlvdXIgcnVsZXMgYW5kIGludGVycHJldGF0aW9ucyBhdCB0aGUg
ZW5kIG9mIHRoZSBkYXkuDQoNCkFueXdheSBtZXNzYWdlIHJlY2VpdmVkLCB3ZSBkb24ndCBsaWtl
IGxlZ2FjeSBzcmlvdiBhbmQgZXZlcnkgdGhpbmcNCnJlbGF0ZWQgdG8gaXQgd2lsbCBiZSBoYW5k
bGVkIHdpdGggYW4gaXJvbiBmaXN0LCBJIHdpbGwgZHJvcCB0aGlzDQpwYXRjaC4NCg0KDQo=

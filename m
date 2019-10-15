Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1051CD8105
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 22:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387460AbfJOUaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 16:30:20 -0400
Received: from mail-eopbgr40080.outbound.protection.outlook.com ([40.107.4.80]:62602
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727994AbfJOUaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 16:30:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzbB46HZsr9U+YTT1MQowZtzEcMN7TcF73SP2fnsI8YKIlWdhevttm/d6GoKvJydtg9IWdD+tUNRQBpocT63wghJc7oiEoRzxf5X8Ky4w8PZyjQxFVRVR0K5QRzBfRtAYIWLJEKZPx49fZ8flAEP4DAT8HSMqGpGdq5Vm/qYFzCfWoWBlVgUvsNF5IbZ6JsbM152kJNTtY7g30u93I8z0NpH2JPO2RXalWsQwKzP2UvLBVvxcT5kWBqNrVxkPtNrhsSNmpFjZGiyn5wXY28ygLTOOGiTCV3rI9WpJvo73LJnnmYL18NFslS5qo+4dgdFhjzM/1hv7yJZb5UYScF+2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=czoFiccN2Ouk+pQPmC2WTFEt3w+kTgJ13WI++VH0SEw=;
 b=SbkQG4F0iawWdVP1kd+XBdmfVkh5eRenPIIqoqrBz/cSy4EWifJBIo831CJEB7BgCz+7Xo5pfLwR90d3BR0MxGH0ZcAYisdSghJC2vL3EpNtGFnHoZDw3Lu8cFJSzJEx2+UAeLNZDqSYnjgzNRnJihwc54tb7er18pSWF3OoDkZaR6E64y4NeOQg15zglCLbbXCxclpcvtBje9Yyl25sgutMQg2mhTWSLyHph4ph3O5myRjel+eGtSoDxikZtQxsFN2tbFUvC2PiUO4W87SgL3ruQNhgXaCkiR+F/uuto1OqetfVobK9OiRQO2AkCfz1DBprK1jyqIcf24c6FxuvTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=czoFiccN2Ouk+pQPmC2WTFEt3w+kTgJ13WI++VH0SEw=;
 b=QMN7zztufXpS7lGOprbfbv0SbJrlZz69Fay0NEMEpf4KxAs2pSiUJBlrnuDLz8jDa9ENJKhnWk0cNVvDLdiPsYjFmJw7/a/0AFX4o3/9Biw+WL8Rav4rqmJaQNlFMAm1OQRe1VYH5CWt87hPBATauMvJtiJFIZ/RHHkWustfMU4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5597.eurprd05.prod.outlook.com (20.177.203.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.19; Tue, 15 Oct 2019 20:29:36 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.023; Tue, 15 Oct 2019
 20:29:36 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "bp@alien8.de" <bp@alien8.de>, Alex Vesker <valex@mellanox.com>
Subject: Re: ERROR: "__umoddi3"
 [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!
Thread-Topic: ERROR: "__umoddi3"
 [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!
Thread-Index: AQHVd5k2ehJGGBwDhUKLDvUQMK7npKdEXQCAgAAMLQCAAAdLAIAAHWiAgAFY0ICAFligAA==
Date:   Tue, 15 Oct 2019 20:29:36 +0000
Message-ID: <c72fceed58cdcb6093f1c1323416426c8237782b.camel@mellanox.com>
References: <20190930141316.GG29694@zn.tnic>
         <20190930154535.GC22120@unicorn.suse.cz> <20190930162910.GI29694@zn.tnic>
         <20190930095516.0f55513a@hermes.lan> <20190930184031.GJ29694@zn.tnic>
         <20191001151439.GA24815@unicorn.suse.cz>
In-Reply-To: <20191001151439.GA24815@unicorn.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69acd149-522f-4473-d3f3-08d751ae6552
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR05MB5597:|VI1PR05MB5597:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5597D36E09B29DA4EA212371BE930@VI1PR05MB5597.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(189003)(199004)(43544003)(54906003)(110136005)(36756003)(26005)(305945005)(58126008)(186003)(86362001)(99286004)(7736002)(71190400001)(71200400001)(66446008)(66476007)(66556008)(64756008)(14454004)(5660300002)(2501003)(66946007)(66066001)(118296001)(76116006)(91956017)(107886003)(316002)(6512007)(3846002)(6506007)(6116002)(2906002)(76176011)(256004)(8936002)(25786009)(476003)(446003)(11346002)(6486002)(2616005)(486006)(478600001)(81166006)(6246003)(102836004)(4326008)(81156014)(6436002)(8676002)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5597;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: adZ2wGGQ1sRnbCTHmK/OH4K8E2XdF/JLPykMWrfD9nBDtpePxZIHVVjgfmrauSN/GlpHc6Pi1HOtY++9ZExJvkQ2daL9xOeKhYgEicijm3/95G+pt5Nn1PoT0uRnyOVtxOrXqyJz2ZNWKPrnLS0x3lZn+kkD7yDOUsc1WPYRwvs35cfZuQBlW5B4hCxR3HAGp+iT6ssWPSNVJqWPRG9Cbw/Pckie00cMiBorLhEDPQXKBj/x6thQV6wdQYUJmlfabcEUNO8xUDutnwV+TEyG459dTnVZU16N7+rfh5eeIm/j2OjcSHhoQWCxjVT/zqM/CA+T13n3VAq4WIgecJdLO5xh7cEsIztXEjcm6HSH5jdYVlo/jr84/ou72M77lT0pERYJBsvEZtCsqBy5ogXt0YKYMsn9/UvJ9NZ1H2Tpj9o=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9DF62F124024F64E8DDDA207E25061ED@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69acd149-522f-4473-d3f3-08d751ae6552
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2019 20:29:36.1081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RIGomeVMz2Nze19yH6qqEY9gOAM1fGRqfzA25cb1R9OQ2THMCEWJR2NIjtLlAvwRSHu/5eWibHAfeXG8MLpcpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5597
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTEwLTAxIGF0IDE3OjE0ICswMjAwLCBNaWNoYWwgS3ViZWNlayB3cm90ZToN
Cj4gT24gTW9uLCBTZXAgMzAsIDIwMTkgYXQgMDg6NDA6MzFQTSArMDIwMCwgQm9yaXNsYXYgUGV0
a292IHdyb3RlOg0KPiA+IE9uIE1vbiwgU2VwIDMwLCAyMDE5IGF0IDA5OjU1OjE2QU0gLTA3MDAs
IFN0ZXBoZW4gSGVtbWluZ2VyIHdyb3RlOg0KPiA+ID4gQ291bGQgYWxzbyB1cyBkaXZfdTY0X3Jl
bSBoZXJlPw0KPiA+IA0KPiA+IFlhaCwgdGhlIGJlbG93IHNlZW1zIHRvIHdvcmsgYW5kIHRoZSBy
ZXN1bHRpbmcgYXNtIGxvb2tzIHNlbnNpYmxlDQo+ID4gdG8gbWUNCj4gPiBidXQgc29tZW9uZSBz
aG91bGQgZGVmaW5pdGVseSBkb3VibGUtY2hlY2sgbWUgYXMgSSBkb24ndCBrbm93IHRoaXMNCj4g
PiBjb2RlDQo+ID4gYXQgYWxsLg0KPiA+IA0KPiA+IFRoeC4NCj4gPiANCj4gPiBkaWZmIC0tZ2l0
DQo+ID4gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvc3RlZXJpbmcv
ZHJfaWNtX3Bvb2wuYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL3N0ZWVyaW5nL2RyX2ljbV9wb29sLmMNCj4gPiBpbmRleCA5MTNmMWU1YWFhZjIuLmI0MzAy
NjU4ZTVmOCAxMDA2NDQNCj4gPiAtLS0NCj4gPiBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9zdGVlcmluZy9kcl9pY21fcG9vbC5jDQo+ID4gKysrDQo+ID4gYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvc3RlZXJpbmcvZHJfaWNtX3Bvb2wu
Yw0KPiA+IEBAIC0xMzcsNyArMTM3LDcgQEAgZHJfaWNtX3Bvb2xfbXJfY3JlYXRlKHN0cnVjdCBt
bHg1ZHJfaWNtX3Bvb2wNCj4gPiAqcG9vbCwNCj4gPiAgDQo+ID4gIAlpY21fbXItPmljbV9zdGFy
dF9hZGRyID0gaWNtX21yLT5kbS5hZGRyOw0KPiA+ICANCj4gPiAtCWFsaWduX2RpZmYgPSBpY21f
bXItPmljbV9zdGFydF9hZGRyICUgYWxpZ25fYmFzZTsNCj4gPiArCWRpdl91NjRfcmVtKGljbV9t
ci0+aWNtX3N0YXJ0X2FkZHIsIGFsaWduX2Jhc2UsICZhbGlnbl9kaWZmKTsNCj4gPiAgCWlmIChh
bGlnbl9kaWZmKQ0KPiA+ICAJCWljbV9tci0+dXNlZF9sZW5ndGggPSBhbGlnbl9iYXNlIC0gYWxp
Z25fZGlmZjsNCj4gPiAgDQo+ID4gDQo+IA0KPiBXaGlsZSB0aGlzIGZpeGVzIDMyLWJpdCBidWls
ZHMsIGl0IGJyZWFrcyA2NC1iaXQgb25lcyBhcyBhbGlnbl9kaWZmDQo+IGlzDQo+IDY0LWJpdCBh
bmQgZGl2X3U2NF9yZW0gZXhwZWN0cyBwb2ludGVyIHRvIHUzMi4gOi0oDQo+IA0KPiBJIGNoZWNr
ZWQgdGhhdCBhbGlnbl9iYXNlIGlzIGFsd2F5cyBhIHBvd2VyIG9mIHR3byBzbyB0aGF0IHdlIGNv
dWxkDQo+IGdldA0KPiBhd2F5IHdpdGgNCj4gDQo+IAlhbGlnbl9kaWZmID0gaWNtX21yLT5pY21f
c3RhcnRfYWRkciAmIChhbGlnbl9iYXNlIC0gMSkNCj4gDQo+IEknbSBub3Qgc3VyZSwgaG93ZXZl
ciwgaWYgaXQncyBzYWZlIHRvIGFzc3VtZSBhbGlnbl9iYXNlIHdpbGwgYWx3YXlzDQo+IGhhdmUg
dG8gYmUgYSBwb3dlciBvZiB0d28gb3IgaWYgd2Ugc2hvdWxkIGFkZCBhIGNoZWNrIGZvciBzYWZl
dHkuDQo+IA0KPiAoQ2MtaW5nIGFsc28gYXV0aG9yIG9mIGNvbW1pdCAyOWNmOGZlYmQxODUgKCJu
ZXQvbWx4NTogRFIsIElDTSBwb29sDQo+IG1lbW9yeSBhbGxvY2F0b3IiKS4pDQo+IA0KDQpUaGFu
a3MgZXZlcnlvbmUgZm9yIHlvdXIgaW5wdXQgb24gdGhpcywgQWxleCB3aWxsIHRha2UgY2FyZSBv
ZiB0aGlzIGFuZA0Kd2Ugd2lsbCBzdWJtaXQgYSBwYXRjaCAuLg0KDQoNCj4gTWljaGFsDQo=

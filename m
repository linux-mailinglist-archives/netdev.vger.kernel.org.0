Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21E1D107B07
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 00:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfKVXBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 18:01:34 -0500
Received: from mail-eopbgr30089.outbound.protection.outlook.com ([40.107.3.89]:30411
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726089AbfKVXBe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 18:01:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LnfX+mUiDVULAIoYiyJb7ormbl3WPx+eXmjNVsHEY0Jfr9EyK+OHyt5f+LrfK/1c/aqCnsgz2I5Etcj273Dx7Tz1ZdmB4YPX95jzf8u1xqwCB6u1QFLjY9S/NqVNquZnvZsNtpUZAbMmCBogHt9q5d/N+2rmb73IzkbVxqn3At/D7ahEppQqlZt5tddNYENJ5/rDSzL1aiBAna249z5JHWKRdH1q5tIDZXY6S8tcvPdB9hEhT7MThWT9LTI5yGQKsfMn7GgByuRXqd0JvDdo8+Z6fRLSLhelmZBsGIZHhzGIzVIeMEtWGuLM4RiP3+vuaWX4JkvQuwL/y7H2GjdsyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPP97vxmEjorHqSuWVLUO4/+FkQkX6KfcJvF8wEYa9c=;
 b=Vx4IGghk1FAsJH3EdEjeINqgEb2b/3DWZMEr1YZCjKRrAPy2UpkduI3lOwptQGv+2sgCR18vQaMDf21airuSeiY5KjHbNlitgPxQ04tibji10QnGAtgU5bj2OCZaffOmdTJPhnXcmqNCfrZhpomXxa1eLWks6HMq7X/6mckFh0VPNKZHZoKFMpqIdJz0Rh+WPGotOfDDZsE3Q/IIfLpzI5/tVSl4VZnaGhZc4qVYJedG8/0/EBX7avuLLqPgHeWu/+0BzpmHSNwmyT2HRz//bzEV0BewjANI4eUVd2RFqUSyHq5AKX4kKB3ILKLULCgj3Wl+1Indg5NK/KPKqfPLNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPP97vxmEjorHqSuWVLUO4/+FkQkX6KfcJvF8wEYa9c=;
 b=BzmPSPmIlMxS2s+B6rkInWLOSUHHuQUUutrdmCotXrR+UO9uMlg3z8J/7m6p08mB8mxZ0KvFvj3FxTy95J3BHIopWpY74fgUdXDHz9s9v6Fd1mP4w2kAQqUvc4TdI7yJJli+opwjockKtvW0Hl/xdokw+GL5Rbqy5BlaLLyoMsc=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.83) by
 VI1PR04MB5296.eurprd04.prod.outlook.com (20.177.49.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Fri, 22 Nov 2019 23:01:28 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::64f5:d1f5:2356:bdcb]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::64f5:d1f5:2356:bdcb%6]) with mapi id 15.20.2474.021; Fri, 22 Nov 2019
 23:01:28 +0000
From:   Alexandru Marginean <alexandru.marginean@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: binding for scanning a MDIO bus
Thread-Topic: binding for scanning a MDIO bus
Thread-Index: AQHVoTDE9xOhoRGcSEOsjw1fon1gC6eXS04AgAAT4ACAABbcgIAAMd2AgAAI8gCAAB5PgA==
Date:   Fri, 22 Nov 2019 23:01:27 +0000
Message-ID: <b1ee2262-47af-3138-6fd6-782b3d821f31@nxp.com>
References: <7b6fc87b-b6d8-21e6-bd8d-74c72b3d63a7@nxp.com>
 <20191122150932.GC6602@lunn.ch>
 <a6f797cf-956e-90d9-0bb3-11e752b8a818@nxp.com>
 <20191122174229.GG6602@lunn.ch>
 <69281eea-6fca-e35c-2d62-167b31361908@nxp.com>
 <CA+h21ho-mPcFj=VLm6Er4gSq2yyZBFyE9z3r3B+k4W3ay+Kb3g@mail.gmail.com>
In-Reply-To: <CA+h21ho-mPcFj=VLm6Er4gSq2yyZBFyE9z3r3B+k4W3ay+Kb3g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=alexandru.marginean@nxp.com; 
x-originating-ip: [178.199.190.75]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fd9db273-2293-4b11-3ff3-08d76f9fe848
x-ms-traffictypediagnostic: VI1PR04MB5296:
x-microsoft-antispam-prvs: <VI1PR04MB529692D982B8DDF007213F98F5490@VI1PR04MB5296.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(346002)(366004)(396003)(199004)(189003)(3846002)(256004)(14444005)(6116002)(6916009)(66066001)(36756003)(102836004)(186003)(8936002)(478600001)(86362001)(7736002)(64756008)(31696002)(66556008)(66476007)(76176011)(5660300002)(2906002)(91956017)(305945005)(76116006)(66446008)(6246003)(6506007)(53546011)(66946007)(6486002)(31686004)(2616005)(446003)(99286004)(71200400001)(229853002)(44832011)(14454004)(71190400001)(26005)(4326008)(6512007)(25786009)(81156014)(11346002)(316002)(81166006)(1411001)(8676002)(54906003)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5296;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e3tTyHqUSFuQ+jAikBoCq5zW3Wu39gFJ+bJRmbsqm3Lj32UreaOMDsCdTCa5c75Cyf++UyADOEnmmWola+pL0pb2zs0vi41XUhywf6H1HKE0I5S0nShjohsW38LfiftR9hZR8TAs3JFyUIBZmQi4IgiRXkna/TxdYBq9zsuoYSY823AtNnG6r0G+Hd0HJyLF3Ncw1aH/0zyCvGPT5je1MFYAhm8rQjUzJnx7k6vLTxqcIU3vrWnZMkGPZFxRpIQlFILYToqaPsKnZdEUu8daXLVF/pBy28PS1qC80/nHekA2g0t1hDLZyqHQQKkmmxwzDZnD1nfNtlvpLFaoG0xCaTu/J3QU4TvZJ79YGXcO8mt08mIkiiyKe9F25ukkNEqqElDVP/QEeJKl61v/CDcXlvQFQGTo+V4Y39P8qxGWYtgZbu3WrOGbiIrjW6dOtjPz
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE4EA29329E99A4980C68FB28CCF80CE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd9db273-2293-4b11-3ff3-08d76f9fe848
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 23:01:27.9869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oRU0ULOpYZVhR3YqAxPoUbss5EBymmUhKmH/GGNhs9LI5Z8FsTOjVnvCjax04eFwp76s7mh9Yr9SbqCX2MK831IgrvBGxQAohaz2b2UY3dc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5296
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvMjIvMjAxOSAxMDoxMiBQTSwgVmxhZGltaXIgT2x0ZWFuIHdyb3RlOg0KPiBPbiBGcmks
IDIyIE5vdiAyMDE5IGF0IDIyOjQzLCBBbGV4YW5kcnUgTWFyZ2luZWFuDQo+IDxhbGV4YW5kcnUu
bWFyZ2luZWFuQG54cC5jb20+IHdyb3RlOg0KPj4NCj4+IE9uIDExLzIyLzIwMTkgNjo0MiBQTSwg
QW5kcmV3IEx1bm4gd3JvdGU6DQo+Pj4+PiBIaSBBbGV4YW5kcnUNCj4+Pj4+DQo+Pj4+PiBZb3Ug
b2Z0ZW4gc2VlIHRoZSBidXMgcmVnaXN0ZXJlZCB1c2luZyBtZGlvYnVzX3JlZ2lzdGVyKCkuIFRo
YXQgdGhlbg0KPj4+Pj4gbWVhbnMgYSBzY2FuIGlzIHBlcmZvcm1lZCBhbmQgYWxsIHBoeXMgb24g
dGhlIGJ1cyBmb3VuZC4gVGhlIE1BQw0KPj4+Pj4gZHJpdmVyIHRoZW4gdXNlcyBwaHlfZmluZF9m
aXJzdCgpIHRvIGZpbmQgdGhlIGZpcnN0IFBIWSBvbiB0aGUgYnVzLg0KPj4+Pj4gVGhlIGRhbmdl
ciBoZXJlIGlzIHRoYXQgdGhlIGhhcmR3YXJlIGRlc2lnbiBjaGFuZ2VzLCBzb21lYm9keSBhZGRz
IGENCj4+Pj4+IHNlY29uZCBQSFksIGFuZCBpdCBhbGwgc3RvcHMgd29ya2luZyBpbiBpbnRlcmVz
dGluZyBhbmQgY29uZnVzaW5nDQo+Pj4+PiB3YXlzLg0KPj4+Pj4NCj4+Pj4+IFdvdWxkIHRoaXMg
d29yayBmb3IgeW91Pw0KPj4+Pj4NCj4+Pj4+ICAgICAgICAgIEFuZHJldw0KPj4+Pj4NCj4+Pj4N
Cj4+Pj4gSG93IGRvZXMgdGhlIE1BQyBnZXQgYSByZWZlcmVuY2UgdG8gdGhlIG1kaW8gYnVzIHRo
b3VnaCwgaXMgdGhlcmUgc29tZQ0KPj4+PiB3YXkgdG8gZGVzY3JpYmUgdGhpcyByZWxhdGlvbnNo
aXAgaW4gdGhlIERUPyAgSSBkaWQgc2F5IHRoYXQgRXRoIGFuZA0KPj4+PiBtZGlvIGFyZSBhc3Nv
Y2lhdGVkIGFuZCB0aGV5IGFyZSwgYnV0IG5vdCBpbiB0aGUgd2F5IEV0aCB3b3VsZCBqdXN0IGtu
b3cNCj4+Pj4gd2l0aG91dCBsb29raW5nIGluIHRoZSBEVCB3aGF0IG1kaW8gdGhhdCBpcy4NCj4+
Pg0KPj4+IFdoYXQgaSBkZXNjcmliZWQgaXMgZ2VuZXJhbGx5IHVzZWQgZm9yIFBDSWUgY2FyZCwg
VVNCIGRvbmdsZXMsDQo+Pj4gZXRjLiBUaGUgTUFDIGRyaXZlciBpcyB0aGUgb25lIHJlZ2lzdGVy
aW5nIHRoZSBNRElPIGJ1cywgc28gaXQgaGFzDQo+Pj4gd2hhdCBpdCBuZWVkcy4gU3VjaCBoYXJk
d2FyZSBpcyBhbHNvIHByZXR0eSBtdWNoIGd1YXJhbnRlZWQgdG8gb25seQ0KPj4+IGhhdmUgb25l
IFBIWSBvbiB0aGUgYnVzLCBzbyBwaHlfZmluZF9maXJzdCgpIGlzIGxlc3MgZGFuZ2Vyb3VzLg0K
Pj4NCj4+IEkgZ2V0IHRoYXQsIGl0J3MgY2xlYXIgaG93IGl0IHdvcmtzIGlmIGl0J3MgYWxsIHBh
cnQgb2YgdGhlIHNhbWUgZGV2aWNlLA0KPj4gYnV0IHRoYXQncyBub3QgYXBwbGljYWJsZSB0byBv
dXIgUURTIGJvYXJkcy4gIFRoZXNlIGFyZSBwcmV0dHkgbXVjaCB0aGUNCj4+IG9wcG9zaXRlIG9m
IHRoZSBQQ0llIGNhcmRzIGFuZCBkb25nbGVzLiAgVGhleSBhcmUgZGVzaWduZWQgdG8gc3VwcG9y
dCBhcw0KPj4gbWFueSBjb21iaW5hdGlvbnMgYXMgcG9zc2libGUgb2YgaW50ZXJmYWNlcywgcHJv
dG9jb2xzIFBIWXMgYW5kIHNvIG9uLg0KPj4gV2hhdCBJJ20gdHJ5aW5nIHRvIGRvIGlzIHRvIGhh
dmUgdGhlIGluZnJhc3RydWN0dXJlIGluIHBsYWNlIHNvIHRoYXQNCj4+IHVzZXJzIG9mIHRoZXNl
IGJvYXJkcyBkb24ndCBoYXZlIHRvIHJlYnVpbGQgYm90aCBVLUJvb3QgYW5kIExpbnV4IGJpbmFy
eQ0KPj4gdG8gZ2V0IGFuIEV0aGVybmV0IGludGVyZmFjZSBydW5uaW5nIHdpdGggYSBkaWZmZXJl
bnQgUEhZIGNhcmQuDQo+Pg0KPj4+PiBNZGlvIGJ1c2VzIG9mIHNsb3RzL2NhcmRzIGFyZSBkZWZp
bmVkIGluIERUIHVuZGVyIHRoZSBtZGlvIG11eC4gIFRoZSBtdXgNCj4+Pj4gaXRzZWxmIGlzIGFj
Y2Vzc2VkIG92ZXIgSTJDIGFuZCBpdHMgcGFyZW50LW1kaW8gaXMgYSBzdGFuZC1hbG9uZSBkZXZp
Y2UNCj4+Pj4gdGhhdCBpcyBub3QgYXNzb2NpYXRlZCB3aXRoIGEgc3BlY2lmaWMgRXRoZXJuZXQg
ZGV2aWNlLiAgQW5kIG9uIHRvcCBvZg0KPj4+PiB0aGF0LCBiYXNlZCBvbiBzZXJkZXMgY29uZmln
dXJhdGlvbiwgc29tZSBFdGggaW50ZXJmYWNlcyBtYXkgZW5kIHVwIG9uIGENCj4+Pj4gZGlmZmVy
ZW50IHNsb3QgYW5kIGZvciB0aGF0IEkgd2FudCB0byBhcHBseSBhIERUIG92ZXJsYXkgdG8gc2V0
IHRoZQ0KPj4+PiBwcm9wZXIgRXRoL21kaW8gYXNzb2NpYXRpb24uDQo+Pj4+DQo+Pj4+IEN1cnJl
bnQgY29kZSBhbGxvd3MgbWUgdG8gZG8gc29tZXRoaW5nIGxpa2UgdGhpcywgYXMgc2VlbiBieSBM
aW51eCBvbiBib290Og0KPj4+PiAvIHsNCj4+Pj4gLi4uLg0KPj4+PiAgICAgICBtZGlvLW11eCB7
DQo+Pj4+ICAgICAgICAgICAgICAgLyogc2xvdCAxICovDQo+Pj4+ICAgICAgICAgICAgICAgbWRp
b0A0IHsNCj4+Pj4gICAgICAgICAgICAgICAgICAgICAgIHNsb3QxX3BoeTA6IHBoeSB7DQo+Pj4+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8qICdyZWcnIG1pc3Npbmcgb24gcHVycG9z
ZSAqLw0KPj4+PiAgICAgICAgICAgICAgICAgICAgICAgfTsNCj4+Pj4gICAgICAgICAgICAgICB9
Ow0KPj4+PiAgICAgICB9Ow0KPj4+PiAuLi4uDQo+Pj4+IH07DQo+Pj4+DQo+Pj4+ICZlbmV0Y19w
b3J0MCB7DQo+Pj4+ICAgICAgIHBoeS1oYW5kbGUgPSA8JnNsb3QxX3BoeTA+Ow0KPj4+PiAgICAg
ICBwaHktbW9kZSA9ICJzZ21paSI7DQo+Pj4+IH07DQo+Pj4+DQo+Pj4+IEJ1dCB0aGUgYmluZGlu
ZyBkb2VzIG5vdCBhbGxvdyB0aGlzLCAncmVnJyBpcyBhIHJlcXVpcmVkIHByb3BlcnR5IG9mDQo+
Pj4+IHBoeXMuICBJcyB0aGlzIGtpbmQgb2YgRFQgc3RydWN0dXJlIGFjY2VwdGFibGUgZXZlbiBp
ZiBpdCdzIG5vdA0KPj4+PiBjb21wbGlhbnQgdG8gdGhlIGJpbmRpbmc/ICBBc3N1bWluZyBpdCdz
IGZpbmUsIGFueSB0aG91Z2h0cyBvbiBtYWtpbmcNCj4+Pj4gdGhpcyBvZmZpY2lhbCBpbiB0aGUg
YmluZGluZz8gIElmIGl0J3Mgbm90LCBhcmUgdGhlcmUgYWx0ZXJuYXRpdmUNCj4+Pj4gb3B0aW9u
cyBmb3Igc3VjaCBhIHNldC11cD8NCj4+Pg0KPj4+IEluIHByaW5jaXBsZSwgdGhpcyBpcyBPLksu
IFRoZSBjb2RlIHNlZW1zIHRvIHN1cHBvcnQgaXQsIGV2ZW4gaWYgdGhlDQo+Pj4gYmluZGluZyBk
b2VzIG5vdCBnaXZlIGl0IGFzIGFuIG9wdGlvbi4gSXQgZ2V0IG1lc3N5IHdoZW4geW91IGhhdmUN
Cj4+PiBtdWx0aXBsZSBQSFlzIG9uIHRoZSBidXMgdGhvdWdoLiBBbmQgaWYgeW91IGFyZSB1c2lu
ZyBEVCwgeW91IGFyZQ0KPj4+IHN1cHBvc2VkIHRvIGtub3cgd2hhdCB0aGUgaGFyZHdhcmUgaXMu
IFNpbmNlIHlvdSBkb24ndCBzZWVtcyB0byBrbm93DQo+Pj4gd2hhdCB5b3VyIGhhcmR3YXJlIGlz
LCB5b3UgYXJlIGdvaW5nIHRvIHNwYW0geW91ciBrZXJuZWwgbG9ncyB3aXRoDQo+Pj4NCj4+PiAg
ICAgICAgICAgICAgICAgICAgICAgICAgIC8qIGJlIG5vaXN5IHRvIGVuY291cmFnZSBwZW9wbGUg
dG8gc2V0IHJlZyBwcm9wZXJ0eSAqLw0KPj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgZGV2
X2luZm8oJm1kaW8tPmRldiwgInNjYW4gcGh5ICVwT0ZuIGF0IGFkZHJlc3MgJWlcbiIsDQo+Pj4g
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjaGlsZCwgYWRkcik7DQo+Pj4NCj4+
PiB3aGljaCBpIGFncmVlIHdpdGguID4NCj4+PiAgICAgICAgIEFuZHJldw0KPj4+DQo+Pg0KPj4g
WWVhaCwgc3BlY2lmaWNhbGx5IG9uIHRoZXNlIFFEUyBib2FyZHMgd2UncmUgdXNpbmcgRFQgYW5k
IHdlIGNhbid0DQo+PiBwcmFjdGljYWxseSB0ZWxsIGtlcm5lbCB1cCBmcm9udCB3aGF0IFBIWSBp
cyBnb2luZyB0byBiZSBwcmVzZW50LiAgSQ0KPj4gbm90aWNlZCB0aGUgbWVzc2FnZXMsIGhhdmlu
ZyBzb21lIHZlcmJvc2l0eSBjYXVzZWQgYnkgUEhZIHNjYW5uaW5nIGlzDQo+PiBmaW5lLiAgSXQn
cyBkZWZpbml0ZWx5IGNhdXNpbmcgbXVjaCBsZXNzIHBhaW4gdGhhbiBlZGl0aW5nIERUcyB0bw0K
Pj4gZGVzY3JpYmUgd2hhdCBjYXJkIGlzIHBsdWdnZWQgaW4gaW4gd2hpY2ggc2xvdC4gIElyb25p
Y2FsbHkgdGhlc2UgY2FyZHMNCj4+IHBoeXNpY2FsbHkgbG9vayBsaWtlIFBDSWUgY2FyZHMsIGFs
dGhvdWdoIHRoZXkgYXJlIG5vdC4NCj4+DQo+PiBPSywgSSdsbCBnbyB3aXRoIFBIWSBub2RlcyB3
aXRoIG1pc3NpbmcgJ3JlZycgcHJvcGVydGllcy4NCj4+DQo+PiBUaGFua3MhDQo+PiBBbGV4DQo+
IA0KPiBIaSBBbGV4LA0KPiANCj4gTGV0J3Mgc2F5IHRoZXJlIGlzIGEgUVNHTUlJIFBIWSBvbiBz
dWNoIGEgcmlzZXIgY2FyZC4gVGhlcmUgaXMgYQ0KPiBzaW5nbGUgU2VyRGVzIGxhbmUgYnV0IG9u
IHRoZSBjYXJkIHRoZXJlIGlzIGEgUEhZIGNoaXAgdGhhdCBhY3RzIGFzIDQNCj4gUEhZcyBpbiB0
aGUgc2FtZSBwYWNrYWdlLiBFYWNoIE1BQyBuZWVkcyB0byB0YWxrIHRvIGl0cyBvd24gUEhZDQo+
IChzZXBhcmF0ZSBhZGRyZXNzZXMpIGluIHRoZSBwYWNrYWdlLiBIb3cgd291bGQgeW91ciBwcm9w
b3NlZCBiaW5kaW5ncw0KPiBpZGVudGlmeSB3aGljaCBNQUMgbmVlZHMgdG8gdGFsayB0byB3aGlj
aCBQSFkgdG8gZ2V0IGl0cyBjb3JyZWN0IGxpbmsNCj4gc3RhdHVzPw0KPiANCj4gVGhhbmtzLA0K
PiAtVmxhZGltaXINCj4gDQoNCkJ5IG15IHByb3Bvc2VkIGJpbmRpbmcgeW91IG1lYW4gdGhlIG1p
c3NpbmcgJ3JlZycgcHJvcGVydHkgaW4gcGh5IG5vZGVzPyANCiAgTG9va2luZyBhdCB0aGUgb2Zf
bWRpb2J1c19yZWdpc3RlciBjb2RlIGl0IGRvZXMgc3VwcG9ydCBzY2FubmluZyBmb3IgDQptdWx0
aXBsZSBQSFlzIG9uIGEgc2luZ2xlIGJ1cyBhbmQgaXQgc2NhbnMgdGhlIGFkZHJlc3NlcyBpbiBv
cmRlci4gDQpNYXRjaGluZyBNQUNzIGFuZCBQSFlzIGNvcnJlY3RseSBpc24ndCBhbiBOWFAgc3Bl
Y2lmaWMgcmVxdWlyZW1lbnQgZm9yIA0Kc3VyZSA6KQ0KDQpIYXJkd2FyZSBpcyBnZW5lcmFsbHkg
d2VsbCBiZWhhdmVkLCB0aGUgcXVhZCBQSFlzIEkndmUgc2VlbiBzbyBmYXIgdXNlIA0KYWRkcmVz
c2VzIGluIG9yZGVyIGZvciB0aGUgNCBpbnRlcmZhY2VzLiAgSXQncyBjb21tb24gdG8gZHJpdmVy
IHRoZSBiYXNlIA0KYWRkcmVzcyB3aXRoIGEgZmV3IFBIWSBwaW5zIGFuZCB0aGVuIHRoZSBQSFkg
YXNzaWducyBpbmNyZW1lbnRhbCANCmFkZHJlc3NlcyB0byB0aGUgb3RoZXIgMyBpbnRlcmZhY2Vz
LiAgSWYgd2UgZXZlciBidW1wIGludG8gYSBQSFkgdGhhdCANCmRvZXNuJ3QgYXNzaWduIGFkZHJl
c3NlcyB0aGF0IHdheSB3ZSdyZSBnb2luZyB0byBkbyBzb21ldGhpbmcgZGlmZmVyZW50IA0KZm9y
IHRoYXQgUEhZLCBtYXliZSBhIGN1c3RvbSBEVCBvdmVybGF5LiAgQnV0IGlmIHRoaXMgd29ya3Mg
Zm9yIGFsbCB0aGUgDQpvdGhlcnMgY2FyZHMgaXQncyBzdGlsbCBwcmV0dHkgdXNlZnVsLg0KDQpB
bGV4DQo=

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF3610798D
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 21:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfKVUlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 15:41:03 -0500
Received: from mail-eopbgr50088.outbound.protection.outlook.com ([40.107.5.88]:39135
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726526AbfKVUlD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 15:41:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RHcyRXVdvzBy18/Yi/8CeBOQkJfrzcRoIAGLhOAdGMOlaJsGiCbgFZzYTR649E79qGQHjPRuw1pVoMxlpLKb8Klkg0W2Yqu8q3cw5yvhPJxPayZvJnnfa9kizUSzjpsTB8UXP5MhkA55uDQZjG9sOID1nHrgyFk/xnNvRYmztYP4H0Z6WK8NVR//N8ZtyfGgVI1ti1xPVF/MBrb9rFqCKp82ubCAJTkS4Ca9owo5O8gZCDgRnMT1aebCYHCSs6q+xnphSGVkBZXWcfg2Slz4JUiqMVSZS9A+JlOQSTUSzfJOnNU/gYE1TEoDLpQNe0B+T17psrsxA4btaVPJ/pL1yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2mtb9qoNMAFs5VQU/j/Khg9Qj6H+HZq/5ILyimePkvA=;
 b=hICKmwwjFjRzPY8LIWxcDS1e2rlojmnHxyEqhC+kumYj4AWSTghx9QpxnadRs6wczMcyljjmk0QevE66ujV9ChhRMjg9gGcyiNBZKG9qf8tiGrHG6eEPZMhdkrgBjLcB54tfPzoGiWHqB9bju/eXmc8Qd73wm/HX/PITGOSddUbjpP5j8l6XwTTH7ySHv1ZiK3hgbE+P8v2D/igqQndW82/W0QT9OFlzVpSCRMn+imR0w5TfNWaRp2CXq64D2X2Icm3U7fi6A6TgF8BqOHLwA2HyRSMz4CWqOtTgjSW2yOOB2ghkWZB/RdoCrGE3Pc2eGkXLtvmHemw8IZJTRfaMCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2mtb9qoNMAFs5VQU/j/Khg9Qj6H+HZq/5ILyimePkvA=;
 b=Tzs+vZVaCdVEoxliAXkEk70s1FHBEe+sl4t76zB5XrJNDm2o0NZimvLSgvQ55MinKSiS9/F2R530T2FiDlOhX5EF2F+ns7aeF7JfqrpTOUbN19NiGC5HN2+ygwT1EvapaUDupCWY6uYn0FomjllfXvx2mPUB2qhfuuh+OGyx6AM=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.83) by
 VI1PR04MB3021.eurprd04.prod.outlook.com (10.170.231.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Fri, 22 Nov 2019 20:40:57 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::64f5:d1f5:2356:bdcb]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::64f5:d1f5:2356:bdcb%6]) with mapi id 15.20.2474.021; Fri, 22 Nov 2019
 20:40:57 +0000
From:   Alexandru Marginean <alexandru.marginean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: binding for scanning a MDIO bus
Thread-Topic: binding for scanning a MDIO bus
Thread-Index: AQHVoTDE9xOhoRGcSEOsjw1fon1gC6eXS04AgAAT4ACAABbcgIAAMd2A
Date:   Fri, 22 Nov 2019 20:40:57 +0000
Message-ID: <69281eea-6fca-e35c-2d62-167b31361908@nxp.com>
References: <7b6fc87b-b6d8-21e6-bd8d-74c72b3d63a7@nxp.com>
 <20191122150932.GC6602@lunn.ch>
 <a6f797cf-956e-90d9-0bb3-11e752b8a818@nxp.com>
 <20191122174229.GG6602@lunn.ch>
In-Reply-To: <20191122174229.GG6602@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=alexandru.marginean@nxp.com; 
x-originating-ip: [178.199.190.75]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 29b7dc81-62cd-4419-8a31-08d76f8c4724
x-ms-traffictypediagnostic: VI1PR04MB3021:
x-microsoft-antispam-prvs: <VI1PR04MB30210C6B5068D5591B65CFE4F5490@VI1PR04MB3021.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(346002)(376002)(366004)(189003)(199004)(7736002)(66446008)(66556008)(6916009)(256004)(305945005)(66476007)(81156014)(2906002)(66946007)(3846002)(6116002)(76116006)(44832011)(8936002)(102836004)(91956017)(64756008)(66066001)(81166006)(71190400001)(8676002)(71200400001)(99286004)(6486002)(229853002)(54906003)(5660300002)(31686004)(316002)(86362001)(2616005)(14454004)(4326008)(26005)(478600001)(76176011)(31696002)(446003)(25786009)(6246003)(11346002)(36756003)(6506007)(186003)(6512007)(6436002)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB3021;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M7oLANXA+ZTWHVkJ64J+tl1Hnmv0BQvd2JQQgUy4He+yiq5psG5hQUGX0I297C+ME2JpII3qFBbm+mVT0lPovwDIdFaDaaZBCAcC39KBy/i7w9tMCZgecLM7nKKOTDu7xyPBiNJT8Iv1ihS6X21uujc4w8UT3ptvHj3bCNZTGngvygiMImFF/bwRVYcxnZpa0ZLSWh3aLTvUxnYTmhHgfLtzE+FTUqFWrWhr6zvufLHh8u2IqpbWzId/2dpjQVHW2xq7I8UVhM3zsRib7kHKEiP/nmPEOVGM9JBojhh7r4z65SDJcOX4krPTy7NqZmWbr+NfpgV3D/aPUrxhVSmUqg9U2YFwwrP0SnOMR1XYGY4E7L7yZ5VRjlRTnO643QAIaZcQ+o6Le8oCWAS8kLXb0ytYduKXACVkhTesEM4+0u/IgQSQPXwsToM2g2/ss3Di
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9200B403D07C2F4C89B97F9E7350A8B4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29b7dc81-62cd-4419-8a31-08d76f8c4724
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 20:40:57.5416
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PJ0nfNsfAIDguUZSuUzqTWhurQ0nB9EhHER1vcCkTJjT2RUPXHKXX/mNyQxAAmhOaPNH6yy/t8yxPTxyI7SYTgeKFcfyDJvpLGyev3AJNVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3021
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvMjIvMjAxOSA2OjQyIFBNLCBBbmRyZXcgTHVubiB3cm90ZToNCj4+PiBIaSBBbGV4YW5k
cnUNCj4+Pg0KPj4+IFlvdSBvZnRlbiBzZWUgdGhlIGJ1cyByZWdpc3RlcmVkIHVzaW5nIG1kaW9i
dXNfcmVnaXN0ZXIoKS4gVGhhdCB0aGVuDQo+Pj4gbWVhbnMgYSBzY2FuIGlzIHBlcmZvcm1lZCBh
bmQgYWxsIHBoeXMgb24gdGhlIGJ1cyBmb3VuZC4gVGhlIE1BQw0KPj4+IGRyaXZlciB0aGVuIHVz
ZXMgcGh5X2ZpbmRfZmlyc3QoKSB0byBmaW5kIHRoZSBmaXJzdCBQSFkgb24gdGhlIGJ1cy4NCj4+
PiBUaGUgZGFuZ2VyIGhlcmUgaXMgdGhhdCB0aGUgaGFyZHdhcmUgZGVzaWduIGNoYW5nZXMsIHNv
bWVib2R5IGFkZHMgYQ0KPj4+IHNlY29uZCBQSFksIGFuZCBpdCBhbGwgc3RvcHMgd29ya2luZyBp
biBpbnRlcmVzdGluZyBhbmQgY29uZnVzaW5nDQo+Pj4gd2F5cy4NCj4+Pg0KPj4+IFdvdWxkIHRo
aXMgd29yayBmb3IgeW91Pw0KPj4+DQo+Pj4gICAgICAgICBBbmRyZXcNCj4+Pg0KPj4NCj4+IEhv
dyBkb2VzIHRoZSBNQUMgZ2V0IGEgcmVmZXJlbmNlIHRvIHRoZSBtZGlvIGJ1cyB0aG91Z2gsIGlz
IHRoZXJlIHNvbWUNCj4+IHdheSB0byBkZXNjcmliZSB0aGlzIHJlbGF0aW9uc2hpcCBpbiB0aGUg
RFQ/ICBJIGRpZCBzYXkgdGhhdCBFdGggYW5kDQo+PiBtZGlvIGFyZSBhc3NvY2lhdGVkIGFuZCB0
aGV5IGFyZSwgYnV0IG5vdCBpbiB0aGUgd2F5IEV0aCB3b3VsZCBqdXN0IGtub3cNCj4+IHdpdGhv
dXQgbG9va2luZyBpbiB0aGUgRFQgd2hhdCBtZGlvIHRoYXQgaXMuDQo+IA0KPiBXaGF0IGkgZGVz
Y3JpYmVkIGlzIGdlbmVyYWxseSB1c2VkIGZvciBQQ0llIGNhcmQsIFVTQiBkb25nbGVzLA0KPiBl
dGMuIFRoZSBNQUMgZHJpdmVyIGlzIHRoZSBvbmUgcmVnaXN0ZXJpbmcgdGhlIE1ESU8gYnVzLCBz
byBpdCBoYXMNCj4gd2hhdCBpdCBuZWVkcy4gU3VjaCBoYXJkd2FyZSBpcyBhbHNvIHByZXR0eSBt
dWNoIGd1YXJhbnRlZWQgdG8gb25seQ0KPiBoYXZlIG9uZSBQSFkgb24gdGhlIGJ1cywgc28gcGh5
X2ZpbmRfZmlyc3QoKSBpcyBsZXNzIGRhbmdlcm91cy4NCg0KSSBnZXQgdGhhdCwgaXQncyBjbGVh
ciBob3cgaXQgd29ya3MgaWYgaXQncyBhbGwgcGFydCBvZiB0aGUgc2FtZSBkZXZpY2UsIA0KYnV0
IHRoYXQncyBub3QgYXBwbGljYWJsZSB0byBvdXIgUURTIGJvYXJkcy4gIFRoZXNlIGFyZSBwcmV0
dHkgbXVjaCB0aGUgDQpvcHBvc2l0ZSBvZiB0aGUgUENJZSBjYXJkcyBhbmQgZG9uZ2xlcy4gIFRo
ZXkgYXJlIGRlc2lnbmVkIHRvIHN1cHBvcnQgYXMgDQptYW55IGNvbWJpbmF0aW9ucyBhcyBwb3Nz
aWJsZSBvZiBpbnRlcmZhY2VzLCBwcm90b2NvbHMgUEhZcyBhbmQgc28gb24uIA0KV2hhdCBJJ20g
dHJ5aW5nIHRvIGRvIGlzIHRvIGhhdmUgdGhlIGluZnJhc3RydWN0dXJlIGluIHBsYWNlIHNvIHRo
YXQgDQp1c2VycyBvZiB0aGVzZSBib2FyZHMgZG9uJ3QgaGF2ZSB0byByZWJ1aWxkIGJvdGggVS1C
b290IGFuZCBMaW51eCBiaW5hcnkgDQp0byBnZXQgYW4gRXRoZXJuZXQgaW50ZXJmYWNlIHJ1bm5p
bmcgd2l0aCBhIGRpZmZlcmVudCBQSFkgY2FyZC4NCg0KPj4gTWRpbyBidXNlcyBvZiBzbG90cy9j
YXJkcyBhcmUgZGVmaW5lZCBpbiBEVCB1bmRlciB0aGUgbWRpbyBtdXguICBUaGUgbXV4DQo+PiBp
dHNlbGYgaXMgYWNjZXNzZWQgb3ZlciBJMkMgYW5kIGl0cyBwYXJlbnQtbWRpbyBpcyBhIHN0YW5k
LWFsb25lIGRldmljZQ0KPj4gdGhhdCBpcyBub3QgYXNzb2NpYXRlZCB3aXRoIGEgc3BlY2lmaWMg
RXRoZXJuZXQgZGV2aWNlLiAgQW5kIG9uIHRvcCBvZg0KPj4gdGhhdCwgYmFzZWQgb24gc2VyZGVz
IGNvbmZpZ3VyYXRpb24sIHNvbWUgRXRoIGludGVyZmFjZXMgbWF5IGVuZCB1cCBvbiBhDQo+PiBk
aWZmZXJlbnQgc2xvdCBhbmQgZm9yIHRoYXQgSSB3YW50IHRvIGFwcGx5IGEgRFQgb3ZlcmxheSB0
byBzZXQgdGhlDQo+PiBwcm9wZXIgRXRoL21kaW8gYXNzb2NpYXRpb24uDQo+Pg0KPj4gQ3VycmVu
dCBjb2RlIGFsbG93cyBtZSB0byBkbyBzb21ldGhpbmcgbGlrZSB0aGlzLCBhcyBzZWVuIGJ5IExp
bnV4IG9uIGJvb3Q6DQo+PiAvIHsNCj4+IC4uLi4NCj4+IAltZGlvLW11eCB7DQo+PiAJCS8qIHNs
b3QgMSAqLw0KPj4gCQltZGlvQDQgew0KPj4gCQkJc2xvdDFfcGh5MDogcGh5IHsNCj4+IAkJCQkv
KiAncmVnJyBtaXNzaW5nIG9uIHB1cnBvc2UgKi8NCj4+IAkJCX07DQo+PiAJCX07DQo+PiAJfTsN
Cj4+IC4uLi4NCj4+IH07DQo+Pg0KPj4gJmVuZXRjX3BvcnQwIHsNCj4+IAlwaHktaGFuZGxlID0g
PCZzbG90MV9waHkwPjsNCj4+IAlwaHktbW9kZSA9ICJzZ21paSI7DQo+PiB9Ow0KPj4NCj4+IEJ1
dCB0aGUgYmluZGluZyBkb2VzIG5vdCBhbGxvdyB0aGlzLCAncmVnJyBpcyBhIHJlcXVpcmVkIHBy
b3BlcnR5IG9mDQo+PiBwaHlzLiAgSXMgdGhpcyBraW5kIG9mIERUIHN0cnVjdHVyZSBhY2NlcHRh
YmxlIGV2ZW4gaWYgaXQncyBub3QNCj4+IGNvbXBsaWFudCB0byB0aGUgYmluZGluZz8gIEFzc3Vt
aW5nIGl0J3MgZmluZSwgYW55IHRob3VnaHRzIG9uIG1ha2luZw0KPj4gdGhpcyBvZmZpY2lhbCBp
biB0aGUgYmluZGluZz8gIElmIGl0J3Mgbm90LCBhcmUgdGhlcmUgYWx0ZXJuYXRpdmUNCj4+IG9w
dGlvbnMgZm9yIHN1Y2ggYSBzZXQtdXA/DQo+IA0KPiBJbiBwcmluY2lwbGUsIHRoaXMgaXMgTy5L
LiBUaGUgY29kZSBzZWVtcyB0byBzdXBwb3J0IGl0LCBldmVuIGlmIHRoZQ0KPiBiaW5kaW5nIGRv
ZXMgbm90IGdpdmUgaXQgYXMgYW4gb3B0aW9uLiBJdCBnZXQgbWVzc3kgd2hlbiB5b3UgaGF2ZQ0K
PiBtdWx0aXBsZSBQSFlzIG9uIHRoZSBidXMgdGhvdWdoLiBBbmQgaWYgeW91IGFyZSB1c2luZyBE
VCwgeW91IGFyZQ0KPiBzdXBwb3NlZCB0byBrbm93IHdoYXQgdGhlIGhhcmR3YXJlIGlzLiBTaW5j
ZSB5b3UgZG9uJ3Qgc2VlbXMgdG8ga25vdw0KPiB3aGF0IHlvdXIgaGFyZHdhcmUgaXMsIHlvdSBh
cmUgZ29pbmcgdG8gc3BhbSB5b3VyIGtlcm5lbCBsb2dzIHdpdGgNCj4gDQo+ICAgICAgICAgICAg
ICAgICAgICAgICAgICAvKiBiZSBub2lzeSB0byBlbmNvdXJhZ2UgcGVvcGxlIHRvIHNldCByZWcg
cHJvcGVydHkgKi8NCj4gICAgICAgICAgICAgICAgICAgICAgICAgIGRldl9pbmZvKCZtZGlvLT5k
ZXYsICJzY2FuIHBoeSAlcE9GbiBhdCBhZGRyZXNzICVpXG4iLA0KPiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgY2hpbGQsIGFkZHIpOw0KPiANCj4gd2hpY2ggaSBhZ3JlZSB3aXRo
LiA+DQo+ICAgICAgICBBbmRyZXcNCj4gDQoNClllYWgsIHNwZWNpZmljYWxseSBvbiB0aGVzZSBR
RFMgYm9hcmRzIHdlJ3JlIHVzaW5nIERUIGFuZCB3ZSBjYW4ndCANCnByYWN0aWNhbGx5IHRlbGwg
a2VybmVsIHVwIGZyb250IHdoYXQgUEhZIGlzIGdvaW5nIHRvIGJlIHByZXNlbnQuICBJIA0Kbm90
aWNlZCB0aGUgbWVzc2FnZXMsIGhhdmluZyBzb21lIHZlcmJvc2l0eSBjYXVzZWQgYnkgUEhZIHNj
YW5uaW5nIGlzIA0KZmluZS4gIEl0J3MgZGVmaW5pdGVseSBjYXVzaW5nIG11Y2ggbGVzcyBwYWlu
IHRoYW4gZWRpdGluZyBEVHMgdG8gDQpkZXNjcmliZSB3aGF0IGNhcmQgaXMgcGx1Z2dlZCBpbiBp
biB3aGljaCBzbG90LiAgSXJvbmljYWxseSB0aGVzZSBjYXJkcyANCnBoeXNpY2FsbHkgbG9vayBs
aWtlIFBDSWUgY2FyZHMsIGFsdGhvdWdoIHRoZXkgYXJlIG5vdC4NCg0KT0ssIEknbGwgZ28gd2l0
aCBQSFkgbm9kZXMgd2l0aCBtaXNzaW5nICdyZWcnIHByb3BlcnRpZXMuDQoNClRoYW5rcyENCkFs
ZXg=

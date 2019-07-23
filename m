Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5427226E
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbfGWWeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:34:17 -0400
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:57766
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726803AbfGWWeR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 18:34:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bloFOm2AIHD832vrLMfg/qCvqxE+WWots+9DHcvVJ35gUu1gx0dx0Tl9B0fRZLzuR/9pI3KSH+1JmElqmy+4xsi/Pnjf/Ha9rNWQ6R/iZqomzVKM7UETU4fQvY++1UVQ/rD9dZpWxftRV4B/rgtiotOwGajGy0yGN4KaUsr1NMFU6S4I4qHiL6nL7EBsysQHtY+Bddw4CrESpzQnYo42lexkzMLgLfHdZ5CZk6lPDGF4eswYPBw8istWP+v9AiwV5UvHaZ9HLloRry2Ba/ofQE0k3wpQlkHP0ZOmxznx4oO+zcHc/xjS7YOb2NS6FXpX5DXMvjxlAXweQJAPwS7V2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rbjCdx3V6QWQkSs+PYX5fqOTBhnVkbmic9zjkEjS/s8=;
 b=afhEDecZ1zJ/ibOp9LcA/1vbxBjUaEfFCRg1ErlZ7pR7/0NBslsnE1Yj1fE8yDD07qJVrquOtKhO53JgxlzNUGXKEZVRBKo7WPrJVYv92Hq6tuVRrCPFgb7RYiRXAikOuAbL3YS7xfv7psi/IWgYMi90RVzM1uLKwwTLhwR7x+mPSoX5JT8DDBtG/mi1dwvdIyKuiXFSvdKUWEwlcONb488ulEZu2WRbAPPD/MYtWMKxCXfQG9uK/tozPjWwNhwD9HuGJgec12NczJ79K8kl1M2uXsJAU6tga6hYhrxWy0zifkfvvVp9YqN5z2M5QbtYdBJVYP+xCZjze+UNrNgX1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rbjCdx3V6QWQkSs+PYX5fqOTBhnVkbmic9zjkEjS/s8=;
 b=IX6D9u6kmJTqr9vbI2buJESpt7G3xWETSD4u59Vvx4EhHcyJsoAXyLhm569zHwoWGikirxaPXR5XgpfqUUWsxQp42ZqDwc5k2yCEaXc62BU4PxrXUv3ur9qjUycdLltk6ExgoctV2vSZoP9hi2uiiMJeHLRaTMWPzCxh1g8mLhc=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2390.eurprd05.prod.outlook.com (10.168.75.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Tue, 23 Jul 2019 22:33:59 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Tue, 23 Jul 2019
 22:33:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "willy@infradead.org" <willy@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "hch@lst.de" <hch@lst.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 6/7] net: Rename skb_frag_t size to bv_len
Thread-Topic: [PATCH v3 6/7] net: Rename skb_frag_t size to bv_len
Thread-Index: AQHVOLgCN3n4tiD8MUS+X3bLyy1Lk6bY2/6A
Date:   Tue, 23 Jul 2019 22:33:59 +0000
Message-ID: <267e43638c85447a5251ce9ca33356da4a8aa3f3.camel@mellanox.com>
References: <20190712134345.19767-1-willy@infradead.org>
         <20190712134345.19767-7-willy@infradead.org>
In-Reply-To: <20190712134345.19767-7-willy@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7476de0-81ad-4718-dad3-08d70fbddb32
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2390;
x-ms-traffictypediagnostic: DB6PR0501MB2390:
x-microsoft-antispam-prvs: <DB6PR0501MB239073A4B174050AB0A1DAD9BEC70@DB6PR0501MB2390.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(189003)(199004)(66476007)(66946007)(66066001)(81166006)(64756008)(91956017)(76116006)(81156014)(66446008)(8936002)(25786009)(256004)(14454004)(99286004)(66556008)(3846002)(86362001)(4326008)(54906003)(110136005)(58126008)(478600001)(36756003)(486006)(53936002)(476003)(229853002)(6246003)(5660300002)(71190400001)(6436002)(305945005)(2906002)(76176011)(186003)(6506007)(316002)(102836004)(26005)(2616005)(2501003)(71200400001)(6486002)(7736002)(6512007)(6116002)(8676002)(68736007)(118296001)(11346002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2390;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iHRvk+HRVxftA+VV3G8ANU3m3MwXg2bHmJGRyIv02Tm8tqG3gGrU8P218c6xT57d7SsphbFNNK+3K/RAWMlqHS0al+JJi1J4zEKZZA84wJHJi0wlyTucqe1TvU443OWY7+tnkdSwjWDqpd7hBv3gg7Hdik0vS6CdudBRodN/PytnQiIgzCt0gmg1IgJRGBLL17FDqVjUsR7gO+RhoncQ8eyXJbXKkb35jmFisyt0RRKBOJc54Or3sU8MgzhQF75Sja2baoBdUR040T02WI22fHCajQmG0Ka2pC4aQUGif6XkpThpgEoWLRk3xo4V2WmZy1yIeoCqyRSXQqublOpA0p5z7GWUUQnquZnfMW/Hd8LquoRZd2u40tLlAswUNDVtVkckz6c0w1SvYRhczNVEF6LJ6EmzTKmWpISMRQStUjQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A137AA307A91BA4C98B9B7FF11A4F191@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7476de0-81ad-4718-dad3-08d70fbddb32
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 22:33:59.5693
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2390
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA3LTEyIGF0IDA2OjQzIC0wNzAwLCBNYXR0aGV3IFdpbGNveCB3cm90ZToN
Cj4gRnJvbTogIk1hdHRoZXcgV2lsY294IChPcmFjbGUpIiA8d2lsbHlAaW5mcmFkZWFkLm9yZz4N
Cj4gDQo+IEltcHJvdmVkIGNvbXBhdGliaWxpdHkgd2l0aCBidmVjDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBNYXR0aGV3IFdpbGNveCAoT3JhY2xlKSA8d2lsbHlAaW5mcmFkZWFkLm9yZz4NCj4gLS0t
DQo+ICBpbmNsdWRlL2xpbnV4L3NrYnVmZi5oIHwgMTAgKysrKystLS0tLQ0KPiAgMSBmaWxlIGNo
YW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQg
YS9pbmNsdWRlL2xpbnV4L3NrYnVmZi5oIGIvaW5jbHVkZS9saW51eC9za2J1ZmYuaA0KPiBpbmRl
eCA4MDc2ZTJiYTgzNDkuLmU4NDllNDExZDFmMyAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51
eC9za2J1ZmYuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L3NrYnVmZi5oDQo+IEBAIC0zMTIsNyAr
MzEyLDcgQEAgdHlwZWRlZiBzdHJ1Y3Qgc2tiX2ZyYWdfc3RydWN0IHNrYl9mcmFnX3Q7DQo+ICAN
Cj4gIHN0cnVjdCBza2JfZnJhZ19zdHJ1Y3Qgew0KPiAgCXN0cnVjdCBwYWdlICpidl9wYWdlOw0K
PiAtCV9fdTMyIHNpemU7DQo+ICsJdW5zaWduZWQgaW50IGJ2X2xlbjsNCj4gIAlfX3UzMiBwYWdl
X29mZnNldDsNCg0KV2h5IGRvIHlvdSBrZWVwIHBhZ2Vfb2Zmc2V0IG5hbWUgYW5kIHR5cGUgYXMg
aXMgPyBpdCB3aWxsIG1ha2UgdGhlIGxhc3QNCnBhdGNoIG11Y2ggY2xlYW5lciBpZiB5b3UgY2hh
bmdlIGl0IHRvICJ1bnNpZ25lZCBpbnQgYnZfb2Zmc2V0Ii4NCnVuc2lnbmVkIGludCBhbmQgX191
MzIgb24gYm90aCAzMmJpdCBhbmQgNjRiaXQgYXJlIHRoZSBzYW1lIGFyZW4ndCB0aGV5DQo/DQoN
Cj4gIH07DQo+ICANCj4gQEAgLTMyMiw3ICszMjIsNyBAQCBzdHJ1Y3Qgc2tiX2ZyYWdfc3RydWN0
IHsNCj4gICAqLw0KPiAgc3RhdGljIGlubGluZSB1bnNpZ25lZCBpbnQgc2tiX2ZyYWdfc2l6ZShj
b25zdCBza2JfZnJhZ190ICpmcmFnKQ0KPiAgew0KPiAtCXJldHVybiBmcmFnLT5zaXplOw0KPiAr
CXJldHVybiBmcmFnLT5idl9sZW47DQo+ICB9DQo+ICANCj4gIC8qKg0KPiBAQCAtMzMyLDcgKzMz
Miw3IEBAIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgaW50IHNrYl9mcmFnX3NpemUoY29uc3QNCj4g
c2tiX2ZyYWdfdCAqZnJhZykNCj4gICAqLw0KPiAgc3RhdGljIGlubGluZSB2b2lkIHNrYl9mcmFn
X3NpemVfc2V0KHNrYl9mcmFnX3QgKmZyYWcsIHVuc2lnbmVkIGludA0KPiBzaXplKQ0KPiAgew0K
PiAtCWZyYWctPnNpemUgPSBzaXplOw0KPiArCWZyYWctPmJ2X2xlbiA9IHNpemU7DQo+ICB9DQo+
ICANCj4gIC8qKg0KPiBAQCAtMzQyLDcgKzM0Miw3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBza2Jf
ZnJhZ19zaXplX3NldChza2JfZnJhZ190DQo+ICpmcmFnLCB1bnNpZ25lZCBpbnQgc2l6ZSkNCj4g
ICAqLw0KPiAgc3RhdGljIGlubGluZSB2b2lkIHNrYl9mcmFnX3NpemVfYWRkKHNrYl9mcmFnX3Qg
KmZyYWcsIGludCBkZWx0YSkNCj4gIHsNCj4gLQlmcmFnLT5zaXplICs9IGRlbHRhOw0KPiArCWZy
YWctPmJ2X2xlbiArPSBkZWx0YTsNCj4gIH0NCj4gIA0KPiAgLyoqDQo+IEBAIC0zNTIsNyArMzUy
LDcgQEAgc3RhdGljIGlubGluZSB2b2lkIHNrYl9mcmFnX3NpemVfYWRkKHNrYl9mcmFnX3QNCj4g
KmZyYWcsIGludCBkZWx0YSkNCj4gICAqLw0KPiAgc3RhdGljIGlubGluZSB2b2lkIHNrYl9mcmFn
X3NpemVfc3ViKHNrYl9mcmFnX3QgKmZyYWcsIGludCBkZWx0YSkNCj4gIHsNCj4gLQlmcmFnLT5z
aXplIC09IGRlbHRhOw0KPiArCWZyYWctPmJ2X2xlbiAtPSBkZWx0YTsNCj4gIH0NCj4gIA0KPiAg
LyoqDQo=

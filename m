Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF505A28F9
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 23:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbfH2Vby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 17:31:54 -0400
Received: from mail-eopbgr150070.outbound.protection.outlook.com ([40.107.15.70]:30445
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726661AbfH2Vbx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 17:31:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=faGVgf89fiBC5cY2UUDOVNkQpHK/kiQwASaxL6T3L/uOWSa+UuE47CyfbR8gE0by8D07YQBidawUKN4eCYkZaW8yJDjxGnk9ZptmG+oU0vZUUCJmtHKDJGqtXgBscIzERt2tyUIc095slKC4x9toRDTuPNI7xp6bn54z9TnxhubEA7Twt2XGTJaksRSY50mKJ/IdnGq0muBABAcfrBkq5yX1GxMYzwioS+eAsYRVyX1yirURkfES/0Kckb1WYpmMorXXUtGETEVWyjTsRQgJKwYlAlMCaxmsmZ995+xhYKxkudvw2W/S4pHa/9b+3X5lKDoirSloquFhrzElMJYkWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsGOm0FSS/sEF0qAiyPg+UamsD/zevj91ukk7b9k4Ys=;
 b=YCj3Z/1SU84jB4PinMQa4FeLmll5+OGnbGUhfA+OPLgznTzgaPmNZxQ9SrHo8NqNfR9iZN+NhTU+vww5VBK+dTfkdWsPpgs5AO0eVdHbVbsq3wRZJHp21fF0Df8CLKqYvmQ7oHkMdo4Tm3JFN0OGynYJmrNtvUjZ51yyew7QhUg6Bh4oPPlwVswKKTEB5Fmsg8U8a4L7KktNVJWkcG39LU3/92oXkoJrlCeIHohwyZRNI7heOB0k9tiramWaP4FT+QmCvj1uNB05ffH15xv0pr9ClF7p4h5RtHGn2ZvkhM8mI2hD/dIRNAdIoOL7WwQdstBbZ9t9QjByi/6JbTU8cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsGOm0FSS/sEF0qAiyPg+UamsD/zevj91ukk7b9k4Ys=;
 b=d6ZkDDxXm59WU0Uyba4NBGJSP/SIA6IR6rDozqYmsZHTrsAvk4T2erYiH8aHLSVMrp+OPs2iOOAibYUWCLnAUORfcfnI2Auo2xfVrv/aa8tf5kjrvY/ckBzN4gVPZKTwYdGHgJG+ef3dcs0OUIyX0KAQTjawNnhkMeqwwA8Ej9M=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2270.eurprd05.prod.outlook.com (10.169.135.152) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 29 Aug 2019 21:31:49 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 21:31:49 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        haiyangz <haiyangz@microsoft.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: Re: linux-next: Tree for Aug 29 (mlx5)
Thread-Topic: linux-next: Tree for Aug 29 (mlx5)
Thread-Index: AQHVXqOWWrDg6HQUkEyJ2ZhpB0y05acSijuAgAAa0IA=
Date:   Thu, 29 Aug 2019 21:31:49 +0000
Message-ID: <c92d20e27268f515e0d4c8a28f92c0da041c2acc.camel@mellanox.com>
References: <20190829210845.41a9e193@canb.auug.org.au>
         <3cbf3e88-53b5-0eb3-9863-c4031b9aed9f@infradead.org>
         <52bcddef-fcf2-8de5-d15a-9e7ee2d5b14d@infradead.org>
In-Reply-To: <52bcddef-fcf2-8de5-d15a-9e7ee2d5b14d@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f87dcfb4-ddd6-49fe-e23b-08d72cc84d54
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2270;
x-ms-traffictypediagnostic: VI1PR0501MB2270:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB2270325EAC422BC5B1F0A243BEA20@VI1PR0501MB2270.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(346002)(39860400002)(376002)(199004)(53754006)(189003)(52314003)(118296001)(8676002)(5660300002)(2906002)(305945005)(6116002)(53936002)(66066001)(91956017)(229853002)(3846002)(1511001)(107886003)(6246003)(2616005)(256004)(7736002)(76176011)(486006)(76116006)(26005)(2201001)(476003)(186003)(11346002)(478600001)(36756003)(6506007)(6486002)(53546011)(14454004)(86362001)(2501003)(102836004)(54906003)(71190400001)(71200400001)(446003)(6512007)(66946007)(81156014)(25786009)(66476007)(66446008)(8936002)(64756008)(81166006)(6436002)(4326008)(110136005)(99286004)(316002)(58126008)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2270;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ypklTFAooNB8q9y2MuFSf1FKhTxj8X6F8rfJXH/xSBD6ThX9kC7SITZbMrMVr9XsKcNQmoKQBXdVSlVfgcN3FOOVgKFjibp33AlJ0KKBLKw726NME1qhC0nZ3ZAisub5ZqH6rxRszkIHr1zydNeM+sHt+/Vqj9UhGX/blldwnDS26bifq8/YB/dYggh9KkoyANZAw2zcCHdO2S40/InXFnyyvY9ys8Ce3lc4WgkVyfGOvG5/E1sKzXAQcIWqa6y/m2QARGjZGGGJT8c2g74iTvWEoNjjoPUbw2xV1Ua3ZYRQ4RM3YAxFb4Qj+KaXVng2ATCurnK2BemTXiQh7h3b8/y04tGcxJVvvKLr0DUi8lXvbwQ1fHiDRgSl+iFbc5NAJmgzkoG0i2P1740wRRYPz7ODBR5EliIKnEfN8M5eZyQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0629CB328889074CBC4994AEE0EA7D9C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f87dcfb4-ddd6-49fe-e23b-08d72cc84d54
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 21:31:49.8174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bsz89ahAkijF9gJaVu4txy0XGPU2pOh+4g9MXjTDCHd7NEgZ3VNNtHpx9d4Dz/sL+tRlIkwnhfYDJAPIvleQqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2270
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA4LTI5IGF0IDEyOjU1IC0wNzAwLCBSYW5keSBEdW5sYXAgd3JvdGU6DQo+
IE9uIDgvMjkvMTkgMTI6NTQgUE0sIFJhbmR5IER1bmxhcCB3cm90ZToNCj4gPiBPbiA4LzI5LzE5
IDQ6MDggQU0sIFN0ZXBoZW4gUm90aHdlbGwgd3JvdGU6DQo+ID4gPiBIaSBhbGwsDQo+ID4gPiAN
Cj4gPiA+IENoYW5nZXMgc2luY2UgMjAxOTA4Mjg6DQo+ID4gPiANCj4gPiANCj4gPiBvbiB4ODZf
NjQ6DQo+ID4gd2hlbiBDT05GSUdfUENJX0hZUEVSVj1tDQo+IA0KPiBhbmQgQ09ORklHX1BDSV9I
WVBFUlZfSU5URVJGQUNFPW0NCj4gDQoNCkhhaXlhbmcgYW5kIEVyYW4sIEkgdGhpbmsgQ09ORklH
X1BDSV9IWVBFUlZfSU5URVJGQUNFIHdhcyBuZXZlcg0Kc3VwcG9zZWQgdG8gYmUgYSBtb2R1bGUg
PyBpdCBzdXBwb3NlZCB0byBwcm92aWRlIGFuIGFsd2F5cyBhdmFpbGFibGUgDQppbnRlcmZhY2Ug
dG8gZHJpdmVycyAuLiANCg0KQW55d2F5LCBtYXliZSB3ZSBuZWVkIHRvIGltcGx5IENPTkZJR19Q
Q0lfSFlQRVJWX0lOVEVSRkFDRSBpbiBtbHg1Lg0KDQpUaGFua3MsDQpTYWVlZC4NCiANCj4gPiBh
bmQgbXhseDUgaXMgYnVpbHRpbiAoPXkpLg0KPiA+IA0KPiA+IGxkOiBkcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFpbi5vOiBpbiBmdW5jdGlvbg0KPiA+IGBtbHg1X3Vu
bG9hZCc6DQo+ID4gbWFpbi5jOigudGV4dCsweDVkKTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBg
bWx4NV9odl92aGNhX2NsZWFudXAnDQo+ID4gbGQ6IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9tYWluLm86IGluIGZ1bmN0aW9uDQo+ID4gYG1seDVfY2xlYW51cF9vbmNl
JzoNCj4gPiBtYWluLmM6KC50ZXh0KzB4MTU4KTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgbWx4
NV9odl92aGNhX2Rlc3Ryb3knDQo+ID4gbGQ6IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9tYWluLm86IGluIGZ1bmN0aW9uDQo+ID4gYG1seDVfbG9hZF9vbmUnOg0KPiA+
IG1haW4uYzooLnRleHQrMHg0MTkxKTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgbWx4NV9odl92
aGNhX2NyZWF0ZScNCj4gPiBsZDogbWFpbi5jOigudGV4dCsweDQ3NzIpOiB1bmRlZmluZWQgcmVm
ZXJlbmNlIHRvDQo+ID4gYG1seDVfaHZfdmhjYV9pbml0Jw0KPiA+IGxkOiBtYWluLmM6KC50ZXh0
KzB4NGIwNyk6IHVuZGVmaW5lZCByZWZlcmVuY2UgdG8NCj4gPiBgbWx4NV9odl92aGNhX2NsZWFu
dXAnDQo+ID4gDQo+ID4gDQo+IA0KPiANCg==

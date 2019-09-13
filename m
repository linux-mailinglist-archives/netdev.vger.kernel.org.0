Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC577B1B57
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 12:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbfIMKGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 06:06:21 -0400
Received: from mail-eopbgr70075.outbound.protection.outlook.com ([40.107.7.75]:39606
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725775AbfIMKGU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 06:06:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G7XpFdPyW1++CZtvKgIVvQF6A9l+cDkWx25wExnNBE9U15+jnUqkGwurWjD9EbYcFdtsetw91P6aX6uzauhFynTFr0bDrnBXnKc+48G+AWqBss1b6kuHQwyMfUr5R2M0J5uINUfUmCgHwl3biyHP36hKy4uDv9CRv0eNQ4fgh6apnp7Q+AGkhEs0+Cn1XDRnAgNmcOffXm8fzPgcG3Nz0/e59m3824WXAjd7wNTgTQcGzSx4JIL+u0pbcVY3+mIiBXMarCKGmc1eqXxkh/kYRuDKaeCkR4leEkhPIz6xoyuLWgDxHMSvs6ORHxzaooy4DJpghSO5o+bl6c0P00IufA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4UMb/C55jzDLYhngtUZ7zsu2uXXOoTPtN8O+cCvkyOE=;
 b=FPMWU03FSQpqomV5OnRRsUzaVGrRfKxEUGd7asdlUR3VI3mWZkZ8lj6tzAFyclvLCGMMjWQjgh+jTmM8nCxFHTKlTaPuu605jJk+hnhZTFAma/7Njn3aWL/asb9ezI/Dqbwyj9t15XVPt9VsaPgpIAHmbzeHtZZJ5tpn/H/5dxRHwrKvccHLFpDy0RRYVuHfFLyNxcBYAX0NDHwPm5k9iv9Q0+Y/CCQdmUkcGQW2IZlgCwdsmUIlp4wcwYGbYCPwEMs37H7zTvXngrR/F1pgyZAmuXxPzfIyjuhCmwRaA19hnfSWcf9Mu1DqegLkSkkVBLGz8EuRXMNHOaxQS/AEKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4UMb/C55jzDLYhngtUZ7zsu2uXXOoTPtN8O+cCvkyOE=;
 b=AUKNIKiblmL2g+9kxJnS1E6n6wwk1u9oNaRfoPgVNtljGeJQNrZYjJgJYbuDWJBPL+KSNbXXAJcKToTrbUwp4kdrMrHlsihlraz+ZTlsLFU0dyKnXCh+DaZVLnjBPoAw67CDLeVPn2SfCI2E30csNmGokHxgt/aJnxPvCR/pALM=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2280.eurprd05.prod.outlook.com (10.168.55.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.21; Fri, 13 Sep 2019 10:06:15 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::f839:378:4972:3e43]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::f839:378:4972:3e43%12]) with mapi id 15.20.2241.022; Fri, 13 Sep 2019
 10:06:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "zhongjiang@huawei.com" <zhongjiang@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: Remove unneeded variable in mlx5_unload_one
Thread-Topic: [PATCH] net/mlx5: Remove unneeded variable in mlx5_unload_one
Thread-Index: AQHVaYvRsuIrAOzWrkqFyb9MhUmdeacpYp8A
Date:   Fri, 13 Sep 2019 10:06:15 +0000
Message-ID: <05f34a7c8a7ff369f9179a98eea6dad924de2d6f.camel@mellanox.com>
References: <1568307542-43797-1-git-send-email-zhongjiang@huawei.com>
In-Reply-To: <1568307542-43797-1-git-send-email-zhongjiang@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [109.186.200.217]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28cf7d13-88a8-4ce2-87ea-08d7383203c4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2280;
x-ms-traffictypediagnostic: DB6PR0501MB2280:
x-microsoft-antispam-prvs: <DB6PR0501MB2280F80AC91F2FC25E21F32CBEB30@DB6PR0501MB2280.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(199004)(189003)(118296001)(2501003)(2906002)(6116002)(86362001)(36756003)(3846002)(102836004)(26005)(186003)(6506007)(76176011)(476003)(2616005)(11346002)(446003)(66946007)(81166006)(81156014)(8676002)(8936002)(99286004)(91956017)(76116006)(66476007)(66556008)(64756008)(66446008)(66066001)(6436002)(6512007)(6486002)(229853002)(53936002)(5660300002)(6246003)(58126008)(54906003)(110136005)(316002)(71190400001)(71200400001)(7736002)(305945005)(486006)(256004)(25786009)(4326008)(478600001)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2280;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8QrnWTpizCgunkAiYcakD3VXJu/jrb+NfnOofX/63q29Nn4Fv24NNeJiCRQcqG7/nb9LIF6GVZkisuoNFko6lIANFQZ+FjeGBW7lyfHERDWYL9MovatBT+oPOp7rE6lBNjZ1TxyYzYZqkZ0RuBGVSG4ajodwrj5kyckE7MnpjhkO+bNeibtShhE25MXXZYNQx4kqPaF2kAkBRChUZMKKJe1S7ePLnQeCtBUMUvnYJnuPdANrdiNxuZP+KQgUui3yM+rDu2QVvffSq9sHPnI0HE2XcZgvON8R8mHbhPK1cXpHlpMYwwy++2zDWd/+yhZ2340ArsXk+vMul5MlwK7Rgx9LKGON2BRADwHoEi2QfcozKMdQS/NjMZ7iV/oNgAy4LJpub/gJY2fGp17n1Ls1UOgKtdV6vskokEZ8ZzGo/ms=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E9C4C52ABC5B964FB9BF288CA8050101@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28cf7d13-88a8-4ce2-87ea-08d7383203c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 10:06:15.8056
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yp92xvQmd35Vow0n6eEiDyVLDECt64IGziOMMJ5Ia/8GaG4PJE9+F+25Xmg9LMy5sgg6KGHMRkBlsHbZlxNB1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2280
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA5LTEzIGF0IDAwOjU5ICswODAwLCB6aG9uZyBqaWFuZyB3cm90ZToNCj4g
bWx4NV91bmxvYWRfb25lIGRvIG5vdCBuZWVkIGxvY2FsIHZhcmlhYmxlIHRvIHN0b3JlIGRpZmZl
cmVudCB2YWx1ZSwNCj4gSGVuY2UganVzdCByZW1vdmUgaXQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiB6aG9uZyBqaWFuZyA8emhvbmdqaWFuZ0BodWF3ZWkuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9tYWluLmMgfCA0ICstLS0NCj4gIDEgZmls
ZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFpbi5jDQo+IGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21haW4uYw0KPiBpbmRleCA5
NjQ4YzIyLi5jMzliYjM3IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9tYWluLmMNCj4gQEAgLTEyMjgsOCArMTIyOCw2IEBAIHN0YXRpYyBpbnQg
bWx4NV9sb2FkX29uZShzdHJ1Y3QgbWx4NV9jb3JlX2Rldg0KPiAqZGV2LCBib29sIGJvb3QpDQo+
ICANCj4gIHN0YXRpYyBpbnQgbWx4NV91bmxvYWRfb25lKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpk
ZXYsIGJvb2wgY2xlYW51cCkNCj4gIHsNCj4gLQlpbnQgZXJyID0gMDsNCj4gLQ0KPiAgCWlmIChj
bGVhbnVwKSB7DQo+ICAJCW1seDVfdW5yZWdpc3Rlcl9kZXZpY2UoZGV2KTsNCj4gIAkJbWx4NV9k
cmFpbl9oZWFsdGhfd3EoZGV2KTsNCj4gQEAgLTEyNTcsNyArMTI1NSw3IEBAIHN0YXRpYyBpbnQg
bWx4NV91bmxvYWRfb25lKHN0cnVjdCBtbHg1X2NvcmVfZGV2DQo+ICpkZXYsIGJvb2wgY2xlYW51
cCkNCj4gIAltbHg1X2Z1bmN0aW9uX3RlYXJkb3duKGRldiwgY2xlYW51cCk7DQo+ICBvdXQ6DQo+
ICAJbXV0ZXhfdW5sb2NrKCZkZXYtPmludGZfc3RhdGVfbXV0ZXgpOw0KPiAtCXJldHVybiBlcnI7
DQo+ICsJcmV0dXJuIDA7DQo+ICB9DQo+ICANCj4gIHN0YXRpYyBpbnQgbWx4NV9tZGV2X2luaXQo
c3RydWN0IG1seDVfY29yZV9kZXYgKmRldiwgaW50DQo+IHByb2ZpbGVfaWR4KQ0KDQpBY2tlZC1i
eTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo=

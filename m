Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E933A28D4
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 23:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbfH2VXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 17:23:36 -0400
Received: from mail-eopbgr40070.outbound.protection.outlook.com ([40.107.4.70]:21058
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726526AbfH2VXg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 17:23:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KqhIpr9GxVL8XBB7r6VdLlPy7wIWfM9KmlAS5NCKiEJLXI7Y/YbU7H8y2LVDc9V+sd8cp4DIaS2IjZZV6D6K9g9LwhWL63ohLr5WnxKTEdO1hRSXj0HZtfqrB0ITTvfQ6jhMDWkzR/NPUXQHwSqfrelJ5ENltFCjCODqFcHCptB8jyWoqedhOa/HgXsf4COXfG0BVyXkrbPWVznCZWEKLpmiei5Iu07+J+ZyvBd7EZkD0V3L74gdEgqHBxK3ieRwaG4dkiStuNCa0pa7FLorn6L7A35G7/xSK29NlGNbc9Cfr/e7mrKDRORcGWPcO90DtE2iTeWxvw1ILbyPiXrx9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QCGlsMJEGq2AwT4aEC8jSPk3TBsLYnuVLIyKhBK/iIs=;
 b=frLgc5HZRMzRpPwIpr0glWLMoSgfMys8brlwdVmQaREL4LdHeR5WeGQ8ykg7c0QdbZYKj918tI14Znu/1/V3X0dzF0lROjlUQ5KZ53r+sQ+hxFuDdgrkTn0XgVo+FVwhdxIx6f4uxNYPThLQBYx7Hoq1zIPOJizTIah4g8isbl6Q3cBYI0zv5iTdfUySPmyy4wYSG5gmCctm4pUafZj40WLGxz10zw/prGmRnN5FB+QRHR5YbFxROGtkKiYNst4G0PA8xDBUrttkBLh6ep1l+vNs4FTx5yQZ74fA2Q43SAIqE8UEgL+oMVyTTYHIUqaikRPLj8/frOTCb9TEY35IIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QCGlsMJEGq2AwT4aEC8jSPk3TBsLYnuVLIyKhBK/iIs=;
 b=It7Fc0uHIwUFOJTFV9Nhur5huWj8SOW7T7B0GKNdZEsq6BDJ3vgAEUQV/R3KRGsiQPyXrhroLlt9wi+99UHk3dtakHKMUkh8hgOpokUEbFtD0cLlD27Ja2IwmEyn/VBm6NVovPCzFxQ5869ZuOm2t5DWQi2ZmbXaD1l8dXO9DP0=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2205.eurprd05.prod.outlook.com (10.169.134.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.18; Thu, 29 Aug 2019 21:23:31 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 21:23:31 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "efremov@linux.com" <efremov@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "joe@perches.com" <joe@perches.com>,
        Boris Pismenny <borisp@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 03/11] net/mlx5e: Remove unlikely() from WARN*()
 condition
Thread-Topic: [PATCH v3 03/11] net/mlx5e: Remove unlikely() from WARN*()
 condition
Thread-Index: AQHVXon5nXwlu8SJiEupxp7KIs6jPKcSousA
Date:   Thu, 29 Aug 2019 21:23:30 +0000
Message-ID: <ad2ef15ddaec0033ce17d8ba252037ef70c7ac93.camel@mellanox.com>
References: <20190829165025.15750-1-efremov@linux.com>
         <20190829165025.15750-3-efremov@linux.com>
In-Reply-To: <20190829165025.15750-3-efremov@linux.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9707d8a8-59d4-4203-f60c-08d72cc7244e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2205;
x-ms-traffictypediagnostic: VI1PR0501MB2205:|VI1PR0501MB2205:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB22056280A972548C1925CB7ABEA20@VI1PR0501MB2205.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:457;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(136003)(376002)(39860400002)(199004)(189003)(8936002)(86362001)(316002)(81166006)(5660300002)(110136005)(186003)(36756003)(102836004)(11346002)(81156014)(14454004)(476003)(53936002)(6512007)(305945005)(7736002)(8676002)(118296001)(2616005)(99286004)(26005)(256004)(14444005)(229853002)(58126008)(6436002)(25786009)(6116002)(71190400001)(71200400001)(3846002)(66066001)(6246003)(54906003)(478600001)(66476007)(66556008)(64756008)(66446008)(6486002)(6506007)(66946007)(4326008)(91956017)(76116006)(2501003)(2906002)(486006)(2201001)(446003)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2205;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3v/EBf558gizx28utlzUrdgeyZ1Jj5Ile+8VVUJ4GgOR+rL2hl3joL0r8DHwt3mCEsXe76age7j23svnFCtMmaZRJ79lHA2/KiAtk6J5WAQlNSlykaVdH251c6gREiI5zAkGfD2JWMae4Lw2cOpPtcqv4141H13nnknT0thuC+nGxzgSBqvq7yafHVKzJ/WNLtLtYo8WuUCL+IWDPzz5l0TsCGXn6SZk2RJYGZHgDRyyi41b5GelhONtsbxYB2RZ9PoVPh85Q2Npnac/LOEIziAFxXu2gR69iU9Jniz0/ynqsjKgn+BSmqtnVB3KNuyKE7w8ef3t2Mqt/AJdSEFeB3Hr68T7M2mXxpwRxrCQ4euxelC/RE/ygU4AubDVh4m0f2nXNGLCjixzFaWvwrQnDPCeWFfgrKw8/MXgP5UqMjo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE79B12C2BE3EB4EA0A7F4D49F618EBD@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9707d8a8-59d4-4203-f60c-08d72cc7244e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 21:23:31.3963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tvBkntELI4rt6SGzu1Jjza8SLhdL10c4Ou3LegZhOOeL27i2k27LCRa0kV1nvsMGs3pEGLNdG1LAFHT7DOumMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2205
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA4LTI5IGF0IDE5OjUwICswMzAwLCBEZW5pcyBFZnJlbW92IHdyb3RlOg0K
PiAidW5saWtlbHkoV0FSTl9PTl9PTkNFKHgpKSIgaXMgZXhjZXNzaXZlLiBXQVJOX09OX09OQ0Uo
KSBhbHJlYWR5IHVzZXMNCj4gdW5saWtlbHkoKSBpbnRlcm5hbGx5Lg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogRGVuaXMgRWZyZW1vdiA8ZWZyZW1vdkBsaW51eC5jb20+DQo+IENjOiBCb3JpcyBQaXNt
ZW5ueSA8Ym9yaXNwQG1lbGxhbm94LmNvbT4NCj4gQ2M6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1A
bWVsbGFub3guY29tPg0KPiBDYzogTGVvbiBSb21hbm92c2t5IDxsZW9uQGtlcm5lbC5vcmc+DQo+
IENjOiBKb2UgUGVyY2hlcyA8am9lQHBlcmNoZXMuY29tPg0KPiBDYzogQW5kcmV3IE1vcnRvbiA8
YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcN
Cj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fYWNj
ZWwva3Rsc190eC5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAx
IGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0DQo+IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2VuX2FjY2VsL2t0bHNfdHguYw0KPiBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9hY2NlbC9rdGxzX3R4LmMNCj4gaW5kZXggNzgz
M2RkZWYwNDI3Li5lNTIyMmQxN2RmMzUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbl9hY2NlbC9rdGxzX3R4LmMNCj4gKysrIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX2FjY2VsL2t0bHNfdHguYw0KPiBA
QCAtNDA4LDcgKzQwOCw3IEBAIHN0cnVjdCBza19idWZmICptbHg1ZV9rdGxzX2hhbmRsZV90eF9z
a2Ioc3RydWN0DQo+IG5ldF9kZXZpY2UgKm5ldGRldiwNCj4gIAkJZ290byBvdXQ7DQo+ICANCj4g
IAl0bHNfY3R4ID0gdGxzX2dldF9jdHgoc2tiLT5zayk7DQo+IC0JaWYgKHVubGlrZWx5KFdBUk5f
T05fT05DRSh0bHNfY3R4LT5uZXRkZXYgIT0gbmV0ZGV2KSkpDQo+ICsJaWYgKFdBUk5fT05fT05D
RSh0bHNfY3R4LT5uZXRkZXYgIT0gbmV0ZGV2KSkNCj4gIAkJZ290byBlcnJfb3V0Ow0KPiAgDQo+
ICAJcHJpdl90eCA9IG1seDVlX2dldF9rdGxzX3R4X3ByaXZfY3R4KHRsc19jdHgpOw0KDQpBY2tl
ZC1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQoNCkRhdmUsIHlvdSBj
YW4gdGFrZSB0aGlzIG9uZS4NCg==

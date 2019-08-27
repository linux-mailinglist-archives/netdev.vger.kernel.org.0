Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB1EF9F4DB
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 23:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730704AbfH0VPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 17:15:31 -0400
Received: from mail-eopbgr50078.outbound.protection.outlook.com ([40.107.5.78]:32854
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726735AbfH0VPb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 17:15:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8inNN7SSy2ryNVmTEoulz27RaEKEamqu0NbKn8X2cLR9Cqdc0/ThY/ztaToE3U5AWoVZ3hfiMbB1lECjDuITyNXU3VI59xEm0fGY5eAAXJPmNFyqpC8qp36So4sZ2f3da/1yVI/jAl1DRcRPF+aat8LT65aJyJ2EclzJVSO3cEBkxEHIByw5KPYPMJ4D2ix0I2wG63rEa6may1GhLlvP0aGvetpBLn+dScSXEjqbpj2J7EGzotVKM8jJTGQPYrfED01gD5dAq/rVjw7BMbQ9O3k2/zriRt3aeYHxhU+QrD3lT/Mj+6OetyRk3x29+Y68IDa7j6QJY8wQV3USr5Kaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jWfSOPyezsy/SZF1bJ70tjQdz1ZgE0SUo63k/RpGuis=;
 b=jLiZnbYtAMBXMQsrG+Cgbq37vPmV92rRUPZIYb3fEdKNju8q2UvMvJy9BTqt3Z9bvk/xeC6fjWjbHOObp0vEwq5oEEA5HCbaB2ahcQdzhnBkrIuHaSmSfxNNfcu0SPVtqj2a6QpEnf/BMkbEx69hbjrGoIKel/fTHHVsxibR3/ko7T5O149qFCe/LLo4MGNUwULZy18BODhQPLXwchqQrUUy8ja4gXkCe5anFB68R0RUEvwpT0Ubu/bah7upf0U/gm4HzcS06cOQl0gw2NbWoB7j2EpWJzhV4cOTK1CcMb79b47ODKeLLmZ1DPyZ4CiYgsgrk5NcPJq9EFSnNR1tyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jWfSOPyezsy/SZF1bJ70tjQdz1ZgE0SUo63k/RpGuis=;
 b=JJwFWRGq0T3oiwyCCRwMgaFQDf2FG5cp7AIdd5X1QcA6xH/A9MNvxGVMovKyhwu8uM/YIiLg+vRyZB/Yk6OIlE2GzwPyoVa5ikuo2zkhfxd2nYf4E0mzXrudKNZ5WULP0mQDzmnKMBrNOafRJrByHuU3+l+mhe6KdNDUs0+bEXA=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2621.eurprd05.prod.outlook.com (10.172.12.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.19; Tue, 27 Aug 2019 21:15:23 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Tue, 27 Aug 2019
 21:15:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "wharms@bfs.de" <wharms@bfs.de>,
        "maowenan@huawei.com" <maowenan@huawei.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] net: mlx5: Kconfig: Fix MLX5_CORE_EN dependencies
Thread-Topic: [PATCH -next] net: mlx5: Kconfig: Fix MLX5_CORE_EN dependencies
Thread-Index: AQHVXITcCNibTH++QEWLgS4IcRgEMqcOl/iAgAAo/4CAAL8OgA==
Date:   Tue, 27 Aug 2019 21:15:23 +0000
Message-ID: <5b838b204d96482cdff006b872146cb492917475.camel@mellanox.com>
References: <20190827031251.98881-1-maowenan@huawei.com>
         <5D64DABF.4010601@bfs.de> <092f56bf-3e94-a3b6-926c-da33ba26ee37@huawei.com>
In-Reply-To: <092f56bf-3e94-a3b6-926c-da33ba26ee37@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18c98c3e-32f0-4925-1ce5-08d72b33acbb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2621;
x-ms-traffictypediagnostic: VI1PR0501MB2621:
x-microsoft-antispam-prvs: <VI1PR0501MB2621B675DD941A63D74040E3BEA00@VI1PR0501MB2621.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(199004)(189003)(6512007)(229853002)(53936002)(2906002)(7736002)(486006)(6116002)(8936002)(3846002)(71200400001)(305945005)(71190400001)(478600001)(2501003)(36756003)(54906003)(5660300002)(6436002)(6246003)(6486002)(66066001)(14454004)(14444005)(58126008)(256004)(81166006)(81156014)(4326008)(66556008)(76116006)(66946007)(11346002)(2616005)(66476007)(446003)(91956017)(99286004)(76176011)(66446008)(64756008)(476003)(110136005)(102836004)(6506007)(8676002)(25786009)(26005)(316002)(86362001)(118296001)(186003)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2621;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mx+jRm6ysPyH9GA3xDBajhSvv18cujPHHKzo644ZgSOTL1TMV6URcp6xXGZCQr+KnLY10U/KlXHPzbHHAjhZJXnvFPJosgVBVBUMoSp7Lp6y2Ri7idEE4ty5yYou/fzBmup97UBvFSKOkyay/tMnpbnsBe0xKnl5SSGGJh9M8qltWgI6nfSLTLMafYYWOuuALIUci5pzR4PPX/nIVDwJZ1ptEXoAeSiuv3ABGFmdoU4nwFC2Z4Ybt5wpEPFHuuy1g55AiFc88ldwjWEqZeUIi74zt7htq0Z/ZG8hlx5iV6zGQpqlTrV1FcZ9WAgwwqF8TN9srHGb/2gDhWQqCySBLtm4pXdMOVtibdJ6SnAo4r4sijlU5kAGA1UknpyeRKyLtXj/aNlIF5FAzTUrQaiSWgh9RcYoZNutRvrJ56mgsYE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <576E5DF6BB1C494D9C555542872C1337@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18c98c3e-32f0-4925-1ce5-08d72b33acbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 21:15:23.5985
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iontQIelaVu3OXY6XT8i1esDJWxO+O3fyX5IdYFohevKNAd0eGiRaG0caRCScZG4edDSJwDel7gM4LELuTgPZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2621
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA4LTI3IGF0IDE3OjUxICswODAwLCBtYW93ZW5hbiB3cm90ZToNCj4gDQo+
IE9uIDIwMTkvOC8yNyAxNToyNCwgd2FsdGVyIGhhcm1zIHdyb3RlOg0KPiA+IA0KPiA+IEFtIDI3
LjA4LjIwMTkgMDU6MTIsIHNjaHJpZWIgTWFvIFdlbmFuOg0KPiA+ID4gV2hlbiBNTFg1X0NPUkVf
RU49eSBhbmQgUENJX0hZUEVSVl9JTlRFUkZBQ0UgaXMgbm90IHNldCwgYmVsb3cNCj4gPiA+IGVy
cm9ycyBhcmUgZm91bmQ6DQo+ID4gPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZW5fbWFpbi5vOiBJbiBmdW5jdGlvbg0KPiA+ID4gYG1seDVlX25pY19lbmFibGUnOg0K
PiA+ID4gZW5fbWFpbi5jOigudGV4dCsweGI2NDkpOiB1bmRlZmluZWQgcmVmZXJlbmNlIHRvDQo+
ID4gPiBgbWx4NWVfaHZfdmhjYV9zdGF0c19jcmVhdGUnDQo+ID4gPiBkcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5vOiBJbiBmdW5jdGlvbg0KPiA+ID4gYG1s
eDVlX25pY19kaXNhYmxlJzoNCj4gPiA+IGVuX21haW4uYzooLnRleHQrMHhiOGM0KTogdW5kZWZp
bmVkIHJlZmVyZW5jZSB0bw0KPiA+ID4gYG1seDVlX2h2X3ZoY2Ffc3RhdHNfZGVzdHJveScNCj4g
PiA+IA0KPiA+ID4gVGhpcyBiZWNhdXNlIENPTkZJR19QQ0lfSFlQRVJWX0lOVEVSRkFDRSBpcyBu
ZXdseSBpbnRyb2R1Y2VkIGJ5DQo+ID4gPiAnY29tbWl0IDM0OGRkOTNlNDBjMQ0KPiA+ID4gKCJQ
Q0k6IGh2OiBBZGQgYSBIeXBlci1WIFBDSSBpbnRlcmZhY2UgZHJpdmVyIGZvciBzb2Z0d2FyZQ0K
PiA+ID4gYmFja2NoYW5uZWwgaW50ZXJmYWNlIiksDQo+ID4gPiBGaXggdGhpcyBieSBtYWtpbmcg
TUxYNV9DT1JFX0VOIGltcGx5IFBDSV9IWVBFUlZfSU5URVJGQUNFLg0KPiA+ID4gDQo+ID4gPiBG
aXhlczogY2VmMzVhZjM0ZDZkICgibmV0L21seDVlOiBBZGQgbWx4NWUgSFYgVkhDQSBzdGF0cyBh
Z2VudCIpDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBNYW8gV2VuYW4gPG1hb3dlbmFuQGh1YXdlaS5j
b20+DQo+ID4gPiAtLS0NCj4gPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvS2NvbmZpZyB8IDEgKw0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigr
KQ0KPiA+ID4gDQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL0tjb25maWcNCj4gPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL0tjb25maWcNCj4gPiA+IGluZGV4IDM3ZmVmOGMuLmE2YTcwY2UgMTAwNjQ0
DQo+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvS2Nv
bmZpZw0KPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L0tjb25maWcNCj4gPiA+IEBAIC0zNSw2ICszNSw3IEBAIGNvbmZpZyBNTFg1X0NPUkVfRU4NCj4g
PiA+ICAJZGVwZW5kcyBvbiBJUFY2PXkgfHwgSVBWNj1uIHx8IE1MWDVfQ09SRT1tDQo+ID4gDQo+
ID4gT1QgYnV0IC4uLg0KPiA+IGlzIHRoYXQgSVBWNiBuZWVkZWQgYXQgYWxsID8gY2FuIHRoZXJl
IGJlIHNvbWV0aGluZyBlbHNlIHRoYXQgeWVzDQo+ID4gb3Igbm8gPw0KDQpvbmx5IG5lZWRlZCBm
b3IgZW5fcmVwLmMvZW5fdGMuYyB3aGljaCBhcmUgb25seSBjb21waWxlZCB3aGVuDQpNTFg1X0VT
V0lUQ0ggaXMgc2VsZWN0ZWQsIHNvIGFjdHVhbGx5IHN1Y2ggY29uZGl0aW9uIHNob3VsZCBiZSBm
b3INCk1MWDVfRVNXSVRDSCBhbmQgbm90IE1MWDVfQ09SRV9FTg0KDQp0ZXN0ZWQgd2l0aDoNCk1M
WDVfQ09SRT15DQpNTFg1X0NPUkVfRU49eQ0KSVBWNj1tDQoNCmFuZCByZW1vdmVkIHRoZSBkZXBl
bmRlbmN5Lg0Kc28gaWYgaXB2NiBpcyBhIG1vZHVsZSBidXQgbWx4NSBpcyBidWlsdGluIHRoaXMg
d2lsbCBoYXBwZW4uLiANCg0KbGQ6IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lbl9yZXAubzogaW4gZnVuY3Rpb24NCmBtbHg1ZV9yZXBfbmVpZ2hfdXBkYXRlX2luaXRf
aW50ZXJ2YWwnOg0KL2hvbWUvc2FlZWRtL2RldmVsL2xpbnV4L2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lbl9yZXANCi5jOjUwNTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0
byBgbmRfdGJsJw0KbGQ6IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
bl9yZXAubzogaW4gZnVuY3Rpb24NCmBtbHg1ZV9yZXBfbmV0ZXZlbnRfZXZlbnQnOg0KL2hvbWUv
c2FlZWRtL2RldmVsL2xpbnV4L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbl9yZXANCi5jOjk0NjogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgbmRfdGJsJw0KbGQ6DQov
aG9tZS9zYWVlZG0vZGV2ZWwvbGludXgvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2VuX3JlcA0KLmM6OTE5OiB1bmRlZmluZWQgcmVmZXJlbmNlIHRvIGBuZF90YmwnDQps
ZDogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3RjLm86IGluIGZ1
bmN0aW9uDQpgbWx4NWVfdGNfdXBkYXRlX25laWdoX3VzZWRfdmFsdWUnOg0KL2hvbWUvc2FlZWRt
L2RldmVsL2xpbnV4L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90
Yy4NCmM6MTQ5NzogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgbmRfdGJsJw0KDQp0aGUgcHJvYmxl
bSBpcyB0aGF0IG1seDVfY29yZSBjYW4ndCBiZSBidWlsdGluIGlmIGlwdjYgaXMgYSBtb2R1bGUg
ZHVlDQp0byB0aGlzIG5kX3RibCBkZXBlbmRlbmN5IA0KDQpJIHRoaW5rIHRoaXMgaXMgc29sdmFi
bGUgYnkgdXNpbmcgaXB2Nl9zdHViLT5uZF90YmwsIGluc3RlYWQgb2YNCnJlZmVyZW5jaW5nIG1k
X3RibCBkaXJlY3RseSBmcm9tIG1seDUuDQoNCj4gDQo+IElmIEkgc2V0IElQVjY9bSwgZXJyb3Jz
IGFyZSBmb3VuZCBhcyBiZWxvdzoNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL21haW4ubzogSW4gZnVuY3Rpb24NCj4gYG1seDVfdW5sb2FkJzoNCj4gbWFpbi5jOigu
dGV4dCsweDI3NSk6IHVuZGVmaW5lZCByZWZlcmVuY2UgdG8gYG1seDVfaHZfdmhjYV9jbGVhbnVw
Jw0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFpbi5vOiBJbiBm
dW5jdGlvbg0KPiBgbWx4NV9jbGVhbnVwX29uY2UnOg0KPiBtYWluLmM6KC50ZXh0KzB4MmU4KTog
dW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgbWx4NV9odl92aGNhX2Rlc3Ryb3knDQo+IGRyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9tYWluLm86IEluIGZ1bmN0aW9uDQo+IGBt
bHg1X2xvYWRfb25lJzoNCj4gbWFpbi5jOigudGV4dCsweDIzYzEpOiB1bmRlZmluZWQgcmVmZXJl
bmNlIHRvIGBtbHg1X2h2X3ZoY2FfY3JlYXRlJw0KPiBtYWluLmM6KC50ZXh0KzB4MjQ4Zik6IHVu
ZGVmaW5lZCByZWZlcmVuY2UgdG8gYG1seDVfaHZfdmhjYV9pbml0Jw0KPiBtYWluLmM6KC50ZXh0
KzB4MjVlMCk6IHVuZGVmaW5lZCByZWZlcmVuY2UgdG8gYG1seDVfaHZfdmhjYV9jbGVhbnVwDQoN
CnRoaXMgaXMgbm90IHJlbGF0ZWQsIGkgdGhpbmsgdGhlcmUgaXMgc29tZXRoaW5nIHdyb25nIHdp
dGggeW91ciBsb2NhbA0KcmVwb3NpdG9yeS4NCg0K

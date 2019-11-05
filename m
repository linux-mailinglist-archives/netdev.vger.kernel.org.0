Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60513F00A4
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 16:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731061AbfKEPEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 10:04:02 -0500
Received: from mail-eopbgr10082.outbound.protection.outlook.com ([40.107.1.82]:56816
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730833AbfKEPEC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 10:04:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gM6vvAlUZhsC00N0WcnqD1UyAMNZ5l2spNzzzIt7yobsNya//OUo95QzJNFRgPG2K5JzVvBhiP8ka+8I5zX4WtFHL/flkpgN+N69HRCphhgQaBjx6LcDBPetufR/lrwHZfNn4bNFgKLFIRQ4tvdGF+Iap5AVORPDFzAgF4WwczmXnpK9dy41oJ3NHW91jE3jFrYUAjty9cWAJUV5tgJeCtlU+0yhXjoaBK2FBzJhRuXSguAr0NoIkSCXRJI/yIJ33Un1BfqcqR/j4f20QT+lirtBZbk7dYUFCRlqLBJ+TBZHeqk0Sa+gUF7xjAeWkNvG9CUUqFog1E2TW8Myb/+/PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+YWA3/kHyGd2mPI0OSUXxwQ58Syr/JjXV4TOEeIqrc=;
 b=fbbeyr0r77n8oCZqD6uan3/FuU2mJSpuGqkPEtk0Fni6DtzNnrlLWmc9gvAJibR5E1vpNf3j3DKy3plB31QpMb4haASJrP7ShMxn+N7TkAKPC7TWrgudaEPE7y9fPI56yHOlo7h1sy57oosyHlpoHxRENGHkb7P/9zeAOIxvuzWZI+6TfwZ6DNNiv7/PRAv9W04AO6SmUHp3oi/BxdcNzv4GQyf1LYG6fH/fAGb9t9vyj7GDBgAh9XbJvoT5FkOmQqzFywUGvdKz1GYTJFKt6F+Cf587ER8UDQlpxdROMelRKvQyZjFHmeen9CO+s8seUO20qkhZqb/98AUPHkGAkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+YWA3/kHyGd2mPI0OSUXxwQ58Syr/JjXV4TOEeIqrc=;
 b=ZJ9hZZqOnGCUabwcT2Bxea7Fqi1F7+GMH6st2ZQrseKxoeW34uoN4yUEFhi2ws0ZdMK1grFGAkHL/AqROwj97XYXifh9x/FFp9qAeHD3yr+KOQvilfP29E635pb/Hsra/wWWwSSUK3blpPeBtmTyWuo7CW5aTiRtFrqPcnIdTvw=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5217.eurprd05.prod.outlook.com (20.178.19.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 15:03:55 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Tue, 5 Nov 2019
 15:03:55 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Colin King <colin.king@canonical.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH][next] net/mlx5: fix spelling mistake "metdata" ->
 "metadata"
Thread-Topic: [PATCH][next] net/mlx5: fix spelling mistake "metdata" ->
 "metadata"
Thread-Index: AQHVk+ju1UlJpWLIEk+xlXrsXBtltqd8rIFg
Date:   Tue, 5 Nov 2019 15:03:55 +0000
Message-ID: <AM0PR05MB4866F3706C26D06AD22BD975D17E0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191105145416.60451-1-colin.king@canonical.com>
In-Reply-To: <20191105145416.60451-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:7198:5d2b:7ff1:d0d4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0d593f1b-f8db-4e13-572a-08d7620160eb
x-ms-traffictypediagnostic: AM0PR05MB5217:|AM0PR05MB5217:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5217C6BC9E01DD09018692F1D17E0@AM0PR05MB5217.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(13464003)(199004)(189003)(8676002)(81166006)(6506007)(11346002)(110136005)(76176011)(14454004)(486006)(2906002)(8936002)(6246003)(52536014)(5660300002)(71200400001)(81156014)(7696005)(66446008)(14444005)(6436002)(6116002)(54906003)(55016002)(25786009)(2501003)(316002)(74316002)(476003)(305945005)(33656002)(229853002)(9686003)(46003)(4326008)(86362001)(99286004)(478600001)(2201001)(53546011)(186003)(102836004)(66946007)(76116006)(64756008)(66476007)(7736002)(446003)(256004)(71190400001)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5217;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OnRPUJHh3Hmhhgf/uOQYR9Gs4LaEpAYHWcJzJVnKJXs44LNMd/l09XVsjckeseCl/yxXATUc6FWOOCDC1ceYEk+kTejsbZNPqKfQbT5svcVd9NQQ3IOxzzEMASxCPkNQPV/EXWk4LIplclPldb7PN4+6zO/6s8KqAy4H5Hbq2kPl3bITMdnouqZEbzhbP8vJ9pzOYuIany9zcZFvZbI5dfL8jpUI8CwtWczUa1B9k5UNtNWbt9Evos61Hkew0NHQuxj1AibH6X0kb78td/f6u3vgX66aihyT+l7X7Kz+miffmr/wrkPjFM5wXS/hrLP+ynnbsy/nxQiW5AG3NwfowhuF1hB89WEPfUvTioC6Pac9d0zOLiazNsDI9cWVeJsncWNODsQYy03TQEhW+w8Vsc6AhtE3obyauJ8u4LyTONQRpWOVD7BPgIiyHzydx432
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d593f1b-f8db-4e13-572a-08d7620160eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 15:03:55.5980
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rvFNXhR6DXcASXG3Sr/awsKg4wunsBhpV3MgJePywunI4tYpUoZqRyAiZljVyzYAolrgXJt60WLj/6N68gPM3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5217
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbGludXgta2VybmVsLW93
bmVyQHZnZXIua2VybmVsLm9yZyA8bGludXgta2VybmVsLQ0KPiBvd25lckB2Z2VyLmtlcm5lbC5v
cmc+IE9uIEJlaGFsZiBPZiBDb2xpbiBLaW5nDQo+IFNlbnQ6IFR1ZXNkYXksIE5vdmVtYmVyIDUs
IDIwMTkgODo1NCBBTQ0KPiBUbzogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+
OyBMZW9uIFJvbWFub3Zza3kNCj4gPGxlb25Aa2VybmVsLm9yZz47IERhdmlkIFMgLiBNaWxsZXIg
PGRhdmVtQGRhdmVtbG9mdC5uZXQ+Ow0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1y
ZG1hQHZnZXIua2VybmVsLm9yZw0KPiBDYzoga2VybmVsLWphbml0b3JzQHZnZXIua2VybmVsLm9y
ZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBbUEFUQ0hdW25leHRd
IG5ldC9tbHg1OiBmaXggc3BlbGxpbmcgbWlzdGFrZSAibWV0ZGF0YSIgLT4NCj4gIm1ldGFkYXRh
Ig0KPiANCj4gRnJvbTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmtpbmdAY2Fub25pY2FsLmNvbT4N
Cj4gDQo+IFRoZXJlIGlzIGEgc3BlbGxpbmcgbWlzdGFrZSBpbiBhIGVzd193YXJuIHdhcm5pbmcg
bWVzc2FnZS4gRml4IGl0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ29saW4gSWFuIEtpbmcgPGNv
bGluLmtpbmdAY2Fub25pY2FsLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZsb2Fkcy5jIHwgMiArLQ0KPiAgMSBmaWxlIGNo
YW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2hfb2ZmbG9hZHMu
Yw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29m
ZmxvYWRzLmMNCj4gaW5kZXggYmQ5ZmQ1OWQ4MjMzLi4xYzNmZGVlODc1ODggMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxv
YWRzLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vz
d2l0Y2hfb2ZmbG9hZHMuYw0KPiBAQCAtMTg3Nyw3ICsxODc3LDcgQEAgc3RhdGljIGludA0KPiBl
c3dfdnBvcnRfY3JlYXRlX2luZ3Jlc3NfYWNsX2dyb3VwKHN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVz
dywNCj4gIAlpZiAoSVNfRVJSKGcpKSB7DQo+ICAJCXJldCA9IFBUUl9FUlIoZyk7DQo+ICAJCWVz
d193YXJuKGVzdy0+ZGV2LA0KPiAtCQkJICJGYWlsZWQgdG8gY3JlYXRlIHZwb3J0WyVkXSBpbmdy
ZXNzIG1ldGRhdGEgZ3JvdXAsDQo+IGVyciglZClcbiIsDQo+ICsJCQkgIkZhaWxlZCB0byBjcmVh
dGUgdnBvcnRbJWRdIGluZ3Jlc3MgbWV0YWRhdGEgZ3JvdXAsDQo+IGVyciglZClcbiIsDQo+ICAJ
CQkgdnBvcnQtPnZwb3J0LCByZXQpOw0KPiAgCQlnb3RvIGdycF9lcnI7DQo+ICAJfQ0KPiAtLQ0K
PiAyLjIwLjENClJldmlld2VkLWJ5OiBQYXJhdiBQYW5kaXQgPHBhcmF2QG1lbGxhbm94LmNvbT4N
Cg0K

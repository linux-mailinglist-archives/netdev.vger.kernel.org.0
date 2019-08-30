Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFD8A3FC7
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 23:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbfH3Vnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 17:43:39 -0400
Received: from mail-eopbgr20064.outbound.protection.outlook.com ([40.107.2.64]:31559
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728079AbfH3Vnj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 17:43:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ve9wBmZeY0y89Z49JFRwcIiqIhqvOvHENLFka/ykd/5F8hE/OoHyedRQ9OTWvuQOjss9dmTxLgRMYKMfbFUJfU+Oca+NLiz4KsKdcvq5bMGf1JVzmwGhVRidCxsPicFCKnmjghxenLw/arSQjbvPAQ+fmxVyfSo04/Tszc5GnvaS9/CDxW/wsq5ECcHSmKfRni35gX6HAwpTy8iDb5lG8G2ZFPhKdDtKlAjpdSd8OTHo7CZFEAiLW9nzUXo92Tl4t6cjoWqNNyT/1RhPmCxudMxawMHSa5dcvWAyOfB72B/MYalvXLDvzxZ4jqOW/GXEfE9JeiOHcxNcAS6bRha+wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSEsD5C0xT1UCKbxVlBzi7i8s3cEmVVtXg3dOehKOws=;
 b=k/7muPa8KNX75n9vSiR/+OlvOJ7hTuKKtKv9TMTr5YWfJe96GVqRIQlbG0exZRWb9tKPoZN9Zm+NSFGSGXoinfdjJlvZuMonAgTwi8qAqtdMLk6U1fKKlaY80TSCJtpwtok7w2+qr2E5vurzxnOwZp1U/4xaBYcKcZ3jNqJ9wVEX+/r8XvZGgpgnP7sFTq08pV70suokc7rzbjvVzAO3U96HP61UkCnMv/FIdlIlJZsRGpcMEX276jMf+v3GHkJDvBETeYSUIvtdx6mHVcZaTocsLFG01vSHjgC9e9PQwGTXHZE+ow9d7ChPY/UB9SnyNwPQ2edIZ5b/GyGdwRJ1fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSEsD5C0xT1UCKbxVlBzi7i8s3cEmVVtXg3dOehKOws=;
 b=HHg/iutjFor41F8xHxxPCazlGq/Bdot2OGzKS83XUEy3SZ39E8WtaDDNlprKbNO5mNourENRpgBqAft7hHcFbWpROFXTHcnr+Jj0y0EFJKKFjNfxGx3ChlUOyLNLE1xh+maPcQTNYBzHHnj5GX1/+gtjPxnyP8KHmLpL3mkJAA8=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2322.eurprd05.prod.outlook.com (10.165.82.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Fri, 30 Aug 2019 21:43:34 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.020; Fri, 30 Aug 2019
 21:43:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "maowenan@huawei.com" <maowenan@huawei.com>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] net: mlx5: Kconfig: Fix MLX5_CORE_EN dependencies
Thread-Topic: [PATCH -next] net: mlx5: Kconfig: Fix MLX5_CORE_EN dependencies
Thread-Index: AQHVXITcCNibTH++QEWLgS4IcRgEMqcUPuUA
Date:   Fri, 30 Aug 2019 21:43:34 +0000
Message-ID: <ef0ab9738f6afa81c709f56cffe4bcad13bec654.camel@mellanox.com>
References: <20190827031251.98881-1-maowenan@huawei.com>
In-Reply-To: <20190827031251.98881-1-maowenan@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f60d379a-bbff-4052-d67c-08d72d931bc4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2322;
x-ms-traffictypediagnostic: AM4PR0501MB2322:
x-microsoft-antispam-prvs: <AM4PR0501MB23222E9C357FBA42C2C56DA1BEBD0@AM4PR0501MB2322.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:765;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(366004)(39850400004)(136003)(346002)(189003)(199004)(91956017)(66946007)(76116006)(6506007)(229853002)(478600001)(102836004)(7736002)(2501003)(3846002)(5660300002)(4744005)(14454004)(6116002)(316002)(36756003)(256004)(8936002)(4326008)(305945005)(6436002)(53936002)(81156014)(6246003)(2906002)(99286004)(58126008)(71190400001)(71200400001)(6512007)(110136005)(26005)(66476007)(476003)(6486002)(66066001)(446003)(486006)(64756008)(66556008)(11346002)(81166006)(25786009)(186003)(2616005)(66446008)(2201001)(118296001)(54906003)(86362001)(76176011)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2322;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fOz+0qMSq0dz0GBGW24BUxfjFi7TQBUMoCp2H1H8Q+XkqtsSCN5zMYwHSekCcSGtxsU6TA6FGUrn2volZnl0MyJ4ASVfXiNd0McXMANei6jvOGqBWcG7iE4KdlqJ+luWhwv2ymUjmZkS0S1TMXrH8wT/2GnIXHn8Wai76cglrRvkj5hgWvr9sHBt3J2UHFpG32oFYTANXuWKbZe1GIWwJmIpJa3cX00c/sTjcwnMOmX2G5ThX2PRMVEUwG/NifhBxjmgD8/EID6dQmpOAtul7Ik+33vbER3CGHK4jSUxtAjnS+qIXDP6LkMybMTVkqJ/LMJuB4XA+z/mcRZ10Ms72F1XioYWFdgRxTJNnD4HBQkYxGRRO4nbncN5uW1vMpzRWcz3CSYINM7LF7B6zCTRA2Yg394xFq2fqxC4wr7ZzX4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C49BF789E69254DAFCD77FA47F5257D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f60d379a-bbff-4052-d67c-08d72d931bc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 21:43:34.4512
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hTEVswJTAcPsn6Jq6HbEL7G5LjS87p+qS2JW02k32qrPKD97rSxqYsWe17qP9j1k8/lX8m9K+S3CZIUKe7/nrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2322
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA4LTI3IGF0IDExOjEyICswODAwLCBNYW8gV2VuYW4gd3JvdGU6DQo+IFdo
ZW4gTUxYNV9DT1JFX0VOPXkgYW5kIFBDSV9IWVBFUlZfSU5URVJGQUNFIGlzIG5vdCBzZXQsIGJl
bG93IGVycm9ycw0KDQpUaGUgaXNzdWUgaGFwcGVucyB3aGVuIFBDSV9IWVBFUlZfSU5URVJGQUNF
IGlzIGEgbW9kdWxlIGFuZCBtbHg1X2NvcmUNCmlzIGJ1aWx0LWluLg0KDQo+IGFyZSBmb3VuZDoN
Cj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4ubzogSW4g
ZnVuY3Rpb24NCj4gYG1seDVlX25pY19lbmFibGUnOg0KPiBlbl9tYWluLmM6KC50ZXh0KzB4YjY0
OSk6IHVuZGVmaW5lZCByZWZlcmVuY2UgdG8NCj4gYG1seDVlX2h2X3ZoY2Ffc3RhdHNfY3JlYXRl
Jw0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5vOiBJ
biBmdW5jdGlvbg0KPiBgbWx4NWVfbmljX2Rpc2FibGUnOg0KPiBlbl9tYWluLmM6KC50ZXh0KzB4
YjhjNCk6IHVuZGVmaW5lZCByZWZlcmVuY2UgdG8NCj4gYG1seDVlX2h2X3ZoY2Ffc3RhdHNfZGVz
dHJveScNCj4gDQo+IFRoaXMgYmVjYXVzZSBDT05GSUdfUENJX0hZUEVSVl9JTlRFUkZBQ0UgaXMg
bmV3bHkgaW50cm9kdWNlZCBieQ0KPiAnY29tbWl0IDM0OGRkOTNlNDBjMQ0KPiAoIlBDSTogaHY6
IEFkZCBhIEh5cGVyLVYgUENJIGludGVyZmFjZSBkcml2ZXIgZm9yIHNvZnR3YXJlDQo+IGJhY2tj
aGFubmVsIGludGVyZmFjZSIpLA0KPiBGaXggdGhpcyBieSBtYWtpbmcgTUxYNV9DT1JFX0VOIGlt
cGx5IFBDSV9IWVBFUlZfSU5URVJGQUNFLg0KPiANCg0KdGhlIGltcGx5IHNob3VsZCBiZSBpbiBN
TFg1X0NPUkUgbm90IE1MWDVfQ09SRV9FTiBzaW5jZSB0aGUNCmltcGxlbWVudGF0aW9uIGFsc28g
aW52b2x2ZXMgTUxYNV9DT1JFLiANCg0KSSB3aWxsIHByZXBhcmUgYSBwYXRjaCB3aXRoIHRoZXNl
IGZpeHVwcy4NCg0KVGhhbmtzLA0KU2FlZWQuDQoNCg==

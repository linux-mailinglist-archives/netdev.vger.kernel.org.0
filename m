Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF88E559B6
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 23:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFYVLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 17:11:23 -0400
Received: from mail-eopbgr130054.outbound.protection.outlook.com ([40.107.13.54]:49781
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725782AbfFYVLW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 17:11:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=vi5+LHyMnN3P0DCaIY19PwGtj3V+Dg/AERKkHvZ4vR0UIdZo1EuuKXVzIU+RXHCMvF68a5bj1/aNx4SGINdjp/pJdF/JeiGDhNGZis7scwEBhyvK6iDf5SsUuuv+aYSarspO7zGmJ03mA6mhM7Iw54ZA5NevkNOb14BJPbfqXkY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xgGJo5z+qyYGD94sUU/W7D5hbcqT/Jb9JIqp0hX+HQ=;
 b=eVJ9WJL/Q+yAf0wZdupSwmhIPk515v+EtNm5js5z0gM3oFf65xo9dK3eV7WBuGashRoHZIwb1ixQDMSsyLLCcnsezNFudFYbZw9Xl8/ybVJE6esjSFb+dtrX7pzNgVIVwVcUWxd7EaEpc9gtBhnd9exaCxOlkrK/UhoH6FMIK44=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xgGJo5z+qyYGD94sUU/W7D5hbcqT/Jb9JIqp0hX+HQ=;
 b=FaMXt6Hqv9f/bSBwigjL2B0uq9v007yUv/2O4msQl6nG2hL0DOB/W2ALUKZ07F7aW/gKdKbz9vEBjskkgnEW89pu0iUVotMDJaZj7j4IVP6KaLz3+MKXx2P2m109DgzSgfKgMaKO8CM9SsGBfXjxKSXUdQTh3OjQu7PycIppklE=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2277.eurprd05.prod.outlook.com (10.168.55.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 21:11:15 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 21:11:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>
CC:     "kernel-team@fb.com" <kernel-team@fb.com>,
        "jsorensen@fb.com" <jsorensen@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/1] Fix broken build of mlx5
Thread-Topic: [PATCH 0/1] Fix broken build of mlx5
Thread-Index: AQHVK2p5cHu0NxJ3VEyhqsMR/NsxyqaspysAgAACJwCAADTigA==
Date:   Tue, 25 Jun 2019 21:11:15 +0000
Message-ID: <1d667c7687ddeb0a17af67f66addcbe89bcdb6a5.camel@mellanox.com>
References: <20190625152708.23729-1-Jes.Sorensen@gmail.com>
         <134e3a684c27fddeeeac111e5b4fac4093473731.camel@mellanox.com>
         <74cb713f-ad8c-7f86-c611-9dd4265f1c9b@gmail.com>
In-Reply-To: <74cb713f-ad8c-7f86-c611-9dd4265f1c9b@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.3 (3.32.3-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 55772e74-0b62-486d-9fcf-08d6f9b1a8ac
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2277;
x-ms-traffictypediagnostic: DB6PR0501MB2277:
x-microsoft-antispam-prvs: <DB6PR0501MB227709E28CC22A526A875BDFBEE30@DB6PR0501MB2277.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(396003)(346002)(39860400002)(366004)(189003)(199004)(102836004)(53936002)(54906003)(316002)(91956017)(71200400001)(229853002)(25786009)(71190400001)(66446008)(26005)(66476007)(186003)(5640700003)(76176011)(446003)(305945005)(66556008)(53546011)(256004)(64756008)(486006)(14454004)(2906002)(66066001)(7736002)(11346002)(6916009)(6512007)(68736007)(1361003)(58126008)(8936002)(6486002)(81166006)(81156014)(2616005)(3846002)(86362001)(6246003)(6116002)(4326008)(2351001)(36756003)(5660300002)(8676002)(478600001)(2501003)(476003)(118296001)(73956011)(66946007)(99286004)(76116006)(6436002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2277;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Vk3HIMqB4WFhL0so6m598ZyqbWlSJvFrUT/YI3OUSdIsnhgzbTM+dH74nd8z17tAj1p2pqr+Y5JvAqP3v6gNFQG91c6ScLLswh5Oey+Wr7zmMNn17u4XYRiaN5uSOQ+Nnp8bi3LyGsemWeQEggBbMGGqGCH0kUrOAHtSeB7CO0Qf071X0UFoBkScRBvJhOi1w5bMmM0ch8Kz2wyg7NLcZexl3Q7MLHlJ8Q9VFETn1w5GDFjxashHQUHCwUlQWFdBA2ZUxRXC61blqVpRI3ykF6QokKpTtvI41F2ZHbead6wrjmFGzkBtHanAByMsMZ1WYqqP+pFRQpsgICylGcZ65IBKBVg98srCWSJ3YHB59C43F6+0TUZjQO1FRgo9o8W+71Zjtul5m7+kcczv1Yd/xXrqj7425G5jS2e86+Lhyg8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0DA5213DC4F5554D9D97E7B394EF4342@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55772e74-0b62-486d-9fcf-08d6f9b1a8ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 21:11:15.3266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2277
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA2LTI1IGF0IDE0OjAxIC0wNDAwLCBKZXMgU29yZW5zZW4gd3JvdGU6DQo+
IE9uIDYvMjUvMTkgMTo1NCBQTSwgU2FlZWQgTWFoYW1lZWQgd3JvdGU6DQo+ID4gT24gVHVlLCAy
MDE5LTA2LTI1IGF0IDExOjI3IC0wNDAwLCBKZXMgU29yZW5zZW4gd3JvdGU6DQo+ID4gPiBGcm9t
OiBKZXMgU29yZW5zZW4gPGpzb3JlbnNlbkBmYi5jb20+DQo+ID4gPiANCj4gPiA+IFRoaXMgZml4
ZXMgYW4gb2J2aW91cyBidWlsZCBlcnJvciB0aGF0IGNvdWxkIGhhdmUgYmVlbiBjYXVnaHQgYnkN
Cj4gPiA+IHNpbXBseSBidWlsZGluZyB0aGUgY29kZSBiZWZvcmUgcHVzaGluZyBvdXQgdGhlIHBh
dGNoLg0KPiA+ID4gDQo+ID4gDQo+ID4gSGkgSmVzLA0KPiA+IA0KPiA+IEp1c3QgdGVzdGVkIGFn
YWluLCBhcyBJIGhhdmUgdGVzdGVkIGJlZm9yZSBzdWJtaXR0aW5nIHRoZSBibGFtZWQNCj4gPiBw
YXRjaCwNCj4gPiBhbmQgYXMgd2UgdGVzdCBvbiBldmVyeSBzaW5nbGUgbmV3IHBhdGNoIGluIG91
ciBidWlsZCBhdXRvbWF0aW9uLg0KPiA+IA0KPiA+IGJvdGggY29tYmluYXRpb25zIENPTkZJR19N
TFg1X0VOX1JYTkZDPXkvbiB3b3JrIG9uIGxhdGVzdCBuZXQtbmV4dCwNCj4gPiB3aGF0IGFtIGkg
bWlzc2luZyA/DQo+IA0KPiBMaW51cycgdHJlZToNCj4gDQo+IFtqZXNAeHBlYXMgbGludXguZ2l0
XSQgZ3JlcCBtbHg1ZV9nZXRfcnhuZmMNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlLyouYw0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUv
ZW4vKi5oDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9ldGh0
b29sLmM6c3RhdGljIGludA0KPiBtbHg1ZV9nZXRfcnhuZmMoc3RydWN0IG5ldF9kZXZpY2UgKmRl
diwgc3RydWN0IGV0aHRvb2xfcnhuZmMgKmluZm8sDQo+IHUzMg0KPiAqcnVsZV9sb2NzKQ0KPiBk
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fZXRodG9vbC5jOgkuZ2V0
X3J4bmZjDQo+ID0gbWx4NWVfZ2V0X3J4bmZjLA0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZW5fZnNfZXRodG9vbC5jOmludA0KPiBtbHg1ZV9nZXRfcnhuZmMoc3Ry
dWN0IG5ldF9kZXZpY2UgKmRldiwNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2VuL2ZzLmg6aW50DQo+IG1seDVlX2dldF9yeG5mYyhzdHJ1Y3QgbmV0X2RldmljZSAq
ZGV2LA0KPiANCj4gc3RhdGljIHZzIG5vbiBzdGF0aWMgZnVuY3Rpb25zLCB3aXRoIGEgcHJvdG90
eXBlIHRoYXQgaXMgbm9uIHN0YXRpYy4NCg0KQnV0IG9ubHkgb25lIHByb3RvdHlwZSBjYW4gYmUg
c2VsZWN0ZWQgYW5kIGl0IGlzIGFjY29yZGluZw0KQ09ORklHX01MWDVfRU5fUlhORkMNCg0Kd2hl
biBDT05GSUdfTUxYNV9FTl9SWE5GQz1uIHRoZW4gdGhlIHN0YXRpYyBwcm90b3R5cGUgd2lsbCBi
ZSBzZWxlY3RlZA0KYW5kIHRoZSBvdGhlciBvbmUgd2lsbCBiZSBjb21waWxlZCBvdXQuDQoNCndo
ZW4gQ09ORklHX01MWDVfRU5fUlhORkM9eSB0aGUgbm9uIHN0YXRpYyBwcm90b3R5cGUgd2lsbCBi
ZSBzZWxlY3RlZA0KYW5kIHRoZSBzdGF0aWMgb25lIHdpbGwgYmUgY29tcGlsZWQgb3V0Lg0KDQpT
byBubyBpc3N1ZSBoZXJlLg0KDQo+IA0KPiBKZXMNCg==

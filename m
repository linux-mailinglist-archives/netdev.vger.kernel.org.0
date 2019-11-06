Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE57F0ECB
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 07:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729549AbfKFGVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 01:21:23 -0500
Received: from mail-eopbgr00079.outbound.protection.outlook.com ([40.107.0.79]:33856
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725812AbfKFGVW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 01:21:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AEG+7XH2Qf5bPyqnbedNfBydnoKkxoYIpjsSxx+unBWw6lxf2f66ChvRf4fi86OLAfSb5z28FfPb2hR5Pb84TDnIpueQytKxVNxsvi73NQg9aLzdIoGSnqv8rrWUwLwn3ZkewUEz52Nls3vj9ya0Yx2wIEJg3FHtBKkkroZ5YH5wbfUBvs9z1W0lp39RzyEDuWziOiS2q/ON26pBH1XbEIRsu9f+eBjGr2RMhEe5nHooeMYCn+Sdmd1dO0wo7MMxybIdnNil34j+wTSwDHuxYDEZ25CsLM0nIi/sDlHMmuMY87lvzM2a/2LoNBJh9s3ZZaLAXCps9o0RsUAiPajnFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSg3GjTphvjL6eURBW6TTGWT+Ne81caN9ncp2MRxQ50=;
 b=DB9qXgEtrDvJtqTJClbaI3ndznEhZvpCOjhooDVXmZtYPzI8FkHRqaxVNTOtsOK3hBpHrIeVyIBtQ6kJbze/TKDIwVj4Ik8oo4mNj/44v8kDG6z73gz93vM86DTYVR4xlith+aVGVca+dAXk+NFcHzfPQDI/1RdjlUxgGZEMnOVnVyuoBAYnR56a5OpnmeM3e32NhUbqYVGYrUwzLTEiblDvx2mNitOFuyIEumY/U80IilJmRcuLaIA+5Wgq7xGt3TqarmZ8Xy4ituJDN4mphOYSQxr5y5RkiLmRtn5l21OROzf932hF5X3RC3Y8wxJh92t4rpstD6jL6oUU4PwQ4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSg3GjTphvjL6eURBW6TTGWT+Ne81caN9ncp2MRxQ50=;
 b=IsJcWKld09ENkbP3nL7vZXGFy+liQSTDwZDVQNrJ+Ao0dmgLXEjbJSTqyA3p15qHhyinaa4tEKVNt8c78MnR3376+eBfr6IvyMMmbZsG8bHaZPJ5RQ71eMDmYziEyIuTOOtRYjNS+7R1oOqeJ33t9tYyO2h9V79OnlP1dbrpVBY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6446.eurprd05.prod.outlook.com (20.179.28.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Wed, 6 Nov 2019 06:21:18 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Wed, 6 Nov 2019
 06:21:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "colin.king@canonical.com" <colin.king@canonical.com>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] net/mlx5: fix spelling mistake "metdata" ->
 "metadata"
Thread-Topic: [PATCH][next] net/mlx5: fix spelling mistake "metdata" ->
 "metadata"
Thread-Index: AQHVk+jnPLY8v2TAj0OuyvOpB0dwZ6d9bdoAgAA/GwA=
Date:   Wed, 6 Nov 2019 06:21:17 +0000
Message-ID: <d3e21e89d017add523749494bb70854402d9cd63.camel@mellanox.com>
References: <20191105145416.60451-1-colin.king@canonical.com>
         <20191105.183522.2155800632990290770.davem@davemloft.net>
In-Reply-To: <20191105.183522.2155800632990290770.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c49af608-4e4b-4e74-6fdb-08d7628188c9
x-ms-traffictypediagnostic: VI1PR05MB6446:
x-microsoft-antispam-prvs: <VI1PR05MB644663B954F18C16B1FA266FBE790@VI1PR05MB6446.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(189003)(199004)(71190400001)(71200400001)(14444005)(256004)(8936002)(2501003)(8676002)(54906003)(6512007)(6246003)(446003)(229853002)(11346002)(4326008)(118296001)(2616005)(476003)(6436002)(25786009)(486006)(6486002)(26005)(66066001)(2906002)(102836004)(305945005)(66446008)(64756008)(66476007)(66556008)(66946007)(99286004)(316002)(91956017)(5660300002)(76116006)(86362001)(36756003)(186003)(4744005)(81166006)(81156014)(110136005)(478600001)(58126008)(14454004)(3846002)(76176011)(7736002)(6506007)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6446;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R8Y8VjoybGNfULv8QgQKXClCkNRcffFlJ9u/6c6Ml/WpGA0Vp1se3Uwfc1M+nXAkBoVDV9NSKte8+VeOaeP/15oIHoH27gT0W299y4yedyoz9fLQ7WZQKQtPywt9an6kqi9kDEdA/zXnO88TdUhxdlrDwYmy+RfYYCSE7gD/WVgGMQd26t6x/B59+wxPwn27y/VZ4L6+6Hx/lUFXXz82zrIT8aoFUHk9+wEbqnO1JzSFi67X3OU2xq8zt98jrw0HJWVJ9QdvPQEoRh5FNLZvRQnRNcoLlK5eojINoWO6nj5SRKjOdTwIZ053hZGMhDIZiKbWSoJEkU84nQsX7aNuSj93LfYzS+vHtaNprb3DOD1ZJHdD+3ljPbvbuYTjWY72eGSdt6tWgpJI9kJakqkorjVI8K1p7D8Mlx2h5GCAh9Rj+5UlWLC4FjinNVU+9zPw
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <01F62C305A27E34A81425FCF14541C56@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c49af608-4e4b-4e74-6fdb-08d7628188c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 06:21:17.9791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /yNSCabBdsi0ofjTqvyDcgCEX/KfyMVWdAmoppk6xPte/+0DNSsgyvKXRP6Gxm5mvyeLAJQuZRkQYKTN1EPndw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6446
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTExLTA1IGF0IDE4OjM1IC0wODAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IENvbGluIEtpbmcgPGNvbGluLmtpbmdAY2Fub25pY2FsLmNvbT4NCj4gRGF0ZTogVHVl
LCAgNSBOb3YgMjAxOSAxNDo1NDoxNiArMDAwMA0KPiANCj4gPiBGcm9tOiBDb2xpbiBJYW4gS2lu
ZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiA+IA0KPiA+IFRoZXJlIGlzIGEgc3BlbGxp
bmcgbWlzdGFrZSBpbiBhIGVzd193YXJuIHdhcm5pbmcgbWVzc2FnZS4gRml4IGl0Lg0KPiA+IA0K
PiA+IFNpZ25lZC1vZmYtYnk6IENvbGluIElhbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5j
b20+DQo+IA0KPiBTYWVlZCwgcGxlYXNlIHBpY2sgdGhpcyBvbmUgdXAuDQo+IA0KPiBUaGFuayB5
b3UuDQoNCkFwcGxpZWQgdG8gbWx4NS1uZXh0Lg0KVGhhbmtzIQ0K

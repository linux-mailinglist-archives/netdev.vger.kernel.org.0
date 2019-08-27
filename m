Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE0A9F3D9
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 22:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731263AbfH0UOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 16:14:50 -0400
Received: from mail-eopbgr50063.outbound.protection.outlook.com ([40.107.5.63]:7628
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726871AbfH0UOu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 16:14:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nN96/cFYF3uKSLDXeCsZBYkDaS8M+IeZ2epWi4KStdU3nKrXEAD2t11sQfw+LscuT1GPocrJE2AeK26PTdGs02CFgu0AY28g4KCe0nKzPHFiuZOItrEPodZJ5+pi8+q6O9sSM/xBPse4W2vHqMDhrGjftD1mlEaPHJnckI3zIqFGXzY4YDufvuUOpFvp1QAET6WwpyY0ZHjb/exRXwrhundcw4ugEz2UwJol+0msBtNAlm/PsAdQdg9U3OdKXzUw3hhr5Q/+2kLttIm32ZeeuUewhjZ78gnNwJJ42muAFm6fow1tAk3XjCobHZKN0Tbw5JZagucdJGr6nqsL7ZNzCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gAs/2mUpXc3whqps2scs0H1qqUKhOGvBX0E+gjUjvOE=;
 b=BUUdvIsjn0RLvJGhE8k4IKtzniSUGIgAW+VdVxsFKeTJ2sF+kVLPCsSyUIbxq6x1mIlu4Is9egirpKe6tCgrW+lvha9maQpRyGLAtCPEq0aGXE3GYgeE+Ff/wNPYXqX4It1BN+2aUjF6pobFDCCLPSZrRZUdOXGThvL28zNll01U00j3K65gpJYZqYE6Z08mVSWZhUsG4PXSKOWzirYCk7GQx22iMQZGvh1vM5jWAot3Y6OsP1PjIqNiph6sUvpkgN56GUiqYEwq7Yms3EgrEONCvk0IRdEfV3/PReD7VMwQaxfNZ8jA5AwM9RLjFrHpAPfO+nd5GjpsJ526ISgwcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gAs/2mUpXc3whqps2scs0H1qqUKhOGvBX0E+gjUjvOE=;
 b=AyRqnr379rgfzA30QHqNMev2MCiKGv5ZN8fShQlyp8zm3GHCIMR3UECnlYuTScIY6dtql3wuIt82/0N8n78s42iL2fdzcrOZwsmMvaPQQsCKg6qwZYTfT1qSOuXIXz7TZyaeXGpywmAG8grgeBTvONuZXqf3YlK2uZV65wpFnNI=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2398.eurprd05.prod.outlook.com (10.168.136.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.19; Tue, 27 Aug 2019 20:14:43 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Tue, 27 Aug 2019
 20:14:43 +0000
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
Thread-Index: AQHVXITcCNibTH++QEWLgS4IcRgEMqcPbxSA
Date:   Tue, 27 Aug 2019 20:14:43 +0000
Message-ID: <715dbd69f4e06afa26aa0a500d37a4dd0638befb.camel@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 0071553f-4e2e-4083-6dbf-08d72b2b32ef
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2398;
x-ms-traffictypediagnostic: VI1PR0501MB2398:
x-microsoft-antispam-prvs: <VI1PR0501MB23984E3F3A62000F5E6DEF60BEA00@VI1PR0501MB2398.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:117;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(39860400002)(346002)(136003)(396003)(189003)(199004)(478600001)(4326008)(58126008)(76116006)(91956017)(8936002)(256004)(186003)(76176011)(2501003)(476003)(102836004)(6486002)(66066001)(305945005)(6512007)(446003)(6246003)(2201001)(2906002)(6436002)(8676002)(66556008)(110136005)(26005)(66446008)(6116002)(64756008)(66476007)(66946007)(316002)(7736002)(54906003)(81156014)(25786009)(81166006)(71190400001)(86362001)(71200400001)(486006)(3846002)(118296001)(6506007)(14454004)(5660300002)(2616005)(99286004)(11346002)(229853002)(36756003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2398;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QoXLeG3Dl3Di5AfmfF96sibM0vqq6N0+P9nM/SA4eHbKpmAHsnKQzQjqisrHK5PWrmiZakfQp8Ydv8AyKJFNMEucpqSJnGdafetGx3w1Y9EengC3/54r+HR/Lo7AnpQcVuaft8RbUaDf0yD07A37BazYVAgFlCKSZo4d5w8ovnyD2RMWglF9UhdYZzEuHoGEhAlpgPDOJ2wq5c48yYgZ8rlTtPgj7k71CqlcWo32aMhGxXlK/nMyO8d/NjBhh1n6KZAPt3x5zX9QYqZjgcs+tndOwbFb8yh7o8ZMQ56ztd1djVLqNVSK7zw4DS3Mm7N1gBI3pfsQLGTc1Ca8FIN19ZAE04qReUYPTpT1oxWXaokxeF3yOVSm8dqBbwcj1wYvJSkVBCWo3zuRSBxsVimfqVxtAHp4WjkIdYLfdgTi4e0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B898B99C561CA1428B3B353BF6964A90@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0071553f-4e2e-4083-6dbf-08d72b2b32ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 20:14:43.3055
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /Lm9+pODrUKe8/BcUMAd9dMAP724A2TV+xjP3jzj76EyJfcxwlwdHQs8ygiXV1s8LoA/ndZFDioQBWnbHcYQyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2398
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA4LTI3IGF0IDExOjEyICswODAwLCBNYW8gV2VuYW4gd3JvdGU6DQo+IFdo
ZW4gTUxYNV9DT1JFX0VOPXkgYW5kIFBDSV9IWVBFUlZfSU5URVJGQUNFIGlzIG5vdCBzZXQsIGJl
bG93IGVycm9ycw0KPiBhcmUgZm91bmQ6DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9lbl9tYWluLm86IEluIGZ1bmN0aW9uDQo+IGBtbHg1ZV9uaWNfZW5hYmxlJzoN
Cj4gZW5fbWFpbi5jOigudGV4dCsweGI2NDkpOiB1bmRlZmluZWQgcmVmZXJlbmNlIHRvDQo+IGBt
bHg1ZV9odl92aGNhX3N0YXRzX2NyZWF0ZScNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2VuX21haW4ubzogSW4gZnVuY3Rpb24NCj4gYG1seDVlX25pY19kaXNhYmxl
JzoNCj4gZW5fbWFpbi5jOigudGV4dCsweGI4YzQpOiB1bmRlZmluZWQgcmVmZXJlbmNlIHRvDQo+
IGBtbHg1ZV9odl92aGNhX3N0YXRzX2Rlc3Ryb3knDQo+IA0KPiBUaGlzIGJlY2F1c2UgQ09ORklH
X1BDSV9IWVBFUlZfSU5URVJGQUNFIGlzIG5ld2x5IGludHJvZHVjZWQgYnkNCj4gJ2NvbW1pdCAz
NDhkZDkzZTQwYzENCj4gKCJQQ0k6IGh2OiBBZGQgYSBIeXBlci1WIFBDSSBpbnRlcmZhY2UgZHJp
dmVyIGZvciBzb2Z0d2FyZQ0KPiBiYWNrY2hhbm5lbCBpbnRlcmZhY2UiKSwNCj4gRml4IHRoaXMg
YnkgbWFraW5nIE1MWDVfQ09SRV9FTiBpbXBseSBQQ0lfSFlQRVJWX0lOVEVSRkFDRS4NCj4gDQoN
CmxldCdzIG5vdCBpbXBseSBhbnl0aGluZy4uIA0KbWx4NWVfaHZfdmhjYV8qIHNob3VsZCBhbHJl
YWR5IGhhdmUgc3R1YnMgIGluIA0KbWx4NS9jb3JlL2VuL2h2X3ZoY2Ffc3RhdC5oIHdoZW4gUENJ
X0hZUEVSVl9JTlRFUkZBQ0UgaXMgb2ZmL3VuZGVmICENCg0KSSBKdXN0IHRyaWVkOg0KDQokIC4v
c2NyaXB0cy9jb25maWcgLXMgUENJX0hZUEVSVl9JTlRFUkZBQ0UNCiQgLi9zY3JpcHRzL2NvbmZp
ZyAtcyBNTFg1X0NPUkUNCiQgLi9zY3JpcHRzL2NvbmZpZyAtcyBNTFg1X0NPUkVfRU4NCnVuZGVm
DQp5DQp5DQoNCiQgbWFrZQ0KDQpBbmQgYnVpbGQgcGFzc2VkIGp1c3QgZmluZS4NCg0KDQo=

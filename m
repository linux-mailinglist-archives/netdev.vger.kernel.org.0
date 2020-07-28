Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2F02304B0
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 09:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgG1HxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 03:53:15 -0400
Received: from mail-vi1eur05on2050.outbound.protection.outlook.com ([40.107.21.50]:9376
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727930AbgG1HxM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 03:53:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aBggCzgbk+GohR+BgnHW2FHXCCsVAOAHAIdaHi4I18Gygbl41tFXcXFNgQL7V/DQ9n948YpEvqpZOueVqzZX4xuAO5hMWs95IdOPXxlx8oEMRfIYEOYbSJWY2+vMTtfmKMSfPj26+yIrNirbOZ2B+yDixyS88mCysttRrAL5q37fpfIfb5LKqT51VNBSd1YoejcLabX/V4v3gNNSN2yJAhTAXM1qpYmMNXdfd+J9EgWKJXD4Uq9FG0rC77KKcX9lOH1+xFAV5cgdqg0SQSar0bx7Rw2bREW00THSPToi1xA6KGrUwhKuw5fzvaqbt+/2vzDSa0OIp80+hAtPG7sSfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecCTnL6/+2TqoE9cWFl1D51TIICdZT4W7ghkr7hZRu0=;
 b=KLWTN/ZR1+e1iNhbVqgQSn0lMy+dBQMSKN6Bpg2sRaShzIInBDFodz0khVc0JjhroEnZPT8oBB4mVH+X3cU3hW7JChwETPbYh/GYG+mamUjUuPWoFTbfI+wxhknZmVFdmR+AoDM7FQlcQpQrCz1lze8MuyEFgh0o/YDD6jxmAKdOe67GugnGGay11mPf6SUpwq3jMDtUfefrv+whDSmaWcJnZ0KVJ/TLB8dlHk7fHILfaf7q9eTaYBoEkBEfT8U9GJcO6rc4cP9/SNFlRTAOxRD6MiPM3E0DtmhKfHptdBTuSyBNsYdoD/59hPlAXSuso3v3dq4TWLpgDeV/0qcbkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecCTnL6/+2TqoE9cWFl1D51TIICdZT4W7ghkr7hZRu0=;
 b=idPOBqX1a0A5Y33m7Vi0Rkr/wqvjtN62In9GC6Kv+7vEktIb0BvoYTKrN9Mbt1eQTEx+vn5yyGsQiLd+eEIIAbewawgPSOjtdbY7zwBqiRd5INykpF/ZDvSYup2pCap//01urDfcrh4DI745EGYp9WV7CM1jPYHpv4PFmTbGEsY=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (2603:10a6:20b:9::29)
 by AM6PR05MB6008.eurprd05.prod.outlook.com (2603:10a6:20b:a3::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Tue, 28 Jul
 2020 07:53:08 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d803:a59d:9a85:975f]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d803:a59d:9a85:975f%7]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 07:53:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "Julia.Lawall@inria.fr" <Julia.Lawall@inria.fr>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] net/mlx5: drop unnecessary list_empty
Thread-Topic: [PATCH 4/7] net/mlx5: drop unnecessary list_empty
Thread-Index: AQHWY0F4frxq877HjEGPrpmehoD3gakbq0iAgAD2dgA=
Date:   Tue, 28 Jul 2020 07:53:08 +0000
Message-ID: <86e8f054d029991167a9fe0a4bdfedff94e38022.camel@mellanox.com>
References: <1595761112-11003-1-git-send-email-Julia.Lawall@inria.fr>
         <1595761112-11003-5-git-send-email-Julia.Lawall@inria.fr>
         <20200727.101059.1257161436665415755.davem@davemloft.net>
In-Reply-To: <20200727.101059.1257161436665415755.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 810ef92f-feb4-4d87-7175-08d832cb4482
x-ms-traffictypediagnostic: AM6PR05MB6008:
x-microsoft-antispam-prvs: <AM6PR05MB600879F3A1F69DAEA65F5E46BE730@AM6PR05MB6008.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vWgcoy6tmTuns4YysqKFDd3F5DRpRBZ5brxvymsOR/3aEYD3s9fLtx7LxZZkWS9Ag+P5u+tc419DVzkxSOUcFSz8/mmXHn/JF2wj+31/bLKCflZyhQOzjsvIBTQQad69qYkcgZY3tHEqb6Y2L5SBV3FZaHMWlJiiBG0IEzQE5WoQW3CRG6WgAMwLC/XzYttv7OTCRxYOtizWFFhTw5to/y3nzwVAnIX3cCs/W0zCFNs9bWAA5hWEORVbz4hrZNalaEu+VdQ4WvRWHx1O78Av1ASgQJkWPUWXt5HgwXm5qXphrRgapxIAtf6x38i2hFNbrlr/nj+m6aivQ1tCGukHLnoeSRcjrf8Lq7S1tbWSKXw8uDf3eU4y9n4aAAWD5x5fw6wgQFZydKcF2qpxPxlA1A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5094.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(346002)(396003)(376002)(366004)(71200400001)(2906002)(8676002)(6512007)(86362001)(26005)(316002)(4326008)(8936002)(83380400001)(186003)(110136005)(54906003)(91956017)(4744005)(478600001)(76116006)(2616005)(6506007)(66476007)(66446008)(36756003)(5660300002)(66946007)(66556008)(64756008)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: j4tdcfNyMXNglkepm8QoMk4c95JJD4h8GMqX2PlezL6MtVVEJ3DuQKfgq5NTZbPMe4dFr8KpnmeVscbuwJxmf+H87A12ZNe90lokErYVP5NK6YDIU8BwdG/lBxH2/WoWRA2F27Tx0Ifh30ZkWDgs0jsSIrg4WbBgj826SRnLKzwmSWkzs0gx007AX+cFOKRiF9bfzY0JSFn5TczXoxjcf4kCar3BuR4h1xPo4M+0G8O6aw7EPwiQoJlV0RncA9kL/EJhG1vHOiILI638rLpEHiZKT65ADrL1DSbLaKmRk9NUiFSiopNOLn5ZRPCxZwXFYY4U6EZ8I4y75z3qU3BstyCIAGB7r9+hyIweAeYxDYL7VmLrlKULyj6aoqxSW49/x8CHrdUER6CWE0K0QkcgrZUITV212r5mb2bL75ijX6l6b8ugmpakQkUfLBgC3QgQvZ1dfjjDNpSvED5TSTQspSzOooa1HU4BhkJAB3ntxx4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <45C695049F1F7C409C1F172865DCA880@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5094.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 810ef92f-feb4-4d87-7175-08d832cb4482
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2020 07:53:08.1135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GYD85D0ATT21DxUUq84v3UA4Rm8liA1OU2gnwM7daDPK47rAkPiRcPtjdgvmLBf7A9gZEdzNta9YeF8qePRSPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6008
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTA3LTI3IGF0IDEwOjEwIC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IEp1bGlhIExhd2FsbCA8SnVsaWEuTGF3YWxsQGlucmlhLmZyPg0KPiBEYXRlOiBTdW4s
IDI2IEp1bCAyMDIwIDEyOjU4OjI5ICswMjAwDQo+IA0KPiA+IGxpc3RfZm9yX2VhY2hfZW50cnkg
aXMgYWJsZSB0byBoYW5kbGUgYW4gZW1wdHkgbGlzdC4NCj4gPiBUaGUgb25seSBlZmZlY3Qgb2Yg
YXZvaWRpbmcgdGhlIGxvb3AgaXMgbm90IGluaXRpYWxpemluZyB0aGUNCj4gPiBpbmRleCB2YXJp
YWJsZS4NCj4gPiBEcm9wIGxpc3RfZW1wdHkgdGVzdHMgaW4gY2FzZXMgd2hlcmUgdGhlc2UgdmFy
aWFibGVzIGFyZSBub3QNCj4gPiB1c2VkLg0KPiA+IA0KPiA+IE5vdGUgdGhhdCBsaXN0X2Zvcl9l
YWNoX2VudHJ5IGlzIGRlZmluZWQgaW4gdGVybXMgb2YNCj4gbGlzdF9maXJzdF9lbnRyeSwNCj4g
PiB3aGljaCBpbmRpY2F0ZXMgdGhhdCBpdCBzaG91bGQgbm90IGJlIHVzZWQgb24gYW4gZW1wdHkg
bGlzdC4gIEJ1dA0KPiBpbg0KPiA+IGxpc3RfZm9yX2VhY2hfZW50cnksIHRoZSBlbGVtZW50IG9i
dGFpbmVkIGJ5IGxpc3RfZmlyc3RfZW50cnkgaXMNCj4gbm90DQo+ID4gcmVhbGx5IGFjY2Vzc2Vk
LCBvbmx5IHRoZSBhZGRyZXNzIG9mIGl0cyBsaXN0X2hlYWQgZmllbGQgaXMNCj4gY29tcGFyZWQN
Cj4gPiB0byB0aGUgYWRkcmVzcyBvZiB0aGUgbGlzdCBoZWFkLCBzbyB0aGUgbGlzdF9maXJzdF9l
bnRyeSBpcyBzYWZlLg0KPiA+IA0KPiA+IFRoZSBzZW1hbnRpYyBwYXRjaCB0aGF0IG1ha2VzIHRo
aXMgY2hhbmdlIGlzIGFzIGZvbGxvd3MgKHdpdGgNCj4gYW5vdGhlcg0KPiA+IHZhcmlhbnQgZm9y
IHRoZSBubyBicmFjZSBjYXNlKTogKGh0dHA6Ly9jb2NjaW5lbGxlLmxpcDYuZnIvKQ0KPiAgLi4u
DQo+ID4gU2lnbmVkLW9mZi1ieTogSnVsaWEgTGF3YWxsIDxKdWxpYS5MYXdhbGxAaW5yaWEuZnI+
DQo+IA0KPiBTYWVlZCwgcGxlYXNlIHBpY2sgdGhpcyB1cC4NCj4gDQo+IFRoYW5rIHlvdS4NCg0K
QXBwbGllZCB0byBuZXQtbmV4dC1tbHg1Lg0KDQpUaGFua3MgIQ0K

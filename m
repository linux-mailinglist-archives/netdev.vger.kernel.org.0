Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06001193732
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 04:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgCZDxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 23:53:01 -0400
Received: from mail-eopbgr30071.outbound.protection.outlook.com ([40.107.3.71]:45798
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727677AbgCZDxB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 23:53:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V628grPgTlxtTdYSQ7WAUiQyXlR+e5UfSAk0C/YOrt3TXJlE0SN04MjdEqFscvhaKaHwJ2FwmSB1nl21HzzX7aOCFP8tBpO99xYlRxPgBVQ3VaS5AvbfKkXz7wxDPOvIAH+9iaSPr5CvtQFQ66+ysE27jkCWVe9D3HwyVaPV3WGwRWAtpAQ+qylmHuh9VJ93FGZasiGs7ImDJ6jD9sWFlZhg5wv9b+ffPflzPVCeFACt4dLZRLmuHGiErMF2kOAYOBOQ9PiL8h1ILspJ5c52Nnlnditf4VVHJJYP8ymXz559zi0jYC/u7/dOEquGFRGkkSUdT2UhNITcJ5/bLxOaug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ejPSFhmzAiIORonM1+ZRwUjW2GV7f9/P37KcHBxcX8=;
 b=KydMyCnaOu4H2Xvkn0o6yzVS8hkaCFtYMqgtrFwLWZ0ecgI/pyMW22v2DaIuVtBz4tNgbybTtke/yZbTK4BDll+ugAQXTGBLSffHYy00mkQAMgS1a6oB4AmvtjNeIPqR/96qBqX0Nor4xBACNRIqbqFkc4V3WtRFuQy2lwLb4vIjp7m+Trve6/nP9yZQr74/M+981YUgtsxdCiYfXvAUrXhhiH+jDT0KPUSZeMSvR8oVCGr4+nrbsopEkmZy7v9IV99aJKrNw1Sv6r2F/5zzikH5Mjb2Pi31UDOO3fQ0ovYZc2VRWPrgWQrMx9rNIRYv70nYtF146jTlueADymgohw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ejPSFhmzAiIORonM1+ZRwUjW2GV7f9/P37KcHBxcX8=;
 b=L4H1ZPPXCOXVG7gLpikKcsmzpQ2kvi8we6hI1rKeGjaVrVvohV5wo7vbmYt+nOKXWKnCpdfUUX1GpEColV/E/Zo6sRnXjKq2kKZCtBXAB/hhcI8a6BLmJSuMKhxV6pSfuQVuj6XmUQCvYA8KbXtUeEuHo/Ihfjgv/b9Vnj4ViYY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4207.eurprd05.prod.outlook.com (52.133.14.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.19; Thu, 26 Mar 2020 03:52:57 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 03:52:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "wenxu@ucloud.cn" <wenxu@ucloud.cn>
CC:     Paul Blakey <paulb@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v8 0/2] net/mlx5e: add indr block support in the
 FT mode
Thread-Topic: [PATCH net-next v8 0/2] net/mlx5e: add indr block support in the
 FT mode
Thread-Index: AQHWAp+Y6Z6WzYpFYUeVaCwg72ZzuKhaPs8A
Date:   Thu, 26 Mar 2020 03:52:57 +0000
Message-ID: <2fce08ab444fe88078ea5b3cec8f224ef5dd203a.camel@mellanox.com>
References: <1585138739-8443-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1585138739-8443-1-git-send-email-wenxu@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4596a510-e63b-47d5-696b-08d7d1392bae
x-ms-traffictypediagnostic: VI1PR05MB4207:|VI1PR05MB4207:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4207693F1F37224F497AC2B5BECF0@VI1PR05MB4207.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0354B4BED2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(376002)(136003)(396003)(366004)(346002)(6506007)(478600001)(316002)(966005)(86362001)(5660300002)(66476007)(76116006)(2906002)(54906003)(66946007)(66556008)(64756008)(66446008)(91956017)(4326008)(6916009)(71200400001)(6512007)(6486002)(186003)(36756003)(2616005)(8676002)(8936002)(26005)(81156014)(81166006);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TlvPKct1z1PNGGG062yNy0gpAePRVnvO8pATXxgV86ARrd/ZPHqssNQKzqwQTO3qh3MxrMsEZUe/gkJeQSOZjPCqjaZyWLNKf8HawOAvXP5MXE6FAh50u1pzv7wFCV0XVpldTPrSYmT/DJdkJQp3Z4RqPUw7wgDr1ngTkfuhAP3XWL3gEJ5cIlfbqTIGHi1HDxNAy4ENne4lhS3iHOqu/0ivc/vCrIWO1dnlEjADVcEyg3T1E0T2FnPZEJqvsxOkcqrMnhmlJW5UFFxJxIqJ/efJ6EGY/UN5DJYbYwumx2vQwzwSOYBqyQXseiJvVCAizGLQDSZD25nwBT9gWtXXV+cs6aKcOSGhv421FVwuvVW8SyRfwf3rGOJ+frhhmmO0dyG31D+Vnu+J0JxnfltRj9EhfeCXgHeNBaifSNiG0WpkG+B/KxfzxfNymmif+g5KKYLcrngb5vzs5MlkR3z7w+E4BTHgEZ5Xaennc79D5Io/IVbv2my+VKnat/UDl6MuF+tGxvcSlnwlxSj5tMhmhA==
x-ms-exchange-antispam-messagedata: 7LUsdqWdLLf4jDz9fE73mHkVpl7J1OqgO5PhHohFOmf/AE+YDzWSjCslBXPOQC8LNryD1c5NiIWxvUnLHxuM9TljaJTJIMHbW/CH67zE6nBKdp5d3rAo4trR2bBJNv2pLw63giV97QjgvQJK0S/Y8w==
Content-Type: text/plain; charset="utf-8"
Content-ID: <46AD5F76975E5D4A9460CDF4396C8BC9@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4596a510-e63b-47d5-696b-08d7d1392bae
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2020 03:52:57.0657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gd/cqNi2KOdacv8jMdejDGHZIHVTSaOc63YWOnwUYHuT80fjeekVkBnkstk9WrVyD3S8yf/oqJuYI5MEzuIq+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4207
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTAzLTI1IGF0IDIwOjE4ICswODAwLCB3ZW54dUB1Y2xvdWQuY24gd3JvdGU6
DQo+IEZyb206IHdlbnh1IDx3ZW54dUB1Y2xvdWQuY24+DQo+IA0KPiBJbmRyIGJsb2NrIHN1cHBv
cnRlZCBpbiBGVCBtb2RlIGNhbiBvZmZsb2FkIHRoZSB0dW5uZWwgZGV2aWNlIGluIHRoZQ0KPiBm
bG93dGFibGVzIG9mIG5mdGFibGUuDQo+IA0KDQphcHBsaWVkIHRvIG5ldC1uZXh0LW1seDUNCg0K
VGhhbmtzICENCg0KDQo+IFRoZSBuZXRmaWx0ZXIgcGF0Y2hlczoNCj4gaHR0cDovL3BhdGNod29y
ay5vemxhYnMub3JnL2NvdmVyLzEyNDI4MTIvDQo+IA0KPiBUZXN0IHdpdGggbWx4IGRyaXZlciBh
cyBmb2xsb3dpbmcgd2l0aCBuZnQ6DQo+IA0KPiBpcCBsaW5rIGFkZCB1c2VyMSB0eXBlIHZyZiB0
YWJsZSAxDQo+IGlwIGwgc2V0IHVzZXIxIHVwIA0KPiBpcCBsIHNldCBkZXYgbWx4X3BmMHZmMCBk
b3duDQo+IGlwIGwgc2V0IGRldiBtbHhfcGYwdmYwIG1hc3RlciB1c2VyMQ0KPiBpZmNvbmZpZyBt
bHhfcGYwdmYwIDEwLjAuMC4xLzI0IHVwDQo+IA0KPiBpZmNvbmZpZyBtbHhfcDAgMTcyLjE2OC4x
NTIuNzUvMjQgdXANCj4gDQo+IGlwIGwgYWRkIGRldiB0dW4xIHR5cGUgZ3JldGFwIGtleSAxMDAw
DQo+IGlwIGwgc2V0IGRldiB0dW4xIG1hc3RlciB1c2VyMQ0KPiBpZmNvbmZpZyB0dW4xIDEwLjAu
MS4xLzI0IHVwDQo+IA0KPiBpcCByIHIgMTAuMC4xLjI0MSBlbmNhcCBpcCBpZCAxMDAwIGRzdCAx
NzIuMTY4LjE1Mi4yNDEga2V5IGRldiB0dW4xDQo+IHRhYmxlIDENCj4gDQo+IG5mdCBhZGQgdGFi
bGUgZmlyZXdhbGwNCj4gbmZ0IGFkZCBjaGFpbiBmaXJld2FsbCB6b25lcyB7IHR5cGUgZmlsdGVy
IGhvb2sgcHJlcm91dGluZyBwcmlvcml0eSAtDQo+IDMwMCBcOyB9DQo+IG5mdCBhZGQgcnVsZSBm
aXJld2FsbCB6b25lcyBjb3VudGVyIGN0IHpvbmUgc2V0IGlpZiBtYXAgeyAidHVuMSIgOiAxLA0K
PiAibWx4X3BmMHZmMCIgOiAxIH0NCj4gbmZ0IGFkZCBjaGFpbiBmaXJld2FsbCBydWxlLTEwMDAt
aW5ncmVzcw0KPiBuZnQgYWRkIHJ1bGUgZmlyZXdhbGwgcnVsZS0xMDAwLWluZ3Jlc3MgY3Qgem9u
ZSAxIGN0IHN0YXRlDQo+IGVzdGFibGlzaGVkLHJlbGF0ZWQgY291bnRlciBhY2NlcHQNCj4gbmZ0
IGFkZCBydWxlIGZpcmV3YWxsIHJ1bGUtMTAwMC1pbmdyZXNzIGN0IHpvbmUgMSBjdCBzdGF0ZSBp
bnZhbGlkDQo+IGNvdW50ZXIgZHJvcA0KPiBuZnQgYWRkIHJ1bGUgZmlyZXdhbGwgcnVsZS0xMDAw
LWluZ3Jlc3MgY3Qgem9uZSAxIHRjcCBkcG9ydCA1MDAxIGN0DQo+IHN0YXRlIG5ldyBjb3VudGVy
IGFjY2VwdA0KPiBuZnQgYWRkIHJ1bGUgZmlyZXdhbGwgcnVsZS0xMDAwLWluZ3Jlc3MgY3Qgem9u
ZSAxIHVkcCBkcG9ydCA1MDAxIGN0DQo+IHN0YXRlIG5ldyBjb3VudGVyIGFjY2VwdA0KPiBuZnQg
YWRkIHJ1bGUgZmlyZXdhbGwgcnVsZS0xMDAwLWluZ3Jlc3MgY3Qgem9uZSAxIHRjcCBkcG9ydCAy
MiBjdA0KPiBzdGF0ZSBuZXcgY291bnRlciBhY2NlcHQNCj4gbmZ0IGFkZCBydWxlIGZpcmV3YWxs
IHJ1bGUtMTAwMC1pbmdyZXNzIGN0IHpvbmUgMSBpcCBwcm90b2NvbCBpY21wIGN0DQo+IHN0YXRl
IG5ldyBjb3VudGVyIGFjY2VwdA0KPiBuZnQgYWRkIHJ1bGUgZmlyZXdhbGwgcnVsZS0xMDAwLWlu
Z3Jlc3MgY291bnRlciBkcm9wDQo+IG5mdCBhZGQgY2hhaW4gZmlyZXdhbGwgcnVsZXMtYWxsIHsg
dHlwZSBmaWx0ZXIgaG9vayBwcmVyb3V0aW5nDQo+IHByaW9yaXR5IC0gMTUwIFw7IH0NCj4gbmZ0
IGFkZCBydWxlIGZpcmV3YWxsIHJ1bGVzLWFsbCBtZXRhIGlpZmtpbmQgInZyZiIgY291bnRlciBh
Y2NlcHQNCj4gbmZ0IGFkZCBydWxlIGZpcmV3YWxsIHJ1bGVzLWFsbCBpaWYgdm1hcCB7ICJ0dW4x
IiA6IGp1bXAgcnVsZS0xMDAwLQ0KPiBpbmdyZXNzIH0NCj4gDQo+IG5mdCBhZGQgZmxvd3RhYmxl
IGZpcmV3YWxsIGZiMSB7IGhvb2sgaW5ncmVzcyBwcmlvcml0eSAyIFw7IGRldmljZXMgPQ0KPiB7
IHR1bjEsIG1seF9wZjB2ZjAgfSBcOyB9DQo+IG5mdCBhZGQgY2hhaW4gZmlyZXdhbGwgZnRiLWFs
bCB7dHlwZSBmaWx0ZXIgaG9vayBmb3J3YXJkIHByaW9yaXR5IDANCj4gXDsgcG9saWN5IGFjY2Vw
dCBcOyB9DQo+IG5mdCBhZGQgcnVsZSBmaXJld2FsbCBmdGItYWxsIGN0IHpvbmUgMSBpcCBwcm90
b2NvbCB0Y3AgZmxvdyBvZmZsb2FkDQo+IEBmYjENCj4gbmZ0IGFkZCBydWxlIGZpcmV3YWxsIGZ0
Yi1hbGwgY3Qgem9uZSAxIGlwIHByb3RvY29sIHVkcCBmbG93IG9mZmxvYWQNCj4gQGZiMQ0KPiAN
Cj4gDQo+IHdlbnh1ICgyKToNCj4gICBuZXQvbWx4NWU6IHJlZmFjdG9yIGluZHIgc2V0dXAgYmxv
Y2sNCj4gICBuZXQvbWx4NWU6IGFkZCBtbHg1ZV9yZXBfaW5kcl9zZXR1cF9mdF9jYiBzdXBwb3J0
DQo+IA0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3JlcC5j
IHwgOTQNCj4gKysrKysrKysrKysrKysrKysrLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgNzMg
aW5zZXJ0aW9ucygrKSwgMjEgZGVsZXRpb25zKC0pDQo+IA0K

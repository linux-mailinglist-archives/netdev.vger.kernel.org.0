Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8DF87B407
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 22:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbfG3UIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 16:08:05 -0400
Received: from mail-eopbgr20062.outbound.protection.outlook.com ([40.107.2.62]:58340
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726174AbfG3UIF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 16:08:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ctXBeHEeacayB9qBXhg8bXokaQapNZ2+dktyUA70RpPBPZme6HhuzyjCCtTBDCXB2CxlBihZ1ZkO6Cn/LHVI+oXZbLsQGGZRjwxnyuozg5wCytgPUJVvbBFgLOwHfWDc4IL0cAIxg6+pO70bGBILbUNxd0Qo48boVRqNydxRFEqwD9TSsm0fcUBVCWvHJ6o3jZlzvApMihxphvby/KzUmmSiWT9CV+tCtVPN2qlY2XLS1DL++tpsbQmNnX+8P6i8Kxzp6TqBtkLe2Pd+wddsD76OcWMdpiC37AHEH5dzq/QdE17oRMYjrPb/XLG51rfEHhuKOA4yb2BdCc4mYcNhrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wru1wq0dNgFCIbapbCL8a1uXoALxCMP5Ia7LqEt3haw=;
 b=B7wzPqfo/SDHf2QNHhxhc7/pJQbR2qO8etPc2Pj3pSRVTH73lI715ZNIxVZl/37jAhKu0q9ZzRVNRTfyDRh6wy3Kxa4X9XqJUvy93owwG0xKr2Q3Ciux7L0AVFni+HwdCr69cmxV792UBKcsYB9pp/LE940DBXtVPM/fj9f0isXHAJ9IGq5BjcU26FghYajWZTOi5/FfkwYsRU+B339e8vc04Tqgy4sKNe0rRrEdgSIFxq8yXetsTUqLyBhypaZNbNPAgu48DXG9I58hzIY5R2vqxgCZGTG0Gz6l9x2HHLclvvnGu4SGXW1k5TQ0vRGbPPQ7ATWn65ICO86tp0qGAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wru1wq0dNgFCIbapbCL8a1uXoALxCMP5Ia7LqEt3haw=;
 b=lZr9Ry5JoUBS2B5WoSGeZ7ZpZ5Bq6El198u+ROzRHSgxMn0GnVYPuk7I9kdT9+MMTBeCvQw5c/iMMonHA/Ijmzzj1BCK/mBpKcvx3kODUgETF/hCzYjCOkIL/Icc1iKQ67M+UQZzmQeF1FQrkL/7+0+BIR3Z0419O6TlnOIZDxA=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2533.eurprd05.prod.outlook.com (10.168.74.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Tue, 30 Jul 2019 20:08:00 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 20:08:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>
CC:     Huy Nguyen <huyn@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next 01/13] net/mlx5e: Print a warning when LRO feature is
 dropped or not allowed
Thread-Topic: [net-next 01/13] net/mlx5e: Print a warning when LRO feature is
 dropped or not allowed
Thread-Index: AQHVRmhf1zpTLl9Vk0e3zVKwgqQQ56bjUMwAgABHWIA=
Date:   Tue, 30 Jul 2019 20:07:59 +0000
Message-ID: <cb43e9dadb8e48d27df8f08464bf40f7a81eafe9.camel@mellanox.com>
References: <20190729234934.23595-1-saeedm@mellanox.com>
         <20190729234934.23595-2-saeedm@mellanox.com>
         <CA+FuTSdoCfj=vcQd3TcA9BRhCNPAJamKHX+14H-6_ecpDEVS_Q@mail.gmail.com>
In-Reply-To: <CA+FuTSdoCfj=vcQd3TcA9BRhCNPAJamKHX+14H-6_ecpDEVS_Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c80c268-39d8-4b8e-1d8f-08d715299ee9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2533;
x-ms-traffictypediagnostic: DB6PR0501MB2533:
x-microsoft-antispam-prvs: <DB6PR0501MB253313277EF6FD77B0C1ADB0BEDC0@DB6PR0501MB2533.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(366004)(396003)(39860400002)(189003)(199004)(186003)(316002)(64756008)(66556008)(66476007)(66446008)(305945005)(58126008)(478600001)(53936002)(54906003)(6246003)(102836004)(81156014)(1361003)(76116006)(7736002)(66946007)(3846002)(4326008)(14454004)(6506007)(6116002)(91956017)(446003)(11346002)(26005)(66066001)(2616005)(81166006)(476003)(99286004)(2351001)(2501003)(486006)(68736007)(76176011)(53546011)(2906002)(5660300002)(36756003)(14444005)(256004)(71190400001)(118296001)(229853002)(6916009)(6436002)(86362001)(8936002)(6486002)(8676002)(6512007)(71200400001)(25786009)(5640700003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2533;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Rr/edAjwxpf9jfuK0EdLk/atPM6srSFZZJjLkcgykb9OlP7s9CwQZPdUZPSiDQocCUp1n5B5SePlDtou0luQhpskctb72SX0UTzIRtLTt//n96dx1a520shX1YvuSLnm237CY0AsffXIP+OqvEGlFx2FoNhK86WlKand25/voqXCTLElXuAXHigd9BMMJVXYSLupK9MXzIQO3WK1VketQAUH/uLBIMGe/5R7AmkhqNxU8XOfwWwfJnxZF6DlPlDCjK4NcEpCBlgYlYzl7KfSBu9YL86HyxDszakI2wyPrrJL0w/IBEY+mB2MlTNSX6aBsqPC0q2Ywr7pcyA7IqxX1/OVNfGgEttQPQic4mxwiAQMY5i9lDomy2v6pFQeDvR1PGxDykIJSHqX68xZorBY0aNpMaVichh4y4n6ryDA3yA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <04BDFD5FEF8FFA4A9BE574AE45A32319@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c80c268-39d8-4b8e-1d8f-08d715299ee9
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 20:07:59.8045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2533
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA3LTMwIGF0IDExOjUyIC0wNDAwLCBXaWxsZW0gZGUgQnJ1aWpuIHdyb3Rl
Og0KPiBPbiBNb24sIEp1bCAyOSwgMjAxOSBhdCA3OjUwIFBNIFNhZWVkIE1haGFtZWVkIDxzYWVl
ZG1AbWVsbGFub3guY29tPg0KPiB3cm90ZToNCj4gPiBGcm9tOiBIdXkgTmd1eWVuIDxodXluQG1l
bGxhbm94LmNvbT4NCj4gPiANCj4gPiBXaGVuIHVzZXIgZW5hYmxlcyBMUk8gdmlhIGV0aHRvb2wg
YW5kIGlmIHRoZSBSUSBtb2RlIGlzIGxlZ2FjeSwNCj4gPiBtbHg1ZV9maXhfZmVhdHVyZXMgZHJv
cHMgdGhlIHJlcXVlc3Qgd2l0aG91dCBhbnkgZXhwbGFuYXRpb24uDQo+ID4gQWRkIG5ldGRldl93
YXJuIHRvIGNvdmVyIHRoaXMgY2FzZS4NCj4gPiANCj4gPiBGaXhlczogNmMzYTgyM2UxZTljICgi
bmV0L21seDVlOiBSWCwgUmVtb3ZlIEhXIExSTyBzdXBwb3J0IGluDQo+ID4gbGVnYWN5IFJRIikN
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBIdXkgTmd1eWVuIDxodXluQG1lbGxhbm94LmNvbT4NCj4gPiBT
aWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCj4gPiAt
LS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4u
YyB8IDUgKysrLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMiBkZWxl
dGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2VuX21haW4uYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2VuX21haW4uYw0KPiA+IGluZGV4IDQ3ZWVhNmIzYTFjMy4uNzc2ZWI0
NmQyNjNkIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9lbl9tYWluLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvZW5fbWFpbi5jDQo+ID4gQEAgLTM3ODgsOSArMzc4OCwxMCBAQCBzdGF0aWMg
bmV0ZGV2X2ZlYXR1cmVzX3QNCj4gPiBtbHg1ZV9maXhfZmVhdHVyZXMoc3RydWN0IG5ldF9kZXZp
Y2UgKm5ldGRldiwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICBuZXRkZXZfd2FybihuZXRk
ZXYsICJEcm9wcGluZyBDLXRhZyB2bGFuDQo+ID4gc3RyaXBwaW5nIG9mZmxvYWQgZHVlIHRvIFMt
dGFnIHZsYW5cbiIpOw0KPiA+ICAgICAgICAgfQ0KPiA+ICAgICAgICAgaWYgKCFNTFg1RV9HRVRf
UEZMQUcocGFyYW1zLCBNTFg1RV9QRkxBR19SWF9TVFJJRElOR19SUSkpIHsNCj4gPiAtICAgICAg
ICAgICAgICAgZmVhdHVyZXMgJj0gfk5FVElGX0ZfTFJPOw0KPiA+IC0gICAgICAgICAgICAgICBp
ZiAocGFyYW1zLT5scm9fZW4pDQo+ID4gKyAgICAgICAgICAgICAgIGlmIChmZWF0dXJlcyAmIE5F
VElGX0ZfTFJPKSB7DQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgbmV0ZGV2X3dhcm4obmV0
ZGV2LCAiRGlzYWJsaW5nIExSTywgbm90DQo+ID4gc3VwcG9ydGVkIGluIGxlZ2FjeSBSUVxuIik7
DQo+IA0KPiBUaGlzIHdhcm5zIGFib3V0ICJEaXNhYmxpbmcgTFJPIiBvbiBhbiBlbmFibGUgcmVx
dWVzdD8NCj4gDQoNCm5vLCB0aGlzIHdhcm5pbmcgYXBwZWFycyBvbmx5IHdoZW4gbHJvIGlzIGFs
cmVhZHkgZW5hYmxlZCBhbmQgbWlnaHQNCmNvbmZsaWN0IHdpdGggYW55IG90aGVyIGZlYXR1cmUg
cmVxdWVzdGVkIGJ5IHVzZXIgKGhlbmNlDQptbHg1ZV9maXhfZmVhdHVyZXMpLCBlLmcgd2hlbiBt
b3ZpbmcgYXdheSBmcm9tIHN0cmlkaW5nIHJxIGluIHRoaXMNCmV4YW1wbGUsIHdlIHdpbGwgZm9y
Y2UgbHJvIHRvIG9mZi4NCg0KDQo+IE1vcmUgZnVuZGFtZW50YWxseSwgaXQgYXBwZWFycyB0aGF0
IHRoZSBkZXZpY2UgZG9lcyBub3QgYWR2ZXJ0aXNlDQo+IHRoZSBmZWF0dXJlIGFzIGNvbmZpZ3Vy
YWJsZSBpbiBuZXRkZXZfaHdfZmVhdHVyZXMgYXMgb2YgY29tbWl0DQo+IDZjM2E4MjNlMWU5YyAo
Im5ldC9tbHg1ZTogUlgsIFJlbW92ZSBIVyBMUk8gc3VwcG9ydCBpbg0KPiBsZWdhY3kgUlEiKSwg
c28gc2hvdWxkbid0IHRoaXMgYmUgY2F1Z2h0IGJ5IHRoZSBkZXZpY2UgZHJpdmVyDQo+IGluZGVw
ZW5kZW50IGV0aHRvb2wgY29kZT8NCg0Kd2hlbiBodyBkb2Vzbid0IHN1cHBvcnQgTUxYNUVfUEZM
QUdfUlhfU1RSSURJTkdfUlEgdGhlbiB5ZXMsIHlvdSB3aWxsDQpuZXZlciBoaXQgdGhpcyBjb2Rl
IHBhdGgsIGJ1dCB3aGVuIGh3IGRvZXMgc3VwcG9ydA0KTUxYNUVfUEZMQUdfUlhfU1RSSURJTkdf
UlEgYW5kIHlvdSB3YW50IHRvIHR1cm4gc3RyaWRpbmcgcnEgb2ZmLCB0aGVuDQpscm8gd2lsbCBi
ZSBmb3JjZWQgdG8gb2ZmIChpZiBpdCB3YXMgZW5hYmxlZCBpbiBmaXJzdCBzcGFjZSkgYW5kIGEN
Cndhcm5pbmcgbXNnIHdpbGwgYmUgc2hvd24uDQoNCg0KDQo=

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531A72304C6
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 09:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgG1H5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 03:57:50 -0400
Received: from mail-eopbgr40056.outbound.protection.outlook.com ([40.107.4.56]:46734
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727798AbgG1H5t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 03:57:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UuHfHTYaPBaGfCarj0GhN3T9s+vsq+GOVSUFLG7GaWM6+dae+nrdhjwYoSA6F7QRepGMCTs4b6dftvS3KdV1jZDjfMCxrkIIH07cpRtnxX4BefkfCX5qzH7CdAt+MGmYAf2zAXGRt/hGS+aAx4td65qQAy9fihf/ccYzYvssnr6xH0G+ONgiYvCJBrffxapGQy3JzNN3YRpYOUFHD/1lU5ePapA4Kzmt1Tt+ldW2COeId9rzW8qLbeOOYEgtOTrXUz0oB7wq2SeMVG898KsNSVvAZcg6W5Bjtsex5ziMRl6v+X8R7vUpbGM/eJsr7BQtTAH7di0gtAJki3QfEZd74g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6z9OLV/kAzBvuG6HMRmFS2D+8wilSnU/w/HTVqXoP4=;
 b=GhG+7abrxAn/XhzSkbF7kAOVYGAygT5j6yLVtIStsigszVoNGr+ePjMKsWJeEWUVG2haV80sH1r4wC+FPqTTcqEGcHZoHzf52THkEnG1Snp2s6kOzfQTUh6nNtBYKrX8+sxAzglD1itwF/NPBlqfzsRN6eGU9JDZ6etErMfhErdu97zdsDmatIbSWepiK4FYIGc+5eM4y3Ihmm65mxjOBhb6MAI7uo5ma0ysXWk+aKWrUY6Yi4A5s9tO9bufDTZqZ4kb0wWvL/y//ooW1Mu85ZthVo7oBNXMvpJJ08UhdvPBkS83trcNKq2cn6BwOmJP6GKLUPzOqv/fCLPT92hrIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6z9OLV/kAzBvuG6HMRmFS2D+8wilSnU/w/HTVqXoP4=;
 b=WchFpiEJ1kcN2isVor5WmBhmfFJPYTkpqOZVn31ZZq6gCtvGO6xtVpp5s5r01g5Yp5OPXEwIyhzWoAqkauMndFHOIm0MEJWWX+6HlW8QWB1gjhmzN6j7QtY8Jlcyptgh3z9nZ5GecUIkCfvE42WCjYAn7ebsyyCIH59QNt1z/lE=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (2603:10a6:20b:9::29)
 by AM6PR05MB4903.eurprd05.prod.outlook.com (2603:10a6:20b:12::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.26; Tue, 28 Jul
 2020 07:57:46 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d803:a59d:9a85:975f]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d803:a59d:9a85:975f%7]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 07:57:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next 0/2] udp_tunnel: convert mlx5 to the new
 udp_tunnel infrastructure
Thread-Topic: [PATCH net-next 0/2] udp_tunnel: convert mlx5 to the new
 udp_tunnel infrastructure
Thread-Index: AQHWYi6mSEIaUFx5VkaOSbjVpyVuqakcpS8A
Date:   Tue, 28 Jul 2020 07:57:46 +0000
Message-ID: <c5ee0e70b0263ebcf70534f2329cf55083021dfe.camel@mellanox.com>
References: <20200725025146.3770263-1-kuba@kernel.org>
In-Reply-To: <20200725025146.3770263-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6172830f-9b84-4cbe-c3d2-08d832cbea6b
x-ms-traffictypediagnostic: AM6PR05MB4903:
x-microsoft-antispam-prvs: <AM6PR05MB4903EC906FB32FD1B1537DBABE730@AM6PR05MB4903.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L9/Yob74iVv7or0a+xXMo5N/0gq5K53EDlzrwkQ2FdmLLpl812gSj9pcaZhZ/lJ7Ic6417frIlxOO1VTlQFcjDuE0hC5NW4TbPjQfUiXgwQeR4FQc3BZ+vOsOLhzAKpucjAZ4hOjfYJlSYsAN/3WnK+zaG4DE6eJqKbm5w+p+T0HO/re6qlwnv4hpvyIb+81NJc7Ruq23bZ1cigTZ3aci+qnOHijhPRNLEAOe14WTfgKCkot97ukicPFqFxzHIgYU1B9xCl0OOrfh2r+5gHS353c+1oYSa5SrT7XzV0S7CnqIFi2myCDPjlpBoZsgbSP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5094.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(186003)(86362001)(54906003)(478600001)(76116006)(91956017)(2906002)(83380400001)(6486002)(2616005)(6512007)(8936002)(36756003)(8676002)(4326008)(71200400001)(26005)(316002)(6506007)(66476007)(66556008)(64756008)(66446008)(5660300002)(6916009)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: q3K40fnGkxIckb66GNlVY1nAOvD4L2INSholK6jvkhQZNZswa8yiLCHilhDNuiYqRrqWQvIkmOO3S687VlHbPfdBQjkug4X6ZpDTtkKR/MBGvOAz9l22D093LtWh2f3ZIUza4vf/Kf/LxedGWQDq6pZilDe2fTuPWAtoBTV1WqxdkLkPTOSfkqIvxpKGDIa6BILdZPRlRLRJOyFVFwlTrZihpAwJGtOvpRnZVuYXkE+z9uuR2K5S3pmlXxwr8HFIMZ+wI5KLnp6DuKGhg5zp+EZrldXbqeDmAA1F5WQ6t6dMl7KriDQrcmIdD94Q2sMfd/kaTAlOcjxTe0x42mQXzdSSd+eGncnMdGKNprkS3Y2JVLC66v9ZGzNQEZ0fAeVbuUfmcgI8zb/AelCqtekfxG/k74RDOfIS5IcwJfWsWWp1Dib/VqbhN5BH3ytOT/WYOmFpxoaKUO/aSHIM5VSiXvz4DrNsCkhBu4nCF+1S8+c=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB7BB08C8C323345B2BD536F273A58A9@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5094.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6172830f-9b84-4cbe-c3d2-08d832cbea6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2020 07:57:46.4696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hzmknXCd4qo2/9pY4m2smvxjD5aFMP1E6pI7J16u+epM8pkEAGbaCtGjvu6Wz7LZFoaWvOTwEhFnbkbSA9XJCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4903
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA3LTI0IGF0IDE5OjUxIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gVGhpcyBzZXQgY29udmVydHMgbWx4NSB0byB0aGUgbmV3IGluZnJhc3RydWN0dXJlLg0KPiAN
Cj4gV2UgbmVlZCBhIHNtYWxsIGFtb3VudCBvZiBzcGVjaWFsIGhhbmRsaW5nIGFzIG1seDUgZXhw
ZWN0cyBJQU5BIFZYTEFODQo+IHBvcnQgdG8gYWx3YXlzIGJlIHByb2dyYW1tZWQgaW50byB0aGUg
ZGV2aWNlLiBldGh0b29sIHdpbGwgc2hvdyBzdWNoDQo+IHBvcnRzIGluIGEgc2VwYXJhdGUsIHR5
cGUtbGVzcywgZmFrZSB0YWJsZSwgYXQgdGhlIGVuZDoNCj4gDQo+IFR1bm5lbCBpbmZvcm1hdGlv
biBmb3IgZXRoMDoNCj4gICBVRFAgcG9ydCB0YWJsZSAwOiANCj4gICAgIFNpemU6IDcNCj4gICAg
IFR5cGVzOiB2eGxhbg0KPiAgICAgTm8gZW50cmllcw0KPiAgIFVEUCBwb3J0IHRhYmxlIDE6IA0K
PiAgICAgU2l6ZTogMQ0KPiAgICAgVHlwZXM6IG5vbmUgKHN0YXRpYyBlbnRyaWVzKQ0KPiAgICAg
RW50cmllcyAoMSk6DQo+ICAgICAgICAgcG9ydCA0Nzg5LCB2eGxhbg0KPiANCj4gU2FlZWQgLSB0
aGlzIHNob3VsZCBhcHBseSBvbiB0b3Agb2YgbmV0LW5leHQsIGluZGVwZW5kZW50bHkgb2YNCj4g
dGhlIEludGVsIHBhdGNoZXMsIHdvdWxkIHlvdSBtaW5kIHRha2luZyB0aGlzIGluIGZvciB0ZXN0
aW5nDQo+IGFuZCByZXZpZXc/IEknbGwgcG9zdCB0aGUgbmV0ZGV2c2ltICYgdGVzdCBvbmNlIElu
dGVsIHBhdGNoZXMNCj4gcmUtZW1lcmdlLg0KPiANCg0KSGkgSmFrdWIsIHRoYW5rcyBmb3IgdGhl
IHBhdGNoZXMuDQoNCldlIGhhZCBzb21lIGZhaWx1cmVzIGluIG91ciBpbnRlcm5hbCByZWdyZXNz
aW9uIGFuZCBpdCBzZWVtcyB0byBiZQ0KcmVsYXRlZCB0byB0aGVzZSBwYXRjaGVzLCBzb21ldGhp
bmcgd2l0aCB2eGxhbiB0ZXN0IGNhc2Ugd2l0aA0KcmVwcmVzZW50b3JzIGFuZCBzd2l0Y2hkZXYg
bW9kZSwgd2Ugd2lsbCBiZSBkZWJ1Z2dpbmcgYW5kIHdpbGwgbGV0IHlvdQ0Ka25vdy4NCg0KPiBK
YWt1YiBLaWNpbnNraSAoMik6DQo+ICAgdWRwX3R1bm5lbDogYWRkIHRoZSBhYmlsaXR5IHRvIGhh
cmQtY29kZSBJQU5BIFZYTEFODQo+ICAgbWx4NTogY29udmVydCB0byBuZXcgdWRwX3R1bm5lbCBp
bmZyYXN0cnVjdHVyZQ0KPiANCj4gIERvY3VtZW50YXRpb24vbmV0d29ya2luZy9ldGh0b29sLW5l
dGxpbmsucnN0ICB8ICAzICsNCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lbi5oICB8ICAyIC0NCj4gIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2VuX21haW4uYyB8IDg4ICsrLS0tLS0tLS0tLS0tLS0tDQo+IC0tDQo+ICAuLi4vbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYyAgfCAgMiAtDQo+ICAuLi4vZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2xpYi92eGxhbi5jICAgfCA4NyArKysrKysrKystLS0tLS0NCj4g
LS0tDQo+ICAuLi4vZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi92eGxhbi5oICAgfCAg
NiArLQ0KPiAgaW5jbHVkZS9uZXQvdWRwX3R1bm5lbC5oICAgICAgICAgICAgICAgICAgICAgIHwg
IDUgKysNCj4gIG5ldC9ldGh0b29sL3R1bm5lbHMuYyAgICAgICAgICAgICAgICAgICAgICAgICB8
IDY5ICsrKysrKysrKysrKystLQ0KPiAgbmV0L2lwdjQvdWRwX3R1bm5lbF9uaWMuYyAgICAgICAg
ICAgICAgICAgICAgIHwgIDcgKysNCj4gIDkgZmlsZXMgY2hhbmdlZCwgMTI2IGluc2VydGlvbnMo
KyksIDE0MyBkZWxldGlvbnMoLSkNCj4gDQo=

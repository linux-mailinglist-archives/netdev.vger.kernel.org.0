Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4711B1C66
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 05:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgDUDIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 23:08:01 -0400
Received: from mail-eopbgr30059.outbound.protection.outlook.com ([40.107.3.59]:56805
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726325AbgDUDIA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 23:08:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mSHO62oYRPRGyRARHgG2ktPN2BytT0ajtY2WJjU0TS3+hbGIEdNDy2YYcf7ulebbwJ9kw1XtSeLMfKBD4liEPyT5R8GRnKqNphxGQbDXNosoQahMHgO5are4Jj/p3ebipX/tgxbiYkIT1YYsG+kmRrNNL3nc+Hy+C11GGc5eHkRS0zEKaIBHNF5eAezqYtC4xyAUl8xr2FsPbulwOmowE8hLb7/OjGdNT/hVB1okk86ayyD58e10jQwYmmx9qi8mcOD5SKaV7Dxf1l3p5+A+SCMcUiiN8NwHl3oWbeIbDbP7AnOTP5y+7z6Dar85mKNm5GFw8KnzE3ep0ESF+PPGmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qa+T0GIYTRD5bzPXCTUyvVj1IE4XNFfh2LXCuOxqtIc=;
 b=Ewcyf9DoBhfLNeE+ihGEBiPxJjg4VnkONGvFNPeXsm8Qav6HXtqhcDqnekrPCT4KPjqfYdTX50UQfd1eQLq5wyLrCanXKLtThtfDsKHJUNQGi+DXNjtT8lKxK5Y1Zw6CnwbjCnH86gbgjGqnw0rl3LDMAXWkWVvXDcG02MevsjJNLGuP3D7xeSckE4+sVJcVUuXyGwCfTYOLFPLAfLZxGuQHWe79Y/brD9eMxA5S4vx0Ht4hxbLUY50H/3WDa5RCzg66kAttQjnHMuGjoLJ0D1D0KJPkqpgf9CL5HWz2WY0GxqqfojGv+Yy3NlUYbOfovdXl2yJIrmrz0NgoFAMqiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qa+T0GIYTRD5bzPXCTUyvVj1IE4XNFfh2LXCuOxqtIc=;
 b=FeDqOIQ2kIK3ZSujPHQrdamg3RpRgTpanUkR6LbfkRolNJX9FsUL+s9uAQjZD1U84JoHlksSFtMKZJ7LGDGCA9o6h1IFxSPDuzlua2nf0+3IGfxyvsATRFanqGV5/XiG7eezfHoBPgN71Tfi0lraazZvAn4qIUsqf5FdFlwASdw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4255.eurprd05.prod.outlook.com (2603:10a6:803:4d::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Tue, 21 Apr
 2020 03:07:55 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2921.030; Tue, 21 Apr 2020
 03:07:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "sashal@kernel.org" <sashal@kernel.org>
CC:     "ecree@solarflare.com" <ecree@solarflare.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Thread-Topic: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Thread-Index: AQHWEFb6WRVOJO0/j0GE4IB+QkA/0qh1Ei4AgAC1ZICAAheSAIAAjYWAgAAM6ICAADp+AIAAE8gAgABWOICAAURNAIAAgPKAgADlNYCAAD1UgIAAJLSAgAAGLYCAABu7AIAAHtEAgAaIJQA=
Date:   Tue, 21 Apr 2020 03:07:55 +0000
Message-ID: <12da718975b8a7d590c3f8d59242ddae946a114f.camel@mellanox.com>
References: <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
         <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
         <20200414205755.GF1068@sasha-vm>
         <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
         <20200416000009.GL1068@sasha-vm>
         <CAJ3xEMjfWL=c=voGqV4pUCzWXmiTn-R6mrRi82UAVHMVysKU1g@mail.gmail.com>
         <20200416172001.GC1388618@kroah.com>
         <b8651ce6d7d6c6dcb8b2d66f07148413892b48d0.camel@mellanox.com>
         <20200416195329.GO1068@sasha-vm>
         <829c2b8807b4e6c59843b3ab85ca3ccc6cae8373.camel@mellanox.com>
         <20200416232302.GR1068@sasha-vm>
In-Reply-To: <20200416232302.GR1068@sasha-vm>
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
x-ms-office365-filtering-correlation-id: 06344379-d523-47bc-05fa-08d7e5a13010
x-ms-traffictypediagnostic: VI1PR05MB4255:
x-microsoft-antispam-prvs: <VI1PR05MB42558E66E975C85FBDA4A684BED50@VI1PR05MB4255.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 038002787A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(346002)(136003)(39860400002)(396003)(376002)(26005)(2616005)(91956017)(71200400001)(64756008)(66476007)(66446008)(66556008)(66946007)(8676002)(6486002)(6916009)(5660300002)(81156014)(36756003)(186003)(2906002)(6512007)(54906003)(478600001)(86362001)(316002)(4326008)(8936002)(76116006)(6506007);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EjHGGCkl7gjYhlgTI1cSH7MR2S5fjivJKUYETpUL3jDYhRrIK1CDe/MNQhOzn9Q45995R0/Uj3aCGRyxtQKe5uFIHw+YLmxeevmujfm3tQZuBTTzxnzK8CQu9+WdJYWsT37nWlzSJaM0ZGpOBqgiYxHfMaTdvmz6nQMJ+ojmbt/fn2NgigfxH1ONYraqyYxtR3UC3h8x3zlcBlh3Nnb4ylO5Rz1PZ88WlWOJTRVBMzNXuv5ssXFwOFzvJIcdiWiO5zHEktXMhqJT9pNcogh184C77TK22STP3hB5ixSD0vy9EGZzWgprcM5Lz5HcJ8dWVSQorlSjfEa6oWvCuQkdltlv84tdJ4G/eVcU5HQOoBg//WaRFn25ySopRTvr7WWpM1Yi5iIFXUMt54/Eb1uNMor+1748BWadL595sQ/oTwB0pt7DW/LnG/ASnwfhgH8H
x-ms-exchange-antispam-messagedata: y1h8o7rvY16lXWnFBdW79pYR5h7ANS56X0meWBzlzk9RgivpfeEnPR3DmhsGKM//i/16AfjNMH5OP0kw8Q4KaXaPvrqrOXlWfJKHqRCfj8Ez3IKpYRdFq6aq9hLpslc9bNHz+RyyZCZzbjWGkyKKvQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <8FEEF0C7DBFFE145BEF95AFC73817EEC@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06344379-d523-47bc-05fa-08d7e5a13010
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2020 03:07:55.3777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ix2qXq7zLyi/8Q0K+rReh+Bf6FSbe3j3kH/C6OKfQZZ4VuR05TFIwNHrgYCEA3HP3DTsYMN4wzb2ZrgwnKF24Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4255
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA0LTE2IGF0IDE5OjIzIC0wNDAwLCBTYXNoYSBMZXZpbiB3cm90ZToNCj4g
T24gVGh1LCBBcHIgMTYsIDIwMjAgYXQgMDk6MzI6NDdQTSArMDAwMCwgU2FlZWQgTWFoYW1lZWQg
d3JvdGU6DQo+ID4gT24gVGh1LCAyMDIwLTA0LTE2IGF0IDE1OjUzIC0wNDAwLCBTYXNoYSBMZXZp
biB3cm90ZToNCj4gPiA+IElmIHdlIGFncmVlIHNvIGZhciwgdGhlbiB3aHkgZG8geW91IGFzc3Vt
ZSB0aGF0IHRoZSBzYW1lIHBlb3BsZQ0KPiA+ID4gd2hvDQo+ID4gPiBkbw0KPiA+ID4gdGhlIGFi
b3ZlIGFsc28gcGVyZmVjdGx5IHRhZyB0aGVpciBjb21taXRzLCBhbmQgZG8gcGVyZmVjdA0KPiA+
ID4gc2VsZWN0aW9uDQo+ID4gPiBvZg0KPiA+ID4gcGF0Y2hlcyBmb3Igc3RhYmxlPyAiSSdtIGFs
d2F5cyByaWdodCBleGNlcHQgd2hlbiBJJ20gd3JvbmciLg0KPiA+IA0KPiA+IEkgYW0gd2VsbGlu
ZyB0byBhY2NlcHQgcGVvcGxlIG1ha2luZyBtaXN0YWtlcywgYnV0IG5vdCB0aGUgQUkuLg0KPiAN
Cj4gVGhpcyBpcyB3aGVyZSB3ZSBkaXNhZ3JlZS4gSWYgSSBjYW4gaGF2ZSBhbiBBSSB0aGF0IHBl
cmZvcm1zIG9uIHBhcg0KPiB3aXRoDQo+IGFuICJhdmVyYWdlIiBrZXJuZWwgZW5naW5lZXIgLSBJ
J20gaGFwcHkgd2l0aCBpdC4NCj4gDQo+IFRoZSB3YXkgSSBzZWUgQVVUT1NFTCBub3cgaXMgYW4g
ImF2ZXJhZ2UiIGtlcm5lbCBlbmdpbmVlciB3aG8gZG9lcw0KPiBwYXRjaA0KPiBzb3J0aW5nIGZv
ciBtZSB0byByZXZpZXcuDQo+IA0KPiBHaXZlbiBJIHJldmlldyBldmVyeXRoaW5nIHRoYXQgaXQg
c3BpdHMgb3V0IGF0IG1lLCBpdCdzIHRlY2huaWNhbGx5IGENCj4gaHVtYW4gZXJyb3IgKG1pbmUp
LCByYXRoZXIgdGhhbiBhIHByb2JsZW0gd2l0aCB0aGUgQUksIHJpZ2h0Pw0KPiANCj4gPiBpZiBp
dCBpcyBuZWNlc3NhcnkgYW5kIHdlIGhhdmUgYSBtYWdpY2FsIHNvbHV0aW9uLCBpIHdpbGwgd3Jp
dGUNCj4gPiBnb29kIEFJDQo+ID4gd2l0aCBubyBmYWxzZSBwb3NpdGl2ZXMgdG8gZml4IG9yIGhl
bHAgYXZvaWQgbWVtbGVhY2tzLg0KPiANCj4gRWFzaWVyIHNhaWQgdGhhbiBkb25lIDopDQo+IA0K
PiBJIHRoaW5rIHRoYXQgdGhlICJJbnRlbGxpZ2VuY2UiIGluIEFJIHN1Z2dlc3RzIHRoYXQgaXQg
Y2FuIGJlIG1ha2luZw0KPiBtaXN0YWtlcy4NCj4gDQo+ID4gQlVUIGlmIGkgY2FuJ3QgYWNoaWV2
ZSAxMDAlIHN1Y2Nlc3MgcmF0ZSwgYW5kIGkgbWlnaHQgZW5kIHVwDQo+ID4gaW50cm9kdWNpbmcg
bWVtbGVhY2sgd2l0aCBteSBBSSwgdGhlbiBJIHdvdWxkbid0IHVzZSBBSSBhdCBhbGwuDQo+ID4g
DQo+ID4gV2UgaGF2ZSBkaWZmZXJlbnQgdmlld3Mgb24gdGhpbmdzLi4gaWYgaSBrbm93IEFJIGlz
IHVzaW5nIGttYWxsb2MNCj4gPiB3cm9uZ2x5LCBJIGZpeCBpdCwgZW5kIG9mIHN0b3J5IDopLg0K
PiA+IA0KPiA+IGZhY3Q6IFlvdXIgQUkgaXMgYnJva2VuLCBjYW4gaW50cm9kdWNlIF9uZXdfIHVu
LWNhbGxlZCBmb3IgYnVncywNCj4gPiBldmVuDQo+ID4gaXQgaXMgdmVyeSB2ZXJ5IHZlcnkgZ29v
ZCA5OS45OSUgb2YgdGhlIGNhc2VzLg0KPiANCj4gUGVvcGxlIGFyZSBicm9rZW4gdG9vLCB0aGV5
IGludHJvZHVjZSBuZXcgYnVncywgc28gd2h5IGFyZSB3ZQ0KPiBhY2NlcHRpbmcNCj4gbmV3IGNv
bW1pdHMgaW50byB0aGUga2VybmVsPw0KPiANCj4gTXkgcG9pbnQgaXMgdGhhdCBldmVyeXRoaW5n
IGlzIGJyb2tlbiwgeW91IGNhbid0IGhhdmUgMTAwJSBwZXJmZWN0DQo+IGFueXRoaW5nLg0KPiAN
Cj4gPiA+IEhlcmUncyBteSBzdWdnZXN0aW9uOiBnaXZlIHVzIGEgdGVzdCByaWcgd2UgY2FuIHJ1
biBvdXIgc3RhYmxlDQo+ID4gPiByZWxlYXNlDQo+ID4gPiBjYW5kaWRhdGVzIHRocm91Z2guIFNv
bWV0aGluZyB0aGF0IHNpbXVsYXRlcyAicmVhbCIgbG9hZCB0aGF0DQo+ID4gPiBjdXN0b21lcnMN
Cj4gPiA+IGFyZSB1c2luZy4gV2UgcHJvbWlzZSB0aGF0IHdlIHdvbid0IHJlbGVhc2UgYSBzdGFi
bGUga2VybmVsIGlmDQo+ID4gPiB5b3VyDQo+ID4gPiB0ZXN0cyBhcmUgZmFpbGluZy4NCj4gPiA+
IA0KPiA+IA0KPiA+IEkgd2lsbCBiZSBtb3JlIHRoYW4gZ2xhZCB0byBkbyBzbywgaXMgdGhlcmUg
YSBmb3JtYWwgcHJvY2VzcyBmb3INCj4gPiBzdWNoDQo+ID4gdGhpbmcgPw0KPiANCj4gSSdkIGxv
dmUgdG8gd29yayB3aXRoIHlvdSBvbiB0aGlzIGlmIHlvdSdyZSBpbnRlcmVzdGVkLiBUaGVyZSBh
cmUgYQ0KPiBmZXcNCj4gb3B0aW9uczoNCj4gDQo+IDEuIFNlbmQgdXMgYSBtYWlsIHdoZW4geW91
IGRldGVjdCBhIHB1c2ggdG8gYSBzdGFibGUtcmMgYnJhbmNoLiBNb3N0DQo+IHBlb3BsZS9ib3Rz
IHJlcGx5IHRvIEdyZWcncyBhbm5vdW5jZSBtYWlsIHdpdGggcGFzcy9mYWlsLg0KDQpTb3VuZHMg
bGlrZSBvdXIgYmVzdCBvcHRpb24gZm9yIG5vdywgYXMgd2UgYWxyZWFkeSBoYXZlIG91ciBvd24g
dGVzdGluZw0KaW5mcmEgdGhhdCBrbm93cyBob3cgdG8gd2F0Y2ggZm9yIGV4dGVybmFsIGNoYW5n
ZXMgaW4gbWFpbGluZyBsaXN0cy4gDQoNCj4gDQo+IDIuIEludGVncmF0ZSB5b3VyIHRlc3RzIGlu
dG8ga2VybmVsY2kgKGtlcm5lbGNpLm9yZykgLSB0aGlzIG1lYW5zDQo+IHRoYXQNCj4geW91J2xs
IHJ1biBhICJsYWIiIG9uIHByZW0sIGFuZCBrZXJuZWxjaSB3aWxsIHNjaGVkdWxlIGJ1aWxkcyBh
bmQNCj4gdGVzdHMNCj4gb24gaXQncyBvd24sIHNlbmRpbmcgcmVwb3J0cyB0byB1cy4NCj4gDQo+
IDMuIFdlJ3JlIG9wZW4gdG8gb3RoZXIgc29sdXRpb25zIGlmIHlvdSBoYWQgc29tZXRoaW5nIGlu
IG1pbmQsIHRoZQ0KPiBmaXJzdA0KPiB0d28gdXN1YWxseSB3b3JrIGZvciBwZW9wbGUgYnV0IGlm
IHlvdSBoYXZlIGEgZGlmZmVyZW50IHJlcXVpcmVtZW50DQo+IHdlJ2xsIGJlIGhhcHB5IHRvIGZp
Z3VyZSBpdCBvdXQuDQo+IA0KDQpUaGFua3MsDQoNCkkgd2lsbCBoYXZlIHRvIGRpc2N1c3MgdGhp
cyB3aXRoIG91ciBDSSBtYWludGFpbmVycyBhbmQgc2VlIHdoYXQgd2UNCnByZWZlci4gDQoNCmkg
d2lsbCBsZXQgeW91IGtub3cuDQoNCg==

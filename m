Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7DCAECB6C
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 23:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbfKAWcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 18:32:19 -0400
Received: from mail-eopbgr140081.outbound.protection.outlook.com ([40.107.14.81]:8964
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725989AbfKAWcT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 18:32:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SRkhuEc7RtEZhMC/yYuE9oyt2Bod56iiJ0/bUO/0RypUU332++dKYzazkwYdXzeFgUFELfX0UZ8e3OYqVm2aZgxAIv9pev1DB7atlHJ1BelBFXUfIcKm3C/urXSSJTC/ne+wi2O//aJxhAr7LoZgnYacgCT42Fr877SgRGof4YRXJDx0L+I0XZe7xQi2WhIs3gElN+2aV4PSD1blhZxAwhZACpxGARFsVHw4gvFOTVGUFb5t2XplWNY2DtgRkRg+XPQM++6bh+PkqIGhdu2gobZXM9MIgGZzPR5ertDkifhGC9WfZxYoS8tivKrDGvGDaziLCIEYz0ksxAL0akLFyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UoSdfEf0S2KG70IGeYqXN+qRwsu6JOnahPHZmSVBa9U=;
 b=M0Tw0Iuk0pfYFNGAeiH3CgYQ79o2rf89l17LTJ8A60/+skN4phEWi3s+8u7nmgeF5yVOEXtvdUFkV0TYV28Zqp6Vr5bXF0AeHSJhlqs7dfS0pfX0evbRi8sR4oO+5qwmLNau/mB7Y6eZwmBNcxdxfI2WDISQ/hZs14oHOnfKshyOyNdvZI+xkIYIk0yL2YX9gFMR0XI0/yGldpOdVa21vFmDb2tgauk4Aaw8oNOKXi9WV9RsdeI1uz241MwbO6RQfS/lItW+C1eskPi/hmhDJeEYTduLuSZ7EwzzkfKE0yNDOI7ehNllWSrTmKq9lqxhktUHN7Hymg+X09A/0T4ArQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UoSdfEf0S2KG70IGeYqXN+qRwsu6JOnahPHZmSVBa9U=;
 b=ekCVvxQ7GnsnculGpwXG0Nw6jL5bge6OvOaiacF09sLR1dckKXmQNzBWKpfGryRx0m71NVBiAuuXIKL6Cj5rHdM+wnmCQt5I4G8T2n8VZUdZqD13BdJNJTr/f5TteKJbj/xpBYGA/fbz4eeLqFxDAJj1J5TZfEsPH/Z3AxES0j8=
Received: from VE1PR04MB6687.eurprd04.prod.outlook.com (20.179.234.30) by
 VE1PR04MB6430.eurprd04.prod.outlook.com (20.179.232.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.25; Fri, 1 Nov 2019 22:31:35 +0000
Received: from VE1PR04MB6687.eurprd04.prod.outlook.com
 ([fe80::c93:c279:545b:b6b6]) by VE1PR04MB6687.eurprd04.prod.outlook.com
 ([fe80::c93:c279:545b:b6b6%3]) with mapi id 15.20.2387.031; Fri, 1 Nov 2019
 22:31:35 +0000
From:   Leo Li <leoyang.li@nxp.com>
To:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Qiang Zhao <qiang.zhao@nxp.com>
CC:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Scott Wood <oss@buserror.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v3 35/36] net/wan: make FSL_UCC_HDLC explicitly depend on
 PPC32
Thread-Topic: [PATCH v3 35/36] net/wan: make FSL_UCC_HDLC explicitly depend on
 PPC32
Thread-Index: AQHVkLHlr4/lsG9mMkGX3of9x6ljgad2gb8AgABkExA=
Date:   Fri, 1 Nov 2019 22:31:35 +0000
Message-ID: <VE1PR04MB6687D4620E32176BDC120DBA8F620@VE1PR04MB6687.eurprd04.prod.outlook.com>
References: <20191018125234.21825-1-linux@rasmusvillemoes.dk>
 <20191101124210.14510-1-linux@rasmusvillemoes.dk>
 <20191101124210.14510-36-linux@rasmusvillemoes.dk>
 <4e2ac670-2bf4-fb47-2130-c0120bcf0111@c-s.fr>
In-Reply-To: <4e2ac670-2bf4-fb47-2130-c0120bcf0111@c-s.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leoyang.li@nxp.com; 
x-originating-ip: [64.157.242.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5e94ad1d-2ce6-43b0-0b1a-08d75f1b4111
x-ms-traffictypediagnostic: VE1PR04MB6430:|VE1PR04MB6430:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB64302A11636E3781DA5CFB2A8F620@VE1PR04MB6430.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(39860400002)(376002)(396003)(136003)(189003)(199004)(13464003)(6116002)(3846002)(7736002)(316002)(4326008)(9686003)(25786009)(81156014)(66066001)(74316002)(476003)(2906002)(6436002)(66556008)(66476007)(64756008)(81166006)(5660300002)(66946007)(66446008)(229853002)(52536014)(76116006)(110136005)(55016002)(66574012)(8676002)(305945005)(6246003)(14444005)(6636002)(53546011)(7696005)(186003)(446003)(8936002)(54906003)(99286004)(486006)(76176011)(11346002)(26005)(478600001)(86362001)(71200400001)(6506007)(71190400001)(14454004)(102836004)(256004)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6430;H:VE1PR04MB6687.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4mnH4VDWTjh1v5hvFq8CqyQfnxWrze5/frsVbHbLCrm+Clw2zUtH9SKp4LrIKsmHMciOu6MFdeWdr25beB3zId8oSw4/O56VG+xdyxrWzLqgkMKRXdgv38+xpgjsm5Or+ELNrYUXlhSkTZz9kZisvGdQZ8Hwq71TL3jIPbUfsUzCFbGlvdjbpNxHS8CCQH9QzbyFVVb9/RyKpiHPoa32+exI7ynXFLTLnj3gXrkvjSfuZfctFS6q6SD6dqnLbv09ht0v+SMf/4SIPoJl056Lz/f7QXY2+VEHTCUlzHw60KQzgoWrHlbAkkuZ+xGdkO1VKQcNKhnm9vg45kASaP+aR5ZULhFRHm+xSdUpgy0dzIkhFR3NmrBVOPegg8jH/COy+DPY44bjEGoKADrDlXPc4Len5jKtwE5xypi6uuHu7JAdcpoTV/vnauckUsQTy0iQ
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e94ad1d-2ce6-43b0-0b1a-08d75f1b4111
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 22:31:35.1149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 24MFtzoLRHfmMLc19Dkue/4BuhpxlRJ2YJn1GAy3vL/JYrReFhOPUqCFAqiWqGWvlErdEUNpNCTFR1JW/ivv2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6430
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ2hyaXN0b3BoZSBMZXJv
eSA8Y2hyaXN0b3BoZS5sZXJveUBjLXMuZnI+DQo+IFNlbnQ6IEZyaWRheSwgTm92ZW1iZXIgMSwg
MjAxOSAxMTozMCBBTQ0KPiBUbzogUmFzbXVzIFZpbGxlbW9lcyA8bGludXhAcmFzbXVzdmlsbGVt
b2VzLmRrPjsgUWlhbmcgWmhhbw0KPiA8cWlhbmcuemhhb0BueHAuY29tPjsgTGVvIExpIDxsZW95
YW5nLmxpQG54cC5jb20+DQo+IENjOiBsaW51eHBwYy1kZXZAbGlzdHMub3psYWJzLm9yZzsgbGlu
dXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOw0KPiBsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnOyBTY290dCBXb29kIDxvc3NAYnVzZXJyb3IubmV0PjsNCj4gbmV0ZGV2QHZnZXIu
a2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYzIDM1LzM2XSBuZXQvd2FuOiBtYWtl
IEZTTF9VQ0NfSERMQyBleHBsaWNpdGx5DQo+IGRlcGVuZCBvbiBQUEMzMg0KPiANCj4gDQo+IA0K
PiBMZSAwMS8xMS8yMDE5IMOgIDEzOjQyLCBSYXNtdXMgVmlsbGVtb2VzIGEgw6ljcml0wqA6DQo+
ID4gQ3VycmVudGx5LCBGU0xfVUNDX0hETEMgZGVwZW5kcyBvbiBRVUlDQ19FTkdJTkUsIHdoaWNo
IGluIHR1cm4NCj4gZGVwZW5kcw0KPiA+IG9uIFBQQzMyLiBBcyBwcmVwYXJhdGlvbiBmb3IgcmVt
b3ZpbmcgdGhlIGxhdHRlciBhbmQgdGh1cyBhbGxvd2luZyB0aGUNCj4gPiBjb3JlIFFFIGNvZGUg
dG8gYmUgYnVpbHQgZm9yIG90aGVyIGFyY2hpdGVjdHVyZXMsIG1ha2UgRlNMX1VDQ19IRExDDQo+
ID4gZXhwbGljaXRseSBkZXBlbmQgb24gUFBDMzIuDQo+IA0KPiBJcyB0aGF0IHJlYWxseSBwb3dl
cnBjIHNwZWNpZmljID8gQ2FuJ3QgdGhlIEFSTSBRRSBwZXJmb3JtIEhETEMgb24gVUNDID8NCg0K
Tm8uICBBY3R1YWxseSB0aGUgSERMQyBhbmQgVERNIGFyZSB0aGUgbWFqb3IgcmVhc29uIHRvIGlu
dGVncmF0ZSBhIFFFIG9uIHRoZSBBUk0gYmFzZWQgTGF5ZXJzY2FwZSBTb0NzLg0KDQpTaW5jZSBS
YXNtdXMgZG9lc24ndCBoYXZlIHRoZSBoYXJkd2FyZSB0byB0ZXN0IHRoaXMgZmVhdHVyZSBRaWFu
ZyBaaGFvIHByb2JhYmx5IGNhbiBoZWxwIHZlcmlmeSB0aGUgZnVuY3Rpb25hbGl0eSBvZiBURE0g
YW5kIHdlIGNhbiBkcm9wIHRoaXMgcGF0Y2guDQoNClJlZ2FyZHMsDQpMZW8NCg0KPiANCj4gQ2hy
aXN0b3BoZQ0KPiANCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFJhc211cyBWaWxsZW1vZXMgPGxp
bnV4QHJhc211c3ZpbGxlbW9lcy5kaz4NCj4gPiAtLS0NCj4gPiAgIGRyaXZlcnMvbmV0L3dhbi9L
Y29uZmlnIHwgMiArLQ0KPiA+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRl
bGV0aW9uKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2FuL0tjb25maWcg
Yi9kcml2ZXJzL25ldC93YW4vS2NvbmZpZyBpbmRleA0KPiA+IGRkMWExNDdmMjk3MS4uNzg3ODVk
NzkwYmNjIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L3dhbi9LY29uZmlnDQo+ID4gKysr
IGIvZHJpdmVycy9uZXQvd2FuL0tjb25maWcNCj4gPiBAQCAtMjcwLDcgKzI3MCw3IEBAIGNvbmZp
ZyBGQVJTWU5DDQo+ID4gICBjb25maWcgRlNMX1VDQ19IRExDDQo+ID4gICAJdHJpc3RhdGUgIkZy
ZWVzY2FsZSBRVUlDQyBFbmdpbmUgSERMQyBzdXBwb3J0Ig0KPiA+ICAgCWRlcGVuZHMgb24gSERM
Qw0KPiA+IC0JZGVwZW5kcyBvbiBRVUlDQ19FTkdJTkUNCj4gPiArCWRlcGVuZHMgb24gUVVJQ0Nf
RU5HSU5FICYmIFBQQzMyDQo+ID4gICAJaGVscA0KPiA+ICAgCSAgRHJpdmVyIGZvciBGcmVlc2Nh
bGUgUVVJQ0MgRW5naW5lIEhETEMgY29udHJvbGxlci4gVGhlIGRyaXZlcg0KPiA+ICAgCSAgc3Vw
cG9ydHMgSERMQyBpbiBOTVNJIGFuZCBURE0gbW9kZS4NCj4gPg0K

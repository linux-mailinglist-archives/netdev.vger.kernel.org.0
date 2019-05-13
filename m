Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77C201AF2C
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 05:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfEMDij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 May 2019 23:38:39 -0400
Received: from mail-eopbgr30085.outbound.protection.outlook.com ([40.107.3.85]:41447
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727202AbfEMDii (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 May 2019 23:38:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aciulH2feqIS8JrherdqWH0fe2VFpx1ifMSYWOWjMS0=;
 b=PvZcjrSeLSY1yn2K02gxdgipE/CMtSfdj13TMVSu637sHYawM5uCvH+mP0YLXpcN+jDmQaU8CAlakObofuTTI6n4ciPoIELfITq3s78o7+csasAmP7ScjBcPcw9YdUhh0C6RvTpSLnjohLL7IZ3Xxst2aiPHheZ5jh0S+oSanwo=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB3486.eurprd04.prod.outlook.com (52.134.4.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.22; Mon, 13 May 2019 03:38:32 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::9889:fa82:4172:14df]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::9889:fa82:4172:14df%6]) with mapi id 15.20.1878.024; Mon, 13 May 2019
 03:38:32 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Maxime Ripard <maxime.ripard@bootlin.com>,
        =?utf-8?B?UGV0ciDFoHRldGlhcg==?= <ynezz@true.cz>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "john@phrozen.org" <john@phrozen.org>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alban Bedel <albeu@free.fr>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net 0/3] add property "nvmem_macaddr_swap" to
 swap macaddr bytes order
Thread-Topic: [EXT] Re: [PATCH net 0/3] add property "nvmem_macaddr_swap" to
 swap macaddr bytes order
Thread-Index: AQHVByN8cgfDehywt06hQvfjje4vh6ZkOamAgAQyDnA=
Date:   Mon, 13 May 2019 03:38:32 +0000
Message-ID: <VI1PR0402MB3600516CFAD9227B0E175DF4FF0F0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <1557476567-17397-4-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-3-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-2-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-1-git-send-email-fugang.duan@nxp.com>
 <20190510112822.GT81826@meh.true.cz> <20190510113155.mvpuhe4yzxdaanei@flea>
In-Reply-To: <20190510113155.mvpuhe4yzxdaanei@flea>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12592d9b-b09a-497c-ca61-08d6d75478c7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3486;
x-ms-traffictypediagnostic: VI1PR0402MB3486:
x-ms-exchange-purlcount: 4
x-microsoft-antispam-prvs: <VI1PR0402MB3486B7A9CE87E3A30901EDEEFF0F0@VI1PR0402MB3486.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0036736630
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(396003)(376002)(346002)(136003)(199004)(189003)(74316002)(186003)(76116006)(256004)(14444005)(3846002)(66574012)(446003)(6116002)(4326008)(2906002)(476003)(86362001)(11346002)(486006)(25786009)(26005)(68736007)(966005)(14454004)(53936002)(33656002)(5660300002)(305945005)(66946007)(73956011)(7736002)(8936002)(102836004)(66476007)(66066001)(7416002)(6506007)(66556008)(52536014)(66446008)(76176011)(478600001)(6246003)(64756008)(8676002)(81166006)(81156014)(99286004)(6436002)(55016002)(316002)(7696005)(6306002)(9686003)(71200400001)(71190400001)(54906003)(110136005)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3486;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fLnavigfzByTIenyXkrqXVLhpdKm7/yTOdF05zviWCL/E+iA+7NidnsnbLmxvdqXPbGiz0IjZPLOp4bdUvfQmeuIgizjRr2qRFmwGV18YP5SDLr+jg37rBrPpcm/Fq01zsHjsIhLQG1VJvp4B3eLUwFI37wDfZ+MLiFlsHUIGOKe5sTft0JKVsu2EneuyXv7+QVsAcKeK2UL/2aagEGRnxFQLKqGpVK3m5yp14inPhMzMRLaWrwvNwxnBJKYTATHbOcFHX3U9TU2MC98ZdEiwCvBNurIUoUKiFFC4AmPS+uFExLHxIXKxYJak192O4MsQX87W+EEwSK9N+Z1A7c/SnwbeTtXEQCpHGqy1gBrpDmCKoMv+BY2AJAnfaVUrWx8ZfhO11pV2cH/pcVadcrausgkOLekxmp/URBB6XKbAqs=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12592d9b-b09a-497c-ca61-08d6d75478c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2019 03:38:32.2317
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3486
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTWF4aW1lIFJpcGFyZCA8bWF4aW1lLnJpcGFyZEBib290bGluLmNvbT4gU2VudDogRnJp
ZGF5LCBNYXkgMTAsIDIwMTkgNzozMiBQTQ0KPiBPbiBGcmksIE1heSAxMCwgMjAxOSBhdCAwMToy
ODoyMlBNICswMjAwLCBQZXRyIMWgdGV0aWFyIHdyb3RlOg0KPiA+IEFuZHkgRHVhbiA8ZnVnYW5n
LmR1YW5AbnhwLmNvbT4gWzIwMTktMDUtMTAgMDg6MjM6NThdOg0KPiA+DQo+ID4gSGkgQW5keSwN
Cj4gPg0KPiA+IHlvdSd2ZSBwcm9iYWJseSBmb3JnZXQgdG8gQ2Mgc29tZSBtYWludGFpbmVycyBh
bmQgbWFpbGluZyBsaXN0cywgc28NCj4gPiBJJ20gYWRkaW5nIHRoZW0gbm93IHRvIHRoZSBDYyBs
b29wLiBUaGlzIHBhdGNoIHNlcmllcyBzaG91bGQgYmUgcG9zdGVkDQo+ID4gYWdhaW5zdCBuZXQt
bmV4dCB0cmVlIGFzIHBlciBuZXRkZXYgRkFRWzBdLCBidXQgeW91J3ZlIHRvIHdhaXQgbGl0dGxl
DQo+ID4gYml0IGFzIG5ldC1uZXh0IGlzIGN1cnJlbnRseSBjbG9zZWQgZm9yIHRoZSBuZXcgc3Vi
bWlzc2lvbnMgYW5kIHlvdQ0KPiA+IHdvdWxkIG5lZWQgdG8gcmVzZW5kIGl0IGFueXdheS4NCj4g
Pg0KPiA+IDAuIGh0dHBzOi8vd3d3Lmtlcm5lbC5vcmcvZG9jL2h0bWwvbGF0ZXN0L25ldHdvcmtp
bmcvbmV0ZGV2LUZBUS5odG1sDQo+ID4NCj4gPiA+IGV0aGVybmV0IGNvbnRyb2xsZXIgZHJpdmVy
IGNhbGwgLm9mX2dldF9tYWNfYWRkcmVzcygpIHRvIGdldCB0aGUgbWFjDQo+ID4gPiBhZGRyZXNz
IGZyb20gZGV2aWN0cmVlIHRyZWUsIGlmIHRoZXNlIHByb3BlcnRpZXMgYXJlIG5vdCBwcmVzZW50
LA0KPiA+ID4gdGhlbiB0cnkgdG8gcmVhZCBmcm9tIG52bWVtLiBpLk1YNngvN0QvOE1RLzhNTSBw
bGF0Zm9ybXMgZXRoZXJuZXQNCj4gPiA+IE1BQyBhZGRyZXNzIHJlYWQgZnJvbSBudm1lbSBvY290
cCBlRnVzZXMsIGJ1dCBpdCByZXF1aXJlcyB0byBzd2FwDQo+ID4gPiB0aGUgc2l4IGJ5dGVzIG9y
ZGVyLg0KPiA+DQo+ID4gVGhhbmtzIGZvciBicmluZ2luZyB1cCB0aGlzIHRvcGljLCBhcyBJIHdv
dWxkIGxpa2UgdG8gZXh0ZW5kIHRoZQ0KPiA+IGZ1bmN0aW9uYWxpdHkgYXMgd2VsbCwgYnV0IEkn
bSBzdGlsbCB1bnN1cmUgaG93IHRvIHRhY2tsZSB0aGlzIGFuZA0KPiA+IHdoZXJlLCBzbyBJJ2xs
IChhYil1c2UgdGhpcyBvcHBvcnR1bml0eSB0byBicmluZyBvdGhlciB1c2UgY2FzZXMgSQ0KPiA+
IHdvdWxkIGxpa2UgdG8gY292ZXIgaW4gdGhlIGZ1dHVyZSwgc28gd2UgY291bGQgYmV0dGVyIHVu
ZGVyc3RhbmQgdGhlIG5lZWRzLg0KPiA+DQo+ID4gVGhpcyByZXZlcnNlIGJ5dGUgb3JkZXIgZm9y
bWF0L2xheW91dCBpcyBvbmUgb2YgYSBmZXcgb3RoZXIgc3RvcmFnZQ0KPiA+IGZvcm1hdHMgY3Vy
cmVudGx5IHVzZWQgYnkgdmVuZG9ycywgc29tZSBvdGhlciAoY3JlYXRpdmUpIHZlbmRvcnMgYXJl
DQo+ID4gY3VycmVudGx5IHByb3ZpZGluZyBNQUMgYWRkcmVzc2VzIGluIE5WTUVNcyBhcyBBU0NJ
SSB0ZXh0IGluIGZvbGxvd2luZw0KPiA+IHR3byBmb3JtYXRzIChoZXhkdW1wIC1DIC9kZXYvbXRk
WCk6DQo+ID4NCj4gPiAgYSkgMDA5MEZFQzlDQkU1IC0gTUFDIGFkZHJlc3Mgc3RvcmVkIGFzIEFT
Q0lJIHdpdGhvdXQgY29sb24gYmV0d2Vlbg0KPiA+IG9jdGV0cw0KPiA+DQo+ID4gICAwMDAwMDA5
MCAgNTcgMmUgNGMgNDEgNGUgMmUgNGQgNDEgIDQzIDJlIDQxIDY0IDY0IDcyIDY1IDczDQo+IHxX
LkxBTi5NQUMuQWRkcmVzfA0KPiA+ICAgMDAwMDAwYTAgIDczIDNkIDMwIDMwIDM5IDMwIDQ2IDQ1
ICA0MyAzOSA0MyA0MiA0NSAzNSAwMCA0OA0KPiB8cz0wMDkwRkVDOUNCRTUuSHwNCj4gPiAgIDAw
MDAwMGIwICA1NyAyZSA0YyA0MSA0ZSAyZSAzMiA0NyAgMmUgMzAgMmUgNGQgNDEgNDMgMmUgNDEN
Cj4gPiB8Vy5MQU4uMkcuMC5NQUMuQXwNCj4gPg0KPiA+ICAgKEZyb20NCj4gPg0KPiBodHRwczov
L2dpdGh1Yi5jb20vb3BlbndydC9vcGVud3J0L3B1bGwvMTQ0OCNpc3N1ZWNvbW1lbnQtNDQyNDc2
Njk1KQ0KPiA+DQo+ID4gIGIpIEQ0OkVFOjA3OjMzOjZDOjIwIC0gTUFDIGFkZHJlc3Mgc3RvcmVk
IGFzIEFTQ0lJIHdpdGggY29sb24gYmV0d2Vlbg0KPiA+IG9jdGV0cw0KPiA+DQo+ID4gICAwMDAw
MDE4MCAgNjYgNjEgNjMgNWYgNmQgNjEgNjMgMjAgIDNkIDIwIDQ0IDM0IDNhIDQ1IDQ1IDNhDQo+
IHxmYWNfbWFjID0gRDQ6RUU6fA0KPiA+ICAgMDAwMDAxOTAgIDMwIDM3IDNhIDMzIDMzIDNhIDM2
IDQzICAzYSAzMiAzMCAwYSA0MiA0NCA0OSA0ZQ0KPiA+IHwwNzozMzo2QzoyMC5CRElOfA0KPiA+
DQo+ID4gICAoRnJvbQ0KPiA+DQo+IGh0dHBzOi8vZ2l0aHViLmNvbS9vcGVud3J0L29wZW53cnQv
cHVsbC8xOTA2I2lzc3VlY29tbWVudC00ODM4ODE5MTEpDQo+ID4NCj4gPiA+IFRoZSBwYXRjaCBz
ZXQgaXMgdG8gYWRkIHByb3BlcnR5ICJudm1lbV9tYWNhZGRyX3N3YXAiIHRvIHN3YXANCj4gPiA+
IG1hY2FkZHIgYnl0ZXMgb3JkZXIuDQo+ID4NCj4gPiBzbyBpdCB3b3VsZCBhbGxvdyBmb2xsb3dp
bmcgRFQgY29uc3RydWN0IChzaW1wbGlmaWVkKToNCj4gPg0KPiA+ICAmZXRoMCB7DQo+ID4gCW52
bWVtLWNlbGxzID0gPCZldGgwX2FkZHI+Ow0KPiA+IAludm1lbS1jZWxsLW5hbWVzID0gIm1hYy1h
ZGRyZXNzIjsNCj4gPiAJbnZtZW1fbWFjYWRkcl9zd2FwOw0KPiA+ICB9Ow0KPiA+DQo+ID4gSSdt
IG5vdCBzdXJlIGFib3V0IHRoZSBgbnZtZW1fbWFjYWRkcl9zd2FwYCBwcm9wZXJ0eSBuYW1lLCBh
cw0KPiA+IGN1cnJlbnRseSB0aGVyZSBhcmUgbm8gb3RoZXIgcHJvcGVydGllcyB3aXRoIHVuZGVy
c2NvcmVzLCBzbyBpdCBzaG91bGQNCj4gPiBiZSBwcm9iYWJseSBuYW1lZCBhcyBgbnZtZW0tbWFj
YWRkci1zd2FwYC4gRFQgc3BlY3MgcGVybWl0cyB1c2Ugb2YgdGhlDQo+ID4gdW5kZXJzY29yZXMs
IGJ1dCB0aGUgZXN0YWJpbGlzaGVkIGNvbnZlbnRpb24gaXMgcHJvYmFibHkgcHJlZmVyZWQuDQo+
ID4NCj4gPiBJbiBvcmRlciB0byBjb3ZlciBhbGwgYWJvdmUgbWVudGlvbmVkIHVzZSBjYXNlcywg
aXQgd291bGQgbWFrZSBtb3JlDQo+ID4gc2Vuc2UgdG8gYWRkIGEgZGVzY3JpcHRpb24gb2YgdGhl
IE1BQyBhZGRyZXNzIGxheW91dCB0byB0aGUgRFQgYW5kIHVzZQ0KPiA+IHRoaXMgaW5mb3JtYXRp
b24gdG8gcHJvcGVybHkgcG9zdHByb2Nlc3MgdGhlIE5WTUVNIGNvbnRlbnQgaW50byB1c2FibGUN
Cj4gPiBNQUMgYWRkcmVzcz8NCj4gPg0KPiA+IFNvbWV0aGluZyBsaWtlIHRoaXM/DQo+ID4NCj4g
PiAgLSBudm1lbS1jZWxsczogcGhhbmRsZSwgcmVmZXJlbmNlIHRvIGFuIG52bWVtIG5vZGUgZm9y
IHRoZSBNQUMNCj4gPiBhZGRyZXNzDQo+ID4gIC0gbnZtZW0tY2VsbC1uYW1lczogc3RyaW5nLCBz
aG91bGQgYmUgIm1hYy1hZGRyZXNzIiBpZiBudm1lbSBpcyB0byBiZQ0KPiA+IHVzZWQNCj4gPiAg
LSBudm1lbS1tYWMtYWRkcmVzcy1sYXlvdXQ6IHN0cmluZywgc3BlY2lmaWVzIE1BQyBhZGRyZXNz
IHN0b3JhZ2UNCj4gbGF5b3V0Lg0KPiA+ICAgIFN1cHBvcnRlZCB2YWx1ZXMgYXJlOiAiYmluYXJ5
IiwgImJpbmFyeS1zd2FwcGVkIiwgImFzY2lpIiwNCj4gImFzY2lpLWRlbGltaXRlZCIuDQo+ID4g
ICAgImJpbmFyeSIgaXMgdGhlIGRlZmF1bHQuDQo+ID4NCj4gPiBPciBwZXJoYXBzIHNvbWV0aGlu
ZyBsaWtlIHRoaXM/DQo+ID4NCj4gPiAgLSBudm1lbS1jZWxsczogcGhhbmRsZSwgcmVmZXJlbmNl
IHRvIGFuIG52bWVtIG5vZGUgZm9yIHRoZSBNQUMNCj4gPiBhZGRyZXNzDQo+ID4gIC0gbnZtZW0t
Y2VsbC1uYW1lczogc3RyaW5nLCBzaG91bGQgYmUgYW55IG9mIHRoZSBzdXBwb3J0ZWQgdmFsdWVz
Lg0KPiA+ICAgIFN1cHBvcnRlZCB2YWx1ZXMgYXJlOiAibWFjLWFkZHJlc3MiLCAibWFjLWFkZHJl
c3Mtc3dhcHBlZCIsDQo+ID4gICAgIm1hYy1hZGRyZXNzLWFzY2lpIiwgIm1hYy1hZGRyZXNzLWFz
Y2lpLWRlbGltaXRlZCIuDQo+ID4NCj4gPiBJJ20gbW9yZSBpbmNsaW5lZCB0b3dhcmRzIHRoZSBm
aXJzdCBwcm9wb3NlZCBzb2x1dGlvbiwgYXMgSSB3b3VsZCBsaWtlDQo+ID4gdG8gcHJvcG9zZSBN
QUMgYWRkcmVzcyBvY3RldCBpbmNyZW1lbnRhdGlvbiBmZWF0dXJlIGluIHRoZSBmdXR1cmUsIHNv
DQo+ID4gaXQgd291bGQNCj4gPiBiZWNvbWU6DQo+ID4NCj4gPiAgLSBudm1lbS1jZWxsczogcGhh
bmRsZSwgcmVmZXJlbmNlIHRvIGFuIG52bWVtIG5vZGUgZm9yIHRoZSBNQUMNCj4gPiBhZGRyZXNz
DQo+ID4gIC0gbnZtZW0tY2VsbC1uYW1lczogc3RyaW5nLCBzaG91bGQgYmUgIm1hYy1hZGRyZXNz
IiBpZiBudm1lbSBpcyB0byBiZQ0KPiA+IHVzZWQNCj4gPiAgLSBudm1lbS1tYWMtYWRkcmVzcy1s
YXlvdXQ6IHN0cmluZywgc3BlY2lmaWVzIE1BQyBhZGRyZXNzIHN0b3JhZ2UNCj4gbGF5b3V0Lg0K
PiA+ICAgIFN1cHBvcnRlZCB2YWx1ZXMgYXJlOiAiYmluYXJ5IiwgImJpbmFyeS1zd2FwcGVkIiwg
ImFzY2lpIiwNCj4gImFzY2lpLWRlbGltaXRlZCIuDQo+ID4gICAgImJpbmFyeSIgaXMgdGhlIGRl
ZmF1bHQuDQo+ID4gIC0gbnZtZW0tbWFjLWFkZHJlc3MtaW5jcmVtZW50OiBudW1iZXIsIHZhbHVl
IGJ5IHdoaWNoIHNob3VsZCBiZQ0KPiA+ICAgIGluY3JlbWVudGVkIE1BQyBhZGRyZXNzIG9jdGV0
LCBjb3VsZCBiZSBuZWdhdGl2ZSB2YWx1ZSBhcyB3ZWxsLg0KPiA+ICAtIG52bWVtLW1hYy1hZGRy
ZXNzLWluY3JlbWVudC1vY3RldDogbnVtYmVyLCB2YWxpZCB2YWx1ZXMgMC01LCBkZWZhdWx0DQo+
IGlzIDUuDQo+ID4gICAgU3BlY2lmaWVzIE1BQyBhZGRyZXNzIG9jdGV0IHVzZWQgZm9yDQo+IGBu
dm1lbS1tYWMtYWRkcmVzcy1pbmNyZW1lbnRgLg0KPiA+DQo+ID4gV2hhdCBkbyB5b3UgdGhpbms/
DQo+IA0KPiBJdCBsb29rcyB0byBtZSB0aGF0IGl0IHNob3VsZCBiZSBhYnN0cmFjdGVkIGF3YXkg
YnkgdGhlIG52bWVtIGludGVyZmFjZSBhbmQNCj4gZG9uZSBhdCB0aGUgcHJvdmlkZXIgbGV2ZWws
IG5vdCB0aGUgY3VzdG9tZXIuDQo+IA0KPiBNYXhpbWUNCj4gDQpJZiB0byBpbXBsZW1lbnQgYWRk
IGFib3ZlIGZlYXR1cmVzIGxpa2UgUGV0ciDFoHRldGlhciBkZXNjcmliZWQsIGl0IHNob3VsZCBi
ZSBhYnN0cmFjdGVkDQpJbiBudm1lbSBjb3JlIGRyaXZlci4NCg0KPiAtLQ0KPiBNYXhpbWUgUmlw
YXJkLCBCb290bGluDQo+IEVtYmVkZGVkIExpbnV4IGFuZCBLZXJuZWwgZW5naW5lZXJpbmcNCj4g
aHR0cHM6Ly9ib290bGluLmNvbQ0K

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC4610ACD2
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 10:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfK0Jse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 04:48:34 -0500
Received: from mail-eopbgr40088.outbound.protection.outlook.com ([40.107.4.88]:33958
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726143AbfK0Jsd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 04:48:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QoBOtyu3YFkqUzoWUewx3DEVm8YANJRPqoym4ObeJniBcCJmUB5CvjkHQs1eu+kR6AveeWqogHB7FNYdd9niRZYa2pcmfV+EaRuiH1DP6Pw51fW3M87KtFDh2tTEJkgZN0DqOV//eawJZWnpD20qLTGQgHzj6N5zwd4lVhunDuJGRtmZyaI66HM/dQHNZEIW6MvWJWGIJDtIwD8EJHHMTmXzMy2Cq6tnfn9IqEuNMLQxGjh15g7DKv5mU8RgQ6+iL9UogeEJdRUqrvXz5Rnh5rZDM9fMKfExYcAjOmcKlcuk7aWQgTW95U+0CNP9jLox099fQl0pnhk2ctlxSfR5mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSfz7fbFQHukX3yfNPk60qvnYLGwE4w/SBcRjuofayE=;
 b=glo4NSjJmp6MBIW83IQQq2Fqj2zKL+omn8vSYxhwIGrKmqmSmk9Yle24ZcspiEpdtcz/7VKEVAGS1lcGmYlnI9Pio9weWZedvXqIp9PPjVKlT6wRjYSffTpAbpl/2UqP4xxopV12oEuE/rLCpCLLaS6bvmhvoLukhA9VH6cSEg1o3q9brRSWMUngSF5r0CQ7/UDTRzS5niefVTdJuddcQCY0CtQkrlyMxp4Y2z7ogZhVzH0tbzqxl73GQltCc3GXkfI3ze/Q92U+tBnuV6NEfkOwEj97HvkMMX/ZvRcEnbt4Z8N1Pz6pPnhouqTaLZCYFnw8pYBCTxvCGfGrbo8k4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSfz7fbFQHukX3yfNPk60qvnYLGwE4w/SBcRjuofayE=;
 b=oqAnb1Gz34L29R9CM46kkSent/EVz1yWbHxf+pj+6MJe9oSTa9cuTVSd4zT2BVLJlpTFzygXSHb9LGdmOGGW8WuHmOazur1d7RVD9FzTONOgrKiZRp4sx4IAdsoQQk4yx5qe0GBMweFrtur9sfmHbxiH5h3S790ZZ5FUHZAVyPA=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4779.eurprd04.prod.outlook.com (20.176.236.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Wed, 27 Nov 2019 09:48:30 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 09:48:30 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Sean Nyekjaer <sean@geanix.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH V2 0/4] can: flexcan: fixes for stop mode
Thread-Topic: [PATCH V2 0/4] can: flexcan: fixes for stop mode
Thread-Index: AQHVpOdxXAI9W9cZiUqxHtJbOFpoG6eeiWMAgAAhqwCAABa5QIAAAZ0w
Date:   Wed, 27 Nov 2019 09:48:29 +0000
Message-ID: <DB7PR04MB4618C541894AD851BED5B0B7E6440@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <e936b9b1-d602-ac38-213c-7272df529bef@geanix.com>
 <4a9c2e4a-c62d-6e88-bd9e-01778dab503b@geanix.com>
 <DB7PR04MB46186472F0437A825548CE11E6440@DB7PR04MB4618.eurprd04.prod.outlook.com>
In-Reply-To: <DB7PR04MB46186472F0437A825548CE11E6440@DB7PR04MB4618.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a8e02548-3d59-4b4c-63d5-08d7731ef586
x-ms-traffictypediagnostic: DB7PR04MB4779:|DB7PR04MB4779:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4779395039900C36FC808D3DE6440@DB7PR04MB4779.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(13464003)(189003)(199004)(8936002)(2940100002)(66066001)(52536014)(76176011)(9686003)(55016002)(305945005)(478600001)(110136005)(74316002)(81156014)(99286004)(4326008)(54906003)(6436002)(7736002)(14454004)(7696005)(81166006)(33656002)(316002)(11346002)(5660300002)(6506007)(26005)(229853002)(8676002)(186003)(25786009)(2201001)(6246003)(76116006)(64756008)(66446008)(256004)(14444005)(66476007)(66946007)(86362001)(3846002)(66556008)(6116002)(446003)(102836004)(71200400001)(71190400001)(2501003)(53546011)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4779;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FYDMWf7NvyPJTAqmgMPNx2cWMI/zyISePSTSPKbQQHp3C/ZETSPGFbZtrzKwWkvr4+E0rTAaM1L17lywQr6Em6i9A7J4Lubj2wn1nTnUGzYllakTTNIDPGM6O/bhQ2vx7PZa1PxM3CPN+SJPbQjow4QO4ZCFysZfqnV+GLpvbA/Z1qhwWE8tZR8hvbV7dqmejs7/ML9lAv0KbmZ4nOjk6fwMcy2Ku+jCmwY3ouFqfOYZSBDMg8/vKYAHHmeIlTHFYv7QqLjmPxMsIPWGo5Da1rWuenqoXLTjcQdvzf+CZCmVIyajoAM5o1pYJjO7UH5f/Y5CTtPRnYPHtPHdxzxHrHzfx5aPBt4gqLd9VkWDbKv450M+G994SnDUeqpIk2FAUBu2ecc5ob7BMNElWGCRjYaKBT5ysRWAqBiYBYe26ROqHoWrboN79U3/MHgNL0+k
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8e02548-3d59-4b4c-63d5-08d7731ef586
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 09:48:29.9144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w1ZrjcJktXpGfU/wy9f254WMfo3FUZjiTSzy3wOSBqeeJjH2Jep0zmu7c+2O75y9a+PYU1ehXK6ecWdApN/WmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4779
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvYWtpbSBaaGFuZyA8cWlh
bmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IFNlbnQ6IDIwMTnlubQxMeaciDI35pelIDE3OjM3DQo+
IFRvOiBTZWFuIE55ZWtqYWVyIDxzZWFuQGdlYW5peC5jb20+OyBta2xAcGVuZ3V0cm9uaXguZGU7
DQo+IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGRsLWxpbnV4LWlteCA8bGludXgt
aW14QG54cC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJFOiBbUEFU
Q0ggVjIgMC80XSBjYW46IGZsZXhjYW46IGZpeGVzIGZvciBzdG9wIG1vZGUNCj4gDQo+IA0KPiA+
IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogU2VhbiBOeWVramFlciA8c2Vh
bkBnZWFuaXguY29tPg0KPiA+IFNlbnQ6IDIwMTnlubQxMeaciDI35pelIDE2OjEzDQo+ID4gVG86
IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBta2xAcGVuZ3V0cm9uaXgu
ZGU7DQo+ID4gbGludXgtY2FuQHZnZXIua2VybmVsLm9yZw0KPiA+IENjOiBkbC1saW51eC1pbXgg
PGxpbnV4LWlteEBueHAuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiA+IFN1YmplY3Q6
IFJlOiBbUEFUQ0ggVjIgMC80XSBjYW46IGZsZXhjYW46IGZpeGVzIGZvciBzdG9wIG1vZGUNCj4g
Pg0KPiA+DQo+ID4NCj4gPiBPbiAyNy8xMS8yMDE5IDA3LjEyLCBTZWFuIE55ZWtqYWVyIHdyb3Rl
Og0KPiA+ID4NCj4gPiA+DQo+ID4gPiBPbiAyNy8xMS8yMDE5IDA2LjU2LCBKb2FraW0gWmhhbmcg
d3JvdGU6DQo+ID4gPj4gwqDCoMKgwqBDb3VsZCB5b3UgaGVscCBjaGVjayB0aGUgcGF0Y2ggc2V0
PyBXaXRoIHlvdXIgc3VnZ2VzdGlvbnMsIEkNCj4gPiA+PiBoYXZlIGNvb2tlZCBhIHBhdGNoIHRv
IGV4aXQgc3RvcCBtb2RlIGR1cmluZyBwcm9iZSBzdGFnZS4NCj4gPiA+Pg0KPiA+ID4+IMKgwqDC
oMKgSU1ITywgSSB0aGluayB0aGlzIHBhdGNoIGlzIHVubmVlZCwgbm93IGluIGZsZXhjYW4gZHJp
dmVyLA0KPiA+ID4+IGVudGVyIHN0b3AgbW9kZSB3aGVuIHN1c3BlbmQsIGFuZCB0aGVuIGV4aXQg
c3RvcCBtb2RlIHdoZW4gcmVzdW1lLg0KPiA+ID4+IEFGQUlLLCBhcyBsb25nIGFzIGZsZXhjYW5f
c3VzcGVuZCBoYXMgYmVlbiBjYWxsZWQsIGZsZXhjYW5fcmVzdW1lDQo+ID4gPj4gd2lsbCBiZSBj
YWxsZWQsIHVubGVzcyB0aGUgc3lzdGVtIGhhbmcgZHVyaW5nIHN1c3BlbmQvcmVzdW1lLiBJZg0K
PiA+ID4+IHNvLCBvbmx5IGNvZGUgcmVzZXQgY2FuIGFjdGl2YXRlIE9TIGFnYWluLiBDb3VsZCB5
b3UgcGxlYXNlIHRlbGwgbWUNCj4gPiA+PiBob3cgZG9lcyBDQU4gc3R1Y2tlZCBpbiBzdG9wIG1v
ZGUgYXQgeW91ciBzaWRlPw0KPiA+ID4NCj4gPiA+IEhpIEpvYWtpbSwNCj4gPiA+DQo+ID4gPiBU
aGFua3MgSSdsbCB0ZXN0IHRoaXMgOi0pDQo+ID4gPiBHdWVzcyBJIHdpbGwgaGF2ZSBkbyBzb21l
IGhhY2tpbmcgdG8gZ2V0IGl0IHN0dWNrIGluIHN0b3AgbW9kZS4NCj4gPiA+DQo+ID4gPiBXZSBo
YXZlIGEgbG90IG9mIGRldmljZXMgaW4gdGhlIGZpZWxkIHRoYXQgZG9lc24ndCBoYXZlOg0KPiA+
ID4gImNhbjogZmxleGNhbjogZml4IGRlYWRsb2NrIHdoZW4gdXNpbmcgc2VsZiB3YWtldXAiDQo+
ID4gPg0KPiA+ID4gQW5kIHRoZXkgaGF2ZSB0cmFmZmljIG9uIGJvdGggQ0FOIGludGVyZmFjZXMs
IHRoYXQgd2F5IGl0J3MgcXVpdGUNCj4gPiA+IGVhc3kgdG8gZ2V0IHRoZW0gc3R1Y2sgaW4gc3Rv
cCBtb2RlLg0KPiA+ID4NCj4gPiA+IC9TZWFuDQo+ID4NCj4gPiBIaSBKb2FraW0sDQo+ID4NCj4g
PiBJIGhhdmUgYmVlbiB0ZXN0aW5nIHRoaXMuDQo+ID4gSSBoYXZlIGEgaGFja2VkIHZlcnNpb24g
b2YgdGhlIGRyaXZlciB0aGF0IGNhbGxzDQo+ID4gZmxleGNhbl9lbnRlcl9zdG9wX21vZGUoKSBh
cyB0aGUgbGFzdCBzdGVwIGluIHRoZSBwcm9iZSBmdW5jdGlvbi4NCj4gPg0KPiA+IEZpcnN0IGlu
c2VydCBvZiBmbGV4Y2FuLmtvIHdoZW4gc3RvcCBtb2RlIGlzIGFjdGl2YXRlZDoNCj4gPiBmbGV4
Y2FuIDIwOTAwMDAuZmxleGNhbjogTGlua2VkIGFzIGEgY29uc3VtZXIgdG8gcmVndWxhdG9yLjQN
Cj4gPg0KPiA+IGZsZXhjYW4gMjA5MDAwMC5mbGV4Y2FuOiByZWdpc3RlcmluZyBuZXRkZXYgZmFp
bGVkDQo+ID4NCj4gPiBmbGV4Y2FuIDIwOTAwMDAuZmxleGNhbjogRHJvcHBpbmcgdGhlIGxpbmsg
dG8gcmVndWxhdG9yLjQNCj4gPg0KPiA+IGZsZXhjYW46IHByb2JlIG9mIDIwOTAwMDAuZmxleGNh
biBmYWlsZWQgd2l0aCBlcnJvciAtMTEwDQo+ID4NCj4gPiBmbGV4Y2FuIDIwOTQwMDAuZmxleGNh
bjogTGlua2VkIGFzIGEgY29uc3VtZXIgdG8gcmVndWxhdG9yLjQNCj4gPg0KPiA+IGZsZXhjYW4g
MjA5NDAwMC5mbGV4Y2FuOiByZWdpc3RlcmluZyBuZXRkZXYgZmFpbGVkDQo+ID4NCj4gPiBmbGV4
Y2FuIDIwOTQwMDAuZmxleGNhbjogRHJvcHBpbmcgdGhlIGxpbmsgdG8gcmVndWxhdG9yLjQNCj4g
Pg0KPiA+IGZsZXhjYW46IHByb2JlIG9mIDIwOTQwMDAuZmxleGNhbiBmYWlsZWQgd2l0aCBlcnJv
ciAtMTEwDQo+ID4NCj4gPg0KPiA+IFdoZW4gSSBpbnNlcnQgYSBmbGV4Y2FuLmtvIHdpdGggdGhl
IHBhdGNoDQo+ID4gImNhbjogZmxleGNhbjogdHJ5IHRvIGV4aXQgc3RvcCBtb2RlIGR1cmluZyBw
cm9iZSBzdGFnZSI6DQo+ID4gZmxleGNhbiAyMDkwMDAwLmZsZXhjYW46IExpbmtlZCBhcyBhIGNv
bnN1bWVyIHRvIHJlZ3VsYXRvci40DQo+ID4NCj4gPiBmbGV4Y2FuIDIwOTAwMDAuZmxleGNhbjog
VW5iYWxhbmNlZCBwbV9ydW50aW1lX2VuYWJsZSENCj4gPg0KPiA+IGZsZXhjYW4gMjA5NDAwMC5m
bGV4Y2FuOiBMaW5rZWQgYXMgYSBjb25zdW1lciB0byByZWd1bGF0b3IuNA0KPiA+DQo+ID4gZmxl
eGNhbiAyMDk0MDAwLmZsZXhjYW46IFVuYmFsYW5jZWQgcG1fcnVudGltZV9lbmFibGUhDQo+ID4N
Cj4gPiBJIHdvcmtzIGFzIEkgZXhwZWN0ZWQgYnV0LCBJIHRoaW5rIHdlIG5lZWQgdG8gZG8gc29t
ZSBwbV9ydW50aW1lDQo+ID4gY2xlYW51cCB3aGVuIGJhaWxpbmcgd2l0aCBlcnJvciAtMTEwLg0K
PiA+IEFueXdheXMgaXQgd29ya3MgZ3JlYXQsIHRoYW5rcyBmb3IgeW91ciB3b3JrIG9uIHRoaXMu
DQo+IA0KPiBIaSBTZWFuLA0KPiANCj4gVGhhbmtzIGZvciB5b3VyIHF1aXJrIHRlc3QsIEkgdXNl
ZCB1bmJpbmQvYmluZCB0byB0ZXN0LCBkbyBub3QgbWVldCBzdWNoIGlzc3VlLg0KPiBJIHdpbGwg
YnVpbGQgYXMgYSBtb2R1bGUgdG8gaGF2ZSBhIHRlc3QuDQoNCk9uZSBtb3JlIHNob3VsZCBjb25m
aXJtIHdpdGggeW91LCB5b3UgaW5zZXJ0ZWQgYSBmbGV4Y2FuLmtvIGFmdGVyIHN0b3AgbW9kZSBh
Y3RpdmF0ZWQgd2l0aG91dCBmaXggcGF0Y2ggZmlyc3RseSwgYW5kIHRoZW4gaW5zZXJ0ZWQgYSBm
bGV4Y2FuLmtvDQp3aXRoIGZpeCBwYXRjaC4gSWYgeWVzLCB0aGlzIGNvdWxkIGNhdXNlIHVuYmFs
YW5jZWQgcG1fcnVudGltZV9lbmFibGVkLiBUaGUgcmVhc29uIGlzIHRoYXQgZmlyc3RseSBpbnNl
cnRlZCB0aGUgZmxleGNhbi5rbyB3b3VsZCBlbmFibGUgZGV2aWNlIHJ1bnRpbWUgcG0sDQphbmQg
dGhlbiB5b3UgaW5zZXJ0ZWQgZmxleGNhbi5rbyBlbmFibGUgZGV2aWNlIHJ1bnRpbWUgcG0gYWdh
aW4uDQoNCkNvdWxkIHlvdSBwbGVhc2UgaW5zZXJ0IGZsZXhjYW4ua28gd2l0aCBmaXggcGF0Y2gg
ZGlyZWN0bHkgYWZ0ZXIgc3RvcCBtb2RlIGFjdGl2YXRlZD8NCiANCkJlc3QgUmVnYXJkcywNCkpv
YWtpbSBaaGFuZw0KPiBCZXN0IFJlZ2FyZHMsDQo+IEpvYWtpbSBaaGFuZw0KPiA+IC9TZWFuDQo=

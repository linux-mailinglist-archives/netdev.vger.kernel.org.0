Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81B26E58AB
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 06:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfJZEyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 00:54:50 -0400
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:2934
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725866AbfJZEyu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 00:54:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWtWGbHcQ+m5dsVxEnoE9ExP0hiuIWUi39q+crNzEMgmmchYRFcG+kCIck75/nxcqcO1d/kOC4llTupXoUvSYgeqgAKtkbgwL8VjQW0z6uA6RVnUv0ixctTbFfyVJdE/38V/zS9gvFDibjxlt7P6HOUKWjmPvpSEa05LldbIJ1klf5eMAX3d1BW6a4xXoh9fQUUyYG3Nuw16bkFOfk5838+vLxVi8bbQ3w6P28ev8Zrt12DXkURGWpdP59e3cHk06vQyBWU4dg9EDKiy9LioqaDF5eEnjPmfkKzTJrEdz5Q4Dq4v3nYIlaq+t6VTb/ICjKizIA3pbho5UlVoXvEduA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQ+eC8RKnc3+D0qMqSAf8Uz6zpwA/wabeJn6+DCVtRk=;
 b=AUB5sTNjiVJK//FELBQHl/M7Fc6FPpfTQDRodco/+Do+vd7B6R3nW1rMuHQ8otOfVRQ+QiO28zrerC3qfbd3PoAB4LiJMz8q5RNGtKrfi3JtRCOL1qBIgUzZrXJ1kxws4n3faV63Lg+/PbtZX6WFPYLi731u9IJYQyBrC/q0TB5HHuU+ajcEQuCGIumKvKCNmyzt30+K6qMCTagTk+g817aNTYcKpNJtbVQyd1uuEz2zOjeLyKGo+a5eokVfL8AFHh5QiP3OokQnn4HrdlYrNV5RjXUf7xyenDwPLLQOBgwlGamqwmb6I9nWV5buz1TznxIF7v+dOLOIaKfpZMeKMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQ+eC8RKnc3+D0qMqSAf8Uz6zpwA/wabeJn6+DCVtRk=;
 b=Pcs1dz4mZWGAeuw9wKWcmcRvoJqc2Ufq+/b22ewuR2ZluG4JFaMr8+OJCEXvH00MOeDz8cGAtWtpS3yTZ5ZWNVbSojC25EfUcrBhUJgxqaaujCfqTgWiPP6ZqLcVW5sRktuoQ4z7TdWMt/laUgK0s4bHP8lA8vBjjvH6a1/N09Q=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB3855.eurprd04.prod.outlook.com (52.134.17.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Sat, 26 Oct 2019 04:54:43 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::5dd6:297c:51e5:2b52]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::5dd6:297c:51e5:2b52%7]) with mapi id 15.20.2387.021; Sat, 26 Oct 2019
 04:54:43 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] net: fec: remove redundant assignment to pointer
 bdp
Thread-Topic: [EXT] [PATCH] net: fec: remove redundant assignment to pointer
 bdp
Thread-Index: AQHVi1jacZHmo8ibwUGeuXB66RDSGKdsW/gw
Date:   Sat, 26 Oct 2019 04:54:43 +0000
Message-ID: <VI1PR0402MB3600328E75600B583331C2C2FF640@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20191025172255.4742-1-colin.king@canonical.com>
In-Reply-To: <20191025172255.4742-1-colin.king@canonical.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 041bb832-a008-4eb7-4d2e-08d759d09df7
x-ms-traffictypediagnostic: VI1PR0402MB3855:
x-microsoft-antispam-prvs: <VI1PR0402MB38555EF99E31D3D7B9E86C08FF640@VI1PR0402MB3855.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-forefront-prvs: 0202D21D2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(189003)(199004)(9686003)(26005)(99286004)(55016002)(25786009)(478600001)(2906002)(446003)(7696005)(14454004)(2501003)(316002)(66556008)(66446008)(76116006)(66946007)(64756008)(6506007)(76176011)(102836004)(66476007)(110136005)(54906003)(229853002)(11346002)(186003)(6246003)(476003)(6436002)(486006)(6116002)(3846002)(66066001)(52536014)(8676002)(81156014)(81166006)(8936002)(4326008)(14444005)(74316002)(7736002)(305945005)(86362001)(4744005)(33656002)(5660300002)(256004)(71200400001)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3855;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HGii3eGeQkHNpiCu8BIiJMVkjO9QqZdgNRxhAv5Cz1SK7BuFSbMokZLNq71Tf8qu4eoc5zI409XG5PWjj9NPUnskUlfVw0M2fj8r3qtkpIBY2EajviuiXnrYF/O1sh29N5OIqBzcJp4c9SF/OJQ+KYo3Z+5lxMduwNHCa15Qk+ijHFRpnMfAydIm/BnVABk5joKknG0VfAnqCb6JZ6uIO8jFaercdkuCqjTDbK2/b0tMwvtrOUAiDy/iPdYXqY68nF5N39W249FsaxUR5So94pFle2NPX1jNyPsfyoJUMsOwWtIpIi5fAUamLT9vsiFeJzYY/GaXY0MUVFID5JtgQZCieIof1aA3Wh5OjICcEmezCW8vONz0kBtbP0K6ad49Aj4/XYGs0JwBOHQtquCwId8GDDjXx26DZEElcIj2z0wCUcCX0v6PJEzxQDNPwUPX
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 041bb832-a008-4eb7-4d2e-08d759d09df7
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2019 04:54:43.2955
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L1ClRe9q3yeUX6mWcUc526QR441e7BG6JsA+jd0U6O2EO6AOa+C/IdLSqsQ10dqRkd7IZ0HElvkDzpUreR8A0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3855
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQ29saW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPiBTZW50OiBTYXR1cmRh
eSwgT2N0b2JlciAyNiwgMjAxOSAxOjIzIEFNDQo+IFRoZSBwb2ludGVyIGJkcCBpcyBiZWluZyBh
c3NpZ25lZCB3aXRoIGEgdmFsdWUgdGhhdCBpcyBuZXZlciByZWFkLCBzbyB0aGUNCj4gYXNzaWdu
bWVudCBpcyByZWR1bmRhbnQgYW5kIGhlbmNlIGNhbiBiZSByZW1vdmVkLg0KPiANCj4gQWRkcmVz
c2VzLUNvdmVyaXR5OiAoIlVudXNlZCB2YWx1ZSIpDQo+IFNpZ25lZC1vZmYtYnk6IENvbGluIElh
biBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+DQpUaGFua3MuDQoNCkFja2VkLWJ5OiBG
dWdhbmcgRHVhbiA8ZnVnYW5nLmR1YW5AbnhwLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9l
dGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYyB8IDEgLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEg
ZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVl
c2NhbGUvZmVjX21haW4uYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNf
bWFpbi5jDQo+IGluZGV4IGQ0ZDRjNzJhZGY0OS4uNjA4MTk2YmRkODkyIDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0KPiArKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0KPiBAQCAtMjcwNiw3ICsyNzA2
LDYgQEAgc3RhdGljIHZvaWQgZmVjX2VuZXRfZnJlZV9idWZmZXJzKHN0cnVjdA0KPiBuZXRfZGV2
aWNlICpuZGV2KQ0KPiANCj4gICAgICAgICBmb3IgKHEgPSAwOyBxIDwgZmVwLT5udW1fdHhfcXVl
dWVzOyBxKyspIHsNCj4gICAgICAgICAgICAgICAgIHR4cSA9IGZlcC0+dHhfcXVldWVbcV07DQo+
IC0gICAgICAgICAgICAgICBiZHAgPSB0eHEtPmJkLmJhc2U7DQo+ICAgICAgICAgICAgICAgICBm
b3IgKGkgPSAwOyBpIDwgdHhxLT5iZC5yaW5nX3NpemU7IGkrKykgew0KPiAgICAgICAgICAgICAg
ICAgICAgICAgICBrZnJlZSh0eHEtPnR4X2JvdW5jZVtpXSk7DQo+ICAgICAgICAgICAgICAgICAg
ICAgICAgIHR4cS0+dHhfYm91bmNlW2ldID0gTlVMTDsNCj4gLS0NCj4gMi4yMC4xDQoNCg==

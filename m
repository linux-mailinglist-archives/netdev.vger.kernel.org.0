Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60EB610AD01
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 10:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfK0J6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 04:58:08 -0500
Received: from mail-eopbgr50054.outbound.protection.outlook.com ([40.107.5.54]:16777
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726383AbfK0J6I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 04:58:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KOgAov2d3VyMVVv/wVo8ehv8MLl2jv4G9+BqJ8JcS8oPhqXSkP6PAhUa4EvBW8LsLkm74yssKSLoNL1GLdvahvL1NvrBv/DhT5pSO1s9L6zJM5Q11g9UbOHwDqcsC4wBV3225O4OHuaLgjt7uT7RVjQ8A44uzQ7wGpFKFAE5LNnolzdc2YNvoZPrQN0h4vjzbgZYSnlCFL0HZkG0Jwg3XuclQNx18rO5IHhBInADd+8ElDVGCQ7g1fCaV34FNTNiT6M5ZXmbCnDQabToUIigCUC8Q1376ZfD7ZJ+Exb77J3dB1NyJ8CGu06+MVOMDgkvPtFqPIN3OHp3e/e2fDwIHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WhGwbh7zVFcGIJrdq9oEkyPiUy6ODz8AG3j8KS4BDzc=;
 b=EdSun/BU44bfH0gBAHu81c4xhEUxeglhQ5tt0vuZNklf7Q91TZQiSoCsZxUNNpls3OyebhDadjV2NuJx2pt4zugloiswbWFQYJmVl79FHbbPpay6r4y5hDL5R/fygiKncScxWD1wGkz+oxLbfEF55KUjGgYMBGYhkRGLWsYWCgwU6Ujpy/sXIqkGkZBcnx+2uAuPxvRtKBuI0YB+CE0QgVpOyotVtEoDtAXBxujHD5LagVJgxm48viQZGvbIB3Nw6UeLycJdeSavLb33PoBJHxIT98RjJpSvmOGC6aTHWYpMkmTIhsAANXtZszT1EBXXr4BI4TLZx4Y6QLL4PdEHEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WhGwbh7zVFcGIJrdq9oEkyPiUy6ODz8AG3j8KS4BDzc=;
 b=Bio5v1By5hjU1cv26EDL0LgDIsqxsy0Cm6hUSa+QqDfZbvtqNavTzZEDhxg6Qnn5x/gQluuOz66qwJcRuuIJwEo65teSKyVXoWUe2dVOL2Cmtz1FSFWx3Wvopj2n4MOw9u1MKmVShAKr3LNm9B/FagJbg3dKjvYVSNmWSt4ZSgI=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB6009.eurprd04.prod.outlook.com (20.178.105.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.18; Wed, 27 Nov 2019 09:58:03 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 09:58:03 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Sean Nyekjaer <sean@geanix.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH V2 0/4] can: flexcan: fixes for stop mode
Thread-Topic: [PATCH V2 0/4] can: flexcan: fixes for stop mode
Thread-Index: AQHVpOdxXAI9W9cZiUqxHtJbOFpoG6eeiWMAgAAhqwCAABa5QIAAAZ0wgAADdACAAADr0A==
Date:   Wed, 27 Nov 2019 09:58:03 +0000
Message-ID: <DB7PR04MB46180EE59D373F9634DD936AE6440@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <e936b9b1-d602-ac38-213c-7272df529bef@geanix.com>
 <4a9c2e4a-c62d-6e88-bd9e-01778dab503b@geanix.com>
 <DB7PR04MB46186472F0437A825548CE11E6440@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <DB7PR04MB4618C541894AD851BED5B0B7E6440@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <1c71c2ef-39a4-6f38-98c0-4ee43767a725@geanix.com>
In-Reply-To: <1c71c2ef-39a4-6f38-98c0-4ee43767a725@geanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 73280cf5-3a0e-4f75-efa6-08d773204b4e
x-ms-traffictypediagnostic: DB7PR04MB6009:|DB7PR04MB6009:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB600960D88EC56CF97869F2CEE6440@DB7PR04MB6009.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(396003)(346002)(39860400002)(189003)(199004)(13464003)(478600001)(4326008)(76176011)(76116006)(66946007)(7696005)(66476007)(66556008)(64756008)(66446008)(6506007)(14454004)(99286004)(14444005)(71200400001)(71190400001)(256004)(316002)(110136005)(54906003)(229853002)(6246003)(305945005)(9686003)(6436002)(5660300002)(7736002)(74316002)(2201001)(52536014)(55016002)(86362001)(2906002)(66066001)(186003)(33656002)(6116002)(3846002)(102836004)(25786009)(53546011)(8676002)(81156014)(81166006)(8936002)(26005)(446003)(11346002)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB6009;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PWSCB8el0mkdUAwZ3j14rVXPBIhq6KDZ3atTBO82dhS1BoK2UvBH5bUNYoB6Ctyqf+WtW2imAo6Vv03PqWqErGxfJJgw7lw2FtNLnzLBK6YeDcn1qrEtBG82fPMJWJVm4ou4q/GW064CDGEDrG4USGqLuVJ7fEeKSx0Wk6dIOpdItFvXn/FMa4EptKPme7k3kvLSMJTPnKfS0Wg/tAXdKu8c7aVGAg+Re9snZEm+xhpRskxQwzZrzPTUfn+f1diOZiHfx+nhxIocPxAchjCPYlhvDltURXJxi6FVxElLzpuqGy8RbD+fjNDs/sCJnrWfR4TqIn41MI2AKRC4KIOgjrl9Xl8lyciSEXYWB9K3Jw2Z/dx4OkKl4l2wYV8sPsYZ6z8S6SCLUxiJNkIuiruE+HslNAXtTjvD/BVP4GZfegPqc/pMDEKMNwKnLWqy3YxF
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73280cf5-3a0e-4f75-efa6-08d773204b4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 09:58:03.3677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lPSYW8gZAReuSCkf1jWJNTxgpRkI1f66/17Tm0P+/vwEltDcNHWDzGEi8qKv9/B0BCEHAkAkM6sH/NHY4Zl4aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB6009
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNlYW4gTnlla2phZXIgPHNl
YW5AZ2Vhbml4LmNvbT4NCj4gU2VudDogMjAxOeW5tDEx5pyIMjfml6UgMTc6NTINCj4gVG86IEpv
YWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBta2xAcGVuZ3V0cm9uaXguZGU7
DQo+IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGRsLWxpbnV4LWlteCA8bGludXgt
aW14QG54cC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFU
Q0ggVjIgMC80XSBjYW46IGZsZXhjYW46IGZpeGVzIGZvciBzdG9wIG1vZGUNCj4gDQo+IA0KPiAN
Cj4gT24gMjcvMTEvMjAxOSAxMC40OCwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+IE9uZSBtb3Jl
IHNob3VsZCBjb25maXJtIHdpdGggeW91LCB5b3UgaW5zZXJ0ZWQgYSBmbGV4Y2FuLmtvIGFmdGVy
IHN0b3ANCj4gPiBtb2RlIGFjdGl2YXRlZCB3aXRob3V0IGZpeCBwYXRjaCBmaXJzdGx5LCBhbmQg
dGhlbiBpbnNlcnRlZCBhDQo+ID4gZmxleGNhbi5rbyB3aXRoIGZpeCBwYXRjaC4gSWYgeWVzLCB0
aGlzIGNvdWxkIGNhdXNlIHVuYmFsYW5jZWQNCj4gcG1fcnVudGltZV9lbmFibGVkLiBUaGUgcmVh
c29uIGlzIHRoYXQgZmlyc3RseSBpbnNlcnRlZCB0aGUgZmxleGNhbi5rbyB3b3VsZA0KPiBlbmFi
bGUgZGV2aWNlIHJ1bnRpbWUgcG0sIGFuZCB0aGVuIHlvdSBpbnNlcnRlZCBmbGV4Y2FuLmtvIGVu
YWJsZSBkZXZpY2UNCj4gcnVudGltZSBwbSBhZ2Fpbi4NCj4gPg0KPiA+IENvdWxkIHlvdSBwbGVh
c2UgaW5zZXJ0IGZsZXhjYW4ua28gd2l0aCBmaXggcGF0Y2ggZGlyZWN0bHkgYWZ0ZXIgc3RvcCBt
b2RlDQo+IGFjdGl2YXRlZD8NCj4gPg0KPiBIaSwNCj4gDQo+IElmIEkgaW5zZXJ0IGZsZXhjYW4u
a28gd2l0aCBmaXggcGF0Y2ggZGlyZWN0bHkgYWZ0ZXIgc3RvcCBtb2RlIGFjdGl2YXRlZCwgdGhl
DQo+IHVuYmFsYW5jZWQgbXNnIGlzIG5vdCBzaG93bi4uLg0KPiBJIGd1ZXNzIHdlIGFyZSBnb29k
IHRoZW4gOikNCg0KR3JlYXQsIFRoYW5rcyBhIGxvdCENCg0KQ291bGQgeW91IGdpdmUgeW91ciBU
ZXN0LWJ5IHRhZyBmb3IgdGhpcyBwYXRjaCBzZXQ/IEFuZCB0aGVuIE1hcmMgY291bGQgcmV2aWV3
IHRoaXMgcGF0Y2ggc2V0Lg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gL1NlYW4N
Cg==

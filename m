Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1DCB18F6F4
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 15:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgCWObH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 10:31:07 -0400
Received: from mail-eopbgr80055.outbound.protection.outlook.com ([40.107.8.55]:10365
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725830AbgCWObH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 10:31:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NiJSX2C0g0gzduhVZRy8+Snxf+2fBJrdKpd0m1yBC4kJV0ljh4BLFG+WNqaMsXecMRSr4vFp3cw5NZA/WwbgayIwvOiHn6lwYwbs4QaWjEl8CD8zeFkNjq/BjsyoS8GKxJTQI3+cpHJ41U5/drUMwhsbeAHZe78X4/NF9rkRbzwsGk4c/Z7t8PhvcUsC2tOEfwdU/BcjEtkrX2mJ9JRo/UpMCZrk5z6Xziy9rSoT68e3ru4HKGurAbRRev552qZqlnoFRVoVZY34Kq6nfwh4q9TC76f8c5LwelV8LfFxWJgaDmoitPtTczEdDeDKpjOfM9dVpuLHCfx3jQTrzndoqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/jhxgM3SAa8DSF5D/M/NNKNtjfs/0XEoh5OHKTX/cw=;
 b=oTujLP8FDP/GpjGfzrw+w6rWxs9M1TEooqzABOVCQnO7ug+W7zSjhiJ1Xqi3NW4xP0ZYLuu+GaV0oPATKAZnp2IXSnWjPMq9zSLjn8WrQ+abeQ5mwPvIrCWN1u4S2dlW31+WRUO+JgkbcAs52SxnRpAjSk5x8wunEPmthNfx2ccXLLWG9QYlUQK6esGfECOxbkmBDT89o3HPBcv0wroXxa9uSGziNUZbP0RLePhz0gbicQ+eiVmuBkPPLAqft/ox3SR/SOSwKNbxHKI1qc4B15E8BVdieRgTB9AWR2o2jArahQcS6Fiy30f2wi+7eaj3XWV9OLWBjD++/n4NWw8Wog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/jhxgM3SAa8DSF5D/M/NNKNtjfs/0XEoh5OHKTX/cw=;
 b=GiISIai3VbgsFnl9SQwwI1D94JvPJn0KjrUZUp4ED1EFzZSunFiqCO7E/ewdCD05L+d8+9xOtyWdkEkVD/wEY2Ly8Lkj32Ni3/Q+VT7swXq1wN7QJmd6ZW5JnLbu5YroNO5qYjbZGCf+CE89QJK6JEgY32jNDMGNCPHMxQPNz0E=
Received: from AM0PR04MB7041.eurprd04.prod.outlook.com (10.186.130.77) by
 AM0PR04MB4371.eurprd04.prod.outlook.com (52.135.148.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Mon, 23 Mar 2020 14:31:03 +0000
Received: from AM0PR04MB7041.eurprd04.prod.outlook.com
 ([fe80::59c3:fa42:854b:aeb3]) by AM0PR04MB7041.eurprd04.prod.outlook.com
 ([fe80::59c3:fa42:854b:aeb3%6]) with mapi id 15.20.2835.021; Mon, 23 Mar 2020
 14:31:03 +0000
From:   Christian Herber <christian.herber@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Marek Vasut <marex@denx.de>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: RE: Re: [PATCH v4 1/4] dt-bindings: net: phy: Add support for NXP
 TJA11xx
Thread-Topic: Re: [PATCH v4 1/4] dt-bindings: net: phy: Add support for NXP
 TJA11xx
Thread-Index: AdYBHzfET3LoSQzERB2HqtRjW4y/+A==
Date:   Mon, 23 Mar 2020 14:31:03 +0000
Message-ID: <AM0PR04MB70413A974A2152D27CAADFAC86F00@AM0PR04MB7041.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=christian.herber@nxp.com; 
x-originating-ip: [77.8.198.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3f6670c7-2e1d-4a2a-3e4f-08d7cf36d113
x-ms-traffictypediagnostic: AM0PR04MB4371:
x-microsoft-antispam-prvs: <AM0PR04MB43719B3F038EC1C5697F3CE886F00@AM0PR04MB4371.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0351D213B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(376002)(366004)(39860400002)(199004)(8676002)(53546011)(81166006)(81156014)(6506007)(7416002)(7696005)(8936002)(186003)(26005)(86362001)(71200400001)(66946007)(66446008)(66476007)(66556008)(64756008)(316002)(54906003)(478600001)(76116006)(44832011)(110136005)(9686003)(55016002)(33656002)(5660300002)(2906002)(52536014)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4371;H:AM0PR04MB7041.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: geF3bi+WgFVbkHwYXFOff/O0+ZIMdWEK2DkJOJA23iOUDoa0+7MMBCeyPXxn1Qe1POiCtmVTdDLIKnA5GIIETilvh9tq5qgKUkuTiXI2sJ/uQpXQ5CtLGDd5BVvs032lbeL1l7YSsod+JjvWM58+kluZVL26pb1DahXjK+qsjGa8VnsJq0fI/uMjsoFqabldHBwzwVuiTOAaT86XSM/m2KBL2YFKl2feinC0gpwqQ5IddcYuX+Viq2LF57kdsYFRwsR1gMs/bY6MyCzkwuJ1LMMUGR848JSfXEvfzIGAEpmW0pqJ0yhd/wCQlHwjNf7iZMqvz3+XV2kY3dE75PWe3b7jJemf5E6alyJsQ3AF8DAcmZcBGiERoM1OvcymNPaZEd+VchzNGqnrEgZ+MBJE2IiINbtd375SVv0HQVFIPNgIQHjeUmwkbuBwDMEE01pX
x-ms-exchange-antispam-messagedata: csgqawmTwXPrbVo8Dbc7ZBuXFB4tt44QiYk010HMpBV2/RqLYQExcXhYoWfMhoz29dwsOzYfF1gl0El8BGEjDqDGHY5m85IzqaUKAzLFBv5p7/hLS+xzS+mkCXIDr7xOhMwBVZ+sr0qPM+MyItJgZg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f6670c7-2e1d-4a2a-3e4f-08d7cf36d113
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2020 14:31:03.8619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mc6pe6s7QInJ6J1CdUYHOboCr7DWGJgSXKzLB4iXxju5XRul9g/x6FDblV8tbuKBgWHZhcYkjpLZjB1haoTiqFrNGeIGQsRA99/lNUql6uQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4371
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pk9uIFN1biwgTWFyIDIyLCAyMDIwIGF0IDM6MDkgUE0gRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWlu
ZWxsaUBnbWFpbC5jb20+IHdyb3RlOg0KPj4NCj4+IE9uIDMvMjAvMjAyMCA0OjA1IFBNLCBSb2Ig
SGVycmluZyB3cm90ZToNCj4+ID4+Pj4gQmVjYXVzZSB0aGUgcHJpbWFyeSBQSFkwIGNhbiBiZSBh
dXRvZGV0ZWN0ZWQgYnkgdGhlIGJ1cyBzY2FuLg0KPj4gPj4+PiBCdXQgSSBoYXZlIG5vdGhpbmcg
YWdhaW5zdCB5b3VyIHN1Z2dlc3Rpb25zLiBQbGVhc2UsIHNvbWUgb25lIHNob3VsZCBzYXkgdGhl
DQo+PiA+Pj4+IGxhc3Qgd29yZCBoZXJlLCBob3cgZXhhY3RseSBpdCBzaG91bGQgYmUgaW1wbGVt
ZW50ZWQ/DQo+PiA+Pg0KPj4gPj4gSXQncyBub3QgZm9yIG1lIHRvIGRlY2lkZSwgSSB3YXMgaG9w
aW5nIHRoZSBEZXZpY2UgVHJlZSBtYWludGFpbmVycw0KPj4gPj4gY291bGQgY2hpbWUgaW4sIHlv
dXIgY3VycmVudCBhcHByb2FjaCB3b3VsZCBjZXJ0YWlubHkgd29yayBhbHRob3VnaCBpdA0KPj4g
Pj4gZmVlbHMgdmlzdWFsbHkgYXdrd2FyZC4NCj4+ID4NCj4+ID4gU29tZXRoaW5nIGxpa2UgdGhp
cyBpcyB3aGF0IEknZCBkbzoNCj4+ID4NCj4+ID4gZXRoZXJuZXQtcGh5QDQgew0KPj4gPiAgIGNv
bXBhdGlibGUgPSAibnhwLHRqYTExMDIiOw0KPj4gPiAgIHJlZyA9IDw0IDU+Ow0KPj4gPiB9Ow0K
Pj4NCj4+IEJ1dCB0aGUgcGFyZW50IChNRElPIGJ1cyBjb250cm9sbGVyKSBoYXMgI2FkZHJlc3Mt
Y2VsbHMgPSAxIGFuZA0KPj4gI3NpemUtY2VsbHMgPSAwLCBzbyBob3cgY2FuIHRoaXMgYmUgbWFk
ZSB0byB3b3JrIHdpdGhvdXQgY3JlYXRpbmcgdHdvDQo+PiBub2RlcyBvciBhIGZpcnN0IG5vZGUg
ZW5jYXBzdWxhdGluZyBhbm90aGVyIG9uZT8NCj4NCj5UaGF0IGlzIHRoZSBzaXplIG9mIHRoZSBh
ZGRyZXNzLCBub3QgaG93IG1hbnkgYWRkcmVzc2VzIHRoZXJlIGFyZS4gSWYNCj50aGUgZGV2aWNl
IGhhcyAyIGFkZHJlc3NlcywgdGhlbiAyIGFkZHJlc3MgZW50cmllcyBzZWVtcyBlbnRpcmVseQ0K
PmFwcHJvcHJpYXRlLg0KPg0KPlJvYg0KDQpZZXMsIGl0IGlzIG9uZSBkZXZpY2Ugd2l0aCB0d28g
YWRkcmVzcy4gVGhpcyBpcyBpZiB5b3UgY2FsbCB0aGUgZW50aXJlIElDIGEgZGV2aWNlLiBJZiB5
b3UgbG9vayBhdCBpdCBmcm9tIGEgUEhZIHBlcnNwZWN0aXZlLCBpdCBpcyB0d28gZGV2aWNlcyB3
aXRoIDEgYWRkcmVzcy4NCklmIHlvdSBqdXN0IGxvb2sgYXQgaXQgYXMgYSBzaW5nbGUgZGV2aWNl
LCBpdCBnZXRzIGRpZmZpY3VsdCB0byBhZGQgUEhZIHNwZWNpZmljIHByb3BlcnRpZXMgaW4gdGhl
IGZ1dHVyZSwgZS5nLiBtYXN0ZXIvc2xhdmUgc2VsZWN0aW9uLg0KSW4gbXkgb3BpbmlvbiBpdHMg
aW1wb3J0YW50IHRvIGhhdmUgc29tZSBraW5kIG9mIGNvbnRhaW5lciBmb3IgdGhlIGVudGlyZSBJ
QywgYnV0IGxpa2V3aXNlIGZvciB0aGUgaW5kaXZpZHVhbCBQSFlzLg0KDQpDaHJpc3RpYW4NCg==

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21FD3D4515
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 07:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhGXElC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 00:41:02 -0400
Received: from mail-eopbgr40055.outbound.protection.outlook.com ([40.107.4.55]:9605
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229730AbhGXElA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Jul 2021 00:41:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PeIeSCJ9XywmlKg91hlbGWzdmeYaUuYOBF+XyUQI3CTLsEjJAEMT3xhPfYDyK8MyJbXUlJOoR05ieThWV3vuIqBR/Z34P24f8cslJuRJA4Z/7EG/3ZnMG0OKhKTEDgt+2GTu45C1/K+SflZxj+hq7vK8Fed0m8eGdumk68xS0YgIsl/vkW/Mdj+ZFEECtUjJDXBo/xPIpybTP1QKp7OiUPM50HRMlMRGlDjGHtyK77J/74VWjcGcXvKLrRoJ2txVlnKClmdpNhc0Ck1A++dSL6N/+S0ETrlcXsZx+mo6UC7jVgxbudcIR6lsMCJaTB5+ZFnSDcaL3LQGFdnkxhY6Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QqFYlNpZOb+XLKlMsFnHfYd62q69VZ/bML8rMky/sKo=;
 b=OnYecB1LtxrblE/I2UPCv1aPKLC+o5UlmXf99pyADxdDpgBFJyhEJrK2RY1UIzWyjTcYMj6zcoWTd4MAsgUogcWzMgxHZuxqpoJWwFqV87a3dUoa4IfbzI7BNW45W1iHcOAFyjY5mFwkSp7YLsJMTQ0MiIjTff8yz3y9WOV/QmoE+XtFGKAHInBM9/FCVnntrOOEe4DzkDa8lsdSe1ZrlfBFcAQ5TEuzvXoB0zXdk8UKzjUpWakOKTWGOIezrHkj7Sr4SUrK0+OI3lR7aSQCW/LOvLnyfd/l6OuSLVcCj6vpcwo0DsgPHw3vdvoma7s0Sj94ycMsDwz8+DEK5ncdng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QqFYlNpZOb+XLKlMsFnHfYd62q69VZ/bML8rMky/sKo=;
 b=eX5ouH/BG7f64pGscwwrxrUmM5xoq2buVPH2ht7LZi/nXzKj4OWUPGc0BbNQmbq5kYDt0TWR923R6MY5+a1ipTQD7AVLh/IWuTITMup8/k/sXPkpmyVLHH9CjS+oscoN5SWCLWnnKERi4aZr2YYBJEZ7KMcQJWs96HVyJuImhI4=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4105.eurprd04.prod.outlook.com (2603:10a6:5:26::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Sat, 24 Jul
 2021 05:21:30 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4352.029; Sat, 24 Jul 2021
 05:21:30 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Shawn Guo <shawnguo@kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
Subject: RE: [PATCH net-next] ARM: dts: imx6qdl: Remove unnecessary mdio
 #address-cells/#size-cells
Thread-Topic: [PATCH net-next] ARM: dts: imx6qdl: Remove unnecessary mdio
 #address-cells/#size-cells
Thread-Index: AQHXf7Xtq1uHAh0lYUGGZOqY+Bf/k6tQiFeAgAAB9gCAAQqgoA==
Date:   Sat, 24 Jul 2021 05:21:29 +0000
Message-ID: <DB8PR04MB6795F1B7B273777BA55B81ABE6E69@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210723112835.31743-1-festevam@gmail.com>
 <20210723130851.6tfl4ijl7hkqzchm@skbuf>
 <CAOMZO5BRt6M=4WrZMWQjYeDcOXMSFhcfjZ95tdUkst5Jm=yB6A@mail.gmail.com>
In-Reply-To: <CAOMZO5BRt6M=4WrZMWQjYeDcOXMSFhcfjZ95tdUkst5Jm=yB6A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bfbe6d2b-ae4a-4073-719a-08d94e62e4b9
x-ms-traffictypediagnostic: DB7PR04MB4105:
x-microsoft-antispam-prvs: <DB7PR04MB4105F7934DC90A4EAB35EF7CE6E69@DB7PR04MB4105.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QGCSpNcdmwXnxz+vYbpiDHPVtfobuBjgm80LwrlSnjNis8z+C/UfFrlR4ZLeKFZk8BD+EYsPGbn/Sq/qRM5EX3qBH8BCUD7DdwAKG78CaI9wyrz/nNUwErtZGhrzH2wK8mEp4BX4yPOEfTsEhMyj9JxjGoiLSTXQp4vtWizrq8UmVPI+ZtVOKt2YIlLzEmvzfWaswH7/VdEdOPeDYPkxlsEF7qk/KEzDoFCMjxV7hnMRwEziStwAD9a1b8ygMC1OqVTtD3KNldQoVwxAswrmWPjDOGIaeE9YtX849Nkoa0rYPeadnT6deN+I/HpELYDUcvj8QL91/MepzH3ifGc40JFq4NiAd1Y6VKeXzHFCs0PTmiDPym34gS3m4AEvueG2lDe9g73ERQjEBhIHi9//4i7OEqoaGXrjjWE43YJMB5s2avzTp6hVYctGSwdmu0jKaHlZeHpeJz0E7P8KWFknVal0CgmCUr9pZgfGasRhgC54IYHHiPR8sFIDLYrQkG0tmpFqDspDd4/zLhzmLHGMuwypgV+7QMc3NXqyiAUQQcT9QdNX7l9b97ubQMep2IY0h3PvArqWo+2OmM//lafWtwR9d9PbhEdScbUbuSZZT95gT+ItlBYzpP1KCVmxcUVk+55TC6Z9k3muHuDho+OCJubm/HwQxNUa5xa4ehKsV6ZUEtVA07xN9rAddol4jYmNrG0sxtEsih9//qQnRksuEEK3CFofWU/bwRjb+F2iU4E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(136003)(366004)(346002)(186003)(6506007)(55016002)(33656002)(71200400001)(8676002)(8936002)(83380400001)(86362001)(26005)(76116006)(122000001)(2906002)(38100700002)(64756008)(66476007)(66556008)(66946007)(66446008)(4326008)(478600001)(52536014)(316002)(5660300002)(110136005)(54906003)(7696005)(53546011)(9686003)(32563001)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VWhiMnVFMGxrakxOYVhXMStucEpuWXZnVThOQSs4TXJYaFRwdGRzOWRXdG1B?=
 =?utf-8?B?UnRrV3pWZG9QdEFmZkprcitpaSsxWmR0ZWNFTmZtYXEwVnU4WmpTS2FaWkgv?=
 =?utf-8?B?clYvRVBreUNKYUlQNGdSeC9sZGQ5UnQrRy9pWVJ5UlJYRmw5NHorazYxTWdW?=
 =?utf-8?B?elhNZHhBcUYvaXFrRFZGcUZQYXVKc253M2RZQVkyc3RGWnVJSmNVNUpRMUNC?=
 =?utf-8?B?TmZHeDk5WWtxcW8zUjdWS2FRWVkxdjAyZCtQUzlHOXJmN3JnL2o1YjZLb2lI?=
 =?utf-8?B?ZXk1dVVUUk8rdEc3NDlVN3B4WXZsOU5HaVFVWDMxRG12cXYrTG1hMEIrakhw?=
 =?utf-8?B?ZnN2S2J1UE9VcXlLVUtsWHdaTjJHS3luTVVZdmxWeGdsTDlQM3hJMFdFSUd1?=
 =?utf-8?B?bGVaMEM3SUlWTm1FSUdBbUorTzE3OHJzdjQwenlMd1ppRVh4bjZxTjArcHNz?=
 =?utf-8?B?L2E2QXc5cjVZYkFwU3A4aGZjcVEvZzJuQjB0Tllnc05OdStMSUpuRjdnamxD?=
 =?utf-8?B?WWZmTDEyZjN0S1o1ait4UUViT3ZrUXBvRDQxaTdsZUJ2Yis3QktuRlJNT2ZT?=
 =?utf-8?B?SnZVTE9OUnJXS1k3NFRyMEZDdHpkaDhiR0pTOGFPV2l1SE5ubjVLVTZxYU0y?=
 =?utf-8?B?encvSDVZQzQ4NW55U2dCeGdmTnJTd2lXQ0JlYUJHRzF5TEdlUktLRm9TMWQ2?=
 =?utf-8?B?SVVSSDNMN29KbnlsSE01cTNKNlphUWpid0FEK21EZHpHQlhmZXFSK2tYeGN4?=
 =?utf-8?B?VmJ3dm83ak5hRzJXQ2E1UTVwNVZVOTB3U2g0VVpVT1g1WHhjSXRPVlcrcTRK?=
 =?utf-8?B?Mjd0S05JTUxSOGxSZUw5TWxLam15RE1JM0xINkFRYWVSZzIxWUZxQmIzZEIz?=
 =?utf-8?B?YWdsb2M2L3lGak9tTC8vN1dHSUY3NXU1eUt5WC8xTnpIa0N4QzFINHZUeFpw?=
 =?utf-8?B?Z1NmbExLQmhubTZXVXE0UWF6UW00U3M2T002cGJ1bXlaUkFkQlZ6RC9yZ0NY?=
 =?utf-8?B?N3NxK2ljNkxHVDNLWlRYN0h1a21KampGclBOSXlnTTZwbU4vbHl1NVE2WUNk?=
 =?utf-8?B?RFFIaTR0ak5ZYi90UGlzS3NGd0MzYmh0WFMwWnpHMXRzcTlXdzdaSGpqemN5?=
 =?utf-8?B?bjBYM3llMlIyOFNxRXhTcFUxcVdFbG50VGt4QXVDWFVTRFBEV2RiaCtmWUxL?=
 =?utf-8?B?WWgvdFhoNDJqYmswVVZUaTZmY2ZNZkJTeHh1SEVUV0dsbjZHNnk1allLc1VD?=
 =?utf-8?B?b2RhWi9XODhYbzJhWjFRQmRIODFSM1BTRXZxWE4rK3UvMWxRTnJkU2JkbUVJ?=
 =?utf-8?B?L2t5c0hDQzFIRUR1YldaOUNGSnRXNEU3eUVPWTZUeEwwSFRONitDUmJ0UmZH?=
 =?utf-8?B?dmowZGFrYUlPVHZRYzR0MzZydDQzTzhxZTB4RnJkQmgrWVBzejFtSXRXUWNm?=
 =?utf-8?B?eTRKRzROODNVcHI1NENheVNNNlBOb3dGRktqVkdHdHh4NkdUREI3ajBWSzRh?=
 =?utf-8?B?bXpjNUpxL2NpSERHaXNTV29jaXdHUUxWQjNpTkw0MWlVRGJ0aXBad1Y4TlNy?=
 =?utf-8?B?dXFLMXhvdHdraHBNbC8vczJWak9yYm1YVEtiMEhRZkx5bDhNZHNpU2pIaDFM?=
 =?utf-8?B?dklFZWdRb3poMHJ3NEZldVRWaGpMZFpIWDIvR29neGpqVklTZjlNNmhWdmNr?=
 =?utf-8?B?NFlvMHZnWXZkclIzdFlHbUxQc1NtdFRsMU9ta3dHb1l4dFk3bDF6ZUV2cUp5?=
 =?utf-8?Q?IEmpej23JcDm+Ot1hQ=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfbe6d2b-ae4a-4073-719a-08d94e62e4b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2021 05:21:29.9790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gShkXU9do0vSa5oAsO1tZruK01I327Uph5nM8IykiaBVf+BWjRpNUV58bq27xIWaksctMgPIxU7zLnAv91X5uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4105
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBGYWJpbywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBGYWJp
byBFc3RldmFtIDxmZXN0ZXZhbUBnbWFpbC5jb20+DQo+IFNlbnQ6IDIwMjHlubQ35pyIMjPml6Ug
MjE6MTYNCj4gVG86IFZsYWRpbWlyIE9sdGVhbiA8b2x0ZWFudkBnbWFpbC5jb20+DQo+IENjOiBE
YXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBTaGF3biBHdW8NCj4gPHNoYXdu
Z3VvQGtlcm5lbC5vcmc+OyBtb2RlcmF0ZWQgbGlzdDpBUk0vRlJFRVNDQUxFIElNWCAvIE1YQyBB
Uk0NCj4gQVJDSElURUNUVVJFIDxsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc+
OyBKb2FraW0gWmhhbmcNCj4gPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsgUm9iIEhlcnJpbmcg
PHJvYmgrZHRAa2VybmVsLm9yZz47IG5ldGRldg0KPiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47
IG9wZW4gbGlzdDpPUEVOIEZJUk1XQVJFIEFORCBGTEFUVEVORUQNCj4gREVWSUNFIFRSRUUgQklO
RElOR1MgPGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogW1BBVENI
IG5ldC1uZXh0XSBBUk06IGR0czogaW14NnFkbDogUmVtb3ZlIHVubmVjZXNzYXJ5IG1kaW8NCj4g
I2FkZHJlc3MtY2VsbHMvI3NpemUtY2VsbHMNCj4gDQo+IEhpIFZsYWRpbXIsDQo+IA0KPiBPbiBG
cmksIEp1bCAyMywgMjAyMSBhdCAxMDowOCBBTSBWbGFkaW1pciBPbHRlYW4gPG9sdGVhbnZAZ21h
aWwuY29tPiB3cm90ZToNCj4gDQo+ID4gQXJlIHlvdSBhY3R1YWxseSBzdXJlIHRoaXMgaXMgdGhl
IGNvcnJlY3QgZml4PyBJZiBJIGxvb2sgYXQgbWRpby55YW1sLA0KPiA+IEkgdGhpbmsgaXQgaXMg
cHJldHR5IGNsZWFyIHRoYXQgdGhlICJldGhlcm5ldC1waHkiIHN1Ym5vZGUgb2YgdGhlIE1ESU8N
Cj4gPiBjb250cm9sbGVyIG11c3QgaGF2ZSBhbiAiQFswLTlhLWZdKyQiIHBhdHRlcm4sIGFuZCBh
ICJyZWciIHByb3BlcnR5Lg0KPiA+IElmIGl0IGRpZCwgdGhlbiBpdCB3b3VsZG4ndCB3YXJuIGFi
b3V0ICNhZGRyZXNzLWNlbGxzLg0KPiANCj4gVGhhbmtzIGZvciByZXZpZXdpbmcgaXQuDQo+IA0K
PiBBZnRlciBkb3VibGUtY2hlY2tpbmcgSSByZWFsaXplIHRoYXQgdGhlIGNvcnJlY3QgZml4IHdv
dWxkIGJlIHRvIHBhc3MgdGhlIHBoeQ0KPiBhZGRyZXNzLCBsaWtlOg0KPiANCj4gcGh5OiBldGhl
cm5ldC1waHlAMSB7DQo+IHJlZyA9IDwxPjsNCj4gDQo+IFNpbmNlIHRoZSBFdGhlcm5ldCBQSFkg
YWRkcmVzcyBpcyBkZXNpZ24gZGVwZW5kYW50LCBJIGNhbiBub3QgbWFrZSB0aGUgZml4DQo+IG15
c2VsZi4NCj4gDQo+IEkgd2lsbCB0cnkgdG8gcGluZyB0aGUgYm9hcmQgbWFpbnRhaW5lcnMgZm9y
IHBhc3NpbmcgdGhlIGNvcnJlY3QgcGh5IGFkZHJlc3MuDQoNClRoYW5rcy4NCg0KSSBwcmVwYXJl
IHRoaXMgcGF0Y2ggdG8gZml4IGR0YnNfY2hlY2sgd2hlbiBjb252ZXJ0IGZlYyBiaW5kaW5nIGlu
dG8gc2NoZW1hLg0KSSByZWFsaXplZCB0aGF0IHdlIG5lZWQgYSAicmVnIiB1bmRlciBwaHkgZGV2
aWNlIG5vZGUsIGJ1dCBJIGFsc28gZG9uJ3Qga25vdyBob3cgdG8gYWRkIGl0IHNpbmNlDQp0aGUg
cGh5IGlzIG9idmlvdXNseSBub3Qgb24gYm9hcmQuIEFuZCBJIGNoZWNrIHRoZSBwaHkgY29kZSwg
aXQgc3VwcG9ydHMgYXV0byBzY2FuIGZvciBQSFlzIHdpdGggZW1wdHkNCiJyZWciIHByb3BlcnR5
Lg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gVGhhbmtzDQo=

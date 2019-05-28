Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3315E2CD48
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 19:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfE1RLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 13:11:51 -0400
Received: from mail-eopbgr60066.outbound.protection.outlook.com ([40.107.6.66]:35975
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726845AbfE1RLv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 13:11:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q9gaJ7YQsbJeInL9gPI0CfV4oPMgZk+CX0uBSzH2Da0=;
 b=ckrkoBWJgoQMPQFTsbX389BmDjztpKaNAnNmxtPDOb9mxKIQLgSZXh5L2OsmwvVn08oE0pVanM03KCOHLMgFV5ZCPffotU/a1ngp3k2MMWuYIvbLaG6sb2wBV1ig0z4x24fVsqq8/kJNmlFBVhLPHfuDdDLv3Jd6r5si7u6q2lQ=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3405.eurprd04.prod.outlook.com (52.134.1.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Tue, 28 May 2019 17:11:37 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053%8]) with mapi id 15.20.1922.019; Tue, 28 May 2019
 17:11:37 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 07/11] net: phylink: Add PHYLINK_DEV operation type
Thread-Topic: [PATCH 07/11] net: phylink: Add PHYLINK_DEV operation type
Thread-Index: AQHVFNJYuRihsAfx/Uiz7daXejWMlaZ/yQGAgAD8C1A=
Date:   Tue, 28 May 2019 17:11:37 +0000
Message-ID: <VI1PR0402MB280021214C0A9FEF4F63AD0AE01E0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
 <1558992127-26008-8-git-send-email-ioana.ciornei@nxp.com>
 <1f35604c-6047-082e-814a-72d8739fff12@gmail.com>
In-Reply-To: <1f35604c-6047-082e-814a-72d8739fff12@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6443256d-048f-4efd-7af4-08d6e38f8b33
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0402MB3405;
x-ms-traffictypediagnostic: VI1PR0402MB3405:
x-microsoft-antispam-prvs: <VI1PR0402MB3405BA665C3A1A043D82D05EE01E0@VI1PR0402MB3405.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(396003)(136003)(346002)(39860400002)(189003)(199004)(8676002)(6506007)(33656002)(14454004)(186003)(4326008)(81166006)(53546011)(81156014)(66446008)(8936002)(64756008)(66476007)(256004)(66946007)(76176011)(7696005)(305945005)(74316002)(7736002)(99286004)(6246003)(5024004)(76116006)(478600001)(73956011)(53936002)(71200400001)(71190400001)(26005)(52536014)(446003)(11346002)(476003)(6436002)(5660300002)(6116002)(316002)(68736007)(44832011)(9686003)(66556008)(110136005)(55016002)(102836004)(229853002)(2201001)(2501003)(86362001)(2906002)(66066001)(486006)(25786009)(7416002)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3405;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CROLLnJ4eoANh6/e0WwtS4U2K1fYUj1AwKwPfIfJtLbW6lsiuBl9FDs6OM8WLKTm35R3Js24/uDwjZ/Zt8R9TWnIqRa/WctLm+fZsic44Hum6hHAYivoIQ9JIz5Sp+5LVqYVqjiLsafYIhlPXO1gi37+7vy7Y/CH2NJYim77MPpQxO2PhRj0C9k9vpqa7uhEGrfsQx0TGpfkseFkg2QwZySXT5k80D3QqhebZiZkp9tvA3Mo2IreuWQcEaOX7lWx26mpzMAJ17Oo3CYrJD+0Zihvi56K9r9+VfP6eqB5u4Tlr1b+7hYRBakcRnzjILGKHPOpHAU7IE0frhEoVjQl3Qz6xg2U1nDyjBLlKDIjPC6TgjpxcnkgIDMUYH7vyU6GCVwZn+HkVDE63aeU7THgIjL9fg4jauGrsPIJoimG+Hg=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6443256d-048f-4efd-7af4-08d6e38f8b33
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 17:11:37.3588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioana.ciornei@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3405
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBSZTogW1BBVENIIDA3LzExXSBuZXQ6IHBoeWxpbms6IEFkZCBQSFlMSU5LX0RF
ViBvcGVyYXRpb24gdHlwZQ0KPiANCj4gDQo+IA0KPiBPbiA1LzI3LzIwMTkgMjoyMiBQTSwgSW9h
bmEgQ2lvcm5laSB3cm90ZToNCj4gPiBJbiB0aGUgUEhZTElOS19ERVYgb3BlcmF0aW9uIHR5cGUs
IHRoZSBQSFlMSU5LIGluZnJhc3RydWN0dXJlIGNhbiB3b3JrDQo+ID4gd2l0aG91dCBhbiBhdHRh
Y2hlZCBuZXRfZGV2aWNlLiBGb3IgcHJpbnRpbmcgdXNlY2FzZXMsIGluc3RlYWQsIGENCj4gPiBz
dHJ1Y3QgZGV2aWNlICogc2hvdWxkIGJlIHBhc3NlZCB0byBQSFlMSU5LIHVzaW5nIHRoZSBwaHls
aW5rX2NvbmZpZw0KPiBzdHJ1Y3R1cmUuDQo+ID4NCj4gPiBBbHNvLCBuZXRpZl9jYXJyaWVyXyog
Y2FsbHMgYXIgZ3VhcmRlZCBieSB0aGUgcHJlc2VuY2Ugb2YgYSB2YWxpZA0KPiA+IG5ldF9kZXZp
Y2UuIFdoZW4gdXNpbmcgdGhlIFBIWUxJTktfREVWIG9wZXJhdGlvbiB0eXBlLCB3ZSBjYW5ub3Qg
Y2hlY2sNCj4gPiBsaW5rIHN0YXR1cyB1c2luZyB0aGUgbmV0aWZfY2Fycmllcl9vaygpIEFQSSBz
byBpbnN0ZWFkLCBrZWVwIGFuDQo+ID4gaW50ZXJuYWwgc3RhdGUgb2YgdGhlIE1BQyBhbmQgY2Fs
bCBtYWNfbGlua197ZG93bix1cH0gb25seSB3aGVuIHRoZQ0KPiA+IGxpbmsgY2hhbmdlZC4NCj4g
Pg0KPiA+IFNpZ25lZC1vZmYtYnk6IElvYW5hIENpb3JuZWkgPGlvYW5hLmNpb3JuZWlAbnhwLmNv
bT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBWbGFkaW1pciBPbHRlYW4gPG9sdGVhbnZAZ21haWwuY29t
Pg0KPiANCj4gU2hvdWxkIG5vdCB0aGlzIHBhdGNoIGJlIHJlLW9yZGVyZWQgdG8gYmUgYWZ0ZXIg
cGF0Y2ggIzg/IE90aGVyIHRoYW4gdGhhdDoNCj4gDQoNCk5vdCBuZWNlc3NhcmlseS4NCkV2ZW4g
d2l0aG91dCBwYXRjaCAjOCAoIm5ldDogcGh5bGluazogQWRkIHBoeWxpbmtfe3ByaW50ayxlcnIs
d2FybixpbmZvLGRiZ30gbWFjcm9zIikgZXZlcnl0aGluZyB3aWxsIGZ1bmN0aW9uIHByb3Blcmx5
IHdpdGggdGhlIG1lbnRpb24gdGhhdCBpbiBjYXNlIG9mIFBIWUxJTktfREVWIGEgTlVMTCBuZXRf
ZGV2aWNlIHdpbGwgZ2V0IHByaW50ZWQuDQoNCkkgY2hvc2UgdG8gYWRkIHRoZSBwaHlsaW5rX3By
aW50ayBhZnRlciB0aGlzIHBhdGNoIGJlY2F1c2Ugbm93IHdlIGhhdmUgdGhlIHdob2xlIHBpY3R1
cmUuDQoNCi0tDQpJb2FuYQ0KDQo+IFJldmlld2VkLWJ5OiBGbG9yaWFuIEZhaW5lbGxpIDxmLmZh
aW5lbGxpQGdtYWlsLmNvbT4NCj4gLS0NCj4gRmxvcmlhbg0K

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B2D27A9A1
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 10:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgI1IgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 04:36:07 -0400
Received: from mail-eopbgr60052.outbound.protection.outlook.com ([40.107.6.52]:19595
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726518AbgI1IgH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 04:36:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gqFLFZaY3DxpX0GNxZjRkEot5LXlB85KBU+uS2cUwxIWnLOWMD+LcS8EqggskzFrCs4mqyDJxIeD1vBEv744UEl72ZcLkRwDjShbM4bt4Lo8WTqvUy81FW2AL4oTpmXnWuy2bFciwaq0accX6NNa96VAYZRf0OEUgdpvbjYURbrT+Jh5OaL5dB2NN4aLGooGGLQliZI8qaB38BuFHLU13lFefLDMESKb80pQPcaIl5ePnAG3KMrll9IMvOi1cR/8KSrgqX7OfMXi/H1y5MSekqbdpXUW9nMGD9+9IeY0PdIKtgXNz/mc5VJ3g8xP+oIvILtnF4AsKKejF75p6aiXxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MB2WBrdDP4R9nq6pKUJ4Mhz3txXCX2UbqrNjOKunlW0=;
 b=HGKw5VhCRNVwaZE3xeq3xXRsW28at4+GeEtPv9xcSKs/aNYAly94HUvob6ZAKHm8YhDwdXGMXfpJeAWHPieyszodxMlzmIcWkr2lwWCt4o2R2mpSnF9qKAHMYmzaUsUsz1W0vzycTTEpZ2dbfRsxjuOz5GLeyHK8W65IfzdZu+s+PetnDjXuKzQ7r35S/QpI6kvuOWytLEQrUhP+5zlHNIoVPT6Mw/DV+ZJA5U1slGe+xj2YwxxNQaoaDYL6akuIjDhNFpGqnNRy98Pv0KoRxV/B5OhH5JmHHCsRqG2NQbiC93cgpIWnzvoefAt96UXda8hZO4M60LeyDFLb9seiaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MB2WBrdDP4R9nq6pKUJ4Mhz3txXCX2UbqrNjOKunlW0=;
 b=j47SmKYvRCLRiXfxTZYlNcVtQSzs/xj5qacECpV0v9Cak/nEY0/GgYkfBHeG5HIQaWj3aAyhw5pLk6FR4mcAe1C2Pmp+wGwlddcnIFXlK4cY/Kz6CwU6JL1Mg0OxxTI9qBg00V3LX5W/Lj3c28o3/FP4rmG3rv36BcM6zuZ4mrQ=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Mon, 28 Sep
 2020 08:36:03 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.029; Mon, 28 Sep 2020
 08:36:03 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH linux-can-next/flexcan 1/4] can: flexcan: initialize all
 flexcan memory for ECC function
Thread-Topic: [PATCH linux-can-next/flexcan 1/4] can: flexcan: initialize all
 flexcan memory for ECC function
Thread-Index: AQHWkwrxc33Q4pOyMEiSJX13xMzIVal49QgAgAMfcACAANYAAIAAZbnggABUGYCAAA5kEIAAB7wAgAADNUA=
Date:   Mon, 28 Sep 2020 08:36:03 +0000
Message-ID: <DB8PR04MB6795064F932CF60033514367E6350@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20200925151028.11004-1-qiangqing.zhang@nxp.com>
 <20200925151028.11004-2-qiangqing.zhang@nxp.com>
 <f98dcb18-19f9-9721-a191-481983158daa@pengutronix.de>
 <DB8PR04MB6795C88B839FE5083283E157E6340@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <4490a094-0b7d-4361-2c0a-906b2cff6020@pengutronix.de>
 <DB8PR04MB679574C44EC1B2D401C9B5D1E6350@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <3910f513-1a47-5128-1a78-f412a0904911@pengutronix.de>
 <DB8PR04MB679575A5E8EE9C7534A446BAE6350@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <e9542cdc-cce8-8ec5-8229-5a9992352539@pengutronix.de>
In-Reply-To: <e9542cdc-cce8-8ec5-8229-5a9992352539@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 96f45b46-cf9a-4ec9-82b5-08d86389895c
x-ms-traffictypediagnostic: DB8PR04MB6795:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB67957C3E6988D3D68CAEBFE9E6350@DB8PR04MB6795.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dh5HSYW5x8SKjFA4612Kpiqje9hGR963aUV3xmh5Qko6rtH9oTvU/RsBvIEKgmgGfGKy10QBIrsKDPbbBcTG7XL5GkZ/SaZmadcL0sLjkluZjqOlOf6BETA6Ok7IFWeKwJtv5V9W8tkT2gZVXYH5w+FomzBAze6Kh/4EbQuFiYj5eqf0ApX+EQ24e0dg/U8Z3SEoeFAstUI55GEBL6DbHmtI+pJURh8mLRCjtoLnGLbGv44vbozCmCrnhfnzNl5a9tqcfuXcxwWMI6VM+bemicPmuvr/LbwIi4lzXrE9592heYwfRRi5QKcbcvdeFIZ6YsVLAl+9AvdZ6qisR+t3NRNNR6aRUOp+USjIXuce1ncR/iCetSocWBMTxMEaa3+BQcFQz8kB2f1xCnGpgHULkSQKLUljwT0RZhBnB+kfRlgB73PDjxhz7R80F65QvRWjumE2uS58kCxFC2csCcBibA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(136003)(39860400002)(376002)(66946007)(83380400001)(54906003)(33656002)(478600001)(6506007)(86362001)(7696005)(53546011)(26005)(76116006)(66476007)(66556008)(186003)(5660300002)(316002)(55016002)(52536014)(8936002)(4326008)(110136005)(2906002)(9686003)(6636002)(83080400001)(66446008)(64756008)(71200400001)(966005)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: KOBZl+32X9v1fuvZgBtLkSvcV8RW6whnmTCqzXoRrlB36gCp+eKesHbe26jcVsOElT/kCGP1i+zOxv8Iy6yU3RAhdmrNqiXVVx/W3oId+IWaos0kcKZJZzwUp2V98Lao6oohsDlff90v/RxTPQaJ09f0yGiM6HDKv1W0/uOiLX8gDdEAOTQO5W+y8Stcr2nLoVMAMhe53LVYnTYlbJEjc17kV+zKATkPisPk3wnd02QFP44GDoFSLdJcCjoP88qV+1L2AZJ5Cul8BhJd4pGlw/mNqFWBDiyUghT3RPFRFn5Oy8bQerZJMCtsB9dHdNE68TRre0aPUnMbtv8VMVLx5hSfmuj1yBP7rZXiZ7ZhD4di85CRFUId4F20HYcrJFp39TvU4wm1DVM0U42PcdD07WU/xMggC88IxvnKcomPlghcjM55maRgzDKOCbXG056cq7Cwy+SRz0867Iz0BminmJPSW9A3tSaONVHRMrgUFmncNvAMhGABg9MRB/Xaj+7lUd/C1f7IXmLGil5R4jmnvTvkN/Ge9bNLJQDUWUU5X1Y1GkHfuhi4ff79M5gV+jqjU5v7U5C0b7BzO4rTPte8GmQGhBgKp25Tcarejt4pWgzgKlKjxYiVLxtKQfwlfixU3Wp5ZECme9+5ukWfZidqcA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96f45b46-cf9a-4ec9-82b5-08d86389895c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2020 08:36:03.8160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xF4DVdH6Nt/JliJgTM2d90RxVOj2sLPNG+qt7rn7irw1Qxj8dIPJYeTv1kb00PjZ2r/Eu+ODDkPBotBBag+gAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6795
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDlubQ55pyIMjjml6UgMTY6MjENCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBsaW51eC1jYW5Admdl
ci5rZXJuZWwub3JnOw0KPiBQYW5rYWogQmFuc2FsIDxwYW5rYWouYmFuc2FsQG54cC5jb20+DQo+
IENjOiBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVs
Lm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIGxpbnV4LWNhbi1uZXh0L2ZsZXhjYW4gMS80XSBj
YW46IGZsZXhjYW46IGluaXRpYWxpemUgYWxsIGZsZXhjYW4NCj4gbWVtb3J5IGZvciBFQ0MgZnVu
Y3Rpb24NCj4gDQo+IE9uIDkvMjgvMjAgOTo1OCBBTSwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+
PiBDYW4gc29tZW9uZSBjaGVjayB0aGUgdmY2MTAsIHRvbz8NCj4gPg0KPiA+IEkgY2hlY2sgdGhl
IFZGNjEwIFJNIGp1c3Qgbm93LCBpbmRlZWQgaXQgaGFzIEVDQyBmZWF0dXJlLCB0aGVyZSBpcyBh
bHNvIGENCj4gTk9URSBpbiAiMTIuMS40LjEzIERldGVjdGlvbiBhbmQgQ29ycmVjdGlvbiBvZiBN
ZW1vcnkgRXJyb3JzIiBzZWN0aW9uOg0KPiA+DQo+ID4gQWxsIEZsZXhDQU4gbWVtb3J5IG11c3Qg
YmUgaW5pdGlhbGl6ZWQgYmVmb3JlIHN0YXJ0aW5nIGl0cyBvcGVyYXRpb24NCj4gPiBpbiBvcmRl
ciB0byBoYXZlIHRoZSBwYXJpdHkgYml0cyBpbiBtZW1vcnkgcHJvcGVybHkgdXBkYXRlZC4gVGhl
DQo+ID4gV1JNRlJaIGJpdCBpbiBDb250cm9sIDIgUmVnaXN0ZXIgKENUUkwyKSBncmFudHMgd3Jp
dGUgYWNjZXNzIHRvIGFsbA0KPiA+IG1lbW9yeSBwb3NpdGlvbnMgZnJvbSAweDA4MCB0byAweEFE
Ri4NCj4gDQo+IFNvdW5kcyBnb29kLg0KDQoNCkNvdWxkIEkgc2VuZCBvdXQgYSBWMyB0byByZXZp
ZXcgZmlyc3RseSwgdGhlbiB3YWl0IFBhbmthaiBoYXZlIHRpbWUgdG8gZG8gdGhlIHRlc3Q/DQoN
CkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiBNYXJjDQo+IA0KPiAtLQ0KPiBQZW5ndXRy
b25peCBlLksuICAgICAgICAgICAgICAgICB8IE1hcmMgS2xlaW5lLUJ1ZGRlICAgICAgICAgICB8
DQo+IEVtYmVkZGVkIExpbnV4ICAgICAgICAgICAgICAgICAgIHwgaHR0cHM6Ly93d3cucGVuZ3V0
cm9uaXguZGUgIHwNCj4gVmVydHJldHVuZyBXZXN0L0RvcnRtdW5kICAgICAgICAgfCBQaG9uZTog
KzQ5LTIzMS0yODI2LTkyNCAgICAgfA0KPiBBbXRzZ2VyaWNodCBIaWxkZXNoZWltLCBIUkEgMjY4
NiB8IEZheDogICArNDktNTEyMS0yMDY5MTctNTU1NSB8DQoNCg==

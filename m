Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1414E11F
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 13:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbfD2LPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 07:15:41 -0400
Received: from mail-eopbgr140075.outbound.protection.outlook.com ([40.107.14.75]:59011
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727710AbfD2LPl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 07:15:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VVuXJASlGFXMJe6s4JEVlRXfk8WZNeqRh+mO/C4BqpM=;
 b=BgulA371QDTvoNVKhzFgVsyuOK1Pu53ZWIJgm15owdO1gnQkXCl9qF3cd1iK1I3Zc3AEv/LbGsXdVwZxBr0dzjkmn9WY+j0sRx/5DImyvekiXXXrLG7ICIJT9jjZSLraapn1ItW57hqTvZI3E90h4bX9mGP5RMLuNTUeBdP+V7k=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.138.152) by
 DB7PR04MB4604.eurprd04.prod.outlook.com (52.135.138.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.12; Mon, 29 Apr 2019 11:15:36 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::dcff:11e1:ab70:bb81]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::dcff:11e1:ab70:bb81%4]) with mapi id 15.20.1835.018; Mon, 29 Apr 2019
 11:15:36 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Aisheng Dong <aisheng.dong@nxp.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] can: flexcan: change .tseg1_min value to 2 in bittiming
 const
Thread-Topic: [PATCH] can: flexcan: change .tseg1_min value to 2 in bittiming
 const
Thread-Index: AQHU/l/eGgL8EWD7kUani7YEBLcwp6ZS8GyQgAALvbA=
Date:   Mon, 29 Apr 2019 11:15:36 +0000
Message-ID: <DB7PR04MB4618C9379A74235BF71025E9E6390@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20190429074551.25754-1-qiangqing.zhang@nxp.com>
 <AM0PR04MB42119D481BD7A6494E4F364F80390@AM0PR04MB4211.eurprd04.prod.outlook.com>
In-Reply-To: <AM0PR04MB42119D481BD7A6494E4F364F80390@AM0PR04MB4211.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36898272-1ba5-4ce9-4445-08d6cc94014c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4604;
x-ms-traffictypediagnostic: DB7PR04MB4604:
x-microsoft-antispam-prvs: <DB7PR04MB460409D3424DDEC09E431C2DE6390@DB7PR04MB4604.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(39860400002)(366004)(346002)(376002)(189003)(199004)(13464003)(14444005)(9686003)(14454004)(8936002)(53936002)(55016002)(81156014)(81166006)(229853002)(66066001)(8676002)(6436002)(86362001)(4326008)(2201001)(71200400001)(71190400001)(478600001)(25786009)(5660300002)(256004)(66556008)(97736004)(186003)(53546011)(26005)(66446008)(66946007)(305945005)(486006)(73956011)(476003)(11346002)(52536014)(446003)(64756008)(66476007)(102836004)(76116006)(2906002)(7736002)(54906003)(110136005)(2501003)(3846002)(33656002)(6246003)(6116002)(7696005)(316002)(76176011)(6506007)(74316002)(99286004)(68736007)(142923001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4604;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PfA3wEbc1bkGM8no84KML+JEQMUGyZtvtwEbS2QINqkKLHTiSsW40DORJJsNLn/eKpyVbyfceHz5KpulkKIpt2hx5YfeuWIEEQgsPmAzW947ftoI6oNV+luhpXypwUxSFz2wrmkn1hTU4TDqsBhrTjVTUlA4pjd//sigHf/EcTzfKzslUzPdCVVS7pYIAk8Aif/T44tywMI1UBGSARIUmrTYtIif+mcue6lS/SvsCDjrNmGFpEUTNtNJZ6O6qrYOjady4laWkoc+L7Qs6llhlmzb9JotTXsmnwvXgfvIAcaEWIsgpezjhPZgjIhOlKc1swQ87/dcDtfrhHXLkvM+8JmAVsMsxjbWgNlPX8zjAWgG6lanwMJ69u6c0tvgUJFNq/iY9rLU7DrMInxmHi0ZwFd5gS5qrhlvBzNpsQVu7aQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36898272-1ba5-4ce9-4445-08d6cc94014c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 11:15:36.7434
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4604
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFpc2hlbmcgRG9uZw0KPiBT
ZW50OiAyMDE55bm0NOaciDI55pelIDE4OjM2DQo+IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWlu
Zy56aGFuZ0BueHAuY29tPjsgd2dAZ3JhbmRlZ2dlci5jb207DQo+IG1rbEBwZW5ndXRyb25peC5k
ZTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldA0KPiBDYzogZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhw
LmNvbT47IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmc7DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmcNCj4gU3ViamVjdDogUkU6IFtQQVRDSF0gY2FuOiBmbGV4Y2FuOiBjaGFuZ2UgLnRzZWcxX21p
biB2YWx1ZSB0byAyIGluIGJpdHRpbWluZw0KPiBjb25zdA0KPiANCj4gPiBGcm9tOiBKb2FraW0g
WmhhbmcNCj4gPiBTZW50OiBNb25kYXksIEFwcmlsIDI5LCAyMDE5IDM6NDggUE0NCj4gPg0KPiA+
IFRpbWUgU2VnbWVudDEodHNlZzEpIGlzIGNvbXBvc2VkIG9mIFByb3BhZ2F0ZSBTZWdtZW50KHBy
b3Bfc2VnKSBhbmQNCj4gPiBQaGFzZSBTZWdtZW5nMShwaGFzZV9zZWcxKS4gVGhlIHJhbmdlIG9m
IFRpbWUgU2VnbWVudDEocGx1cyAyKSBpcyAyIHVwDQo+ID4gdG8NCj4gPiAxNiBhY2NvcmRpbmcg
dG8gbGF0ZXN0IHJlZmVyZW5jZSBtYW51YWwuIFRoYXQgbWVhbnMgdGhlIG1pbmltdW0gdmFsdWUN
Cj4gPiBvZiBQUk9QU0VHIGFuZCBQU0VHMSBiaXQgZmllbGQgaXMgMC4gU28gY2hhbmdlIC50c2Vn
MSBtaW4gdmFsdWUgdG8gMi4NCj4gPg0KPiANCj4gSSBzYXcgbGF0ZXN0IE1YNlEgUk0gc3RpbGwg
aW5kaWNhdGVzIGl0J3MgNC0xNi4NCj4gQ2FuIHlvdSBoZWxwIGRvdWJsZSBjaGVjayB3aXRoIElD
IGd1eXMgd2hldGhlciBhbGwgUk0gb2YgcmVsYXRlZCBjaGlwcyBuZWVkDQo+IHVwZGF0ZT8NCg0K
T2theSwgSSByZWZlcnJlZCB0byAyMDE4IFJNIGFuZCBzcGVjaWZpYyBSTSBmb3IgaW14OFFNL1FY
UC4gSSB3aWxsIGRvdWJsZSBjaGVjayB3aXRoIElDIGd1eXMuDQoNCkJlc3QgUmVnYXJkcywNCkpv
YWtpbSBaaGFuZw0KDQo+IFJlZ2FyZHMNCj4gRG9uZyBBaXNoZW5nDQo+IA0KPiA+IFNpZ25lZC1v
ZmYtYnk6IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+ID4gLS0tDQo+
ID4gIGRyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMgfCAyICstDQo+ID4gIDEgZmlsZSBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMgYi9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jDQo+ID4g
aW5kZXgNCj4gPiBlMzUwODNmZjMxZWUuLjJlYTM1ZWY0YWEyNyAxMDA2NDQNCj4gPiAtLS0gYS9k
cml2ZXJzL25ldC9jYW4vZmxleGNhbi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvY2FuL2ZsZXhj
YW4uYw0KPiA+IEBAIC0zMjcsNyArMzI3LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBmbGV4Y2Fu
X2RldnR5cGVfZGF0YQ0KPiA+IGZzbF9sczEwMjFhX3IyX2RldnR5cGVfZGF0YSA9IHsNCj4gPg0K
PiA+ICBzdGF0aWMgY29uc3Qgc3RydWN0IGNhbl9iaXR0aW1pbmdfY29uc3QgZmxleGNhbl9iaXR0
aW1pbmdfY29uc3QgPSB7DQo+ID4gIAkubmFtZSA9IERSVl9OQU1FLA0KPiA+IC0JLnRzZWcxX21p
biA9IDQsDQo+ID4gKwkudHNlZzFfbWluID0gMiwNCj4gPiAgCS50c2VnMV9tYXggPSAxNiwNCj4g
PiAgCS50c2VnMl9taW4gPSAyLA0KPiA+ICAJLnRzZWcyX21heCA9IDgsDQo+ID4gLS0NCj4gPiAy
LjE3LjENCg0K

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D40FE75C87
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 03:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbfGZBZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 21:25:51 -0400
Received: from mail-eopbgr60064.outbound.protection.outlook.com ([40.107.6.64]:20510
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725819AbfGZBZv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 21:25:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gfLJYf+rtJMpG+HRVitNWw7kr/SwvC+zPrce+0gb+MSRCUfmIh6YXbqzWY4q+FVHvcHCI9Q6OAz4SnCsRxD/ENtoovM2rqYQ3Ce1x4HsdvSiOJjAqbkAXY962f5/tIRhnVE45zd48wrfB68sD7YTiolwqGH3dLr8UGVvlZ5WDv5lyDXwXvl5KVLQwlxLH2F/cId5GNXIDFa183qDXLq8WstrvVuyel6L3gvOZtPgUaUVZJTvqHAQgHryFaEWKOS0aUSKSoiMCSBwgqZHnw1uC7w3Y4eWhPyOfenVkzLJeJPrypMhIuawRKN5HBSu4PNRTsJ7mmJJEAnvNDmvr3kuoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9AK9zy5fK3hI/A18HMF3gwpFWIp5axeMs+ynfM9Y2Cg=;
 b=I4X3IIG3luXqaE6SaJdgSPacrtOnG1mHPcoEz29wjB+k1vVKBXsAAoyKrZ7NVDYK38D8zSYgP+DSVwyUf7+74xrYkQrauRWJ24F+DK5hqroChe+C6KxKqkrI1AA7XOkP2Ilr/oHeMbFn0LErvi+uDaHhsHx8qFVQ52NhcIAjTDCP1jPmx0E2jYZ8lVfLcrqBufQgUJn//B9ErMY6dRRGH516FDz+fHCMPqAceSPOx1B4abbO/B8L/XF8HOynxU2zg9jC5iD6gXLZ1Abuz+P+b5O9Wt0z68tJSjSNw357rDQ1R+yNRx9GVl6LzzUx6Qx1/y4dX3I3CSmcwZsBM+sTYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9AK9zy5fK3hI/A18HMF3gwpFWIp5axeMs+ynfM9Y2Cg=;
 b=HiWjYoqXO+4l2xtzq88sJtPIyn3/cSV4ZTXLWfko+xrabqV2OzWJR6itT1fKjAEig7DiFCLOjZzvLd17UTQQroZmjSr2NBFPhO7AseaCoIA7cB7jjQOR1Nwstg6NHpVGNbAjGcc+Ge0zmm39CtCXS80cgNHn8uQ1PHHhbVTyRZ4=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5130.eurprd04.prod.outlook.com (20.176.233.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Fri, 26 Jul 2019 01:25:47 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b%5]) with mapi id 15.20.2094.013; Fri, 26 Jul 2019
 01:25:47 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 0/8] can: flexcan: add CAN FD support for NXP Flexcan
Thread-Topic: [PATCH 0/8] can: flexcan: add CAN FD support for NXP Flexcan
Thread-Index: AQHVOIgqonFULiHPO0eSKFSJ3ULGeqbbAsWQgAAINwCAAC3BgIAA9gtA
Date:   Fri, 26 Jul 2019 01:25:47 +0000
Message-ID: <DB7PR04MB46180B39F68030C4EA5E2533E6C00@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20190712075926.7357-1-qiangqing.zhang@nxp.com>
 <DB7PR04MB461831872271A98E741FF68AE6C10@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <22ca8787-fa99-50bb-af1a-098866542e42@pengutronix.de>
 <24eb5c67-4692-1002-2468-4ae2e1a6b68b@pengutronix.de>
In-Reply-To: <24eb5c67-4692-1002-2468-4ae2e1a6b68b@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33ea7199-2341-4ba2-df39-08d71168302c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB5130;
x-ms-traffictypediagnostic: DB7PR04MB5130:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <DB7PR04MB5130A774C815DBD7784269D0E6C00@DB7PR04MB5130.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(13464003)(199004)(189003)(446003)(99286004)(6116002)(2906002)(11346002)(52536014)(8676002)(81156014)(186003)(110136005)(81166006)(86362001)(76116006)(476003)(2501003)(5660300002)(102836004)(53386004)(6436002)(6246003)(76176011)(71200400001)(3846002)(966005)(26005)(71190400001)(316002)(53546011)(55016002)(74316002)(4326008)(66946007)(14444005)(64756008)(53936002)(25786009)(486006)(66476007)(66556008)(7736002)(68736007)(6506007)(33656002)(305945005)(14454004)(8936002)(6306002)(7696005)(229853002)(66446008)(54906003)(66066001)(256004)(478600001)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5130;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VlCMM41ECEpCMnLOteyVZ+YDSUUZA3uEEMwi0f4Jog85TcnCdtGaHCQhLZ8snLgQO4yFQ5lBztmL8bBLiZELgnBOGM9iAido7tQ0EJuW13sgcxT/OWjlaXop+9ae+Sr+7wTrspABgIWKq572d6bJ4AEGr1kLt61dBhjLuZFjs8wrUKpTnnBZBm8X65B2Nr7ttH/EsV/XXZBeo3/XEVrYeWcCd1ZOJNPHKhU7/WQO8q+7jDNJDrbs6QOTe6sZRp4q2TlkRfqzlyWAVR6yq3Xes3VDZfN7phtM/e4BV/bV7xoM31d/iuyUTDIEnzVblkztjIfucArumpCizLdkrTULgzc3AkSzmqWf8oFm+0auNfQPELyQOx77/oG3HO3G9G2VZEMicQQYVg5WX3GVKUXa/bMK/TBv00+I3gEIYU2rtkE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33ea7199-2341-4ba2-df39-08d71168302c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 01:25:47.7433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qiangqing.zhang@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5130
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMTnlubQ35pyIMjXml6UgMTg6MzcNCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBsaW51eC1jYW5Admdl
ci5rZXJuZWwub3JnDQo+IENjOiB3Z0BncmFuZGVnZ2VyLmNvbTsgZGwtbGludXgtaW14IDxsaW51
eC1pbXhAbnhwLmNvbT47DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6
IFtQQVRDSCAwLzhdIGNhbjogZmxleGNhbjogYWRkIENBTiBGRCBzdXBwb3J0IGZvciBOWFAgRmxl
eGNhbg0KPiANCj4gT24gNy8yNS8xOSA5OjUzIEFNLCBNYXJjIEtsZWluZS1CdWRkZSB3cm90ZToN
Cj4gPiBPbiA3LzI1LzE5IDk6MzggQU0sIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPj4gS2luZGx5
IHBpbmdpbmcuLi4NCj4gPj4NCj4gPj4gQWZ0ZXIgeW91IGdpdCBwdWxsIHJlcXVlc3QgZm9yIGxp
bnV4LWNhbi1uZXh0LWZvci01LjQtMjAxOTA3MjQsIHNvbWUgcGF0Y2hlcw0KPiBhcmUgbWlzc2lu
ZyBmcm9tIGxpbnV4LWNhbi1uZXh0L3Rlc3RpbmcuDQo+ID4+IGNhbjogZmxleGNhbjogZmxleGNh
bl9tYWlsYm94X3JlYWQoKSBtYWtlIHVzZSBvZiBmbGV4Y2FuX3dyaXRlNjQoKSB0bw0KPiA+PiBt
YXJrIHRoZSBtYWlsYm94IGFzIHJlYWQNCj4gPj4gY2FuOiBmbGV4Y2FuOiBmbGV4Y2FuX2lycSgp
OiBhZGQgc3VwcG9ydCBmb3IgVFggbWFpbGJveCBpbiBpZmxhZzENCj4gPj4gY2FuOiBmbGV4Y2Fu
OiBmbGV4Y2FuX3JlYWRfcmVnX2lmbGFnX3J4KCk6IG9wdGltaXplIHJlYWRpbmcNCj4gPj4gY2Fu
OiBmbGV4Y2FuOiBpbnRyb2R1Y2Ugc3RydWN0IGZsZXhjYW5fcHJpdjo6dHhfbWFzayBhbmQgbWFr
ZSB1c2Ugb2YNCj4gPj4gaXQNCj4gPj4gY2FuOiBmbGV4Y2FuOiBjb252ZXJ0IHN0cnVjdCBmbGV4
Y2FuX3ByaXY6OnJ4X21hc2t7MSwyfSB0byByeF9tYXNrDQo+ID4+IGNhbjogZmxleGNhbjogcmVt
b3ZlIFRYIG1haWxib3ggYml0IGZyb20gc3RydWN0DQo+ID4+IGZsZXhjYW5fcHJpdjo6cnhfbWFz
a3sxLDJ9DQo+ID4+IGNhbjogZmxleGNhbjogcmVuYW1lIHN0cnVjdCBmbGV4Y2FuX3ByaXY6OnJl
Z19pbWFza3sxLDJ9X2RlZmF1bHQgdG8NCj4gPj4gcnhfbWFza3sxLDJ9DQo+ID4+IGNhbjogZmxl
eGNhbjogZmxleGNhbl9pcnEoKTogcmVuYW1lIHZhcmlhYmxlIHJlZ19pZmxhZyAtPg0KPiA+PiBy
ZWdfaWZsYWdfcngNCj4gPj4gY2FuOiBmbGV4Y2FuOiByZW5hbWUgbWFjcm8gRkxFWENBTl9JRkxB
R19NQigpIC0+DQo+IEZMRVhDQU5fSUZMQUcyX01CKCkNCj4gPj4NCj4gPj4gWW91IGNhbiByZWZl
ciB0byBiZWxvdyBsaW5rIGZvciB0aGUgcmVhc29uIG9mIGFkZGluZyBhYm92ZSBwYXRjaGVzOg0K
PiA+PiBodHRwczovL3d3dy5zcGluaWNzLm5ldC9saXN0cy9saW51eC1jYW4vbXNnMDA3NzcuaHRt
bA0KPiA+PiBodHRwczovL3d3dy5zcGluaWNzLm5ldC9saXN0cy9saW51eC1jYW4vbXNnMDExNTAu
aHRtbA0KPiA+Pg0KPiA+PiBBcmUgeW91IHByZXBhcmVkIHRvIGFkZCBiYWNrIHRoZXNlIHBhdGNo
ZXMgYXMgdGhleSBhcmUgbmVjZXNzYXJ5IGZvcg0KPiA+PiBGbGV4Y2FuIENBTiBGRD8gQW5kIHRo
aXMgRmxleGNhbiBDQU4gRkQgcGF0Y2ggc2V0IGlzIGJhc2VkIG9uIHRoZXNlDQo+ID4+IHBhdGNo
ZXMuDQo+ID4NCj4gPiBZZXMsIHRoZXNlIHBhdGNoZXMgd2lsbCBiZSBhZGRlZCBiYWNrLg0KPiAN
Cj4gSSd2ZSBjbGVhbmVkIHVwIHRoZSBmaXJzdCBwYXRjaCBhIGJpdCwgYW5kIHB1c2hlZCBldmVy
eXRoaW5nIHRvIHRoZSB0ZXN0aW5nDQo+IGJyYW5jaC4gQ2FuIHlvdSBnaXZlIGl0IGEgdGVzdC4N
Cg0KSGkgTWFyYywNCg0KQm90aCBDbGFzc2ljIENBTiBhbmQgQ0FOIEZEIGNhbiB3b3JrIGZpbmUg
b24gbXkgc2lkZSB0ZXN0LCB0aGFuayB5b3UgZm9yIHlvdXIga2luZGx5IHJldmlldy4NCg0KQmVz
dCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+IHJlZ2FyZHMsDQo+IE1hcmMNCj4gDQo+IC0tDQo+
IFBlbmd1dHJvbml4IGUuSy4gICAgICAgICAgICAgICAgICB8IE1hcmMgS2xlaW5lLUJ1ZGRlICAg
ICAgICAgICB8DQo+IEluZHVzdHJpYWwgTGludXggU29sdXRpb25zICAgICAgICB8IFBob25lOiAr
NDktMjMxLTI4MjYtOTI0ICAgICB8DQo+IFZlcnRyZXR1bmcgV2VzdC9Eb3J0bXVuZCAgICAgICAg
ICB8IEZheDogICArNDktNTEyMS0yMDY5MTctNTU1NSB8DQo+IEFtdHNnZXJpY2h0IEhpbGRlc2hl
aW0sIEhSQSAyNjg2ICB8IGh0dHA6Ly93d3cucGVuZ3V0cm9uaXguZGUgICB8DQoNCg==

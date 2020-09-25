Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDAC22781C5
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 09:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgIYHil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 03:38:41 -0400
Received: from mail-eopbgr40049.outbound.protection.outlook.com ([40.107.4.49]:42370
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727132AbgIYHik (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 03:38:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V2H2U68h5fFtwkX0mJ6qGxxgPvbSBlEf4gR6eFz0a6Avnu0cMFNG9R4FkcBCb1UsTLkoVPgCoaMvt/Z699tfLLsNSsR+yd7QfKNwcOaQkAAavd9y24sT8kZO+ZT9JREWNJ54WGgYFWSvOTGC5kaAF/FAfZfZsVH7v/U838Wk7cgSxkHhfE25um9MjWuv1Ynvd5MeANXY6bVqVyTK6qR8BP3+Zwlu/9jhzXACYD1m9N/zrMHZF8lsg2wriU4ApLDUef+KRfyKAHzjJ+kbYvCthkUwEwKEfaVWgISHYplh+TQEd73JEER9kcF4dJMbsMoUnTPTlWr7Iwmn2WErGzSQiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nzDExIWD4iFbzRzRu8WX4ywpxVThkB40YuBkTZuma/k=;
 b=OW2pva7Yst+pHP+E2ZbpdHeVeU9xD1iTfgppxsTp0AezpQx92IlHd4LhjE9Y0f7PcbIj8GoKlby3C7pHRFJLp93/h0x+4N6OXJN+sc5eUH7HAl7xFYvOviuExh237kvEEJQCpzK7MJd6ZZZxlDxHaCB6FakzIdDLd/MOCVClt9yqANUHi5SeduWtXeQ0iLo1zHBmdzAwNQq0pNK0W882a3oK/gug1uraICyOHuevrlsXNTHrujhOZMnaKNFj/BqY+DZrweEtT2VCYWepcnnxdwInl1WKhwtx2F0M7PiVOgWi5HxpkSiX6RhdAMmH5J2DaY0CbqCUic2GSPNrnnQBEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nzDExIWD4iFbzRzRu8WX4ywpxVThkB40YuBkTZuma/k=;
 b=Zfx9bLpkOUfaG7ru9l35yXlkjnmdiqyKfUM19i2Oc2JDh23Xs8r3VQ0fhk9sKrQ/zWbESOIiYJmom0+byzgzo0ogmrSWSBq33zb2oHG9klq9OjhneyA/fbOF2CKmWbxcTPS3yyn3YQ5gHmqjp//Snwi7qwhR+MqL54lzBOQa9MA=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6251.eurprd04.prod.outlook.com (2603:10a6:10:cd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Fri, 25 Sep
 2020 07:38:35 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.022; Fri, 25 Sep 2020
 07:38:35 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH linux-can-next/flexcan 1/4] can: flexcan: initialize all
 flexcan memory for ECC function
Thread-Topic: [PATCH linux-can-next/flexcan 1/4] can: flexcan: initialize all
 flexcan memory for ECC function
Thread-Index: AQHWkwrxc33Q4pOyMEiSJX13xMzIVal49jIAgAAAT/A=
Date:   Fri, 25 Sep 2020 07:38:35 +0000
Message-ID: <DB8PR04MB6795BB0D5F2FFEEC3D384A96E6360@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20200925151028.11004-1-qiangqing.zhang@nxp.com>
 <20200925151028.11004-2-qiangqing.zhang@nxp.com>
 <b4960a59-a864-d6f8-cef6-7223a6351dae@pengutronix.de>
In-Reply-To: <b4960a59-a864-d6f8-cef6-7223a6351dae@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9026939f-460c-4a0d-9a39-08d861260288
x-ms-traffictypediagnostic: DBBPR04MB6251:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR04MB625185DA46919D1D5570CE3DE6360@DBBPR04MB6251.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pb+UEzFsnqCAFeIiNliLNTfJ/u9xk7ViHE5dRHQOjqMy03/wg4rcX6XXXE7WVKIaD/Iiutc5XlZ61Ky6T36phO5o7GOrTuXoBWbvMt5V+FQW3N4PhVY41YqZv8DxCjqtZHeLlMd7T835kTWD9qomTlH8osVpEDnMnFTO9jlJIiLr/hluinQtvhB3gxYaR4x+h2spuvcpV9R4yObgBNiQlhG1mkEhN51VjRQSneHN17dxqPXttMi2Gs8OoeUPxaReNw1mRYH7jnLy1DP3Bc1XJQuuY8Jwh9eoL/d2sMwqTYxm2SUjOVkmQffN7nSvwUCOZHnx94i2YyqGjDtZMNX+pMQvcb948NOoUEVqYjvMEJKZuH/5ziQbVTsH4a6SrquBaksEyEPAsP+ZNiN6IJkq1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(66946007)(66476007)(76116006)(64756008)(33656002)(66556008)(55016002)(66446008)(9686003)(8676002)(478600001)(8936002)(54906003)(52536014)(86362001)(71200400001)(2906002)(6506007)(316002)(186003)(53546011)(83080400001)(26005)(110136005)(83380400001)(7696005)(4326008)(5660300002)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: GiFpBEjZkkKvy6SrNZQebVbAMNGq4o9pUXiXMcODn/YN0cDhdtFDdlr0CvV+meJss7JyIZqUyGBxPFenWoIagyfFFkZTtpkU63ajHR8CBPmMqciNcAmIfFXvuJVD9ebLpNdo8+XnHP/xCA1AjdohPmdtd5puCk37Fp+gHZjA3b6PZodvzV9qRJkdBUT2edMVJw6UtFSrdurpvbLvYyB8Geva+R1loksjfgqQOWNeNGdBQ6XplJ5whcALTl0qPXMFoRCIEFTArF3ZxM7vHPlQiiRVqzo1FRnZ/b//3ds3vvudpgUITibBtVCv4aT/ffZB3zsJMdh6kGhwQyS50eQUFlvT36LNh/7a4VAuLHnLNtGN0cANjYyj7ykI4KLEX/OCTSOHLxk1ZSqUpANQMmPlwg1IXxl6bVKytb/o5TJ/6jcnCKGsvwfOoWT8TkJ+YmW0NrATx6/WAGM1dCBIAkA5gCoeIU9bzZwbil1aUrFAsNebRO5mBkbZITUiTh8QgQuA/Ns7oburUITnJSN0GFvgVOWQTuziw82LRZwNN7M0xcmB7xtag8V6s0Xj2ok9L95mNQHJAhn+MrkW4qmh+2Cr+X+q8VV+v76cAdK20g3GcKheIe+Fzxv50pIXlzS5yy4EzJqckQmH+Ca0JmBCYFJwAA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9026939f-460c-4a0d-9a39-08d861260288
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2020 07:38:35.0908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3jrM0X6VQ8peRQfhhx3X0ltEzZFOdPIkIqqov+Pqsqjo+evq2ehbZr8KyVaYmlF4+9svVyXY0iLRfBNsiekuRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6251
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDlubQ55pyIMjXml6UgMTU6MzMNCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBsaW51eC1jYW5Admdl
ci5rZXJuZWwub3JnDQo+IENjOiBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsgbmV0
ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIGxpbnV4LWNhbi1uZXh0
L2ZsZXhjYW4gMS80XSBjYW46IGZsZXhjYW46IGluaXRpYWxpemUgYWxsIGZsZXhjYW4NCj4gbWVt
b3J5IGZvciBFQ0MgZnVuY3Rpb24NCj4gDQo+IE9uIDkvMjUvMjAgNToxMCBQTSwgSm9ha2ltIFpo
YW5nIHdyb3RlOg0KPiA+IFRoZXJlIGlzIGEgTk9URSBhdCB0aGUgc2VjdGlvbiAiRGV0ZWN0aW9u
IGFuZCBjb3JyZWN0aW9uIG9mIG1lbW9yeSBlcnJvcnMiOg0KPiA+IEFsbCBGbGV4Q0FOIG1lbW9y
eSBtdXN0IGJlIGluaXRpYWxpemVkIGJlZm9yZSBzdGFydGluZyBpdHMgb3BlcmF0aW9uDQo+ID4g
aW4gb3JkZXIgdG8gaGF2ZSB0aGUgcGFyaXR5IGJpdHMgaW4gbWVtb3J5IHByb3Blcmx5IHVwZGF0
ZWQuDQo+ID4gQ1RSTDJbV1JNRlJaXSBncmFudHMgd3JpdGUgYWNjZXNzIHRvIGFsbCBtZW1vcnkg
cG9zaXRpb25zIHRoYXQgcmVxdWlyZQ0KPiA+IGluaXRpYWxpemF0aW9uLCByYW5naW5nIGZyb20g
MHgwODAgdG8gMHhBREYgYW5kIGZyb20gMHhGMjggdG8gMHhGRkYNCj4gPiB3aGVuIHRoZSBDQU4g
RkQgZmVhdHVyZSBpcyBlbmFibGVkLiBUaGUgUlhNR01BU0ssIFJYMTRNQVNLLA0KPiBSWDE1TUFT
SywNCj4gPiBhbmQgUlhGR01BU0sgcmVnaXN0ZXJzIG5lZWQgdG8gYmUgaW5pdGlhbGl6ZWQgYXMg
d2VsbC4gTUNSW1JGRU5dIG11c3Qgbm90DQo+IGJlIHNldCBkdXJpbmcgbWVtb3J5IGluaXRpYWxp
emF0aW9uLg0KPiA+DQo+ID4gTWVtb3J5IHJhbmdlIGZyb20gMHgwODAgdG8gMHhBREYsIHRoZXJl
IGFyZSByZXNlcnZlZCBtZW1vcnkNCj4gPiAodW5pbXBsZW1lbnRlZCBieSBoYXJkd2FyZSksIHRo
ZXNlIG1lbW9yeSBjYW4gYmUgaW5pdGlhbGl6ZWQgb3Igbm90Lg0KPiA+DQo+ID4gSW5pdGlhbGl6
ZSBhbGwgRmxleENBTiBtZW1vcnkgYmVmb3JlIGFjY2Vzc2luZyB0aGVtLCBvdGhlcndpc2UsIG1l
bW9yeQ0KPiA+IGVycm9ycyBtYXkgYmUgZGV0ZWN0ZWQuIFRoZSBpbnRlcm5hbCByZWdpb24gY2Fu
bm90IGJlIGluaXRpYWxpemVkIHdoZW4NCj4gPiB0aGUgaGFyZHdhcmUgZG9lcyBub3Qgc3VwcG9y
dCBFQ0MuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56
aGFuZ0BueHAuY29tPg0KPiANCj4gSXMgdGhpcyB3aG9sZSBwYXRjaCB2YWxpZC9jb21wYXRpYmxl
IHdpdGggdGhlIG14Nyx0b28/DQoNCkhpIE1hcmMsDQoNCkkgbm90aWNlIGl0IGp1c3Qgbm93LCBz
ZWVtcyBsYWNrIG9mIHBhdGNoIGZvciBpbXggZmlybXdhcmUgaW4gdXBzdHJlYW0sIHRoYXQgd2ls
bCBhbHdheXMgZXhwb3J0IHNjdSBzeW1ib2xzLg0KaW5jbHVkZS9saW51eC9maXJtd2FyZS9pbXgv
c3ZjL21pc2MuaA0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gTWFyYw0KPiANCj4g
LS0NCj4gUGVuZ3V0cm9uaXggZS5LLiAgICAgICAgICAgICAgICAgfCBNYXJjIEtsZWluZS1CdWRk
ZSAgICAgICAgICAgfA0KPiBFbWJlZGRlZCBMaW51eCAgICAgICAgICAgICAgICAgICB8IGh0dHBz
Oi8vd3d3LnBlbmd1dHJvbml4LmRlICB8DQo+IFZlcnRyZXR1bmcgV2VzdC9Eb3J0bXVuZCAgICAg
ICAgIHwgUGhvbmU6ICs0OS0yMzEtMjgyNi05MjQgICAgIHwNCj4gQW10c2dlcmljaHQgSGlsZGVz
aGVpbSwgSFJBIDI2ODYgfCBGYXg6ICAgKzQ5LTUxMjEtMjA2OTE3LTU1NTUgfA0KDQo=

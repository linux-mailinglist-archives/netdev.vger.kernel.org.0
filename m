Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC3C278455
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 11:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgIYJsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 05:48:11 -0400
Received: from mail-eopbgr60058.outbound.protection.outlook.com ([40.107.6.58]:62731
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727795AbgIYJsK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 05:48:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZIO1tWM2uPIEzn05UAaMMwpWxGbBDZZb6UIvrLIAJir+1DJKUn6quTYR5TZhbB4yTaYRaQHYoM/rmpAntgmHEYwHoIces2dSKGbDHmo1DZn1Uba/NJYgP0r8ZoAkeXSLJ2YxMG4rdE2AtzbUIhySMhj1tccvkDoSXCsYI0Htol/MwMyM37tosBSptqPRH/FBtvzZFpBl65AV4kYLoPt3rszibH6b7XSDPNdJ5nSqdu6z0Sm6dsURuOeXRC+xkZHiU+eWBXtBfjIF0zxc0j/1zYA+7aS7+ZvMVrVA7w8iggmrQgEykAkP/p8qvVbEATus/NuEY2zEXBQeC9ftFpEQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ciSIz6lX9jW5giUlQGM/8XY4zlmJthB46v06dMrH/M=;
 b=Kn3kkLiU4xCF5L06SGF0Qk6MU4mJt8jpiZq16dJSBG8BYEk6C4SiNi8m1SfQewAa/lEuTQxjCFTYpuq48noEOwXMy/OlK36rrSdpNKX1TFMUyKq3dc8YMDtdCuIc8lwT7FYNLPzUmYBpzB3tfzjGNL9OskYtUN129n/r13tmDSgRT+8af26mwNK+ByLm8BdKyXmXhwF1pHlAJ75fhlti9Vzuevvh+lYtE/eERIwtOJqJW91nozO8dZW9B0UwKPDOBYzKSVPN6JrUQ5vy6NCjxMOXTNhrAZPK4NX5Q4WG5vaeJj51/0/zNAiX8BqwqaAbLUOOUeq/or1WsOO/u1QXOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ciSIz6lX9jW5giUlQGM/8XY4zlmJthB46v06dMrH/M=;
 b=dh0RJNBxk0Ys+WsD2ejNb++RZa2fpV4gfR5Jls9rinC02Ural9DQO/2WspOQqUh+d8XCu3cPIIBhkn5D7Yk6qcR3Z4/enY+m4dFp4C7aW0pumXl/4xOl1taWK2mkWJGXn/DCSew/NTCsVWxjr3eC0HB0VDZ1AaYYF/x38voaM1U=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7205.eurprd04.prod.outlook.com (2603:10a6:10:1b3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Fri, 25 Sep
 2020 09:48:07 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.022; Fri, 25 Sep 2020
 09:48:07 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH linux-can-next/flexcan 2/4] can: flexcan: add flexcan
 driver for i.MX8MP
Thread-Topic: [PATCH linux-can-next/flexcan 2/4] can: flexcan: add flexcan
 driver for i.MX8MP
Thread-Index: AQHWkwryw5CNKh5rmUaMkhxmNi/0xql5D8uAgAABQbCAAAdQgIAAAfbg
Date:   Fri, 25 Sep 2020 09:48:07 +0000
Message-ID: <DB8PR04MB67952A5BEC6A4A91050CA45BE6360@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20200925151028.11004-1-qiangqing.zhang@nxp.com>
 <20200925151028.11004-3-qiangqing.zhang@nxp.com>
 <bdb05b08-b60c-c3f9-2b01-3a8606d304f9@pengutronix.de>
 <DB8PR04MB6795D438EB4D6C6F9CF4F096E6360@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <e1a7eebd-e36c-cd96-1b9f-7300faee40dd@pengutronix.de>
In-Reply-To: <e1a7eebd-e36c-cd96-1b9f-7300faee40dd@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 32da209c-ed74-4fa9-1072-08d861381b38
x-ms-traffictypediagnostic: DBAPR04MB7205:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBAPR04MB720586E0DC2B64F432DBD40DE6360@DBAPR04MB7205.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vgXTlJ/wUu+zFWgXJapthyQtOXlGgSDFv/5I1zXSOt5/dW0NTWw6lBREncDG0u6VGXDu3O7OvKz4hd4xlgebnQM3AKBUNu2Q901JT6nTWm9IaZkKUt+XrlDgoZbT3U5JlJlEX7a5AQh66JARA5vXRC/NoonjpxNyXZoLI+76WpHfOVq2n8ZPB0gCVMWGdkMv8VOThSAR05zZdCmFsygXT8LPjaBOMbimQ+VPAtVhxh8TrLyBF+nbfebSraGp2cNihLeVyhZ2Pfh9jeoQIs6cerbyXsBtdmZBXoysATKelrGewnGuMOTqupJZVcEGV/1umcARDFq9/X4IeS4w1PLAWpgdsUhcT+k9afpi4OggO7oiZsdJmlyUe9ydmc18l8+GAoTcqWTB70u6x/Pm2vV8SIlWX8kkEjZLNaXK8GIE9aX86jdFyZZDrVZ9Xf0/aXKg7K/a469DJPPkax7t51M4UQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(366004)(136003)(26005)(53546011)(5660300002)(54906003)(186003)(66476007)(76116006)(83380400001)(110136005)(316002)(6506007)(33656002)(83080400001)(478600001)(71200400001)(4326008)(66446008)(9686003)(7696005)(66946007)(55016002)(2906002)(86362001)(8676002)(8936002)(966005)(64756008)(66556008)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: QVQEDYZlqkuaCk9NylYwM7Ehdaol/31Eltfr8oV30ApLDIz/VjgmzEiLPJXnY1NhCfb/c5sNEMDXS2nMl1VirwSQJmCrP9FFngqrGCObUxaNOtRzWCXg5PAm8RL7RmrKLq39sGUh9uOgBIWWd6Agjcb3KJgqRhQReRpRAwpkjDO2cjkiswH3A6eVwVXG6RTSQZoVz22rykVLJ34SeB6i0E+9+RiRDAwND/SfA8dUJWTCj7lZ+MCUvthd4ntxzo12/euRmIs8aK4YGsEMrep6K962Ht+oLxam4nzKNE4gFmI4DHIS2BUpuKq9JfeSz53M9tL3/P98wlgr680MXKSk8O0nTmVa8MMZ2DjK0bNnceQh3ELWuZ1J4xEssBnPHwcMy21CmqE5oYTJXEX7CxY2O9U+6crz9se+FUXK1AAmrDVkiACaTRP3ROoa/Y9AKGPTBzDjMwg7NNjmkbKt84l/sn81nGKg6wWZSFCLPyUyG0abE1goIYu0sNdng3L0b6KdSsQJYHa2hYgoFdPTYtGz/M7JMHzYBAhJjdOw+i09hnR9+BHj5nQWZh1JDf8F/0tVqb6Jr+BKqFl1akQ61au/ffw/m3TPRe3v5gaJ11ZIKOR3G5JY3nPcB3V4KoqScRAvm5ck1yIEnzns3RbdNd5nVw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32da209c-ed74-4fa9-1072-08d861381b38
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2020 09:48:07.4532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x5N43OBKOTMfEf3grHPWfb0NrMCyA7CgoeGzYqrBqoHdjLWtqdUqe8DLRNE4ptuZECe2+EN3EPppQBSG+25fqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7205
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDlubQ55pyIMjXml6UgMTc6MzYNCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBsaW51eC1jYW5Admdl
ci5rZXJuZWwub3JnDQo+IENjOiBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsgbmV0
ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIGxpbnV4LWNhbi1uZXh0
L2ZsZXhjYW4gMi80XSBjYW46IGZsZXhjYW46IGFkZCBmbGV4Y2FuIGRyaXZlcg0KPiBmb3IgaS5N
WDhNUA0KPiANCj4gT24gOS8yNS8yMCAxMToxMSBBTSwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+
PiBUaGlzIGRvZXNuJ3QgYXBwbHkgdG8gbmV0LW5leHQvbWFzdGVyLiBUaGUgTVg4UU0gaW5kZW50
ZWQgZGlmZmVyZW50bHkuDQo+ID4NCj4gPiBOZWVkIEkgcmViYXNlIG9uIG5ldC1uZXh0L21hc3Rl
ciBpbiBuZXh0IHZlcnNpb24/IFRoaXMgcGF0Y2ggc2V0IGlzDQo+ID4gbWFkZSBmcm9tIGxpbnV4
LWNhbi1uZXh0L2ZsZXhjYW4gYnJhbmNoLg0KPiBZZXMsIHRoZSBmbGV4Y2FuIHBhdGNoZXMgYXJl
IGFscmVhZHkgaW4gRGF2aWQncyB0cmVlLCBzbyBwbGVhc2UgYmFzZSBvbg0KPiBuZXQtbmV4dC9t
YXN0ZXIuDQoNCk9rLCBhbm90aGVyIEkgd2FudCB0byBpbmRpY2F0ZSBpcyB0aGF0LCBpLk1YOE1Q
IFJNIGhhcyBub3QgcmVsZWFzZWQgdG8gcHVibGljLCBJIG9ubHkgaGF2ZSBpbnRlcm5hbCByZXZp
ZXcgdmVyc2lvbiBhbmQgc3BlY2lmaWMgUk0gb2YgaS5NWDhNUCBnZW5lcmF0ZWQgYnkgSVAgb3du
ZXJzLg0KDQpTbyBJIGFtIHVuYWJsZSB0byBnaXZlIGEgd2Vic2l0ZSBsaW5rIGZvciB0aGlzLCBq
dXN0IGFkZCB0aGUgbmFtZSwgdmVyc2lvbiwgc2VjdGlvbi4NCg0KQmVzdCBSZWdhcmRzLA0KSm9h
a2ltIFpoYW5nDQo+IE1hcmMNCj4gDQo+IC0tDQo+IFBlbmd1dHJvbml4IGUuSy4gICAgICAgICAg
ICAgICAgIHwgTWFyYyBLbGVpbmUtQnVkZGUgICAgICAgICAgIHwNCj4gRW1iZWRkZWQgTGludXgg
ICAgICAgICAgICAgICAgICAgfCBodHRwczovL3d3dy5wZW5ndXRyb25peC5kZSAgfA0KPiBWZXJ0
cmV0dW5nIFdlc3QvRG9ydG11bmQgICAgICAgICB8IFBob25lOiArNDktMjMxLTI4MjYtOTI0ICAg
ICB8DQo+IEFtdHNnZXJpY2h0IEhpbGRlc2hlaW0sIEhSQSAyNjg2IHwgRmF4OiAgICs0OS01MTIx
LTIwNjkxNy01NTU1IHwNCg0K

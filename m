Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B895027833B
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 10:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgIYIvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 04:51:06 -0400
Received: from mail-vi1eur05on2080.outbound.protection.outlook.com ([40.107.21.80]:18624
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727135AbgIYIvG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 04:51:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KHBnUkTrTOh4eXUuxkaGesNAtrmHemUurxJqHFRVKHTUT6EaMznUzway+Uj8NaQcYFubleJGFvGCU6J0ORpPTp2rKl/sOQiT8UpRs3VJ7R7JPzdLZBY9vPaChnp8N5con18Jv/yJCZCGDmo+VUukoWqVHuul8mTu1jqLddNLBgQMVb4aT7Ts5zyFP5T+TbF4rKZn6P7XoAPsQCFuTxzofGUwa1+C4YuGDu8iEuSs++9hag3Mq/hU8+S8vUn6rzl44y2gQgQ5CNkL48Pxmo9iF/vKZvlOZpLWWMPp3ppaYjvOsIoxvrFMWJK+1EGqvOndiq6mQXjLWgXJmKfJAvP4dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=St7TVU/cbrYGCh14ROtEdb0ZnNMoq0noNAiG/dCScQE=;
 b=nE9x3qZ4I23fV+wR9p8k9cKDvNzqk6ZsPcFN1LFdKTLC2qU57kzAqpBNLu8+sQgfdDAxI2piS59mP0MeCnqBrjpu16aiB7WaYzY29F4Vlw101CIAEAnIGRHc9MgdH9V/QI+Ns5+zAD8VE2EV0hAuDfAfPpv0HkmSciZbuGdZqYuRCd4ujiyoayBxEleFwJooKWdOKVqbbvA9R1AbDIG/ANfqj56KdxIC5fwQzOP5G0AGRfwB9zvPdSpbDkqWmHcVlAnNGsVhzhdoRJGFgZKyI/155Ds4e0AYyh0oc6z8xbvDKEw+cUsbQZjBbA4A/EcxGuENXsWibBYMcGqCHn4fNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=St7TVU/cbrYGCh14ROtEdb0ZnNMoq0noNAiG/dCScQE=;
 b=LXY6vmiwRJKPYfFMJOh5q8JVLdvQvMER3Rbi91512mcWmi+uX0hDanK70GnZ/yMDEsXQuhgIqvJ/TNtRAyQ8kvuoQb+FXX6a3edm8bUSGjPO35dkJYDqT8GWj6CDymQQ7FIqlcHRfO+bi5SErZ8c/dxxCC74EQG/5JX5kTqt5iY=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB7100.eurprd04.prod.outlook.com (2603:10a6:10:127::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Fri, 25 Sep
 2020 08:51:02 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.022; Fri, 25 Sep 2020
 08:51:01 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH linux-can-next/flexcan 1/4] can: flexcan: initialize all
 flexcan memory for ECC function
Thread-Topic: [PATCH linux-can-next/flexcan 1/4] can: flexcan: initialize all
 flexcan memory for ECC function
Thread-Index: AQHWkwrxc33Q4pOyMEiSJX13xMzIVal49jIAgAAAT/CAAApBAIAABgZg
Date:   Fri, 25 Sep 2020 08:51:01 +0000
Message-ID: <DB8PR04MB6795BAB5714106474A06FD81E6360@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20200925151028.11004-1-qiangqing.zhang@nxp.com>
 <20200925151028.11004-2-qiangqing.zhang@nxp.com>
 <b4960a59-a864-d6f8-cef6-7223a6351dae@pengutronix.de>
 <DB8PR04MB6795BB0D5F2FFEEC3D384A96E6360@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <a4a57849-fc34-0bc5-f35e-13347f6585dd@pengutronix.de>
In-Reply-To: <a4a57849-fc34-0bc5-f35e-13347f6585dd@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c758aba2-67aa-4885-6971-08d86130214a
x-ms-traffictypediagnostic: DB8PR04MB7100:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB7100FAAD41D5395FFCC5070AE6360@DB8PR04MB7100.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A+rXTmNgbcTwSoBafmBrv6FMfCRezovS35HopH51yrkQOhU9OSQNkOgwJJdkVKidOYrhycFTtwZGIO+iO5lu/Jlddw5A8agehadvRD23YpKbn1HE+Pu49f1w4EHIE3EpYaZTuPTKB9am4pfnShRchxIRyGcMpDEAYoxk8aNhR1EXaG2krWMDldBWXnWxPmsep+sdutZO+COGpbGYeKQcfznjCgF1Vc41HNj8Oi/wZuPAyCDkza+FrzTojA1wf0j0HJoEnsr2Q0EfY7MUaQSPnpNpkzVngNqi8CHqU0mfLqmfNg202G5w8dUuzC5D3lHcoKNXRiI+PZJ4r9P9OCzz0NVaty0a0vtfIUdlG7dXCET64ebBmppo+8XpYKIsw6061gc7uinlenxFNRAGdvAYRxkFwI084d6wgP/lOAYrzLzyvOXrQ35F4/ic7jlenEOvNRqF/KHP45EpaVz7ZQZLEA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(346002)(366004)(136003)(8936002)(53546011)(7696005)(8676002)(54906003)(316002)(52536014)(6506007)(478600001)(966005)(110136005)(4326008)(83380400001)(64756008)(33656002)(55016002)(186003)(9686003)(2906002)(66446008)(86362001)(5660300002)(76116006)(71200400001)(66476007)(66556008)(66946007)(83080400001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: N+rEBNE20scQCZmGoAAkmng5zgmF/lxPZxLo1Z1bSR6DJm1kovpuK70e+64QJY6wZgAWOGBl43DGvpcHsLmbxyEW0YJ6rHfbdOK4UO71FaiepATCA07uJVyOeO7a/+m3THoKtEAbyzus9mlz5tnoueJoV5QH/Mao+b6lbaFEgFXsKtwFybAzoYqyYFvIP6K9uGiD/FLcBmiZRcIoF2PSXZ8uuhT+becd3VAOQto9CqqF2uucUFfm1MQUJpVFXc0bCdiQU/0v/efRhYrNRP32Bnizx6a5QG63ipri3uopnsHAQC3QhBMNf8YihD5JKeD0KexCHzpnkjpT4/XqOPKsw0Zti+uLou6GuPBbFpeVtv6oxQWrRli2g6MhNR5u3Gm8brr+f5QIJycaTtFmSJ717+KGepe8REMqV+RgiqET8ujLR+oyRp2dHkaAw2GA00ODCpOv+ji7Z4j+RuXtX5wBM7MJDmtulXtERO81KOcLclJCsPY+Qpmi7KX0vGp8fY4SMBjEQEXBhMg6EODvrT4IahJlg11bDJabF89jplgAn1CltJFB1GD/fjIoozmgnPvM7Mjz+ngbf3U355Fc73TwOvonMen3dO9G48x8eJ06PzkTiTJ7/HNSlG7AN4Rv30mm0tAaVvbpA0pbT1Mrxaj+ng==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c758aba2-67aa-4885-6971-08d86130214a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2020 08:51:01.6709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JP/McdDyS6OPcOiiiQGN+syxZ/yCNGQuNRWZXh24Ai3wIs21G54Ur1oYbzDCzxmZ8fDhv95i2JS+ooXWHvxRrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDlubQ55pyIMjXml6UgMTY6MTENCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBsaW51eC1jYW5Admdl
ci5rZXJuZWwub3JnDQo+IENjOiBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsgbmV0
ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIGxpbnV4LWNhbi1uZXh0
L2ZsZXhjYW4gMS80XSBjYW46IGZsZXhjYW46IGluaXRpYWxpemUgYWxsIGZsZXhjYW4NCj4gbWVt
b3J5IGZvciBFQ0MgZnVuY3Rpb24NCj4gDQo+IE9uIDkvMjUvMjAgOTozOCBBTSwgSm9ha2ltIFpo
YW5nIHdyb3RlOg0KPiA+IEkgbm90aWNlIGl0IGp1c3Qgbm93LCBzZWVtcyBsYWNrIG9mIHBhdGNo
IGZvciBpbXggZmlybXdhcmUgaW4NCj4gPiB1cHN0cmVhbSwgdGhhdCB3aWxsIGFsd2F5cyBleHBv
cnQgc2N1IHN5bWJvbHMuDQo+ID4gaW5jbHVkZS9saW51eC9maXJtd2FyZS9pbXgvc3ZjL21pc2Mu
aA0KPiANCj4gVGhhdCB3aWxsIGFmZmVjdCAiY2FuOiBmbGV4Y2FuOiBhZGQgQ0FOIHdha2V1cCBm
dW5jdGlvbiBmb3IgaS5NWDgiIG5vdCB0aGlzDQo+IHBhdGNoLCByaWdodD8NCg0KSGkgTWFyYywN
Cg0KWWVzLCBvbmx5IGFmZmVjdCAiY2FuOiBmbGV4Y2FuOiBhZGQgQ0FOIHdha2V1cCBmdW5jdGlv
biBmb3IgaS5NWDgiLCBJIHdpbGwgcmVtb3ZlIHRoaXMgcGF0Y2ggZmlyc3QuDQpTb3JyeSwgSSBy
ZXBsaWVkIGluIGEgd3JvbmcgcGxhY2UuDQoNCiJjYW46IGZsZXhjYW46IGluaXRpYWxpemUgYWxs
IGZsZXhjYW4gbWVtb3J5IGZvciBFQ0MgZnVuY3Rpb24iIGZvciB0aGlzIHBhdGNoLCBJIGZpbmQg
dGhpcyBpc3N1ZSBpbiBpLk1YOE1QLCB3aGljaCBpcyB0aGUgZmlyc3QgU29DIGltcGxlbWVudHMg
RUNDIGZvciBpLk1YDQpJIHRoaW5rIHRoaXMgcGF0Y2ggc2hvdWxkIGNvbXBhdGlibGUgd2l0aCBv
dGhlcnMgd2hpY2ggaGFzIEVDQyBzdXBwb3J0LCBidXQgSSBkb24ndCBoYXZlIG9uZSB0byBoYXZl
IGEgdGVzdC4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+IE1hcmMNCj4gDQo+IC0t
DQo+IFBlbmd1dHJvbml4IGUuSy4gICAgICAgICAgICAgICAgIHwgTWFyYyBLbGVpbmUtQnVkZGUg
ICAgICAgICAgIHwNCj4gRW1iZWRkZWQgTGludXggICAgICAgICAgICAgICAgICAgfCBodHRwczov
L3d3dy5wZW5ndXRyb25peC5kZSAgfA0KPiBWZXJ0cmV0dW5nIFdlc3QvRG9ydG11bmQgICAgICAg
ICB8IFBob25lOiArNDktMjMxLTI4MjYtOTI0ICAgICB8DQo+IEFtdHNnZXJpY2h0IEhpbGRlc2hl
aW0sIEhSQSAyNjg2IHwgRmF4OiAgICs0OS01MTIxLTIwNjkxNy01NTU1IHwNCg0K

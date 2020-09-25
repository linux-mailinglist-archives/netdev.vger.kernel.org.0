Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8462781E1
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 09:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbgIYHmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 03:42:52 -0400
Received: from mail-eopbgr130087.outbound.protection.outlook.com ([40.107.13.87]:2119
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727068AbgIYHmw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 03:42:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAr7/pm87/0idp8GZM9RNzmvFiXSxMEeZQP1oxqKuRZ14Z48iPYjuMa6zooi3pYpYYX6/jBwD1MLZBe1HPXRopl5pScO98CTakkHms0Y5OS71AyWDv959bRnz6UpjKyObIsU5fsPx8gLq4ZhzySJz7M3ZLQmv0kGk66U/ou2i4hBZc25GHnDYPdC38e3Z5m8xPprhz+Jg0l4A3USAugMWHDKM42o9W5rwyNNwmrN3pum2KHzSd60Qhh3ReU3YSnbq1BJnURD5LiR0g+gfVp2FaJ+ryNbLKAr6D4Nr5oLs0qUdgOSdmFkQd+IjOX3Mka3X9n9O8Z++T3ejjQBAeIGTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z3upbPbKomSqiuOXF4+5H7V5wSaFlWJhmp5VMYfWfvI=;
 b=OGmPni41F4LS30QoXCuM8Sd32wNFVOrwh2fk3pk0eGOc+o8ZOeoB5+5gVVHV/+UW0x98FuCxduETXC7l7wnS7AeTwe8AiupDIYpimRzsr36Amu6WzRqzI/5G/BVp6xKl9FNZzk0az94rgqqUNjVJ2Lr/BTw6wCiTqRlJKKlA1Id3lWU8JY4BlRCDaeQC9X8jVhq9utVQJe8MbVFOKLlUilmmQ0ZVA4oevuB310a5C/enF3AnSwgznCab9PEIpjf+wwsBsrls972Y09FYnokhqsZan1Ax3ucpntMuGjXJtw02u6W5UC/xCLIE1Iq9/I3UH4+1Erq0A/Ha9Y75I2pjCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z3upbPbKomSqiuOXF4+5H7V5wSaFlWJhmp5VMYfWfvI=;
 b=HelXce0OkoxIbhBBqQr4nGfmRPHesfQ8Hl+EWhQedhXgkGb4g5pnTTPDLdx54ZSjpn8Cg63QdnKNHiaZUdz0sK9PavsUcjR+8yQRIZos/b5hjdcSqB8SOCSWjFF7Qiki5bJJT/hgCcr8I+QFu5toZ3e+o/qzgl3OAzPSkuqa5FQ=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB3962.eurprd04.prod.outlook.com (2603:10a6:5:1a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21; Fri, 25 Sep
 2020 07:42:46 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.022; Fri, 25 Sep 2020
 07:42:46 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH linux-can-next/flexcan 2/4] can: flexcan: add flexcan
 driver for i.MX8MP
Thread-Topic: [PATCH linux-can-next/flexcan 2/4] can: flexcan: add flexcan
 driver for i.MX8MP
Thread-Index: AQHWkwryw5CNKh5rmUaMkhxmNi/0xql49y6AgAABUbA=
Date:   Fri, 25 Sep 2020 07:42:46 +0000
Message-ID: <DB8PR04MB6795F09E1EE9BAC93FE29552E6360@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20200925151028.11004-1-qiangqing.zhang@nxp.com>
 <20200925151028.11004-3-qiangqing.zhang@nxp.com>
 <0729c592-8b2c-3bc5-4529-5a45b9c5186f@pengutronix.de>
In-Reply-To: <0729c592-8b2c-3bc5-4529-5a45b9c5186f@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d52542cd-43bf-42fe-dabc-08d861269884
x-ms-traffictypediagnostic: DB7PR04MB3962:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB396215AA6291E39AAB01C6E3E6360@DB7PR04MB3962.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:227;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /fV6kR8B82/Y56uR53pGhJrKis433l3ddcQ6tt9dKgpFV7DA/rOr1zbuOgl8LM0TplMBzDZo+D9lBuL8f3j35g4xK1+Fy3TmPU7JHCBL/VL1X/XRS0We4SxcM/vx4J27/ztjBWhwnMbu2cXBpZFkqmdixKAkAnFQlTszQ0jlkWuU8NoMrRLM46OiW4HsaTmJ2ZjHQNVnFl/kLxf1f/FCr3Ay/sI9Q+lmR57VtZyoeUoaV4mTfP5e8zVqbPqtT58Gyist2co+OKfBHesCp5k+o1mBRbVpcMzi7+yEKPhg5EQZSslx1MVYKlI5oLGeVDNk+6XZj7icW39bGBM67Azjyd393/kf29OBRhwO56xVPMzglOTSH8IAdaebMRWhE/Hb0IZNP3XJkc/4eD1oBSgeja/uvI0QDo+Ztrqo8E3WuOKOh3K+1vqSRdPv+GSWyNeCF47CDRmvA2TPf/TiRizk2w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(346002)(396003)(39860400002)(5660300002)(52536014)(66556008)(66476007)(64756008)(66946007)(66446008)(76116006)(71200400001)(8676002)(8936002)(83380400001)(9686003)(478600001)(86362001)(4326008)(33656002)(53546011)(6506007)(186003)(26005)(7696005)(966005)(110136005)(54906003)(2906002)(55016002)(316002)(83080400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: V99ygn7sKJiMgXpwO35ju3yjDHObCQtlBKCkwNHjHxNce8/pggT5DWklQOzBBYY+mq58QV0AD9UJ47ZMaNf6YXezoPGZPj+KPyM1HWqj/OQPzGcrJIrIW0zII5WK9DJov1Gx6jbn8+ey39x6e/+aCaMQ3xYBSqNCcq8nqt8qAuhYP8vrFLF4/5d7nMAfCGRHvY2wGfxXjTEF/dL+qoDn8PMPWvHp5AYvLXHOj39pcRfaf2Mf+TiKM5MgzIsaFHVsf4Rla6pX99EhU6lMpDS8HwMV3ncuLWRD1fzovTprX3jNFzChyhssFDovH0O6iSzYujBumxcwCW8QxmtbeKSJkr6dxl/66IqMQHL55kLu466kA3IWRYr7Z4ZnshaystaH+/YdaQGCmE0fe9aU2W/nyOy5TkvL3jd0/Z0NclMH3XV7sSYhnOhH3H1lCeDiWbPFDh232sFygt8gEgjg+txYXrGnsmlZEym+6vzq/+wcqP0VzSVaaLkONN9GPpGgC0E0KqAZDKLe3xXhG65eP4od4rDRaGG8r8ceRfRwCClNW2C07agq6SFCB/PK4nPwANRVEkJwObQ/aMaTVT92SNsuuMP9fcHNIyYkNUK15hyNeLTW0vtLL5YbWgTmAzyf4cm7nkMlGvMKw0ilmSkICWkwdQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d52542cd-43bf-42fe-dabc-08d861269884
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2020 07:42:46.7892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dL46O3NaiHp0B+EOlLaIRQUHyyvgMR6zRxofqE8HMRAMSuOdGFwO2qM9uNeKVGHksnp5bklM5epkrLkFoDEbPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB3962
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDlubQ55pyIMjXml6UgMTU6MzcNCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBsaW51eC1jYW5Admdl
ci5rZXJuZWwub3JnDQo+IENjOiBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsgbmV0
ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIGxpbnV4LWNhbi1uZXh0
L2ZsZXhjYW4gMi80XSBjYW46IGZsZXhjYW46IGFkZCBmbGV4Y2FuIGRyaXZlcg0KPiBmb3IgaS5N
WDhNUA0KPiANCj4gT24gOS8yNS8yMCA1OjEwIFBNLCBKb2FraW0gWmhhbmcgd3JvdGU6DQo+ID4g
QWRkIGZsZXhjYW4gZHJpdmVyIGZvciBpLk1YOE1QLCB3aGljaCBzdXBwb3J0cyBDQU4gRkQgYW5k
IEVDQy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpo
YW5nQG54cC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMgfCA5
ICsrKysrKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspDQo+ID4NCj4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYyBiL2RyaXZlcnMvbmV0L2Nh
bi9mbGV4Y2FuLmMNCj4gPiBpbmRleCBmMDJmMWRlMmJiY2EuLjhjODc1M2Y3Nzc2NCAxMDA2NDQN
Cj4gPiAtLS0gYS9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jDQo+ID4gKysrIGIvZHJpdmVycy9u
ZXQvY2FuL2ZsZXhjYW4uYw0KPiA+IEBAIC0yMTQsNiArMjE0LDcgQEANCj4gPiAgICogICBNWDUz
ICBGbGV4Q0FOMiAgMDMuMDAuMDAuMDAgICAgeWVzICAgICAgICBubyAgICAgICAgbm8NCj4gbm8g
ICAgICAgIG5vICAgICAgICAgICBubw0KPiA+ICAgKiAgIE1YNnMgIEZsZXhDQU4zICAxMC4wMC4x
Mi4wMCAgICB5ZXMgICAgICAgeWVzICAgICAgICBubw0KPiBubyAgICAgICB5ZXMgICAgICAgICAg
IG5vDQo+ID4gICAqICBNWDhRTSAgRmxleENBTjMgIDAzLjAwLjIzLjAwICAgIHllcyAgICAgICB5
ZXMgICAgICAgIG5vDQo+IG5vICAgICAgIHllcyAgICAgICAgICB5ZXMNCj4gPiArICogIE1YOE1Q
ICBGbGV4Q0FOMyAgMDMuMDAuMTcuMDEgICAgeWVzICAgICAgIHllcyAgICAgICAgbm8NCj4geWVz
ICAgICAgIHllcyAgICAgICAgICB5ZXMNCj4gPiAgICogICBWRjYxMCBGbGV4Q0FOMyAgPyAgICAg
ICAgICAgICAgIG5vICAgICAgIHllcyAgICAgICAgbm8NCj4geWVzICAgICAgIHllcz8gICAgICAg
ICAgbm8NCj4gPiAgICogTFMxMDIxQSBGbGV4Q0FOMiAgMDMuMDAuMDQuMDAgICAgIG5vICAgICAg
IHllcyAgICAgICAgbm8NCj4gbm8gICAgICAgeWVzICAgICAgICAgICBubw0KPiA+ICAgKiBMWDIx
NjBBIEZsZXhDQU4zICAwMy4wMC4yMy4wMCAgICAgbm8gICAgICAgeWVzICAgICAgICBubw0KPiBu
byAgICAgICB5ZXMgICAgICAgICAgeWVzDQo+ID4gQEAgLTM4OSw2ICszOTAsMTMgQEAgc3RhdGlj
IGNvbnN0IHN0cnVjdCBmbGV4Y2FuX2RldnR5cGVfZGF0YQ0KPiBmc2xfaW14OHFtX2RldnR5cGVf
ZGF0YSA9IHsNCj4gPiAgCQlGTEVYQ0FOX1FVSVJLX1NVUFBPUlRfRkQsDQo+ID4gIH07DQo+ID4N
Cj4gPiArc3RhdGljIHN0cnVjdCBmbGV4Y2FuX2RldnR5cGVfZGF0YSBmc2xfaW14OG1wX2RldnR5
cGVfZGF0YSA9IHsNCj4gPiArCS5xdWlya3MgPSBGTEVYQ0FOX1FVSVJLX0RJU0FCTEVfUlhGRyB8
DQo+IEZMRVhDQU5fUVVJUktfRU5BQkxFX0VBQ0VOX1JSUyB8DQo+ID4gKwkJRkxFWENBTl9RVUlS
S19VU0VfT0ZGX1RJTUVTVEFNUCB8DQo+IEZMRVhDQU5fUVVJUktfQlJPS0VOX1BFUlJfU1RBVEUg
fA0KPiA+ICsJCUZMRVhDQU5fUVVJUktfU1VQUE9SVF9GRCB8DQo+IEZMRVhDQU5fUVVJUktfU0VU
VVBfU1RPUF9NT0RFIHwNCj4gPiArCQlGTEVYQ0FOX1FVSVJLX0RJU0FCTEVfTUVDUiwNCj4gDQo+
IENhbiB5b3Ugc29ydCB0aGUgb3JkZXIgb2YgdGhlIHF1aXJrcyBieSB0aGVpciB2YWx1ZT8NCg0K
T2ssIEkgaGF2ZSBub3Qgbm90aWNlZCBzdWNoIGRldGFpbHMgYmVmb3JlLCBzb3JyeS4NCg0KQmVz
dCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+ID4gK307DQo+ID4gKw0KPiA+ICBzdGF0aWMgY29u
c3Qgc3RydWN0IGZsZXhjYW5fZGV2dHlwZV9kYXRhIGZzbF92ZjYxMF9kZXZ0eXBlX2RhdGEgPSB7
DQo+ID4gIAkucXVpcmtzID0gRkxFWENBTl9RVUlSS19ESVNBQkxFX1JYRkcgfA0KPiBGTEVYQ0FO
X1FVSVJLX0VOQUJMRV9FQUNFTl9SUlMgfA0KPiA+ICAJCUZMRVhDQU5fUVVJUktfRElTQUJMRV9N
RUNSIHwNCj4gRkxFWENBTl9RVUlSS19VU0VfT0ZGX1RJTUVTVEFNUCB8IEBADQo+ID4gLTE5MzIs
NiArMTk0MCw3IEBAIHN0YXRpYyBpbnQgZmxleGNhbl9zZXR1cF9zdG9wX21vZGUoc3RydWN0DQo+
ID4gcGxhdGZvcm1fZGV2aWNlICpwZGV2KSAgfQ0KPiA+DQo+ID4gIHN0YXRpYyBjb25zdCBzdHJ1
Y3Qgb2ZfZGV2aWNlX2lkIGZsZXhjYW5fb2ZfbWF0Y2hbXSA9IHsNCj4gPiArCXsgLmNvbXBhdGli
bGUgPSAiZnNsLGlteDhtcC1mbGV4Y2FuIiwgLmRhdGEgPQ0KPiA+ICsmZnNsX2lteDhtcF9kZXZ0
eXBlX2RhdGEsIH0sDQo+ID4gIAl7IC5jb21wYXRpYmxlID0gImZzbCxpbXg4cW0tZmxleGNhbiIs
IC5kYXRhID0NCj4gJmZzbF9pbXg4cW1fZGV2dHlwZV9kYXRhLCB9LA0KPiA+ICAJeyAuY29tcGF0
aWJsZSA9ICJmc2wsaW14NnEtZmxleGNhbiIsIC5kYXRhID0gJmZzbF9pbXg2cV9kZXZ0eXBlX2Rh
dGEsIH0sDQo+ID4gIAl7IC5jb21wYXRpYmxlID0gImZzbCxpbXgyOC1mbGV4Y2FuIiwgLmRhdGEg
PQ0KPiA+ICZmc2xfaW14MjhfZGV2dHlwZV9kYXRhLCB9LA0KPiA+DQo+IA0KPiBNYXJjDQo+IA0K
PiAtLQ0KPiBQZW5ndXRyb25peCBlLksuICAgICAgICAgICAgICAgICB8IE1hcmMgS2xlaW5lLUJ1
ZGRlICAgICAgICAgICB8DQo+IEVtYmVkZGVkIExpbnV4ICAgICAgICAgICAgICAgICAgIHwgaHR0
cHM6Ly93d3cucGVuZ3V0cm9uaXguZGUgIHwNCj4gVmVydHJldHVuZyBXZXN0L0RvcnRtdW5kICAg
ICAgICAgfCBQaG9uZTogKzQ5LTIzMS0yODI2LTkyNCAgICAgfA0KPiBBbXRzZ2VyaWNodCBIaWxk
ZXNoZWltLCBIUkEgMjY4NiB8IEZheDogICArNDktNTEyMS0yMDY5MTctNTU1NSB8DQoNCg==

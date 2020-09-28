Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E82827A569
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 04:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgI1C1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 22:27:54 -0400
Received: from mail-db8eur05on2053.outbound.protection.outlook.com ([40.107.20.53]:61057
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726328AbgI1C1y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 22:27:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bshNSY/ccg4bPbR4+2ki0taPjoDFW3ffOksQVpEEOFAR5iRQRTV0W87dJ2t8sRWq2lGJIBE9jrmtX1QuG8jZf6+k015JRxKFc/4PCrekUXkxDgFqN6dHvunmZpRjIFAXLf2zY5wrzZV9t4GVb+jVHXczOw24bIfG24IIadExyMpKgzJrKGK17wtyuh1Ij1XgMLB5+BZhP1IVuIkquSPsx3+YQmctFJTBUamWdiuzcrtJjsU3ts26AYOtV8XTFDKwnuHl/AEkur/ePJ+3sRM0LKztlGoAHgxlRIv8z8GAZJfMdIFwf6OWvtLPI1f5dA8+5T6a5edVFAbtd74q2NcJkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVPfTzXjeT2i6DsA2YXKpIAQCer2ApRyV8OOg+4MByQ=;
 b=H6Ba2kEdbH9k4g6K94R34PbP3BBpFNgtEORQreb550DYM5N7KgRkj1LivXJIbfrFlJtCjLsLmnPdez+FC18/aSWGpRmc0VnCcytNx2WB60fK1KHMbaGbWnVcGIl3OUgmlfWw3jBUWc6v2nSMcGbO1K7xMbHAARv+7Qyd+h1hy/TA2WkYEzwRbmdxeY3+4cv2yK6uzwENrP8xOeMnftirP3T6fISz/cEq+9cKgkNq7EAzBsOu2ENVW9O1fYbAJIdaJOTkXMrd7fztkTFYLcTCkzW9/eG5SVydJ5ZMik8n9Nj5ZYq8foV6ESQxDFzQUEfJeJ+uOV6i/iCLvksPrtP5Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVPfTzXjeT2i6DsA2YXKpIAQCer2ApRyV8OOg+4MByQ=;
 b=cChtAzy68TuKzVrxQGJHMcpVTkEmk9+qugdKk4KOaWTCB1j8yARihmAsYxIhMKijnt5zbkwTdfQH5nVbWBQAasJYh+cSKen7U6sdaZIqmzyPi55yalRus17GHhES+czpZTnQIkZccjzeBf+Q63knR6ewiU+MC75VYaI+yMYlKlY=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5788.eurprd04.prod.outlook.com (2603:10a6:10:b1::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Mon, 28 Sep
 2020 02:27:49 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.029; Mon, 28 Sep 2020
 02:27:49 +0000
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
Thread-Index: AQHWkwrxc33Q4pOyMEiSJX13xMzIVal49QgAgAMfcACAANYAAIAAZbng
Date:   Mon, 28 Sep 2020 02:27:49 +0000
Message-ID: <DB8PR04MB679574C44EC1B2D401C9B5D1E6350@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20200925151028.11004-1-qiangqing.zhang@nxp.com>
 <20200925151028.11004-2-qiangqing.zhang@nxp.com>
 <f98dcb18-19f9-9721-a191-481983158daa@pengutronix.de>
 <DB8PR04MB6795C88B839FE5083283E157E6340@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <4490a094-0b7d-4361-2c0a-906b2cff6020@pengutronix.de>
In-Reply-To: <4490a094-0b7d-4361-2c0a-906b2cff6020@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: pankaj.bansal@nxp.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 270c1081-45a1-470b-80c6-08d8635617f5
x-ms-traffictypediagnostic: DB8PR04MB5788:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB5788C7AA40B7D4E4F1055C91E6350@DB8PR04MB5788.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AiWIY7rxhGPL5e8anHlC5vOJEnplaD8BZeO3A6Ig3Px3FaCy4yGmzWwulT4doUQCKDY0xd6STKz09jCTpkX43vj1YpVo8aLv9cPw8j0sJx8L+GyFkVMmCo5aERH1xQKORgYo9F9HLRGojtUhsZumpKv2/CR17urgvCNKbrT62AcAbiYk8AP35y61cAgIU9EQlNaTc2THXS+UadZSZmt0atXWpgEnzF2wbIwKXb1y9szNpFsPL6E9qG7Xr2UA8iY+CG1Vie6mFrKM9/Gvk46WNQ+BcB8vBOGR25sjKWshxBbWIkB159T/WTXAvPLYsVjqkFS2p407g12xZQzlmAWsPqM2F9U8IToBzC+JKebNVsAwKQ+zR+AmubZOJdupQ/jKrfj5qJZ/W5T0A9tE1ah0A8fC0ATTAo3MNSNwZedBwXXZafHXxrNbvSTn7gmbAk5KkFrSWKnc9SwaPqFS19/DAw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(346002)(366004)(136003)(9686003)(76116006)(66446008)(64756008)(6636002)(4326008)(8676002)(66556008)(66476007)(54906003)(7696005)(83380400001)(66946007)(186003)(55016002)(8936002)(52536014)(83080400001)(316002)(110136005)(26005)(478600001)(33656002)(5660300002)(86362001)(966005)(71200400001)(2906002)(53546011)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: pAYGTy9+L7XVZbzxSgz4Mf3XdDF2HvHJoOLrD2Rl5tmSTuFu0jv698SiRrGwgP/Dz/uxhvHNusxHKEf/pUnGNFRRse/Fabttj9kUA1idvlfOy0u7M1jJEX58e09Y32xbHAlp9VmHeJqJaKvae1ASxQVOMDHp7tP5tqcX3Lm9V6k4izpmoL9ObvhijMnj2v2UU084ClHfKGJTdHeUj+7vP38pi8vnEndVg3DFlHtcRF3AIQ2CiNtuUMFuKS+i2YShNwfFk0snURvu9aKqym2L/vvYhsCRWRjDUxT9YxOjXW5iQTfzQLTUf6r5tG7nuI8268yX0s132nsmJ+mpj8HnfWxyjws52ybVpTuFs3sbwmg8z92pnJPFFOpUmjxA0fBZyNrLGctozhbFteLuWq6j2Ww5SJhwlf3YQvwtm30r7396EQ0tefZ80iNXr3psyJ0CKZxn8omcPbUBze8nI3INxI6wE9V4ITPkletEdmDKWKl8r17x3poNtunaJm4bqif7/XFR4bhWbP3xzGjp/prDB2OQ/SYAUApMAxThFaJNUm80k9jMWcgY41uSWTVVFDPTdEFU66ahKgw8PL+b//tZ6oXK6/k84SP4WOJuzhAgUQTglWVE9qOq4rGN0h6EY/jwzSTNnAW/aziEqAy2ZOq6ZA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 270c1081-45a1-470b-80c6-08d8635617f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2020 02:27:49.2082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kYOpm/fNH0awlbeZotuckjoz9iVTx3sITWoBqwAGSGuoV81HaMbw/8LqBOqtshqswvNUurzE3bQhX6NExK2XDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5788
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDlubQ55pyIMjjml6UgMzo1Ng0KPiBU
bzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT47IGxpbnV4LWNhbkB2Z2Vy
Lmtlcm5lbC5vcmcNCj4gQ2M6IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+OyBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbGludXgtY2FuLW5leHQv
ZmxleGNhbiAxLzRdIGNhbjogZmxleGNhbjogaW5pdGlhbGl6ZSBhbGwgZmxleGNhbg0KPiBtZW1v
cnkgZm9yIEVDQyBmdW5jdGlvbg0KPiANCj4gT24gOS8yNy8yMCAxMDowMSBBTSwgSm9ha2ltIFpo
YW5nIHdyb3RlOg0KPiA+IFsuLi5dDQo+ID4+IENhbiB5b3UgY3JlYXRlIGEgInN0YXRpYyBjb25z
dCBzdHJ1Y3QiIGhvbGRpbmcgdGhlIHJlZyAob3Igb2Zmc2V0KSArDQo+ID4+IGxlbiBhbmQgbG9v
cCBvdmVyIGl0LiBTb21ldGhpbmcgbGlua2UgdGhpcz8NCj4gPj4NCj4gPj4gY29uc3Qgc3RydWN0
IHN0cnVjdCBmbGV4Y2FuX3JhbV9pbml0IHJhbV9pbml0W10gew0KPiA+PiAJdm9pZCBfX2lvbWVt
ICpyZWc7DQo+ID4+IAl1MTYgbGVuOw0KPiA+PiB9ID0gew0KPiA+PiAJew0KPiA+PiAJCS5yZWcg
PSByZWdzLT5tYiwJLyogTUIgUkFNICovDQo+ID4+IAkJLmxlbiA9IHNpemVvZihyZWdzLT5tYiks
IC8gc2l6ZW9mKHUzMiksDQo+ID4+IAl9LCB7DQo+ID4+IAkJLnJlZyA9IHJlZ3MtPnJ4aW1yLAkv
KiBSWElNUiBSQU0gKi8NCj4gPj4gCQkubGVuID0gc2l6ZW9mKHJlZ3MtPnJ4aW1yKSwNCj4gPj4g
CX0sIHsNCj4gPj4gCQkuLi4NCj4gPj4gCX0sDQo+ID4+IH07DQo+ID4NCj4gPiBJbiB0aGlzIHZl
cnNpb24sIEkgb25seSBpbml0aWFsaXplIHRoZSBpbXBsZW1lbnRlZCBtZW1vcnksIHNvIHRoYXQN
Cj4gPiBpdCdzIGEgc2V2ZXJhbCB0cml2aWFsIG1lbW9yeSBzbGljZSwgcmVzZXJ2ZWQgbWVtb3J5
IG5vdCBpbml0aWFsaXplZC4NCj4gPiBGb2xsb3cgeW91ciBwb2ludCwgSSBuZWVkIGNyZWF0ZSBh
IGdsb2JhbCBwb2ludGVyIGZvciBzdHJ1Y3QNCj4gPiBmbGV4Y2FuX3JlZywgaS5lLiBzdGF0aWMg
c3RydWN0IGZsZXhjYW5fcmVncyAqcmVnLCBzbyB0aGF0IHdlIGNhbiB1c2UNCj4gPiAucmVnID0g
cmVncy0+bWIgaW4gcmFtX2luaXRbXSwgSU1ITywgSSBkb24ndCBxdWl0ZSB3YW50IHRvIGFkZCB0
aGlzLA0KPiA+IG9yIGlzIHRoZXJlIGFueSBiZXR0ZXIgc29sdXRpb24gdG8gZ2V0IHRoZSByZWcv
bGVuIHZhbHVlPw0KPiANCj4gT25lIG9wdGlvbiBpcyBub3QgdG8gbWFrZSBpdCBhIGdsb2JhbCB2
YXJpYWJsZSwgYnV0IHRvIG1vdmUgaXQgaW50byB0aGUgZnVuY3Rpb24sDQo+IHRoZW4geW91IGhh
dmUgdGhlIHJlZyBwb2ludGVyIGF2YWlsYWJsZS4NCg0KV2lsbCB0YWtlIGludG8gYWNjb3VudCBp
ZiBsYXRlciB3ZSBhbHNvIG5lZWQgaW1wbGVtZW50IHRoaXMgc3RydWN0Lg0KDQo+ID4gQWNjb3Jk
aW5nIHRvIGJlbG93IG5vdGVzIGFuZCBkaXNjdXNzZWQgd2l0aCBJUCBvd25lciBiZWZvcmUsIHJl
c2VydmVkDQo+ID4gbWVtb3J5IGFsc28gY2FuIGJlIGluaXRpYWxpemVkLiBTbyBJIHdhbnQgdG8g
YWRkIHR3byBtZW1vcnkgcmVnaW9ucywNCj4gPiBhbmQgaW5pdGlhbGl6ZSB0aGVtIHRvZ2V0aGVy
LCB0aGlzIGNvdWxkIGJlIG1vcmUgY2xlYW4uIEkgd2lsbCBzZW5kDQo+ID4gb3V0IGEgVjIsIHBs
ZWFzZSBsZXQgbWUga25vdyB3aGljaCBvbmUgZG8geW91IHRoaW5rIGlzIGJldHRlcj8NCj4gDQo+
IElmIGl0J3MgT0sgb24gYWxsIFNvQ3MgdG8gaW5pdGlhbGl6ZSB0aGUgY29tcGxldGUgUkFNIGFy
ZWEsIGp1c3QgZG8gaXQuIFRoZW4gd2UgY2FuDQo+IGdldCByaWQgb2YgdGhlIHByb3Bvc2VkIHN0
cnVjdCBhdCBhbGwuDQoNClNob3VsZCBiZSBPSyBhY2NvcmRpbmcgdG8gSVAgZ3V5cyBmZWVkYmFj
a3MuDQoNCkkgYW0gY2hlY2tpbmcgbGF5ZXJzY2FwZSdzIENBTiBzZWN0aW9uOg0KDQpUaGVyZSBp
cyBubyBFQ0Mgc2VjdGlvbiBpbiBMUzEwMjFBIA0KaHR0cHM6Ly93d3cubnhwLmNvbS9wcm9kdWN0
cy9wcm9jZXNzb3JzLWFuZC1taWNyb2NvbnRyb2xsZXJzL2FybS1wcm9jZXNzb3JzL2xheWVyc2Nh
cGUtbXVsdGljb3JlLXByb2Nlc3NvcnMvbGF5ZXJzY2FwZS0xMDIxYS1kdWFsLWNvcmUtY29tbXVu
aWNhdGlvbnMtcHJvY2Vzc29yLXdpdGgtbGNkLWNvbnRyb2xsZXI6TFMxMDIxQT90YWI9RG9jdW1l
bnRhdGlvbl9UYWINCg0KDQpFQ0Mgc2VjdGlvbiBpbiBMWDIxNjBBLCBhbHNvIGNvbnRhaW5zIHRo
ZSBzYW1lIE5PVEUgYXMgaS5NWDhNUC4NCmh0dHBzOi8vd3d3Lm54cC5jb20vcHJvZHVjdHMvcHJv
Y2Vzc29ycy1hbmQtbWljcm9jb250cm9sbGVycy9hcm0tcHJvY2Vzc29ycy9sYXllcnNjYXBlLW11
bHRpY29yZS1wcm9jZXNzb3JzL2xheWVyc2NhcGUtbHgyMTYwYS1tdWx0aWNvcmUtY29tbXVuaWNh
dGlvbnMtcHJvY2Vzc29yOkxYMjE2MEE/dGFiPURvY3VtZW50YXRpb25fVGFiDQoNCg0KSGkgQFBh
bmthaiBCYW5zYWwsIGNvdWxkIHlvdSBwbGVhc2UgYWxzbyBoYXZlIGEgY2hlY2s/DQoNCkJlc3Qg
UmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiA+ICJDVFJMMltXUk1GUlpdIGdyYW50cyB3cml0ZSBh
Y2Nlc3MgdG8gYWxsIG1lbW9yeSBwb3NpdGlvbnMgdGhhdA0KPiA+IHJlcXVpcmUgaW5pdGlhbGl6
YXRpb24sIHJhbmdpbmcgZnJvbSAweDA4MCB0byAweEFERiBhbmQgZnJvbSAweEYyOCB0bw0KPiA+
IDB4RkZGIHdoZW4gdGhlIENBTiBGRCBmZWF0dXJlIGlzIGVuYWJsZWQuIFRoZSBSWE1HTUFTSywg
UlgxNE1BU0ssDQo+ID4gUlgxNU1BU0ssIGFuZCBSWEZHTUFTSyByZWdpc3RlcnMgbmVlZCB0byBi
ZSBpbml0aWFsaXplZCBhcyB3ZWxsLg0KPiA+IE1DUltSRkVOXSBtdXN0IG5vdCBiZSBzZXQgZHVy
aW5nIG1lbW9yeSBpbml0aWFsaXphdGlvbi4iDQo+IA0KPiBNYXJjDQo+IA0KPiAtLQ0KPiBQZW5n
dXRyb25peCBlLksuICAgICAgICAgICAgICAgICB8IE1hcmMgS2xlaW5lLUJ1ZGRlICAgICAgICAg
ICB8DQo+IEVtYmVkZGVkIExpbnV4ICAgICAgICAgICAgICAgICAgIHwgaHR0cHM6Ly93d3cucGVu
Z3V0cm9uaXguZGUgIHwNCj4gVmVydHJldHVuZyBXZXN0L0RvcnRtdW5kICAgICAgICAgfCBQaG9u
ZTogKzQ5LTIzMS0yODI2LTkyNCAgICAgfA0KPiBBbXRzZ2VyaWNodCBIaWxkZXNoZWltLCBIUkEg
MjY4NiB8IEZheDogICArNDktNTEyMS0yMDY5MTctNTU1NSB8DQoNCg==

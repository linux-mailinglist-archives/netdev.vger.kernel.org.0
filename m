Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4583227A6EE
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 07:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgI1FXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 01:23:32 -0400
Received: from mail-eopbgr130084.outbound.protection.outlook.com ([40.107.13.84]:46726
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726328AbgI1FXc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 01:23:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iv7fM+T5T9MytPTXuK13WI8XA+KZr+XP2HaagRTZjq2KVxSANOHP+CyGUjQJT1qqE+ojtDN0673bbQnoDL2+sjZKIr9i7jT36yNaEDBTsPBjFPldaUJhpbk9d3/exEF2wQzmWb3jwDA9GlJo4pO6A+dh/kbF+brTMEWmMj+NYhvKomVhNUnjW+57vQK6hYHcY1Varigrqf/hPcBp7xnF+onJinoylWp8dYI62lZs842BJHcGDNrpwVA/fq9bGcun1yw0VY3iarBBIf4kEavLN4Jzc3kPUyR26NsHU3gvp7LU76r+Qob+bFwQBeMr/Hlk/RqYWGWJ5bH8JrnaqZjJdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2o060IORDJP2i5pPxeYYmALqstrOP/Z48SK/dfhUazs=;
 b=MlodlLYVhtK6ZcW5TWRZTwO9aBSUCRGdkIjo/5IaO8vfhZWu3ysGZ7xkix1mjUnuOfgz++E6EYYwL5ef6BIMKPI/M2texElTHcIu+hf608e2vBG1Q0vNprLxkSNkYG27SSimYzNwk0GxK1e2U1H55T4e5+bjI2NhUBsTRVXHirWl2PkbGcWrL6Wl69fxxsB3G/9scQGRHPAzn7RlEk7gerNwNuR7dregNy1KfjrAVqV7RwNRfEg1HpYxXRAxQ0ZHbPSi0qGqobZ+WCiEtJWKbvL9LmD9njV08ohi67SAbM+It5I6K2iIyA7Pu2EQH7MlU8EUWtrlBxZtB798uGeo8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2o060IORDJP2i5pPxeYYmALqstrOP/Z48SK/dfhUazs=;
 b=M6h0/eHXrDi7CNHBOc7aBDA+Ok/eOlbpaGxDWJqkDsRLNC79p+94Aolh9+ao6xbgGEcYJGPQIY5vxhH/yYckn2kaCXsextPbTtXBrhqwWPlroiAs33Ir5fGxK5A235VXvXhSDDBa3BJ7HQqY18C3gh2jsHGPa4qjae3VljPi8fk=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3850.eurprd04.prod.outlook.com (2603:10a6:8:3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Mon, 28 Sep
 2020 05:23:27 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.029; Mon, 28 Sep 2020
 05:23:27 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH V2 1/3] can: flexcan: initialize all flexcan memory for
 ECC function
Thread-Topic: [PATCH V2 1/3] can: flexcan: initialize all flexcan memory for
 ECC function
Thread-Index: AQHWlKVNGxBuk+dVOE+HzIioencc0Kl8564AgABtCyCAACsuQA==
Date:   Mon, 28 Sep 2020 05:23:26 +0000
Message-ID: <DB8PR04MB67953242A9B727F851B7466CE6350@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20200927160801.28569-1-qiangqing.zhang@nxp.com>
 <20200927160801.28569-2-qiangqing.zhang@nxp.com>
 <34240503-1d9e-9b8c-cdd0-28482ea60fbf@pengutronix.de>
 <DB8PR04MB6795C350DB0CCFF56787561CE6350@DB8PR04MB6795.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB6795C350DB0CCFF56787561CE6350@DB8PR04MB6795.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bf5753d0-bf1a-4e53-6f4a-08d8636ea0ed
x-ms-traffictypediagnostic: DB3PR0402MB3850:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB3PR0402MB385058C3005D647256758902E6350@DB3PR0402MB3850.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gbt5qcyx3/XRY496JOf9otb9r99BjgcEozwPXeHH22+yYn9UeB/g5CqKcdcZbQGeN+iM6hG4qnN3X2HRByavJ4lmboxnQtARgC5h75RA+DtfEZeo1hlJ8rspFO9INTmDED9ChhPuy9cCadHD1VdfWKW6+zMaTzRQ31oFjY2CWlGA2vzgqmTZ4Qqo0DSdHnVqkS5YeM3sZZbwCxTeBEGt0zuKGRF3/D7poBRJgIc/tnnpA5UxhB+Kv/S6eqyImbZEowT2789rmODE1o+Jk7yp7zMubZijOKc4sM02LHVHGGzou7cWuRc9TzGic18HStq1j6gG02eQS7gtZnb8Ok/XrVG5m/irWJ+1BL00ELw8v5myEYLHPbwQt9VGkjhuZBu/b9ZZElPz27X/oEQg7dZ0Qg8wexzlpvWZm6NifjV2Qx4ZB2+aslkQ7eSDYtOxnDi3xdbOk8/PMHTCgFz4hqh9pg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(66446008)(966005)(4326008)(2906002)(86362001)(316002)(110136005)(8936002)(478600001)(8676002)(2940100002)(33656002)(54906003)(76116006)(64756008)(66556008)(66476007)(66946007)(5660300002)(6506007)(53546011)(26005)(186003)(7696005)(52536014)(83380400001)(55016002)(9686003)(83080400001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: HWEw1Y/GALneTAIuqWINHxyjRlfoxhEdd+rg09wG2bkHuc9P+wg8KZGgxdeduFHUssGHTX9vWXQ3mxhOpjPw3gnQDDxjFUwqRS+1VhyckI0ubhhjfpAGcdb86UKM+Pi+qievspMBoZ7v9AP4fq16mJs146jHkea05ri14Y0NJ6tdxN+L17AWPz84ImsYZTv4t+r5RjgQBUz0cZox43kOrzIY3e3yNTeJNnc4Usq/cirHbdxyWacvuJmDIzubMsrt0Yh5evaE01LwpSt5JHN+8++XVxguK4xIAxXoR3Qrs6DVdu7ZkhwSRPFZZ2YCDwICyLyfsqVq5bad9I6sIBaMLNdSbDAt3ijH5RvA0Vo70jnk/Ypt+1PRpadzdQppDNmhirLjqXXr5IG5P/5E4bY5FJYm0sweI7wh8QEDSGyyjhUsYOfG8/dTrfHQ5lx1lP3vV9mFFU3807wu2RpV4zc0KE2+sUNM2fzAZ9loxYNStBzxJsbuhAl8eelSDWwhZSZtOp8lWF1KrDl0MAIsch/NY+j1IjlK/f/FOCY7dxELkKtCqi010xJ7IghAKLkDNJ/U6qkgHKUFAv9dJ8dZ5A2YDI1JZECNloAPzRm2fsWkcGvkJESOJvLLCvrxsr6Ee/LekskQdaTQQ8t345F/yTCpSA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf5753d0-bf1a-4e53-6f4a-08d8636ea0ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2020 05:23:26.9536
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LhyFf5Dzva03i0bbs2uyIZYwcwsVTxoGdgbc95uWTVmXWlbZO5R/5frp4mnwlxh3h3hWd1iDdxPuCUm0JVfg4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3850
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvYWtpbSBaaGFuZyA8cWlh
bmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IFNlbnQ6IDIwMjDlubQ55pyIMjjml6UgMTA6MjkNCj4g
VG86IE1hcmMgS2xlaW5lLUJ1ZGRlIDxta2xAcGVuZ3V0cm9uaXguZGU+OyBsaW51eC1jYW5Admdl
ci5rZXJuZWwub3JnDQo+IENjOiBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsgbmV0
ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSRTogW1BBVENIIFYyIDEvM10gY2FuOiBm
bGV4Y2FuOiBpbml0aWFsaXplIGFsbCBmbGV4Y2FuIG1lbW9yeSBmb3IgRUNDDQo+IGZ1bmN0aW9u
DQo+IA0KPiANCj4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+IEZyb206IE1hcmMg
S2xlaW5lLUJ1ZGRlIDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+ID4gU2VudDogMjAyMOW5tDnmnIgy
OOaXpSAzOjU4DQo+ID4gVG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+
OyBsaW51eC1jYW5Admdlci5rZXJuZWwub3JnDQo+ID4gQ2M6IGRsLWxpbnV4LWlteCA8bGludXgt
aW14QG54cC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+ID4gU3ViamVjdDogUmU6IFtQ
QVRDSCBWMiAxLzNdIGNhbjogZmxleGNhbjogaW5pdGlhbGl6ZSBhbGwgZmxleGNhbg0KPiA+IG1l
bW9yeSBmb3IgRUNDIGZ1bmN0aW9uDQo+ID4NCj4gPiBPbiA5LzI3LzIwIDY6MDcgUE0sIEpvYWtp
bSBaaGFuZyB3cm90ZToNCj4gPiBbLi4uXQ0KPiA+DQo+ID4gPiArc3RhdGljIHZvaWQgZmxleGNh
bl9pbml0X3JhbShzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KSB7DQo+ID4gPiArCXN0cnVjdCBmbGV4
Y2FuX3ByaXYgKnByaXYgPSBuZXRkZXZfcHJpdihkZXYpOw0KPiA+ID4gKwlzdHJ1Y3QgZmxleGNh
bl9yZWdzIF9faW9tZW0gKnJlZ3MgPSBwcml2LT5yZWdzOw0KPiA+ID4gKwl1MzIgcmVnX2N0cmwy
Ow0KPiA+ID4gKwlpbnQgaTsNCj4gPiA+ICsNCj4gPiA+ICsJLyogMTEuOC4zLjEzIERldGVjdGlv
biBhbmQgY29ycmVjdGlvbiBvZiBtZW1vcnkgZXJyb3JzOg0KPiA+ID4gKwkgKiBDVFJMMltXUk1G
UlpdIGdyYW50cyB3cml0ZSBhY2Nlc3MgdG8gYWxsIG1lbW9yeSBwb3NpdGlvbnMgdGhhdA0KPiA+
ID4gKwkgKiByZXF1aXJlIGluaXRpYWxpemF0aW9uLCByYW5naW5nIGZyb20gMHgwODAgdG8gMHhB
REYgYW5kDQo+ID4gPiArCSAqIGZyb20gMHhGMjggdG8gMHhGRkYgd2hlbiB0aGUgQ0FOIEZEIGZl
YXR1cmUgaXMgZW5hYmxlZC4NCj4gPiA+ICsJICogVGhlIFJYTUdNQVNLLCBSWDE0TUFTSywgUlgx
NU1BU0ssIGFuZCBSWEZHTUFTSw0KPiByZWdpc3RlcnMNCj4gPiBuZWVkIHRvDQo+ID4gPiArCSAq
IGJlIGluaXRpYWxpemVkIGFzIHdlbGwuIE1DUltSRkVOXSBtdXN0IG5vdCBiZSBzZXQgZHVyaW5n
IG1lbW9yeQ0KPiA+ID4gKwkgKiBpbml0aWFsaXphdGlvbi4NCj4gPiA+ICsJICovDQo+ID4gPiAr
CXJlZ19jdHJsMiA9IHByaXYtPnJlYWQoJnJlZ3MtPmN0cmwyKTsNCj4gPiA+ICsJcmVnX2N0cmwy
IHw9IEZMRVhDQU5fQ1RSTDJfV1JNRlJaOw0KPiA+ID4gKwlwcml2LT53cml0ZShyZWdfY3RybDIs
ICZyZWdzLT5jdHJsMik7DQo+ID4gPiArDQo+ID4gPiArCWZvciAoaSA9IDA7IGkgPCByYW1faW5p
dFswXS5sZW47IGkrKykNCj4gPiA+ICsJCXByaXYtPndyaXRlKDAsICh2b2lkIF9faW9tZW0gKily
ZWdzICsgcmFtX2luaXRbMF0ub2Zmc2V0ICsNCj4gPiA+ICtzaXplb2YodTMyKSAqIGkpOw0KPiA+
DQo+ID4gQXMgdGhlIHdyaXRlIGZ1bmN0aW9uIG9ubHkgZG9lcyBlbmRpYW4gY29udmVyc2lvbiwg
YW5kIHlvdSdyZSB3cml0aW5nIDAgaGVyZS4NCj4gPiBXaGF0IGFib3V0IHVzaW5nIGlvd3JpdGUz
Ml9yZXAoKSBhbmQgZ2V0IHJpZCBvZiB0aGUgZm9yIGxvb3A/DQo+IA0KPiBUaGFua3MgZm9yIHRo
aXMgcG9pbnQsIEkgd2lsbCB1cGRhdGUgaW4gbmV4dCB2ZXJzaW9uLg0KDQpBaGhoLi4gSSBjaGVj
ayBpb3dyaXRlMzJfcmVwKCkgd3JpdGVzIGEgYnVmIHRvIHNpbmdsZSBhZGRyZXNzLCBubyBzaGlm
dCBmb3IgYWRkcmVzcy4NCg0KSSBwcmVmZXIgdG8gdXNlIG1lbXNldF9pbygpIGhlcmUgdG8gaW5p
dGlhbGl6ZSBhIGJsb2NrIG9mIGlvIG1lbW9yeS4gV2hhdCBkbyB5b3UgdGhpbms/DQoNCkJlc3Qg
UmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiBCZXN0IFJlZ2FyZHMsDQo+IEpvYWtpbSBaaGFuZw0K
PiA+IE1hcmMNCj4gPg0KPiA+IC0tDQo+ID4gUGVuZ3V0cm9uaXggZS5LLiAgICAgICAgICAgICAg
ICAgfCBNYXJjIEtsZWluZS1CdWRkZSAgICAgICAgICAgfA0KPiA+IEVtYmVkZGVkIExpbnV4ICAg
ICAgICAgICAgICAgICAgIHwgaHR0cHM6Ly93d3cucGVuZ3V0cm9uaXguZGUgIHwNCj4gPiBWZXJ0
cmV0dW5nIFdlc3QvRG9ydG11bmQgICAgICAgICB8IFBob25lOiArNDktMjMxLTI4MjYtOTI0ICAg
ICB8DQo+ID4gQW10c2dlcmljaHQgSGlsZGVzaGVpbSwgSFJBIDI2ODYgfCBGYXg6ICAgKzQ5LTUx
MjEtMjA2OTE3LTU1NTUgfA0KDQo=

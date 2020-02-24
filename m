Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3895F16A34D
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 10:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbgBXJ6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 04:58:20 -0500
Received: from mail-vi1eur05on2075.outbound.protection.outlook.com ([40.107.21.75]:6030
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726509AbgBXJ6T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 04:58:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KTheHdeR3jYQ3lLDEzzex3BafK6MD1BfonVCIQ3msjdDesO1H25PxjIN8vDBLPV3IhQnS8Ng7P/tl5DOZTU00eddKLB1Xbq9lpjkp6DsApSOi19rlq70KbQ4ggT7b7bySu+Pzq/48hV3Y/2r4nQ55M/9Qb3jiIB0k4iuZhJ3Og55uN4XME0DIl3p9Gg3lfWmL7RGPKX+jPWIa/fO2Mt4pvxqtu4gstcL7QsbiSgoP3O0thxyGU+ie4qoNpODFTC8dt7GMxAmkDFxp4oXcDrqI+POLY8OZFX3VzQbDU7miMKJDrfk437YoXogJ5iQvFa50cHmN+1nw5L5EDhSnUbcZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iICpaRUeQe02FhRtUBUU8r9OShvQzlYekArzndqcVDA=;
 b=kUTBkPrl2Y+j2w7E+2GxPlTtdnk0qBZ/BAw8okWsJYQr7NV9/eTJGzujYNozZueaFlRyGwNtf7+ETB+N2ymrlm9LrGsA1XswchkkJz9If9urUcuRDNVvsr4Yr0ux3rIDmrnHByfXxBg18BPoVu/AZzeKylC+oYZA2wtDJwOJ6j2IMOIPmnNZn8pliC9oESLKanAr3OcxT3yQoj3H7/lctqPhE6u1twwDebW+Z94vAqVVGsNHnfAAL752zpCmSz5+RLTofd6agAgVc/x3Q7oExiAw+jlZIw/nb8dXA4+Pxt5ZdG/wiz3v4v0fgXYEC8fBkB5Z6+KXBrCenRBwgyYcsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iICpaRUeQe02FhRtUBUU8r9OShvQzlYekArzndqcVDA=;
 b=tD0CrrvX9sv51lN9M2K9ELRVYI270vhj2tdhkFDbUo2qU3NnLDCps4mAGDbsteOvpURtB1/iAz8J8rI1CAzp9+uepoC7EnPlMlywyF1+VDhxNgnTxnQLHLXsUrm/6M5sWRuyMBMlhtb/AGrArPSD84df7y4AW2KQKYHkwNsT1R8=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5499.eurprd04.prod.outlook.com (20.178.106.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Mon, 24 Feb 2020 09:58:14 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::5cb4:81c8:1618:5ca]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::5cb4:81c8:1618:5ca%7]) with mapi id 15.20.2750.021; Mon, 24 Feb 2020
 09:58:14 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Michael Walle <michael@walle.cc>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>
Subject: RE: [PATCH 0/8] can: flexcan: add CAN FD support for NXP Flexcan
Thread-Topic: [PATCH 0/8] can: flexcan: add CAN FD support for NXP Flexcan
Thread-Index: AQHVOIgqonFULiHPO0eSKFSJ3ULGeqbbAsWQgAAINwCAAC3BgIE/m36AgABmuxCAAHloAIAAB/CAgA/DrmA=
Date:   Mon, 24 Feb 2020 09:58:14 +0000
Message-ID: <DB7PR04MB4618AE719492AC3326468402E6EC0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <24eb5c67-4692-1002-2468-4ae2e1a6b68b@pengutronix.de>
 <20200213192027.4813-1-michael@walle.cc>
 <DB7PR04MB461896B6CC3EDC7009BCD741E6150@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <2322fb83486c678917957d9879e27e63@walle.cc>
 <DB7PR04MB46187A6B5A8EC3A1D73D69FFE6150@DB7PR04MB4618.eurprd04.prod.outlook.com>
In-Reply-To: <DB7PR04MB46187A6B5A8EC3A1D73D69FFE6150@DB7PR04MB4618.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [222.93.202.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 172bdbe0-ee3b-4a3e-e749-08d7b910107a
x-ms-traffictypediagnostic: DB7PR04MB5499:|DB7PR04MB5499:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5499E22A97A8CCA0DD3B43D4E6EC0@DB7PR04MB5499.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 032334F434
x-forefront-antispam-report: SFV:NSPM;SFS:(10001)(10009020)(4636009)(39860400002)(366004)(346002)(136003)(396003)(376002)(199004)(189003)(316002)(71200400001)(26005)(52536014)(6506007)(966005)(55016002)(478600001)(86362001)(2906002)(7696005)(66946007)(186003)(45080400002)(53546011)(9686003)(81156014)(8936002)(81166006)(8676002)(5660300002)(54906003)(4326008)(33656002)(110136005)(66556008)(66476007)(66446008)(64756008)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5499;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z7KwhkBcqd+tAYmQfmP3DUBw/4DrIKPxgPgnhru2rH+bcQR5P34mOil+XLPYghRUbOelfkqkqu10YXd3H5NBbs4jGghQ5tr/kXEsCMna+F8I0RutGKsTX/SYNY7qFuu9dgftC91u8GPF4g+tbn4+aU44wA6gwvKvBLBPyjlo+/f1EzJ/0CMr9iyTZqJ+NC2Q2ONNNjrOj6HkUIJlNsWHRr6rF3+JvyoLxmkICsHBZR2R/IFggs75wV9QvVAWawNGvqmqrNdVmbm5gMnE+nDmbkd0fXQTf9TCYFuvjJ7p4nfrdSmgQxY96RnRgxZl/BLvKqTeAsnD6WsyJriBEG+N47Rk9lp/PSM9zW18qjLpJQxZgLQvmMSOcWfxV8T6h6aJ+Z7Egsk0jmuh+djezq2JSni2z3gLpw6Ib2ND5ZPSbB9ue8NspioJAgBVoyEMsOrOtWZGU37pwZLwJsOPkogSJnWrF1dxYdHC8vYZlr2SnWpgXKnzzpDlVXLIqKKI6tzYEBQtrDeGMcIi6SgJobd99pfADScb4auvgJTpSxSjaKe7UFp92QVYQrBnm1hAsxQU3cPMDzkF3GcXpmpjzhni9lgWLuu9kwuznpVc/BMePqnIIxDae5k8l4Nn8rVYtX7i
x-ms-exchange-antispam-messagedata: Wj9yd7GT+S5yqGIr1bZ+yN0uZH90uepgVRaSEcrg1ZBPoOWWnHLluxaXqCiq/LbTH5v1+wJyIDt+dw7Opo5/n9CxmZIufpDzCU4okwF149BNJZOsSuNU9A5CXakRlxW4+w+35/AYAK154fFMobIvGA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 172bdbe0-ee3b-4a3e-e749-08d7b910107a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2020 09:58:14.2270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mDwAg31KAKhopMwexYiMjxsywSGxsoKWFP66+awsBcJccvlS0Rq2kENz/WBpiygMCDa/cpPb3pi61SVltj/qJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5499
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IGxpbnV4LWNhbi1vd25lckB2
Z2VyLmtlcm5lbC5vcmcgPGxpbnV4LWNhbi1vd25lckB2Z2VyLmtlcm5lbC5vcmc+DQo+IE9uIEJl
aGFsZiBPZiBKb2FraW0gWmhhbmcNCj4gU2VudDogMjAyMOW5tDLmnIgxNOaXpSAxNzoxOA0KPiBU
bzogTWljaGFlbCBXYWxsZSA8bWljaGFlbEB3YWxsZS5jYz4NCj4gQ2M6IE1hcmMgS2xlaW5lLUJ1
ZGRlIDxta2xAcGVuZ3V0cm9uaXguZGU+OyB3Z0BncmFuZGVnZ2VyLmNvbTsNCj4gbmV0ZGV2QHZn
ZXIua2VybmVsLm9yZzsgbGludXgtY2FuQHZnZXIua2VybmVsLm9yZzsgUGFua2FqIEJhbnNhbA0K
PiA8cGFua2FqLmJhbnNhbEBueHAuY29tPg0KPiBTdWJqZWN0OiBSRTogW1BBVENIIDAvOF0gY2Fu
OiBmbGV4Y2FuOiBhZGQgQ0FOIEZEIHN1cHBvcnQgZm9yIE5YUCBGbGV4Y2FuDQo+IA0KPiANCj4g
DQo+IEJlc3QgUmVnYXJkcywNCj4gSm9ha2ltIFpoYW5nDQo+IA0KPiA+IC0tLS0tT3JpZ2luYWwg
TWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogTWljaGFlbCBXYWxsZSA8bWljaGFlbEB3YWxsZS5jYz4N
Cj4gPiBTZW50OiAyMDIw5bm0MuaciDE05pelIDE2OjQzDQo+ID4gVG86IEpvYWtpbSBaaGFuZyA8
cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+ID4gQ2M6IE1hcmMgS2xlaW5lLUJ1ZGRlIDxta2xA
cGVuZ3V0cm9uaXguZGU+OyB3Z0BncmFuZGVnZ2VyLmNvbTsNCj4gPiBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOyBsaW51eC1jYW5Admdlci5rZXJuZWwub3JnOyBQYW5rYWogQmFuc2FsDQo+ID4gPHBh
bmthai5iYW5zYWxAbnhwLmNvbT4NCj4gPiBTdWJqZWN0OiBSZTogW1BBVENIIDAvOF0gY2FuOiBm
bGV4Y2FuOiBhZGQgQ0FOIEZEIHN1cHBvcnQgZm9yIE5YUA0KPiA+IEZsZXhjYW4NCj4gPg0KPiA+
IEhpIEpvYWtpbSwNCj4gPg0KPiA+IEFtIDIwMjAtMDItMTQgMDI6NTUsIHNjaHJpZWIgSm9ha2lt
IFpoYW5nOg0KPiA+ID4gSGkgTWljaGFsLA0KPiA+ID4NCj4gPiA+PiAtLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KPiA+ID4+IEZyb206IE1pY2hhZWwgV2FsbGUgPG1pY2hhZWxAd2FsbGUuY2M+
DQo+ID4gPj4gU2VudDogMjAyMOW5tDLmnIgxNOaXpSAzOjIwDQo+ID4gPj4gVG86IE1hcmMgS2xl
aW5lLUJ1ZGRlIDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+ID4gPj4gQ2M6IEpvYWtpbSBaaGFuZyA8
cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyB3Z0BncmFuZGVnZ2VyLmNvbTsNCj4gPiA+PiBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1jYW5Admdlci5rZXJuZWwub3JnOyBQYW5rYWogQmFu
c2FsDQo+ID4gPj4gPHBhbmthai5iYW5zYWxAbnhwLmNvbT47IE1pY2hhZWwgV2FsbGUgPG1pY2hh
ZWxAd2FsbGUuY2M+DQo+ID4gPj4gU3ViamVjdDogUmU6IFtQQVRDSCAwLzhdIGNhbjogZmxleGNh
bjogYWRkIENBTiBGRCBzdXBwb3J0IGZvciBOWFANCj4gPiA+PiBGbGV4Y2FuDQo+ID4gPj4NCj4g
PiA+PiBIaSwNCj4gPiA+Pg0KPiA+ID4+ID4+PiBBcmUgeW91IHByZXBhcmVkIHRvIGFkZCBiYWNr
IHRoZXNlIHBhdGNoZXMgYXMgdGhleSBhcmUNCj4gPiA+PiA+Pj4gbmVjZXNzYXJ5IGZvciBGbGV4
Y2FuIENBTiBGRD8gQW5kIHRoaXMgRmxleGNhbiBDQU4gRkQgcGF0Y2ggc2V0DQo+ID4gPj4gPj4+
IGlzIGJhc2VkIG9uIHRoZXNlIHBhdGNoZXMuDQo+ID4gPj4gPj4NCj4gPiA+PiA+PiBZZXMsIHRo
ZXNlIHBhdGNoZXMgd2lsbCBiZSBhZGRlZCBiYWNrLg0KPiA+ID4+ID4NCj4gPiA+PiA+SSd2ZSBj
bGVhbmVkIHVwIHRoZSBmaXJzdCBwYXRjaCBhIGJpdCwgYW5kIHB1c2hlZCBldmVyeXRoaW5nIHRv
DQo+ID4gPj4gPnRoZSB0ZXN0aW5nIGJyYW5jaC4gQ2FuIHlvdSBnaXZlIGl0IGEgdGVzdC4NCj4g
PiA+Pg0KPiA+ID4+IFdoYXQgaGFwcGVuZCB0byB0aGF0IGJyYW5jaD8gRldJVyBJJ3ZlIGp1c3Qg
dHJpZWQgdGhlIHBhdGNoZXMgb24gYQ0KPiA+ID4+IGN1c3RvbSBib2FyZCB3aXRoIGEgTFMxMDI4
QSBTb0MuIEJvdGggQ0FOIGFuZCBDQU4tRkQgYXJlIHdvcmtpbmcuDQo+ID4gPj4gSSd2ZSB0ZXN0
ZWQgYWdhaW5zdCBhIFBlYWt0ZWNoIFVTQiBDQU4gYWRhcHRlci4gSSdkIGxvdmUgdG8gc2VlDQo+
ID4gPj4gdGhlc2UgcGF0Y2hlcyB1cHN0cmVhbSwgYmVjYXVzZSBvdXIgYm9hcmQgYWxzbyBvZmZl
cnMgQ0FOIGFuZCBiYXNpYw0KPiA+ID4+IHN1cHBvcnQgZm9yIGl0IGp1c3QgbWFkZSBpdCB1cHN0
cmVhbSBbMV0uDQo+ID4gPiBUaGUgRmxleENBTiBDQU4gRkQgcmVsYXRlZCBwYXRjaGVzIGhhdmUg
c3RheWVkIGluDQo+ID4gPiBsaW51eC1jYW4tbmV4dC9mbGV4Y2FuIGJyYW5jaCBmb3IgYSBsb25n
IHRpbWUsIEkgc3RpbGwgZG9uJ3Qga25vdw0KPiA+ID4gd2h5IE1hcmMgZG9lc24ndCBtZXJnZSB0
aGVtIGludG8gTGludXggbWFpbmxpbmUuDQo+ID4gPiBodHRwczovL2V1cjAxLnNhZmVsaW5rcy5w
cm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0cHMlM0ElMkYlMkZnaXQuDQo+ID4gPg0KPiA+
DQo+IGtlcm5lbC5vcmclMkZwdWIlMkZzY20lMkZsaW51eCUyRmtlcm5lbCUyRmdpdCUyRm1rbCUy
RmxpbnV4LWNhbi1uZXh0LmcNCj4gPiA+DQo+ID4NCj4gaXQlMkZ0cmVlJTJGJTNGaCUzRGZsZXhj
YW4mYW1wO2RhdGE9MDIlN0MwMSU3Q3FpYW5ncWluZy56aGFuZyU0MG4NCj4gPiB4cC5jbw0KPiA+
ID4NCj4gPg0KPiBtJTdDOTRkY2E0NDcyYTU4NDQxMGIzYjkwOGQ3YjEyOWRiMjclN0M2ODZlYTFk
M2JjMmI0YzZmYTkyY2Q5OWMNCj4gPiA1YzMwMTYzDQo+ID4gPg0KPiA+DQo+IDUlN0MwJTdDMCU3
QzYzNzE3MjY2NTY0MjA3OTE5MiZhbXA7c2RhdGE9Nzd0RzZWdVFDaSUyRlpYQktiMjMNCj4gPiA4
JTJGZE5TVjMNCj4gPiA+IE5VSUZyTTVZMGU5eWowSjNvcyUzRCZhbXA7cmVzZXJ2ZWQ9MA0KPiA+
ID4gQWxzbyBtdXN0IGhvcGUgdGhhdCB0aGlzIHBhdGNoIHNldCBjYW4gYmUgdXBzdHJlYW1lZCBz
b29uLiA6LSkNCj4gPg0KPiA+IEkndmUgdG9vayB0aGVtIGZyb20gdGhpcyBicmFuY2ggYW5kIGFw
cGxpZWQgdGhlbSB0byB0aGUgbGF0ZXN0IGxpbnV4IG1hc3Rlci4NCj4gPg0KPiA+IFRodXMsDQo+
ID4NCj4gPiBUZXN0ZWQtYnk6IE1pY2hhZWwgV2FsbGUgPG1pY2hhZWxAd2FsbGUuY2M+DQo+ID4N
Cj4gPg0KSGkgTWFyYywNCg0KSG93IGFib3V0IEZsZXhDQU4gQ0FOIEZEIHBhdGNoIHNldCwgd2hl
biB3aWxsIHlvdSBzZW5kIHRvIG1haW5saW5lPw0KDQpUaGFua3MgYSBsb3QhDQoNCkJlc3QgUmVn
YXJkcywNCkpvYWtpbSBaaGFuZw0K

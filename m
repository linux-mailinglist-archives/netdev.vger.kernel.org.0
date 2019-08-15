Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C56F8EB1C
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 14:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731425AbfHOMIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 08:08:44 -0400
Received: from mail-eopbgr150088.outbound.protection.outlook.com ([40.107.15.88]:52960
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729986AbfHOMIo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 08:08:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e5EiUyKuV+9bUGdcY3rIOKST/L52E9TlAnHiOIJotK6n3fm+bqx/BcikBWk++5Y3VCiXXx6EFGV7xqqjSDO349PpBNtH8wl2g31UcnWgWzdCd3cHkAp9RUe0t2BFw7ulzwpnBZAQC2/Mn0HQ6YlCLGQESuAWtlw09O2PXVaRMwW7fpYzi/v75HUdkRkMRO7Qm8VuDSRmlrAAdOiYXA1dyeqt5hZvs7MQGPBCzUbiwOj3Ve47zIVp3aHwhYQeO9pySNjY3HNrmGg6uddvigcreM2WzJFVozTXNSgVLnvwyH93hn+suBD/P2vOIbP58mxRf1hqPsqZ2RaklulF7U8gwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qyeyW5sFuNZ8bkjWGg2h/CNVoa2wLqDDxKODS7bAOIs=;
 b=LmvVSf7fm1gLqZhbgZb4TY8wqaAtj30lK4MC1RaQnc3gBwDpRpQDLw4fGOHxz4grEmEm3xeaWvL+UOJNdaO2L5ZlugXzMOuB1dTdACeJ4qxxEQjiTB87T7ZZt2qvmPtIfAYGKaEjOeZ+QxZRIL6s+VOPhAtOTxP21FrQJCoFxnQ+Y9VHmp86raOeISga3ISoIQP7JHkTSFg3ZCDSTDlRat1GW2tT2CuZzDS+/5O0B+Hn4QLs7G1nwwVH19GqsvbHljNWwC1jBrk81p5HBHmkuGSINcE7pTTlhqH9hdGlWASWOAAam0N3gJ5eSvHeBzPbF+zwXEK7mLAynC4yEqu/4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qyeyW5sFuNZ8bkjWGg2h/CNVoa2wLqDDxKODS7bAOIs=;
 b=gloQ2wrQfXKgo4nZZfXS2Y1PBqBIxIpu7hVFcSHfghuNtYQpLqPdgCxIaAa/kxDzug6OUivV0MMARsthx6kikyVw3vFU9WgebOrk02FOjPqQIufpmCXRHwVUcx756V3ZFzp2IDLQukxBuuh64g6KZClL1xUX2ve/gFjtCA8Meqs=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2336.eurprd04.prod.outlook.com (10.169.132.145) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Thu, 15 Aug 2019 12:08:40 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::2072:e49f:a84a:8f37]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::2072:e49f:a84a:8f37%11]) with mapi id 15.20.2178.016; Thu, 15 Aug
 2019 12:08:40 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     "Allan W . Nielsen" <allan.nielsen@microchip.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: RE: [v2, 4/4] ocelot: add VCAP IS2 rule to trap PTP Ethernet frames
Thread-Topic: [v2, 4/4] ocelot: add VCAP IS2 rule to trap PTP Ethernet frames
Thread-Index: AQHVUYHBQ+XbfTaLmU6f16cDa36pP6b4nMYAgAFzxLCAAE5xgIABvPfg
Date:   Thu, 15 Aug 2019 12:08:40 +0000
Message-ID: <VI1PR0401MB2237B2ABB288FE12072C64D1F8AC0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
References: <20190813025214.18601-1-yangbo.lu@nxp.com>
 <20190813025214.18601-5-yangbo.lu@nxp.com>
 <20190813062525.5bgdzjc6kw5hqdxk@lx-anielsen.microsemi.net>
 <VI1PR0401MB2237E0F32D6CC719682E8C1AF8AD0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
 <20190814091645.dwo7c36xan2ttln2@lx-anielsen.microsemi.net>
In-Reply-To: <20190814091645.dwo7c36xan2ttln2@lx-anielsen.microsemi.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d493e646-f948-4c93-52e8-08d721794f68
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2336;
x-ms-traffictypediagnostic: VI1PR0401MB2336:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0401MB2336F80212655A2AF5637C35F8AC0@VI1PR0401MB2336.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(396003)(376002)(346002)(366004)(136003)(189003)(13464003)(199004)(53754006)(476003)(966005)(74316002)(256004)(64756008)(53546011)(305945005)(9686003)(446003)(11346002)(14454004)(26005)(33656002)(7736002)(102836004)(4326008)(186003)(66066001)(486006)(478600001)(25786009)(8676002)(6506007)(7696005)(3846002)(6116002)(76176011)(6306002)(99286004)(316002)(81166006)(229853002)(53936002)(54906003)(71190400001)(66476007)(66556008)(66946007)(81156014)(6436002)(55016002)(86362001)(52536014)(8936002)(2906002)(6246003)(6916009)(66446008)(76116006)(71200400001)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2336;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OsTMoMxUflbsQb3c+QQ8TaZH1oqErPrPMgM7v1Pmi6Inj+tg054+4qePTkgZ10iQDmcsgbx2R7PLMMaJeDhPrvdrUaOj/6UaOYXLozc2yn2Eudp341AAOaowwP+zzI9DMrEptvAbyccVr3lmkqiJTnhCYGcyP/tyVxbbLyabb9rBsyX7P6RkpC6xHF122CLiuaI5GQncz6j3QPNv2Wi3LCUmPePbQtGWK3TRKOUTwotX8Sw7M2KhuDD1ihdcJeoK0SEPgmA4SZxHl7HFRrsXfAH6q7TH8z73gNTh/cejQXCpEAHf24y2DODJNAm+IMuCZzCk9mhr0PbR9I/QONvsyH5Q8cxTwQSLpUlZQ5oYBvCw8BsOWN8nuPX/hEzLSJe4z+xQQWdy93Tae8oWq0NEWC/33VcMInx2rZ9fyqXokP8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d493e646-f948-4c93-52e8-08d721794f68
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 12:08:40.1881
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1oZfg2QD75Et8TPz/V5GaC8mPWrHL3+2Nxp1dBylphAI7SrMxAMGN3STXZ0TC8t/EIirhSoVQIhHBXEjrh5DBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2336
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWxsYW4sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQWxsYW4g
VyAuIE5pZWxzZW4gPGFsbGFuLm5pZWxzZW5AbWljcm9jaGlwLmNvbT4NCj4gU2VudDogV2VkbmVz
ZGF5LCBBdWd1c3QgMTQsIDIwMTkgNToxNyBQTQ0KPiBUbzogWS5iLiBMdSA8eWFuZ2JvLmx1QG54
cC5jb20+DQo+IENjOiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+OyBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOyBEYXZpZCBTIC4gTWlsbGVyDQo+IDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgQWxl
eGFuZHJlIEJlbGxvbmkgPGFsZXhhbmRyZS5iZWxsb25pQGJvb3RsaW4uY29tPjsNCj4gTWljcm9j
aGlwIExpbnV4IERyaXZlciBTdXBwb3J0IDxVTkdMaW51eERyaXZlckBtaWNyb2NoaXAuY29tPg0K
PiBTdWJqZWN0OiBSZTogW3YyLCA0LzRdIG9jZWxvdDogYWRkIFZDQVAgSVMyIHJ1bGUgdG8gdHJh
cCBQVFAgRXRoZXJuZXQgZnJhbWVzDQo+IA0KPiBUaGUgMDgvMTQvMjAxOSAwNDo1NiwgWS5iLiBM
dSB3cm90ZToNCj4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9tOiBB
bGxhbiBXIC4gTmllbHNlbiA8YWxsYW4ubmllbHNlbkBtaWNyb2NoaXAuY29tPg0KPiA+ID4gU2Vu
dDogVHVlc2RheSwgQXVndXN0IDEzLCAyMDE5IDI6MjUgUE0NCj4gPiA+IFRvOiBZLmIuIEx1IDx5
YW5nYm8ubHVAbnhwLmNvbT4NCj4gPiA+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBEYXZp
ZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsNCj4gPiA+IEFsZXhhbmRyZSBCZWxs
b25pIDxhbGV4YW5kcmUuYmVsbG9uaUBib290bGluLmNvbT47IE1pY3JvY2hpcCBMaW51eA0KPiA+
ID4gRHJpdmVyIFN1cHBvcnQgPFVOR0xpbnV4RHJpdmVyQG1pY3JvY2hpcC5jb20+DQo+ID4gPiBT
dWJqZWN0OiBSZTogW3YyLCA0LzRdIG9jZWxvdDogYWRkIFZDQVAgSVMyIHJ1bGUgdG8gdHJhcCBQ
VFANCj4gPiA+IEV0aGVybmV0IGZyYW1lcw0KPiA+ID4NCj4gPiA+IFRoZSAwOC8xMy8yMDE5IDEw
OjUyLCBZYW5nYm8gTHUgd3JvdGU6DQo+ID4gPiA+IEFsbCB0aGUgUFRQIG1lc3NhZ2VzIG92ZXIg
RXRoZXJuZXQgaGF2ZSBldHlwZSAweDg4Zjcgb24gdGhlbS4NCj4gPiA+ID4gVXNlIGV0eXBlIGFz
IHRoZSBrZXkgdG8gdHJhcCBQVFAgbWVzc2FnZXMuDQo+ID4gPiA+DQo+ID4gPiA+IFNpZ25lZC1v
ZmYtYnk6IFlhbmdibyBMdSA8eWFuZ2JvLmx1QG54cC5jb20+DQpbLi4uXQ0KPiBDYW4gd2UgY29u
dGludWUgdGhpcyBkaXNjdXNzaW9uIGluIHRoZSBvdGhlciB0aHJlYWQgd2hlcmUgSSBsaXN0ZWQg
dGhlIDMNCj4gc2NlbmFyaW9zPw0KDQpbWS5iLiBMdV0gU3VyZS4gTGV0J3MgZGlzY3VzcyBpbiB0
aGF0IHRocmVhZC4NCmh0dHBzOi8vcGF0Y2h3b3JrLm96bGFicy5vcmcvcGF0Y2gvMTE0NTYyNy8N
Cg0KWy4uLl0NCj4gPiA+IFdoYXQgaWYgZG8gbm90IHdhbnQgdGhpcyBvbiBhbGwgcG9ydHM/DQo+
ID4gW1kuYi4gTHVdIEFjdHVhbGx5IEkgZG9u4oCZdCB0aGluayB0aGVyZSBzaG91bGQgYmUgZGlm
ZmVyZW5jZSBvZiBoYW5kbGluZyBQVFANCj4gbWVzc2FnZXMgb24gZWFjaCBwb3J0Lg0KPiA+IFlv
dSBkb27igJl0IG5lZWQgdG8gcnVuIFBUUCBwcm90b2NvbCBhcHBsaWNhdGlvbiBvbiB0aGUgc3Bl
Y2lmaWMgcG9ydCBpZiB5b3UNCj4gZG9u4oCZdCB3YW50Lg0KPiBXaGF0IGlmIHlvdSB3YW50IHNv
bWUgdmxhbnMgb3Igc29tZSBwb3J0cyB0byBiZSBQVFAgdW5hd2FyZSwgYW5kIG90aGVyIHRvDQo+
IGJlIFBUUCBhd2FyZS4NCg0KW1kuYi4gTHVdIEFjdHVhbGx5IEkgY291bGRu4oCZdCBmaW5kIHJl
YXNvbnMgd2h5IG1ha2Ugc29tZSBwb3J0cyBQVFAgdW5hd2FyZSwgaWYgdGhlcmUgaXMgc29mdHdh
cmUgc3RhY2sgZm9yIFBUUCBhd2FyZS4uLg0KDQo+IA0KPiA+ID4gSWYgeW91IGRvIG5vdCBoYXZl
IGFuIGFwcGxpY2F0aW9uIGJlaGluZCB0aGlzIGltcGxlbWVudGluZyBhDQo+ID4gPiBib3VuZGFy
eSBvciB0cmFuc3BhcmVudCBjbG9jaywgdGhlbiB5b3UgYXJlIGJyZWFraW5nIFBUUCBvbiB0aGUg
bmV0d29yay4NCj4gPiBbWS5iLiBMdV0gWW91J3JlIHJpZ2h0LiBCdXQgYWN0dWFsbHkgZm9yIFBU
UCBuZXR3b3JrLCBhbGwgUFRQIGRldmljZXMgc2hvdWxkIHJ1bg0KPiBQVFAgcHJvdG9jb2wgb24g
aXQuDQo+ID4gT2YgY291cnNlLCBpdCdzIGJldHRlciB0byBoYXZlIGEgd2F5IHRvIGNvbmZpZ3Vy
ZSBpdCBhcyBub24tYXdhcmUgUFRQIHN3aXRjaC4NCj4gSSB0aGluayB3ZSBhZ3JlZS4NCj4gDQo+
IEluIG15IHBvaW50IG9mIHZpZXcsIGl0IGlzIHRoZSBQVFAgZGFlbW9uIHdobyBzaG91bGQgY29u
ZmlndXJlIGZyYW1lcyB0byBiZQ0KPiB0cmFwcGVkLiBUaGVuIHRoZSBzd2l0Y2ggd2lsbCBiZSBQ
VFAgdW5hd2FyZSB1bnRpbCB0aGUgUFRQIGRhZW1vbiBzdGFydHMgdXANCj4gYW5kIGlzIHJlYWR5
IHRvIG1ha2UgaXQgYXdhcmUuDQo+IA0KPiBJZiB3ZSBwdXQgaXQgaW4gdGhlIGluaXQgZnVuY3Rp
b24sIHRoZW4gaXQgd2lsbCBiZSBvZiBQVFAgYnJva2VuIHVudGlsIHRoZSBQVFANCj4gZGFlbW9u
IHN0YXJ0cy4NCj4gDQo+IC9BbGxhbg0KDQo=

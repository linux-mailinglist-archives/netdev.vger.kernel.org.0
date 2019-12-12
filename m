Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB94611CF98
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 15:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729701AbfLLOTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 09:19:08 -0500
Received: from mail-eopbgr50048.outbound.protection.outlook.com ([40.107.5.48]:61518
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729392AbfLLOTI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 09:19:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N9N37D6Oz2Gp739LlRXg9OgnGNThouak8D/6luo1gGdOfLLRmfvB00lXcNTIUew8tLiQ8z+/O+N17ZuhbnZt79ZQ9Lr1FCYYcuwbe3iwReBaAzKpg1y1+QlE0QIx1gFEmOI91VZC/iP4NRngMQ+wHXR9dDVUAjEbNOEX/bvcaM0vq3YcM2Je392kHdLMFRI5/CH16GlHwb55LbbkdtTjKaGovCQjgh9sl2gHMLkhCDNRTIbcvSCzPOfLnPdnqE62VV4CDFmtQUXliYlwYsQzZNbjlqCtpZpiEc8k3SLd6jje0YA8Z4TdpeFEGLsufmw/Ek3TBU6fPQbxzrQqYz9UyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OXLpUIzKhEEURQCioPVi9Ycm3anRioFtc/rXOetqJOY=;
 b=UDKY3wZS5uKLJ6UwnlbMQNc71r4dnAaVKQP/+TaXJ1dQ8L7I6mfOy9FUXbgOHc6JZpFeAgFtVJ9GRZ02Lp5hvdsj3Kts+HJWk+Sjv2yJI5zdnYns85BFHtbiZT46WrO+kk0UH3PTQePQLdOhrsEg+PWD3kbl0lYD/wejm7ATp6QIULeF2TP8/2SQhp2xPGnVDuZwSlbHdbJ2+8BYoO5KbOqPAmwaQoI8C3RaJt7tdbaqJaoANj0pjyc1z6IHEWkMeurIxRjb1khjCNp5jE+PclD7tOFYLzUv2n+RwliFW6U3JeaJW8MqhgCjKpk8P/S7x5o8s6vc1ZVbLCnsxbfEXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=onway.ch; dmarc=pass action=none header.from=onway.ch;
 dkim=pass header.d=onway.ch; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cloudguard.onmicrosoft.com; s=selector2-cloudguard-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OXLpUIzKhEEURQCioPVi9Ycm3anRioFtc/rXOetqJOY=;
 b=ADHIQsqswDprVEJQWw0ofhHwNFeWGBCD6uA2uT71Az+Pz4TvFjT6SGCyXuRHi3cipkD/7czpjrpMG1YwMIY5FCcwpjr+eDJ4iEPLvzoYguxsKWeFaR896TnhOkA9pQTkrn3ltoVVZKXnX/zwxx4xgzgB+Dy7p2WFNkgkLFcXu3I=
Received: from DBBPR04MB6187.eurprd04.prod.outlook.com (20.179.42.139) by
 DBBPR04MB6315.eurprd04.prod.outlook.com (20.179.44.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Thu, 12 Dec 2019 14:19:02 +0000
Received: from DBBPR04MB6187.eurprd04.prod.outlook.com
 ([fe80::ecbe:ce3d:cc21:87e8]) by DBBPR04MB6187.eurprd04.prod.outlook.com
 ([fe80::ecbe:ce3d:cc21:87e8%7]) with mapi id 15.20.2516.018; Thu, 12 Dec 2019
 14:19:02 +0000
From:   Andreas Tobler <andreas.tobler@onway.ch>
To:     Andrew Lunn <andrew@lunn.ch>, Baruch Siach <baruch@tkos.co.il>
CC:     Vivien Didelot <vivien.didelot@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Hubert Feurstein <h.feurstein@gmail.com>
Subject: Re: [BUG] mv88e6xxx: tx regression in v5.3
Thread-Topic: [BUG] mv88e6xxx: tx regression in v5.3
Thread-Index: AQHVsAku1wLvJyTgik2X2CiVCJjXQqe06NiAgABCBYCAAAvHAIAA+8WAgABJxgCAABHxgA==
Date:   Thu, 12 Dec 2019 14:19:02 +0000
Message-ID: <741aedd9-189e-9139-684b-16fcb597c2d6@onway.ch>
References: <87tv67tcom.fsf@tarshish> <20191211131111.GK16369@lunn.ch>
 <87fthqu6y6.fsf@tarshish> <20191211174938.GB30053@lunn.ch>
 <20191212085045.nqhfldkbebqzzamv@sapphire.tkos.co.il>
 <20191212131448.GA9959@lunn.ch>
In-Reply-To: <20191212131448.GA9959@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0011.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100::23)
 To DBBPR04MB6187.eurprd04.prod.outlook.com (2603:10a6:10:ca::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=andreas.tobler@onway.ch; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [185.12.128.225]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a313ea40-f5c4-4901-28bb-08d77f0e3d04
x-ms-traffictypediagnostic: DBBPR04MB6315:
x-microsoft-antispam-prvs: <DBBPR04MB631562DB526ADEDC3A9996C4F3550@DBBPR04MB6315.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0249EFCB0B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(42606007)(366004)(39830400003)(396003)(376002)(136003)(199004)(189003)(4326008)(54906003)(53546011)(2616005)(6506007)(5660300002)(110136005)(508600001)(15974865002)(8936002)(2906002)(6512007)(66946007)(8676002)(71200400001)(81166006)(44832011)(66556008)(36756003)(186003)(52116002)(31686004)(64756008)(66446008)(26005)(6486002)(66476007)(86362001)(31696002)(81156014)(316002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR04MB6315;H:DBBPR04MB6187.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: onway.ch does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: upwzYoFCYKj46hByLFjpYXfMxdoyg5sjfxfqG6D/fyfzTtNSu9hZIu/s45/CMk1DKPegkTiq1nKX4OBaVi3OpmNZH6WFAeSLmtIeULdBmbeeHwIe1p9buIuAN1vsYrvSO/dl2GkK1lpzmZ5cnFDOo4ShTtxe17A8+9Bw3HYPlCJUSM+J5bngWeXwrN8nfG/TBkJ3fojnTQX1qB+zAwaffL3fU4c9xX3h+1H9AkXV8XYiklCsJckDUfpNvDjqxByE8813TFfB01uhHGKRzichPidS59pvk3cjgsyig0pufmzuQI2Zw6S40Sb9NPxS9GNibzDrtmOIl93xzwPA5o48I5tuaQgQKxAvwR5C1ECLVT0s99Lj9mKG8cJMYZ0D8e/ucIVh2CQAMJAoFaZOJOA9ML6OD/SSZxyQvoOoQ78d+LqKRPj0l97MBUuXCE3gz04ssRkoL1KfXkz9rOoaivyWESqYqkZFV8nu0hWlU+A3iObnPlQnqLTv+9dwllvWm3uv
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D9F7F35A9B843469598D95C98A2785E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: onway.ch
X-MS-Exchange-CrossTenant-Network-Message-Id: a313ea40-f5c4-4901-28bb-08d77f0e3d04
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2019 14:19:02.7895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6609f251-fcb7-49e1-90a9-db1acfa508db
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9V4Q35cCEjcG22+I/DN91MxfmLSRKeqRM6bvajhQmOs59Gro8KdMxhvhb4aWaCgMUn/6iy+5qKJvy836Klc/hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6315
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIuMTIuMTkgMTQ6MTQsIEFuZHJldyBMdW5uIHdyb3RlOg0KPj4gQXMgeW91IGd1ZXNzZWQs
IG12ODhlNnh4eF9tYWNfY29uZmlnKCkgZXhpdHMgZWFybHkgYmVjYXVzZQ0KPj4gbXY4OGU2eHh4
X3BoeV9pc19pbnRlcm5hbCgpIHJldHVybnMgdHJ1ZSBmb3IgcG9ydCBudW1iZXIgMiwgYW5kICdt
b2RlJyBpcw0KPj4gTUxPX0FOX1BIWS4gV2hhdCBpcyB0aGUgcmlnaHQgTUFDL1BIWSBzZXR1cCBm
bG93IGluIHRoaXMgY2FzZT8NCj4gDQo+IFNvIHRoaXMgZ29lcyBiYWNrIHRvDQo+IA0KPiBjb21t
aXQgZDcwMGVjNDExOGY5ZDVlODhkYjhmNjc4ZTczNDJmMjhjOTMwMzdiOQ0KPiBBdXRob3I6IE1h
cmVrIFZhc3V0IDxtYXJleEBkZW54LmRlPg0KPiBEYXRlOiAgIFdlZCBTZXAgMTIgMDA6MTU6MjQg
MjAxOCArMDIwMA0KPiANCj4gICAgICBuZXQ6IGRzYTogbXY4OGU2eHh4OiBNYWtlIHN1cmUgdG8g
Y29uZmlndXJlIHBvcnRzIHdpdGggZXh0ZXJuYWwgUEhZcw0KPiAgICAgIA0KPiAgICAgIFRoZSBN
Vjg4RTZ4eHggY2FuIGhhdmUgZXh0ZXJuYWwgUEhZcyBhdHRhY2hlZCB0byBjZXJ0YWluIHBvcnRz
IGFuZCB0aG9zZQ0KPiAgICAgIFBIWXMgY291bGQgZXZlbiBiZSBvbiBkaWZmZXJlbnQgTURJTyBi
dXMgdGhhbiB0aGUgb25lIHdpdGhpbiB0aGUgc3dpdGNoLg0KPiAgICAgIFRoaXMgcGF0Y2ggbWFr
ZXMgc3VyZSB0aGF0IHBvcnRzIHdpdGggc3VjaCBQSFlzIGFyZSBjb25maWd1cmVkIGNvcnJlY3Rs
eQ0KPiAgICAgIGFjY29yZGluZyB0byB0aGUgaW5mb3JtYXRpb24gcHJvdmlkZWQgYnkgdGhlIFBI
WS4NCj4gDQo+IEBAIC03MDksMTMgKzcxNywxNyBAQCBzdGF0aWMgdm9pZCBtdjg4ZTZ4eHhfbWFj
X2NvbmZpZyhzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBwb3J0LA0KPiAgICAgICAgICBzdHJ1
Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXAgPSBkcy0+cHJpdjsNCj4gICAgICAgICAgaW50IHNwZWVk
LCBkdXBsZXgsIGxpbmssIHBhdXNlLCBlcnI7DQo+ICAgDQo+IC0gICAgICAgaWYgKG1vZGUgPT0g
TUxPX0FOX1BIWSkNCj4gKyAgICAgICBpZiAoKG1vZGUgPT0gTUxPX0FOX1BIWSkgJiYgbXY4OGU2
eHh4X3BoeV9pc19pbnRlcm5hbChkcywgcG9ydCkpDQo+ICAgICAgICAgICAgICAgICAgcmV0dXJu
Ow0KPiANCj4gVGhlIGlkZWEgYmVpbmcsIHRoYXQgdGhlIE1BQyBoYXMgZGlyZWN0IGtub3dsZWRn
ZSBvZiB0aGUgUEhZDQo+IGNvbmZpZ3VyYXRpb24gYmVjYXVzZSBpdCBpcyBpbnRlcm5hbC4gVGhl
cmUgaXMgbm8gbmVlZCB0byBjb25maWd1cmUNCj4gdGhlIE1BQywgaXQgZG9lcyBpdCBpdHNlbGYu
DQo+IA0KPiBUaGlzIGFzc3VtcHRpb24gc2VlbXMgd3JvbmcgZm9yIHRoZSBzd2l0Y2ggeW91IGhh
dmUuDQo+IA0KPiBJIHRoaW5rIGl0IGlzIGp1c3QgYSBvcHRpbWlzYXRpb24uIFNvIHdlIGNhbiBw
cm9iYWJseSByZW1vdmUgdGhpcyBwaHkNCj4gaW50ZXJuYWwgdGVzdC4NCj4gDQo+IEFuZA0KPiAg
ICAgICAgICB9IGVsc2UgaWYgKCFtdjg4ZTZ4eHhfcGh5X2lzX2ludGVybmFsKGRzLCBwb3J0KSkg
ew0KPiANCj4gYWxzbyBuZWVkcyB0byBjaGFuZ2UuDQo+IA0KPiBJdCB3b3VsZCBiZSBpbnRlcmVz
dGluZyB0byBrbm93IGlmIHRoZSBNQUMgaXMgY29tcGxldGVseSB3cm9uZ2x5DQo+IGNvbmZpZ3Vy
ZWQsIG9yIGl0IGlzIGp1c3QgYSBzdWJzZXQgb2YgcGFyYW1ldGVycy4NCg0KSW50ZXJlc3Rpbmcg
dGhhdCB5b3UgbWVudGlvbiB0aGUgcGF0Y2ggYWJvdmUuDQoNCkkganVtcCBpbiBiZWNhdXNlIEkg
aGF2ZSBhbiBpc3N1ZSBzaW5jZSB0aGUgYWJvdmUgcGF0Y2ggd2VudCBpbi4NCg0KSW4gbXkgY2Fz
ZSAoc2VlIGJlbG93KSB0aGUgbGlua3MgYXJlIHVwIGFuZCBydW5uaW5nIGZpbmUsIGJ1dCB3aGVu
IEkgDQpkaXNjb25uZWN0IHRoZSBsYW4gb24gcG9ydCA4IG9yIDksIEkgZG8gbm90IGdldCB0aGUg
SVAgYmFjay4gVGhlIHNhbWUgDQphcHBsaWVzIGlmIEkgc2V0IHRoZSBkZXZpY2UgZG93biBhbmQg
dXAgYWdhaW4uIEkgbG9vc2UgdGhlIGlwIGFuZCBkbyBub3QgDQpnZXQgaXQgYWdhaW4uDQoNCklm
IEkgc2V0IHRoZSBsaW5rIGluIHRoZSBhYm92ZSAnZWxzZSBpZicgY2xhdXNlIHRvIExJTktfVU5G
T1JDRUQsIEkgZ2V0IA0KbXkgaXAncyBiYWNrIGFuZCB0aGUgbGlua3MgYXJlIHdvcmtpbmcgYWdh
aW4uDQoNCiAgICAgICAgIH0gZWxzZSBpZiAoIW12ODhlNnh4eF9waHlfaXNfaW50ZXJuYWwoZHMs
IHBvcnQpKSB7DQotICAgICAgICAgICAgICAgbGluayA9IHN0YXRlLT5saW5rOw0KKyAgICAgICAg
ICAgICAgIGxpbmsgPSBMSU5LX1VORk9SQ0VEOw0KICAgICAgICAgICAgICAgICBzcGVlZCA9IHN0
YXRlLT5zcGVlZDsNCg0KSSBob3BlIEkgZGlkIG5vdCBoaWphY2sgdGhlIHRocmVhZCBhbiBteSBz
aXR1YXRpb24gaXMgcmVsYXRlZC4gT3RoZXJ3aXNlIA0KcGxlYXNlIGxldCBtZSBrbm93Lg0KDQpU
aGFua3MsDQpBbmRyZWFzDQoNClRoZSBsYW4wLzEvMiBhcmUgMTAwTSwgbGFuMy80IGFyZSAxRw0K
DQpteSBzd2l0Y2ggaW5mbyBmcm9tIHRoZSBsb2csIDUuNC4yOg0KDQptdjg4ZTYwODUgZjEwNzIw
MDQubWRpby1taWk6MDA6IHN3aXRjaCAweDk5MCBkZXRlY3RlZDogTWFydmVsbCANCjg4RTYwOTcv
ODhFNjA5N0YsIHJldmlzaW9uIDINCmxpYnBoeTogbXY4OGU2eHh4IFNNSTogcHJvYmVkDQptdjg4
ZTYwODUgZjEwNzIwMDQubWRpby1taWk6MDAgbGFuMCAodW5pbml0aWFsaXplZCk6IFBIWSANCltt
djg4ZTZ4eHgtMTowNV0gZHJpdmVyIFtHZW5lcmljIFBIWV0NCm12ODhlNjA4NSBmMTA3MjAwNC5t
ZGlvLW1paTowMCBsYW4xICh1bmluaXRpYWxpemVkKTogUEhZIA0KW212ODhlNnh4eC0xOjA2XSBk
cml2ZXIgW0dlbmVyaWMgUEhZXQ0KbXY4OGU2MDg1IGYxMDcyMDA0Lm1kaW8tbWlpOjAwIGxhbjIg
KHVuaW5pdGlhbGl6ZWQpOiBQSFkgDQpbbXY4OGU2eHh4LTE6MDddIGRyaXZlciBbR2VuZXJpYyBQ
SFldDQptdjg4ZTYwODUgZjEwNzIwMDQubWRpby1taWk6MDAgbGFuMyAodW5pbml0aWFsaXplZCk6
IFBIWSANClttdjg4ZTZ4eHgtMTowOF0gZHJpdmVyIFtNYXJ2ZWxsIDg4RTExMTJdDQptdjg4ZTYw
ODUgZjEwNzIwMDQubWRpby1taWk6MDAgbGFuNCAodW5pbml0aWFsaXplZCk6IFBIWSANClttdjg4
ZTZ4eHgtMTowOV0gZHJpdmVyIFtNYXJ2ZWxsIDg4RTExMTJdDQoNCg0KDQoNCi0tIA0Kb253YXkg
YWcNCkFuZHJlYXMgVG9ibGVyDQpTb2Z0d2FyZSBFbmdpbmVlcg0KDQpTdGF1ZmZhY2hlcnN0cmFz
c2UgMTYsIENILTgwMDQgWsO8cmljaA0KVGVsOiArNDEgNTUgMjE0IDE4IDQyDQphbmRyZWFzLnRv
YmxlckBvbndheS5jaA0Kd3d3Lm9ud2F5LmNoDQoNCg==

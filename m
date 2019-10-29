Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72CDFE8B2E
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 15:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389739AbfJ2Osb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 10:48:31 -0400
Received: from mail-eopbgr80070.outbound.protection.outlook.com ([40.107.8.70]:14726
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389732AbfJ2Osa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 10:48:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eD7mQE6f3OjbdCshVvaFrqewRCu0o6BD+uy6zLt6ap4BVfIqlI6NewzzK67kAojeLo4rz+sLN9qV/o6Sw/CZsCnIGj7AwsB8wh0okFcsfzX3d6vziwGPIe0kwcIGX7IT91oS570LZ5Pps9+t4j8BRK+j/9McH17p3krxuv5Dog1M5fhhr12ay45KUlYzdPw7oYFmGM7sRbbJbUtoh+OUiDZN9dESzGrdfHnpuPuz/+rWo6GOPImONs+fGB9VP+p+CV1c6sFWUgIXUrgpLan6WNw/etUnFB36fXT57jEO7LhJyk1bXemmbmxhDx1/dfG2SItMBAvo7GSM6sJWeJYwUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VsyiBPBJ0CPAIeI+DJvH5wDXzsytTk+2hthvZcxywjI=;
 b=JvN8Rz3f3i8aG7cnRdKj9RvItI/v+I/rfqdIuBMRTlNhbzv4B0vLglmKT+MucG7ZBJdQMMvgVv0mDAdjPkBlPLTdt9imyHvN/LE4D7gHWemN1LJ/bAyEdd0Ym6RD/xs8isBBVulnn701bOnA66JGJBdJjPcorQa41nbvWzBdIyXy4lPpctQZKa/SxaTtCiD8Yf6oFHKfbLO1THFL7eFyf1FDvK6SBvo5AU6GngAb2i8pLYuu55+R+dbPzHoLa54DnydDhnNm1nrH5gXcPEAAdlnhkiVu7pCDqIoFB39ZpAIuyJZEXBY8eTlU2M15q7TSGQJdNTYui0tP5g4oCCpvEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VsyiBPBJ0CPAIeI+DJvH5wDXzsytTk+2hthvZcxywjI=;
 b=Eju+caEH2N06claqlgoXFjWNfq2oSgCkNGBFVp9Zz9cKCssBFYzCQ7aNUlJ3MgyUW03FP33SU0UtsS/abzCfoeqf1IK6Qyni7DTy/7m/vIK98Piq79jNrDbkPKlOhTTlMas6RPpZeR99aoYXS1KAqjaBiTznA7JCZ1hvWTz22h0=
Received: from VI1PR05MB6285.eurprd05.prod.outlook.com (20.179.24.85) by
 VI1PR05MB5709.eurprd05.prod.outlook.com (20.178.121.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.23; Tue, 29 Oct 2019 14:48:26 +0000
Received: from VI1PR05MB6285.eurprd05.prod.outlook.com
 ([fe80::1072:ebe8:54ba:d873]) by VI1PR05MB6285.eurprd05.prod.outlook.com
 ([fe80::1072:ebe8:54ba:d873%5]) with mapi id 15.20.2408.016; Tue, 29 Oct 2019
 14:48:26 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net 11/11] Documentation: TLS: Add missing counter description
Thread-Topic: [net 11/11] Documentation: TLS: Add missing counter description
Thread-Index: AQHViqKwBmdphiEkGkKddixvb/YqBqdqUQWAgAdphwA=
Date:   Tue, 29 Oct 2019 14:48:26 +0000
Message-ID: <86bb1c88-c650-d262-8d14-180af563dc10@mellanox.com>
References: <20191024193819.10389-1-saeedm@mellanox.com>
 <20191024193819.10389-12-saeedm@mellanox.com>
 <20191024143651.795705df@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191024143651.795705df@cakuba.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR01CA0073.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::14) To VI1PR05MB6285.eurprd05.prod.outlook.com
 (2603:10a6:803:f1::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a5b8a0c7-2e5b-4dd5-bd95-08d75c7f0ddf
x-ms-traffictypediagnostic: VI1PR05MB5709:|VI1PR05MB5709:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5709773036D8C386DF22598EAE610@VI1PR05MB5709.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(199004)(189003)(86362001)(6246003)(66066001)(256004)(66556008)(66476007)(305945005)(64756008)(6436002)(14444005)(2616005)(4326008)(11346002)(446003)(66446008)(81156014)(81166006)(31696002)(486006)(8676002)(66946007)(5660300002)(6636002)(498600001)(229853002)(6116002)(3846002)(2906002)(6486002)(8936002)(186003)(26005)(36756003)(53546011)(76176011)(31686004)(110136005)(6506007)(6512007)(14454004)(25786009)(54906003)(476003)(107886003)(71200400001)(71190400001)(102836004)(99286004)(52116002)(7736002)(386003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5709;H:VI1PR05MB6285.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2HFJaO425hIKkGMDs6qXR6CGz5+gIDuVoWLhT5mKiSMOrhnUAVCQFnlDyRprvL/FCd2FwOhMgBkoF4na8wb9K7IQX3WgNQwR8TrGfA6rCGMcUIKcW2FgzClXo6vvxp9REiZprjDI53C143oCVJE2hW2suyMWCzxQ7IEHxRqC9arP77ki7WKK9QQr6tCX+qu/YazUxevcyxXXi3YPgV98vyUdRygKF2/6/l3xR11FDY91bPNuVli/i1SwddkHZlh0eP61nDQp11LEjuqlEG45O283ZmLTQYseyKRHKbwLqclwj+qHd7i4pzLttVnI8lMxfCdZXZG57a+rPQeCJ22R688hptytEp6yAdhpzCbVhXjm+gvzw7s43vr8cccriMZLrdNkJnApnmbEufJz+29SBk57hFWfzbMX7qnvjPf1d/S05ry3ceLBxgql3EceWBUF
Content-Type: text/plain; charset="utf-8"
Content-ID: <A891E9F2A20BBE4B96431048D8B37FB7@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5b8a0c7-2e5b-4dd5-bd95-08d75c7f0ddf
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 14:48:26.2051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pgu35AeQO6tbmf0q6XGNzhh+6zuEy+RL0HogFyFu9AZBV+0f8aqUwmYF0lcRzHRIx+B47r9g4XFDfJNuqGIyFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5709
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzI1LzIwMTkgMTI6MzYgQU0sIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiBPbiBU
aHUsIDI0IE9jdCAyMDE5IDE5OjM5OjAyICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToNCj4+
IEZyb206IFRhcmlxIFRvdWthbiA8dGFyaXF0QG1lbGxhbm94LmNvbT4NCj4+DQo+PiBBZGQgVExT
IFRYIGNvdW50ZXIgZGVzY3JpcHRpb24gZm9yIHRoZSBwYWNrZXRzIHRoYXQgc2tpcCB0aGUgcmVz
eW5jDQo+PiBwcm9jZWR1cmUgYW5kIGhhbmRsZWQgaW4gdGhlIHJlZ3VsYXIgdHJhbnNtaXQgZmxv
dywgYXMgdGhleSBjb250YWluDQo+PiBubyBkYXRhLg0KPj4NCj4+IEZpeGVzOiA0NmEzZWE5ODA3
NGUgKCJuZXQvbWx4NWU6IGtUTFMsIEVuaGFuY2UgVFggcmVzeW5jIGZsb3ciKQ0KPj4gU2lnbmVk
LW9mZi1ieTogVGFyaXEgVG91a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0KPj4gU2lnbmVkLW9m
Zi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo+PiAtLS0NCj4+ICAg
RG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL3Rscy1vZmZsb2FkLnJzdCB8IDMgKysrDQo+PiAgIDEg
ZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvRG9jdW1l
bnRhdGlvbi9uZXR3b3JraW5nL3Rscy1vZmZsb2FkLnJzdCBiL0RvY3VtZW50YXRpb24vbmV0d29y
a2luZy90bHMtb2ZmbG9hZC5yc3QNCj4+IGluZGV4IDBkZDNmNzQ4MjM5Zi4uODdkYjg3MDk5NjA3
IDEwMDY0NA0KPj4gLS0tIGEvRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL3Rscy1vZmZsb2FkLnJz
dA0KPj4gKysrIGIvRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL3Rscy1vZmZsb2FkLnJzdA0KPj4g
QEAgLTQzNiw2ICs0MzYsOSBAQCBieSB0aGUgZHJpdmVyOg0KPj4gICAgICBlbmNyeXB0aW9uLg0K
Pj4gICAgKiBgYHR4X3Rsc19vb29gYCAtIG51bWJlciBvZiBUWCBwYWNrZXRzIHdoaWNoIHdlcmUg
cGFydCBvZiBhIFRMUyBzdHJlYW0NCj4+ICAgICAgYnV0IGRpZCBub3QgYXJyaXZlIGluIHRoZSBl
eHBlY3RlZCBvcmRlci4NCj4+ICsgKiBgYHR4X3Rsc19za2lwX25vX3N5bmNfZGF0YWBgIC0gbnVt
YmVyIG9mIFRYIHBhY2tldHMgd2hpY2ggd2VyZSBwYXJ0IG9mDQo+PiArICAgYSBUTFMgc3RyZWFt
IGFuZCBhcnJpdmVkIG91dC1vZi1vcmRlciwgYnV0IHNraXBwZWQgdGhlIEhXIG9mZmxvYWQgcm91
dGluZQ0KPj4gKyAgIGFuZCB3ZW50IHRvIHRoZSByZWd1bGFyIHRyYW5zbWl0IGZsb3cgYXMgdGhl
eSBjb250YWluZWQgbm8gZGF0YS4NCj4gDQo+IFRoYXQgZG9lc24ndCBzb3VuZCByaWdodC4gSXQg
c291bmRzIGxpa2UgeW91J3JlIHRhbGtpbmcgYWJvdXQgcHVyZSBBY2tzDQo+IGFuZCBvdGhlciBz
ZWdtZW50cyB3aXRoIG5vIGRhdGEuIEZvciBtbHg1IHRob3NlIGFyZSBza2lwcGVkIGRpcmVjdGx5
IGluDQo+IG1seDVlX2t0bHNfaGFuZGxlX3R4X3NrYigpLg0KPiANCj4gVGhpcyBjb3VudGVyIGlz
IGZvciBzZWdtZW50cyB3aGljaCBhcmUgcmV0cmFuc21pc3Npb24gb2YgZGF0YSBxdWV1ZWQgdG8N
Cj4gdGhlIHNvY2tldCBiZWZvcmUga2VybmVsIGdvdCB0aGUga2V5cyBpbnN0YWxsZWQuDQo+IA0K
PiBZb3UgZXhwbGFpbmVkIGl0IHJlYXNvbmFibHkgd2VsbCBpbiA0NmEzZWE5ODA3NGUgKCJuZXQv
bWx4NWU6IGtUTFMsDQo+IEVuaGFuY2UgVFggcmVzeW5jIGZsb3ciKToNCj4gDQo+ICAgICAgSG93
ZXZlciwgaW4gY2FzZSB0aGUgVExTIFNLQiBpcyBhIHJldHJhbnNtaXNzaW9uIG9mIHRoZSBjb25u
ZWN0aW9uDQo+ICAgICAgaGFuZHNoYWtlLCBpdCBpbml0aWF0ZXMgdGhlIHJlc3luYyBmbG93IChh
cyB0aGUgdGNwIHNlcSBjaGVjayBob2xkcyksDQo+ICAgICAgd2hpbGUgcmVndWxhciBwYWNrZXQg
aGFuZGxlIGlzIGV4cGVjdGVkLg0KPiANCg0KUmlnaHQuIEknbGwgcmVwaHJhc2UuDQoNCj4gRGlk
IHRoaXMgcGF0Y2ggZ2V0IHN0dWNrIGluIHRoZSBxdWV1ZSBmb3Igc28gbG9uZyB5b3UgZm9yZ290
IHdoYXQgdGhlDQo+IGNvdW50ZXIgd2FzPyA7KQ0KPiANCj4+ICAgICogYGB0eF90bHNfZHJvcF9u
b19zeW5jX2RhdGFgYCAtIG51bWJlciBvZiBUWCBwYWNrZXRzIHdoaWNoIHdlcmUgcGFydCBvZg0K
Pj4gICAgICBhIFRMUyBzdHJlYW0gZHJvcHBlZCwgYmVjYXVzZSB0aGV5IGFycml2ZWQgb3V0IG9m
IG9yZGVyIGFuZCBhc3NvY2lhdGVkDQo+PiAgICAgIHJlY29yZCBjb3VsZCBub3QgYmUgZm91bmQu
DQo=

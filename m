Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B93F32E63
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 13:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbfFCLOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 07:14:44 -0400
Received: from mail-eopbgr150115.outbound.protection.outlook.com ([40.107.15.115]:34117
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727812AbfFCLOo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 07:14:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1VwdxUUFWLhnL7p1NMYOUp52J9eNQ5FpLQyJLAgdooY=;
 b=O5CbJ8INmO3VXCp4LtSj/pZHiYEcHKrllkdzslNgWZZCmb9fg72N27hgGWZgDsRkDZlWU2PQOusCofYBGIh+k71nKv5uCHwLRgr8RrQ1QawcEPcxYgznuN5e9rarrgPEhZBZhGH5g7WRNcta6DQ1GoIA1Lgj3cAY6aliCL9in1M=
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM (20.178.126.80) by
 VI1PR10MB2029.EURPRD10.PROD.OUTLOOK.COM (52.134.28.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.21; Mon, 3 Jun 2019 11:14:39 +0000
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5]) by VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5%6]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 11:14:39 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Vivien Didelot <vivien.didelot@gmail.com>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: reset value of MV88E6XXX_G1_IEEE_PRI
Thread-Topic: reset value of MV88E6XXX_G1_IEEE_PRI
Thread-Index: AQHVFG+fncWQ8lohfEiBAdvF6CsT76Z+546AgAAp2YD///RugIAKzFkA
Date:   Mon, 3 Jun 2019 11:14:39 +0000
Message-ID: <3a016cd4-ee15-7365-347e-69dfc20c04de@prevas.dk>
References: <4e5592a2-bce3-127b-99e1-7fab00dc0511@prevas.dk>
 <20190527083215.GB2594@t480s.localdomain>
 <493a84d0-5319-41ce-1437-77daf8813d39@prevas.dk>
 <20190527102037.GB31320@t480s.localdomain>
In-Reply-To: <20190527102037.GB31320@t480s.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0901CA0053.eurprd09.prod.outlook.com
 (2603:10a6:3:45::21) To VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d933ecbc-2645-4f06-2d2d-08d6e814ab1c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR10MB2029;
x-ms-traffictypediagnostic: VI1PR10MB2029:
x-microsoft-antispam-prvs: <VI1PR10MB20297A3CB41A0302232EB8978A140@VI1PR10MB2029.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(366004)(396003)(136003)(376002)(346002)(189003)(199004)(42882007)(31696002)(14444005)(53936002)(476003)(2616005)(31686004)(6916009)(486006)(44832011)(76176011)(6486002)(446003)(186003)(26005)(11346002)(256004)(68736007)(386003)(71190400001)(6506007)(102836004)(52116002)(66066001)(3846002)(6116002)(54906003)(74482002)(71200400001)(99286004)(229853002)(81166006)(8676002)(305945005)(72206003)(36756003)(316002)(478600001)(14454004)(4326008)(8936002)(81156014)(6512007)(7736002)(8976002)(66556008)(66476007)(66446008)(6246003)(64756008)(2906002)(25786009)(5660300002)(6436002)(73956011)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB2029;H:VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MnWiKr4NitHVt8DMUthkCy0S3k9iguI+zAvNpxanxoOoP6ct70YcH2ysAWUkozIAjU5MZ79ksrLRnPXPInmA46ZXgKg+cWHvahNoPAZKsnweNLk1nzhK/XjfNIV866Y/I6SCVopuyqqFGT9gfKAtiIu2jr1VAKUeRcy5LlC5NNAiXdDdfKvZlUXxOK11UR2KjEMrOlVHRJ0hPt32H2z0c5rNmey+bnpk7jz+41Wm0WrEfTuRQR/PZYd3F2kzhfnw4FMDgWa+uG2m1lrExoUNm04bQ2WyNdsf9rT4JP3g0/W30eJqkW3jjlWXqHkv5vvR54AQnbaSfhCOuSRVm7MiqaWHGqT08ubMtyd2KAsmQealbeQsXH813gR+GUMeXEevjOZyjj2SeLgiAM0g5q0R0qwKlTqdZOzPap2dyzHmBJk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3C2588B452BC346979402F6C8AAD378@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: d933ecbc-2645-4f06-2d2d-08d6e814ab1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 11:14:39.1461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB2029
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjcvMDUvMjAxOSAxNi4yMCwgVml2aWVuIERpZGVsb3Qgd3JvdGU6DQo+IEhpIFJhc211cywN
Cj4gDQo+Pg0KPj4gQmFzZWQgb24gdGhlIHZlcnkgc3lzdGVtYXRpYyBkZXNjcmlwdGlvbiBbaWVl
ZSB0YWdzIDcgYW5kIDYgYXJlIG1hcHBlZA0KPj4gdG8gMywgNSBhbmQgNCB0byAyLCAzIGFuZCAy
IHRvIDEsIGFuZCAxIGFuZCAwIHRvIDBdLCBJIHN0cm9uZ2x5IGJlbGlldmUNCj4+IHRoYXQgMHhm
YTUwIGlzIGFsc28gdGhlIHJlc2V0IHZhbHVlIGZvciB0aGUgNjA4NSwgc28gdGhpcyBpcyBtb3N0
IGxpa2VseQ0KPj4gd3JvbmcgZm9yIGFsbCB0aGUgY3VycmVudCBjaGlwcyAtIHRob3VnaCBJIGRv
bid0IGhhdmUgYSA2MDg1IGRhdGEgc2hlZXQuDQo+Pg0KPj4gSSBjYW4gY2VydGFpbmx5IGFkZCBh
IDYyNTAgdmFyaWFudCB0aGF0IGRvZXMgdGhlIHJpZ2h0IHRoaW5nIGZvciB0aGUNCj4+IDYyNTAs
IGFuZCBJIHByb2JhYmx5IHdpbGwgLSB0aGlzIGlzIG1vcmUgYSBxdWVzdGlvbiBhYm91dCB0aGUg
Y3VycmVudCBjb2RlLg0KPiANCj4gR29vZCBjYXRjaCwgSSBkb3VibGUgY2hlY2tlZCA4OEU2MDg1
IGFuZCA4OEU2MzUyIGFuZCBib3RoIGRlc2NyaWJlDQo+IGEgcmVzZXQgdmFsdWUgb2YgMHhGQTUw
LiBGaXhpbmcgbXY4OGU2MDg1X2cxX2llZWVfcHJpX21hcCBzaG91bGQNCj4gYmUgZW5vdWdoLg0K
DQpVcmdoLCB5ZXMsIGJ1dCBub3cgdGhhdCBJIGdvdCBhY2Nlc3MgdG8gb3RoZXIgZGF0YSBzaGVl
dHMgSSBhbHNvIGNoZWNrZWQNCjg4ZTYwOTUsIGFuZCB0aGF0IGFjdHVhbGx5IGRvZXMgZGVzY3Jp
YmUgYSByZXNldCB2YWx1ZSBvZiAweGZhNDEuIFNvDQp0aGF0IHZhbHVlIGlzIG5vdCB0YWtlbiBv
dXQgb2YgdGhpbiBhaXIsIHRob3VnaCBpdCBkb2VzIG5vdCBhcHBseSB0byB0aGUNCmNoaXAgdmFy
aWFudCB0aGF0IHRoZSBjdXJyZW50IG12ODhlNjA4NV9nMV9pZWVlX3ByaV9tYXAgaGVscGVyIGlz
IG5hbWVkDQphZnRlciA6KA0KDQpTbyBJIHRoaW5rIEknbGwgYWRkIGEgbXY4OGU2MjUwX2cxX2ll
ZWVfcHJpX21hcCBmb3IgdGhlIGNoaXAgSSdtIHdvcmtpbmcNCm9uLCB0aGVuIG90aGVyIGNoaXBz
IHRoYXQgaGF2ZSAweGZhNTAgYXMgdGhlIHJlc2V0IHZhbHVlIGNhbiBiZSBzd2l0Y2hlZA0Kb3Zl
ciB0byB1c2UgdGhhdCBvbmUgYnkgb25lLCBkb3VibGUtY2hlY2tpbmcgdGhlIGRhdGEgc2hlZXQg
KGFuZCBpZGVhbGx5DQphbHNvIHRoZSBhY3R1YWwgaGFyZHdhcmUuLi4pIGZvciBlYWNoIG9uZS4N
Cg0KUmFzbXVzDQoNCg0K

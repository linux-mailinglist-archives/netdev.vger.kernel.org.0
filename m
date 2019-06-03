Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D25533937
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 21:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfFCTnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 15:43:46 -0400
Received: from mail-eopbgr00114.outbound.protection.outlook.com ([40.107.0.114]:60718
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726157AbfFCTnp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 15:43:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XIcIVab13VwrRKwWvC1W5J4JcQ+/kqEOclxv0RScM0=;
 b=RUJZpqXo4wK8aCt62TR7KTJyq/DnXlg6Zl6Ps4yucHmp9hVuOoBQeP69KmxKVRUGYlepYZywox38166c0Fh/UvM1PnKrhWHUl12QwL0dsbIhTP9SjW+35TB2OHu0UG9I1Y7Xqsuc4NZFsm3a+1E5blCguMt++Qqf6TgZxHUcDwk=
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM (20.178.126.80) by
 VI1PR10MB1918.EURPRD10.PROD.OUTLOOK.COM (52.134.26.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Mon, 3 Jun 2019 19:43:40 +0000
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5]) by VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5%6]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 19:43:40 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Vivien Didelot <vivien.didelot@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 01/10] net: dsa: mv88e6xxx: add
 mv88e6250_g1_ieee_pri_map
Thread-Topic: [PATCH net-next v3 01/10] net: dsa: mv88e6xxx: add
 mv88e6250_g1_ieee_pri_map
Thread-Index: AQHVGhqHnyHUOFwezk6WN9nCJNIDv6aKEDiAgABE1wA=
Date:   Mon, 3 Jun 2019 19:43:40 +0000
Message-ID: <155de71a-10d0-820a-27f4-cf0cf8d0e5f2@prevas.dk>
References: <20190603144112.27713-1-rasmus.villemoes@prevas.dk>
 <20190603144112.27713-2-rasmus.villemoes@prevas.dk>
 <20190603113713.GB2789@t480s.localdomain>
In-Reply-To: <20190603113713.GB2789@t480s.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0401CA0062.eurprd04.prod.outlook.com
 (2603:10a6:3:19::30) To VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [5.186.118.63]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed55693c-c7ef-4744-55ae-08d6e85bc716
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR10MB1918;
x-ms-traffictypediagnostic: VI1PR10MB1918:
x-microsoft-antispam-prvs: <VI1PR10MB1918C3CD256316C7678A69748A140@VI1PR10MB1918.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(366004)(396003)(136003)(376002)(346002)(189003)(199004)(36756003)(74482002)(66446008)(64756008)(66946007)(6436002)(73956011)(6116002)(3846002)(305945005)(6486002)(66476007)(66556008)(316002)(6246003)(2906002)(71446004)(5660300002)(25786009)(8936002)(8976002)(6512007)(7736002)(8676002)(81156014)(81166006)(6916009)(102836004)(44832011)(76176011)(186003)(26005)(52116002)(476003)(53936002)(11346002)(446003)(42882007)(256004)(14444005)(68736007)(31686004)(2616005)(486006)(478600001)(66066001)(31696002)(99286004)(4326008)(386003)(72206003)(54906003)(71190400001)(6506007)(229853002)(14454004)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB1918;H:VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +IzwEHj3c8DgJIHMR+yNsRuNRTkYadyNBt08YwQkx5tIJOBdbDBsBP60/ZbSO12iopDjLx4vhUu4jWWj7iDCCerJhGD7R0u4w7lCCH8UIo3KhWjq0q1tzsklb9+1SDZ4vK0Lgta5M7XIsTYp5HYaz0OOH3zkQ2lr2hJdeoT1ulzJ/Px8mhYjx9Ol9ObTaHYzc3EBw4qq2snx/88s8qk8Zdk6F5TRqMMymyxMPUp9cpPfHe621vX2jeqMwJA5KAJlsNx2eRLyqazFKNaFH8j5tHQ8hlzdVua9jbaH5mLdCBYzPjplqzXNVUGLOVf7QZQmPhkIB4Zzc/h8Xr+T7M/gUSqyHvPhVLdxZ0dkcOnFiDGQtQq43PvBnCOIiJ4qsfjjGsuemFCmw2MXeIzRlGTLtqVeDMhMgnH+x6/7mk9C7Cw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8085E8DC73EE934EB821F3AA70D2D458@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: ed55693c-c7ef-4744-55ae-08d6e85bc716
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 19:43:40.2579
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB1918
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDMvMDYvMjAxOSAxNy4zNywgVml2aWVuIERpZGVsb3Qgd3JvdGU6DQo+IEhpIFJhc211cywN
Cj4gDQo+IE9uIE1vbiwgMyBKdW4gMjAxOSAxNDo0MjoxMiArMDAwMCwgUmFzbXVzIFZpbGxlbW9l
cyA8cmFzbXVzLnZpbGxlbW9lc0BwcmV2YXMuZGs+IHdyb3RlOg0KPj4gUXVpdGUgYSBmZXcgb2Yg
dGhlIGV4aXN0aW5nIHN1cHBvcnRlZCBjaGlwcyB0aGF0IHVzZQ0KPj4gbXY4OGU2MDg1X2cxX2ll
ZWVfcHJpX21hcCBhcyAtPmllZWVfcHJpX21hcCAoaW5jbHVkaW5nLCBpbmNpZGVudGFsbHksDQo+
PiBtdjg4ZTYwODUgaXRzZWxmKSBhY3R1YWxseSBoYXZlIGEgcmVzZXQgdmFsdWUgb2YgMHhmYTUw
IGluIHRoZQ0KPj4gRzFfSUVFRV9QUkkgcmVnaXN0ZXIuDQo+Pg0KPj4gVGhlIGRhdGEgc2hlZXQg
Zm9yIHRoZSBtdjg4ZTYwOTUsIGhvd2V2ZXIsIGRvZXMgZGVzY3JpYmUgYSByZXNldCB2YWx1ZQ0K
Pj4gb2YgMHhmYTQxLg0KPj4NCj4+IFNvIHJhdGhlciB0aGFuIGNoYW5naW5nIHRoZSB2YWx1ZSBp
biB0aGUgZXhpc3RpbmcgY2FsbGJhY2ssIGludHJvZHVjZQ0KPj4gYSBuZXcgdmFyaWFudCB3aXRo
IHRoZSAweGZhNTAgdmFsdWUuIFRoYXQgd2lsbCBiZSB1c2VkIGJ5IHRoZSB1cGNvbWluZw0KPj4g
bXY4OGU2MjUwLCBhbmQgZXhpc3RpbmcgY2hpcHMgY2FuIGJlIHN3aXRjaGVkIG92ZXIgb25lIGJ5
IG9uZSwNCj4+IHByZWZlcmFibHkgZG91YmxlLWNoZWNraW5nIGJvdGggdGhlIGRhdGEgc2hlZXQg
YW5kIGFjdHVhbCBoYXJkd2FyZSBpbg0KPj4gZWFjaCBjYXNlIC0gaWYgYW55Ym9keSBhY3R1YWxs
eSBmZWVscyB0aGlzIGlzIGltcG9ydGFudCBlbm91Z2ggdG8NCj4+IGNhcmUuDQo+IA0KPiBHaXZl
biB5b3VyIHByZXZpb3VzIHRocmVhZCBvbiB0aGlzIHRvcGljLCBJJ2QgcHJlZmVyIHRoYXQgeW91
IGluY2x1ZGUNCj4gYSBmaXJzdCBwYXRjaCB3aGljaCBpbXBsZW1lbnRzIG12ODhlNjA5NV9nMV9p
ZWVlX3ByaV9tYXAoKSB1c2luZyAweGZhNDENCj4gYW5kIHVwZGF0ZSBtdjg4ZXs2MDkyLDYwOTV9
X29wcyB0byB1c2UgaXQsIHRoZW4gYSBzZWNvbmQgb25lIHdoaWNoIGZpeGVzDQo+IG12ODhlNjA4
NV9nMV9pZWVlX3ByaV9tYXAgdG8gdXNlIDB4ZmE1MC4gVGhlbiBtdjg4ZTYyNTBfb3BzIGNhbiB1
c2UgaXQuDQoNCldlbGwsIHRoZSB0aGluZyBpcywgdGhhdCB3b3VsZCBvZiBjb3Vyc2UgZml4IHRo
ZSB2YWx1ZSBmb3IgNjI0MCBhbmQNCjYwODUsIGtlZXBpbmcgdGhlIHJpZ2h0IHZhbHVlIGZvciA2
MDkyIGFuZCA2MDk1LCBidXQgSSdkIGFsc28gYmUNCmNoYW5naW5nIHRoZSB2YWx1ZSBmb3IgYSB3
aG9sZSBsb3Qgb2Ygb3RoZXIgY2hpcHMgZm9yIHdoaWNoIEkgZG9uJ3Qga25vdw0Kd2hpY2ggb25l
IHdvdWxkIGJlIHRoZSByaWdodCBvbmUuDQoNCk9yaWdpbmFsbHkgSSB0aG91Z2h0IHRoYXQgMHhm
YTUwIHdhcyB0aGUgcmlnaHQgdmFsdWUgZm9yIGFsbCBjaGlwcw0KKHNpbXBseSBiZWNhdXNlIHgg
LT4gZmxvb3IoeC8yKSBpcyBhIHNhbmUgZGVmYXVsdCBtYXBwaW5nKSwgYnV0IHNpbmNlIEkNCm5v
dyBrbm93IHRoYXQgMHhmYTQxIChpLmUuLCAzIGFuZCAwIGFyZSBtYXBwZWQgdG8gMSwgMiBhbmQg
MSBhcmUgbWFwcGVkDQp0byAwKSBpcyB0aGUgcmVzZXQgdmFsdWUgZm9yIGF0IGxlYXN0IHNvbWUg
Y2hpcHMsIEknZCByYXRoZXIgbm90IG1ha2UgYQ0KYmxhbmtldCBjaGFuZ2UgdGhhdCBtaWdodCBm
aXggc29tZSBhbmQgImJyZWFrIiBvdGhlciBjaGlwcy4NCg0KUmFzbXVzDQo=

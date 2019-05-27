Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E89512B5F7
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 15:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbfE0NCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 09:02:08 -0400
Received: from mail-eopbgr140127.outbound.protection.outlook.com ([40.107.14.127]:34019
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726063AbfE0NCH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 09:02:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUASQQ2VH355KevFzViZqyp/z0a2OkUPgFglV3X4B5k=;
 b=eukz2Quoj2YnXP/cNoZG3rBUejyfupIijhPqgntIJpOPx+qJ0YHmGOKIBkjJaKcwQewR1kbmAWeGoFVGlFBjh4Osgl3VZuzPvKBaMKzjUIo6xoGOxCt6lvVpl9OCnSLb3fJefGLr5guUoWCo2b8b5tvOny5B5GvS5fs727amKko=
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM (20.178.126.80) by
 VI1PR10MB2238.EURPRD10.PROD.OUTLOOK.COM (20.177.62.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Mon, 27 May 2019 13:02:04 +0000
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5]) by VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5%6]) with mapi id 15.20.1922.021; Mon, 27 May 2019
 13:02:04 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Vivien Didelot <vivien.didelot@gmail.com>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: reset value of MV88E6XXX_G1_IEEE_PRI
Thread-Topic: reset value of MV88E6XXX_G1_IEEE_PRI
Thread-Index: AQHVFG+fncWQ8lohfEiBAdvF6CsT76Z+546AgAAIUoA=
Date:   Mon, 27 May 2019 13:02:04 +0000
Message-ID: <493a84d0-5319-41ce-1437-77daf8813d39@prevas.dk>
References: <4e5592a2-bce3-127b-99e1-7fab00dc0511@prevas.dk>
 <20190527083215.GB2594@t480s.localdomain>
In-Reply-To: <20190527083215.GB2594@t480s.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0701CA0046.eurprd07.prod.outlook.com
 (2603:10a6:3:9e::14) To VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66eabc69-49d1-447b-acf5-08d6e2a383d6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR10MB2238;
x-ms-traffictypediagnostic: VI1PR10MB2238:
x-microsoft-antispam-prvs: <VI1PR10MB2238103878A282759BC9969C8A1D0@VI1PR10MB2238.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0050CEFE70
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(346002)(396003)(376002)(39850400004)(199004)(189003)(6116002)(66066001)(6486002)(64756008)(66446008)(3846002)(31696002)(42882007)(74482002)(54906003)(2906002)(256004)(72206003)(5660300002)(8676002)(6512007)(68736007)(25786009)(81156014)(81166006)(229853002)(316002)(8936002)(99286004)(7736002)(71200400001)(2616005)(71190400001)(6436002)(36756003)(76176011)(52116002)(102836004)(26005)(386003)(6506007)(4326008)(305945005)(186003)(66946007)(31686004)(486006)(53936002)(478600001)(66476007)(66556008)(476003)(6916009)(73956011)(8976002)(11346002)(446003)(14454004)(44832011)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB2238;H:VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: taEXExIDLW6Mtftm8jxjMCgroQrMYXfRHn3v39cCZZrqh1no+smrv24GmYzlfy5d/KbMgy0AqI6zKQIzu2PcYfd28d2sal27kExEO5DKnLGHdhyFZbNBit0XmC8m0XrCg3izF1kb+ARoOeqD7bgYoKUBHVXjwrvc4hVe71aH72zvvlu4ff34u0wlQ3GDHqv8yM0Mby6f6nBsHD98tLqpEaHTtXHW8OD8Vr6Z2gosgO72Xf9jg4REHB94O9RFT26C/Z0R/A0aIZ/xLJ376bwu60HNhmnUmcnpBwBGiBJLrfON7DKwjxqwCOJaF3jFt2rpszxixe7JAePHoGWfGzHo1sT31RpYMmVx1KgmJEwbtdImF7Pg5dpZYC2vCDfUdfa85lEMRO3O4HmC+X3ngpHpQIR3mk4Me63mfx7smNTpzcM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A34C020B6F5EC479442FEECCEF12A6E@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 66eabc69-49d1-447b-acf5-08d6e2a383d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2019 13:02:04.2692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB2238
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjcvMDUvMjAxOSAxNC4zMiwgVml2aWVuIERpZGVsb3Qgd3JvdGU6DQo+IEhpIFJhc211cywN
Cj4gDQo+IE9uIE1vbiwgMjcgTWF5IDIwMTkgMDk6MzY6MTMgKzAwMDAsIFJhc211cyBWaWxsZW1v
ZXMgPHJhc211cy52aWxsZW1vZXNAcHJldmFzLmRrPiB3cm90ZToNCj4+IExvb2tpbmcgdGhyb3Vn
aCB0aGUgZGF0YSBzaGVldHMgY29tcGFyaW5nIHRoZSBtdjg4ZTYyNDAgYW5kIDYyNTAsIEkNCj4+
IG5vdGljZWQgdGhhdCB0aGV5IGhhdmUgdGhlIGV4YWN0IHNhbWUgZGVzY3JpcHRpb24gb2YgdGhl
IEcxX0lFRUVfUFJJDQo+PiByZWdpc3RlciAoZ2xvYmFsMSwgb2Zmc2V0IDB4MTgpLiBIb3dldmVy
LCB0aGUgY3VycmVudCBjb2RlIHVzZWQgYnkgNjI0MCBkb2VzDQo+Pg0KPj4gaW50IG12ODhlNjA4
NV9nMV9pZWVlX3ByaV9tYXAoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwKQ0KPj4gew0KPj4g
CS8qIFJlc2V0IHRoZSBJRUVFIFRhZyBwcmlvcml0aWVzIHRvIGRlZmF1bHRzICovDQo+PiAJcmV0
dXJuIG12ODhlNnh4eF9nMV93cml0ZShjaGlwLCBNVjg4RTZYWFhfRzFfSUVFRV9QUkksIDB4ZmE0
MSk7DQo+PiB9DQo+Pg0KPj4gd2hpbGUgaWYgbXkgcmVhZGluZyBvZiB0aGUgZGF0YSBzaGVldCBp
cyBjb3JyZWN0LCB0aGUgcmVzZXQgdmFsdWUgaXMNCj4+IHJlYWxseSAweGZhNTAgKGZpZWxkcyA3
OjYgYW5kIDU6NCBhcmUgUldTIHRvIDB4MSwgZmllbGQgMzoyIGFuZCAxOjAgYXJlDQo+PiBSV1Ip
IC0gYW5kIHRoaXMgaXMgYWxzbyB0aGUgdmFsdWUgSSByZWFkIGZyb20gdGhlIDYyNTAgb24gb3Vy
IG9sZCBCU1ANCj4+IHdpdGggYW4gb3V0LW9mLXRyZWUgZHJpdmVyIHRoYXQgZG9lc24ndCB0b3Vj
aCB0aGF0IHJlZ2lzdGVyLiBUaGlzIHNlZW1zDQo+PiB0byBnbyB3YXkgYmFjayAoYXQgbGVhc3Qg
M2IxNTg4NTkzMDk3KS4gU2hvdWxkIHRoaXMgYmUgbGVmdCBhbG9uZSBmb3INCj4+IG5vdCByaXNr
aW5nIGJyZWFraW5nIGV4aXN0aW5nIHNldHVwcyAoanVzdCB1cGRhdGluZyB0aGUgY29tbWVudCks
IG9yIGNhbg0KPj4gd2UgbWFrZSB0aGUgY29kZSBtYXRjaCB0aGUgY29tbWVudD8gT3IgYW0gSSBq
dXN0IHJlYWRpbmcgdGhpcyBhbGwgd3Jvbmc/DQo+IA0KPiBJZiB0aGUgcmVzZXQgdmFsdWUgaXNu
J3QgdGhlIHNhbWUsIHRoZSBiaXRzIGFyZSBjZXJ0YWlubHkgZGlmZmVyZW50bHkNCj4gb3JnYW5p
emVkIGluc2lkZSB0aGlzIHJlZ2lzdGVyLCBzbyB0aGUgcHJvcGVyIHdheSB3b3VsZCBiZSB0byBh
ZGQgYQ0KPiBtdjg4ZTYyNDBfZzFfaWVlZV9wcmlfbWFwIGZ1bmN0aW9uLCB1c2VkIGJ5IGJvdGgg
ODhFNjI0MCBhbmQgODhFNjI1MC4NCj4gDQoNCkJhc2VkIG9uIHRoZSB2ZXJ5IHN5c3RlbWF0aWMg
ZGVzY3JpcHRpb24gW2llZWUgdGFncyA3IGFuZCA2IGFyZSBtYXBwZWQNCnRvIDMsIDUgYW5kIDQg
dG8gMiwgMyBhbmQgMiB0byAxLCBhbmQgMSBhbmQgMCB0byAwXSwgSSBzdHJvbmdseSBiZWxpZXZl
DQp0aGF0IDB4ZmE1MCBpcyBhbHNvIHRoZSByZXNldCB2YWx1ZSBmb3IgdGhlIDYwODUsIHNvIHRo
aXMgaXMgbW9zdCBsaWtlbHkNCndyb25nIGZvciBhbGwgdGhlIGN1cnJlbnQgY2hpcHMgLSB0aG91
Z2ggSSBkb24ndCBoYXZlIGEgNjA4NSBkYXRhIHNoZWV0Lg0KDQpJIGNhbiBjZXJ0YWlubHkgYWRk
IGEgNjI1MCB2YXJpYW50IHRoYXQgZG9lcyB0aGUgcmlnaHQgdGhpbmcgZm9yIHRoZQ0KNjI1MCwg
YW5kIEkgcHJvYmFibHkgd2lsbCAtIHRoaXMgaXMgbW9yZSBhIHF1ZXN0aW9uIGFib3V0IHRoZSBj
dXJyZW50IGNvZGUuDQoNCj4gSSdtIG5vdCBhIGJpZyBmYW4gb2YgcmV3cml0aW5nIHRoZSBkZWZh
dWx0IHZhbHVlcywgYnV0IHRoYXQgaXMgdGhlDQo+IHdheSB3ZSBjaG9zZSB1bnRpbCB3ZSBtYWtl
IGFjdHVhbGx5IHVzZSBvZiB0aGVzZSB0YWcgcHJpb3JpdHkgYml0cy4NCg0KWWVzLCBJIHdhcyB3
b25kZXJpbmcgd2h5IHRoZXJlJ3MgYSBsb3Qgb2YgY29kZSB3aGljaCBzaW1wbHkgc2VydmVzIHRv
DQpzZXQgZGVmYXVsdCB2YWx1ZXMgLSBidXQgSSBndWVzcyBpdCBtYWtlcyBzZW5zZSB0byBmb3Jj
ZSB0aGUgc3dpdGNoIGludG8NCmEga25vd24gc3RhdGUgaW4gY2FzZSB0aGUgYm9vdGxvYWRlciBk
aWQgc29tZXRoaW5nIG9kZC4NCg0KUmFzbXVzDQo=

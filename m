Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 019B2BEC8E
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 09:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbfIZHap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 03:30:45 -0400
Received: from mail-eopbgr50074.outbound.protection.outlook.com ([40.107.5.74]:35648
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726521AbfIZHao (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 03:30:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YaJHPeski5GrG5Z0n2gowNoC6Lj3XNdMYIJK24+T+HkrOHcq0l2ODdgtDSqKGF/g52DJ15zCaPOAuuFfnuuaYNpyteG5leeGK+gdbtuIuG8UTde9vuTvpiLtj/N+exIskz/zxj8OWW4yWME20mr0UosGaUO+vN2BriKvuS0ySG7ccWqLaiDM1eT4IZI7iTPJ67WWmpSUhD3crA1jaDk5OBtVojuFWazcoXP8NSFjOu8GOtBvPYeMOHIYwF0TyOh1G3jyiP7pUXqRVghoyZ7G9ytAREUXeih1bWEYjiapfGdGjxszFcyD4tR3QSzVPjnB7VhF7wt6RupEiOLEenLnmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+dLbdoVd3H6cvH2/T8GnbaypbYv3HrcJguIM9DOFvs=;
 b=M1MwNrpLS4gh0dkxidFZORiOg8om4NzdQWJTRrnPZ+Z88IeZFFc+79/xoBLY9OIF/s6YIEk/Cz7PpkODEiDNOoIOMTjgyvbzU0PMGc8NTOgd/DCJEVtp/gSnZX9GnNhBbXMUB5xlB2OgaKCjicZ2ysIF6CIaP0GEhJoOZ4R1r73tb0QdQ77bFyEb96lQadMq6GxpKcgWz/h43wMpDCZGeKC0G4LJSXXlpS1i1Z5fkYN6/Nt6R2If+Bz3m0PsCbD0j5DQs4mShyUP/XbyHKo9fwHmc6q4NrYJyrFVHHGJWZvDu8D81JdADz+HyfwWDuyYv//6FHLV/vtgjdEurfLcSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+dLbdoVd3H6cvH2/T8GnbaypbYv3HrcJguIM9DOFvs=;
 b=JC2b4YhNVQ2YTk7k6U7pCWsuwft9izdN2d3udbHz+KupGzzacOhTc8xSdjTqnFnqeduADA3B8IPaXlIL0LCuV6R+xFO7SDHXV4M+IcaA/r1Kw5in0KWWUHGWqJjEF+MLPmWmaD8jrn5Q6YgtE5UCbDFy7TGp1Dgmjl6IFqItpac=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3364.eurprd05.prod.outlook.com (10.171.191.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.21; Thu, 26 Sep 2019 07:30:40 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::bd07:1f1a:7d30:7a5b]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::bd07:1f1a:7d30:7a5b%7]) with mapi id 15.20.2305.017; Thu, 26 Sep 2019
 07:30:40 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Edward Cree <ecree@solarflare.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Pravin Shelar <pshelar@ovn.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@netronome.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: CONFIG_NET_TC_SKB_EXT
Thread-Topic: CONFIG_NET_TC_SKB_EXT
Thread-Index: AQHVbtxxDxq98BXUU0W1ldTc//QoBKczG/uAgAGj5oCAAGQoAIAAC2iAgAATpQCAAcftgIAAGgkAgAB1cACAAKZjgIABc1wA///TvACAATZdAIAB6dAAgADyt4A=
Date:   Thu, 26 Sep 2019 07:30:40 +0000
Message-ID: <541fde6d-01ce-edf3-84e4-153756aba00f@mellanox.com>
References: <CAADnVQJBxsWU8BddxWDBX==y87ZLoEsBdqq0DqhYD7NyEcDLzg@mail.gmail.com>
 <1569153104-17875-1-git-send-email-paulb@mellanox.com>
 <20190922144715.37f71fbf@cakuba.netronome.com>
 <68c6668c-f316-2ceb-31b0-8197d22990ae@mellanox.com>
 <d6867e6c-2b81-5fcd-1d88-46663bed6e26@solarflare.com>
 <4f99e2b6-0f09-9d2c-6300-dfc884d501a8@mellanox.com>
 <3c09871f-a367-56ca-0d25-f0699a7b79d0@solarflare.com>
In-Reply-To: <3c09871f-a367-56ca-0d25-f0699a7b79d0@solarflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR06CA0006.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::19) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1127aac-acd6-4f35-8e5b-08d742536e96
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR05MB3364;
x-ms-traffictypediagnostic: AM4PR05MB3364:|AM4PR05MB3364:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB3364A4A8F8B8EDDA05F5D9D7CF860@AM4PR05MB3364.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0172F0EF77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(396003)(346002)(39860400002)(199004)(189003)(31686004)(316002)(66066001)(110136005)(256004)(14444005)(71190400001)(7416002)(81156014)(71200400001)(478600001)(3846002)(8936002)(81166006)(54906003)(6116002)(36756003)(99286004)(76176011)(14454004)(7116003)(11346002)(2616005)(476003)(446003)(4326008)(5660300002)(486006)(7736002)(31696002)(305945005)(86362001)(8676002)(2906002)(102836004)(186003)(25786009)(26005)(66476007)(66556008)(53546011)(64756008)(6246003)(6436002)(6486002)(52116002)(66446008)(66946007)(386003)(6506007)(6512007)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3364;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xiS+yJyVs9rcMIgAaJF4vUVMUaqfUGGY3Gt4BDMNbNlxOHs8PcaefcfL7xQ+WZrk6AP6as9WC0OLWh2/8CEboMtxfxn7MIIQhshrA6x5Su+n+gFXicLod9iQTbzCbr7BLZNK8Bzc/z+Pr3BysXV1IJ7rATzOsE9oLiG07ZzZ9CS8shd/XO8OIO9cC0rvf8KWBeyF4zRmhfjhoE+CbQhK0FhGIFmyO96AYEdEasJ+buB8pHuErrNEtfrs4N225uj6y3uCnYxSOEQKlUxNQgVxxUfMdUQyxQZ8gZBeb9cEpd9fou9Yj3BpYtZwekoMjAVR70UvpDyK60ah7+V4o2RiE9cqf3RV9dkYCzVuxrwZHpGZSCgBmNqAC8bA+Vn83pZ30wb0+URdsEN4Z/TjFPQXzA4q0vBEux52cYgo+ycUCnE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3003BB1E22F8DE4DBF30BFD86B1534AA@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1127aac-acd6-4f35-8e5b-08d742536e96
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2019 07:30:40.3542
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ezBWUylQEZGxlEWMvitPLtFco2asAw8c0p1z/b5WOz5QcBFsVYlecFw0L12xbECmyNvtT/TdE3etdW8+nrbjMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3364
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA5LzI1LzIwMTkgODowMSBQTSwgRWR3YXJkIENyZWUgd3JvdGU6DQo+IE9uIDI0LzA5LzIw
MTkgMTI6NDgsIFBhdWwgQmxha2V5IHdyb3RlOg0KPj4gVGhlICdtaXNzJyBmb3IgYWxsIG9yIG5v
dGhpbmcgaXMgZWFzeSwgYnV0IHRoZSBoYXJkIHBhcnQgaXMgY29tYmluaW5nDQo+PiBhbGwgdGhl
IHBhdGhzIGEgcGFja2V0IGNhbiB0YWtlIGluIHNvZnR3YXJlIHRvIGEgc2luZ2xlICdhbGwgb3Ig
bm90aGluZycNCj4+IHJ1bGUgaW4gaGFyZHdhcmUuDQo+IEJ1dCB5b3UgZG9uJ3QgY29tYmluZSB0
aGVtIHRvIGEgc2luZ2xlIHJ1bGUgaW4gaGFyZHdhcmUsIGJlY2F1c2UgeW91DQo+ICDCoGhhdmUg
bXVsdGlwbGUgc2VxdWVudGlhbCB0YWJsZXMuwqAgKEkganVzdCBzcGVudCB0aGUgbGFzdCBmZXcg
d2Vla3MNCj4gIMKgdGVsbGluZyBvdXIgaGFyZHdhcmUgZ3V5cyB0aGF0IG5vLCB0aGV5IGNhbid0
IGp1c3QgZ2l2ZSB1cyBvbmUgYmlnDQo+ICDCoHRhYmxlIGFuZCBleHBlY3QgdGhlIGRyaXZlciB0
byBkbyBhbGwgdGhhdCBjb21iaW5pbmcsIGJlY2F1c2UgYXMgeW91DQo+ICDCoHNheSwgaXQncyAn
dGhlIGhhcmQgcGFydCcuKQ0KPg0KPj4gV2hhdCBpZiB5b3UgJ21pc3MnIG9uIHRoZSBtYXRjaCBm
b3IgdGhlIHR1cGxlPyBZb3UgYWxyZWFkeSBkaWQgc29tZQ0KPj4gcHJvY2Vzc2luZyBpbiBoYXJk
d2FyZSwgc28gZWl0aGVyIHlvdSByZXZlcnQgdGhvc2UsIG9yIHlvdSBjb250aW51ZSBpbg0KPj4g
c29mdHdhcmUgd2hlcmUgeW91IGxlZnQgb2ZmwqAgKHRoZSBhY3Rpb24gY3QpLg0KPiBCdXQgdGhl
IG9ubHkgcHJvY2Vzc2luZyB5b3UgZGlkIHdhcyB0byBtYXRjaCBzdHVmZiBhbmQgZ2VuZXJhdGUg
bWV0YWRhdGENCj4gIMKgaW4gdGhlIGZvcm0gb2YgbG9va3VwIGtleXMgKGUuZy4gYSBjdF96b25l
KSBmb3IgdGhlIG5leHQgcm91bmQgb2YNCj4gIMKgbWF0Y2hpbmcuwqAgVGhlcmUncyBub3RoaW5n
IHRvICJyZXZlcnQiIHVubGVzcyB5b3UndmUgYWN0dWFsbHkgbW9kaWZpZWQNCj4gIMKgdGhlIHBh
Y2tldCBiZWZvcmUgc2VuZGluZyBpdCB0byBDVCwgYW5kIGFzIEkgc2FpZCBJIGRvbid0IGJlbGll
dmUgdGhhdCdzDQo+ICDCoHdvcnRoIHN1cHBvcnRpbmcuDQo+DQo+PiBUaGUgYWxsIG9yIG5vdGhp
bmcgYXBwcm9hY2ggd2lsbCByZXF1aXJlIGNoYW5naW5nIHRoZSBzb2Z0d2FyZSBtb2RlbCB0bw0K
Pj4gYWxsb3cNCj4+DQo+PiBtZXJnaW5nIHRoZSBjdCB6b25lIHRhYmxlIG1hdGNoZXMgaW50byB0
aGUgaGFyZHdhcmUgcnVsZXMNCj4gSSBkb24ndCBrbm93IGhvdyBtdWNoIG1vcmUgY2xlYXJseSBJ
IGNhbiBzYXkgdGhpczogYWxsLW9yLW5vdGhpbmcgZG9lcyBub3QNCj4gIMKgcmVxdWlyZSBtZXJn
aW5nLsKgIEl0IGp1c3QgcmVxdWlyZXMgYW55IGFjdGlvbnMgdGhhdCBjb21lIGJlZm9yZSBhIG1h
dGNoaW5nDQo+ICDCoHN0YWdlIChhbmQgdGhhdCB0aGUgaHcgZG9lc24ndCBoYXZlIHRoZSBjYXBh
YmlsaXR5IHRvIHJldmVydCkgdG8gcHV0IGENCj4gIMKgcnVsZSBzdHJhaWdodCBpbiB0aGUgJ25v
dGhpbmcnIGJ1Y2tldC4NCj4gU28gaWYgeW91IHdyaXRlDQo+ICDCoCBjaGFpbiAwIGRzdF9tYWMg
YWE6YmI6Y2M6ZGQ6ZWU6ZmYgY3Rfc3RhdGUgLXRya8KgIGFjdGlvbiB2bGFuIHB1c2ggYmxhaCBh
Y3Rpb24gY3QgYWN0aW9uIGdvdG8gY2hhaW4gWA0KPiAgwqB0aGUgZHJpdmVyIGNhbiBzYXkgLUVP
UE5PVFNVUFAgYmVjYXVzZSB5b3UgcHVzaGVkIGEgVkxBTiBhbmQgbWlnaHQgc3RpbGwNCj4gIMKg
bWlzcyBpbiBjaGFpbiBYLsKgIEJ1dCBpZiB5b3Ugd3JpdGUNCj4gIMKgIGNoYWluIDAgZHN0X21h
YyBhYTpiYjpjYzpkZDplZTpmZiBjdF9zdGF0ZSAtdHJrwqAgYWN0aW9uIGN0IGFjdGlvbiBnb3Rv
IGNoYWluIFgNCj4gIMKgdGhlbiB0aGUgZHJpdmVyIHdpbGwgaGFwcGlseSBvZmZsb2FkIHRoYXQg
YmVjYXVzZSBpZiB5b3UgbWlzcyBpbiB0aGUgbGF0ZXINCj4gIMKgbG9va3VwcyB5b3UndmUgbm90
IGFsdGVyZWQgdGhlIHBhY2tldCDigJQgdGhlIGNoYWluMC1ydWxlIGlzICppZGVtcG90ZW50KiBz
bw0KPiAgwqBpdCBkb2Vzbid0IG1hdHRlciBpZiBIVyBhbmQgU1cgYm90aCBwZXJmb3JtIGl0LsKg
IChPciBldmVuIGFsbCB0aHJlZSBvZiBIVywNCj4gIMKgdGMgYW5kIE92Uy4pDQoNCg0KT2ssIEkg
dGhvdWdodCB5b3UgbWVhbnQgbWVyZ2luZyB0aGUgcnVsZXMgYmVjYXVzZSB3ZSBkbyB3YW50IHRv
IHN1cHBvcnQgDQp0aG9zZSBtb2RpZmljYXRpb25zIHVzZS1jYXNlcy4NCg0KSW4gbmF0IHNjZW5h
cmlvcyB0aGUgcGFja2V0IHdpbGwgYmUgbW9kaWZpZWQsIGFuZCB0aGVuIHRoZXJlIGNhbiBiZSBh
IG1pc3M6DQoNCiDCoMKgwqDCoMKgwqDCoMKgwqDCoCAtdHJrIC4uLi4gQ1Qoem9uZSBYLCBSZXN0
b3JlIE5BVCksZ290byBjaGFpbiAxDQoNCiDCoMKgwqDCoMKgwqDCoMKgwqDCoCArdHJrK2VzdCwg
bWF0Y2ggb24gaXB2NCwgQ1Qoem9uZSBZKSwgZ290byBjaGFpbiAyDQoNCiDCoMKgwqDCoMKgwqDC
oMKgwqDCoCArdHJrK2VzdCwgb3V0cHV0Li4NCg0KDQpJbiB0dW5uZWxpbmcgc2NlbmFyaW9zLCB0
aGUgdHVubmVsIGRldmljZSBkZWNhcHN1bGF0ZXMgdGhlIHBhY2tldCBiZWZvcmUgDQppdCBldmVu
IHJlYWNoZXMgT3ZTL1RjLCB3aGljaCBpcyBhbm90aGVywqAgbW9kaWZpY2F0aW9uLg0KDQpBbHNv
LCB0aGVyZSBhcmUgc3RhdHMgaXNzdWVzIGlmIHdlIGFscmVhZHkgYWNjb3VudGVkIGZvciBzb21l
IGFjdGlvbnMgaW4gDQpoYXJkd2FyZS4NCg0KDQpQYXVsLg0KDQoNCg0KDQo=

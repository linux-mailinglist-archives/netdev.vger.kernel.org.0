Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F58C739B1
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 21:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390426AbfGXTmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 15:42:51 -0400
Received: from mail-eopbgr40088.outbound.protection.outlook.com ([40.107.4.88]:54849
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390412AbfGXTmu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 15:42:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KuJJWAk3movqeKoOqz46qspf/d4B1/f7jNmpPOiYacEYIFkdwtmJBx8xJfHLmENyVxU6s4tBwqvFUZvBYXB5CewAVhh9xKCbwqZQvsvyylCW5k8j2UqrLsWX2nx5XIN+E9yeJv5xFkqa2cUajUC3CLaZoSiw6gURkVza2W6QWCUeX5/KiL7E8a4Va2rideH+fCpCLkAa/ZhO3jxxv0TiSWfXkcsedMiOYsga8jVArbO28q1JgjqodlsBaYHlh2uURlLFnvt2JFY2w3l+QXK1jZCIDjPhhMFmkkqR2hjwbeteoLykdJ9w428h79iq99ixb8gYrVBklFD60XOYc+6fIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hm0Qx4QfmKv49HXrsE+yEEsib1PxZfncCrvX6be20JA=;
 b=oZVVT93e6tl/WFLwfAxTxBNOIRbfCwdLc0J8zqsxqpWqicrrhvPlfGiKiYc5Db6Dxkb7y9jdGVNuvLgltVdmFHb/SXuq8SrZlJbWDQlvODnTFGjgSkcU1nYwZ8513kcCJzLWGlaoXiXljDADCU4QxthJaZn1QiOXEDBzwo/WlZV0wch4Cvi49Q9s0MxN5V32yluMSKoV0jJBxMNOMZCcGdiBC8GFIdFTRtqlfgMnVF+1KuTukv4is10fHbuw1/YMahc742pPuGnsFmoijkYogjTr63LrRWVSHMPqTWTgACChwlrB2Kg6LntnR2VcJTWzfViMxtsw9Lj1V6mOZTX5gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hm0Qx4QfmKv49HXrsE+yEEsib1PxZfncCrvX6be20JA=;
 b=osgpk7EEouK2DYaE9RQInLiB0QY5P0FhXyDU+XLp6w0EFufP3d3coG2hzPm/rK/1qhZ0e1cX7ur66v0Ki3eIxMSMTXibj7umCl5qzNmZw7reM7L3luihB6dsxvodukvxOnp8pB34XGqeVL0+dwTmWlmONA7MfKJLP7fJ6DXRFHg=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2165.eurprd05.prod.outlook.com (10.168.55.134) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Wed, 24 Jul 2019 19:42:46 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Wed, 24 Jul 2019
 19:42:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "skalluru@marvell.com" <skalluru@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "aelior@marvell.com" <aelior@marvell.com>,
        "mkalderon@marvell.com" <mkalderon@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] qed: Add API for flashing the nvm
 attributes.
Thread-Topic: [PATCH net-next 2/2] qed: Add API for flashing the nvm
 attributes.
Thread-Index: AQHVQduLZVoKGVtDL0SZAJwk9KfVQabaLDSA
Date:   Wed, 24 Jul 2019 19:42:45 +0000
Message-ID: <24c09b029d00ba73aab58ef09a2e65ac545b3423.camel@mellanox.com>
References: <20190724045141.27703-1-skalluru@marvell.com>
         <20190724045141.27703-3-skalluru@marvell.com>
In-Reply-To: <20190724045141.27703-3-skalluru@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2503bd34-91d0-4758-5dc7-08d7106f1a14
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2165;
x-ms-traffictypediagnostic: DB6PR0501MB2165:
x-microsoft-antispam-prvs: <DB6PR0501MB216588145B81E09803DF1CD5BEC60@DB6PR0501MB2165.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(346002)(39860400002)(396003)(189003)(199004)(66946007)(66066001)(66556008)(76176011)(81166006)(66476007)(66446008)(81156014)(446003)(76116006)(91956017)(64756008)(8936002)(4326008)(25786009)(86362001)(14444005)(256004)(14454004)(54906003)(316002)(58126008)(478600001)(36756003)(110136005)(486006)(99286004)(53936002)(5660300002)(2906002)(6246003)(305945005)(476003)(6436002)(26005)(229853002)(6486002)(6506007)(102836004)(186003)(71200400001)(2501003)(68736007)(118296001)(6512007)(2616005)(3846002)(7736002)(6116002)(11346002)(8676002)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2165;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BQyE/j5sjAsA+IDj34j8OTT6UFJITfidDh5naz4to8gz3SmXmTCRE4nLhTpVDyOCbRbo+MhHTIn0YatmSi3bCo/dRFcaatIn0JM8bwwZ+8IyqFw7t2lrZjwzqjmOBtUriTEs8ZHLSuY8jWxA16OCECcE0fFUyHoDzD72X1qk7vQfxRs6vonEG8YX38k0LklVy+tfPqUocIlHpegT0EZMZtdgxN1iqvuxTBCSTSnPfUp16+VPtK463MumEz+xb6ZAME/qbDaUNs+r3rPB11aYfp1MlsMP4JBL7LsRHWhLi8VUwP/c3IvncHgqsJlW4SSYyhKKR2f/vlavgnQ6nAYYdZKbcNat1fkk4j0tCHUZUwvZstyTKhuZNSYvsbI/9Cxm8SdG7rAof7SzRCAqc1xb627tXN4ZsFuY+n1vXV56bvw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF8A8D403E45784D960410782A3FDCA8@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2503bd34-91d0-4758-5dc7-08d7106f1a14
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 19:42:45.9811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2165
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA3LTIzIGF0IDIxOjUxIC0wNzAwLCBTdWRhcnNhbmEgUmVkZHkgS2FsbHVy
dSB3cm90ZToNCj4gVGhlIHBhdGNoIGFkZHMgZHJpdmVyIGludGVyZmFjZSBmb3IgcmVhZGluZyB0
aGUgTlZNIGNvbmZpZyByZXF1ZXN0DQo+IGFuZA0KPiB1cGRhdGUgdGhlIGF0dHJpYnV0ZXMgb24g
bnZtIGNvbmZpZyBmbGFzaCBwYXJ0aXRpb24uDQo+IA0KDQpZb3UgZGlkbid0IG5vdCB1c2UgdGhl
IGdldF9jZmcgQVBJIHlvdSBhZGRlZCBpbiBwcmV2aW91cyBwYXRjaC4NCg0KQWxzbyBjYW4geW91
IHBsZWFzZSBjbGFyaWZ5IGhvdyB0aGUgdXNlciByZWFkcy93cml0ZSBmcm9tL3RvIE5WTSBjb25m
aWcNCj8gaSBtZWFuIHdoYXQgVUFQSXMgYW5kIHRvb2xzIGFyZSBiZWluZyB1c2VkID8NCg0KPiBT
aWduZWQtb2ZmLWJ5OiBTdWRhcnNhbmEgUmVkZHkgS2FsbHVydSA8c2thbGx1cnVAbWFydmVsbC5j
b20+DQo+IFNpZ25lZC1vZmYtYnk6IEFyaWVsIEVsaW9yIDxhZWxpb3JAbWFydmVsbC5jb20+DQo+
IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcWxvZ2ljL3FlZC9xZWRfbWFpbi5jIHwgNjUN
Cj4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICBpbmNsdWRlL2xpbnV4L3FlZC9x
ZWRfaWYuaCAgICAgICAgICAgICAgICAgfCAgMSArDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDY2IGlu
c2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9xbG9n
aWMvcWVkL3FlZF9tYWluLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9xbG9naWMvcWVkL3Fl
ZF9tYWluLmMNCj4gaW5kZXggODI5ZGQ2MC4uNTRmMDBkMiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvcWxvZ2ljL3FlZC9xZWRfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L3Fsb2dpYy9xZWQvcWVkX21haW4uYw0KPiBAQCAtNjcsNiArNjcsOCBAQA0KPiAg
I2RlZmluZSBRRURfUk9DRV9RUFMJCQkoODE5MikNCj4gICNkZWZpbmUgUUVEX1JPQ0VfRFBJUwkJ
CSg4KQ0KPiAgI2RlZmluZSBRRURfUkRNQV9TUlFTICAgICAgICAgICAgICAgICAgIFFFRF9ST0NF
X1FQUw0KPiArI2RlZmluZSBRRURfTlZNX0NGR19TRVRfRkxBR1MJCTB4RQ0KPiArI2RlZmluZSBR
RURfTlZNX0NGR19TRVRfUEZfRkxBR1MJMHgxRQ0KPiAgDQo+ICBzdGF0aWMgY2hhciB2ZXJzaW9u
W10gPQ0KPiAgCSJRTG9naWMgRmFzdExpblEgNHh4eHggQ29yZSBNb2R1bGUgcWVkICIgRFJWX01P
RFVMRV9WRVJTSU9ODQo+ICJcbiI7DQo+IEBAIC0yMjI3LDYgKzIyMjksNjYgQEAgc3RhdGljIGlu
dCBxZWRfbnZtX2ZsYXNoX2ltYWdlX3ZhbGlkYXRlKHN0cnVjdA0KPiBxZWRfZGV2ICpjZGV2LA0K
PiAgCXJldHVybiAwOw0KPiAgfQ0KPiAgDQo+ICsvKiBCaW5hcnkgZmlsZSBmb3JtYXQgLQ0KPiAr
ICogICAgIC8tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tDQo+IC0tLS0tLS0tLS0tLVwNCj4gKyAqIDBCICB8ICAgICAgICAgICAgICAgICAg
ICAgICAweDUgW2NvbW1hbmQNCj4gaW5kZXhdICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwN
Cj4gKyAqIDRCICB8IEVudGl0eSBJRCAgICAgfCBSZXNlcnZlZCAgICAgICAgfCAgTnVtYmVyIG9m
IGNvbmZpZw0KPiBhdHRyaWJ1dGVzICAgICAgIHwNCj4gKyAqIDhCICB8IENvbmZpZyBJRCAgICAg
ICAgICAgICAgICAgICAgICAgfCBMZW5ndGggICAgICAgIHwNCj4gVmFsdWUgICAgICAgICAgICAg
IHwNCj4gKw0KPiAqICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICANCj4gICAgICAgICB8DQo+ICsgKiAgICAgXC0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gLS0t
LS0tLS0tLS0tLw0KPiArICogVGhlcmUgY2FuIGJlIHNldmVyYWwgQ2ZnX2lkLUxlbmd0aC1WYWx1
ZSBzZXRzIGFzIHNwZWNpZmllZCBieQ0KPiAnTnVtYmVyIG9mLi4uJy4NCj4gKyAqIEVudGl0eSBJ
RCAtIEEgbm9uIHplcm8gZW50aXR5IHZhbHVlIGZvciB3aGljaCB0aGUgY29uZmlnIG5lZWQgdG8N
Cj4gYmUgdXBkYXRlZC4NCj4gKyAqLw0KPiArc3RhdGljIGludCBxZWRfbnZtX2ZsYXNoX2NmZ193
cml0ZShzdHJ1Y3QgcWVkX2RldiAqY2RldiwgY29uc3QgdTgNCj4gKipkYXRhKQ0KPiArew0KPiAr
CXN0cnVjdCBxZWRfaHdmbiAqaHdmbiA9IFFFRF9MRUFESU5HX0hXRk4oY2Rldik7DQo+ICsJdTgg
ZW50aXR5X2lkLCBsZW4sIGJ1ZlszMl07DQo+ICsJc3RydWN0IHFlZF9wdHQgKnB0dDsNCj4gKwl1
MTYgY2ZnX2lkLCBjb3VudDsNCj4gKwlpbnQgcmMgPSAwLCBpOw0KPiArCXUzMiBmbGFnczsNCj4g
Kw0KPiArCXB0dCA9IHFlZF9wdHRfYWNxdWlyZShod2ZuKTsNCj4gKwlpZiAoIXB0dCkNCj4gKwkJ
cmV0dXJuIC1FQUdBSU47DQo+ICsNCj4gKwkvKiBOVk0gQ0ZHIElEIGF0dHJpYnV0ZSBoZWFkZXIg
Ki8NCj4gKwkqZGF0YSArPSA0Ow0KPiArCWVudGl0eV9pZCA9ICoqZGF0YTsNCj4gKwkqZGF0YSAr
PSAyOw0KPiArCWNvdW50ID0gKigodTE2ICopKmRhdGEpOw0KPiArCSpkYXRhICs9IDI7DQo+ICsN
Cj4gKwlEUF9WRVJCT1NFKGNkZXYsIE5FVElGX01TR19EUlYsDQo+ICsJCSAgICJSZWFkIGNvbmZp
ZyBpZHM6IGVudGl0eSBpZCAlMDJ4IG51bSBfYXR0cnMgPQ0KPiAlMGRcbiIsDQo+ICsJCSAgIGVu
dGl0eV9pZCwgY291bnQpOw0KPiArCS8qIE5WTSBDRkcgSUQgYXR0cmlidXRlcyAqLw0KPiArCWZv
ciAoaSA9IDA7IGkgPCBjb3VudDsgaSsrKSB7DQo+ICsJCWNmZ19pZCA9ICooKHUxNiAqKSpkYXRh
KTsNCj4gKwkJKmRhdGEgKz0gMjsNCj4gKwkJbGVuID0gKipkYXRhOw0KPiArCQkoKmRhdGEpKys7
DQo+ICsJCW1lbWNweShidWYsICpkYXRhLCBsZW4pOw0KPiArCQkqZGF0YSArPSBsZW47DQo+ICsN
Cj4gKwkJZmxhZ3MgPSBlbnRpdHlfaWQgPyBRRURfTlZNX0NGR19TRVRfUEZfRkxBR1MgOg0KPiAr
CQkJUUVEX05WTV9DRkdfU0VUX0ZMQUdTOw0KPiArDQo+ICsJCURQX1ZFUkJPU0UoY2RldiwgTkVU
SUZfTVNHX0RSViwNCj4gKwkJCSAgICJjZmdfaWQgPSAlZCBsZW4gPSAlZFxuIiwgY2ZnX2lkLCBs
ZW4pOw0KPiArCQlyYyA9IHFlZF9tY3BfbnZtX3NldF9jZmcoaHdmbiwgcHR0LCBjZmdfaWQsIGVu
dGl0eV9pZCwNCj4gZmxhZ3MsDQo+ICsJCQkJCSBidWYsIGxlbik7DQo+ICsJCWlmIChyYykgew0K
PiArCQkJRFBfRVJSKGNkZXYsICJFcnJvciAlZCBjb25maWd1cmluZyAlZFxuIiwgcmMsDQo+IGNm
Z19pZCk7DQo+ICsJCQlicmVhazsNCj4gKwkJfQ0KPiArCX0NCj4gKw0KPiArCXFlZF9wdHRfcmVs
ZWFzZShod2ZuLCBwdHQpOw0KPiArDQo+ICsJcmV0dXJuIHJjOw0KPiArfQ0KPiArDQo+ICBzdGF0
aWMgaW50IHFlZF9udm1fZmxhc2goc3RydWN0IHFlZF9kZXYgKmNkZXYsIGNvbnN0IGNoYXIgKm5h
bWUpDQo+ICB7DQo+ICAJY29uc3Qgc3RydWN0IGZpcm13YXJlICppbWFnZTsNCj4gQEAgLTIyNjgs
NiArMjMzMCw5IEBAIHN0YXRpYyBpbnQgcWVkX252bV9mbGFzaChzdHJ1Y3QgcWVkX2RldiAqY2Rl
diwNCj4gY29uc3QgY2hhciAqbmFtZSkNCj4gIAkJCXJjID0gcWVkX252bV9mbGFzaF9pbWFnZV9h
Y2Nlc3MoY2RldiwgJmRhdGEsDQo+ICAJCQkJCQkJJmNoZWNrX3Jlc3ApOw0KPiAgCQkJYnJlYWs7
DQo+ICsJCWNhc2UgUUVEX05WTV9GTEFTSF9DTURfTlZNX0NGR19JRDoNCj4gKwkJCXJjID0gcWVk
X252bV9mbGFzaF9jZmdfd3JpdGUoY2RldiwgJmRhdGEpOw0KPiArCQkJYnJlYWs7DQo+ICAJCWRl
ZmF1bHQ6DQo+ICAJCQlEUF9FUlIoY2RldiwgIlVua25vd24gY29tbWFuZCAlMDh4XG4iLA0KPiBj
bWRfdHlwZSk7DQo+ICAJCQlyYyA9IC1FSU5WQUw7DQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xp
bnV4L3FlZC9xZWRfaWYuaCBiL2luY2x1ZGUvbGludXgvcWVkL3FlZF9pZi5oDQo+IGluZGV4IGVl
ZjAyZTYuLjIzODA1ZWEgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvbGludXgvcWVkL3FlZF9pZi5o
DQo+ICsrKyBiL2luY2x1ZGUvbGludXgvcWVkL3FlZF9pZi5oDQo+IEBAIC04MDQsNiArODA0LDcg
QEAgZW51bSBxZWRfbnZtX2ZsYXNoX2NtZCB7DQo+ICAJUUVEX05WTV9GTEFTSF9DTURfRklMRV9E
QVRBID0gMHgyLA0KPiAgCVFFRF9OVk1fRkxBU0hfQ01EX0ZJTEVfU1RBUlQgPSAweDMsDQo+ICAJ
UUVEX05WTV9GTEFTSF9DTURfTlZNX0NIQU5HRSA9IDB4NCwNCj4gKwlRRURfTlZNX0ZMQVNIX0NN
RF9OVk1fQ0ZHX0lEID0gMHg1LA0KPiAgCVFFRF9OVk1fRkxBU0hfQ01EX05WTV9NQVgsDQo+ICB9
Ow0KPiAgDQo=

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46AB5BCA43
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 16:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632790AbfIXOcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 10:32:51 -0400
Received: from mail-eopbgr770084.outbound.protection.outlook.com ([40.107.77.84]:1973
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2632786AbfIXOcv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 10:32:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IfG2yjBge1KPW76rl1i/pdq42t8qX3LNrcQAAKaG4E2UdCSmwxvS5YKmtuI3GDfZzhOhNf03DVQ2p3Wc1S6oH2kgy7ZFJGlW4TNr2Pq3RtHGM4gKEy/Z/E4vho9KdfXpAMkkft/qHbNKRg8CUsQIC+AhII+rxPNyMpiM6EypkUzToFjtmv829cKGMjQ89DkD+8azLahlNQAc+XmnYlxryWmsBlfrrYnCe1oDWnog6CAIvHTMmvBInzJqGhFel5BtEgqeXgDsuPmHuMJv17Vk83oNcJT32sSO83CJ+RS4ARNScXPBaRLWdz+SYZs5WzCoJLMoVVfR/rOhY/NDeZ/rjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=woXtD4wO2PKDPFhAtWEOPuV1P86MzNAja16WfdnmS/A=;
 b=C0Dh7XOFHmf0kupQ46RsTWvelQGosLXhrCtXXI7XsuYTP/f/yxyjFKDuF5vs2o6KjKQK0c+h2hs6RSGvmi4UGPtR96F30rS0P9yw1N/V0P9EuA54o0ha7wpxm385Ka2ncdikaYGvT2PYHprZGnXsw609+EdY0ip0HLB4KADv6STD+EL9dR5BF7Zo1P+RUQW9/6dm/nR+a9FWhLtAPXBEyLQWiGQrkA/WccovCon3S6vilOCPzgNuiDszLfUsCo9S3LqVquOtaGiDd33BWGaiRdcidFSBy5jzhm2DouhiaiNJqwdudZ4n7ECdKLVZmuas5QwP7Hw7VDyvLrHvuelhmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=woXtD4wO2PKDPFhAtWEOPuV1P86MzNAja16WfdnmS/A=;
 b=hFEhvjcCcM7iNg2tBUH3LngbEO+84ealKjipoO3HPiilx4CxPUk5GLTG2D63CshDCypzAd2X+mQdIwhCMmHCClZ6IX8/7FCtee9+y3uChqv1DeWZSTdlybh1I7tB+JmNEULuKncyfequ8HKWh5EihvJhWYsVty9Hw+VagYraowg=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3714.namprd11.prod.outlook.com (20.178.222.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.25; Tue, 24 Sep 2019 14:32:46 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::391a:d43a:162:c96a]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::391a:d43a:162:c96a%7]) with mapi id 15.20.2284.023; Tue, 24 Sep 2019
 14:32:46 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     =?utf-8?B?SG9sZ2VyIEhvZmZzdMOkdHRl?= 
        <holger@applied-asynchrony.com>, Netdev <netdev@vger.kernel.org>
Subject: Re: atlantic: weird hwmon temperature readings with AQC107 NIC
 (kernel 5.2/5.3)
Thread-Topic: atlantic: weird hwmon temperature readings with AQC107 NIC
 (kernel 5.2/5.3)
Thread-Index: AQHVcuK2rSPrJ5DcZkqcu5wiEcjygqc644sAgAAAZgA=
Date:   Tue, 24 Sep 2019 14:32:46 +0000
Message-ID: <c26f4a9d-df14-c8af-4c99-5a670099e8bc@aquantia.com>
References: <0db14339-1b69-8fa4-21fd-6d436037c945@applied-asynchrony.com>
 <4faf7584-860e-6f52-95ab-ea96438af394@applied-asynchrony.com>
In-Reply-To: <4faf7584-860e-6f52-95ab-ea96438af394@applied-asynchrony.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0122.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::14) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f83a012-cbb4-4583-be89-08d740fc1138
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR11MB3714;
x-ms-traffictypediagnostic: BN8PR11MB3714:
x-microsoft-antispam-prvs: <BN8PR11MB3714DBDF61FB49905B004B3A98840@BN8PR11MB3714.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(39850400004)(366004)(376002)(346002)(51914003)(189003)(199004)(469094003)(53484002)(6512007)(14444005)(14454004)(6116002)(2906002)(229853002)(3846002)(76176011)(66946007)(66476007)(6486002)(6246003)(25786009)(256004)(64756008)(66446008)(44832011)(11346002)(36756003)(476003)(71190400001)(5660300002)(71200400001)(99286004)(52116002)(446003)(2616005)(486006)(186003)(6506007)(386003)(7736002)(26005)(316002)(110136005)(66574012)(8936002)(81166006)(81156014)(8676002)(66556008)(31686004)(6436002)(66066001)(53546011)(31696002)(305945005)(86362001)(508600001)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3714;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: phk3EvSnJ+Bvlmj8+mytBMdo+tBqlr9y+jobppOTMkPPheCFNqaU6zLdgiVBCvhIwEuHFvuJctWRwud7wbdag9ZfKh74a585R+O7G4Qj/9Yll9nS1yFdX4Q7QFhAPmgFyG93FJVxHjSncr9Y0WG5UqfEG8kV0I05LVtAOI3HwLKynrsUmoZrX8lB1+aIt0XJlhK2s1q0Wa8z/23NJuTBKgzBLSm/ft8388GpbYmw2aftw/FncwnuC+m66ewZFk7YNprjPBWs3GWLNcLokirLuS8UkVnkXAjzvUN+IpKIRvGRIADmN2nBMWWiiSGDA++wgvgaHotGyS8je7z4fTITIsadKXBIQhFoV8WM1ZdAK7iurnLCWVZZqTitYMjjJ9QG13OHmMDGneOTt+7lzhTn9rE8qv0hiuSqY/Up4ekMSI8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <BBABFEE4EAD6BE408032081D1D06A579@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f83a012-cbb4-4583-be89-08d740fc1138
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 14:32:46.2861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hYMN4wljvkLO7lFEkOijbKjX8JijBjJudWTLERqM4nk33d5oIvHdQR3vkc23Lf8Q99a0lNVWTsTwsJXE2gjV4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3714
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDI0LjA5LjIwMTkgMTc6MzAsIEhvbGdlciBIb2Zmc3TDpHR0ZSB3cm90ZToNCj4gT24g
OS8yNC8xOSA0OjE2IFBNLCBIb2xnZXIgSG9mZnN0w6R0dGUgd3JvdGU6DQo+PiBIaSwNCj4+DQo+
PiBJIHJlY2VudGx5IHVwZ3JhZGVkIG15IGhvbWUgbmV0d29yayB3aXRoIHR3byBBUTEwNy1iYXNl
ZCBOSUNzIGFuZCBhDQo+PiBtdWx0aS1zcGVlZCBzd2l0Y2guIEV2ZXJ5dGhpbmcgd29ya3MgZ3Jl
YXQsIGJ1dCBJIGNvdWxkbid0IGhlbHAgYnV0IG5vdGljZQ0KPj4gdmVyeSB3ZWlyZCBod21vbiB0
ZW1wZXJhdHVyZSBvdXRwdXQgKHdoaWNoIEkgd2FudGVkIHRvIHVzZSBmb3IgbW9uaXRvcmluZw0K
Pj4gYW5kIGFsZXJ0aW5nKS4NCj4+DQo+PiBCb3RoIGNhcmRzIGlkZW50aWZ5IGFzOg0KPj4NCj4+
ICRsc3BjaSAtdiAtcyAwNjowMC4wDQo+PiAwNjowMC4wIEV0aGVybmV0IGNvbnRyb2xsZXI6IEFx
dWFudGlhIENvcnAuIEFRQzEwNyBOQmFzZS1UL0lFRUUgODAyLjNieg0KPj4gRXRoZXJuZXQgQ29u
dHJvbGxlciBbQVF0aW9uXSAocmV2IDAyKQ0KPj4gwqDCoMKgwqDCoFN1YnN5c3RlbTogQVNVU1Rl
SyBDb21wdXRlciBJbmMuIEFRQzEwNyBOQmFzZS1UL0lFRUUgODAyLjNieiBFdGhlcm5ldA0KPj4g
Q29udHJvbGxlciBbQVF0aW9uXQ0KPj4NCj4+IEluIG9uZSBtYWNoaW5lIGxtX3NlbnNvcnMgc2F5
czoNCj4+DQo+PiBldGgwLXBjaS0wMjAwDQo+PiBBZGFwdGVyOiBQQ0kgYWRhcHRlcg0KPj4gUEhZ
IFRlbXBlcmF0dXJlOiArMzE1LjHCsEMNCj4+DQo+PiBUaGlzIHNlZW1zIHF1aXRlIHdyb25nIHNp
bmNlIHRoZSBjYXJkIGlzIG9ubHkgc2xpZ2h0bHkgd2FybSB0byB0aGUgdG91Y2gsIGFuZA0KPj4g
MzE1LjEgaXMgZXhhY3RseSAyNTUgKyA2MC4xIC0gdGhlIGxhdHRlciB2YWx1ZSBmZWVscyBtb3Jl
IGxpa2UgdGhlIGFjdHVhbA0KPj4gdGVtcGVyYXR1cmUuDQo+Pg0KPj4gT24gYSBzZWNvbmQgbWFj
aGluZSBpdCBzYXlzOg0KPj4NCj4+IGV0aDAtcGNpLTA2MDANCj4+IEFkYXB0ZXI6IFBDSSBhZGFw
dGVyDQo+PiBQSFkgVGVtcGVyYXR1cmU6ICs2OTc3LjDCsEMNCj4+DQo+PiBJIGZlZWwgcXVhbGlm
aWVkIHRvIHNheSB0aGF0IGlzIGRlZmluaXRlbHkgd3JvbmcgYXMgd2VsbCwgc2luY2UgdGhlIG1h
Y2hpbmUgaXMNCj4+IGN1cnJlbnRseSBub3QgbWVsdGluZyBpdHMgd2F5IHRvIHRoZSBlYXJ0aCdz
IGNvcmUsIGFuZCBhbHNvIG9ubHkgc2xpZ2h0bHkgd2FybQ0KPj4gdG8gdGhlIHRvdWNoLiA6KQ0K
Pj4NCj4+IEJvdGggY2FyZHMgYWxzbyByZXBvcnRlZCB3cm9uZyB2YWx1ZXMgd2l0aCBrZXJuZWwg
NS4yLCBidXQgc2luY2UgSSdtIG9uIDUuMy4xDQo+PiBJIG1pZ2h0IGFzIHdlbGwgcmVwb3J0IHRo
ZSBjdXJyZW50IHdyb25nbmVzcy4NCj4+DQo+PiBEbyB3ZSBrbm93IHdobydzIHRvIGJsYW1lIGhl
cmUgLSBtb3RoZXJib2FyZHMsIE5JQ3MsIGRyaXZlciwga2VybmVsLCBod21vbg0KPj4gaW5mcmFz
dHJ1Y3R1cmU/IEkgYmVsaWV2ZSB0aGUgaHdtb24gcGF0Y2hlcyBsYW5kZWQgZmlyc3QgaW4gNS4y
Lg0KPiANCj4gQW5vdGhlciBvYnNlcnZhdGlvbjogdGhlIGh3bW9uIG91dHB1dCBpbW1lZGlhdGVs
eSBiZWNvbWVzIHNhbmUgKH41OMKwKQ0KPiB3aGVuIEkgZG93biB0aGUgbGluayB3aXRoIGlmY29u
ZmlnLiBBcyBzb29uIGFzIEkgYnJpbmcgdGhlIGxpbmsgYmFjayB1cCwNCj4gdGhlIHRlbXBlcmF0
dXJlIGp1bXBzIGZyb20gNTjCsCB0byA2OTc2wrAgaW4gb25lIHNlY29uZC4NCj4gSXQgc2VlbXMg
dGhhdCB0aGUgcHJlc2VuY2Ugb2YgdGhlIGNhcnJpZXIgc29tZWhvdyBtYW5nbGVzIHRoZSBzZW5z
b3INCj4gcmVhZGluZ3MuIEkgaG9wZSB0aGlzIGhlbHBzIHRvIGZpbmQgdGhlIGlzc3VlLg0KPiAN
Cj4gdGhhbmtzLA0KPiBIb2xnZXINCg0KDQpIaSBIb2xnZXIsDQoNClRoYW5rcyBmb3IgdGhlIHJl
cG9ydCwNCg0KV2UndmUgcmVjZW50bHkgZm91bmQgb3V0IHRoYXQgYXMgd2VsbCwgY291bGQgeW91
IHRyeSBhcHBseWluZyB0aGUgZm9sbG93aW5nIHBhdGNoOg0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3X2F0bF91dGlsc19mdzJ4
LmMNCmIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3X2F0
bF91dGlsc19mdzJ4LmMNCmluZGV4IGRhNzI2NDg5ZTNjOC4uMDhiMDI2YjQxNTcxIDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3X2F0
bF91dGlsc19mdzJ4LmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFu
dGljL2h3X2F0bC9od19hdGxfdXRpbHNfZncyeC5jDQpAQCAtMzM3LDcgKzMzNyw3IEBAIHN0YXRp
YyBpbnQgYXFfZncyeF9nZXRfcGh5X3RlbXAoc3RydWN0IGFxX2h3X3MgKnNlbGYsIGludCAqdGVt
cCkNCiAgICAgICAgLyogQ29udmVydCBQSFkgdGVtcGVyYXR1cmUgZnJvbSAxLzI1NiBkZWdyZWUg
Q2Vsc2l1cw0KICAgICAgICAgKiB0byAxLzEwMDAgZGVncmVlIENlbHNpdXMuDQogICAgICAgICAq
Lw0KLSAgICAgICAqdGVtcCA9IHRlbXBfcmVzICAqIDEwMDAgLyAyNTY7DQorICAgICAgICp0ZW1w
ID0gKHRlbXBfcmVzICYgMHhGRkZGKSAgKiAxMDAwIC8gMjU2Ow0KDQogICAgICAgIHJldHVybiAw
Ow0KIH0NCg0KDQoNCkZ1bm55IHRoaW5nIGlzIHRoYXQgdGhpcyB2YWx1ZSBnZXRzIHJlYWRvdXQg
ZnJvbSBIVyBtZW1vcnksIGFsbCB0aGUgcmVhZG91dHMgYXJlDQpkb25lIGJ5IGZ1bGwgZHdvcmRz
LCBidXQgdGhlIHZhbHVlIGlzIG9ubHkgd29yZCB3aWR0aC4gSGlnaCB3b3JkIG9mIHRoYXQgZHdv
cmQNCmlzIGVzdGltYXRlZCBjYWJsZSBsZW5ndGguIE9uIHNob3J0IGNhYmxlcyB3ZSB1c2UgaXQg
aXMgb2Z0ZW4gemVybyA7KQ0KDQpBcyBJIHNlZSBmcm9tIHlvdXIgcmVhZGluZ3MgLSB5b3VyIGNh
YmxlcyBhcmUgYWJpdCBsb25nZXIgOikNCg0KVGhpcyBhbHNvIGV4cGxhaW5zIHdoeSB0ZW1wIGlz
IGdvb2Qgd2hlbiB5b3UgZG8gaW50ZXJmYWNlIGRvd24uDQoNClJlZ2FyZHMsDQogIElnb3INCg==

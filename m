Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB3526F4F2
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 06:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgIRESX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 00:18:23 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:34958 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726117AbgIRESW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 00:18:22 -0400
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f64350a0000>; Fri, 18 Sep 2020 12:18:18 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 04:18:18 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Sep 2020 04:18:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MYMJ4GtloiFBDrzLRABVwnmH11EEtaicokoFXqB3pOzmDHV4D7tOcbP3WjSDPwAS3wrCIN+4NR7hW/LpED/mnunCUaETCp8JVbO9SotyPlRm8isVIlN3hP2qaZn4xZij47OzWcQ6XrPAIKZPZ0AsSMXQEbrfxUuRpLU2bG6hL77tyljADijnY3K2N2rF6cRYQb/BUOMa/KzTTv5ejHmiiXDvfgMoegnh6iPrVC048jz5xR7Wx96z6XdqApKg+lF9COrzl0OdcjQwXjrJbA4WhEwRIW98diMrl/D+MLK7VqLYg3Aghj98mH/1FYjoEMcJ5NT1Q/Ea/+ee/uvHEKVfxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vrjk50o7WuNi344QydvQlC3IklKTdFZ1Xc9EBRRDwF4=;
 b=Yqo+ypTcGxKR14PZv8RF2E/0xuCOUEEfg2q91+9labjilN5+olEvaqK/mxiJH0+EVAzBItZGJIRUOV/+JsIEf9NL7kuzt8sr5FZ/2ss/4LV14XGWhZmssOnvFA3ECoY4L8HXqd786woJHyxlmU6Lz0/g0zDg0Mr6Jp1hJcw1QshoikjuHKnxyjbNQ5zYa2R6AhF04j7XBYse9h5WqIXiLEriyhYm02kzBZUno0wBEevjdxq0i8ljqqMKWdo/dO+OWMyQX4EuIscy6figi1D/TMlpd966MoA0yhIIW1D9JqFUYIe1GxDobdhU/v91ltwIrnlKeisVd3h2MncIwUaCjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (52.135.54.148) by
 BYAPR12MB2869.namprd12.prod.outlook.com (20.179.92.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Fri, 18 Sep 2020 04:18:15 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3370.019; Fri, 18 Sep 2020
 04:18:15 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next v2 1/8] devlink: Introduce PCI SF port flavour
 and port attribute
Thread-Topic: [PATCH net-next v2 1/8] devlink: Introduce PCI SF port flavour
 and port attribute
Thread-Index: AQHWjRbfsBFsIsWtkkyNl1+R6ZtbG6ltQJQAgACEJpA=
Date:   Fri, 18 Sep 2020 04:18:15 +0000
Message-ID: <BY5PR12MB43220E910463577F0D792965DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-2-parav@nvidia.com>
 <7b4627d3-2a69-5700-e985-2fe5c56f03cb@gmail.com>
In-Reply-To: <7b4627d3-2a69-5700-e985-2fe5c56f03cb@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5f2d0d7-3753-4377-5145-08d85b89dd9d
x-ms-traffictypediagnostic: BYAPR12MB2869:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB28697BBE2791582C646F12B0DC3F0@BYAPR12MB2869.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rk/HuMBfoxfoZSDlcv8x3yADsxoKNpKsS31/+2Fu/jVqRgD/jS5MlCvryj3Cvov28bFQVWaYTB3qvUIgJ5x+E9CreBQh+lqEioKJek8k01g28o1itFCAEVN4OzOtvvAyg2y/R/1EUH0yudsu5uc4xYPKf0f0QhQ31mleIFeBNQitgPfDyrTAG25d/lqh9f5N8bqg9ihdlmMbFCpSQn1bhP3rTWMkPTs4pjS5KHz8F74TffwdSIuXMOGnc45S/j5dJF9qh6TPxj8Jji/mjIywcLfwWI6j+rPgp2/0Ktq0Q8uM6J+YGhVno9VhJkSfFzT0+z38Fsx87r5empKZGyPB8Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(8676002)(4326008)(8936002)(52536014)(83380400001)(316002)(5660300002)(55016002)(2906002)(186003)(9686003)(6506007)(53546011)(107886003)(7696005)(478600001)(64756008)(55236004)(66946007)(66446008)(26005)(66476007)(76116006)(86362001)(71200400001)(33656002)(66556008)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: X7YUkbrmFdur2GLnboLtx1XCRoEDQcIs+4c7s3YbL8SF4tXdhzyNiuolTprZwvw/v6jyigDb0nHWkSqXE5mbbViroIB92SuDac97ezD+sEWh5g+tjQV0f8nVSKHNP3J6g9CCt+RZsScVxd/MHZ0+DmEG6qQoR1oG/WnyZUt0W77dPaP0cV2QXJkNGOe0sggGwH5V7VCX1m7/IzZGITSaYoi2M0yO5/x8KveZHH3nMUXaULMVBulCVHK35Fh1yqRjiHORPNGZNvIWT601a1fDKxkakjTlHuWZd839GW155tcvr0h0+snsZejh+wunY3VlAdZV0uBUZeHPp9uaGtqjg7jr6NKfAeVhig3fo1oRm6gDgPmgpq5uMsOlETqqtNidmHGS0fwbA2isvzj8DptJ+Qke0+uzZMVv9a3KJUdedcuK4mhuTW5zH8EOepuBl7uMQtJazdsCndfkLRd/nTO6ItxbrdVVb99ZBnfflVDlBI+QTuA3jqZIbA049rB897POQWS1/rpK2o85lbNRKMMUuciwO/E7Be6Yq7Y/NANz6mi1IiPcJ/vz2RSqpBTD44TGoyIeyUhKDqvImmLXZGlUEX0jKUpeakoBvk5Dd7KzYMmveAIZUG8E3OVbRqtLoGZawbrtTJRvUf8pAIeSQcxBeQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5f2d0d7-3753-4377-5145-08d85b89dd9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 04:18:15.9169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c8drvcXXN6VTn3Ti5wrKMV/PiJwpMkUrZhq9mb/ThdU3sN2qxY8WHPl1rW31YyhLNydzyVstGQDstvEkLkwXEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2869
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600402698; bh=Vrjk50o7WuNi344QydvQlC3IklKTdFZ1Xc9EBRRDwF4=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=CCNpz/kFnxb/rUjBjj2pjjv9BdT0FuoCW6E0sMPFMchItqA8BKkGTh4dEAUNFFC6Q
         r5A20MQ+oVZ8naEwn5VIHdO7Ex2a7va/TH4vpLsbq4kvlg8osKmb1HPfYqlj4arj9h
         dCG251YgVrr7l3ceL3NfNBSnm2qZz80v9B/6VjIvlzILaaD1xO12ZPOjdStL0A7PEI
         Ygq39bMJWaetFHzoB3UDLQNqZ4UBaiDrZdSgMjF9fgcFoRBKgJfiOk81RiRs6kUTeH
         6+4wZJcRnnxe6k0zRyn/WUpD1cuLpiDrghHDXpDRXFIP5YjjtAcz6bk8aRCm9r0Ylp
         k3xczTP92p4XA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IERhdmlkIEFoZXJuIDxkc2FoZXJuQGdtYWlsLmNvbT4NCj4gU2VudDogRnJpZGF5
LCBTZXB0ZW1iZXIgMTgsIDIwMjAgMTozMiBBTQ0KPiANCj4gT24gOS8xNy8yMCAxMToyMCBBTSwg
UGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9kZXZsaW5r
LmggYi9pbmNsdWRlL25ldC9kZXZsaW5rLmggaW5kZXgNCj4gPiA0OGIxYzFlZjFlYmQuLjFlZGI1
NTgxMjViMCAxMDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL25ldC9kZXZsaW5rLmgNCj4gPiArKysg
Yi9pbmNsdWRlL25ldC9kZXZsaW5rLmgNCj4gPiBAQCAtODMsNiArODMsMjAgQEAgc3RydWN0IGRl
dmxpbmtfcG9ydF9wY2lfdmZfYXR0cnMgew0KPiA+ICAJdTggZXh0ZXJuYWw6MTsNCj4gPiAgfTsN
Cj4gPg0KPiA+ICsvKioNCj4gPiArICogc3RydWN0IGRldmxpbmtfcG9ydF9wY2lfc2ZfYXR0cnMg
LSBkZXZsaW5rIHBvcnQncyBQQ0kgU0YNCj4gPiArYXR0cmlidXRlcw0KPiA+ICsgKiBAY29udHJv
bGxlcjogQXNzb2NpYXRlZCBjb250cm9sbGVyIG51bWJlcg0KPiA+ICsgKiBAcGY6IEFzc29jaWF0
ZWQgUENJIFBGIG51bWJlciBmb3IgdGhpcyBwb3J0Lg0KPiA+ICsgKiBAc2Y6IEFzc29jaWF0ZWQg
UENJIFNGIGZvciBvZiB0aGUgUENJIFBGIGZvciB0aGlzIHBvcnQuDQo+ID4gKyAqIEBleHRlcm5h
bDogd2hlbiBzZXQsIGluZGljYXRlcyBpZiBhIHBvcnQgaXMgZm9yIGFuIGV4dGVybmFsDQo+ID4g
K2NvbnRyb2xsZXIgICovIHN0cnVjdCBkZXZsaW5rX3BvcnRfcGNpX3NmX2F0dHJzIHsNCj4gPiAr
CXUzMiBjb250cm9sbGVyOw0KPiA+ICsJdTE2IHBmOw0KPiA+ICsJdTMyIHNmOw0KPiANCj4gV2h5
IGEgdTMyPyBEbyB5b3UgZXhwZWN0IHRvIHN1cHBvcnQgdGhhdCBtYW55IFNGcz8gU2VlbXMgbGlr
ZSBldmVuIGEgdTE2IGlzDQo+IG1vcmUgdGhhbiB5b3UgY2FuIGFkZXF1YXRlbHkgbmFtZSB3aXRo
aW4gYW4gSUZOQU1FU1ogYnVmZmVyLg0KPg0KSSB0aGluayB1MTYgaXMgbGlrZWx5IGVub3VnaCwg
d2hpY2ggbGV0IHVzZSBjcmVhdGVzIDY0SyBTRiBwb3J0cyB3aGljaCBpcyBhIGxvdC4gOi0pDQpX
YXMgbGl0dGxlIGNvbmNlcm5lZCB0aGF0IGl0IHNob3VsZG4ndCBmYWxsIHNob3J0IGluIGZldyB5
ZWFycy4gU28gcGlja2VkIHUzMi4gDQpVc2VycyB3aWxsIGJlIGFibGUgdG8gbWFrZSB1c2Ugb2Yg
YWx0ZXJuYXRpdmUgbmFtZXMgc28ganVzdCBiZWNhdXNlIElGTkFNRVNaIGlzIDE2IGNoYXJhY3Rl
cnMsIGRvIG5vdCB3YW50IHRvIGxpbWl0IHNmbnVtIHNpemUuDQpXaGF0IGRvIHlvdSB0aGluaz8N
Cg0KPiANCj4gPiArCXU4IGV4dGVybmFsOjE7DQo+ID4gK307DQo+ID4gKw0KPiA+ICAvKioNCj4g
PiAgICogc3RydWN0IGRldmxpbmtfcG9ydF9hdHRycyAtIGRldmxpbmsgcG9ydCBvYmplY3QNCj4g
PiAgICogQGZsYXZvdXI6IGZsYXZvdXIgb2YgdGhlIHBvcnQNCj4gDQo+IA0KPiA+IGRpZmYgLS1n
aXQgYS9uZXQvY29yZS9kZXZsaW5rLmMgYi9uZXQvY29yZS9kZXZsaW5rLmMgaW5kZXgNCj4gPiBl
NWI3MWYzYzJkNGQuLmZhZGE2NjBmZDUxNSAxMDA2NDQNCj4gPiAtLS0gYS9uZXQvY29yZS9kZXZs
aW5rLmMNCj4gPiArKysgYi9uZXQvY29yZS9kZXZsaW5rLmMNCj4gPiBAQCAtNzg1NSw2ICs3ODg5
LDkgQEAgc3RhdGljIGludA0KPiBfX2RldmxpbmtfcG9ydF9waHlzX3BvcnRfbmFtZV9nZXQoc3Ry
dWN0IGRldmxpbmtfcG9ydCAqZGV2bGlua19wb3J0LA0KPiA+ICAJCW4gPSBzbnByaW50ZihuYW1l
LCBsZW4sICJwZiV1dmYldSIsDQo+ID4gIAkJCSAgICAgYXR0cnMtPnBjaV92Zi5wZiwgYXR0cnMt
PnBjaV92Zi52Zik7DQo+ID4gIAkJYnJlYWs7DQo+ID4gKwljYXNlIERFVkxJTktfUE9SVF9GTEFW
T1VSX1BDSV9TRjoNCj4gPiArCQluID0gc25wcmludGYobmFtZSwgbGVuLCAicGYldXNmJXUiLCBh
dHRycy0+cGNpX3NmLnBmLCBhdHRycy0NCj4gPnBjaV9zZi5zZik7DQo+ID4gKwkJYnJlYWs7DQo+
ID4gIAl9DQo+ID4NCj4gPiAgCWlmIChuID49IGxlbikNCj4gPg0KPiANCj4gQW5kIGFzIEkgbm90
ZWQgYmVmb3JlLCB0aGlzIGZ1bmN0aW9uIGNvbnRpbnVlcyB0byBncm93IGRldmljZSBuYW1lcyBh
bmQgaXQgaXMNCj4gZ29pbmcgdG8gc3BpbGwgb3ZlciB0aGUgSUZOQU1FU1ogYnVmZmVyIGFuZCBF
SU5WQUwgaXMgZ29pbmcgdG8gYmUgY29uZnVzaW5nLiBJdA0KPiByZWFsbHkgbmVlZHMgYmV0dGVy
IGVycm9yIGhhbmRsaW5nIGJhY2sgdG8gdXNlcnMgKG5vdCBrZXJuZWwgYnVmZmVycykuDQpBbHRl
cm5hdGl2ZSBuYW1lcyBbMV0gc2hvdWxkIGhlbHAgdG8gb3ZlcmNvbWUgdGhlIGxpbWl0YXRpb24g
b2YgSUZOQU1FU1ouDQpGb3IgZXJyb3IgY29kZSBFSU5WQUwsIHNob3VsZCBpdCBiZSBFTk9TUEM/
DQpJZiBzbywgc2hvdWxkIEkgaW5zZXJ0IGEgcHJlLXBhdGNoIGluIHRoaXMgc2VyaWVzPw0KDQpb
MV0gaXAgbGluayBwcm9wZXJ0eSBhZGQgZGV2IERFVklDRSBbIGFsdG5hbWUgTkFNRSAuLiBdDQoN
Cg==

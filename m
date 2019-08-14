Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D81F8CA8B
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 07:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfHNE4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 00:56:34 -0400
Received: from mail-eopbgr10040.outbound.protection.outlook.com ([40.107.1.40]:44734
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725262AbfHNE4e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 00:56:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DN9vPTEoaPTgd7K+CvFsXAFyzHOSsSzK8MpLgM4nOkgDrGO/c2Ye0Zjvmq1s5wlFW7dWJ7BahSJzihDqeoCtgZZGAabwwYQgyyJUXTeMtD0soDri03XQoHqv1ZW2ThY52vzAlxj4fm930r7HaEcCCpGWILZXv+6nVXYVcuz6GphKTD0h7bYQx0ygWr0XT709vwXFTtgSpBHy1XCUlEDd7lRRjUfNOuQWDt0/je7pFHne8pPxZXu1f8bcQE4bajNGvFzqownN9clZhaert7RdNUchn/tLOpN2DxN7Fc3WBThxFOB6Hx6qlove3Yhh4KqHEMKb0x0B55RRO8A7yXBQHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f2U0PGaqYkCx4X2e0wuQvMrUpiFPhMV8qmoSazJEaZc=;
 b=aqPr0qaGBRWSsIyWsr6RutfuZRWouJgsegKi7kt2L7Z03OtVcLECoyAopUnVzSTIOP4hQO+aeDDxoWqw/qt6/WbBI1slYaEqLljnB7Kn1h5TZ/1IsqprG8VNnbNNgLlsYlnM4hxcbRDNVHn0DZQId3lmbSmQ6F9PwTl/FO135z3ArmKrQ8lsnDrFRN7bY6K2XXOoMvOYXVPPA/kE8CI5AkbCMTeZmZ98s53MXISTR+kkXmIzdamPQxSoDTb+5zQiRuJAxz6hvVuu/+i0YxhjlP1n19uChwlSddlggMDsVvGxcKgefcyDzR67tbmebGXs1qP8L6AluYM5iBHONp4ZQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f2U0PGaqYkCx4X2e0wuQvMrUpiFPhMV8qmoSazJEaZc=;
 b=EPAjJw6Pq1iGjROrBKl8zetyBwqZHPIc12x/LnkQdxPeQvbL/gAFnSiMtCzRvsT1nAWaE7CiDdMm+zRPHHF8URII/L+Uf2/QaleB2wAqGLbCxGpo9PBxA2YBl04RiJUZQoJbKP23VnEvbDnyjrRrR9zkXyb/n+bhnq+VmCO1lX4=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2639.eurprd04.prod.outlook.com (10.168.66.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Wed, 14 Aug 2019 04:56:26 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::2072:e49f:a84a:8f37]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::2072:e49f:a84a:8f37%11]) with mapi id 15.20.2157.022; Wed, 14 Aug
 2019 04:56:26 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     "Allan W . Nielsen" <allan.nielsen@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: RE: [v2, 4/4] ocelot: add VCAP IS2 rule to trap PTP Ethernet frames
Thread-Topic: [v2, 4/4] ocelot: add VCAP IS2 rule to trap PTP Ethernet frames
Thread-Index: AQHVUYHBQ+XbfTaLmU6f16cDa36pP6b4nMYAgAFzxLA=
Date:   Wed, 14 Aug 2019 04:56:26 +0000
Message-ID: <VI1PR0401MB2237E0F32D6CC719682E8C1AF8AD0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
References: <20190813025214.18601-1-yangbo.lu@nxp.com>
 <20190813025214.18601-5-yangbo.lu@nxp.com>
 <20190813062525.5bgdzjc6kw5hqdxk@lx-anielsen.microsemi.net>
In-Reply-To: <20190813062525.5bgdzjc6kw5hqdxk@lx-anielsen.microsemi.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9f23ce1f-0fda-433f-ab91-08d72073c37d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2639;
x-ms-traffictypediagnostic: VI1PR0401MB2639:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0401MB2639ECC527A6C176EC63192DF8AD0@VI1PR0401MB2639.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(13464003)(189003)(199004)(53754006)(6506007)(55016002)(33656002)(86362001)(81156014)(81166006)(53936002)(8676002)(9686003)(6306002)(3846002)(2906002)(6246003)(76176011)(7696005)(186003)(7736002)(6116002)(305945005)(26005)(74316002)(66946007)(99286004)(25786009)(52536014)(102836004)(4326008)(66556008)(66066001)(256004)(486006)(54906003)(229853002)(71190400001)(476003)(110136005)(66476007)(76116006)(66446008)(11346002)(64756008)(446003)(6436002)(53546011)(71200400001)(316002)(478600001)(966005)(8936002)(14454004)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2639;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: unGN7XK8GQ4FJWUtabxCV7JqOwhO32Jcb74MPOAgPFHSjycA2lhLw2vsAULHscdFEAM7aCiU0MMaHy9tMXyT1HoCP6RUX3IlnV/rY13HlHv4IL5I4dEApbzAod1cWI7t/qIVYKLCcsMd3ifRYckwAmYUsOG8Jy8RlWwwjXLWHKbJDsDiFbwMN3DkwOuti4nMG2hbo+8XFp9EPar20fIpEE1GgBsL5i2bG795DS7TuVLatN2lQjRA9r9ZWoQVhjxOZGv8GF5VGkE92Ps2ZCmpcBrP3CVDpGprwkgI87wh/bCSybuxbG4uYwzz4MjIMHjJ/bZergMR1aFvCeG43hyVoCoqc8+24AfT9ZJtRTEPQw78ERz0rzifL8UeFAII7jxGEl/xNugPu7CWs8pMsGvZCVr1ILMHvzSbeXgxyqaan4s=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f23ce1f-0fda-433f-ab91-08d72073c37d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 04:56:26.7586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ebMfVAiFnXLC6jCglapdGdwri+dIc+mAhUwfAsoJfgUO+YzgqZHwtDryubmcHY7xVjBTiySqSPYEqEN2JhluLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2639
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWxsYW4sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQWxsYW4g
VyAuIE5pZWxzZW4gPGFsbGFuLm5pZWxzZW5AbWljcm9jaGlwLmNvbT4NCj4gU2VudDogVHVlc2Rh
eSwgQXVndXN0IDEzLCAyMDE5IDI6MjUgUE0NCj4gVG86IFkuYi4gTHUgPHlhbmdiby5sdUBueHAu
Y29tPg0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgRGF2aWQgUyAuIE1pbGxlciA8ZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldD47DQo+IEFsZXhhbmRyZSBCZWxsb25pIDxhbGV4YW5kcmUuYmVsbG9u
aUBib290bGluLmNvbT47IE1pY3JvY2hpcCBMaW51eCBEcml2ZXINCj4gU3VwcG9ydCA8VU5HTGlu
dXhEcml2ZXJAbWljcm9jaGlwLmNvbT4NCj4gU3ViamVjdDogUmU6IFt2MiwgNC80XSBvY2Vsb3Q6
IGFkZCBWQ0FQIElTMiBydWxlIHRvIHRyYXAgUFRQIEV0aGVybmV0IGZyYW1lcw0KPiANCj4gVGhl
IDA4LzEzLzIwMTkgMTA6NTIsIFlhbmdibyBMdSB3cm90ZToNCj4gPiBBbGwgdGhlIFBUUCBtZXNz
YWdlcyBvdmVyIEV0aGVybmV0IGhhdmUgZXR5cGUgMHg4OGY3IG9uIHRoZW0uDQo+ID4gVXNlIGV0
eXBlIGFzIHRoZSBrZXkgdG8gdHJhcCBQVFAgbWVzc2FnZXMuDQo+ID4NCj4gPiBTaWduZWQtb2Zm
LWJ5OiBZYW5nYm8gTHUgPHlhbmdiby5sdUBueHAuY29tPg0KPiA+IC0tLQ0KPiA+IENoYW5nZXMg
Zm9yIHYyOg0KPiA+IAktIEFkZGVkIHRoaXMgcGF0Y2guDQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMv
bmV0L2V0aGVybmV0L21zY2Mvb2NlbG90LmMgfCAyOCArKysrKysrKysrKysrKysrKysrKysrKysr
KysrDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyOCBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbXNjYy9vY2Vsb3QuYw0KPiA+IGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbXNjYy9vY2Vsb3QuYw0KPiA+IGluZGV4IDY5MzJlNjEuLjQwZjRlMGQg
MTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbXNjYy9vY2Vsb3QuYw0KPiA+
ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21zY2Mvb2NlbG90LmMNCj4gPiBAQCAtMTY4MSw2
ICsxNjgxLDMzIEBAIGludCBvY2Vsb3RfcHJvYmVfcG9ydChzdHJ1Y3Qgb2NlbG90ICpvY2Vsb3Qs
IHU4DQo+ID4gcG9ydCwgIH0gIEVYUE9SVF9TWU1CT0wob2NlbG90X3Byb2JlX3BvcnQpOw0KPiA+
DQo+ID4gK3N0YXRpYyBpbnQgb2NlbG90X2FjZV9hZGRfcHRwX3J1bGUoc3RydWN0IG9jZWxvdCAq
b2NlbG90KSB7DQo+ID4gKwlzdHJ1Y3Qgb2NlbG90X2FjZV9ydWxlICpydWxlOw0KPiA+ICsNCj4g
PiArCXJ1bGUgPSBremFsbG9jKHNpemVvZigqcnVsZSksIEdGUF9LRVJORUwpOw0KPiA+ICsJaWYg
KCFydWxlKQ0KPiA+ICsJCXJldHVybiAtRU5PTUVNOw0KPiA+ICsNCj4gPiArCS8qIEVudHJ5IGZv
ciBQVFAgb3ZlciBFdGhlcm5ldCAoZXR5cGUgMHg4OGY3KQ0KPiA+ICsJICogQWN0aW9uOiB0cmFw
IHRvIENQVSBwb3J0DQo+ID4gKwkgKi8NCj4gPiArCXJ1bGUtPm9jZWxvdCA9IG9jZWxvdDsNCj4g
PiArCXJ1bGUtPnByaW8gPSAxOw0KPiA+ICsJcnVsZS0+dHlwZSA9IE9DRUxPVF9BQ0VfVFlQRV9F
VFlQRTsNCj4gPiArCS8qIEF2YWlsYWJsZSBvbiBhbGwgaW5ncmVzcyBwb3J0IGV4Y2VwdCBDUFUg
cG9ydCAqLw0KPiA+ICsJcnVsZS0+aW5ncmVzc19wb3J0ID0gfkJJVChvY2Vsb3QtPm51bV9waHlz
X3BvcnRzKTsNCj4gPiArCXJ1bGUtPmRtYWNfbWMgPSBPQ0VMT1RfVkNBUF9CSVRfMTsNCj4gPiAr
CXJ1bGUtPmZyYW1lLmV0eXBlLmV0eXBlLnZhbHVlWzBdID0gMHg4ODsNCj4gPiArCXJ1bGUtPmZy
YW1lLmV0eXBlLmV0eXBlLnZhbHVlWzFdID0gMHhmNzsNCj4gPiArCXJ1bGUtPmZyYW1lLmV0eXBl
LmV0eXBlLm1hc2tbMF0gPSAweGZmOw0KPiA+ICsJcnVsZS0+ZnJhbWUuZXR5cGUuZXR5cGUubWFz
a1sxXSA9IDB4ZmY7DQo+ID4gKwlydWxlLT5hY3Rpb24gPSBPQ0VMT1RfQUNMX0FDVElPTl9UUkFQ
Ow0KPiA+ICsNCj4gPiArCW9jZWxvdF9hY2VfcnVsZV9vZmZsb2FkX2FkZChydWxlKTsNCj4gPiAr
CXJldHVybiAwOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICBpbnQgb2NlbG90X2luaXQoc3RydWN0IG9j
ZWxvdCAqb2NlbG90KSAgew0KPiA+ICAJdTMyIHBvcnQ7DQo+ID4gQEAgLTE3MDgsNiArMTczNSw3
IEBAIGludCBvY2Vsb3RfaW5pdChzdHJ1Y3Qgb2NlbG90ICpvY2Vsb3QpDQo+ID4gIAlvY2Vsb3Rf
bWFjdF9pbml0KG9jZWxvdCk7DQo+ID4gIAlvY2Vsb3Rfdmxhbl9pbml0KG9jZWxvdCk7DQo+ID4g
IAlvY2Vsb3RfYWNlX2luaXQob2NlbG90KTsNCj4gPiArCW9jZWxvdF9hY2VfYWRkX3B0cF9ydWxl
KG9jZWxvdCk7DQo+ID4NCj4gPiAgCWZvciAocG9ydCA9IDA7IHBvcnQgPCBvY2Vsb3QtPm51bV9w
aHlzX3BvcnRzOyBwb3J0KyspIHsNCj4gPiAgCQkvKiBDbGVhciBhbGwgY291bnRlcnMgKDUgZ3Jv
dXBzKSAqLw0KPiBUaGlzIHNlZW1zIHJlYWxseSB3cm9uZyB0byBtZSwgYW5kIG11Y2ggdG9vIGhh
cmQtY29kZWQuLi4NCj4gDQo+IFdoYXQgaWYgSSB3YW50IHRvIGZvcndhcmQgdGhlIFBUUCBmcmFt
ZXMgdG8gYmUgZm9yd2FyZGVkIGxpa2UgYSBub3JtYWwNCj4gbm9uLWF3YXJlIFBUUCBzd2l0Y2g/
DQoNCltZLmIuIEx1XSBBcyBBbmRyZXcgc2FpZCwgb3RoZXIgc3dpdGNoZXMgY291bGQgaWRlbnRp
ZnkgUFRQIG1lc3NhZ2VzIGFuZCBmb3J3YXJkIHRvIENQVSBmb3IgcHJvY2Vzc2luZy4NCmh0dHBz
Oi8vcGF0Y2h3b3JrLm96bGFicy5vcmcvcGF0Y2gvMTE0NTYyNy8NCg0KSSdtIGFsc28gd29uZGVy
aW5nIHdoZXRoZXIgdGhlcmUgaXMgY29tbW9uIG1ldGhvZCBpbiBsaW51eCB0byBhZGRyZXNzIHlv
dXIgcXVlc3Rpb25zLg0KSWYgbm8sIEkgdGhpbmsgdHJhcHBpbmcgYWxsIFBUUCBtZXNzYWdlcyBv
biBhbGwgcG9ydHMgdG8gQ1BVIGNvdWxkIGJlIHVzZWQgZm9yIG5vdy4NCklmIHVzZXJzIHJlcXVp
cmUgUFRQIHN5bmNocm9uaXphdGlvbiwgdGhleSBhY3R1YWxseSBkb27igJl0IHdhbnQgYSBub24t
YXdhcmUgUFRQIHN3aXRjaC4NCg0KSSBvbmNlIHNlZSBvdGhlciBvY2Vsb3QgY29kZSBjb25maWd1
cmUgcHRwIHRyYXAgcnVsZXMgaW4gaW9jdGwgdGltZXN0YW1waW5nIHNldHRpbmcuIEJ1dCBJIGRv
buKAmXQgdGhpbmsgaXQncyBwcm9wZXIgZWl0aGVyLg0KRW5hYmxlIHRpbWVzdGFtcGluZyBkb2Vz
buKAmXQgbWVhbiB3ZSB3YW50IHRvIHRyYXAgUFRQIG1lc3NhZ2VzLg0KDQo+IA0KPiBXaGF0IGlm
IGRvIG5vdCB3YW50IHRoaXMgb24gYWxsIHBvcnRzPw0KDQpbWS5iLiBMdV0gQWN0dWFsbHkgSSBk
b27igJl0IHRoaW5rIHRoZXJlIHNob3VsZCBiZSBkaWZmZXJlbmNlIG9mIGhhbmRsaW5nIFBUUCBt
ZXNzYWdlcyBvbiBlYWNoIHBvcnQuDQpZb3UgZG9u4oCZdCBuZWVkIHRvIHJ1biBQVFAgcHJvdG9j
b2wgYXBwbGljYXRpb24gb24gdGhlIHNwZWNpZmljIHBvcnQgaWYgeW91IGRvbuKAmXQgd2FudC4N
Cg0KPiANCj4gSWYgeW91IGRvIG5vdCBoYXZlIGFuIGFwcGxpY2F0aW9uIGJlaGluZCB0aGlzIGlt
cGxlbWVudGluZyBhIGJvdW5kYXJ5IG9yDQo+IHRyYW5zcGFyZW50IGNsb2NrLCB0aGVuIHlvdSBh
cmUgYnJlYWtpbmcgUFRQIG9uIHRoZSBuZXR3b3JrLg0KDQpbWS5iLiBMdV0gWW91J3JlIHJpZ2h0
LiBCdXQgYWN0dWFsbHkgZm9yIFBUUCBuZXR3b3JrLCBhbGwgUFRQIGRldmljZXMgc2hvdWxkIHJ1
biBQVFAgcHJvdG9jb2wgb24gaXQuDQpPZiBjb3Vyc2UsIGl0J3MgYmV0dGVyIHRvIGhhdmUgYSB3
YXkgdG8gY29uZmlndXJlIGl0IGFzIG5vbi1hd2FyZSBQVFAgc3dpdGNoLg0KDQo+IA0KPiAvQWxs
YW4NCg==

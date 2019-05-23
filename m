Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6709427C78
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 14:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730402AbfEWMKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 08:10:55 -0400
Received: from mail-eopbgr40053.outbound.protection.outlook.com ([40.107.4.53]:23813
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728309AbfEWMKz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 08:10:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=waEx57VcOknlIMHxrTt+peAbwfeLGnz1JIdmMvDmb+8=;
 b=oHVq88GqZ0QN9NSmXxnCY3Mc2cNZeL4r2HnXCij144td1tBSFIRqCZIgz+mHOgT6U7C/JTlnxC1eYMC+fK/E7+xX2A5bf5EQdmiFZzFZQCI60386tssHSlrLdNCc8lrdJoQT+biV6pmY2k4yybmwPJFEbkCSvbWxGsJTvZIzBEY=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3344.eurprd04.prod.outlook.com (52.134.8.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Thu, 23 May 2019 12:10:47 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053%8]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 12:10:47 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [RFC PATCH net-next 5/9] net: phylink: Add phylink_create_raw
Thread-Topic: [RFC PATCH net-next 5/9] net: phylink: Add phylink_create_raw
Thread-Index: AQHVEQW8O+LbHNLMy02dz0XkU/eeIaZ3+5GAgAAA+oCAAKIrAA==
Date:   Thu, 23 May 2019 12:10:47 +0000
Message-ID: <VI1PR0402MB28006FF30E571E71F1AA1278E0010@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
 <20190523011958.14944-6-ioana.ciornei@nxp.com>
 <c2712523-f1b9-47f8-672b-d35e62bf35ea@gmail.com>
 <0d29a5ee-8a68-d0be-c524-6e3ee1f46802@gmail.com>
In-Reply-To: <0d29a5ee-8a68-d0be-c524-6e3ee1f46802@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c625286-99f9-4811-52fb-08d6df77b06f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3344;
x-ms-traffictypediagnostic: VI1PR0402MB3344:
x-microsoft-antispam-prvs: <VI1PR0402MB334412C81A16827618FA5E23E0010@VI1PR0402MB3344.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(396003)(366004)(39860400002)(346002)(189003)(199004)(6506007)(7696005)(99286004)(53546011)(3846002)(6116002)(102836004)(76176011)(81166006)(81156014)(8676002)(8936002)(305945005)(7736002)(2501003)(4326008)(68736007)(66556008)(64756008)(76116006)(66476007)(73956011)(66946007)(316002)(66066001)(25786009)(66446008)(71200400001)(33656002)(71190400001)(55016002)(2201001)(5660300002)(6246003)(478600001)(9686003)(2906002)(6436002)(229853002)(74316002)(53936002)(256004)(86362001)(14444005)(52536014)(14454004)(486006)(476003)(26005)(186003)(110136005)(54906003)(446003)(11346002)(44832011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3344;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XuVZblbge+MfzsrzBBMw1CibQEbjLhFsxnpAUsW0BiDLmx4JM1qmyr0eYj3xQa3FrKqzf3rYHvbKjI3SBhQFNpMcrgjPKzdPVdNsWRg0j9Xe+oL2q6k122Nc89OUpzI4GLdD08NRfeodBi6t1F8g6p9ctA0sx+i0OGxp1RmWuehwXsn4yaQghQRHIXSTUIMrDS6PqCiwuWSm8+Nom0xMAJTjV7iHX2taTBftep/z6blUa+oV/VbfE04Iv7m0YcN4QpCWqYrjmRFcocL0oPuo8z4Jc6ZEmZ/yDNCFe+MO57FwkE1Pdd82GzIt2NiILnlYQji7OjAmwvyzBzKUVt70PIwtZlEyELNivrJskwiUud/sqcnxkZBlwXVYgMHeDJ77+nSEd+Jnu1cpCS8aQSJyY1VMX+P1hYJ/KuTPRx9X8XA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c625286-99f9-4811-52fb-08d6df77b06f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 12:10:47.1950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3344
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IFN1YmplY3Q6IFJlOiBbUkZDIFBBVENIIG5ldC1uZXh0IDUvOV0gbmV0OiBwaHlsaW5rOiBB
ZGQgcGh5bGlua19jcmVhdGVfcmF3DQo+IA0KPiANCj4gDQo+IE9uIDUvMjIvMjAxOSA3OjI1IFBN
LCBGbG9yaWFuIEZhaW5lbGxpIHdyb3RlOg0KPiA+DQo+ID4NCj4gPiBPbiA1LzIyLzIwMTkgNjoy
MCBQTSwgSW9hbmEgQ2lvcm5laSB3cm90ZToNCj4gPj4gVGhpcyBhZGRzIGEgbmV3IGVudHJ5IHBv
aW50IHRvIFBIWUxJTksgdGhhdCBkb2VzIG5vdCByZXF1aXJlIGENCj4gPj4gbmV0X2RldmljZSBz
dHJ1Y3R1cmUuDQo+ID4+DQo+ID4+IFRoZSBtYWluIGludGVuZGVkIHVzZSBhcmUgRFNBIHBvcnRz
IHRoYXQgZG8gbm90IGhhdmUgbmV0IGRldmljZXMNCj4gPj4gcmVnaXN0ZXJlZCBmb3IgdGhlbSAo
bWFpbmx5IGJlY2F1c2UgZG9pbmcgc28gd291bGQgYmUgcmVkdW5kYW50IC0gc2VlDQo+ID4+IERv
Y3VtZW50YXRpb24vbmV0d29ya2luZy9kc2EvZHNhLnJzdCBmb3IgZGV0YWlscykuIFNvIGZhciBE
U0EgaGFzDQo+ID4+IGJlZW4gdXNpbmcgUEhZTElCIGZpeGVkIFBIWXMgZm9yIHRoZXNlIHBvcnRz
LCBkcml2ZW4gbWFudWFsbHkgd2l0aA0KPiA+PiBnZW5waHkgaW5zdGVhZCBvZiBzdGFydGluZyBh
IGZ1bGwgUEhZIHN0YXRlIG1hY2hpbmUsIGJ1dCB0aGlzIGRvZXMNCj4gPj4gbm90IHNjYWxlIHdl
bGwgd2hlbiB0aGVyZSBhcmUgYWN0dWFsIFBIWXMgdGhhdCBuZWVkIGEgZHJpdmVyIG9uIHRob3Nl
DQo+ID4+IHBvcnRzLCBvciB3aGVuIGEgZml4ZWQtbGluayBpcyByZXF1ZXN0ZWQgaW4gRFQgdGhh
dCBoYXMgYSBzcGVlZA0KPiA+PiB1bnN1cHBvcnRlZCBieSB0aGUgZml4ZWQgUEhZIEMyMiBlbXVs
YXRpb24gKHN1Y2ggYXMgU0dNSUktMjUwMCkuDQo+ID4+DQo+ID4+IFRoZSBwcm9wb3NlZCBzb2x1
dGlvbiBjb21lcyBpbiB0aGUgZm9ybSBvZiBhIG5vdGlmaWVyIGNoYWluIG93bmVkIGJ5DQo+ID4+
IHRoZSBQSFlMSU5LIGluc3RhbmNlLCBhbmQgdGhlIHBhc3Npbmcgb2YgcGh5bGlua19ub3RpZmll
cl9pbmZvDQo+ID4+IHN0cnVjdHVyZXMgYmFjayB0byB0aGUgZHJpdmVyIHRocm91Z2ggYSBibG9j
a2luZyBub3RpZmllciBjYWxsLg0KPiA+Pg0KPiA+PiBUaGUgZXZlbnQgQVBJIGV4cG9zZWQgYnkg
dGhlIG5ldyBub3RpZmllciBtZWNoYW5pc20gaXMgYSAxOjEgbWFwcGluZw0KPiA+PiB0byB0aGUg
ZXhpc3RpbmcgUEhZTElOSyBtYWNfb3BzLCBwbHVzIHRoZSBQSFlMSU5LIGZpeGVkLWxpbmsgY2Fs
bGJhY2suDQo+ID4+DQo+ID4+IEJvdGggdGhlIHN0YW5kYXJkIHBoeWxpbmtfY3JlYXRlKCkgZnVu
Y3Rpb24sIGFzIHdlbGwgYXMgaXRzIHJhdw0KPiA+PiB2YXJpYW50LCBjYWxsIHRoZSBzYW1lIHVu
ZGVybHlpbmcgZnVuY3Rpb24gd2hpY2ggaW5pdGlhbGl6ZXMgZWl0aGVyDQo+ID4+IHRoZSBuZXRk
ZXYgZmllbGQgb3IgdGhlIG5vdGlmaWVyIGJsb2NrIG9mIHRoZSBQSFlMSU5LIGluc3RhbmNlLg0K
PiA+Pg0KPiA+PiBBbGwgUEhZTElOSyBkcml2ZXIgY2FsbGJhY2tzIGhhdmUgYmVlbiBleHRlbmRl
ZCB0byBjYWxsIHRoZSBub3RpZmllcg0KPiA+PiBjaGFpbiBpbiBjYXNlIHRoZSBpbnN0YW5jZSBp
cyBhIHJhdyBvbmUuDQo+ID4+DQo+ID4+IFNpZ25lZC1vZmYtYnk6IElvYW5hIENpb3JuZWkgPGlv
YW5hLmNpb3JuZWlAbnhwLmNvbT4NCj4gPj4gU2lnbmVkLW9mZi1ieTogVmxhZGltaXIgT2x0ZWFu
IDxvbHRlYW52QGdtYWlsLmNvbT4NCj4gPj4gLS0tDQo+ID4NCj4gPiBbc25pcF0NCj4gPg0KPiA+
PiArCXN0cnVjdCBwaHlsaW5rX25vdGlmaWVyX2luZm8gaW5mbyA9IHsNCj4gPj4gKwkJLmxpbmtf
YW5fbW9kZSA9IHBsLT5saW5rX2FuX21vZGUsDQo+ID4+ICsJCS8qIERpc2NhcmQgY29uc3QgcG9p
bnRlciAqLw0KPiA+PiArCQkuc3RhdGUgPSAoc3RydWN0IHBoeWxpbmtfbGlua19zdGF0ZSAqKXN0
YXRlLA0KPiA+PiArCX07DQo+ID4+ICsNCj4gPj4gIAluZXRkZXZfZGJnKHBsLT5uZXRkZXYsDQo+
ID4+ICAJCSAgICIlczogbW9kZT0lcy8lcy8lcy8lcyBhZHY9JSpwYiBwYXVzZT0lMDJ4IGxpbms9
JXUNCj4gYW49JXVcbiIsDQo+ID4+ICAJCSAgIF9fZnVuY19fLCBwaHlsaW5rX2FuX21vZGVfc3Ry
KHBsLT5saW5rX2FuX21vZGUpLA0KPiA+PiBAQCAtMjk5LDcgKzMxNywxMiBAQCBzdGF0aWMgdm9p
ZCBwaHlsaW5rX21hY19jb25maWcoc3RydWN0IHBoeWxpbmsgKnBsLA0KPiA+PiAgCQkgICBfX0VU
SFRPT0xfTElOS19NT0RFX01BU0tfTkJJVFMsIHN0YXRlLT5hZHZlcnRpc2luZywNCj4gPj4gIAkJ
ICAgc3RhdGUtPnBhdXNlLCBzdGF0ZS0+bGluaywgc3RhdGUtPmFuX2VuYWJsZWQpOw0KPiA+DQo+
ID4gRG9uJ3QgeW91IG5lZWQgdG8gZ3VhcmQgdGhhdCBuZXRkZXZfZGJnKCkgd2l0aCBhbiBpZiAo
cGwtPm9wcykgdG8NCj4gPiBhdm9pZCBkZS1yZWZlcmVuY2luZyBhIE5VTEwgbmV0X2RldmljZT8N
Cj4gPg0KDQoNClRoZSBuZXRkZXZfKiBwcmludCB3aWxsIG5vdCBkZXJlZmVyZW5jZSBhIE5VTEwg
bmV0X2RldmljZSBzaW5jZSBpdCBoYXMgZXhwbGljaXQgY2hlY2tzIGFnYWlucyB0aGlzLg0KSW5z
dGVhZCBpdCB3aWxsIGp1c3QgcHJpbnQgKG5ldC9jb3JlL2Rldi5jLCBfX25ldGRldl9wcmludGsp
Og0KDQoJcHJpbnRrKCIlcyhOVUxMIG5ldF9kZXZpY2UpOiAlcFYiLCBsZXZlbCwgdmFmKTsNCg0K
DQo+ID4gQW5vdGhlciBwb3NzaWJpbGl0eSBjb3VsZCBiZSB0byBjaGFuZ2UgdGhlIHNpZ25hdHVy
ZSBvZiB0aGUNCj4gPiBwaHlsaW5rX21hY19vcHMgdG8gdGFrZSBhbiBvcGFxdWUgcG9pbnRlciBh
bmQgaW4gdGhlIGNhc2Ugd2hlcmUgd2UNCj4gPiBjYWxsZWQgcGh5bGlua19jcmVhdGUoKSBhbmQg
cGFzc2VkIGRvd24gYSBuZXRfZGV2aWNlIHBvaW50ZXIsIHdlDQo+ID4gc29tZWhvdyByZW1lbWJl
ciB0aGF0IGZvciBkb2luZyBhbnkgb3BlcmF0aW9uIHRoYXQgcmVxdWlyZXMgYQ0KPiA+IG5ldF9k
ZXZpY2UgKHByaW50aW5nLCBzZXR0aW5nIGNhcnJpZXIpLiBXZSBsb3NlIHN0cmljdCB0eXBpbmcg
aW4gZG9pbmcNCj4gPiB0aGF0LCBidXQgd2UnZCBoYXZlIGZld2VyIHBsYWNlcyB0byBwYXRjaCBm
b3IgYSBibG9ja2luZyBub3RpZmllciBjYWxsLg0KPiA+DQo+IA0KPiBPciBldmVuIG1ha2UgdGhv
c2UgZnVuY3Rpb25zIHBhcnQgb2YgcGh5bGlua19tYWNfb3BzIHN1Y2ggdGhhdCB0aGUgY2FsbGVy
DQo+IGNvdWxkIHBhc3MgYW4gLmNhcnJpZXJfb2sgY2FsbGJhY2sgd2hpY2ggaXMgbmV0aWZfY2Fy
cmllcl9vaygpIGZvciBhIG5ldF9kZXZpY2UsDQo+IGVsc2UgaXQncyBOVUxMLCBzYW1lIHdpdGgg
cHJpbnRpbmcgZnVuY3Rpb25zIGlmIGRlc2lyZWQuLi4NCj4gLS0NCj4gRmxvcmlhbg0KDQoNCkxl
dCBtZSBzZWUgaWYgSSB1bmRlcnN0b29kIHRoaXMgY29ycmVjdGx5LiBJIHByZXN1bWUgdGhhdCBh
bnkgQVBJIHRoYXQgd2UgYWRkIHNob3VsZCBub3QgYnJlYWsgYW55IGN1cnJlbnQgUEhZTElOSyB1
c2Vycy4NCg0KWW91IHN1Z2dlc3QgdG8gY2hhbmdlIHRoZSBwcm90b3R5cGUgb2YgdGhlIHBoeWxp
bmtfbWFjX29wcyBmcm9tDQoNCgl2b2lkICgqdmFsaWRhdGUpKHN0cnVjdCBuZXRfZGV2aWNlICpu
ZGV2LCB1bnNpZ25lZCBsb25nICpzdXBwb3J0ZWQsDQoJCQkgc3RydWN0IHBoeWxpbmtfbGlua19z
dGF0ZSAqc3RhdGUpOw0KDQp0byBzb21ldGhpbmcgdGhhdCB0YWtlcyBhIHZvaWQgcG9pbnRlcjoN
Cg0KCXZvaWQgKCp2YWxpZGF0ZSkodm9pZCAqZGV2LCB1bnNpZ25lZCBsb25nICpzdXBwb3J0ZWQs
DQoJCQkgc3RydWN0IHBoeWxpbmtfbGlua19zdGF0ZSAqc3RhdGUpOw0KDQpUaGlzIHdvdWxkIGlt
cGx5IHRoYXQgdGhlIGFueSBmdW5jdGlvbiBpbiBQSFlMSU5LIHdvdWxkIGhhdmUgdG8gc29tZWhv
dyBkaWZmZXJlbnRpYXRlIGlmIHRoZSBkZXYgcHJvdmlkZWQgaXMgaW5kZWVkIGEgbmV0X2Rldmlj
ZSBvciBhbm90aGVyIHN0cnVjdHVyZSBpbiBvcmRlciB0byBtYWtlIHRoZSBkZWNpc2lvbiBpZiBu
ZXRpZl9jYXJyaWVyX29mZiBzaG91bGQgYmUgY2FsbGVkIG9yIG5vdCAodGhpcyBpcyBzbyB3ZSBk
byBub3QgYnJlYWsgYW55IGRyaXZlcnMgdXNpbmcgUEhZTElOSykuIEkgY2Fubm90IHNlZSBob3cg
dGhpcyBqdWRnZW1lbnQgY2FuIGJlIG1hZGUuDQoNCi0tDQpJb2FuYQ0K

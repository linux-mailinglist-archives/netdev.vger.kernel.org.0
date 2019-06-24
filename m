Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F318D51031
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbfFXPWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:22:45 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:20036 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728380AbfFXPWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 11:22:44 -0400
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Nicolas.Ferre@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="Nicolas.Ferre@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; spf=Pass smtp.mailfrom=Nicolas.Ferre@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.63,412,1557212400"; 
   d="scan'208";a="38662944"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jun 2019 08:22:43 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.87.71) by
 chn-vm-ex03.mchp-main.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 24 Jun 2019 08:21:44 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5 via Frontend
 Transport; Mon, 24 Jun 2019 08:22:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43OJ/uMQh99QmLfrxKCnUUDXREFUOMhaaY4rq8jPbMc=;
 b=JkAezk76E8NUvq4YPPMZARtbOE21oolMeigF+wAGhmcL4rxS1udict5L1QZQQtaEAGObC/F4UiXseSAA9YMdtx6jJgu9klDA2BeUxS8ilBzuBq0Ao0zXLPDEGjTS24+tOUykSAz2ME704hshsAEaW4s36i5pBQMJciTWn7mSYUs=
Received: from MWHPR11MB1662.namprd11.prod.outlook.com (10.172.55.15) by
 MWHPR11MB1935.namprd11.prod.outlook.com (10.175.52.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Mon, 24 Jun 2019 15:22:41 +0000
Received: from MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::7534:63dc:8504:c2b3]) by MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::7534:63dc:8504:c2b3%6]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 15:22:41 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <palmer@sifive.com>, <harini.katakam@xilinx.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.simek@xilinx.com>
Subject: Re: [PATCH 1/2] net: macb: Fix compilation on systems without
 COMMON_CLK
Thread-Topic: [PATCH 1/2] net: macb: Fix compilation on systems without
 COMMON_CLK
Thread-Index: AQHVKqCqFQFm2ETAS0C/ZCmNkZW81Q==
Date:   Mon, 24 Jun 2019 15:22:41 +0000
Message-ID: <8bf8f052-cb9e-a4a6-4a7f-584cbd20582d@microchip.com>
References: <mhng-ac6d3a1f-07a8-40b5-a4ad-93e529ecc206@palmer-si-x1e>
In-Reply-To: <mhng-ac6d3a1f-07a8-40b5-a4ad-93e529ecc206@palmer-si-x1e>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0315.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::15) To MWHPR11MB1662.namprd11.prod.outlook.com
 (2603:10b6:301:e::15)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [213.41.198.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba9ffde3-3dd1-4ed3-5fb2-08d6f8b7cc64
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1935;
x-ms-traffictypediagnostic: MWHPR11MB1935:
x-microsoft-antispam-prvs: <MWHPR11MB1935C46BF3FE298D2A07ECB6E0E00@MWHPR11MB1935.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(376002)(136003)(39860400002)(396003)(199004)(189003)(6512007)(5660300002)(76176011)(99286004)(6436002)(186003)(14454004)(6486002)(66556008)(64756008)(52116002)(229853002)(31696002)(66946007)(66446008)(66476007)(73956011)(86362001)(31686004)(14444005)(54906003)(446003)(110136005)(11346002)(8936002)(6116002)(71190400001)(71200400001)(486006)(25786009)(3846002)(316002)(256004)(4326008)(68736007)(2906002)(8676002)(36756003)(476003)(2616005)(66066001)(6506007)(53546011)(53936002)(386003)(478600001)(102836004)(72206003)(6246003)(26005)(7736002)(81156014)(81166006)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1935;H:MWHPR11MB1662.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JfKd/AD0OTR/Z5FEY5xOQ11fCGIKjyZGKLXmqDiBrFo7Lqgt/JOwRrdZN4F/r8+SBkBO+UFi1MWLUtOTcMD5cvBwr7TBU05F4wEMidKZbqZfKOMJ99EyZPnS1sxmfB81CFEG8GAQOKbNlBatTvMFvfZZW/MqIQdrH2ajkB/c+VIO2xtSmyQ5/aVYPOnjYlqpqTCnZEKR8btppf915yGHldXtIGgOgGHiRBmAMS9AoIR+B0OsWYl2FFpBDzb05DxvJG0CseEqqUeHZmPPn+qrICN75t7BMUzpmH1PG8RyIM8SNRxwILy5slrRlXYNl9dXRR4ftM3KpdEaP1E8wHd8o8FpW6Q2CPV7UDNV2O9iz4CnPh+hQ/oUw49Z5pcdJU3m6HMTDEBI5xdKWLIRm2ZtDaEhRxCxir7pPOa6v0/AQQE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8310E3026F696345B379E3F734263546@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ba9ffde3-3dd1-4ed3-5fb2-08d6f8b7cc64
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 15:22:41.4490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nicolas.ferre@microchip.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1935
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjQvMDYvMjAxOSBhdCAxMTo1NywgUGFsbWVyIERhYmJlbHQgd3JvdGU6DQo+IEV4dGVybmFs
IEUtTWFpbA0KPiANCj4gDQo+IE9uIE1vbiwgMjQgSnVuIDIwMTkgMDI6NDA6MjEgUERUICgtMDcw
MCksIE5pY29sYXMuRmVycmVAbWljcm9jaGlwLmNvbSB3cm90ZToNCj4+IE9uIDI0LzA2LzIwMTkg
YXQgMDg6MTYsIFBhbG1lciBEYWJiZWx0IHdyb3RlOg0KPj4+IEV4dGVybmFsIEUtTWFpbA0KPj4+
DQo+Pj4NCj4+PiBUaGUgcGF0Y2ggdG8gYWRkIHN1cHBvcnQgZm9yIHRoZSBGVTU0MC1DMDAwIGFk
ZGVkIGEgZGVwZW5kZW5jeSBvbg0KPj4+IENPTU1PTl9DTEssIGJ1dCBkaWRuJ3QgZXhwcmVzcyB0
aGF0IHZpYSBLY29uZmlnLiAgVGhpcyBmaXhlcyB0aGUgYnVpbGQNCj4+PiBmYWlsdXJlIGJ5IGFk
ZGluZyBDT05GSUdfTUFDQl9GVTU0MCwgd2hpY2ggZGVwZW5kcyBvbiBDT01NT05fQ0xLIGFuZA0K
Pj4+IGNvbmRpdGlvbmFsbHkgZW5hYmxlcyB0aGUgRlU1NDAtQzAwMCBzdXBwb3J0Lg0KPj4NCj4+
IExldCdzIHRyeSB0byBsaW1pdCB0aGUgdXNlIG9mICAjaWZkZWYncyB0aHJvdWdob3V0IHRoZSBj
b2RlLiBXZSBhcmUNCj4+IHVzaW5nIHRoZW0gaW4gdGhpcyBkcml2ZXIgYnV0IG9ubHkgZm9yIHRo
ZSBob3QgcGF0aHMgYW5kIHRoaW5ncyB0aGF0DQo+PiBoYXZlIGFuIGltcGFjdCBvbiBwZXJmb3Jt
YW5jZS4gSSBkb24ndCB0aGluayBpdCdzIHRoZSBjYXNlIGhlcmU6IHNvDQo+PiBwbGVhc2UgZmlu
ZCBhbm90aGVyIG9wdGlvbiA9PiBOQUNLLg0KPiANCj4gT0suICBXb3VsZCB5b3UgYWNjZXB0IGFk
ZGluZyBhIEtjb25maWcgZGVwZW5kZW5jeSBvZiB0aGUgZ2VuZXJpYyBNQUNCIGRyaXZlciBvbg0K
PiBDT01NT05fQ0xLLCBhcyBzdWdnZXN0ZWQgaW4gdGhlIGNvdmVyIGxldHRlcj8NCg0KWWVzOiBh
bGwgdXNlcnMgb2YgdGhpcyBwZXJpcGhlcmFsIGhhdmUgQ09NTU9OX0NMSyBzZXQuDQpZb3UgY2Fu
IHJlbW92ZSBpdCBmcm9tIHRoZSBQQ0kgd3JhcHBlciB0aGVuLg0KDQpCZXN0IHJlZ2FyZHMsDQog
ICBOaWNvbGFzDQoNCj4+PiBJJ3ZlIGJ1aWx0IHRoaXMgd2l0aCBhIHBvd2VycGMgYWxseWVzY29u
ZmlnICh3aGljaCBwb2ludGVkIG91dCB0aGUgYnVnKQ0KPj4+IGFuZCBvbiBSSVNDLVYsIG1hbnVh
bGx5IGNoZWNraW5nIHRvIGVuc3VyZSB0aGUgY29kZSB3YXMgYnVpbHQuICBJDQo+Pj4gaGF2ZW4n
dCBldmVuIGJvb3RlZCB0aGUgcmVzdWx0aW5nIGtlcm5lbHMuDQo+Pj4NCj4+PiBGaXhlczogYzIx
OGFkNTU5MDIwICgibWFjYjogQWRkIHN1cHBvcnQgZm9yIFNpRml2ZSBGVTU0MC1DMDAwIikNCj4+
PiBTaWduZWQtb2ZmLWJ5OiBQYWxtZXIgRGFiYmVsdCA8cGFsbWVyQHNpZml2ZS5jb20+DQo+Pj4g
LS0tDQo+Pj4gICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9LY29uZmlnICAgICB8IDEx
ICsrKysrKysrKysrDQo+Pj4gICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21h
aW4uYyB8IDEyICsrKysrKysrKysrKw0KPj4+ICAgIDIgZmlsZXMgY2hhbmdlZCwgMjMgaW5zZXJ0
aW9ucygrKQ0KPj4+DQo+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVu
Y2UvS2NvbmZpZyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvS2NvbmZpZw0KPj4+IGlu
ZGV4IDE3NjY2OTdjOWM1YS4uNzRlZTJiZmQyMzY5IDEwMDY0NA0KPj4+IC0tLSBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2NhZGVuY2UvS2NvbmZpZw0KPj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2NhZGVuY2UvS2NvbmZpZw0KPj4+IEBAIC00MCw2ICs0MCwxNyBAQCBjb25maWcgTUFDQl9V
U0VfSFdTVEFNUA0KPj4+ICAgIAktLS1oZWxwLS0tDQo+Pj4gICAgCSAgRW5hYmxlIElFRUUgMTU4
OCBQcmVjaXNpb24gVGltZSBQcm90b2NvbCAoUFRQKSBzdXBwb3J0IGZvciBNQUNCLg0KPj4+ICAg
IA0KPj4+ICtjb25maWcgTUFDQl9GVTU0MA0KPj4+ICsJYm9vbCAiRW5hYmxlIHN1cHBvcnQgZm9y
IHRoZSBTaUZpdmUgRlU1NDAgY2xvY2sgY29udHJvbGxlciINCj4+PiArCWRlcGVuZHMgb24gTUFD
QiAmJiBDT01NT05fQ0xLDQo+Pj4gKwlkZWZhdWx0IHkNCj4+PiArCS0tLWhlbHAtLS0NCj4+PiAr
CSAgRW5hYmxlIHN1cHBvcnQgZm9yIHRoZSBNQUNCL0dFTSBjbG9jayBjb250cm9sbGVyIG9uIHRo
ZSBTaUZpdmUNCj4+PiArCSAgRlU1NDAtQzAwMC4gIFRoaXMgZGV2aWNlIGlzIG5lY2Vzc2FyeSBm
b3Igc3dpdGNoaW5nIGJldHdlZW4gMTAvMTAwDQo+Pj4gKwkgIGFuZCBnaWdhYml0IG1vZGVzIG9u
IHRoZSBGVTU0MC1DMDAwIFNvQywgd2l0aG91dCB3aGljaCBpdCBpcyBvbmx5DQo+Pj4gKwkgIHBv
c3NpYmxlIHRvIGJyaW5nIHVwIHRoZSBFdGhlcm5ldCBsaW5rIGluIHdoYXRldmVyIG1vZGUgdGhl
DQo+Pj4gKwkgIGJvb3Rsb2FkZXIgcHJvYmVkLg0KPj4+ICsNCj4+PiAgICBjb25maWcgTUFDQl9Q
Q0kNCj4+PiAgICAJdHJpc3RhdGUgIkNhZGVuY2UgUENJIE1BQ0IvR0VNIHN1cHBvcnQiDQo+Pj4g
ICAgCWRlcGVuZHMgb24gTUFDQiAmJiBQQ0kgJiYgQ09NTU9OX0NMSw0KPj4+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jIGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPj4+IGluZGV4IGM1NDVjNWI0MzVkOC4uYTkw
M2RmZGQ0MTgzIDEwMDY0NA0KPj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2Uv
bWFjYl9tYWluLmMNCj4+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2Jf
bWFpbi5jDQo+Pj4gQEAgLTQxLDYgKzQxLDcgQEANCj4+PiAgICAjaW5jbHVkZSA8bGludXgvcG1f
cnVudGltZS5oPg0KPj4+ICAgICNpbmNsdWRlICJtYWNiLmgiDQo+Pj4gICAgDQo+Pj4gKyNpZmRl
ZiBDT05GSUdfTUFDQl9GVTU0MA0KPj4+ICAgIC8qIFRoaXMgc3RydWN0dXJlIGlzIG9ubHkgdXNl
ZCBmb3IgTUFDQiBvbiBTaUZpdmUgRlU1NDAgZGV2aWNlcyAqLw0KPj4+ICAgIHN0cnVjdCBzaWZp
dmVfZnU1NDBfbWFjYl9tZ210IHsNCj4+PiAgICAJdm9pZCBfX2lvbWVtICpyZWc7DQo+Pj4gQEAg
LTQ5LDYgKzUwLDcgQEAgc3RydWN0IHNpZml2ZV9mdTU0MF9tYWNiX21nbXQgew0KPj4+ICAgIH07
DQo+Pj4gICAgDQo+Pj4gICAgc3RhdGljIHN0cnVjdCBzaWZpdmVfZnU1NDBfbWFjYl9tZ210ICpt
Z210Ow0KPj4+ICsjZW5kaWYNCj4+PiAgICANCj4+PiAgICAjZGVmaW5lIE1BQ0JfUlhfQlVGRkVS
X1NJWkUJMTI4DQo+Pj4gICAgI2RlZmluZSBSWF9CVUZGRVJfTVVMVElQTEUJNjQgIC8qIGJ5dGVz
ICovDQo+Pj4gQEAgLTM5NTYsNiArMzk1OCw3IEBAIHN0YXRpYyBpbnQgYXQ5MWV0aGVyX2luaXQo
c3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4+PiAgICAJcmV0dXJuIDA7DQo+Pj4gICAg
fQ0KPj4+ICAgIA0KPj4+ICsjaWZkZWYgQ09ORklHX01BQ0JfRlU1NDANCj4+PiAgICBzdGF0aWMg
dW5zaWduZWQgbG9uZyBmdTU0MF9tYWNiX3R4X3JlY2FsY19yYXRlKHN0cnVjdCBjbGtfaHcgKmh3
LA0KPj4+ICAgIAkJCQkJICAgICAgIHVuc2lnbmVkIGxvbmcgcGFyZW50X3JhdGUpDQo+Pj4gICAg
ew0KPj4+IEBAIC00MDU2LDcgKzQwNTksOSBAQCBzdGF0aWMgaW50IGZ1NTQwX2MwMDBfaW5pdChz
dHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPj4+ICAgIA0KPj4+ICAgIAlyZXR1cm4gbWFj
Yl9pbml0KHBkZXYpOw0KPj4+ICAgIH0NCj4+PiArI2VuZGlmDQo+Pj4gICAgDQo+Pj4gKyNpZmRl
ZiBDT05GSUdfTUFDQl9GVTU0MA0KPj4+ICAgIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbWFjYl9jb25m
aWcgZnU1NDBfYzAwMF9jb25maWcgPSB7DQo+Pj4gICAgCS5jYXBzID0gTUFDQl9DQVBTX0dJR0FC
SVRfTU9ERV9BVkFJTEFCTEUgfCBNQUNCX0NBUFNfSlVNQk8gfA0KPj4+ICAgIAkJTUFDQl9DQVBT
X0dFTV9IQVNfUFRQLA0KPj4+IEBAIC00MDY1LDYgKzQwNzAsNyBAQCBzdGF0aWMgY29uc3Qgc3Ry
dWN0IG1hY2JfY29uZmlnIGZ1NTQwX2MwMDBfY29uZmlnID0gew0KPj4+ICAgIAkuaW5pdCA9IGZ1
NTQwX2MwMDBfaW5pdCwNCj4+PiAgICAJLmp1bWJvX21heF9sZW4gPSAxMDI0MCwNCj4+PiAgICB9
Ow0KPj4+ICsjZW5kaWYNCj4+PiAgICANCj4+PiAgICBzdGF0aWMgY29uc3Qgc3RydWN0IG1hY2Jf
Y29uZmlnIGF0OTFzYW05MjYwX2NvbmZpZyA9IHsNCj4+PiAgICAJLmNhcHMgPSBNQUNCX0NBUFNf
VVNSSU9fSEFTX0NMS0VOIHwgTUFDQl9DQVBTX1VTUklPX0RFRkFVTFRfSVNfTUlJX0dNSUksDQo+
Pj4gQEAgLTQxNTUsNyArNDE2MSw5IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgb2ZfZGV2aWNlX2lk
IG1hY2JfZHRfaWRzW10gPSB7DQo+Pj4gICAgCXsgLmNvbXBhdGlibGUgPSAiY2RucyxlbWFjIiwg
LmRhdGEgPSAmZW1hY19jb25maWcgfSwNCj4+PiAgICAJeyAuY29tcGF0aWJsZSA9ICJjZG5zLHp5
bnFtcC1nZW0iLCAuZGF0YSA9ICZ6eW5xbXBfY29uZmlnfSwNCj4+PiAgICAJeyAuY29tcGF0aWJs
ZSA9ICJjZG5zLHp5bnEtZ2VtIiwgLmRhdGEgPSAmenlucV9jb25maWcgfSwNCj4+PiArI2lmZGVm
IENPTkZJR19NQUNCX0ZVNTQwDQo+Pj4gICAgCXsgLmNvbXBhdGlibGUgPSAic2lmaXZlLGZ1NTQw
LW1hY2IiLCAuZGF0YSA9ICZmdTU0MF9jMDAwX2NvbmZpZyB9LA0KPj4+ICsjZW5kaWYNCj4+PiAg
ICAJeyAvKiBzZW50aW5lbCAqLyB9DQo+Pj4gICAgfTsNCj4+PiAgICBNT0RVTEVfREVWSUNFX1RB
QkxFKG9mLCBtYWNiX2R0X2lkcyk7DQo+Pj4gQEAgLTQzNjMsNyArNDM3MSw5IEBAIHN0YXRpYyBp
bnQgbWFjYl9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPj4+ICAgIA0KPj4+
ICAgIGVycl9kaXNhYmxlX2Nsb2NrczoNCj4+PiAgICAJY2xrX2Rpc2FibGVfdW5wcmVwYXJlKHR4
X2Nsayk7DQo+Pj4gKyNpZmRlZiBDT05GSUdfTUFDQl9GVTU0MA0KPj4+ICAgIAljbGtfdW5yZWdp
c3Rlcih0eF9jbGspOw0KPj4+ICsjZW5kaWYNCj4+PiAgICAJY2xrX2Rpc2FibGVfdW5wcmVwYXJl
KGhjbGspOw0KPj4+ICAgIAljbGtfZGlzYWJsZV91bnByZXBhcmUocGNsayk7DQo+Pj4gICAgCWNs
a19kaXNhYmxlX3VucHJlcGFyZShyeF9jbGspOw0KPj4+IEBAIC00Mzk4LDcgKzQ0MDgsOSBAQCBz
dGF0aWMgaW50IG1hY2JfcmVtb3ZlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+Pj4g
ICAgCQlwbV9ydW50aW1lX2RvbnRfdXNlX2F1dG9zdXNwZW5kKCZwZGV2LT5kZXYpOw0KPj4+ICAg
IAkJaWYgKCFwbV9ydW50aW1lX3N1c3BlbmRlZCgmcGRldi0+ZGV2KSkgew0KPj4+ICAgIAkJCWNs
a19kaXNhYmxlX3VucHJlcGFyZShicC0+dHhfY2xrKTsNCj4+PiArI2lmZGVmIENPTkZJR19NQUNC
X0ZVNTQwDQo+Pj4gICAgCQkJY2xrX3VucmVnaXN0ZXIoYnAtPnR4X2Nsayk7DQo+Pj4gKyNlbmRp
Zg0KPj4+ICAgIAkJCWNsa19kaXNhYmxlX3VucHJlcGFyZShicC0+aGNsayk7DQo+Pj4gICAgCQkJ
Y2xrX2Rpc2FibGVfdW5wcmVwYXJlKGJwLT5wY2xrKTsNCj4+PiAgICAJCQljbGtfZGlzYWJsZV91
bnByZXBhcmUoYnAtPnJ4X2Nsayk7DQo+Pj4NCj4+DQo+Pg0KPj4gLS0gDQo+PiBOaWNvbGFzIEZl
cnJlDQoNCg0KLS0gDQpOaWNvbGFzIEZlcnJlDQo=

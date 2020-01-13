Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03564138D37
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 09:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbgAMIuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 03:50:15 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:7929 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728682AbgAMIuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 03:50:15 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Claudiu.Beznea@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="Claudiu.Beznea@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; spf=Pass smtp.mailfrom=Claudiu.Beznea@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: J8KUkutId6NeILy8P+JDI/HVcE5lbEZripuHb9eZ4oJf/tw6atNZVBM8FuRrilKfNt9qdjczj0
 Z/AWTypx3ClFohLmyKdyUryG+JwDxDhiaEuoszLD+ZZOgOsaQiPh3U5PMU17XSWHQvtKq40Qid
 5bX1mRMWVd9xIZD/de/JWT/LoNFVth8SS4W7AK+FC8+MZCHtvmTxFy5KSyzcd6/qZWDU4gJQH1
 hNabz7Kp3lQkEy33S4z68y2TxY6dCQnhn2Fy3VuHiZeZ2mBAnRwcs4g9Ji0Su7AnRj+Pnsh/4v
 6IY=
X-IronPort-AV: E=Sophos;i="5.69,428,1571727600"; 
   d="scan'208";a="63040613"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jan 2020 01:50:13 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 13 Jan 2020 01:50:13 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 13 Jan 2020 01:50:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hCQWkTGqizHrMcsBOZa8bOT3Io0nDMCLlvTbMNVXqnNmoNtXON8JNg1hYh57zay1WMuZhyRBEiTtuXllzmkB8paqCwTr/pCtEi61XM5WIiXxmOMxO3EIcrroIcWGKaTyJgM4237+Lqw2lUKKnNNtWoTjq6PUbPutxSTWCIhm87g3gLjApzJSPyBB9QuvN3pjgeuYdAaLySWm7uGI6tbhHUMINywn3+t5vbb/WiH2YAVbIcqNLTd1zPEvQGhsW+6wya3WWY7ZxvALvxpjdPAgkKjq7kJ9G2VtflTG09F63Xl1ng/gtlxzAzYkyuG8shB3WlDRerIDIhGZQVinqn/GAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQHJ3Y9SepxpOxkIvE6bbR8wfQs682QImKTXfpfNYMk=;
 b=manFg2H1TaZzm6sYC6PyRkQc0JNBtR3Lhs1Hax5lGP2lUEHmHtkpuFQrjptcHv7J88DJ/zBNT07ME5dkUozcha3BfdQIEqEWeUGUnV24T3qtO0meEq1qrBHENA2ft4E/CeFOXTTzVf0s/2anyOJ0zAjw+ZZ5kt+OH+dtIO2bbj5QOOOe+m1qG7iJO7cZGjKq/tJjT+C4Nw1yoSf8MaGpcDhlcny63tcK8BFS6BiKZgwODR9bjURUokgmGMHFJNx0BVl8/J5uw3p/s4Me1bXQhPNxzR4uMVeP0j3j+g+TOPZSkGDMEHlWt7VW8rpq7gNv03LfSIwFCfvdmdOzcp8llA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQHJ3Y9SepxpOxkIvE6bbR8wfQs682QImKTXfpfNYMk=;
 b=se7zIKpOJlb1F/rMNsL/bSEAm5P1JpedCPk8/nNAjYcXAq0Rqdyyliv8DM/taAvhuLm/SSe09l0H7N4XFGTYE0kZXPX08XMGGNpyN4uVPySOXPiFIvjf0b9AYH3foDCEoDB57g6YCBZwgjwIrtqOIYY6Hi05GXUvXmZpACj5avM=
Received: from DM6PR11MB3225.namprd11.prod.outlook.com (20.176.120.224) by
 DM6PR11MB3084.namprd11.prod.outlook.com (20.177.219.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Mon, 13 Jan 2020 08:50:12 +0000
Received: from DM6PR11MB3225.namprd11.prod.outlook.com
 ([fe80::106f:424f:ac54:1dbb]) by DM6PR11MB3225.namprd11.prod.outlook.com
 ([fe80::106f:424f:ac54:1dbb%7]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 08:50:12 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <mparab@cadence.com>, <Nicolas.Ferre@microchip.com>,
        <jakub.kicinski@netronome.com>, <andrew@lunn.ch>,
        <antoine.tenart@bootlin.com>, <rmk+kernel@armlinux.org.uk>
CC:     <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <dkangude@cadence.com>,
        <a.fatoum@pengutronix.de>, <brad.mouring@ni.com>,
        <pthombar@cadence.com>
Subject: Re: [PATCH v3 net] net: macb: fix for fixed-link mode
Thread-Topic: [PATCH v3 net] net: macb: fix for fixed-link mode
Thread-Index: AQHVye53HjWj743yAku0O8hzj4Hz+w==
Date:   Mon, 13 Jan 2020 08:50:12 +0000
Message-ID: <d211e4f8-0893-84c8-5700-40b0bcf0474a@microchip.com>
References: <1578886243-43953-1-git-send-email-mparab@cadence.com>
In-Reply-To: <1578886243-43953-1-git-send-email-mparab@cadence.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd3b5cf8-6022-4724-2198-08d798059a10
x-ms-traffictypediagnostic: DM6PR11MB3084:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB308442B723DC0CC34740539287350@DM6PR11MB3084.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(39860400002)(366004)(136003)(396003)(189003)(199004)(2906002)(91956017)(76116006)(7416002)(8936002)(2616005)(6512007)(66476007)(4326008)(26005)(64756008)(66446008)(6506007)(53546011)(36756003)(110136005)(54906003)(66556008)(6486002)(8676002)(81156014)(81166006)(316002)(186003)(478600001)(86362001)(31696002)(66946007)(5660300002)(71200400001)(31686004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3084;H:DM6PR11MB3225.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ohsCFfwb8G5ccna0n4x/6fOqGafgW08CdfNgHTjdE7Jde0IRndWQTFVC3zAdiJK4U/L313SWB6t6APyXU6vAuhhEzX2stlAFOaOOvK7U7cNtj7GOBDZ/y+mXZObFpYnfq7q4AXsaEFkMZ5fZpDKWLk6Q31AwLmViBApsCGP+coh80Xg9nBJmAJ4z/vDu9Qmr+QVihikbmHXfi4cBhs75GbacVKr+b9PGmyXdrNASBn1gWcCOQBOJKyA4z/PkbrzCUHgriZsNRU3aRZ5a3m3O0C1FRjBVlo2+IKaVat/j8sdlQ1Z2iPPkkSifMD4IhvqznnUwUhEswy0C2mt6Ifl1pUfeo5CVHZKgB32CR84WJG6Pe2k7v6Yqs8jpUHfMl8MHf4wyQqFC8g0KOOldTxyajfuUObf720QjNGC9dtxc9/s0fpv1lY6qFg/QzWxLz2yD
Content-Type: text/plain; charset="utf-8"
Content-ID: <7552FEF451C45549B2963892A3E4FE69@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dd3b5cf8-6022-4724-2198-08d798059a10
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 08:50:12.2501
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZMdbLzPfC3ShcJ0ApRopxUUOHzds9fl1t/4XduRel05iAfQ58qVkcCowe55K7KjSTYSID57h9EDwB1dCIoeNNyoED5Iyemuon9KrqBnXgFQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3084
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEzLjAxLjIwMjAgMDU6MzAsIE1pbGluZCBQYXJhYiB3cm90ZToNCj4gRVhURVJOQUwg
RU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Ug
a25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBUaGlzIHBhdGNoIGZpeCB0aGUgaXNzdWUg
d2l0aCBmaXhlZCBsaW5rLiBXaXRoIGZpeGVkLWxpbmsNCj4gZGV2aWNlIG9wZW5pbmcgZmFpbHMg
ZHVlIHRvIG1hY2JfcGh5bGlua19jb25uZWN0IG5vdA0KPiBoYW5kbGluZyBmaXhlZC1saW5rIG1v
ZGUsIGluIHdoaWNoIGNhc2Ugbm8gTUFDLVBIWSBjb25uZWN0aW9uDQo+IGlzIG5lZWRlZCBhbmQg
cGh5bGlua19jb25uZWN0IHJldHVybiBzdWNjZXNzICgwKSwgaG93ZXZlcg0KPiBpbiBjdXJyZW50
IGRyaXZlciBhdHRlbXB0IGlzIG1hZGUgdG8gc2VhcmNoIGFuZCBjb25uZWN0IHRvDQo+IFBIWSBl
dmVuIGZvciBmaXhlZC1saW5rLg0KPiANCj4gRml4ZXM6IDc4OTdiMDcxYWMzYiAoIm5ldDogbWFj
YjogY29udmVydCB0byBwaHlsaW5rIikNCj4gU2lnbmVkLW9mZi1ieTogTWlsaW5kIFBhcmFiIDxt
cGFyYWJAY2FkZW5jZS5jb20+DQoNClJldmlld2VkLWJ5OiBDbGF1ZGl1IEJlem5lYSA8Y2xhdWRp
dS5iZXpuZWFAbWljcm9jaGlwLmNvbT4NCg0KPiAtLS0NCj4gQ2hhbmdlcyBpbiB2MjoNCj4gMS4g
Q29kZSByZWZhY3RvcmluZyB0byByZW1vdmUgZXh0cmEgaWYgY29uZGl0aW9uDQo+IA0KPiBDaGFu
Z2VzIGluIHYzOg0KPiAxLiBSZXZlcnNlIGNocmlzdG1hcyB0cmVlIG9yZGVyaW5nIG9mIGxvY2Fs
IHZhcmlhYmxlcw0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9t
YWluLmMgfCAzMCArKysrKysrKysrKysrKy0tLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAx
NyBpbnNlcnRpb25zKCspLCAxMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiBpbmRleCAxYzU0N2VlMGQ0NDQuLjdhMmZlNjNkMTEz
NiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4u
Yw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+IEBA
IC02NTAsMjEgKzY1MCwyNCBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHBoeWxpbmtfbWFjX29wcyBt
YWNiX3BoeWxpbmtfb3BzID0gew0KPiAgICAgICAgIC5tYWNfbGlua191cCA9IG1hY2JfbWFjX2xp
bmtfdXAsDQo+ICB9Ow0KPiANCj4gK3N0YXRpYyBib29sIG1hY2JfcGh5X2hhbmRsZV9leGlzdHMo
c3RydWN0IGRldmljZV9ub2RlICpkbikNCj4gK3sNCj4gKyAgICAgICBkbiA9IG9mX3BhcnNlX3Bo
YW5kbGUoZG4sICJwaHktaGFuZGxlIiwgMCk7DQo+ICsgICAgICAgb2Zfbm9kZV9wdXQoZG4pOw0K
PiArICAgICAgIHJldHVybiBkbiAhPSBOVUxMOw0KPiArfQ0KPiArDQo+ICBzdGF0aWMgaW50IG1h
Y2JfcGh5bGlua19jb25uZWN0KHN0cnVjdCBtYWNiICpicCkNCj4gIHsNCj4gKyAgICAgICBzdHJ1
Y3QgZGV2aWNlX25vZGUgKmRuID0gYnAtPnBkZXYtPmRldi5vZl9ub2RlOw0KPiAgICAgICAgIHN0
cnVjdCBuZXRfZGV2aWNlICpkZXYgPSBicC0+ZGV2Ow0KPiAgICAgICAgIHN0cnVjdCBwaHlfZGV2
aWNlICpwaHlkZXY7DQo+ICAgICAgICAgaW50IHJldDsNCj4gDQo+IC0gICAgICAgaWYgKGJwLT5w
ZGV2LT5kZXYub2Zfbm9kZSAmJg0KPiAtICAgICAgICAgICBvZl9wYXJzZV9waGFuZGxlKGJwLT5w
ZGV2LT5kZXYub2Zfbm9kZSwgInBoeS1oYW5kbGUiLCAwKSkgew0KPiAtICAgICAgICAgICAgICAg
cmV0ID0gcGh5bGlua19vZl9waHlfY29ubmVjdChicC0+cGh5bGluaywgYnAtPnBkZXYtPmRldi5v
Zl9ub2RlLA0KPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAw
KTsNCj4gLSAgICAgICAgICAgICAgIGlmIChyZXQpIHsNCj4gLSAgICAgICAgICAgICAgICAgICAg
ICAgbmV0ZGV2X2VycihkZXYsICJDb3VsZCBub3QgYXR0YWNoIFBIWSAoJWQpXG4iLCByZXQpOw0K
PiAtICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KPiAtICAgICAgICAgICAgICAg
fQ0KPiAtICAgICAgIH0gZWxzZSB7DQo+ICsgICAgICAgaWYgKGRuKQ0KPiArICAgICAgICAgICAg
ICAgcmV0ID0gcGh5bGlua19vZl9waHlfY29ubmVjdChicC0+cGh5bGluaywgZG4sIDApOw0KPiAr
DQo+ICsgICAgICAgaWYgKCFkbiB8fCAocmV0ICYmICFtYWNiX3BoeV9oYW5kbGVfZXhpc3RzKGRu
KSkpIHsNCj4gICAgICAgICAgICAgICAgIHBoeWRldiA9IHBoeV9maW5kX2ZpcnN0KGJwLT5taWlf
YnVzKTsNCj4gICAgICAgICAgICAgICAgIGlmICghcGh5ZGV2KSB7DQo+ICAgICAgICAgICAgICAg
ICAgICAgICAgIG5ldGRldl9lcnIoZGV2LCAibm8gUEhZIGZvdW5kXG4iKTsNCj4gQEAgLTY3Mywx
MCArNjc2LDExIEBAIHN0YXRpYyBpbnQgbWFjYl9waHlsaW5rX2Nvbm5lY3Qoc3RydWN0IG1hY2Ig
KmJwKQ0KPiANCj4gICAgICAgICAgICAgICAgIC8qIGF0dGFjaCB0aGUgbWFjIHRvIHRoZSBwaHkg
Ki8NCj4gICAgICAgICAgICAgICAgIHJldCA9IHBoeWxpbmtfY29ubmVjdF9waHkoYnAtPnBoeWxp
bmssIHBoeWRldik7DQo+IC0gICAgICAgICAgICAgICBpZiAocmV0KSB7DQo+IC0gICAgICAgICAg
ICAgICAgICAgICAgIG5ldGRldl9lcnIoZGV2LCAiQ291bGQgbm90IGF0dGFjaCB0byBQSFkgKCVk
KVxuIiwgcmV0KTsNCj4gLSAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIHJldDsNCj4gLSAg
ICAgICAgICAgICAgIH0NCj4gKyAgICAgICB9DQo+ICsNCj4gKyAgICAgICBpZiAocmV0KSB7DQo+
ICsgICAgICAgICAgICAgICBuZXRkZXZfZXJyKGRldiwgIkNvdWxkIG5vdCBhdHRhY2ggUEhZICgl
ZClcbiIsIHJldCk7DQo+ICsgICAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KPiAgICAgICAgIH0N
Cj4gDQo+ICAgICAgICAgcGh5bGlua19zdGFydChicC0+cGh5bGluayk7DQo+IC0tDQo+IDIuMTcu
MQ0KPiANCj4g

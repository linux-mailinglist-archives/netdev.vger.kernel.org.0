Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF6D136F58
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 15:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgAJO3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 09:29:33 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:4381 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbgAJO3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 09:29:32 -0500
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
IronPort-SDR: q5AiC3XkiauEHUQFQG17xILgSYBRgXKCrPTN1w/P5eSDbuM0CAQarGXVZ6eJN8ct5nAPWg7tza
 3ygMbof4X/nO89x/Eh43KeQh/Rrd8M+CpxFf8R3hBh2AxjhYJkahF5hgcGayTaoZnLo9lwNEmX
 MpjR/h93Xwa/gmoAwVfIhAhet6w6kSLnMop48QdZ1CCudHvii+urqRdBKdAFFwIQxoe89rokho
 j3K4B9eLZzMjTE9rKL9MSdPrjfnQTFHITdty0Uhx0hRGXHzw3eMc1uakez6+QRZeqnfx+9nk3B
 f/I=
X-IronPort-AV: E=Sophos;i="5.69,417,1571727600"; 
   d="scan'208";a="62877025"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Jan 2020 07:29:30 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 10 Jan 2020 07:29:30 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Fri, 10 Jan 2020 07:29:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JSqMLRReve8BV3ZaCM3KyNfU0/JusiiBOdUct00Em+P/DFuJAKeoNk6cvbLgO9d1fP46LiAw45ZKiq06qfO0JVJm2Tui8B29IXubQ5ffOS2VYG2+Cu93fwxw0dAqyuP+ANWuhVypzxMwzzdDd4wKd89kKUjgH+f0zmsW0ny9xTs8vxOffnyo3BXGsPDUKwaY9OZwJCSJHOQQgdOgOeCRkcO3TClA1XeHE58aksiodKKxTzpiz3fs80RHYAydeAmLLq+CxRh1jKzM9SzitVWRy7jPI8DdJ7BV7fITKx/btKNpAvhriV2pzV3w+WA8/YFKmEAFH7+TEJZ7tjIuJW6Dwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxloPh4/jxlmr4sbf54DV4SK9CqW6sDObohYQUYoWZU=;
 b=EKsLa5ltL2feIg37GfyMr7OdwS2HU2E45kCNITiRONVlJTSngEIVijhw+qJPDemsRcsetWF/yym0Vi6m+ZPF19qU/vQ3mPH8a2w6mSzExMvsJJlCAW0ZI1WJ6aGSQSwcIMjNMBwwcDBDL7Fy7oAIHzOev0FgImoSCGSJv9aQokThCFLKBg+0bBPra4PgE8FdVOSh8HCvnJKq+m3wtR8OzFwmThQluiDMCaYrDbRT2/Rzo/+NOnl//n5fOhKbz/xbji1CMYSU2ffF1i/Qrcb2v0ALLli0UncYOW3ddaJnJ3VuSdvmFl/sWh4h//PZLJMYhZCESZx3khLZPJsKykZT0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxloPh4/jxlmr4sbf54DV4SK9CqW6sDObohYQUYoWZU=;
 b=GasbKkqfqruBwca4atFPr/9Mq6DQxST94rMtnhNgOhG/2R3DFuuYreTDjjS8qwWSiISMBuQ3Sc2Lzy/WE4TmZqBcpWnOnNpw7XUuQajLeZGjgidnO2QbE9Winkqwtr+Jw8jAIj/+lu3UCMQUVM6gQMjYVahKmXmvBEIPgaA12Yk=
Received: from DM6PR11MB3225.namprd11.prod.outlook.com (20.176.120.224) by
 DM6PR11MB2619.namprd11.prod.outlook.com (20.176.99.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.11; Fri, 10 Jan 2020 14:29:27 +0000
Received: from DM6PR11MB3225.namprd11.prod.outlook.com
 ([fe80::106f:424f:ac54:1dbb]) by DM6PR11MB3225.namprd11.prod.outlook.com
 ([fe80::106f:424f:ac54:1dbb%7]) with mapi id 15.20.2623.008; Fri, 10 Jan 2020
 14:29:27 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <alexandre.belloni@bootlin.com>
CC:     <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <Nicolas.Ferre@microchip.com>, <Ludovic.Desroches@microchip.com>,
        <vkoul@kernel.org>, <Eugen.Hristev@microchip.com>,
        <jic23@kernel.org>, <knaack.h@gmx.de>, <lars@metafoo.de>,
        <pmeerw@pmeerw.net>, <mchehab@kernel.org>, <lee.jones@linaro.org>,
        <richard.genoud@gmail.com>, <radu_nicolae.pirea@upb.ro>,
        <Tudor.Ambarus@microchip.com>, <miquel.raynal@bootlin.com>,
        <richard@nod.at>, <vigneshr@ti.com>, <wg@grandegger.com>,
        <mkl@pengutronix.de>, <a.zummo@towertech.it>, <broonie@kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <linux-iio@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-spi@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-rtc@vger.kernel.org>
Subject: Re: [PATCH 03/16] dt-bindings: atmel-tcb: add microchip,<chip>-tcb
Thread-Topic: [PATCH 03/16] dt-bindings: atmel-tcb: add microchip,<chip>-tcb
Thread-Index: AQHVx8JdxpRYsxUulk+Au4WCpSrtFg==
Date:   Fri, 10 Jan 2020 14:29:27 +0000
Message-ID: <da99fbce-8341-19d2-12c9-144564d70726@microchip.com>
References: <1578488123-26127-1-git-send-email-claudiu.beznea@microchip.com>
 <1578488123-26127-4-git-send-email-claudiu.beznea@microchip.com>
 <20200110134001.GD1027187@piout.net>
In-Reply-To: <20200110134001.GD1027187@piout.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2b8e2ee-3f51-4d33-5aaf-08d795d97fae
x-ms-traffictypediagnostic: DM6PR11MB2619:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB261914089414C7B81ADA900387380@DM6PR11MB2619.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02788FF38E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(396003)(346002)(39860400002)(366004)(199004)(189003)(966005)(6486002)(71200400001)(26005)(6506007)(53546011)(6916009)(31696002)(478600001)(2616005)(8676002)(81166006)(186003)(81156014)(86362001)(64756008)(66446008)(7406005)(66556008)(66476007)(36756003)(2906002)(54906003)(31686004)(5660300002)(6512007)(66946007)(91956017)(76116006)(4326008)(8936002)(316002)(7416002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB2619;H:DM6PR11MB3225.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A30B1H1ZE17H9I1fgVDH+S8ZJ4VzWdgVlD/1s+7fYFSAW6V/IGfnMPOb+Hf4BGGxU8Yt5KMuuQ5+PcRy4449kUgZal5vhyireB9TFxUzxTlnaHFZUecYNPrj+rGiGTlr9VjHwuOOqhOGN7w56k4vROS0O1MWHVOtQUcE9mtKdrxnO/BRWHbx5rX8BTvh+o+DMp9fWaAhkLPTAcBaE1erSh2cKFheVd4Ve+Fg3/GhrLICcJcsbRcmdjUhfKXSW70UrQWJnunn5mYMHvIK4jbs4Cojh2/39O1BIv1lrEgUQ+bRILYl9+LmrRPMUGuzqcuK1j8LH7Ffl23YMG1HcwI1OLxernXxIfHLhv6xF3zu0EO8P65K6XVf/3Wl7b2ShXH8iZhJpICOzlvAlbgyVvYiN3EFJDzqIuroIyAgi6lkqscQlSpA4lvoRIZo69FJXg8GP/B66m4hIXpi300Htiju5JOoxyNnB5Yxr/I06kg2dXc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <88CA889BDD9DA749BF1403CE9B9231D5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f2b8e2ee-3f51-4d33-5aaf-08d795d97fae
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2020 14:29:27.8009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YeoEhpAe0UmE9ZEWjX/ksEr3eX2Yr5486S2WyfyiCLJXASfPHqr13AslEXQcfiqn6/FquOLYZD7dm87Z26xXBDeZdfiSupFXW/z11lsvwUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2619
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLjAxLjIwMjAgMTU6NDAsIEFsZXhhbmRyZSBCZWxsb25pIHdyb3RlOg0KPiBFWFRF
Uk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IE9uIDA4LzAxLzIwMjAgMTQ6NTU6
MTArMDIwMCwgQ2xhdWRpdSBCZXpuZWEgd3JvdGU6DQo+PiBBZGQgbWljcm9jaGlwLDxjaGlwPi10
Y2IgdG8gRFQgYmluZGluZ3MgZG9jdW1lbnRhdGlvbi4gVGhpcyBpcyBmb3INCj4+IG1pY3JvY2hp
cCxzYW05eDYwLXRjYi4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBDbGF1ZGl1IEJlem5lYSA8Y2xh
dWRpdS5iZXpuZWFAbWljcm9jaGlwLmNvbT4NCj4+IC0tLQ0KPj4gIERvY3VtZW50YXRpb24vZGV2
aWNldHJlZS9iaW5kaW5ncy9tZmQvYXRtZWwtdGNiLnR4dCB8IDUgKysrLS0NCj4+ICAxIGZpbGUg
Y2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1n
aXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbWZkL2F0bWVsLXRjYi50eHQg
Yi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbWZkL2F0bWVsLXRjYi50eHQNCj4+
IGluZGV4IGM0YTgzZTM2NGNiNi4uZTE3MTNlNDFmNmUwIDEwMDY0NA0KPj4gLS0tIGEvRG9jdW1l
bnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL21mZC9hdG1lbC10Y2IudHh0DQo+PiArKysgYi9E
b2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbWZkL2F0bWVsLXRjYi50eHQNCj4+IEBA
IC0xLDYgKzEsNyBAQA0KPj4gICogRGV2aWNlIHRyZWUgYmluZGluZ3MgZm9yIEF0bWVsIFRpbWVy
IENvdW50ZXIgQmxvY2tzDQo+PiAtLSBjb21wYXRpYmxlOiBTaG91bGQgYmUgImF0bWVsLDxjaGlw
Pi10Y2IiLCAic2ltcGxlLW1mZCIsICJzeXNjb24iLg0KPj4gLSAgPGNoaXA+IGNhbiBiZSAiYXQ5
MXJtOTIwMCIgb3IgImF0OTFzYW05eDUiDQo+PiArLSBjb21wYXRpYmxlOiBTaG91bGQgYmUgImF0
bWVsLDxjaGlwPi10Y2IiLCAibWljcm9jaGlwLDxjaGlwPi10Y2IiLA0KPj4gKyAgInNpbXBsZS1t
ZmQiLCAic3lzY29uIi4NCj4+ICsgIDxjaGlwPiBjYW4gYmUgImF0OTFybTkyMDAiLCAiYXQ5MXNh
bTl4NSIgb3IgInNhbTl4NjAiDQo+IA0KPiBhdG1lbCxzYW05eDYwLXRjYiwgbWljcm9jaGlwLGF0
OTFybTkyMDAtdGNiIGFuZCBtaWNyb2NoaXAsYXQ5MXNhbTl4NS10Y2INCj4gYXJlIG5vdCBhbGxv
d2VkIGFuZCB0aGUgZG9jdW1lbnRhdGlvbiBzaG91bGQgcmVmbGVjdCB0aGF0Lg0KDQpPSyEgSSds
bCBkb3VibGUgY2hlY2sgaXQuDQoNCj4gDQo+IEl0IHdvdWxkIHByb2JhYmx5IGJlIGVhc2llciB0
byBkbyB0aGF0IG9uIHRvcCBvZiB0aGUgeWFtbCBjb252ZXJzaW9uDQo+IGhlcmU6DQo+IGh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAxOTEwMDkyMjQwMDYuNTAyMS0yLWFsZXhhbmRyZS5i
ZWxsb25pQGJvb3RsaW4uY29tLw0KDQpJIGRvbid0IHNlZSB0aGlzIGludGVncmF0ZWQgaW4gbmV4
dC0yMDIwMDExMC4gQW0gSSBsb29raW5nIGF0IHRoZSB3cm9uZyBicmFuY2g/DQoNCj4gDQo+IC0t
DQo+IEFsZXhhbmRyZSBCZWxsb25pLCBCb290bGluDQo+IEVtYmVkZGVkIExpbnV4IGFuZCBLZXJu
ZWwgZW5naW5lZXJpbmcNCj4gaHR0cHM6Ly9ib290bGluLmNvbQ0KPiA=

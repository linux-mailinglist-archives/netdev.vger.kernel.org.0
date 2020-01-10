Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36723137094
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728394AbgAJPDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:03:02 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:8141 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728249AbgAJPDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 10:03:00 -0500
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
IronPort-SDR: q1mZVEN9+9nW+41vxWAi9UpPaolO36Gv6BAftDCUtxI9Vs+WlxZ+r9Mt14bSknsGsG5e9CWlT5
 GUOEqYpVdaJTX6RGfbeKYdrSIYqx9T6gj+foUKu4P/Ofdq7mPWdys8NrkrX9y42aCZSY4Hg6iX
 OVtsUuuauqEFqqwrjejtqKe75XqvXJHv8oVd6oZENCHuwIxMoh7J+3R7n/2mcsZ2ozbePmnEl2
 3PACBOOhyXFJQ/K3CgpJGMhmbiSZ6HOiWhKRpdjwSnVjCWGSoI+7P1HT/CI67Qv0r1q7ns2WFW
 hBc=
X-IronPort-AV: E=Sophos;i="5.69,417,1571727600"; 
   d="scan'208";a="62881054"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Jan 2020 08:02:57 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 10 Jan 2020 08:02:56 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Fri, 10 Jan 2020 08:02:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lswe8IrsffHQnGEOc/m08k4TFkyhASIbI9pLP6ZP2SUMgxlht8kOovEEVcmJ4yWRwdyVeOtRZmkeDv45nlY2bzGxvtZRNEaaYQFUiE3VkrTnjHIllvWdq/Uc74H6JMM92/gHliW4o4yPy/P4BUL4sJZXoxG6qtWIzR4b+7KSENVYEUIMmMBxgYH7ogVCUMk1i/vIcCUXPYAh4Q/p0Glhw4DvkLFQrc0TsR/p8g8NdDDATRD666Yty2aD8r2eByhKgxdigyGuTjy/lRjfYBiOnJhSdX7GbG+xWJqzWdCdqd/brn3PefDRVOlXAxhWUHfHJN64sK+AihX5+rYrShSigQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ROYUQMPp03uT25P58fK2sBlfAea5ZRoYtOpcKJhSISs=;
 b=LJAbNACXHrIL1ZOgru/FlYDYtHSbDZlz4TNkRIyjjALHC3sZbaAVjfi7lkUiomU62b7NzM959T6TATPshzX6b5caUnj7jDRQBCrGaY84L/zAwflQsrK3Jdvk95xbNZWXD+gBZ9wIO1hkoQUEfWPJ9fHK4oDvY5XGni0g6DObq/hlsZayX0h+bLSRahhXDBlI5xU+9h65jBIaXNSWPCJ9av1PINBkANLhrG7Eazp2hFGgJosGfTkv7SgTdsjF1OtQF+rW2yTMGFrccLM+gwU1F//G2kJLPjLTnybYWNp8rb1F8wcsb7hQ2ZXzjmpSEEK7NymestctrNnH1es7VjofTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ROYUQMPp03uT25P58fK2sBlfAea5ZRoYtOpcKJhSISs=;
 b=WPUm0YU5eWGC/DgvWkZMio4tPNbVPq899Z9fw6fILUacE1XLRZNfmq8dc290WXJZ3uDua0/2NFCNfRQzAWiPBAQhh2OHk2aMBbNNMaqSD4xWkR+1MiGnJqUDw15E7r8BzbcDJNO/Y2xs6DHLVPnTwhV68HDEfbG9h2GFuhEHqJ8=
Received: from DM6PR11MB3225.namprd11.prod.outlook.com (20.176.120.224) by
 DM6PR11MB4073.namprd11.prod.outlook.com (10.255.61.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Fri, 10 Jan 2020 15:02:55 +0000
Received: from DM6PR11MB3225.namprd11.prod.outlook.com
 ([fe80::106f:424f:ac54:1dbb]) by DM6PR11MB3225.namprd11.prod.outlook.com
 ([fe80::106f:424f:ac54:1dbb%7]) with mapi id 15.20.2623.008; Fri, 10 Jan 2020
 15:02:55 +0000
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
Subject: Re: [PATCH 11/16] dt-bindings: atmel,at91rm9200-rtc: add
 microchip,sam9x60-rtc
Thread-Topic: [PATCH 11/16] dt-bindings: atmel,at91rm9200-rtc: add
 microchip,sam9x60-rtc
Thread-Index: AQHVx8cJ1Sdz4XPBp0a+PBJp3PSmrg==
Date:   Fri, 10 Jan 2020 15:02:55 +0000
Message-ID: <cd8ecfb1-b88a-88c4-205f-45ac7e25c5cc@microchip.com>
References: <1578488123-26127-1-git-send-email-claudiu.beznea@microchip.com>
 <1578488123-26127-12-git-send-email-claudiu.beznea@microchip.com>
 <20200110143001.GE1027187@piout.net>
In-Reply-To: <20200110143001.GE1027187@piout.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f3eed86-8fd5-4bf0-35f0-08d795de2c78
x-ms-traffictypediagnostic: DM6PR11MB4073:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB4073030C1B5DBFA428B71AF787380@DM6PR11MB4073.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 02788FF38E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(39860400002)(376002)(366004)(136003)(199004)(189003)(8676002)(186003)(5660300002)(6486002)(6512007)(2906002)(71200400001)(53546011)(6506007)(2616005)(26005)(478600001)(66556008)(6916009)(66946007)(66446008)(76116006)(64756008)(66476007)(4326008)(8936002)(81166006)(54906003)(91956017)(31686004)(31696002)(7416002)(7406005)(966005)(316002)(86362001)(81156014)(36756003)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB4073;H:DM6PR11MB3225.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iwSqYCZiVdt5raWL0+yTz682VYv1qyx7XtWg5eo1oekx5xf+sw34bc+EqB2Vat14SBoqfHBZUhe9AONHULKP8ivYiLSZs7xr+DXzvLR8ttdv2tvPCBpwTma/flzeDtc7Iit+bqLnXKQMep/PIIEDt37PDXTPhqHOoqHvZVSOdoC+rfSP9yQx+BRACJXVCFZQ9tFrbQKqr2GpctWj6kRFS8z+2eX+sBjuu4yjg3anKLa5LX1r07sOqueQo5ZPonA4FULeeAah2U+2kN83Dj9+5nF4KEPY/HGGofbi2Tcqph845d2tmA4ZjQdM7FHfIpU7UN19QOmwRhmOCXxlvVZOVo09I/UiXWjRT47z9AF+29AO/ayrBLKwqpIjt1Ltl7IbS4s++yTfnpkLlDl7RNP5luU6+XeTgwG6SEzdUK7aQoCJnmXwK2AmGNX8cHrnMUqGwaYFLHpCvvHEiOJYOB78PykKqXObMglF01qSpJKVNmY1mEdG8WWlVGqv1NPBEVQbm5TZEP3brumwVq61Foe0yg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <AE39BBAE4DFACA498B36344FFFF2868E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f3eed86-8fd5-4bf0-35f0-08d795de2c78
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2020 15:02:55.5649
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lstx1sjPtslO9cBwiO8kwk8GOEMvvmTcWCx/9VtduurAc4xi13Z118GNEtPtQAoOyi5efonltgFH80Q7t6LwkHm2VBspvI71Uh+h8ZS3nmM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4073
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLjAxLjIwMjAgMTY6MzAsIEFsZXhhbmRyZSBCZWxsb25pIHdyb3RlOg0KPiBFWFRF
Uk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IEhpLA0KPiANCj4gT24gMDgvMDEv
MjAyMCAxNDo1NToxOCswMjAwLCBDbGF1ZGl1IEJlem5lYSB3cm90ZToNCj4+IEFkZCBtaWNyb2No
aXAsc2FtOXg2MC1ydGMgdG8gRFQgYmluZGluZ3MgZG9jdW1lbnRhdGlvbi4NCj4gDQo+IFRoaXMg
d2lsbCBoYXZlIHRvIGJlIHJlYmFzZWQgb24gdG9wIG9mDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2xpbnV4LXJ0Yy8yMDE5MTIyOTIwNDQyMS4zMzc2MTItMi1hbGV4YW5kcmUuYmVsbG9uaUBi
b290bGluLmNvbS8NCg0KVGhpcyBpcyBhbHNvIG5vdCBpbnRlZ3JhdGVkIGluIGxhdGVzdCBuZXh0
LiBXaWxsIHRoaXMgcG9zdHBvbmUgdGhlDQphY2NlcHRhbmNlIG9mIHRoZSBkZXZpY2UgdHJlZSwg
dW50aWwgdGhlIHlhbWwgY29udmVyc2lvbiBpcyBhY2NlcHRlZD8NCg0KPiANCj4+DQo+PiBTaWdu
ZWQtb2ZmLWJ5OiBDbGF1ZGl1IEJlem5lYSA8Y2xhdWRpdS5iZXpuZWFAbWljcm9jaGlwLmNvbT4N
Cj4+IC0tLQ0KPj4gIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9ydGMvYXRtZWws
YXQ5MXJtOTIwMC1ydGMudHh0IHwgMyArKy0NCj4+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRp
b25zKCspLCAxIGRlbGV0aW9uKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24v
ZGV2aWNldHJlZS9iaW5kaW5ncy9ydGMvYXRtZWwsYXQ5MXJtOTIwMC1ydGMudHh0IGIvRG9jdW1l
bnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3J0Yy9hdG1lbCxhdDkxcm05MjAwLXJ0Yy50eHQN
Cj4+IGluZGV4IDVkMzc5MWU3ODljNi4uMzVlYWI5MTM4ZDBiIDEwMDY0NA0KPj4gLS0tIGEvRG9j
dW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3J0Yy9hdG1lbCxhdDkxcm05MjAwLXJ0Yy50
eHQNCj4+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9ydGMvYXRtZWws
YXQ5MXJtOTIwMC1ydGMudHh0DQo+PiBAQCAtMSw3ICsxLDggQEANCj4+ICBBdG1lbCBBVDkxUk05
MjAwIFJlYWwgVGltZSBDbG9jaw0KPj4NCj4+ICBSZXF1aXJlZCBwcm9wZXJ0aWVzOg0KPj4gLS0g
Y29tcGF0aWJsZTogc2hvdWxkIGJlOiAiYXRtZWwsYXQ5MXJtOTIwMC1ydGMiIG9yICJhdG1lbCxh
dDkxc2FtOXg1LXJ0YyINCj4+ICstIGNvbXBhdGlibGU6IHNob3VsZCBiZTogImF0bWVsLGF0OTFy
bTkyMDAtcnRjIiwgImF0bWVsLGF0OTFzYW05eDUtcnRjIiBvcg0KPj4gKyAgIm1pY3JvY2hpcCxz
YW05eDYwLXJ0YyINCj4+ICAtIHJlZzogcGh5c2ljYWwgYmFzZSBhZGRyZXNzIG9mIHRoZSBjb250
cm9sbGVyIGFuZCBsZW5ndGggb2YgbWVtb3J5IG1hcHBlZA0KPj4gICAgcmVnaW9uLg0KPj4gIC0g
aW50ZXJydXB0czogcnRjIGFsYXJtL2V2ZW50IGludGVycnVwdA0KPj4gLS0NCj4+IDIuNy40DQo+
Pg0KPiANCj4gLS0NCj4gQWxleGFuZHJlIEJlbGxvbmksIEJvb3RsaW4NCj4gRW1iZWRkZWQgTGlu
dXggYW5kIEtlcm5lbCBlbmdpbmVlcmluZw0KPiBodHRwczovL2Jvb3RsaW4uY29tDQo+IA==

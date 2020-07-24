Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F4322BF10
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 09:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgGXH2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 03:28:55 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:15087 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbgGXH2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 03:28:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595575733; x=1627111733;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ItbYPIzTUu13yh+phgPg6OerWttch76Z9MoU2aQdJz0=;
  b=AEzchMwTrCUxpyn/3UX652l/7koBupQexUdw8FaU1zflA9fNSVIlQoXQ
   tvVF39CGxSW6ONitBLWyAhh6wYQC4tAh+OMIl/4zAwUDhMqcLtFAlmNIq
   wyGh5O1pIJAnRSTNxIVVUQQnHNe0yywBg619Mjf7oCFgqawDuyhL9uqil
   1wRQ/MfPNE/yqTB6jPhHB93bN89W5P7pfuUNrXgob5DVs4p02SgtpxN/Q
   OSJITxXty19hf5Jk9RxOHjH91zWgYwLYV6tvKIGr0L3vAoqjRL7jz5/S1
   bm/Qbv5VS16XAA5D6xrspojwZMAfQoi/Ei6e4+DvcKQO9L78RwWfRLFCw
   g==;
IronPort-SDR: nuAOv8QwVt6Z8qEIWIxUywitdv2Z6CEBgYm1tByNTx3/BriG6na3UfueE5dbNKjQnxOjM7o6kI
 3hxt2AWhle6w9sww/Vgmc/A5c3SjRvvc4f26XLwzwpi0JCQGSAKqjTHF0Jw9txBmMLGi2IZ801
 g4tutu8HbbzKxZfgWZfBOR0jSAXedgZuvBzozo9BNnkI6aY45wAx1xGpNlwwtYOA8T5yYICpop
 4TNUQfiZSuMyNCsCk6lXUbnfYS02UgqycISMyE+TTXw+ypG9dN1PwpC3qZZe5Fy1VP6CHNbBIj
 InU=
X-IronPort-AV: E=Sophos;i="5.75,389,1589266800"; 
   d="scan'208";a="81144471"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jul 2020 00:28:52 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 00:28:45 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Fri, 24 Jul 2020 00:28:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HfVnxUZgBFWY8OdcZUb5HoK5t8r7FhDjOYlrQ0Sv11nJAPSQU9dNpfbCl5jHpOwp40+9v61OZgi2eb34/8SCwThWvjC43YT/noy1Q8nwAm4B6jzaOo1QX749tM1h0LMDQ/Nx3wqJkEJ4G4HHYo0B1QICBh72vCfdlihByCJmC02ouZ4AMnr5/VA9fgzADgxq0R+7knOgHPSqiM0sJYFybqOY2QSXIqKTXuSc3YLu2RIqQFJVmNlqw66z6oK2H5vq1icibCFna64IlOMjVlY3uwcTr7rJjqzQNBcPJ13S3XUHv1CxQalBjjenJvt8bzt5oHkg7KNdPWto4UrbJ0CObA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ItbYPIzTUu13yh+phgPg6OerWttch76Z9MoU2aQdJz0=;
 b=K5YBm77D4YQUtpDsQ+MdsBEzjIWSKrbb8WpjxL/sDFXcZ2JWWaKoETGkxfMAPHBeROrsIpPGNKvGt5DW1lJDua4neDYT+Nc6+8lSwhbydfKcGPLXie4Ct+SsgVrzsMTCs0ADN/YxhxW1nSaSs+pH3ne41X3HoWiuneWG0UgLL295qBlWBOjnclih30TpesIbusDL6+YI584n5W00CWOXbuNtYDEOadJk1mu5KiW8rYYw8g8OiUugTba+lLNYDD2eSNHyXtf2RJ4jCgAtf0OWT5GIU648F0rANWaKI0H5GB2puq8iOVGbee1qzehh5WoMHiPgh9ydQIDQZw2F+a+j0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ItbYPIzTUu13yh+phgPg6OerWttch76Z9MoU2aQdJz0=;
 b=unX9TgIsdJBx/FqM6wfG2xlwEe2HGuY2mAdSthrWPrH0rhGwiIp6Al1a6Q6GNuxh73a7fY+0aD9h8XhdwEFllYTcczXsTOeHqxaUTfqRvzv5K0VA1jnN3ujLnQ2im9IOED/O1f0FMiI3ib+NM77YHitG+SQdpOLeyx/3zsefcME=
Received: from SN6PR11MB3422.namprd11.prod.outlook.com (2603:10b6:805:da::18)
 by SN6PR11MB3021.namprd11.prod.outlook.com (2603:10b6:805:d1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Fri, 24 Jul
 2020 07:28:39 +0000
Received: from SN6PR11MB3422.namprd11.prod.outlook.com
 ([fe80::8964:f2f1:afb8:27f7]) by SN6PR11MB3422.namprd11.prod.outlook.com
 ([fe80::8964:f2f1:afb8:27f7%6]) with mapi id 15.20.3216.020; Fri, 24 Jul 2020
 07:28:39 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <f.fainelli@gmail.com>, <Codrin.Ciubotariu@microchip.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <andrew@lunn.ch>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <Ludovic.Desroches@microchip.com>
Subject: Re: [PATCH net-next v2 3/7] net: macb: parse PHY nodes found under an
 MDIO node
Thread-Topic: [PATCH net-next v2 3/7] net: macb: parse PHY nodes found under
 an MDIO node
Thread-Index: AQHWYYwMmD+BfB7F50+r6VDdk0f0lA==
Date:   Fri, 24 Jul 2020 07:28:39 +0000
Message-ID: <c3946f5b-d0ef-b64f-6882-9d44751a983b@microchip.com>
References: <20200721171316.1427582-1-codrin.ciubotariu@microchip.com>
 <20200721171316.1427582-4-codrin.ciubotariu@microchip.com>
 <460e5f3d-f3a0-154e-d617-d1536c96e390@gmail.com>
In-Reply-To: <460e5f3d-f3a0-154e-d617-d1536c96e390@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [82.137.16.151]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 432a70c6-70a8-406f-f484-08d82fa32f81
x-ms-traffictypediagnostic: SN6PR11MB3021:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB302176901E60734734BAA88987770@SN6PR11MB3021.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ykFFsuL0/Zb0kc7vGJmuD0TiOI/b6Eyk8isCURwjOW1rCJXrdo93VvRfBeldEPzI9sO6swcnyMTTz1q4kbo1ojNyqYhNPERZna+tBw0gvd05W0m9zIrDVhNd/cAev2Gz2I9AUehfIoQth/Wh8KfN3SdVY4xXpSNdCF5ndHeF31j97sGDsWDwEfbIzRPL5VPKwIPytC6IyaejLbOOHeKNpjiK2ZaP5bto65jIUXlAg+N/jR58qyRtS27L38IpXwklEtHRxSVI9XHud6iuBIIgw02OetAlHchDDMVxZiqtSJH6p1ot+H5EL4nqGOtPcka8ffunSHFwnKicG4LIdV0ef1DpM/j5NHDhj9AI95dlfB6v1BHOgkPBg/MpgZ+BYgmz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3422.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(396003)(376002)(39860400002)(366004)(54906003)(110136005)(31686004)(26005)(53546011)(107886003)(7416002)(6506007)(2906002)(5660300002)(36756003)(4326008)(66476007)(478600001)(71200400001)(8936002)(31696002)(186003)(86362001)(76116006)(64756008)(66946007)(316002)(6512007)(66446008)(6486002)(2616005)(66556008)(8676002)(91956017)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Uybk//gQSUyAwgGDWYZv27KQB2BtKPiYYQeexG7Pc0/va04VvLAQlmuRKlUrm3kEX+VMYjEFon9tXQOHF+ksXM399efUkVb8+z1wvPkQC8M/hDdfkC4WriMMGRmPSqPgQ5IFM7MUW4P2J8TJ6ba+WDaL6Hs8WaZpdSAy89VGw3vj2L2tnyv0TOsea0lHjkBalsIJ858JJuPuKtEWN2N4RGXsdjJjCxo5ESZ0c3FtWrKRy/v6ySl5bLadwNjAobCpokEMUJXiS03bUmllhijANRUcwz6ao2J3exJUAP/m26xw2DI9LMCiaYqevgb8AM/LqUHbX4S0qS2RfZG8tkWtYp2zOiwtXgcmdYfkHQcBhWtgR17iqhsigT7EYjAMoM/p6UFOTdfborYWzPK1jNNwd3GQLrFb0bZRH48tfKlZtRMdxkMBxWRwJdo5r7ZvyS1eukHbn5fXrtFFPoeUDervaNEQy2lxRQcfGyu7kA7B6Hg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <537F9F333B85FF4C91A3EE1A831CDD77@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3422.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 432a70c6-70a8-406f-f484-08d82fa32f81
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2020 07:28:39.4186
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1FWQ5kqU0UJIN7aV6DASgInjT/+Z1vN7DcdcQqn5eGBKua89aoS3H4wTBKeoXtsZNaQiRWYjN3bn98FRSDfSDkDCa57p1ktFxTz1Yvo2Y+o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3021
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIzLjA3LjIwMjAgMjE6NTksIEZsb3JpYW4gRmFpbmVsbGkgd3JvdGU6DQo+IEVYVEVS
TkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3Mg
eW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gNy8yMS8yMCAxMDoxMyBBTSwg
Q29kcmluIENpdWJvdGFyaXUgd3JvdGU6DQo+PiBUaGUgTUFDQiBlbWJlZHMgYW4gTURJTyBidXMg
Y29udHJvbGxlci4gRm9yIHRoaXMgcmVhc29uLCB0aGUgUEhZIG5vZGVzDQo+PiB3ZXJlIHJlcHJl
c2VudGVkIGFzIHN1Yi1ub2RlcyBpbiB0aGUgTUFDQiBub2RlLiBHZW5lcmFsbHksIHRoZQ0KPj4g
RXRoZXJuZXQgY29udHJvbGxlciBpcyBkaWZmZXJlbnQgdGhhbiB0aGUgTURJTyBjb250cm9sbGVy
LCBzbyB0aGUgUEhZcw0KPj4gYXJlIHByb2JlZCBieSBhIHNlcGFyYXRlIE1ESU8gZHJpdmVyLiBT
aW5jZSBhZGRpbmcgdGhlIFBIWSBub2RlcyBkaXJlY3RseQ0KPj4gdW5kZXIgdGhlIEVUSCBub2Rl
IGJlY2FtZSBkZXByZWNhdGVkLCB3ZSBhZGp1c3QgdGhlIE1BQ0IgZHJpdmVyIHRvIGxvb2sNCj4+
IGZvciBhbiBNRElPIG5vZGUgYW5kIHJlZ2lzdGVyIHRoZSBzdWJub2RlIE1ESU8gZGV2aWNlcy4N
Cj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBDb2RyaW4gQ2l1Ym90YXJpdSA8Y29kcmluLmNpdWJvdGFy
aXVAbWljcm9jaGlwLmNvbT4NCj4+IC0tLQ0KPj4NCj4+IENoYW5nZXMgaW4gdjI6DQo+PiAgLSBy
ZWFkZGVkIG5ld2xpbmUgcmVtb3ZlZCBieSBtaXN0YWtlOw0KPj4NCj4+ICBkcml2ZXJzL25ldC9l
dGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jIHwgMTAgKysrKysrKysrKw0KPj4gIDEgZmlsZSBj
aGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRl
bmNlL21hY2JfbWFpbi5jDQo+PiBpbmRleCA4OWZlN2FmNWU0MDguLmIyNWM2NGI0NTE0OCAxMDA2
NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4+
ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4+IEBAIC03
NDAsMTAgKzc0MCwyMCBAQCBzdGF0aWMgaW50IG1hY2JfbWlpX3Byb2JlKHN0cnVjdCBuZXRfZGV2
aWNlICpkZXYpDQo+PiAgc3RhdGljIGludCBtYWNiX21kaW9idXNfcmVnaXN0ZXIoc3RydWN0IG1h
Y2IgKmJwKQ0KPj4gIHsNCj4+ICAgICAgIHN0cnVjdCBkZXZpY2Vfbm9kZSAqY2hpbGQsICpucCA9
IGJwLT5wZGV2LT5kZXYub2Zfbm9kZTsNCj4+ICsgICAgIHN0cnVjdCBkZXZpY2Vfbm9kZSAqbWRp
b19ub2RlOw0KPj4gKyAgICAgaW50IHJldDsNCj4+DQo+PiAgICAgICBpZiAob2ZfcGh5X2lzX2Zp
eGVkX2xpbmsobnApKQ0KPj4gICAgICAgICAgICAgICByZXR1cm4gbWRpb2J1c19yZWdpc3Rlcihi
cC0+bWlpX2J1cyk7DQo+IA0KPiBEb2VzIG5vdCB0aGlzIG5lZWQgY2hhbmdpbmcgYXMgd2VsbD8g
Q29uc2lkZXIgdGhlIHVzZSBjYXNlIG9mIGhhdmluZw0KPiB5b3VyIE1BQ0IgRXRoZXJuZXQgbm9k
ZSBoYXZlIGEgZml4ZWQtbGluayBwcm9wZXJ0eSB0byBkZXNjcmliZSBob3cgaXQNCj4gY29ubmVj
dHMgdG8gYSBzd2l0Y2gsIGFuZCB5b3VyIE1BQ0IgTURJTyBjb250cm9sbGVyLCBleHByZXNzZWQg
YXMgYQ0KPiBzdWItbm9kZSwgZGVzY3JpYmluZyB0aGUgTURJTyBhdHRhY2hlZCBzd2l0Y2ggaXQg
Y29ubmVjdHMgdG8uDQoNCkp1c3QgYXNraW5nLCBkb2VzIHRoaXMgd29ydGggaGF2aW5nL2NoYW5n
aW5nIGl0IGFzIGxvbmcgYXMgdGhlcmUgaXMgbm8gaW4NCmtlcm5lbCBib2FyZC9jb25maWd1cmF0
aW9uIHRoYXQgY291bGQgYmVuZWZpdCBvZmY/DQoNClRoYW5rIHlvdSwNCkNsYXVkaXUgQmV6bmVh
DQoNCj4gDQo+Pg0KPj4gKyAgICAgLyogaWYgYW4gTURJTyBub2RlIGlzIHByZXNlbnQsIGl0IHNo
b3VsZCBjb250YWluIHRoZSBQSFkgbm9kZXMgKi8NCj4+ICsgICAgIG1kaW9fbm9kZSA9IG9mX2dl
dF9jaGlsZF9ieV9uYW1lKG5wLCAibWRpbyIpOw0KPj4gKyAgICAgaWYgKG1kaW9fbm9kZSkgew0K
Pj4gKyAgICAgICAgICAgICByZXQgPSBvZl9tZGlvYnVzX3JlZ2lzdGVyKGJwLT5taWlfYnVzLCBt
ZGlvX25vZGUpOw0KPj4gKyAgICAgICAgICAgICBvZl9ub2RlX3B1dChtZGlvX25vZGUpOw0KPj4g
KyAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KPj4gKyAgICAgfQ0KPj4gKw0KPj4gICAgICAgLyog
T25seSBjcmVhdGUgdGhlIFBIWSBmcm9tIHRoZSBkZXZpY2UgdHJlZSBpZiBhdCBsZWFzdCBvbmUg
UEhZIGlzDQo+PiAgICAgICAgKiBkZXNjcmliZWQuIE90aGVyd2lzZSBzY2FuIHRoZSBlbnRpcmUg
TURJTyBidXMuIFdlIGRvIHRoaXMgdG8gc3VwcG9ydA0KPj4gICAgICAgICogb2xkIGRldmljZSB0
cmVlIHRoYXQgZGlkIG5vdCBmb2xsb3cgdGhlIGJlc3QgcHJhY3RpY2VzIGFuZCBkaWQgbm90DQo+
Pg0KPiANCj4gDQo+IC0tDQo+IEZsb3JpYW4NCj4g

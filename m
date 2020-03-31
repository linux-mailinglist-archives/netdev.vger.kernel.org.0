Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC106198EDF
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 10:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729955AbgCaIyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 04:54:16 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:6476 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgCaIyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 04:54:16 -0400
IronPort-SDR: K0nYC8Oqryu4asw6qYANaXgMrArzvM9KdYdjuVGBYKzs5+cXAyc0DsZb9gDKK3j6o0WX5S/rl7
 EwWhDYHGvDZM8TFzRimcn2XHZGt64a+sBhoRUPOKv3z5zfZP3AGx9Zynh+Vr5Egs6TmXb7mwsZ
 ocNLrftW+GbdFPbd1G1ah7nvdH1ERo7yhOUo1/2r2ucVnf+lPO1Z7lNQbwyx2pbuc6kMkQu+Au
 IN9X/QlPTDuzpSs6RMiGLs6XL6OswGsH0InENqWKT8iydOX++fxruP3s4CEEZGNw3isHC9PSpV
 r5I=
X-IronPort-AV: E=Sophos;i="5.72,327,1580799600"; 
   d="scan'208";a="71802632"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Mar 2020 01:54:15 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 31 Mar 2020 01:54:14 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Tue, 31 Mar 2020 01:54:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k0PRi0Jp5OTi0hW7a5DuwUhMdHMY3zernt0nIHkRIbLoeZ2iVYS1mXN9Tijh/tavLOujNhbAeLU2lKpdtyBF2tbr8GOf1iiOOe44opJDV8Kgo7QvRQqA5pQH9+DRQrVadvcUqXdj+G/bqn8aHmZcbCKM0y/UTFtZWY4InqghJmoduQhw/mrUvRCyNIneF79dXjyfZkAKiyy4P5XA9KrCyv2B5zCc79w2icSA2J8KYPmIvlfJBqMfzuRMpIDn8hg0bNTpB78apgPSRObYKcqr/W4SO7wWcVZ+yPKyORLKdJ/V90vcPP08/lweK9tdcHoYy17laaFvhf17tX4ZE/jv1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X1ceVgdMITrO0I0tm8vFagRsqb+GulFLv6TOdS/q7ng=;
 b=MYmmwWraXEiffR84OA+jely5Kb8ldOkH3zNSRQwoAqCg7Slb0uTWs4wnp6z4BkQJR7j1Mzku42CUi/ryRqdggeVf/95YyJbU/RxFWDwkGmg8Kr30iDzEUL9KAgMFTDI39gp89LGyzS0nBaHMxVuk+dw+3+CBzv5GypPl53SiJTys+gY1yPOf2wBnDyNdgPIIBsorzDqxdCNIFDkH6zJm4ujpsSLXgykcxl1GJ6rbHj4tOaN76Mzw/TquVl4VwqRZdGJgC3hemWtAe3cvSXjWhWGZhD1luuQhFod1eqD+TZ88Fw6glAoSgacNaDBWv/7N4U+W0d5YwowZUXy0xL8Sxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X1ceVgdMITrO0I0tm8vFagRsqb+GulFLv6TOdS/q7ng=;
 b=aZ0tKoyrf50SVO48uLRC6no+WiDTZ5FLRVjDB6HuzcpX9r4wRs+AbPfK2pX8N0LdWxq6Mq1gd/u8ImRudn2eJTdmhvHflptysflRCoxwbOo6OcDtoIPTGP0vMvrGowKU5mHidE2RVzYny52+PgTygbAKe7mJqkSwLMDJopvq0v8=
Received: from BY5PR11MB4497.namprd11.prod.outlook.com (2603:10b6:a03:1cc::28)
 by BY5PR11MB3974.namprd11.prod.outlook.com (2603:10b6:a03:183::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.18; Tue, 31 Mar
 2020 08:54:13 +0000
Received: from BY5PR11MB4497.namprd11.prod.outlook.com
 ([fe80::114b:fdb3:5bf5:2694]) by BY5PR11MB4497.namprd11.prod.outlook.com
 ([fe80::114b:fdb3:5bf5:2694%5]) with mapi id 15.20.2856.019; Tue, 31 Mar 2020
 08:54:13 +0000
From:   <Codrin.Ciubotariu@microchip.com>
To:     <f.fainelli@gmail.com>, <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>
Subject: Re: [PATCH] net: mdio: of: Do not treat fixed-link as PHY
Thread-Topic: [PATCH] net: mdio: of: Do not treat fixed-link as PHY
Thread-Index: AQHWBqykuJ0v/jHHYESe6xUz4L35r6hhU7EAgAAOiACAAQRNgA==
Date:   Tue, 31 Mar 2020 08:54:13 +0000
Message-ID: <bd9f2507-958e-50bf-2b84-c21adf6ab588@microchip.com>
References: <20200330160136.23018-1-codrin.ciubotariu@microchip.com>
 <20200330163028.GE23477@lunn.ch>
 <9bbbe2ed-985b-49e7-cc16-8b6bae3e8e8e@gmail.com>
In-Reply-To: <9bbbe2ed-985b-49e7-cc16-8b6bae3e8e8e@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Codrin.Ciubotariu@microchip.com; 
x-originating-ip: [86.121.14.3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1beed840-82ff-4541-2244-08d7d55115eb
x-ms-traffictypediagnostic: BY5PR11MB3974:
x-microsoft-antispam-prvs: <BY5PR11MB397432B9BC346BBA5E74F933E7C80@BY5PR11MB3974.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0359162B6D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4497.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(396003)(39860400002)(376002)(346002)(366004)(136003)(2616005)(66476007)(66446008)(8676002)(81156014)(76116006)(26005)(6486002)(66556008)(186003)(36756003)(66946007)(5660300002)(478600001)(91956017)(8936002)(81166006)(316002)(64756008)(6506007)(6512007)(54906003)(4326008)(2906002)(71200400001)(31696002)(53546011)(86362001)(31686004)(110136005);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H1qcVWcIqTJ7v9nwln8BQlqDKna4MiqIXnlrrkhR7Zd9oReW64iiGIoQCfiR/eQQSgoonRYy3IF8X84hn3SabGw2Ufx40dkX3eAstswxRZidFF1rAScRdYXvZJb48eJfuMZ1sESXiPBUZwJpMs3cXtx+CH8ZsGqE8wasjterSgvdzdEMIuh1ydls3u+YGX4JU+TSq5pv7hNdDGnxl6iY8vxo+d0wk33vkGZrmbo7WXY1VxIepsCUvHk3pk47mD0b1JfkmbxhSw8rsb6nkFqi3Sjyrbd78GclKXeUa1No8z+NvHL5JFkCXDSMtYxiiT9ga0nACiLRmb/8utUuGXuguon0NLLYTOBSHLbSRt30jP5vUEl+4yBGYIqIUYwElG/T/oi8d00WBrQ+ndKt9ez3zQNX0AzJZhVyYd+ZjHSxcK36ccUy4Gdj0LY9Clg/DYB2
x-ms-exchange-antispam-messagedata: vaWS7ARMVmPgDWguEOY9qOfYBIIl3YXe5mGoFJOsDsB45Fm1IIRgnqx9PpVDb7AjvrBuGnbS2p38FFVOE9mZwvbhEy0GtJkI7vwl6dplQeRomeG4u5g6zeLdE/02Iec/7Uasxber99HepHWnB9GjbQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA3EA2C27CE71A4586B4DD06C5808F69@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1beed840-82ff-4541-2244-08d7d55115eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2020 08:54:13.1883
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YwNo+KauEBLi/A6Zn2DPI4uDCRleBfdwt3j/p7U6lt7eeGzBXuw5X0pJ1BvTs3VeG1yhfS04EgSarvsXKR7qsKdPrzcT1A5TIVngi2oDhg0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3974
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMzAuMDMuMjAyMCAyMDoyMiwgRmxvcmlhbiBGYWluZWxsaSB3cm90ZToNCj4gRVhURVJOQUwg
RU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Ug
a25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiAzLzMwLzIwMjAgOTozMCBBTSwgQW5k
cmV3IEx1bm4gd3JvdGU6DQo+PiBPbiBNb24sIE1hciAzMCwgMjAyMCBhdCAwNzowMTozNlBNICsw
MzAwLCBDb2RyaW4gQ2l1Ym90YXJpdSB3cm90ZToNCj4+PiBTb21lIGV0aGVybmV0IGNvbnRyb2xs
ZXJzLCBzdWNoIGFzIGNhZGVuY2UncyBtYWNiLCBoYXZlIGFuIGVtYmVkZGVkIE1ESU8uDQo+Pj4g
Rm9yIHRoaXMgcmVhc29uLCB0aGUgZXRoZXJuZXQgUEhZIG5vZGVzIGFyZSBub3QgdW5kZXIgYW4g
TURJTyBidXMsIGJ1dA0KPj4+IGRpcmVjdGx5IHVuZGVyIHRoZSBldGhlcm5ldCBub2RlLiBTaW5j
ZSB0aGVzZSBkcml2ZXJzIG1pZ2h0IHVzZQ0KPj4+IG9mX21kaW9idXNfY2hpbGRfaXNfcGh5KCks
IHdlIHNob3VsZCBmaXggdGhpcyBmdW5jdGlvbiBieSByZXR1cm5pbmcgZmFsc2UNCj4+PiBpZiBh
IGZpeGVkLWxpbmsgaXMgZm91bmQuDQo+Pg0KPj4gU28gaSBhc3N1bWUgdGhlIHByb2JsZW0gb2Nj
dXJzIGhlcmU6DQo+Pg0KPj4gc3RhdGljIGludCBtYWNiX21kaW9idXNfcmVnaXN0ZXIoc3RydWN0
IG1hY2IgKmJwKQ0KPj4gew0KPj4gICAgICAgICAgc3RydWN0IGRldmljZV9ub2RlICpjaGlsZCwg
Km5wID0gYnAtPnBkZXYtPmRldi5vZl9ub2RlOw0KPj4NCj4+ICAgICAgICAgIC8qIE9ubHkgY3Jl
YXRlIHRoZSBQSFkgZnJvbSB0aGUgZGV2aWNlIHRyZWUgaWYgYXQgbGVhc3Qgb25lIFBIWSBpcw0K
Pj4gICAgICAgICAgICogZGVzY3JpYmVkLiBPdGhlcndpc2Ugc2NhbiB0aGUgZW50aXJlIE1ESU8g
YnVzLiBXZSBkbyB0aGlzIHRvIHN1cHBvcnQNCj4+ICAgICAgICAgICAqIG9sZCBkZXZpY2UgdHJl
ZSB0aGF0IGRpZCBub3QgZm9sbG93IHRoZSBiZXN0IHByYWN0aWNlcyBhbmQgZGlkIG5vdA0KPj4g
ICAgICAgICAgICogZGVzY3JpYmUgdGhlaXIgbmV0d29yayBQSFlzLg0KPj4gICAgICAgICAgICov
DQo+PiAgICAgICAgICBmb3JfZWFjaF9hdmFpbGFibGVfY2hpbGRfb2Zfbm9kZShucCwgY2hpbGQp
DQo+PiAgICAgICAgICAgICAgICAgIGlmIChvZl9tZGlvYnVzX2NoaWxkX2lzX3BoeShjaGlsZCkp
IHsNCj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAvKiBUaGUgbG9vcCBpbmNyZW1lbnRzIHRo
ZSBjaGlsZCByZWZjb3VudCwNCj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgKiBkZWNyZW1l
bnQgaXQgYmVmb3JlIHJldHVybmluZy4NCj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgKi8N
Cj4+ICAgICAgICAgICAgICAgICAgICAgICAgICBvZl9ub2RlX3B1dChjaGlsZCk7DQo+Pg0KPj4g
ICAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiBvZl9tZGlvYnVzX3JlZ2lzdGVyKGJwLT5t
aWlfYnVzLCBucCk7DQo+PiAgICAgICAgICAgICAgICAgIH0NCj4+DQo+PiAgICAgICAgICByZXR1
cm4gbWRpb2J1c19yZWdpc3RlcihicC0+bWlpX2J1cyk7DQo+PiB9DQo+Pg0KPj4gSSB0aGluayBh
IGJldHRlciBzb2x1dGlvbiBpcw0KPj4NCj4+ICAgICAgICAgIGZvcl9lYWNoX2F2YWlsYWJsZV9j
aGlsZF9vZl9ub2RlKG5wLCBjaGlsZCkNCj4+ICsgICAgICAgICAgICAgaWYgKG9mX3BoeV9pc19m
aXhlZF9saW5rKGNoaWxkKQ0KPj4gKyAgICAgICAgICAgICAgICBjb250aW51ZTsNCj4+ICAgICAg
ICAgICAgICAgICAgaWYgKG9mX21kaW9idXNfY2hpbGRfaXNfcGh5KGNoaWxkKSkgew0KPj4gICAg
ICAgICAgICAgICAgICAgICAgICAgIC8qIFRoZSBsb29wIGluY3JlbWVudHMgdGhlIGNoaWxkIHJl
ZmNvdW50LA0KPj4gICAgICAgICAgICAgICAgICAgICAgICAgICAqIGRlY3JlbWVudCBpdCBiZWZv
cmUgcmV0dXJuaW5nLg0KPj4gICAgICAgICAgICAgICAgICAgICAgICAgICAqLw0KPj4gICAgICAg
ICAgICAgICAgICAgICAgICAgIG9mX25vZGVfcHV0KGNoaWxkKTsNCj4+DQo+PiAgICAgICAgICAg
ICAgICAgICAgICAgICAgcmV0dXJuIG9mX21kaW9idXNfcmVnaXN0ZXIoYnAtPm1paV9idXMsIG5w
KTsNCj4+ICAgICAgICAgICAgICAgICAgfQ0KPj4NCj4+ICAgICAgICAgIHJldHVybiBtZGlvYnVz
X3JlZ2lzdGVyKGJwLT5taWlfYnVzKTsNCj4+IH0NCj4+DQo+PiBUaGlzIHByb2JsZW0gaXMgb25s
eSBhbiBpc3N1ZSBmb3IgbWFjYiwgc28ga2VlcCB0aGUgZml4IGxvY2FsIHRvIG1hY2IuDQo+IA0K
PiBBZ3JlZSwgdGhlcmUgaXMgbm8gcmVhc29uIGZvciBvZl9tZGlvYnVzX2NoaWxkX2lzX3BoeSgp
IHRvIGJlIGNoZWNraW5nDQo+IGZvciBhIGZpeGVkLWxpbmsuIElmIHlvdSBzdWJtaXQgdGhpcyBm
b3JtYWxseToNCj4gDQo+IEFja2VkLWJ5OiBGbG9yaWFuIEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdt
YWlsLmNvbT4NCg0KVGhhbmtzIGd1eXMuIEkgdGhvdWdodCB0aGVyZSBtaWdodCBiZSBvdGhlciBj
b250cm9sbGVycyB0aGF0IGhhdmUgdGhlIA0KUEhZIG5vZGVzIGluc2lkZSB0aGUgZXRoZXJuZXQg
bm9kZS4gSWYgbm90LCBJIGd1ZXNzIHRoYXQgDQpvZl9tZGlvYnVzX2NoaWxkX2lzX3BoeSgpIGNh
biBiZSByZXN0cmljdGVkIHRvIGJlIGNhbGxlZCBvbmx5IGlmIHRoZSANCnBhc3NlZCBkZXZpY2Vf
bm9kZSBwb2ludHMgdG8gYW4gTURJTyBub2RlLg0KTW92aW5nIHRoZSBmaXggdG8gbWFjYiwgSSB0
aGluayB0aGF0IG9mX3BoeV9pc19maXhlZF9saW5rKCkgbmVlZHMgYSANCmRldmljZV9ub2RlIHRv
IHRoZSBldGhlcm5ldCBub2RlLCBzaW5jZSBpdCBhbHNvIGhhcyB0byBkZWFsIHdpdGggdGhlIA0K
bGVnYWN5IGNhc2UgaW4gd2hpY2ggZml4ZWQtbGluayBpcyBhIHByb3BlcnR5LCBzbyBpdCB3b3Vs
ZCBsb29rIGxpa2UgDQpzb21ldGhpbmcgbGlrZSB0aGlzOg0KICAgICAgICAgc3RydWN0IGRldmlj
ZV9ub2RlICpjaGlsZCwgKm5wID0gYnAtPnBkZXYtPmRldi5vZl9ub2RlOw0KDQorICAgICAgIGlm
IChvZl9waHlfaXNfZml4ZWRfbGluayhucCkpDQorICAgICAgICAgICAgICAgcmV0dXJuIG1kaW9i
dXNfcmVnaXN0ZXIoYnAtPm1paV9idXMpOw0KKw0KICAgICAgICAgLyogT25seSBjcmVhdGUgdGhl
IFBIWSBmcm9tIHRoZSBkZXZpY2UgdHJlZSBpZiBhdCBsZWFzdCBvbmUgUEhZIGlzDQoNCkkgd2ls
bCBzZW5kIGFub3RoZXIgcGF0Y2ggc2hvcnRseS4NCg0KVGhhbmtzIGFuZCBiZXN0IHJlZ2FyZHMs
DQpDb2RyaW4=

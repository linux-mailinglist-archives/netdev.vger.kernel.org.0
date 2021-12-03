Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D74466F2C
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 02:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377966AbhLCBlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 20:41:40 -0500
Received: from mswedge1.sunplus.com ([60.248.182.113]:45288 "EHLO
        mg.sunplus.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1377962AbhLCBlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 20:41:31 -0500
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.112
        by mg01.sunplus.com with MailGates ESMTP Server V5.0(5128:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Fri, 03 Dec 2021 09:36:40 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx02.sunplus.com.tw (172.17.9.112) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Fri, 3 Dec 2021 09:36:41 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Fri, 3 Dec 2021
 09:36:41 +0800
From:   =?utf-8?B?V2VsbHMgTHUg5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        =?utf-8?B?VmluY2VudCBTaGloIOaWvemMlem0uw==?= 
        <vincent.shih@sunplus.com>
Subject: RE: [PATCH net-next v3 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Thread-Topic: [PATCH net-next v3 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Thread-Index: AQHX5dF9eGPWQxkNKU64ogPFWvAIaqwcdcyAgAE+n/CAAPQwgIAA4eHw//+CcACAAPOLMA==
Date:   Fri, 3 Dec 2021 01:36:41 +0000
Message-ID: <ad04e59777694bbcbcf52f518a2c16a0@sphcmbx02.sunplus.com.tw>
References: <1638266572-5831-1-git-send-email-wellslutw@gmail.com>
 <1638266572-5831-3-git-send-email-wellslutw@gmail.com>
 <YabsT0/dASvYUH2p@lunn.ch>
 <cf60c230950747ec918acfc6dda595d6@sphcmbx02.sunplus.com.tw>
 <YajEbXtBwlDL4gOL@lunn.ch>
 <2fded2fc3a1344d0882ae2f186257911@sphcmbx02.sunplus.com.tw>
 <YakYlHzvlAI+1at+@lunn.ch>
In-Reply-To: <YakYlHzvlAI+1at+@lunn.ch>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.25.108.39]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpUaGFuayB5b3UgZm9yIGV4cGxhbmF0aW9uLg0KDQoNCkJlc3QgcmVnYXJk
cywNCldlbGxzIEx1DQoNCg0KPiA+IEhpIEFuZHJldywNCj4gPg0KPiA+IFRoYW5rIHlvdSBmb3Ig
ZXhwbGFuYXRpb24uDQo+ID4NCj4gPiBJJ2xsIGFkZCBwaHlfc3VwcG9ydF9hc3ltX3BhdXNlKCkg
YWZ0ZXIgUEhZIGNvbm5lY3RlZCBuZXh0IHBhdGNoLg0KPiA+DQo+ID4gSSBmb3VuZCBzb21lIGRy
aXZlcnMgY2FsbCBwaHlfc2V0X21heF9zcGVlZCgpIHRvIHNldCBQSFkgc3BlZWQgdG8gMTAwTQ0K
PiA+IGFmdGVyIFBIWSBjb25uZWN0ZWQuIElzIHRoYXQgbmVjZXNzYXJ5Pw0KPiANCj4gPiBGcm9t
ICdzdXBwb3J0ZWQnLCBQSFkgc3VwcG9ydHMgMTBNLzEwME0gYWxyZWFkeS4NCj4gDQo+IFlvdSBu
ZWVkIHBoeV9zZXRfbWF4X3NwZWVkKCkgd2hlbiBpdCBpcyBwb3NzaWJsZSB0byBjb25uZWN0IGEg
MTAvMTAwIE1BQyB0byBhIDFHIFBIWS4gIFlvdQ0KPiBzb21ldGltZSBkbyB0aGlzIGJlY2F1c2Ug
YSAxRyBQSFkgaXMgY2hlYXBlciB0aGFuIGEgMTAwTSBQSFkuIFVubGVzcyBsaW1pdGVkLCB0aGUg
UEhZIHdpbGwNCj4gYWR2ZXJ0aXNlIGFuZCBjb3VsZCBuZWdvdGlhdGUgYSAxRyBsaW5rLCBidXQg
dGhlIE1BQyBjb3VsZCB0aGVuIG5vdCBzdXBwb3J0IGl0LiBJZiBpdCBpcw0KPiBub3QgcGh5c2lj
YWxseSBwb3NzaWJsZSB0byBjb25uZWN0IGEgMUcgUEhZIHRvIHlvdXIgTUFDLCB5b3UgZG9uJ3Qg
bmVlZCB0byB3b3JyeS4NCj4gDQo+ID4gSSBhbHNvIGZvdW5kIHNvbWUgZHJpdmVycyBjYWxsIHBo
eV9zdGFydF9hbmVnKCkgYWZ0ZXIgUEhZIHN0YXJ0ZWQuDQo+IA0KPiBJdCBpcyBub3QgbmVlZGVk
Lg0KPiANCj4gICAgQW5kcmV3DQo=

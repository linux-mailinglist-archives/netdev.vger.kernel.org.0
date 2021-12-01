Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0691646478C
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 08:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240802AbhLAHFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 02:05:52 -0500
Received: from 113.196.136.162.ll.static.sparqnet.net ([113.196.136.162]:60406
        "EHLO mg.sunplus.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S239960AbhLAHFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 02:05:51 -0500
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.202
        by mg01.sunplus.com with MailGates ESMTP Server V5.0(5598:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Wed, 01 Dec 2021 15:02:24 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx01.sunplus.com.tw (172.17.9.202) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Wed, 1 Dec 2021 15:02:19 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Wed, 1 Dec 2021
 15:02:19 +0800
From:   =?big5?B?V2VsbHMgTHUgp2aq2sTL?= <wells.lu@sunplus.com>
To:     Andrew Lunn <andrew@lunn.ch>, Wells Lu <wellslutw@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        =?big5?B?VmluY2VudCBTaGloIKxJwEPCRQ==?= <vincent.shih@sunplus.com>
Subject: RE: [PATCH net-next v3 1/2] devicetree: bindings: net: Add bindings
 doc for Sunplus SP7021.
Thread-Topic: [PATCH net-next v3 1/2] devicetree: bindings: net: Add bindings
 doc for Sunplus SP7021.
Thread-Index: AQHX5dF96kpitI8abkuv1MQy393+pKwcW5WAgADaG8A=
Date:   Wed, 1 Dec 2021 07:02:19 +0000
Message-ID: <cafbb308e5554fa2ab5db4ffe01a777d@sphcmbx02.sunplus.com.tw>
References: <1638266572-5831-1-git-send-email-wellslutw@gmail.com>
 <1638266572-5831-2-git-send-email-wellslutw@gmail.com>
 <YabWUQdIP288U09d@lunn.ch>
In-Reply-To: <YabWUQdIP288U09d@lunn.ch>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.25.108.39]
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpUaGFuayB5b3UgdmVyeSBtdWNoIGZvciByZXZpZXcuDQoNCkknbGwgbW92
ZSBwcm9wZXJ0aWVzIG52bWVtLWNlbGxzIGFuZCBudm1lbS1jZWxsLW5hbWVzIHRvIGV0aGVybmV0
IHBvcnRzDQphbmQgY2hhbmdlIHZhbHVlIG9mIG52bWVtLWNlbGwtbmFtZXMgdG8gIm1hYy1hZGRy
ZXNzIiBuZXh0IHBhdGNoLg0KDQpJJ2xsIHJlZmVyIHRvICJudm1lbV9nZXRfbWFjX2FkZHJlc3Mo
KSIgd2hlbiBtb2RpZnlpbmcgY29kZS4NCg0KDQpCZXN0IHJlZ2FyZHMsDQpXZWxscw0KDQoNCj4g
PiArICBudm1lbS1jZWxsczoNCj4gPiArICAgIGl0ZW1zOg0KPiA+ICsgICAgICAtIGRlc2NyaXB0
aW9uOiBudm1lbSBjZWxsIGFkZHJlc3Mgb2YgTUFDIGFkZHJlc3Mgb2YgMXN0IE1BQw0KPiA+ICsg
ICAgICAtIGRlc2NyaXB0aW9uOiBudm1lbSBjZWxsIGFkZHJlc3Mgb2YgTUFDIGFkZHJlc3Mgb2Yg
Mm5kIE1BQw0KPiA+ICsNCj4gPiArICBudm1lbS1jZWxsLW5hbWVzOg0KPiA+ICsgICAgZGVzY3Jp
cHRpb246IG5hbWVzIGNvcnJlc3BvbmRpbmcgdG8gdGhlIG52bWVtIGNlbGxzIG9mIE1BQyBhZGRy
ZXNzDQo+ID4gKyAgICBpdGVtczoNCj4gPiArICAgICAgLSBjb25zdDogbWFjX2FkZHIwDQo+ID4g
KyAgICAgIC0gY29uc3Q6IG1hY19hZGRyMQ0KPiANCj4gVGhlc2UgYXJlIHBvcnQgcHJvcGVydGll
cywgc28gcHV0IHRoZW0gaW4gdGhlIHBvcnQgc2VjdGlvbi4NCj4gDQo+IEFsc28sIHRoZSBuYW1l
IHlvdSBzaG91bGQgdXNlIGlzIHdlbGwgZGVmaW5lZCwgIm1hYy1hZGRyZXNzIi4gIFNlZSBudm1l
bV9nZXRfbWFjX2FkZHJlc3MoKS4NCj4gQnV0IHlvdSB3b24ndCBiZSBhYmxlIHRvIHVzZSB0aGF0
IGhlbHBlciBiZWNhdXNlIGl0IHRha2UgZGV2LCBub3QgYW4gb2Ygbm9kZS4NCj4gDQo+IAlBbmRy
ZXcNCg==

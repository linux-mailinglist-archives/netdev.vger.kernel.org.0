Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A75D45F52A
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 20:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236315AbhKZT26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 14:28:58 -0500
Received: from 113.196.136.146.ll.static.sparqnet.net ([113.196.136.146]:56572
        "EHLO mg.sunplus.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S233715AbhKZT05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 14:26:57 -0500
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.112
        by mg02.sunplus.com with MailGates ESMTP Server V5.0(47497:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Sat, 27 Nov 2021 03:23:29 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx02.sunplus.com.tw (172.17.9.112) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Sat, 27 Nov 2021 03:13:24 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Sat, 27 Nov
 2021 03:13:24 +0800
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
Subject: RE: [PATCH v2 2/2] net: ethernet: Add driver for Sunplus SP7021
Thread-Topic: [PATCH v2 2/2] net: ethernet: Add driver for Sunplus SP7021
Thread-Index: AQHX1ttDZ0jKVsi7r0auZS2tEQF+d6wADq2AgAXn1uCADjVYcP//wFkAgAFNSvCAADlOgIAAnUMA//+c8QCAAI9HsA==
Date:   Fri, 26 Nov 2021 19:13:23 +0000
Message-ID: <b41b754050a14c598b723825ab277322@sphcmbx02.sunplus.com.tw>
References: <cover.1636620754.git.wells.lu@sunplus.com>
 <519b61af544f4c6920012d44afd35a0f8761b24f.1636620754.git.wells.lu@sunplus.com>
 <YY7/v1msiaqJF3Uy@lunn.ch>
 <7cccf9f79363416ca8115a7ed9b1b7fd@sphcmbx02.sunplus.com.tw>
 <YZ+pzFRCB0faDikb@lunn.ch>
 <6c1ce569d2dd46eba8d4b0be84d6159b@sphcmbx02.sunplus.com.tw>
 <YaDxc2+HKUYxsmX4@lunn.ch>
 <38e40bc4c0de409ca959bcb847c1fc96@sphcmbx02.sunplus.com.tw>
 <YaEiRt+vqt1Ix8xb@lunn.ch>
In-Reply-To: <YaEiRt+vqt1Ix8xb@lunn.ch>
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

SGkgQW5kcmV3LA0KDQpJIHJlYWQgc3BlY2lmaWNhdGlvbiBvZiBJQ1BsdXMgSVAxMDFHICgxME0v
MTAwTSBQSFkpLg0KQml0cyBvZiByZWdpc3RlciAwIChjb250cm9sKSBhbmQgcmVnaXN0ZXIgMSAo
c3RhdHVzKSANCmFyZSBSL1cgb3IgUk8gdHlwZS4gVGhleSB3aWxsIG5vdCBiZSBjbGVhcmVkIGFm
dGVyIA0KcmVhZC4gTm8gbWF0dGVyIGhvdyBtYW55IHRpbWVzIHRoZXkgYXJlIHJlYWQsIHRoZSAN
CnJlYWQtYmFjayB2YWx1ZSBpcyB0aGUgc2FtZS4NCg0KRm9yIGV4YW1wbGUsDQpWYWx1ZSBvZiBy
ZWdpc3RlciAwIChjb250cm9sKSBpcyAweDMxMDANClZhbHVlIG9mIHJlZ2lzdGVyIDEgKHN0YXR1
cykgaXMgMHg3ODZkIA0KDQpUaGUgcmVhZC1iYWNrIHZhbHVlcyBhcmUgYWx3YXlzIHRoZSBzYW1l
IHVubGVzcyB5b3UgDQp1bnBsdWcgdGhlIGNhYmxlLg0KDQpCZXNpZGVzLCB3ZSB1c2UgcG9sbGlu
ZyBtb2RlIChwaHlkZXYtPmlycSA9IFBIWV9QT0xMKSANClBIWSBzdGF0ZS1tYWNoaW5lIGlzIHRy
aWdnZXJlZCBieSB1c2luZyAxLUh6IHdvcmstDQpxdWV1ZSwgbm90IGludGVycnVwdC4NCg0KV2Ug
ZGlkbid0IGZpbmQgYW55IHByb2JsZW0gYWZ0ZXIgbWFueSB0ZXN0cyBhZnRlciANCnVzaW5nICdm
b3JjZScgbW9kZS4NCg0KQ2FuIHdlIGdvIHdpdGggdGhpcyBhcHByb2FjaD8NCg0KDQpCZXN0IHJl
Z2FyZHMsDQpXZWxscw0KDQoNCj4gPiBIaSBBbmRyZXcsDQo+ID4NCj4gPg0KPiA+IEZyb20gZGF0
YSBwcm92aWRlZCBieSBBU0lDIGVuZ2luZWVyLCBNQUMgb2YgU1A3MDIxIG9ubHkgcmVhZHMgdGhl
IDQNCj4gPiByZWdpc3RlcnMgb2YgUEhZOg0KPiA+IDA6IENvbnRyb2wgcmVnaXN0ZXINCj4gPiAx
OiBTdGF0dXMgcmVnaXN0ZXINCj4gDQo+IFRoaXMgaXMgdGhlIHJlZ2lzdGVyIHdoaWNoIGhhcyBs
YXRjaGluZyBvZiB0aGUgbGluayBzdGF0dXMuIGdlbnBoeV91cGRhdGVfbGluaygpIGV4cGVjdHMN
Cj4gdGhpcyBsYXRjaGluZyBiZWhhdmlvdXIsIGFuZCBpZiB0aGUgaGFyZHdhcmUgcmVhZHMgdGhl
IHJlZ2lzdGVyLCB0aGF0IGJlaGF2aW91ciBpcyBub3QNCj4gZ29pbmcgdG8gaGFwcGVuLg0KPiAN
Cj4gCUFuZHJldw0K

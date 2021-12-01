Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426C046449B
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 02:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345580AbhLABp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 20:45:56 -0500
Received: from 113.196.136.146.ll.static.sparqnet.net ([113.196.136.146]:33474
        "EHLO mg.sunplus.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1345425AbhLABpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 20:45:55 -0500
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.202
        by mg02.sunplus.com with MailGates ESMTP Server V5.0(31414:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Wed, 01 Dec 2021 09:42:18 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx01.sunplus.com.tw (172.17.9.202) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Wed, 1 Dec 2021 09:42:17 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Wed, 1 Dec 2021
 09:42:18 +0800
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
Subject: RE: [PATCH net-next v3 0/2] This is a patch series for pinctrl driver
 for Sunplus SP7021 SoC.
Thread-Topic: [PATCH net-next v3 0/2] This is a patch series for pinctrl
 driver for Sunplus SP7021 SoC.
Thread-Index: AQHX5dF8/zm+xm8A+EOVliANx386Oawb/PqAgADfDSA=
Date:   Wed, 1 Dec 2021 01:42:18 +0000
Message-ID: <b488fe7aec1c4beebe8b6fd2f52aba7e@sphcmbx02.sunplus.com.tw>
References: <1638266572-5831-1-git-send-email-wellslutw@gmail.com>
 <YaaG9V2c/DL11GJC@lunn.ch>
In-Reply-To: <YaaG9V2c/DL11GJC@lunn.ch>
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

SGkgQW5kcmV3LA0KDQpTb3JyeSBmb3Igd3Jvbmcgc3ViamVjdCBsaW5lLg0KSSBkaWQgYSB3cm9u
ZyBjb3B5Lg0KDQoNCkJlc3QgcmVnYXJkcywNCldlbGxzIEx1DQoNClNtYXJ0IENvbXB1dGluZyBQ
cm9ncmFtDQpIb21lIEVudGVydGFpbm1lbnQgQnVzaW5lc3MgVW5pdA0KU3VucGx1cyBUZWNobm9s
b2d5IENvLiwgTHRkLg0KMTksIElubm92YXRpb24gMXN0IFJvYWQsDQpTY2llbmNlLWJhc2VkIElu
ZHVzdHJpYWwgUGFyaw0KSHNpbi1DaHUsIFRhaXdhbiAzMDANClRFTKFHODg2LTMtNTc4NjAwNSBl
eHQuIDI1ODANCg0KDQo+ID4gU3VucGx1cyBTUDcwMjEgaXMgYW4gQVJNIENvcnRleCBBNyAoNCBj
b3JlcykgYmFzZWQgU29DLiBJdCBpbnRlZ3JhdGVzDQo+ID4gbWFueSBwZXJpcGhlcmFscyAoZXg6
IFVBUlQsIEkyQywgU1BJLCBTRElPLCBlTU1DLCBVU0IsIFNEIGNhcmQgYW5kDQo+ID4gZXRjLikg
aW50byBhIHNpbmdsZSBjaGlwLiBJdCBpcyBkZXNpZ25lZCBmb3IgaW5kdXN0cmlhbCBjb250cm9s
DQo+ID4gYXBwbGljYXRpb25zLg0KPiANCj4gVGhlIHN1YmplY3QgbGluZSBpcyB3cm9uZyBhZ2Fp
bi4gVGhpcyBoYXMgbm90aGluZyB0byBkbyB3aXRoIGEgcGluIGNvbnRyb2xsZXIuDQo+IA0KPiAJ
QW5kcmV3DQo=

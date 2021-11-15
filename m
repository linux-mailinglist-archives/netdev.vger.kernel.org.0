Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E97450741
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236702AbhKOOmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:42:18 -0500
Received: from 113.196.136.162.ll.static.sparqnet.net ([113.196.136.162]:43452
        "EHLO mg.sunplus.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S234526AbhKOOmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 09:42:03 -0500
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.112
        by mg01.sunplus.com with MailGates ESMTP Server V5.0(29069:1:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Mon, 15 Nov 2021 22:38:55 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx02.sunplus.com.tw (172.17.9.112) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Mon, 15 Nov 2021 22:38:51 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Mon, 15 Nov
 2021 22:38:51 +0800
From:   =?big5?B?V2VsbHMgTHUgp2aq2sTL?= <wells.lu@sunplus.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        =?big5?B?VmluY2VudCBTaGloIKxJwEPCRQ==?= <vincent.shih@sunplus.com>
Subject: RE: [PATCH v2 2/2] net: ethernet: Add driver for Sunplus SP7021
Thread-Topic: [PATCH v2 2/2] net: ethernet: Add driver for Sunplus SP7021
Thread-Index: AQHX1ttDZ0jKVsi7r0auZS2tEQF+d6wAAtwAgAACQ4CABKf0kA==
Date:   Mon, 15 Nov 2021 14:38:51 +0000
Message-ID: <76a9501f4c4d46a59e489b73aa6da1f7@sphcmbx02.sunplus.com.tw>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <cover.1636620754.git.wells.lu@sunplus.com>
 <519b61af544f4c6920012d44afd35a0f8761b24f.1636620754.git.wells.lu@sunplus.com>
 <a8c656b8-a564-6aa6-7ca4-50e7a0bd65a1@gmail.com> <YY73u/c6IyQW2Sl3@lunn.ch>
In-Reply-To: <YY73u/c6IyQW2Sl3@lunn.ch>
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

SGkgQW5kcmV3LA0KDQpUaGFuayB5b3UgZm9yIHJlbWluZGluZy4NCg0KSSdsbCBkbyBteSBiZXN0
IHRvIGFkZHJlc3MgYWxsIGNvbW1lbnRzLg0KSSBmdWxseSB1bmRlcnN0YW5kIHRoYXQgYWxsIHJl
dmlld2VycycgY29tbWVudHMgc2hvdWxkIGJlIGFkZHJlc3NlZC4NCklmIEkgbG9zdCBhZGRyZXNz
aW5nIGFueSBjb21tZW50cywgcGxlYXNlIGtpbmRseSByZW1pbmQgbWUgYWdhaW4uDQoNCg0KQmVz
dCByZWdhcmRzLA0KV2VsbHMNCg0KDQo+IEhpIEZsb3JpYW4NCj4gDQo+IFlvdSBhcmUgYmFzaWNh
bGx5IHBvaW50aW5nIG91dCBpc3N1ZXMgaSBhbHJlYWR5IHBvaW50ZWQgb3V0IGluIHByZXZpb3Vz
IHZlcnNpb25zLCBhbmQgaGF2ZQ0KPiBiZWVuIGlnbm9yZWQgOi0oDQo+IA0KPiBXZWxscywgcGxl
YXNlIGxvb2sgYXQgdGhlIGNvbW1lbnRzIGkgbWFkZSBvbiB5b3VyIGVhcmxpZXIgdmVyc2lvbnMu
IFRob3NlIGNvbW1lbnRzIGFyZQ0KPiBzdGlsbCB2YWxpZCBhbmQgbmVlZCBhZGRyZXNzaW5nLg0K
PiANCj4gCSBBbmRyZXcNCg==

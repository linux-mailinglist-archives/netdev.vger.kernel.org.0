Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A09F4613C2
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 12:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhK2LW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 06:22:29 -0500
Received: from mswedge2.sunplus.com ([60.248.182.106]:39590 "EHLO
        mg.sunplus.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S242653AbhK2LUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 06:20:23 -0500
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.112
        by mg02.sunplus.com with MailGates ESMTP Server V5.0(10613:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Mon, 29 Nov 2021 19:16:33 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx02.sunplus.com.tw (172.17.9.112) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Mon, 29 Nov 2021 19:16:27 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Mon, 29 Nov
 2021 19:16:27 +0800
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
Thread-Index: AQHX1ttDZ0jKVsi7r0auZS2tEQF+d6wADq2AgAXn1uCADjVYcP//wFkAgAFNSvCAADlOgIAAnUMA//+c8QCAAI9HsP//iKYAAJWzbgA=
Date:   Mon, 29 Nov 2021 11:16:27 +0000
Message-ID: <2c1d6de8d7284a92ae0317dcfc444d79@sphcmbx02.sunplus.com.tw>
References: <cover.1636620754.git.wells.lu@sunplus.com>
 <519b61af544f4c6920012d44afd35a0f8761b24f.1636620754.git.wells.lu@sunplus.com>
 <YY7/v1msiaqJF3Uy@lunn.ch>
 <7cccf9f79363416ca8115a7ed9b1b7fd@sphcmbx02.sunplus.com.tw>
 <YZ+pzFRCB0faDikb@lunn.ch>
 <6c1ce569d2dd46eba8d4b0be84d6159b@sphcmbx02.sunplus.com.tw>
 <YaDxc2+HKUYxsmX4@lunn.ch>
 <38e40bc4c0de409ca959bcb847c1fc96@sphcmbx02.sunplus.com.tw>
 <YaEiRt+vqt1Ix8xb@lunn.ch>
 <b41b754050a14c598b723825ab277322@sphcmbx02.sunplus.com.tw>
 <YaE2WJibNCQAHBwz@lunn.ch>
In-Reply-To: <YaE2WJibNCQAHBwz@lunn.ch>
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

SGkgQW5kcmV3LA0KDQoNClRoYW5rcyBhIGxvdCBmb3IgZXhwbGFuYXRpb24hLg0KDQo+IFlvdSBu
ZWVkIHRvIG5vdCBtYWtlIGFueSByZWFkIG9uIHRoZSBQSFkgd2hpY2ggTGludXggaXMgZHJpdmlu
Zy4NCj4gQ29uZmlndXJlIHRoZSBoYXJkd2FyZSB0byByZWFkIG9uIGFuIGFkZHJlc3Mgd2hlcmUg
dGhlcmUgaXMgbm8gUEhZLg0KPg0KDQpJIHdpbGwgbW9kaWZ5IGNvZGUgdG8gc2V0IGhhcmR3YXJl
IGV4dGVybmFsIFBIWSBhZGRyZXNzIHRvIDMxLg0KSW4gbWlpX3JlYWQoKSBvciBtaWlfd3JpdGUo
KSBmdW5jdGlvbnMsIHNldCBoYXJkd2FyZSBleHRlcm5hbCBQSFkgDQphZGRyZXNzIHRvIHJlYWwg
UEhZIGFkZHJlc3MsIHNvIHRoYXQgbWlpIHJlYWQgb3Igd3JpdGUgY29tbWFuZCBjYW4gDQpiZSBz
ZW50IG91dCBieSBoYXJkd2FyZS4gU2V0IGhhcmR3YXJlIGV4dGVybmFsIFBIWSBhZGRyZXNzIGJh
Y2sgdG8gDQozMSBhZnRlciBtaWkgcmVhZCBvciB3cml0ZSBjb21tYW5kIGRvbmUuDQoNCg0KQmVz
dCByZWdhcmRzLA0KV2VsbHMgTHUNCg==

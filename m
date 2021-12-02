Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7A5466A04
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 19:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348385AbhLBSuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 13:50:37 -0500
Received: from mswedge1.sunplus.com ([60.248.182.113]:59368 "EHLO
        mg.sunplus.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233228AbhLBSuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 13:50:32 -0500
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.112
        by mg01.sunplus.com with MailGates ESMTP Server V5.0(5599:6:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Fri, 03 Dec 2021 02:46:53 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx02.sunplus.com.tw (172.17.9.112) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Fri, 3 Dec 2021 02:46:40 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Fri, 3 Dec 2021
 02:46:40 +0800
From:   =?big5?B?V2VsbHMgTHUgp2aq2sTL?= <wells.lu@sunplus.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        =?big5?B?VmluY2VudCBTaGloIKxJwEPCRQ==?= <vincent.shih@sunplus.com>
Subject: RE: [PATCH net-next v3 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Thread-Topic: [PATCH net-next v3 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Thread-Index: AQHX5dF9eGPWQxkNKU64ogPFWvAIaqwcdcyAgAE+n/CAAPQwgIAA4eHw
Date:   Thu, 2 Dec 2021 18:46:40 +0000
Message-ID: <2fded2fc3a1344d0882ae2f186257911@sphcmbx02.sunplus.com.tw>
References: <1638266572-5831-1-git-send-email-wellslutw@gmail.com>
 <1638266572-5831-3-git-send-email-wellslutw@gmail.com>
 <YabsT0/dASvYUH2p@lunn.ch>
 <cf60c230950747ec918acfc6dda595d6@sphcmbx02.sunplus.com.tw>
 <YajEbXtBwlDL4gOL@lunn.ch>
In-Reply-To: <YajEbXtBwlDL4gOL@lunn.ch>
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

SGkgQW5kcmV3LA0KDQpUaGFuayB5b3UgZm9yIGV4cGxhbmF0aW9uLg0KDQpJJ2xsIGFkZCBwaHlf
c3VwcG9ydF9hc3ltX3BhdXNlKCkgYWZ0ZXIgUEhZIGNvbm5lY3RlZCBuZXh0IHBhdGNoLg0KDQpJ
IGZvdW5kIHNvbWUgZHJpdmVycyBjYWxsIHBoeV9zZXRfbWF4X3NwZWVkKCkgdG8gc2V0IFBIWSBz
cGVlZCB0bw0KMTAwTSBhZnRlciBQSFkgY29ubmVjdGVkLiBJcyB0aGF0IG5lY2Vzc2FyeT8gRnJv
bSAnc3VwcG9ydGVkJywgUEhZIA0Kc3VwcG9ydHMgMTBNLzEwME0gYWxyZWFkeS4NCg0KSSBhbHNv
IGZvdW5kIHNvbWUgZHJpdmVycyBjYWxsIHBoeV9zdGFydF9hbmVnKCkgYWZ0ZXIgUEhZIHN0YXJ0
ZWQuDQpJcyB0aGF0IG5lY2Vzc2FyeT8gRnJvbSBzdGF0dXMgcmVnaXN0ZXIgb2YgUEhZLCAnYXV0
by1uZWdvJyBoYXMgDQpjb21wbGV0ZWQuDQoNCg0KQmVzdCByZWdhcmRzLA0KV2VsbHMNCg0KDQo+
ID4gSSBwcmludGVkIG91dCB0aGUgdmFsdWUgb2YgJ3N1cHBvcnRlZCcgYW5kICdhZHZlcnRpc2lu
ZycuDQo+ID4gJ3N1cHBvcnRlZCcgc2hvd3MgUEhZIGRldmljZSBzdXBwb3J0cyBQYXVzZSBhbmQg
QXN5bVBhdXNlICgweDYyY2YpLg0KPiA+IEJ1dCAnYWR2ZXJ0aXNpbmcnIHNob3dzIFBIWSBkZXZp
Y2UgZG9lcyBub3Qgc3VwcG9ydCBQYXVzZSBvciBBc3ltUGF1c2UgKDB4MDJjZikuDQo+ID4gSXMg
dGhpcyBjb3JyZWN0Pw0KPiA+DQo+ID4gSG93IHRvIGxldCBsaW5rIHBhcnRuZXIga25vdyBsb2Nh
bCBub2RlIHN1cHBvcnRzIFBhdXNlICYgQXN5bVBhdXNlDQo+ID4gKGZsb3cgY29udHJvbCk/DQo+
ID4NCj4gDQo+ICdzdXBwb3J0ZWQnIGluZGljYXRlcyB0aGF0IHRoZSBQSFkgY2FuIGRvLiBJdCBo
YXMgdGhlIGFiaWxpdHkgdG8gYWR2ZXJ0aXNlIHBhdXNlLiBCdXQgd2UNCj4gZG9uJ3QgYXV0b21h
dGljYWxseSBjb3B5IHRob3NlIGJpdHMgaW50byAnYWR2ZXJ0aXNpbmcnIGJlY2F1c2Ugd2UgZG9u
J3Qga25vdyBpZiB0aGUgTUFDDQo+IGFjdHVhbGx5IHN1cHBvcnRzIHBhdXNlL2FzeW0gcGF1c2Uu
DQo+IA0KPiBUaGUgTUFDIGRyaXZlciBuZWVkcyB0byBjYWxsIHBoeV9zdXBwb3J0X3N5bV9wYXVz
ZSgpIG9yDQo+IHBoeV9zdXBwb3J0X2FzeW1fcGF1c2UoKSB0byBsZXQgcGh5bGliIGtub3cgd2hh
dCBpdCBjYW4gZG8uIHBoeWxpYiB3aWxsIHRoZW4gYWRkIHRoZQ0KPiBhcHByb3ByaWF0ZSBiaXRz
IHRvICdhZHZlcnRpc2luZycuDQo+IA0KPiA+IFdpbGwgbWlpX3JlYWQoKSBhbmQgbWlpX3dyaXRl
KCkgYmUgY2FsbGVkIGluIGludGVycnVwdCBjb250ZXh0Pw0KPiANCj4gTm8uIE9ubHkgdGhyZWFk
IGNvbnRleHQsIGJlY2F1c2UgaXQgdXNlcyBhIG11dGV4IHRvIHByZXZlbnQgbXVsdGlwbGUgYWNj
ZXNzZXMgYXQgdGhlIHNhbWUNCj4gdGltZS4NCj4gDQo+IAkgQW5kcmV3DQo=

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC2246CC9E
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 05:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244244AbhLHEli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 23:41:38 -0500
Received: from 113.196.136.146.ll.static.sparqnet.net ([113.196.136.146]:57098
        "EHLO mg.sunplus.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S240064AbhLHElh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 23:41:37 -0500
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.202
        by mg02.sunplus.com with MailGates ESMTP Server V5.0(31386:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Wed, 08 Dec 2021 12:38:00 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx01.sunplus.com.tw (172.17.9.202) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Wed, 8 Dec 2021 12:37:59 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Wed, 8 Dec 2021
 12:37:59 +0800
From:   =?big5?B?V2VsbHMgTHUgp2aq2sTL?= <wells.lu@sunplus.com>
To:     Jakub Kicinski <kuba@kernel.org>, Wells Lu <wellslutw@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        =?big5?B?VmluY2VudCBTaGloIKxJwEPCRQ==?= <vincent.shih@sunplus.com>
Subject: RE: [PATCH net-next v4 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Thread-Topic: [PATCH net-next v4 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Thread-Index: AQHX60F8YLhxpbct+0aHjLW9kGkiW6wm7LuAgAEXAgA=
Date:   Wed, 8 Dec 2021 04:37:59 +0000
Message-ID: <ba5fe14be8d2434793713bd13abccb28@sphcmbx02.sunplus.com.tw>
References: <1638864419-17501-1-git-send-email-wellslutw@gmail.com>
        <1638864419-17501-3-git-send-email-wellslutw@gmail.com>
 <20211207115735.4d665759@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211207115735.4d665759@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

SGkgSmFrdWIsDQoNClRoYW5rIHlvdSBmb3IgcmV2aWV3Lg0KDQpJJ2xsIGZpeCB0aGUgd2Fybmlu
Z3MgcmVwb3J0ZWQgZnJvbSBjbGFuZyBuZXh0IHBhdGNoLg0KDQoNCkJlc3QgcmVnYXJkcywNCldl
bGxzIEx1DQoNCg0KPiBPbiBUdWUsICA3IERlYyAyMDIxIDE2OjA2OjU5ICswODAwIFdlbGxzIEx1
IHdyb3RlOg0KPiA+IEFkZCBkcml2ZXIgZm9yIFN1bnBsdXMgU1A3MDIxIFNvQy4NCj4gPg0KPiA+
IFNpZ25lZC1vZmYtYnk6IFdlbGxzIEx1IDx3ZWxsc2x1dHdAZ21haWwuY29tPg0KPiANCj4gY2xh
bmcgcG9pbnRzIG91dDoNCj4gDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L3N1bnBsdXMvc3BsMnN3
X2RyaXZlci5jOjIyMzo2NTogd2FybmluZzogcmVzdWx0IG9mIGNvbXBhcmlzb24gb2YNCj4gY29u
c3RhbnQgMTg4IHdpdGggZXhwcmVzc2lvbiBvZiB0eXBlICdjaGFyJyBpcyBhbHdheXMgdHJ1ZQ0K
PiBbLVd0YXV0b2xvZ2ljYWwtY29uc3RhbnQtb3V0LW9mLXJhbmdlLWNvbXBhcmVdDQo+ICAgICAg
ICAgICAgIChtYWNfYWRkclswXSAhPSAweEZDIHx8IG1hY19hZGRyWzFdICE9IDB4NEIgfHwgbWFj
X2FkZHJbMl0gIT0gMHhCQykpIHsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICB+fn5+fn5+fn5+fiBeICB+fn5+DQo+IGRyaXZlcnMv
bmV0L2V0aGVybmV0L3N1bnBsdXMvc3BsMnN3X2RyaXZlci5jOjIyMzoxOTogd2FybmluZzogcmVz
dWx0IG9mIGNvbXBhcmlzb24gb2YNCj4gY29uc3RhbnQgMjUyIHdpdGggZXhwcmVzc2lvbiBvZiB0
eXBlICdjaGFyJyBpcyBhbHdheXMgdHJ1ZQ0KPiBbLVd0YXV0b2xvZ2ljYWwtY29uc3RhbnQtb3V0
LW9mLXJhbmdlLWNvbXBhcmVdDQo+ICAgICAgICAgICAgIChtYWNfYWRkclswXSAhPSAweEZDIHx8
IG1hY19hZGRyWzFdICE9IDB4NEIgfHwgbWFjX2FkZHJbMl0gIT0gMHhCQykpIHsNCj4gICAgICAg
ICAgICAgIH5+fn5+fn5+fn5+IF4gIH5+fn4NCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvc3VucGx1
cy9zcGwyc3dfZHJpdmVyLmM6MjIyOjY0OiB3YXJuaW5nOiByZXN1bHQgb2YgY29tcGFyaXNvbiBv
Zg0KPiBjb25zdGFudCAxODggd2l0aCBleHByZXNzaW9uIG9mIHR5cGUgJ2NoYXInIGlzIGFsd2F5
cyBmYWxzZQ0KPiBbLVd0YXV0b2xvZ2ljYWwtY29uc3RhbnQtb3V0LW9mLXJhbmdlLWNvbXBhcmVd
DQo+ICAgICAgICAgaWYgKG1hY19hZGRyWzVdID09IDB4RkMgJiYgbWFjX2FkZHJbNF0gPT0gMHg0
QiAmJiBtYWNfYWRkclszXSA9PSAweEJDICYmDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB+fn5+fn5+fn5+fiBeICB+fn5+DQo+IGRy
aXZlcnMvbmV0L2V0aGVybmV0L3N1bnBsdXMvc3BsMnN3X2RyaXZlci5jOjIyMjoxODogd2Fybmlu
ZzogcmVzdWx0IG9mIGNvbXBhcmlzb24gb2YNCj4gY29uc3RhbnQgMjUyIHdpdGggZXhwcmVzc2lv
biBvZiB0eXBlICdjaGFyJyBpcyBhbHdheXMgZmFsc2UNCj4gWy1XdGF1dG9sb2dpY2FsLWNvbnN0
YW50LW91dC1vZi1yYW5nZS1jb21wYXJlXQ0KPiAgICAgICAgIGlmIChtYWNfYWRkcls1XSA9PSAw
eEZDICYmIG1hY19hZGRyWzRdID09IDB4NEIgJiYgbWFjX2FkZHJbM10gPT0gMHhCQyAmJg0KPiAg
ICAgICAgICAgICB+fn5+fn5+fn5+fiBeICB+fn5+DQo=

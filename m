Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB5F44E098
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 03:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbhKLDAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 22:00:53 -0500
Received: from mswedge1.sunplus.com ([60.248.182.113]:41374 "EHLO
        mg.sunplus.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234499AbhKLDAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 22:00:52 -0500
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.202
        by mg01.sunplus.com with MailGates ESMTP Server V5.0(25038:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Fri, 12 Nov 2021 10:58:03 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx01.sunplus.com.tw (172.17.9.202) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Fri, 12 Nov 2021 10:57:57 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Fri, 12 Nov
 2021 10:57:58 +0800
From:   =?big5?B?V2VsbHMgTHUgp2aq2sTL?= <wells.lu@sunplus.com>
To:     Rob Herring <robh@kernel.org>, Wells Lu <wellslutw@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?big5?B?VmluY2VudCBTaGloIKxJwEPCRQ==?= <vincent.shih@sunplus.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: RE: [PATCH v2 1/2] devicetree: bindings: net: Add bindings doc for
 Sunplus SP7021.
Thread-Topic: [PATCH v2 1/2] devicetree: bindings: net: Add bindings doc for
 Sunplus SP7021.
Thread-Index: AQHX1ttD14D1e9fuyEOeGcQRZL+/3qv95Q4AgAFPB0A=
Date:   Fri, 12 Nov 2021 02:57:58 +0000
Message-ID: <ee7e43d86102455aa72c38d02b747284@sphcmbx02.sunplus.com.tw>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <cover.1636620754.git.wells.lu@sunplus.com>
 <321e3b1a7dfca81f3ffae03b11099e8efeef92fa.1636620754.git.wells.lu@sunplus.com>
 <1636642646.909645.3774086.nullmailer@robh.at.kernel.org>
In-Reply-To: <1636642646.909645.3774086.nullmailer@robh.at.kernel.org>
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

SGksDQoNCg0KPiBPbiBUaHUsIDExIE5vdiAyMDIxIDE3OjA0OjIwICswODAwLCBXZWxscyBMdSB3
cm90ZToNCj4gPiBBZGQgYmluZGluZ3MgZG9jdW1lbnRhdGlvbiBmb3IgU3VucGx1cyBTUDcwMjEu
DQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBXZWxscyBMdSA8d2VsbHMubHVAc3VucGx1cy5jb20+
DQo+ID4gLS0tDQo+ID4gQ2hhbmdlcyBpbiBWMg0KPiA+ICAtIEFkZGVkIG1kaW8gYW5kIHBoeSBz
dWItbm9kZXMuDQo+ID4NCj4gPiAgLi4uL2JpbmRpbmdzL25ldC9zdW5wbHVzLHNwNzAyMS1lbWFj
LnlhbWwgICAgICAgICAgfCAxNTIgKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIE1BSU5UQUlO
RVJTICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICA3ICsNCj4gPiAg
MiBmaWxlcyBjaGFuZ2VkLCAxNTkgaW5zZXJ0aW9ucygrKQ0KPiA+ICBjcmVhdGUgbW9kZSAxMDA2
NDQNCj4gPiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3N1bnBsdXMsc3A3
MDIxLWVtYWMueWFtbA0KPiA+DQo+IA0KPiBNeSBib3QgZm91bmQgZXJyb3JzIHJ1bm5pbmcgJ21h
a2UgRFRfQ0hFQ0tFUl9GTEFHUz0tbSBkdF9iaW5kaW5nX2NoZWNrJw0KPiBvbiB5b3VyIHBhdGNo
IChEVF9DSEVDS0VSX0ZMQUdTIGlzIG5ldyBpbiB2NS4xMyk6DQo+IA0KPiB5YW1sbGludCB3YXJu
aW5ncy9lcnJvcnM6DQo+IC4vRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9z
dW5wbHVzLHNwNzAyMS1lbWFjLnlhbWw6OTQ6MTI6IFt3YXJuaW5nXSB3cm9uZw0KPiBpbmRlbnRh
dGlvbjogZXhwZWN0ZWQgMTAgYnV0IGZvdW5kIDExIChpbmRlbnRhdGlvbikNCj4gDQo+IGR0c2No
ZW1hL2R0YyB3YXJuaW5ncy9lcnJvcnM6DQo+IA0KPiBkb2MgcmVmZXJlbmNlIGVycm9ycyAobWFr
ZSByZWZjaGVja2RvY3MpOg0KPiANCj4gU2VlIGh0dHBzOi8vcGF0Y2h3b3JrLm96bGFicy5vcmcv
cGF0Y2gvMTU1MzgzMQ0KPiANCj4gVGhpcyBjaGVjayBjYW4gZmFpbCBpZiB0aGVyZSBhcmUgYW55
IGRlcGVuZGVuY2llcy4gVGhlIGJhc2UgZm9yIGEgcGF0Y2ggc2VyaWVzIGlzIGdlbmVyYWxseSB0
aGUgbW9zdA0KPiByZWNlbnQgcmMxLg0KPiANCj4gSWYgeW91IGFscmVhZHkgcmFuICdtYWtlIGR0
X2JpbmRpbmdfY2hlY2snIGFuZCBkaWRuJ3Qgc2VlIHRoZSBhYm92ZSBlcnJvcihzKSwgdGhlbiBt
YWtlIHN1cmUNCj4gJ3lhbWxsaW50JyBpcyBpbnN0YWxsZWQgYW5kIGR0LXNjaGVtYSBpcyB1cCB0
bw0KPiBkYXRlOg0KPiANCj4gcGlwMyBpbnN0YWxsIGR0c2NoZW1hIC0tdXBncmFkZQ0KPiANCj4g
UGxlYXNlIGNoZWNrIGFuZCByZS1zdWJtaXQuDQoNClRoYW5rIHlvdSB2ZXJ5IG11Y2ggZm9yIHJl
dmlldyBhbmQgdGVzdHMuDQpJJ2xsIGZpeCB3cm9uZyBpbmRlbnRhdGlvbiBuZXh0IHBhdGNoLg0K
DQo=

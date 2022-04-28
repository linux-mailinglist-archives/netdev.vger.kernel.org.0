Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E078551328A
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 13:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235193AbiD1Lgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbiD1Lgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:36:44 -0400
Received: from mg.sunplus.com (mswedge1.sunplus.com [60.248.182.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 10C361DA46;
        Thu, 28 Apr 2022 04:33:27 -0700 (PDT)
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.202
        by mg01.sunplus.com with MailGates ESMTP Server V5.0(27732:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Thu, 28 Apr 2022 19:33:01 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx01.sunplus.com.tw (172.17.9.202) with Microsoft SMTP Server (TLS) id
 15.0.1497.26; Thu, 28 Apr 2022 19:32:56 +0800
Received: from sphcmbx02.sunplus.com.tw ([fe80::fd3d:ad1a:de2a:18bd]) by
 sphcmbx02.sunplus.com.tw ([fe80::fd3d:ad1a:de2a:18bd%14]) with mapi id
 15.00.1497.026; Thu, 28 Apr 2022 19:32:56 +0800
From:   =?big5?B?V2VsbHMgTHUgp2aq2sTL?= <wells.lu@sunplus.com>
To:     Francois Romieu <romieu@fr.zoreil.com>,
        Wells Lu <wellslutw@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "edumazet@google.com" <edumazet@google.com>
Subject: RE: [PATCH net-next v9 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Thread-Topic: [PATCH net-next v9 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Thread-Index: AQHYWI+jS4JtiaXpFUyrVgs1l1MK560CSWcAgALotYA=
Date:   Thu, 28 Apr 2022 11:32:56 +0000
Message-ID: <ff2077684c4c45fca929a8f61447242b@sphcmbx02.sunplus.com.tw>
References: <1650882640-7106-1-git-send-email-wellslutw@gmail.com>
 <1650882640-7106-3-git-send-email-wellslutw@gmail.com>
 <Ymh3si+MTg5i0Bnl@electric-eye.fr.zoreil.com>
In-Reply-To: <Ymh3si+MTg5i0Bnl@electric-eye.fr.zoreil.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.25.108.39]
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRnJhbmNvaXMsDQoNCg0KPiBbLi4uXQ0KPiA+ICtpbnQgc3BsMnN3X3J4X3BvbGwoc3RydWN0
IG5hcGlfc3RydWN0ICpuYXBpLCBpbnQgYnVkZ2V0KSB7DQo+IFsuLi5dDQo+ID4gKwl3bWIoKTsJ
LyogbWFrZSBzdXJlIHNldHRpbmdzIGFyZSBlZmZlY3RpdmUuICovDQo+ID4gKwltYXNrID0gcmVh
ZGwoY29tbS0+bDJzd19yZWdfYmFzZSArIEwyU1dfU1dfSU5UX01BU0tfMCk7DQo+ID4gKwltYXNr
ICY9IH5NQUNfSU5UX1JYOw0KPiA+ICsJd3JpdGVsKG1hc2ssIGNvbW0tPmwyc3dfcmVnX2Jhc2Ug
KyBMMlNXX1NXX0lOVF9NQVNLXzApOw0KPiA+ICsNCj4gPiArCW5hcGlfY29tcGxldGUobmFwaSk7
DQo+ID4gKwlyZXR1cm4gMDsNCj4gPiArfQ0KPiA+ICsNCj4gPiAraW50IHNwbDJzd190eF9wb2xs
KHN0cnVjdCBuYXBpX3N0cnVjdCAqbmFwaSwgaW50IGJ1ZGdldCkgew0KPiBbLi4uXQ0KPiA+ICsJ
d21iKCk7CQkJLyogbWFrZSBzdXJlIHNldHRpbmdzIGFyZSBlZmZlY3RpdmUuICovDQo+ID4gKwlt
YXNrID0gcmVhZGwoY29tbS0+bDJzd19yZWdfYmFzZSArIEwyU1dfU1dfSU5UX01BU0tfMCk7DQo+
ID4gKwltYXNrICY9IH5NQUNfSU5UX1RYOw0KPiA+ICsJd3JpdGVsKG1hc2ssIGNvbW0tPmwyc3df
cmVnX2Jhc2UgKyBMMlNXX1NXX0lOVF9NQVNLXzApOw0KPiA+ICsNCj4gPiArCW5hcGlfY29tcGxl
dGUobmFwaSk7DQo+ID4gKwlyZXR1cm4gMDsNCj4gPiArfQ0KPiA+ICsNCj4gPiAraXJxcmV0dXJu
X3Qgc3BsMnN3X2V0aGVybmV0X2ludGVycnVwdChpbnQgaXJxLCB2b2lkICpkZXZfaWQpIHsNCj4g
Wy4uLl0NCj4gPiArCWlmIChzdGF0dXMgJiBNQUNfSU5UX1JYKSB7DQo+ID4gKwkJLyogRGlzYWJs
ZSBSWCBpbnRlcnJ1cHRzLiAqLw0KPiA+ICsJCW1hc2sgPSByZWFkbChjb21tLT5sMnN3X3JlZ19i
YXNlICsgTDJTV19TV19JTlRfTUFTS18wKTsNCj4gPiArCQltYXNrIHw9IE1BQ19JTlRfUlg7DQo+
ID4gKwkJd3JpdGVsKG1hc2ssIGNvbW0tPmwyc3dfcmVnX2Jhc2UgKyBMMlNXX1NXX0lOVF9NQVNL
XzApOw0KPiBbLi4uXQ0KPiA+ICsJCW5hcGlfc2NoZWR1bGUoJmNvbW0tPnJ4X25hcGkpOw0KPiA+
ICsJfQ0KPiA+ICsNCj4gPiArCWlmIChzdGF0dXMgJiBNQUNfSU5UX1RYKSB7DQo+ID4gKwkJLyog
RGlzYWJsZSBUWCBpbnRlcnJ1cHRzLiAqLw0KPiA+ICsJCW1hc2sgPSByZWFkbChjb21tLT5sMnN3
X3JlZ19iYXNlICsgTDJTV19TV19JTlRfTUFTS18wKTsNCj4gPiArCQltYXNrIHw9IE1BQ19JTlRf
VFg7DQo+ID4gKwkJd3JpdGVsKG1hc2ssIGNvbW0tPmwyc3dfcmVnX2Jhc2UgKyBMMlNXX1NXX0lO
VF9NQVNLXzApOw0KPiA+ICsNCj4gPiArCQlpZiAodW5saWtlbHkoc3RhdHVzICYgTUFDX0lOVF9U
WF9ERVNfRVJSKSkgew0KPiBbLi4uXQ0KPiA+ICsJCX0gZWxzZSB7DQo+ID4gKwkJCW5hcGlfc2No
ZWR1bGUoJmNvbW0tPnR4X25hcGkpOw0KPiA+ICsJCX0NCj4gPiArCX0NCj4gDQo+IFRoZSByZWFk
bC93cml0ZWwgc2VxdWVuY2UgaW4gcnhfcG9sbCAob3IgdHhfcG9sbCkgcmFjZXMgd2l0aCB0aGUg
aXJxIGhhbmRsZXIgcGVyZm9ybWluZw0KPiBNQUNfSU5UX1RYIChvciBNQUNfSU5UX1JYKSB3b3Jr
LiBJZiB0aGUgcmVhZGwgcmV0dXJucyB0aGUgc2FtZSB2YWx1ZSB0byBib3RoIGNhbGxlcnMsDQo+
IG9uZSBvZiB0aGUgd3JpdGVsIHdpbGwgYmUgb3ZlcndyaXR0ZW4uDQo+IA0KPiAtLQ0KPiBVZWlt
b3INCg0KSSB3aWxsIGFkZCBkaXNhYmxlX2lycSgpIGFuZCBlbmFibGVfaXJxKCkgZm9yIHNwbDJz
d19yeF9wb2xsKCkgYW5kIHNwbDJzd190eF9wb2xsKCkgYXMgc2hvd24gYmVsb3c6DQoNCnNwbDJz
d19yeF9wb2xsKCk6DQoNCgl3bWIoKTsJLyogbWFrZSBzdXJlIHNldHRpbmdzIGFyZSBlZmZlY3Rp
dmUuICovDQoJZGlzYWJsZV9pcnEoY29tbS0+aXJxKTsNCgltYXNrID0gcmVhZGwoY29tbS0+bDJz
d19yZWdfYmFzZSArIEwyU1dfU1dfSU5UX01BU0tfMCk7DQoJbWFzayAmPSB+TUFDX0lOVF9SWDsN
Cgl3cml0ZWwobWFzaywgY29tbS0+bDJzd19yZWdfYmFzZSArIEwyU1dfU1dfSU5UX01BU0tfMCk7
DQoJZW5hYmxlX2lycShjb21tLT5pcnEpOw0KDQpzcGwyc3dfdHhfcG9sbCgpOg0KDQoJd21iKCk7
CQkJLyogbWFrZSBzdXJlIHNldHRpbmdzIGFyZSBlZmZlY3RpdmUuICovDQoJZGlzYWJsZV9pcnEo
Y29tbS0+aXJxKTsNCgltYXNrID0gcmVhZGwoY29tbS0+bDJzd19yZWdfYmFzZSArIEwyU1dfU1df
SU5UX01BU0tfMCk7DQoJbWFzayAmPSB+TUFDX0lOVF9UWDsNCgl3cml0ZWwobWFzaywgY29tbS0+
bDJzd19yZWdfYmFzZSArIEwyU1dfU1dfSU5UX01BU0tfMCk7DQoJZW5hYmxlX2lycShjb21tLT5p
cnEpOw0KDQoNCklzIHRoZSBtb2RpZmljYXRpb24gb2s/DQoNCg0KVGhhbmsgeW91IGZvciB5b3Vy
IHJldmlldy4NCg0KQmVzdCByZWdhcmRzLA0KV2VsbHMNCg0K

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C45C51411B
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 05:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236682AbiD2Dxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 23:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235455AbiD2Dxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 23:53:47 -0400
X-Greylist: delayed 231 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 28 Apr 2022 20:50:26 PDT
Received: from mg.sunplus.com (unknown [113.196.136.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 88C60B646B;
        Thu, 28 Apr 2022 20:50:23 -0700 (PDT)
X-MailGates: (compute_score:DELIVER,40,3)
Received: from 172.17.9.202
        by mg02.sunplus.com with MailGates ESMTP Server V5.0(12344:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Fri, 29 Apr 2022 11:46:12 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx01.sunplus.com.tw (172.17.9.202) with Microsoft SMTP Server (TLS) id
 15.0.1497.26; Fri, 29 Apr 2022 11:46:06 +0800
Received: from sphcmbx02.sunplus.com.tw ([fe80::fd3d:ad1a:de2a:18bd]) by
 sphcmbx02.sunplus.com.tw ([fe80::fd3d:ad1a:de2a:18bd%14]) with mapi id
 15.00.1497.026; Fri, 29 Apr 2022 11:46:06 +0800
From:   =?utf-8?B?V2VsbHMgTHUg5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
To:     Francois Romieu <romieu@fr.zoreil.com>
CC:     Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
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
Thread-Index: AQHYWI+jS4JtiaXpFUyrVgs1l1MK560CSWcAgALotYCAACZzAIAA50mg
Date:   Fri, 29 Apr 2022 03:46:06 +0000
Message-ID: <c9f1c79f056c4982b6f425a3c3fdcfcd@sphcmbx02.sunplus.com.tw>
References: <1650882640-7106-1-git-send-email-wellslutw@gmail.com>
 <1650882640-7106-3-git-send-email-wellslutw@gmail.com>
 <Ymh3si+MTg5i0Bnl@electric-eye.fr.zoreil.com>
 <ff2077684c4c45fca929a8f61447242b@sphcmbx02.sunplus.com.tw>
 <YmsIqDPjvZKbbKov@electric-eye.fr.zoreil.com>
In-Reply-To: <YmsIqDPjvZKbbKov@electric-eye.fr.zoreil.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.25.108.39]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRnJhbmNvaXMsDQoNCg0KPiBbLi4uXQ0KPiA+IEkgd2lsbCBhZGQgZGlzYWJsZV9pcnEoKSBh
bmQgZW5hYmxlX2lycSgpIGZvciBzcGwyc3dfcnhfcG9sbCgpIGFuZCBzcGwyc3dfdHhfcG9sbCgp
DQo+IGFzIHNob3duIGJlbG93Og0KPiA+DQo+ID4gc3BsMnN3X3J4X3BvbGwoKToNCj4gPg0KPiA+
IAl3bWIoKTsJLyogbWFrZSBzdXJlIHNldHRpbmdzIGFyZSBlZmZlY3RpdmUuICovDQo+ID4gCWRp
c2FibGVfaXJxKGNvbW0tPmlycSk7DQo+ID4gCW1hc2sgPSByZWFkbChjb21tLT5sMnN3X3JlZ19i
YXNlICsgTDJTV19TV19JTlRfTUFTS18wKTsNCj4gPiAJbWFzayAmPSB+TUFDX0lOVF9SWDsNCj4g
PiAJd3JpdGVsKG1hc2ssIGNvbW0tPmwyc3dfcmVnX2Jhc2UgKyBMMlNXX1NXX0lOVF9NQVNLXzAp
Ow0KPiA+IAllbmFibGVfaXJxKGNvbW0tPmlycSk7DQo+ID4NCj4gPiBzcGwyc3dfdHhfcG9sbCgp
Og0KPiA+DQo+ID4gCXdtYigpOwkJCS8qIG1ha2Ugc3VyZSBzZXR0aW5ncyBhcmUgZWZmZWN0aXZl
LiAqLw0KPiA+IAlkaXNhYmxlX2lycShjb21tLT5pcnEpOw0KPiA+IAltYXNrID0gcmVhZGwoY29t
bS0+bDJzd19yZWdfYmFzZSArIEwyU1dfU1dfSU5UX01BU0tfMCk7DQo+ID4gCW1hc2sgJj0gfk1B
Q19JTlRfVFg7DQo+ID4gCXdyaXRlbChtYXNrLCBjb21tLT5sMnN3X3JlZ19iYXNlICsgTDJTV19T
V19JTlRfTUFTS18wKTsNCj4gPiAJZW5hYmxlX2lycShjb21tLT5pcnEpOw0KPiA+DQo+ID4NCj4g
PiBJcyB0aGUgbW9kaWZpY2F0aW9uIG9rPw0KPiANCj4gZGlzYWJsZV9pcnEgcHJldmVudHMgZnV0
dXJlIGlycSBwcm9jZXNzaW5nIGJ1dCBpdCBkb2VzIG5vdCBoZWxwIGFnYWluc3QgaXJxIGNvZGUg
Y3VycmVudGx5DQo+IHJ1bm5pbmcgb24gYSBkaWZmZXJlbnQgY3B1Lg0KPiANCj4gWW91IG1heSB1
c2UgcGxhaW4gc3Bpbl97bG9jayAvIHVubG9ja30gaW4gSVJRIGNvbnRleHQgYW5kIHNwaW5fe2xv
cV9pcnFzYXZlIC8gaXJxX3Jlc3RvcmV9DQo+IGluIE5BUEkgY29udGV4dC4NCj4gDQo+IC0tDQo+
IFVlaW1vcg0KDQpUaGFuayB5b3UgZm9yIHRlYWNoaW5nIG1lIGhvdyB0byBmaXggdGhlIGlzc3Vl
Lg0KSSdsbCBhZGQgdGhlbSBuZXh0IHBhdGNoLg0KDQoNCkJlc3QgcmVnYXJkcywNCldlbGxzDQo=

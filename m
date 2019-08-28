Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67991A081D
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 19:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfH1RHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 13:07:21 -0400
Received: from mga14.intel.com ([192.55.52.115]:20811 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbfH1RHV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 13:07:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 10:07:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,441,1559545200"; 
   d="scan'208";a="210237523"
Received: from kmsmsx153.gar.corp.intel.com ([172.21.73.88])
  by fmsmga002.fm.intel.com with ESMTP; 28 Aug 2019 10:07:18 -0700
Received: from pgsmsx103.gar.corp.intel.com ([169.254.2.25]) by
 KMSMSX153.gar.corp.intel.com ([169.254.5.69]) with mapi id 14.03.0439.000;
 Thu, 29 Aug 2019 01:07:17 +0800
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH v1 net-next] net: stmmac: Add support for MDIO interrupts
Thread-Topic: [PATCH v1 net-next] net: stmmac: Add support for MDIO
 interrupts
Thread-Index: AQHVXDYvbcbFOv5jhkKTA358ZQr6KKcNPteAgAA+tgCAA0MwoA==
Date:   Wed, 28 Aug 2019 17:07:16 +0000
Message-ID: <D6759987A7968C4889FDA6FA91D5CBC814759747@PGSMSX103.gar.corp.intel.com>
References: <1566870320-9825-1-git-send-email-weifeng.voon@intel.com>
 <20190826184719.GF2168@lunn.ch>
 <cac5aba0-b47b-00c6-f99b-64c6b385308a@gmail.com>
In-Reply-To: <cac5aba0-b47b-00c6-f99b-64c6b385308a@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+PiBEVyBFUW9TIHY1Lnh4IGNvbnRyb2xsZXJzIGFkZGVkIGNhcGFiaWxpdHkgZm9yIGludGVy
cnVwdCBnZW5lcmF0aW9uDQo+ID4+IHdoZW4gTURJTyBpbnRlcmZhY2UgaXMgZG9uZSAoR01JSSBC
dXN5IGJpdCBpcyBjbGVhcmVkKS4NCj4gPj4gVGhpcyBwYXRjaCBhZGRzIHN1cHBvcnQgZm9yIHRo
aXMgaW50ZXJydXB0IG9uIHN1cHBvcnRlZCBIVyB0byBhdm9pZA0KPiA+PiBwb2xsaW5nIG9uIEdN
SUkgQnVzeSBiaXQuDQo+ID4+DQo+ID4+IHN0bW1hY19tZGlvX3JlYWQoKSAmIHN0bW1hY19tZGlv
X3dyaXRlKCkgd2lsbCBzbGVlcCB1bnRpbCB3YWtlX3VwKCkNCj4gPj4gaXMgY2FsbGVkIGJ5IHRo
ZSBpbnRlcnJ1cHQgaGFuZGxlci4NCj4gPg0KPiA+IEhpIFZvb24NCj4gPg0KPiA+IEkgX3RoaW5r
XyB0aGVyZSBhcmUgc29tZSBvcmRlciBvZiBvcGVyYXRpb24gaXNzdWVzIGhlcmUuIFRoZSBtZGlv
YnVzDQo+ID4gaXMgcmVnaXN0ZXJlZCBpbiB0aGUgcHJvYmUgZnVuY3Rpb24uIEFzIHNvb24gYXMg
b2ZfbWRpb2J1c19yZWdpc3RlcigpDQo+ID4gaXMgY2FsbGVkLCB0aGUgTURJTyBidXMgbXVzdCB3
b3JrLiBBdCB0aGF0IHBvaW50IE1ESU8gcmVhZC93cml0ZXMgY2FuDQo+ID4gc3RhcnQgdG8gaGFw
cGVuLg0KPiA+DQo+ID4gQXMgZmFyIGFzIGkgY2FuIHNlZSwgdGhlIGludGVycnVwdCBoYW5kbGVy
IGlzIG9ubHkgcmVxdWVzdGVkIGluDQo+ID4gc3RtbWFjX29wZW4oKS4gU28gaXQgc2VlbXMgbGlr
ZSBhbnkgTURJTyBvcGVyYXRpb25zIGFmdGVyIHByb2JlLCBidXQNCj4gPiBiZWZvcmUgb3BlbiBh
cmUgZ29pbmcgdG8gZmFpbD8NCj4gDQo+IEFGQUlSLCB3YWl0X2V2ZW50X3RpbWVvdXQoKSB3aWxs
IGNvbnRpbnVlIHRvIGJ1c3kgbG9vcCBhbmQgd2FpdCB1bnRpbA0KPiB0aGUgdGltZW91dCwgYnV0
IG5vdCByZXR1cm4gYW4gZXJyb3IgYmVjYXVzZSB0aGUgcG9sbGVkIGNvbmRpdGlvbiB3YXMNCj4g
dHJ1ZSwgYXQgbGVhc3QgdGhhdCBpcyBteSByZWNvbGxlY3Rpb24gZnJvbSBoYXZpbmcgdGhlIHNh
bWUgaXNzdWUgd2l0aA0KPiB0aGUgYmNtZ2VuZXQgZHJpdmVyIGJlZm9yZSBpdCB3YXMgbW92ZWQg
dG8gY29ubmVjdGluZyB0byB0aGUgUEhZIGluIHRoZQ0KPiBuZG9fb3BlbigpIGZ1bmN0aW9uLg0K
PiAtLQ0KPiBGbG9yaWFuDQoNCkZsb3JpYW4gaXMgcmlnaHQgYXMgdGhlIHBvbGwgY29uZGl0aW9u
IGlzIHN0aWxsIHRydWUgYWZ0ZXIgdGhlIHRpbWVvdXQuIA0KSGVuY2UsIGFueSBtZGlvIG9wZXJh
dGlvbiBhZnRlciBwcm9iZSBhbmQgYmVmb3JlIG5kb19vcGVuIHdpbGwgc3RpbGwgd29yay4NClRo
ZSBvbmx5IGNvbnMgaGVyZSBpcyB0aGF0IGF0dGFjaGluZyB0aGUgUEhZIHdpbGwgdGFrZXMgYSBm
dWxsIGxlbmd0aCBvZiANCnRpbWVvdXQgdGltZSBmb3IgZWFjaCBtZGlvX3JlYWQgYW5kIG1kaW9f
d3JpdGUuIA0KU28gd2Ugc2hvdWxkIGF0dGFjaCB0aGUgcGh5IG9ubHkgYWZ0ZXIgdGhlIGludGVy
cnVwdCBoYW5kbGVyIGlzIHJlcXVlc3RlZD8NCiANCg==

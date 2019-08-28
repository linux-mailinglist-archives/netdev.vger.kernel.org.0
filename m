Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E042A08A6
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 19:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfH1Rgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 13:36:35 -0400
Received: from mga04.intel.com ([192.55.52.120]:16474 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727055AbfH1Rgd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 13:36:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 10:36:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,441,1559545200"; 
   d="scan'208";a="188304621"
Received: from kmsmsx157.gar.corp.intel.com ([172.21.138.134])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Aug 2019 10:36:31 -0700
Received: from pgsmsx103.gar.corp.intel.com ([169.254.2.25]) by
 kmsmsx157.gar.corp.intel.com ([169.254.5.162]) with mapi id 14.03.0439.000;
 Thu, 29 Aug 2019 01:36:30 +0800
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        "Heiner Kallweit" <hkallweit1@gmail.com>
Subject: RE: [PATCH v1 net-next] net: phy: mdio_bus: make mdiobus_scan also
 cover PHY that only talks C45
Thread-Topic: [PATCH v1 net-next] net: phy: mdio_bus: make mdiobus_scan also
 cover PHY that only talks C45
Thread-Index: AQHVXDc1t4vgWavJu0GuD73CQMEeB6cNOWeAgAAHYgCAAdKi8P//jAIAgAGQK4CAABXrAIAAiMHA
Date:   Wed, 28 Aug 2019 17:36:29 +0000
Message-ID: <D6759987A7968C4889FDA6FA91D5CBC814759789@PGSMSX103.gar.corp.intel.com>
References: <1566870769-9967-1-git-send-email-weifeng.voon@intel.com>
 <e9ece5ad-a669-6d6b-d050-c633cad15476@gmail.com>
 <20190826185418.GG2168@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC814758ED8@PGSMSX103.gar.corp.intel.com>
 <20190827154918.GO2168@lunn.ch>
 <AF233D1473C1364ABD51D28909A1B1B75C22CD3C@pgsmsx114.gar.corp.intel.com>
 <ef6aa10e-d3eb-e154-0168-d7f012858a2c@gmail.com>
In-Reply-To: <ef6aa10e-d3eb-e154-0168-d7f012858a2c@gmail.com>
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

PiBPbiA4LzI4LzE5IDg6NDEgQU0sIE9uZywgQm9vbiBMZW9uZyB3cm90ZToNCj4gPj4gT24gVHVl
LCBBdWcgMjcsIDIwMTkgYXQgMDM6MjM6MzRQTSArMDAwMCwgVm9vbiwgV2VpZmVuZyB3cm90ZToN
Cj4gPj4+Pj4+IE1ha2UgbWRpb2J1c19zY2FuKCkgdG8gdHJ5IGhhcmRlciB0byBsb29rIGZvciBh
bnkgUEhZIHRoYXQgb25seQ0KPiA+Pj4+IHRhbGtzIEM0NS4NCj4gPj4+Pj4gSWYgeW91IGFyZSBu
b3QgdXNpbmcgRGV2aWNlIFRyZWUgb3IgQUNQSSwgYW5kIHlvdSBhcmUgbGV0dGluZyB0aGUNCj4g
Pj4+Pj4gTURJTyBidXMgYmUgc2Nhbm5lZCwgaXQgc291bmRzIGxpa2UgdGhlcmUgc2hvdWxkIGJl
IGEgd2F5IGZvciB5b3UNCj4gPj4+Pj4gdG8gcHJvdmlkZSBhIGhpbnQgYXMgdG8gd2hpY2ggYWRk
cmVzc2VzIHNob3VsZCBiZSBzY2FubmVkICh0aGF0J3MNCj4gPj4+Pj4gbWlpX2J1czo6cGh5X21h
c2spIGFuZCBwb3NzaWJseSBlbmhhbmNlIHRoYXQgd2l0aCBhIG1hc2sgb2YNCj4gPj4+Pj4gcG9z
c2libGUNCj4gPj4+Pj4gQzQ1IGRldmljZXM/DQo+ID4+Pj4NCj4gPj4+PiBZZXMsIGkgZG9uJ3Qg
bGlrZSB0aGlzIHVuY29uZGl0aW9uYWwgYzQ1IHNjYW5uaW5nLiBBIGxvdCBvZiBNRElPDQo+ID4+
Pj4gYnVzIGRyaXZlcnMgZG9uJ3QgbG9vayBmb3IgdGhlIE1JSV9BRERSX0M0NS4gVGhleSBhcmUg
Z29pbmcgdG8gZG8gYQ0KPiA+Pj4+IEMyMiB0cmFuc2ZlciwgYW5kIG1heWJlIG5vdCBtYXNrIG91
dCB0aGUgTUlJX0FERFJfQzQ1IGZyb20gcmVnLA0KPiA+Pj4+IGNhdXNpbmcgYW4gaW52YWxpZCBy
ZWdpc3RlciB3cml0ZS4gQmFkIHRoaW5ncyBjYW4gdGhlbiBoYXBwZW4uDQo+ID4+Pj4NCj4gPj4+
PiBXaXRoIERUIGFuZCBBQ1BJLCB3ZSBoYXZlIGFuIGV4cGxpY2l0IGluZGljYXRpb24gdGhhdCBD
NDUgc2hvdWxkIGJlDQo+ID4+Pj4gdXNlZCwgc28gd2Uga25vdyBvbiB0aGlzIHBsYXRmb3JtIEM0
NSBpcyBzYWZlIHRvIHVzZS4gV2UgbmVlZA0KPiA+Pj4+IHNvbWV0aGluZyBzaW1pbGFyIHdoZW4g
bm90IHVzaW5nIERUIG9yIEFDUEkuDQo+ID4+Pj4NCj4gPj4+PiAJICBBbmRyZXcNCj4gPj4+DQo+
ID4+PiBGbG9yaWFuIGFuZCBBbmRyZXcsDQo+ID4+PiBUaGUgbWRpbyBjMjIgaXMgdXNpbmcgdGhl
IHN0YXJ0LW9mLWZyYW1lIFNUPTAxIHdoaWxlIG1kaW8gYzQ1IGlzDQo+ID4+PiB1c2luZyBTVD0w
MCBhcyBpZGVudGlmaWVyLiBTbyBtZGlvIGMyMiBkZXZpY2Ugd2lsbCBub3QgcmVzcG9uc2UgdG8N
Cj4gbWRpbyBjNDUgcHJvdG9jb2wuDQo+ID4+PiBBcyBpbiBJRUVFIDgwMi4xYWUtMjAwMiBBbm5l
eCA0NUEuMyBtZW50aW9uIHRoYXQ6DQo+ID4+PiAiIEV2ZW4gdGhvdWdoIHRoZSBDbGF1c2UgNDUg
TURJTyBmcmFtZXMgdXNpbmcgdGhlIFNUPTAwIGZyYW1lIGNvZGUNCj4gPj4+IHdpbGwgYWxzbyBi
ZSBkcml2ZW4gb24gdG8gdGhlIENsYXVzZSAyMiBNSUkgTWFuYWdlbWVudCBpbnRlcmZhY2UsDQo+
ID4+PiB0aGUgQ2xhdXNlIDIyIFBIWXMgd2lsbCBpZ25vcmUgdGhlIGZyYW1lcy4gIg0KPiA+Pj4N
Cj4gPj4+IEhlbmNlLCBJIGFtIG5vdCBzZWVpbmcgYW55IGNvbmNlcm4gdGhhdCB0aGUgYzQ1IHNj
YW5uaW5nIHdpbGwgbWVzcw0KPiA+Pj4gdXAgd2l0aA0KPiA+Pj4gYzIyIGRldmljZXMuDQo+ID4+
DQo+ID4+IEhpIFZvb24NCj4gPj4NCj4gPj4gVGFrZSBmb3IgZXhhbXBsZSBtZGlvLWhpc2ktZmVt
YWMuYw0KPiA+Pg0KPiA+PiBzdGF0aWMgaW50IGhpc2lfZmVtYWNfbWRpb19yZWFkKHN0cnVjdCBt
aWlfYnVzICpidXMsIGludCBtaWlfaWQsIGludA0KPiA+PiByZWdudW0pIHsNCj4gPj4gICAgICAg
IHN0cnVjdCBoaXNpX2ZlbWFjX21kaW9fZGF0YSAqZGF0YSA9IGJ1cy0+cHJpdjsNCj4gPj4gICAg
ICAgIGludCByZXQ7DQo+ID4+DQo+ID4+ICAgICAgICByZXQgPSBoaXNpX2ZlbWFjX21kaW9fd2Fp
dF9yZWFkeShkYXRhKTsNCj4gPj4gICAgICAgIGlmIChyZXQpDQo+ID4+ICAgICAgICAgICAgICAg
IHJldHVybiByZXQ7DQo+ID4+DQo+ID4+ICAgICAgICB3cml0ZWwoKG1paV9pZCA8PCBCSVRfUEhZ
X0FERFJfT0ZGU0VUKSB8IHJlZ251bSwNCj4gPj4gICAgICAgICAgICAgICBkYXRhLT5tZW1iYXNl
ICsgTURJT19SV0NUUkwpOw0KPiA+Pg0KPiA+Pg0KPiA+PiBUaGVyZSBpcyBubyBjaGVjayBoZXJl
IGZvciBNSUlfQUREUl9DNDUuIFNvIGl0IHdpbGwgcGVyZm9ybSBhIEMyMg0KPiA+PiB0cmFuc2Zl
ci4gQW5kIHJlZ251bSB3aWxsIHN0aWxsIGhhdmUgTUlJX0FERFJfQzQ1IGluIGl0LCBzbyB0aGUN
Cj4gPj4gd3JpdGVsKCkgaXMgZ29pbmcgdG8gc2V0IGJpdCAzMCwgc2luY2UgI2RlZmluZSBNSUlf
QUREUl9DNDUgKDE8PDMwKS4NCj4gPj4gV2hhdCBoYXBwZW5zIG9uIHRoaXMgaGFyZHdhcmUgdW5k
ZXIgdGhlc2UgY29uZGl0aW9ucz8NCj4gPj4NCj4gPj4gWW91IGNhbm5vdCB1bmNvbmRpdGlvbmFs
bHkgYXNrIGFuIE1ESU8gZHJpdmVyIHRvIGRvIGEgQzQ1IHRyYW5zZmVyLg0KPiA+PiBTb21lIGRy
aXZlcnMgYXJlIGdvaW5nIHRvIGRvIGJhZCB0aGluZ3MuDQo+ID4NCj4gPiBBbmRyZXcgJiBGbG9y
aWFuLCB0aGFua3MgZm9yIHlvdXIgcmV2aWV3IG9uIHRoaXMgcGF0Y2ggYW5kIGluc2lnaHRzIG9u
DQo+IGl0Lg0KPiA+IFdlIHdpbGwgbG9vayBpbnRvIHRoZSBpbXBsZW1lbnRhdGlvbiBhcyBzdWdn
ZXN0ZWQgYXMgZm9sbG93Lg0KPiA+DQo+ID4gLSBmb3IgZWFjaCBiaXQgY2xlYXIgaW4gbWlpX2J1
czo6cGh5X21hc2ssIHNjYW4gaXQgYXMgQzIyDQo+ID4gLSBmb3IgZWFjaCBiaXQgY2xlYXIgaW4g
bWlpX2J1czo6cGh5X2M0NV9tYXNrLCBzY2FuIGl0IGFzIEM0NQ0KPiA+DQo+ID4gV2Ugd2lsbCB3
b3JrIG9uIHRoaXMgYW5kIHJlc3VibWl0IHNvb25lc3QuDQo+IA0KPiBTb3VuZHMgZ29vZC4gSWYg
eW91IGRvIG5vdCBuZWVkIHRvIHNjYW4gdGhlIE1ESU8gYnVzLCBhbm90aGVyIGFwcHJvYWNoDQo+
IGlzIHRvIGNhbGwgZ2V0X3BoeV9kZXZpY2UoKSBieSBwYXNzaW5nIHRoZSBpc19jNDUgYm9vbGVh
biB0byB0cnVlIGluDQo+IG9yZGVyIHRvIGNvbm5lY3QgZGlyZWN0bHkgdG8gYSBDNDUgZGV2aWNl
IGZvciB3aGljaCB5b3UgYWxyZWFkeSBrbm93IHRoZQ0KPiBhZGRyZXNzLg0KPiANCj4gQXNzdW1p
bmcgdGhpcyBpcyBkb25lIGZvciB0aGUgc3RtbWFjIFBDSSBjaGFuZ2VzIHRoYXQgeW91IGhhdmUg
c3VibWl0dGVkLA0KPiBhbmQgdGhhdCB0aG9zZSBjYXJkcyBoYXZlIGEgZml4ZWQgc2V0IG9mIGFk
ZHJlc3NlcyBmb3IgdGhlaXIgUEhZcywgbWF5YmUNCj4gc2Nhbm5pbmcgdGhlIGJ1cyBpcyBvdmVy
a2lsbD8NCj4gLS0NCj4gRmxvcmlhbg0KDQpHb29kIHN1Z2dlc3Rpb24uIEFuZCB5ZXMsIHdlIGhh
dmUgYSBmaXggcGh5IGFkZHJlc3MgdG9vLiBCdXQgdGhlIE1BQyBpcyBmcmVlIA0KdG8gcGFpciB3
aXRoIGFueSBQSFkgd2hpY2ggbWlnaHQgc3VwcG9ydHMgb25seSBtZGlvIGMyMiBvciBvbmx5IG1k
aW8gYzQ1LiANCldlIHdpbGwgY29uc2lkZXIgaXQgYW5kIHJlc3VibWl0IHNvb25lc3QuDQoNCg0K
DQo=

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57E3933D07
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 04:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfFDCP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 22:15:28 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:26613 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfFDCP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 22:15:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559614527; x=1591150527;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8Hwclfbp9ZImcy7JwV+ku4rdlk61fQJheiqwVo7zwrM=;
  b=C3QqFSz21ugIwbp+hjhX+MTbKah0AvTh92uJ3SuadoByvJKbKZ77AZ2G
   zddPhgdKUpQ7aXk9SMAvZYodTNPxnHtcoexn1WG/Vd1Xl4p3TtOHmZnAU
   IP7pg9NdZ99BwT8NiPk+s0AYeWuP0g/saroslSQm3WqRxrj7DZEOUhknq
   s=;
X-IronPort-AV: E=Sophos;i="5.60,549,1549929600"; 
   d="scan'208";a="808373627"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 04 Jun 2019 02:15:25 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id 4D02C141703;
        Tue,  4 Jun 2019 02:15:24 +0000 (UTC)
Received: from EX13D08EUB003.ant.amazon.com (10.43.166.117) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 4 Jun 2019 02:15:23 +0000
Received: from EX13D04EUB002.ant.amazon.com (10.43.166.51) by
 EX13D08EUB003.ant.amazon.com (10.43.166.117) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 4 Jun 2019 02:15:22 +0000
Received: from EX13D04EUB002.ant.amazon.com ([10.43.166.51]) by
 EX13D04EUB002.ant.amazon.com ([10.43.166.51]) with mapi id 15.00.1367.000;
 Tue, 4 Jun 2019 02:15:22 +0000
From:   "Bshara, Nafea" <nafea@amazon.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Jubran, Samih" <sameehj@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Wilson, Matt" <msw@amazon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Subject: Re: [PATCH V2 net 00/11] Extending the ena driver to support new
 features and enhance performance
Thread-Topic: [PATCH V2 net 00/11] Extending the ena driver to support new
 features and enhance performance
Thread-Index: AQHVGhq67AG/toDzFEuJgXAZxcdpDaaKc16AgAAPeQCAAAorgIAALp+AgAAG49I=
Date:   Tue, 4 Jun 2019 02:15:22 +0000
Message-ID: <D26B5448-1E74-44E8-83DA-FC93E5520325@amazon.com>
References: <20190603144329.16366-1-sameehj@amazon.com>
 <20190603143205.1d95818e@cakuba.netronome.com>
 <9da931e72debc868efaac144082f40d379c50f3c.camel@amazon.co.uk>
 <20190603160351.085daa91@cakuba.netronome.com>,<20190604015043.GG17267@lunn.ch>
In-Reply-To: <20190604015043.GG17267@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QW5kcmV3LA0KDQpTZW50IGZyb20gbXkgaVBob25lDQoNCk9uIEp1biAzLCAyMDE5LCBhdCA2OjUy
IFBNLCBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+IHdyb3RlOg0KDQo+PiBBbnkgIlNtYXJ0
TklDIiB2ZW5kb3IgaGFzIHRlbXB0YXRpb24gb2YgdUFQSS1sZXZlbCBoYW5kIG9mZiB0byB0aGUN
Cj4+IGZpcm13YXJlIChpbmNsdWRpbmcgbXkgZW1wbG95ZXIpLCB3ZSBhbGwgcnVuIHByZXR0eSBi
ZWVmeSBwcm9jZXNzb3JzDQo+PiBpbnNpZGUgInRoZSBOSUMiIGFmdGVyIGFsbC4gIFRoZSBkZXZp
Y2UgY2VudHJpYyBldGh0b29sIGNvbmZpZ3VyYXRpb24NCj4+IGNhbiBiZSBpbXBsZW1lbnRlZCBi
eSBqdXN0IGZvcndhcmRpbmcgdGhlIHVBUEkgc3RydWN0dXJlcyBhcyB0aGV5IGFyZQ0KPj4gdG8g
dGhlIEZXLiAgSSdtIHN1cmUgQW5kcmV3IGFuZCBvdGhlcnMgd2hvIHdvdWxkIGxpa2UgdG8gc2Vl
IExpbnV4DQo+PiB0YWtlcyBtb3JlIGNvbnRyb2wgb3ZlciBQSFlzIGV0Yy4gd291bGQgbm90IGxp
a2UgdGhpcyBzY2VuYXJpbywgZWl0aGVyLg0KPiANCj4gTm8sIGkgd291bGQgbm90LiBUaGVyZSBh
cmUgYSBmZXcgZ29vZCBleGFtcGxlcyBvZiBib3RoIGZpcm13YXJlIGFuZA0KPiBvcGVuIGRyaXZl
cnMgYmVpbmcgdXNlZCB0byBjb250cm9sIHRoZSBzYW1lIFBIWSwgb24gZGlmZmVyZW50DQo+IGJv
YXJkcy4gVGhlIFBIWSBkcml2ZXIgd2FzIGRldmVsb3BlZCBieSB0aGUgY29tbXVuaXR5LCBhbmQg
aGFzIG1vcmUNCj4gZmVhdHVyZXMgdGhhbiB0aGUgZmlybXdhcmUgZHJpdmVyLiBBbmQgaXQga2Vl
cHMgZ2FpbmluZyBmZWF0dXJlcy4gVGhlDQo+IGZpcm13YXJlIGkgc3R1Y2ssIG5vIHVwZGF0ZXMu
IFRoZSBjb21tdW5pdHkgZHJpdmVyIGNhbiBiZSBkZWJ1Z2dlZCwNCj4gdGhlIGZpcm13YXJlIGlz
IGEgYmxhY2sgYm94LCBubyBjaGFuY2Ugb2YgdGhlIGNvbW11bml0eSBmaXhpbmcgYW55DQo+IGJ1
Z3MgaW4gaXQuDQo+IA0KPiBBbmQgUEhZcyBhcmUgY29tbW9kaXR5IGRldmljZXMuIEkgZG91YnQg
dGhlcmUgaXMgYW55IHZhbHVlIGFkZCBpbiB0aGUNCj4gZmlybXdhcmUgZm9yIGEgUEhZLCBhbnkg
cmVhbCBJUFIgd2hpY2ggbWFrZXMgdGhlIHByb2R1Y3QgYmV0dGVyLCBtYWdpYw0KPiBzYXVjZSBy
ZWxhdGVkIHRvIHRoZSBQSFkuIFNvIGp1c3Qgc2F2ZSB0aGUgY29zdCBvZiB3cml0aW5nIGFuZA0K
PiBtYWludGFpbmluZyBmaXJtd2FyZSwgZXhwb3J0IHRoZSBNRElPIGJ1cywgYW5kIGxldCBMaW51
eCBjb250cm9sIGl0Lg0KPiBDb25jZW50cmF0ZSB0aGUgZW5naW5lZXJzIG9uIHRoZSBpbnRlcmVz
dGluZyBwYXJ0cyBvZiB0aGUgTklDLCB0aGUNCj4gU21hcnQgcGFydHMsIHdoZXJlIHRoZXJlIGNh
biBiZSByZWFsIElQUi4NCj4gDQo+IEFuZCBpIHdvdWxkIHNheSB0aGlzIGlzIHRydWUgZm9yIGFu
eSBOSUMuIExldCBMaW51eCBjb250cm9sIHRoZSBQSFkuDQo+IA0KPiAgICAgIEFuZHJldw0KPiAN
Cg0KSXQgbWF5IGJlIHRydWUgZm9yIG9sZCBHYkUgUEhZcyB3aGVyZSBpdOKAmXMgYSBkaXNjcmV0
ZSBjaGlwIGZyb20gdGhlIGxpa2VzIG9mIE1hcnZlbGwgb3IgYnJvYWRjb20NCg0KQnV0IGF0IDI1
LzUwLzEwMEcsIHRoZSBQSHkgaXMgYWN0dWFsbHkgcGFydCBvZiB0aGUgbmljLiBJdOKAmXMgYSB2
ZXJ5IGNvbXBsZXggU0VSREVTLiAgQ2xvdWQgcHJvdmlkZXJzIGxpa2UgdXMgc3BlbmQgZW5vcm1v
dXMgYW1vdW50IG9mIHRpbWUgdGVzdGluZyB0aGUgUEhZIGFjcm9zcyBwcm9jZXNzIGFuZCB2b2x0
YWdlIHZhcmlhdGlvbnMsIGFsbCBjYWJsZSB0eXBlcywgbGVuZ3RoIGFuZCBtYW51ZmFjdHVyaW5n
IHZhcmlhdGlvbnMsIGFuZCBhZ2FpbnN0IGFsbCBzd2l0Y2hlcyB3ZSB1c2UuICBDb21tdW5pdHkg
ZHJpdmVycyB3b27igJl0IGJlIGFibGUgdG8gdmFsaWRhdGUgYW5kIHR1bmUgYWxsIHRoaXMuDQoN
ClBsdXMgd2Ugd291bGQgbmVlZCBleGFjdCBzYW1lIHNldHRpbmcgZm9yIExpbnV4LCBpbmNsdWRp
bmcgYWxsIGRpc3RyaWJ1dGlvbnMgZXZlbiAxMHllYXIgb2xkIGxpa2UgUkhFTDYsIGZvciBhbGwg
V2luZG93cywgRVNYLCBEUERLLCBGcmVlQlNELCAgYW5kIHN1cHBvcnQgbWlsbGlvbnMgb2YgZGlm
ZmVyZW50IGN1c3RvbWVycyB3aXRoIGRpZmZlcmVudCBzZXRzIG9mIE1hY2hpbmUgaW1hZ2VzLiAN
Cg0KSW4gdGhpcyBjYXNlLCB0aGVyZSBpcyBubyBwcmFjdGljYWwgY2hvaWNlIGJ5IGhhdmUgdGhl
IGZpcm13YXJlIHRvIG1hbmFnZSB0aGUgUEhZ

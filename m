Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B76E397D2
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 23:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731001AbfFGVeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 17:34:05 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:39072 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729796AbfFGVeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 17:34:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559943244; x=1591479244;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ci2OMA7X9AFtU5+f8MLSLkh5+K8L37bF/lJzkinaJnU=;
  b=gem5ntb1drE9MGRkPM5WsWaw5Pu+wvctKGjzu2UY9SomO46bGPWRAA18
   zj64dDF3N8Wm4HGGcRzuuedz7M7oXAsJdPKj3IOQQx1fyLPh2hUe6OfPf
   j+Zs5GjVmogiEinbMklopEhUm1Ee3IzBWAsFhqzHCJJLmnpZoDwRdrLp3
   8=;
X-IronPort-AV: E=Sophos;i="5.60,564,1549929600"; 
   d="scan'208";a="736590956"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-c5104f52.us-west-2.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 07 Jun 2019 21:34:02 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-c5104f52.us-west-2.amazon.com (Postfix) with ESMTPS id 1EE42A22F8;
        Fri,  7 Jun 2019 21:34:02 +0000 (UTC)
Received: from EX13D08EUB002.ant.amazon.com (10.43.166.232) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 7 Jun 2019 21:34:01 +0000
Received: from EX13D04EUB002.ant.amazon.com (10.43.166.51) by
 EX13D08EUB002.ant.amazon.com (10.43.166.232) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 7 Jun 2019 21:34:00 +0000
Received: from EX13D04EUB002.ant.amazon.com ([10.43.166.51]) by
 EX13D04EUB002.ant.amazon.com ([10.43.166.51]) with mapi id 15.00.1367.000;
 Fri, 7 Jun 2019 21:34:00 +0000
From:   "Bshara, Nafea" <nafea@amazon.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>
CC:     David Woodhouse <dwmw2@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Jubran, Samih" <sameehj@amazon.com>, Andrew Lunn <andrew@lunn.ch>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Wilson, Matt" <msw@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Subject: Re: [PATCH V2 net 00/11] Extending the ena driver to support new
 features and enhance performance
Thread-Topic: [PATCH V2 net 00/11] Extending the ena driver to support new
 features and enhance performance
Thread-Index: AQHVGhq67AG/toDzFEuJgXAZxcdpDaaKc16AgAAPeQCAAAorgIAALp+AgAAG49KAAE7pAIAArv0AgAKvMgCAAHNcAP//1FmAgAB8GACAAA7HaYAAAvQAgAADxoeAAAXVgIAAFuSigAACzQCAAVLqgP//jIaA
Date:   Fri, 7 Jun 2019 21:34:00 +0000
Message-ID: <F6CECB83-63C5-4A91-8798-84846A3D7E00@amazon.com>
References: <20190603144329.16366-1-sameehj@amazon.com>
 <20190603143205.1d95818e@cakuba.netronome.com>
 <9da931e72debc868efaac144082f40d379c50f3c.camel@amazon.co.uk>
 <20190603160351.085daa91@cakuba.netronome.com>
 <20190604015043.GG17267@lunn.ch>
 <D26B5448-1E74-44E8-83DA-FC93E5520325@amazon.com>
 <af79f238465ebe069bc41924a2ae2efbcdbd6e38.camel@infradead.org>
 <20190604102406.1f426339@cakuba.netronome.com>
 <7f697af8f31f4bc7ba30ef643e7b3921@EX13D11EUB003.ant.amazon.com>
 <20190606100945.49ceb657@cakuba.netronome.com>
 <D9B372D5-1B71-4387-AA8D-E38B22B44D8D@amazon.com>
 <20190606150428.2e55eb08@cakuba.netronome.com>
 <861B5CF2-878E-4610-8671-9D66AB61ABD7@amazon.com>
 <20190606160756.73fe4c06@cakuba.netronome.com>
 <35E875B8-FAE8-4C6A-BA30-FB3E2F7BA66B@amazon.com>
 <20190606164219.10dca54e@cakuba.netronome.com>
 <9057E288-28BA-4865-B41A-5847EE41D66F@amazon.com>
 <20190606181416.5ce1400d@cakuba.netronome.com>
 <20190607142717.3ee89f12@cakuba.netronome.com>
In-Reply-To: <20190607142717.3ee89f12@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.10.a.190512
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.97]
Content-Type: text/plain; charset="utf-8"
Content-ID: <3C4550C3A79E3344B16EF62D61AEC19D@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDYvNy8xOSwgMjoyNyBQTSwgIkpha3ViIEtpY2luc2tpIiA8amFrdWIua2ljaW5z
a2lAbmV0cm9ub21lLmNvbT4gd3JvdGU6DQoNCiAgICBPbiBUaHUsIDYgSnVuIDIwMTkgMTg6MTQ6
MTYgLTA3MDAsIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KICAgID4gT24gRnJpLCA3IEp1biAyMDE5
IDAxOjA0OjE0ICswMDAwLCBCc2hhcmEsIE5hZmVhIHdyb3RlOg0KICAgID4gPiBPbiBKdW4gNiwg
MjAxOSwgYXQgNDo0MyBQTSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6ICANCiAgICA+ID4gPj4+IE9r
YXksIHRoZW4geW91IGtub3cgd2hpY2ggb25lIGlzIHdoaWNoLiAgQXJlIHRoZXJlIG11bHRpcGxl
IEVOQXMgYnV0DQogICAgPiA+ID4+PiBvbmUgRUZBPyAgDQogICAgPiA+ID4+IA0KICAgID4gPiA+
PiBZZXMsICB2ZXJ5IHBvc3NpYmxlLiBWZXJ5IGNvbW1vbg0KICAgID4gPiA+PiANCiAgICA+ID4g
Pj4gVHlwaWNhbCB1c2UgY2FzZSB0aGF0IGluc3RhbmNlcyBoYXZlIG9uZSBlbmEgZm9yIGNvbnRy
b2wgcGxhbmUsIG9uZQ0KICAgID4gPiA+PiBmb3IgaW50ZXJuZXQgZmFjaW5nICwgYW5kIG9uZSAx
MDBHIGVuYSB0aGF0IGFsc28gaGF2ZSBlZmEgY2FwYWJpbGl0aWVzICANCiAgICA+ID4gPiANCiAg
ICA+ID4gPiBJIHNlZSwgYW5kIHRob3NlIGFyZSBQQ0kgZGV2aWNlcy4uICBTb21lIGZvcm0gb2Yg
cGxhdGZvcm0gZGF0YSB3b3VsZA0KICAgID4gPiA+IHNlZW0gbGlrZSB0aGUgYmVzdCBmaXQgdG8g
bWUuICBUaGVyZSBpcyBzb21ldGhpbmcgY2FsbGVkOg0KICAgID4gPiA+IA0KICAgID4gPiA+IC9z
eXMvYnVzL3BjaS8ke2RiZGZ9L2xhYmVsDQogICAgPiA+ID4gDQogICAgPiA+ID4gSXQgc2VlbXMg
dG8gY29tZSBmcm9tIHNvbWUgQUNQSSB0YWJsZSAtIERTTSBtYXliZT8gIEkgdGhpbmsgeW91IGNh
biBwdXQNCiAgICA+ID4gPiB3aGF0ZXZlciBzdHJpbmcgeW91IHdhbnQgdGhlcmUg8J+klCAgICAN
CiAgICA+ID4gDQogICAgPiA+IEFjcGkgcGF0aCB3b27igJl0IHdvcmssIG11Y2ggb2YgdGhlZSBp
bnRlcmZhY2UgYXJlIGhvdCBhdHRhY2hlZCwgdXNpbmcNCiAgICA+ID4gbmF0aXZlIHBjaWUgaG90
IHBsdWcgYW5kIGFjcGkgd29u4oCZdCBiZSBpbnZvbHZlZC4gICANCiAgICA+IA0KICAgID4gUGVy
aGFwcyBob3RwbHVnIGJyZWFrIERTTSwgSSB3b24ndCBwcmV0ZW5kIHRvIGJlIGFuIEFDUEkgZXhw
ZXJ0LiAgU28geW91DQogICAgPiBjYW4gZmluZCBhIHdheSB0byBzdHVmZiB0aGUgbGFiZWwgaW50
byB0aGF0IGZpbGUgZnJvbSBhbm90aGVyIHNvdXJjZS4NCiAgICA+IFRoZXJlJ3MgYWxzbyBWUEQs
IG9yIGN1c3RvbSBQQ0kgY2FwcywgYnV0IHBsYXRmb3JtIGRhdGEgZ2VuZXJhbGx5IHNlZW1zDQog
ICAgPiBsaWtlIGEgYmV0dGVyIGlkZWEuDQogICAgDQogICAgSmlyaSwgZG8geW91IGhhdmUgYW55
IHRob3VnaHRzIGFib3V0IHVzaW5nIHBoeXNfcG9ydF9uYW1lIGZvciBleHBvc2luZw0KICAgIHRv
cG9sb2d5IGluIHZpcnR1YWwgZW52aXJvbm1lbnRzLiAgUGVyaGFwcyB0aGF0J3MgdGhlIGJlc3Qg
Zml0IG9uIHRoZQ0KICAgIG5ldGRldiBzaWRlLiAgSXQncyBub3QgbGlrZSB3ZSB3YW50IGFueSBv
dGhlciBwb3J0IG5hbWUgaW4gc3VjaCBjYXNlLA0KICAgIGFuZCBoYXZpbmcgaXQgYXV0b21hdGlj
YWxseSBhcHBlbmRlZCB0byB0aGUgbmV0ZGV2IG5hbWUgbWF5IGJlIHVzZWZ1bC4NCiAgICANCmFu
eSBwcmVmZXJlbmNlIGZvciB0aGF0IHZzIC9zeXNmcyA/DQoNCg0KDQo=

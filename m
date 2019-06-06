Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB7238161
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbfFFW5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:57:30 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:58614 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbfFFW5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 18:57:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559861848; x=1591397848;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ktbbkOrrXdx5GHt2FlZ2AOaOq/FxgMM0aZ/BwS33A54=;
  b=XCF1BANAKA4w8yuhLDL+Rd0fes5R9YGzuUGyogLeMu83JtMxPXeX2Fo0
   ILbNXIlx2TASMzhvuJ0HhJrNKJRatq0CShQ0vPyxqVhbCdD5OYgwHl35S
   GGmzXi7jQNxrtWM1isvgC0CNC6meW8RKAIVUoPrlPL9pc+Yaklnc4pk91
   E=;
X-IronPort-AV: E=Sophos;i="5.60,560,1549929600"; 
   d="scan'208";a="678611984"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 06 Jun 2019 22:57:24 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 05D46241734;
        Thu,  6 Jun 2019 22:57:22 +0000 (UTC)
Received: from EX13D08EUB001.ant.amazon.com (10.43.166.236) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 6 Jun 2019 22:57:22 +0000
Received: from EX13D04EUB002.ant.amazon.com (10.43.166.51) by
 EX13D08EUB001.ant.amazon.com (10.43.166.236) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 6 Jun 2019 22:57:21 +0000
Received: from EX13D04EUB002.ant.amazon.com ([10.43.166.51]) by
 EX13D04EUB002.ant.amazon.com ([10.43.166.51]) with mapi id 15.00.1367.000;
 Thu, 6 Jun 2019 22:57:21 +0000
From:   "Bshara, Nafea" <nafea@amazon.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "Jubran, Samih" <sameehj@amazon.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Andrew Lunn <andrew@lunn.ch>,
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
Thread-Index: AQHVGhq67AG/toDzFEuJgXAZxcdpDaaKc16AgAAPeQCAAAorgIAALp+AgAAG49KAAE7pAIAArv0AgAKvMgCAAHNcAP//1FmAgAB8GACAAA7HaQ==
Date:   Thu, 6 Jun 2019 22:57:21 +0000
Message-ID: <861B5CF2-878E-4610-8671-9D66AB61ABD7@amazon.com>
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
        <D9B372D5-1B71-4387-AA8D-E38B22B44D8D@amazon.com>,<20190606150428.2e55eb08@cakuba.netronome.com>
In-Reply-To: <20190606150428.2e55eb08@cakuba.netronome.com>
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

DQoNClNlbnQgZnJvbSBteSBpUGhvbmUNCg0KPiBPbiBKdW4gNiwgMjAxOSwgYXQgMzowNSBQTSwg
SmFrdWIgS2ljaW5za2kgPGpha3ViLmtpY2luc2tpQG5ldHJvbm9tZS5jb20+IHdyb3RlOg0KPiAN
Cj4+IE9uIFRodSwgNiBKdW4gMjAxOSAyMTo0MDoxOSArMDAwMCwgQnNoYXJhLCBOYWZlYSB3cm90
ZToNCj4+IO+7v09uIDYvNi8xOSwgMTA6MTYgQU0sICJKYWt1YiBLaWNpbnNraSIgPGpha3ViLmtp
Y2luc2tpQG5ldHJvbm9tZS5jb20+IHdyb3RlOg0KPj4gDQo+PiAgICBIaSBTYW1paCENCj4+IA0K
Pj4gICAgUGxlYXNlIGRvbid0IHRvcCBwb3N0IG9uIExpbnV4IGtlcm5lbCBtYWlsaW5nIGxpc3Rz
Lg0KPj4gDQo+Pj4gICAgT24gVGh1LCA2IEp1biAyMDE5IDEwOjIzOjQwICswMDAwLCBKdWJyYW4s
IFNhbWloIHdyb3RlOg0KPj4+IEFzIG9mIHRvZGF5IHRoZXJlIGFyZSBubyBmbGFncyBleHBvc2Vk
IGJ5IEVOQSBOSUMgZGV2aWNlLCBob3dldmVyLCB3ZQ0KPj4+IGFyZSBwbGFubmluZyB0byB1c2Ug
dGhlbSBpbiB0aGUgbmVhciBmdXR1cmUuIFdlIHdhbnQgdG8gcHJvdmlkZQ0KPj4+IGN1c3RvbWVy
cyB3aXRoIGV4dHJhIG1ldGhvZHMgdG8gaWRlbnRpZnkgKGFuZCBkaWZmZXJlbnRpYXRlKSBtdWx0
aXBsZQ0KPj4+IG5ldHdvcmsgaW50ZXJmYWNlcyB0aGF0IGNhbiBiZSBhdHRhY2hlZCB0byBhIHNp
bmdsZSBWTS4gQ3VycmVudGx5LA0KPj4+IGN1c3RvbWVycyBjYW4gaWRlbnRpZnkgYSBzcGVjaWZp
YyBuZXR3b3JrIGludGVyZmFjZSAoRU5JKSBvbmx5IGJ5IE1BQw0KPj4+IGFkZHJlc3MsIGFuZCBs
YXRlciBsb29rIHVwIHRoaXMgTUFDIGFtb25nIG90aGVyIG11bHRpcGxlIEVOSXMgdGhhdA0KPj4+
IHRoZXkgaGF2ZS4gSW4gc29tZSBjYXNlcyBpdCBtaWdodCBub3QgYmUgY29udmVuaWVudC4gVXNp
bmcgdGhlc2UNCj4+PiBmbGFncyB3aWxsIGxldCB1cyBpbmZvcm0gdGhlIGN1c3RvbWVyIGFib3V0
IEVOSWBzIHNwZWNpZmljDQo+Pj4gcHJvcGVydGllcy4gIA0KPj4gDQo+PiAgICBPaCBubyA6KCAg
WW91J3JlIHVzaW5nIHByaXZhdGUgX2ZlYXR1cmVfIGZsYWdzIGFzIGxhYmVscyBvciB0YWdzLg0K
Pj4gDQo+Pj4gSXQncyBub3QgZmluYWxpemVkLCBidXQgdGVudGF0aXZlbHkgaXQgY2FuIGxvb2sg
bGlrZSB0aGlzOiANCj4+PiBwcmltYXJ5LWVuaTogb24gLyogRGlmZmVyZW50aWF0ZSBiZXR3ZWVu
IHByaW1hcnkgYW5kIHNlY29uZGFyeSBFTklzICovICANCj4+IA0KPj4gICAgRGlkIHlvdSBjb25z
aWRlciB1c2luZyBwaHlzX3BvcnRfbmFtZSBmb3IgdGhpcyB1c2UgY2FzZT8NCj4+IA0KPj4gICAg
SWYgdGhlIGludGVudCBpcyB0byBoYXZlIHRob3NlIGludGVyZmFjZXMgYm9uZGVkLCBldmVuIGJl
dHRlciB3b3VsZA0KPj4gICAgYmUgdG8gZXh0ZW5kIHRoZSBuZXRfZmFpbG92ZXIgbW9kdWxlIG9y
IHdvcmsgb24gdXNlciBzcGFjZSBBQkkgZm9yIFZNDQo+PiAgICBmYWlsb3Zlci4gIFRoYXQgbWln
aHQgYmUgYSBiaWdnZXIgZWZmb3J0LCB0aG91Z2guDQo+IA0KPiBTb21lb25lIGVsc2Ugd2lsbCBh
ZGRyZXNzIHRoaXMgcG9pbnQ/DQo+IA0KPj4+IGhhcy1hc3NvY2lhdGVkLWVmYTogb24gLyogV2ls
bCBzcGVjaWZ5IEVOQSBkZXZpY2UgaGFzIGFub3RoZXIgYXNzb2NpYXRlZCBFRkEgZGV2aWNlICov
ICANCj4+IA0KPj4gICAgSURLIGhvdyB5b3VyIEVOQS9FRkEgdGhpbmcgd29ya3MsIGJ1dCBzb3Vu
ZHMgbGlrZSBzb21ldGhpbmcgdGhhdCBzaG91bGQNCj4+ICAgIGJlIHNvbHZlZCBpbiB0aGUgZGV2
aWNlIG1vZGVsLg0KPj4gDQo+PiBbTkJdIEVOQSBpcyBhIG5ldERldiwgIEVGQSBpcyBhbiBpYl9k
ZXYuICAgQm90aCBzaGFyZSB0aGUgc2FtZSBwaHlzaWNhbCBuZXR3b3JrDQo+PiBBbGwgcHJldmlv
dXMgYXR0ZW1wdCB0byBtYWtlIHRoZW0gc2hhcmUgYXQgZGV2aWNlIGxldmVsIGxlYWRzIHRvIGEN
Cj4+IGxvdCBvZiBjb21wbGV4aXR5IGF0IHRoZSBPUyBsZXZlbCwgd2l0aCBpbnRlci1kZXBlbmRl
bmNpZXMgdGhhdCBhcmUNCj4+IHByb25nZWQgdG8gZXJyb3IgTm90IHRvIG1lbnRpb24gdGhhdCBP
UyBkaXN0cmlidXRpb24gdGhhdCBiYWNrcG9ydA0KPj4gZnJvbSBtYWlubGluZSB3b3VsZCBiYWNr
cG9ydCBkaWZmZXJlbnQgc3Vic2V0IG9mIGVhY2ggZHJpdmVyLCAgbGV0DQo+PiBhbG9uZSB0aGV5
IGJlbG9uZyB0byB0d28gc3VidHJlZXMgd2l0aCB0d28gZGlmZmVyZW50IG1haW50YWluZXJzIGFu
ZA0KPj4gd2UgZG9u4oCZdCB3YW50IHRvIGJlIGluIGEgcGxhY2Ugd2hlcmUgd2UgaGF2ZSB0byBj
b29yZGluYXRlIHJlbGVhc2VzDQo+PiBiZXR3ZWVuIHR3byBzdWJncm91cHMNCj4+IA0KPj4gQXMg
c3VjaCwgd2Ugc2VsZWN0ZWQgYSBtdWNoIHNhZmVyIHBhdGgsIHRoYXQgb3BlcmF0aW9uYWwsIGRl
dmVsb3BtZW50IGFuZCBkZXBsb3ltZW50IG9mIHR3byBkaWZmZXJlbnQgZHJpdmVycyAobmV0ZGV2
IHZzIGliX2RldikgbXVjaCBlYXNpZXIgYnV0IGV4cG9zaW5nIHRoZSBuaWMgYXMgdHdvIGRpZmZl
cmVudCBQaHlzaWNhbCBmdW5jdGlvbnMvZGV2aWNlcw0KPj4gDQo+PiBPbmx5IGNvc3Qgd2UgaGF2
ZSBpcyB0aGF0IHdlIG5lZWQgdGhpcyBleHRyYSBwcm9wcmlldHkgdG8gaGVscCB1c2VyIGlkZW50
aWZ5IHdoaWNoIHR3byBkZXZpY2VzIGFyZSByZWxhdGVkIGhlbmNlIFNhbWloJ3MgY29tbWVudHMN
Cj4gDQo+IEkgdGhpbmsgeW91J3JlIGFyZ3Vpbmcgd2l0aCBhIGRpZmZlcmVudCBwb2ludCB0aGFu
IHRoZSBvbmUgSSBtYWRlIDopDQo+IERvIHlvdSB0aGluayBJIHNhaWQgdGhleSBzaG91bGQgdXNl
IHRoZSBzYW1lIFBDSSBkZXZpY2U/ICBJIGhhdmVuJ3QuDQo+IA0KPiBJSVVDIHlvdSBhcmUgZXhw
b3NpbmcgYSAidGFnIiB0aHJvdWdoIHRoZSBmZWF0dXJlIEFQSSBvbiB0aGUgbmV0ZGV2IHRvDQo+
IGluZGljYXRlIHRoYXQgdGhlcmUgaXMgYW5vdGhlciBQQ0kgZGV2aWNlIHByZXNlbnQgb24gdGhl
IHN5c3RlbT8NCj4gDQo+IFdoYXQgSSBzYWlkIGlzIGlmIHRoZXJlIGlzIGEgcmVsYXRpb24gYmV0
d2VlbiBQQ0kgZGV2aWNlcyB0aGUgYmVzdA0KPiBsZXZlbCB0byBleHBvc2UgdGhpcyByZWxhdGlv
biBhdCBpcyBhdCB0aGUgZGV2aWNlIG1vZGVsIGxldmVsLiAgSU9XDQo+IGhhdmUgc29tZSBmb3Jt
IG9uICJsaW5rIiBpbiBzeXNmcywgbm90IGluIGEgcmFuZG9tIHBsYWNlIG9uIGEgbmV0ZGV2Lg0K
PiANCj4gSGF2aW5nIHNhaWQgdGhhdCwgaXQncyBlbnRpcmVseSB1bmNsZWFyIHRvIG1lIHdoYXQg
dGhlIHVzZXIgc2NlbmFyaW8gaXMNCj4gaGVyZS4gIFlvdSBzYXkgIndoaWNoIHR3byBkZXZpY2Vz
IHJlbGF0ZWQiLCB5ZXQgeW91IG9ubHkgaGF2ZSBvbmUgYml0LA0KPiBzbyBpdCBjYW4gaW5kaWNh
dGUgdGhhdCB0aGVyZSBpcyBhbm90aGVyIGRldmljZSwgbm90IF93aGljaF8gZGV2aWNlIGlzDQo+
IHJlbGF0ZWQuICBJbmZvcm1hdGlvbiB5b3UgY2FuIGZ1bGwgd2VsbCBnZXQgZnJvbSBydW5uaW5n
IGxzcGNpIPCfpLcNCj4gRG8gdGhlIGRldmljZXMgaGF2ZSB0aGUgc2FtZSBQQ0kgSUQvdmVuZG9y
Om1vZGVsPw0KDQpEaWZmZXJlbnQgbW9kZWwgaWQNCldpbGwgbG9vayBpbnRvIHN5c2ZzIA==

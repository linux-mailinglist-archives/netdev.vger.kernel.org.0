Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C84B37FBD
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbfFFVk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:40:29 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:29596 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfFFVk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:40:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559857227; x=1591393227;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=haa6/n2fb+qWWERhfYNT5OYL7/jBwN5YDBUgT3jvLPI=;
  b=oPELPrMFjjVywc6MMvc6xNGVaCp479o7UdCxJhkH7As41uQmSNVmM49H
   GebHR0FMEDspkQdOCPJNZm/XcP7iBw0sZ35dC7oA4sggX3SGMGxARl5LH
   1mxbKM6rXvd9oEqlxVQEB/R1n7Z7TRxYdrJppal19Sy1VrDUQgnWfNjuI
   A=;
X-IronPort-AV: E=Sophos;i="5.60,560,1549929600"; 
   d="scan'208";a="678602489"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 06 Jun 2019 21:40:22 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id BBB4AA211A;
        Thu,  6 Jun 2019 21:40:21 +0000 (UTC)
Received: from EX13D08EUB003.ant.amazon.com (10.43.166.117) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 6 Jun 2019 21:40:21 +0000
Received: from EX13D04EUB002.ant.amazon.com (10.43.166.51) by
 EX13D08EUB003.ant.amazon.com (10.43.166.117) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 6 Jun 2019 21:40:20 +0000
Received: from EX13D04EUB002.ant.amazon.com ([10.43.166.51]) by
 EX13D04EUB002.ant.amazon.com ([10.43.166.51]) with mapi id 15.00.1367.000;
 Thu, 6 Jun 2019 21:40:19 +0000
From:   "Bshara, Nafea" <nafea@amazon.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "Jubran, Samih" <sameehj@amazon.com>
CC:     David Woodhouse <dwmw2@infradead.org>,
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
Thread-Index: AQHVGhq67AG/toDzFEuJgXAZxcdpDaaKc16AgAAPeQCAAAorgIAALp+AgAAG49KAAE7pAIAArv0AgAKvMgCAAHNcAP//1FmA
Date:   Thu, 6 Jun 2019 21:40:19 +0000
Message-ID: <D9B372D5-1B71-4387-AA8D-E38B22B44D8D@amazon.com>
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
In-Reply-To: <20190606100945.49ceb657@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.10.a.190512
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.155]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A885E91A698AFF4899D2A83844CC3273@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDYvNi8xOSwgMTA6MTYgQU0sICJKYWt1YiBLaWNpbnNraSIgPGpha3ViLmtpY2lu
c2tpQG5ldHJvbm9tZS5jb20+IHdyb3RlOg0KDQogICAgSGkgU2FtaWghDQogICAgDQogICAgUGxl
YXNlIGRvbid0IHRvcCBwb3N0IG9uIExpbnV4IGtlcm5lbCBtYWlsaW5nIGxpc3RzLg0KICAgIA0K
ICAgIE9uIFRodSwgNiBKdW4gMjAxOSAxMDoyMzo0MCArMDAwMCwgSnVicmFuLCBTYW1paCB3cm90
ZToNCiAgICA+IEFzIG9mIHRvZGF5IHRoZXJlIGFyZSBubyBmbGFncyBleHBvc2VkIGJ5IEVOQSBO
SUMgZGV2aWNlLCBob3dldmVyLCB3ZQ0KICAgID4gYXJlIHBsYW5uaW5nIHRvIHVzZSB0aGVtIGlu
IHRoZSBuZWFyIGZ1dHVyZS4gV2Ugd2FudCB0byBwcm92aWRlDQogICAgPiBjdXN0b21lcnMgd2l0
aCBleHRyYSBtZXRob2RzIHRvIGlkZW50aWZ5IChhbmQgZGlmZmVyZW50aWF0ZSkgbXVsdGlwbGUN
CiAgICA+IG5ldHdvcmsgaW50ZXJmYWNlcyB0aGF0IGNhbiBiZSBhdHRhY2hlZCB0byBhIHNpbmds
ZSBWTS4gQ3VycmVudGx5LA0KICAgID4gY3VzdG9tZXJzIGNhbiBpZGVudGlmeSBhIHNwZWNpZmlj
IG5ldHdvcmsgaW50ZXJmYWNlIChFTkkpIG9ubHkgYnkgTUFDDQogICAgPiBhZGRyZXNzLCBhbmQg
bGF0ZXIgbG9vayB1cCB0aGlzIE1BQyBhbW9uZyBvdGhlciBtdWx0aXBsZSBFTklzIHRoYXQNCiAg
ICA+IHRoZXkgaGF2ZS4gSW4gc29tZSBjYXNlcyBpdCBtaWdodCBub3QgYmUgY29udmVuaWVudC4g
VXNpbmcgdGhlc2UNCiAgICA+IGZsYWdzIHdpbGwgbGV0IHVzIGluZm9ybSB0aGUgY3VzdG9tZXIg
YWJvdXQgRU5JYHMgc3BlY2lmaWMNCiAgICA+IHByb3BlcnRpZXMuDQogICAgDQogICAgT2ggbm8g
OiggIFlvdSdyZSB1c2luZyBwcml2YXRlIF9mZWF0dXJlXyBmbGFncyBhcyBsYWJlbHMgb3IgdGFn
cy4NCiAgICANCiAgICA+IEl0J3Mgbm90IGZpbmFsaXplZCwgYnV0IHRlbnRhdGl2ZWx5IGl0IGNh
biBsb29rIGxpa2UgdGhpczogDQogICAgPiBwcmltYXJ5LWVuaTogb24gLyogRGlmZmVyZW50aWF0
ZSBiZXR3ZWVuIHByaW1hcnkgYW5kIHNlY29uZGFyeSBFTklzICovDQogICAgDQogICAgRGlkIHlv
dSBjb25zaWRlciB1c2luZyBwaHlzX3BvcnRfbmFtZSBmb3IgdGhpcyB1c2UgY2FzZT8NCiAgICAN
CiAgICBJZiB0aGUgaW50ZW50IGlzIHRvIGhhdmUgdGhvc2UgaW50ZXJmYWNlcyBib25kZWQsIGV2
ZW4gYmV0dGVyIHdvdWxkDQogICAgYmUgdG8gZXh0ZW5kIHRoZSBuZXRfZmFpbG92ZXIgbW9kdWxl
IG9yIHdvcmsgb24gdXNlciBzcGFjZSBBQkkgZm9yIFZNDQogICAgZmFpbG92ZXIuICBUaGF0IG1p
Z2h0IGJlIGEgYmlnZ2VyIGVmZm9ydCwgdGhvdWdoLg0KICAgIA0KICAgID4gaGFzLWFzc29jaWF0
ZWQtZWZhOiBvbiAvKiBXaWxsIHNwZWNpZnkgRU5BIGRldmljZSBoYXMgYW5vdGhlciBhc3NvY2lh
dGVkIEVGQSBkZXZpY2UgKi8NCiAgICANCiAgICBJREsgaG93IHlvdXIgRU5BL0VGQSB0aGluZyB3
b3JrcywgYnV0IHNvdW5kcyBsaWtlIHNvbWV0aGluZyB0aGF0IHNob3VsZA0KICAgIGJlIHNvbHZl
ZCBpbiB0aGUgZGV2aWNlIG1vZGVsLg0KDQpbTkJdIEVOQSBpcyBhIG5ldERldiwgIEVGQSBpcyBh
biBpYl9kZXYuICAgQm90aCBzaGFyZSB0aGUgc2FtZSBwaHlzaWNhbCBuZXR3b3JrDQpBbGwgcHJl
dmlvdXMgYXR0ZW1wdCB0byBtYWtlIHRoZW0gc2hhcmUgYXQgZGV2aWNlIGxldmVsIGxlYWRzIHRv
IGEgbG90IG9mIGNvbXBsZXhpdHkgYXQgdGhlIE9TIGxldmVsLCB3aXRoIGludGVyLWRlcGVuZGVu
Y2llcyB0aGF0IGFyZSBwcm9uZ2VkIHRvIGVycm9yDQpOb3QgdG8gbWVudGlvbiB0aGF0IE9TIGRp
c3RyaWJ1dGlvbiB0aGF0IGJhY2twb3J0IGZyb20gbWFpbmxpbmUgd291bGQgYmFja3BvcnQgZGlm
ZmVyZW50IHN1YnNldCBvZiBlYWNoIGRyaXZlciwgIGxldCBhbG9uZSB0aGV5IGJlbG9uZyB0byB0
d28gc3VidHJlZXMgd2l0aCB0d28gZGlmZmVyZW50IG1haW50YWluZXJzIGFuZCB3ZSBkb27igJl0
IHdhbnQgdG8gYmUgaW4gYSBwbGFjZSB3aGVyZSB3ZSBoYXZlIHRvIGNvb3JkaW5hdGUgcmVsZWFz
ZXMgYmV0d2VlbiB0d28gc3ViZ3JvdXBzDQoNCkFzIHN1Y2gsIHdlIHNlbGVjdGVkIGEgbXVjaCBz
YWZlciBwYXRoLCB0aGF0IG9wZXJhdGlvbmFsLCBkZXZlbG9wbWVudCBhbmQgZGVwbG95bWVudCBv
ZiB0d28gZGlmZmVyZW50IGRyaXZlcnMgKG5ldGRldiB2cyBpYl9kZXYpIG11Y2ggZWFzaWVyIGJ1
dCBleHBvc2luZyB0aGUgbmljIGFzIHR3byBkaWZmZXJlbnQgUGh5c2ljYWwgZnVuY3Rpb25zL2Rl
dmljZXMNCg0KT25seSBjb3N0IHdlIGhhdmUgaXMgdGhhdCB3ZSBuZWVkIHRoaXMgZXh0cmEgcHJv
cHJpZXR5IHRvIGhlbHAgdXNlciBpZGVudGlmeSB3aGljaCB0d28gZGV2aWNlcyBhcmUgcmVsYXRl
ZCBoZW5jZSBTYW1paCdzIGNvbW1lbnRzDQogICAgDQoNCg==

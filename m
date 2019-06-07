Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04FDF3825C
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 03:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbfFGBET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 21:04:19 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:56847 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbfFGBET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 21:04:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559869458; x=1591405458;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4wDHjroz1B1yK4YAlpOJj27T14xFJjjONYzbEFanTiQ=;
  b=NUPQ3yJj1Sx1W+nwxuKHLpPtjnu7M+Tg5v8W1kh1B9rX+CmiCu34nsKw
   Y8in5Jp2tNmr/0EceRTi1PYQNXo/j/L/2BlttKtCnCqhmZpsp+Shr9vru
   azy5R97tJrqQH+6LYVDrpcaXE76eSbzP9nP/fGPVl3dpoUPevY0WlaaQm
   c=;
X-IronPort-AV: E=Sophos;i="5.60,561,1549929600"; 
   d="scan'208";a="678626680"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 07 Jun 2019 01:04:17 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 45535242AF4;
        Fri,  7 Jun 2019 01:04:15 +0000 (UTC)
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 7 Jun 2019 01:04:15 +0000
Received: from EX13D04EUB002.ant.amazon.com (10.43.166.51) by
 EX13D11EUB003.ant.amazon.com (10.43.166.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 7 Jun 2019 01:04:14 +0000
Received: from EX13D04EUB002.ant.amazon.com ([10.43.166.51]) by
 EX13D04EUB002.ant.amazon.com ([10.43.166.51]) with mapi id 15.00.1367.000;
 Fri, 7 Jun 2019 01:04:14 +0000
From:   "Bshara, Nafea" <nafea@amazon.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
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
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH V2 net 00/11] Extending the ena driver to support new
 features and enhance performance
Thread-Topic: [PATCH V2 net 00/11] Extending the ena driver to support new
 features and enhance performance
Thread-Index: AQHVGhq67AG/toDzFEuJgXAZxcdpDaaKc16AgAAPeQCAAAorgIAALp+AgAAG49KAAE7pAIAArv0AgAKvMgCAAHNcAP//1FmAgAB8GACAAA7HaYAAAvQAgAADxoeAAAXVgIAAFuSi
Date:   Fri, 7 Jun 2019 01:04:14 +0000
Message-ID: <9057E288-28BA-4865-B41A-5847EE41D66F@amazon.com>
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
        <35E875B8-FAE8-4C6A-BA30-FB3E2F7BA66B@amazon.com>,<20190606164219.10dca54e@cakuba.netronome.com>
In-Reply-To: <20190606164219.10dca54e@cakuba.netronome.com>
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

DQoNClNlbnQgZnJvbSBteSBpUGhvbmUNCg0KT24gSnVuIDYsIDIwMTksIGF0IDQ6NDMgUE0sIEph
a3ViIEtpY2luc2tpIDxqYWt1Yi5raWNpbnNraUBuZXRyb25vbWUuY29tPiB3cm90ZToNCg0KPj4+
IE9rYXksIHRoZW4geW91IGtub3cgd2hpY2ggb25lIGlzIHdoaWNoLiAgQXJlIHRoZXJlIG11bHRp
cGxlIEVOQXMgYnV0DQo+Pj4gb25lIEVGQT8NCj4+IA0KPj4gWWVzLCAgdmVyeSBwb3NzaWJsZS4g
VmVyeSBjb21tb24NCj4+IA0KPj4gVHlwaWNhbCB1c2UgY2FzZSB0aGF0IGluc3RhbmNlcyBoYXZl
IG9uZSBlbmEgZm9yIGNvbnRyb2wgcGxhbmUsIG9uZQ0KPj4gZm9yIGludGVybmV0IGZhY2luZyAs
IGFuZCBvbmUgMTAwRyBlbmEgdGhhdCBhbHNvIGhhdmUgZWZhIGNhcGFiaWxpdGllcw0KPiANCj4g
SSBzZWUsIGFuZCB0aG9zZSBhcmUgUENJIGRldmljZXMuLiAgU29tZSBmb3JtIG9mIHBsYXRmb3Jt
IGRhdGEgd291bGQNCj4gc2VlbSBsaWtlIHRoZSBiZXN0IGZpdCB0byBtZS4gIFRoZXJlIGlzIHNv
bWV0aGluZyBjYWxsZWQ6DQo+IA0KPiAvc3lzL2J1cy9wY2kvJHtkYmRmfS9sYWJlbA0KPiANCj4g
SXQgc2VlbXMgdG8gY29tZSBmcm9tIHNvbWUgQUNQSSB0YWJsZSAtIERTTSBtYXliZT8gIEkgdGhp
bmsgeW91IGNhbiBwdXQNCj4gd2hhdGV2ZXIgc3RyaW5nIHlvdSB3YW50IHRoZXJlIPCfpJQNCg0K
QWNwaSBwYXRoIHdvbuKAmXQgd29yaywgbXVjaCBvZiB0aGVlIGludGVyZmFjZSBhcmUgaG90IGF0
dGFjaGVkLCB1c2luZyBuYXRpdmUgcGNpZSBob3QgcGx1ZyBhbmQgYWNwaSB3b27igJl0IGJlIGlu
dm9sdmVkLiA=

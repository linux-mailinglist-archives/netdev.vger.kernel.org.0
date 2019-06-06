Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C670381BF
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 01:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbfFFXVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 19:21:31 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:9314 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFFXVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 19:21:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559863290; x=1591399290;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IdYGVoInfzzoWz1AMrqj4yuZIDKIT5ISkrJ/D75VbHo=;
  b=PuWwx2YsjUjxozB3T8djBoJa0tcT7pivOoINUwU8SO7am2UcgSMM1aF7
   ZU1/vI3qCr/ORxhY6iExqAudJ3It0YEln2/miO3TqojG3JynuuEP+9DkI
   7A2lXZn30xUujVTJlDGBCPXBYLBoYrTSsla+I803oRSOr9MPCgqjJOU6d
   c=;
X-IronPort-AV: E=Sophos;i="5.60,561,1549929600"; 
   d="scan'208";a="769343721"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 06 Jun 2019 23:21:28 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id B97C0A24A6;
        Thu,  6 Jun 2019 23:21:27 +0000 (UTC)
Received: from EX13D22EUB001.ant.amazon.com (10.43.166.145) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 6 Jun 2019 23:21:27 +0000
Received: from EX13D04EUB002.ant.amazon.com (10.43.166.51) by
 EX13D22EUB001.ant.amazon.com (10.43.166.145) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 6 Jun 2019 23:21:26 +0000
Received: from EX13D04EUB002.ant.amazon.com ([10.43.166.51]) by
 EX13D04EUB002.ant.amazon.com ([10.43.166.51]) with mapi id 15.00.1367.000;
 Thu, 6 Jun 2019 23:21:26 +0000
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
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Subject: Re: [PATCH V2 net 00/11] Extending the ena driver to support new
 features and enhance performance
Thread-Topic: [PATCH V2 net 00/11] Extending the ena driver to support new
 features and enhance performance
Thread-Index: AQHVGhq67AG/toDzFEuJgXAZxcdpDaaKc16AgAAPeQCAAAorgIAALp+AgAAG49KAAE7pAIAArv0AgAKvMgCAAHNcAP//1FmAgAB8GACAAA7HaYAAAvQAgAADxoc=
Date:   Thu, 6 Jun 2019 23:21:25 +0000
Message-ID: <35E875B8-FAE8-4C6A-BA30-FB3E2F7BA66B@amazon.com>
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
        <861B5CF2-878E-4610-8671-9D66AB61ABD7@amazon.com>,<20190606160756.73fe4c06@cakuba.netronome.com>
In-Reply-To: <20190606160756.73fe4c06@cakuba.netronome.com>
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

DQoNClNlbnQgZnJvbSBteSBpUGhvbmUNCg0KPiBPbiBKdW4gNiwgMjAxOSwgYXQgNDowOCBQTSwg
SmFrdWIgS2ljaW5za2kgPGpha3ViLmtpY2luc2tpQG5ldHJvbm9tZS5jb20+IHdyb3RlOg0KPiAN
Cj4gT24gVGh1LCA2IEp1biAyMDE5IDIyOjU3OjIxICswMDAwLCBCc2hhcmEsIE5hZmVhIHdyb3Rl
Og0KPj4+IEhhdmluZyBzYWlkIHRoYXQsIGl0J3MgZW50aXJlbHkgdW5jbGVhciB0byBtZSB3aGF0
IHRoZSB1c2VyIHNjZW5hcmlvIGlzDQo+Pj4gaGVyZS4gIFlvdSBzYXkgIndoaWNoIHR3byBkZXZp
Y2VzIHJlbGF0ZWQiLCB5ZXQgeW91IG9ubHkgaGF2ZSBvbmUgYml0LA0KPj4+IHNvIGl0IGNhbiBp
bmRpY2F0ZSB0aGF0IHRoZXJlIGlzIGFub3RoZXIgZGV2aWNlLCBub3QgX3doaWNoXyBkZXZpY2Ug
aXMNCj4+PiByZWxhdGVkLiAgSW5mb3JtYXRpb24geW91IGNhbiBmdWxsIHdlbGwgZ2V0IGZyb20g
cnVubmluZyBsc3BjaSDwn6S3DQo+Pj4gRG8gdGhlIGRldmljZXMgaGF2ZSB0aGUgc2FtZSBQQ0kg
SUQvdmVuZG9yOm1vZGVsPyAgDQo+PiANCj4+IERpZmZlcmVudCBtb2RlbCBpZA0KPiANCj4gT2th
eSwgdGhlbiB5b3Uga25vdyB3aGljaCBvbmUgaXMgd2hpY2guICBBcmUgdGhlcmUgbXVsdGlwbGUg
RU5BcyBidXQNCj4gb25lIEVGQT8NCj4gDQoNClllcywgIHZlcnkgcG9zc2libGUuIFZlcnkgY29t
bW9uDQoNClR5cGljYWwgdXNlIGNhc2UgdGhhdCBpbnN0YW5jZXMgaGF2ZSBvbmUgZW5hIGZvciBj
b250cm9sIHBsYW5lLCBvbmUgZm9yIGludGVybmV0IGZhY2luZyAsIGFuZCBvbmUgMTAwRyBlbmEg
dGhhdCBhbHNvIGhhdmUgZWZhIGNhcGFiaWxpdGllcw0KDQo+PiBXaWxsIGxvb2sgaW50byBzeXNm
cyANCj4gDQo+IEkgc3RpbGwgZG9uJ3QgdW5kZXJzdGFuZCB3aGF0IGlzIHRoZSBwcm9ibGVtIHlv
dSdyZSB0cnlpbmcgdG8gc29sdmUsDQo+IHBlcmhhcHMgcGh5c19wb3J0X2lkIGlzIHRoZSB3YXkg
dG8gZ28uLi4NCj4gDQo+IA0KPiBUaGUgbGFyZ2VyIHBvaW50IGhlcmUgaXMgdGhhdCB3ZSBjYW4n
dCBndWlkZSB5b3UgdG8gdGhlIHJpZ2h0IEFQSQ0KPiB1bmxlc3Mgd2Uga25vdyB3aGF0IHlvdSdy
ZSB0cnlpbmcgdG8gYWNoaWV2ZS4gIEFuZCB3ZSBkb24ndCBoYXZlIA0KPiB0aGUgc2xpZ2h0ZXN0
IGNsdWUgb2Ygd2hhdCdyZSB0cnlpbmcgdG8gYWNoaWV2ZSBpZiB1QVBJIGlzIGZvcndhcmRlZCAN
Cj4gdG8gdGhlIGRldmljZS4gIA0KPiANCj4gSG9uZXN0bHkgdGhpcyBpcyB3b3JzZSwgYW5kIHdh
eSBtb3JlIGJhc2ljIHRoYW4gSSB0aG91Z2h0LCBJIHRoaW5rDQo+IDMxNWMyOGQyYjcxNCAoIm5l
dDogZW5hOiBldGh0b29sOiBhZGQgZXh0cmEgcHJvcGVydGllcyByZXRyaWV2YWwgdmlhIGdldF9w
cml2X2ZsYWdzIikNCj4gbmVlZHMgdG8gYmUgcmV2ZXJ0ZWQuDQoNCkxldOKAmXMgbm90IGRvIHRo
YXQgdW50aWwgd2UgZmluaXNoIHRoaXMgZGlzY3Vzc2lvbiBhbmQgZXhwbGFpbiB0aGUgdmFyaW91
cyB1c2UgY2FzZXM=

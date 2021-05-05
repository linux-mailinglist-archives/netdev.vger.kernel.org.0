Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88ED53737A4
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 11:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbhEEJhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 05:37:47 -0400
Received: from mailgw02.mediatek.com ([216.200.240.185]:52258 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbhEEJhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 05:37:46 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 May 2021 05:37:46 EDT
X-UUID: f8b40e87745347dd948baa84fdc9793e-20210505
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=wGIu9D0K3g9b5WCqbKTXiSpOw9BUQsnxsil9kutRcfg=;
        b=X9nDReORDPz35r0ccML3pdh8YdbJ+qSLYPjvgG2nLM2OpyOgokoqyxhqsm8mZhHeoHqgwOJkjNjDMVQgiDR8RFQHdsRVGZYtVwbeQKDmmtAlwIKfhG9bvI5HPLyO4mzIrEUhERJOz0FYLaz779c4/O4jk1OYtALNdirtUC+ZuRw=;
X-UUID: f8b40e87745347dd948baa84fdc9793e-20210505
Received: from mtkcas66.mediatek.inc [(172.29.193.44)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1997269144; Wed, 05 May 2021 02:31:45 -0700
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 MTKMBS62N1.mediatek.inc (172.29.193.41) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 5 May 2021 02:31:43 -0700
Received: from mtksdccf07 (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 5 May 2021 17:31:42 +0800
Message-ID: <fc962daf8b7babc22b043b2b0878a206780b55f3.camel@mediatek.com>
Subject: Re: Re: Re: Re: [PATCH net-next 0/4] MT7530 interrupt support
From:   Landen Chao <landen.chao@mediatek.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>
CC:     DENG Qingfang <dqfext@gmail.com>,
        David Miller <davem@davemloft.net>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <matthias.bgg@gmail.com>, <linux@armlinux.org.uk>,
        <sean.wang@mediatek.com>, <vivien.didelot@gmail.com>,
        <olteanv@gmail.com>, <robh+dt@kernel.org>,
        <linus.walleij@linaro.org>, <gregkh@linuxfoundation.org>,
        <sergio.paracuellos@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-staging@lists.linux.dev>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <weijie.gao@mediatek.com>,
        <gch981213@gmail.com>, <opensource@vdorst.com>,
        <tglx@linutronix.de>, <maz@kernel.org>
Date:   Wed, 5 May 2021 17:31:43 +0800
In-Reply-To: <YIwxpYD1jnFMPQz+@lunn.ch>
References: <20210429062130.29403-1-dqfext@gmail.com>
         <20210429.170815.956010543291313915.davem@davemloft.net>
         <20210430023839.246447-1-dqfext@gmail.com> <YIv28APpOP9tnuO+@lunn.ch>
         <trinity-843c99ce-952a-434e-95e4-4ece3ba6b9bd-1619786236765@3c-app-gmx-bap03>
         <YIv7w8Wy81fmU5A+@lunn.ch>
         <trinity-611ff023-c337-4148-a215-98fd5604eac2-1619787382934@3c-app-gmx-bap03>
         <YIwCliT5NZT713WD@lunn.ch>
         <trinity-c45bbeec-5b7c-43a2-8e86-7cb22ad61558-1619794787680@3c-app-gmx-bap03>
         <YIwxpYD1jnFMPQz+@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTA0LTMwIGF0IDE4OjM0ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
PiBtaG0sIG1heWJlIHRoZSBuYW1pbmcgc2hvdWxkIGRpZmZlciBpZiBnZW5lcmljIHBoeSBhbmQg
bmV0LXBoeSBhcmUNCj4gPiB0aGF0IGRpZmZlcmVudC4gaSBndWVzcyB0aGVyZSBpcyBubyB3YXkg
dG8gbWVyZ2UgdGhlIG5ldCBwaHlzIHRvDQo+ID4gdGhlDQo+ID4gZ2VuZXJpYyBwaHlzIChkdWUg
dG8gbGlua2luZyB0byB0aGUgbmV0IGRldmljZSBkcml2ZXJzKSB0byBoYXZlDQo+ID4gb25seQ0K
PiA+IDEgcGh5IHNlY3Rpb24sIHJpZ2h0Pw0KPiANCj4gcGh5cyBhbmQgZ2VuZXJpYyBQSFlzIGFy
ZSB2ZXJ5IGRpZmZlcmVudCB0aGluZ3MsIGNvbXBsZXRlbHkgZGlmZmVyZW50DQo+IEFQSSBldGMu
IFRoZXkgY2Fubm90IGJlIG1lcmdlZC4NCj4gDQo+ID4gYnV0IGlmIHBoeS0gcHJlZml4IGlzIHVz
ZWQgYnkgZ2VuZXJpYyBwaHlzLCBtYXliZSBldGgtIG9yIG5ldC0gY2FuDQo+ID4gYmUgdXNlZCBo
ZXJlIChtYXliZSB3aXRoICJwaHkiIGFkZGVkKQ0KPiA+IA0KPiA+IHNvbWV0aGluZyBsaWtlDQo+
ID4gDQo+ID4gZXRoLXBoeS1tdDc1M3gua28NCkhvdyBhYm91dCB1c2luZyBtZWRpYXRlay1nZS5r
by4gJ2dlJyBpcyB0aGUgYWJicmV2aWF0aW9uIG9mIGdpZ2FiaXQNCkV0aGVybmV0LiBNb3N0IG1l
ZGlhdGVrIHByb2R1Y3RzIHVzZSB0aGUgc2FtZSBnaWdhYml0IEV0aGVybmV0IHBoeS4NCg0KTGFu
ZGVuDQo+ID4gDQo+ID4gZWxzZSBpIGhhdmUgbm8gaWRlYSBub3cuLi5teSBwYXRjaCByZW5hbWlu
ZyB0aGUgbXVzYi1tb2R1bGUgc2VlbXMNCj4gPiBub3QNCj4gPiB0byBiZSBhY2NlcHRlZCBkdWUg
dG8gcG9zc2libGUgYnJlYWthZ2UNCj4gDQo+IFRoZSB1c2IgbW9kdWxlIGhhcyBiZWVuIGFyb3Vu
ZCBmb3IgYSBsb25nIHRpbWUsIHNvIGl0IGNhbm5vdCBiZQ0KPiBjaGFuZ2VkLiBUaGUgcGh5IGRy
aXZlciBpcyBuZXcsIG5vdCBpbiBhIHJlbGVhc2VkIGtlcm5lbC4gU28gd2UgY2FuDQo+IHN0aWxs
IHJlbmFtZSBpdCB3aXRob3V0IGNhdXNpbmcgcHJvYmxlbXMuDQo+IA0KPiBJIHN0aWxsIHdhbnQg
dG8gdW5kZXJzdGFuZCB0aGUgbmFtaW5nIGhlcmUuIElmIHlvdSBsb29rIGF0IG1vc3QNCj4gRXRo
ZXJuZXQgc3dpdGNoZXMgd2l0aCBpbnRlZ3JhdGVkIFBIWXMsIHRoZSBQSFlzIGhhdmUgdGhlaXIg
b3duDQo+IG5hbWluZw0KPiBzY2hlbWUsIHNlcGFyYXRlIGZyb20gdGhlIHN3aXRjaCwgYmVjYXVz
ZSB0aGV5IGFyZSBpbmRlcGVuZGVudCBJUC4gU28NCj4gaSB3b3VsZCBwcmVmZXIgdGhpcyBkcml2
ZXIgYnkgbmFtZWQgYWZ0ZXIgdGhlIFBIWSBuYW1lLCBub3QgdGhlDQo+IHN3aXRjaA0KPiBuYW1l
LiBUaGF0IG1pZ2h0IHNvbHZlIHRoZSBuYW1pbmcgY29uZmxpY3QsIG10MTIzeCBmb3IgdGhlIFBI
WSwNCj4gbXQ3NTMwDQo+IGZvciB0aGUgc3dpdGNoIGRyaXZlci4NCj4gDQo+IAlBbmRyZXcNCg==


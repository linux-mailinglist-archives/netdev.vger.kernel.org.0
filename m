Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D31411BA76
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 18:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730157AbfLKRiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 12:38:05 -0500
Received: from mailgw01.mediatek.com ([216.200.240.184]:48911 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729912AbfLKRiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 12:38:04 -0500
X-UUID: d81845a974bf4976925fb686cac3625e-20191211
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=1G2ecBdsGiCmLvqUgkfBXFA90ZxkA0MFjUV6DWvTWiU=;
        b=DGwWSWUpOHud9U+BecPSZboTGtDN5+pl0bibZT0pvigmxn/OxFgM2hdKQfzgIkbgTdICIdqDJodzNWyLbb3MUsUQJzA1hUZANcIGQIyoAkkYPoxuQVyRuVeRASpaIEHiICrbSoDTpFRARrOSbLzqielxESeWNnEEA9JkI2/ij5M=;
X-UUID: d81845a974bf4976925fb686cac3625e-20191211
Received: from mtkcas66.mediatek.inc [(172.29.193.44)] by mailgw01.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 217714657; Wed, 11 Dec 2019 09:38:01 -0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 MTKMBS62N1.mediatek.inc (172.29.193.41) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 11 Dec 2019 09:36:52 -0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 12 Dec 2019 01:35:41 +0800
Message-ID: <1576085745.23763.53.camel@mtksdccf07>
Subject: Re: [PATCH net-next 4/6] net: dsa: mt7530: Add the support of
 MT7531 switch
From:   Landen Chao <landen.chao@mediatek.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@savoirfairelinux.com" 
        <vivien.didelot@savoirfairelinux.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sean Wang <Sean.Wang@mediatek.com>,
        "opensource@vdorst.com" <opensource@vdorst.com>,
        "frank-w@public-files.de" <frank-w@public-files.de>
Date:   Thu, 12 Dec 2019 01:35:45 +0800
In-Reply-To: <20191210163557.GC27714@lunn.ch>
References: <cover.1575914275.git.landen.chao@mediatek.com>
         <6d608dd024edc90b09ba4fe35417b693847f973c.1575914275.git.landen.chao@mediatek.com>
         <20191210163557.GC27714@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpPbiBXZWQsIDIwMTktMTItMTEgYXQgMDA6MzUgKzA4MDAsIEFuZHJldyBM
dW5uIHdyb3RlOg0KPiBPbiBUdWUsIERlYyAxMCwgMjAxOSBhdCAwNDoxNDo0MFBNICswODAwLCBM
YW5kZW4gQ2hhbyB3cm90ZToNCj4gPiBBZGQgbmV3IHN1cHBvcnQgZm9yIE1UNzUzMToNCj4gPiAN
Cj4gPiBNVDc1MzEgaXMgdGhlIG5leHQgZ2VuZXJhdGlvbiBvZiBNVDc1MzAuIEl0IGlzIGFsc28g
YSA3LXBvcnRzIHN3aXRjaCB3aXRoDQo+ID4gNSBnaWdhIGVtYmVkZGVkIHBoeXMsIDIgY3B1IHBv
cnRzLCBhbmQgdGhlIHNhbWUgTUFDIGxvZ2ljIG9mIE1UNzUzMC4gQ3B1DQo+ID4gcG9ydCA2IG9u
bHkgc3VwcG9ydHMgSFNHTUlJIGludGVyZmFjZS4gQ3B1IHBvcnQgNSBzdXBwb3J0cyBlaXRoZXIg
UkdNSUkNCj4gPiBvciBIU0dNSUkgaW4gZGlmZmVyZW50IEhXIHNrdS4NCj4gDQo+IEhpIExhbmRl
bg0KPiANCj4gTG9va2luZyBhdCB0aGUgY29kZSwgeW91IHNlZW0gdG8gdHJlYXQgSFNHTUlJIGFz
IDI1MDBCYXNlLVguIElzIHRoaXMNCj4gY29ycmVjdD8gT3IgaXMgaXQgU0dNSUkgb3ZlciBjbG9j
a2VkIHRvIDIuNUdicHM/DQpBZnRlciByZS1yZWFkIE1UNzYyMiB0cmVhZFswXSBhZ2FpbiwgYW5k
IGFjY29yZGluZyB0byB0aGUgY29uZmlndXJhYmxlDQpwYXJ0IG9mIHRoaXMgSVAsIGl0IGlzIGNs
b3NlciB0byAyNTAwQmFzZS1YIGRlZmluaXRpb246DQpgYFBIWV9JTlRFUkZBQ0VfTU9ERV8yNTAw
QkFTRVhgYA0KICAgIFRoaXMgZGVmaW5lcyBhIHZhcmlhbnQgb2YgMTAwMEJBU0UtWCB3aGljaCBp
cyBjbG9ja2VkIDIuNSB0aW1lcw0KZmFzdGVyLCB0aGFuIHRoZSA4MDIuMyBzdGFuZGFyZCBnaXZp
bmcgYSBmaXhlZCBiaXQgcmF0ZSBvZiAzLjEyNUdiYXVkLg0KDQpJZiBIU0dNSUkgbWVhbnMgU0dN
SUkgb3ZlciBjbG9ja2VkIHRvIDIuNUdicHMsIHRoZSBpbnRyb2R1Y3Rpb24gbmVlZHMgdG8NCmJl
IGNoYW5nZWQgdG8gInN1cHBvcnQgU0dNSUkvMTAwMEJhc2UtWC8yNTAwQmFzZS14Ii4NCg0KWzBd
Og0KaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wYXRjaC8xMTA1NzUyNy8NCj4gDQo+IAkg
QW5kcmV3DQoNClJlZ2FyZHMgTGFuZGVuDQo=


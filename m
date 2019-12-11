Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED51D11BBB7
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731301AbfLKS2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:28:11 -0500
Received: from mailgw02.mediatek.com ([216.200.240.185]:58549 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731155AbfLKS2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:28:09 -0500
X-UUID: 51a9bce2e8cd4f61ab5a3414b952c729-20191211
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=DayJ7MQWQ4RP+Xy9OFTguKUS9uFN/Vn4kGqH3oJR+Hs=;
        b=RjHN9U0eQTpQs/XOW7GXxK7+TRHWYSLdznZmKzSoGVyKknnlsf8ILFhfqLBjAXp82huinTHDXuejodmE9mX/qzTQ++4N4pKaJ4BsSBlUg79tmtgrg0WlXUD4iYvkAvPzkHsJGRX90CZqzL21iAz/OhpSzm8O0AWPb1WdxdQqpiU=;
X-UUID: 51a9bce2e8cd4f61ab5a3414b952c729-20191211
Received: from mtkcas66.mediatek.inc [(172.29.193.44)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 766005550; Wed, 11 Dec 2019 10:28:05 -0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 MTKMBS62DR.mediatek.inc (172.29.94.18) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 11 Dec 2019 10:27:43 -0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 12 Dec 2019 02:27:23 +0800
Message-ID: <1576088846.23763.80.camel@mtksdccf07>
Subject: Re: [PATCH net-next 5/6] arm64: dts: mt7622: add mt7531 dsa to
 mt7622-rfb1 board
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
Date:   Thu, 12 Dec 2019 02:27:26 +0800
In-Reply-To: <20191210165149.GF27714@lunn.ch>
References: <cover.1575914275.git.landen.chao@mediatek.com>
         <7f5a690281664a0fe47cfe7726f26d7f6211d015.1575914275.git.landen.chao@mediatek.com>
         <20191210165149.GF27714@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTEyLTExIGF0IDAwOjUxICswODAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
PiArCQkJCXBvcnRANiB7DQo+ID4gKwkJCQkJcmVnID0gPDY+Ow0KPiA+ICsJCQkJCWxhYmVsID0g
ImNwdSI7DQo+ID4gKwkJCQkJZXRoZXJuZXQgPSA8JmdtYWMwPjsNCj4gPiArCQkJCQlwaHktbW9k
ZSA9ICIyNTAwYmFzZS14IjsNCj4gPiArDQo+ID4gKwkJCQkJZml4ZWQtbGluayB7DQo+ID4gKwkJ
CQkJCXNwZWVkID0gPDI1MDA+Ow0KPiA+ICsJCQkJCQlmdWxsLWR1cGxleDsNCj4gPiArCQkJCQkJ
cGF1c2U7DQo+ID4gKwkJCQkJfTsNCj4gDQo+IFRoaXMgZml4ZWQtbGluayBzaG91bGQgbm90IGJl
IG5lZWRlZC4gVGhlIERTQSBkcml2ZXIgaXMgc3VwcG9zZWQgdG8NCj4gY29uZmlndXJlIHRoZSBD
UFUgcG9ydCB0byBpdHMgZmFzdGVzdCBzcGVlZCBieSBkZWZhdWx0LiAyNTAwIGlzDQo+IHRoZSBm
YXN0ZXN0IHNwZWVkIGEgMjUwMEJhc2UtWCBsaW5rIGNhbiBkby4uLg0KSSdsbCBhZGQgdGhlIGNw
dSBwb3J0IGxvZ2ljIHRvIHVzZSB0aGUgZmFzdGVzdCBzcGVlZCBieSBkZWZhdWx0Lg0KSXQgYWxz
byBuZWVkcyB0byBtb2RpZnkgdGhlIG10NzUzeF9waHlsaW5rX21hY19jb25maWcoKSBsb2dpYy4N
Cg0KTGFuZGVuDQo+IA0KPiAgICAgQW5kcmV3DQoNCg==


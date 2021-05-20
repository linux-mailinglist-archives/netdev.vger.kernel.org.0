Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC88389ED9
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 09:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhETHXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 03:23:38 -0400
Received: from mailgw02.mediatek.com ([216.200.240.185]:58961 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbhETHXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 03:23:35 -0400
X-UUID: 061f921aa6cc47a083df4dae5b853384-20210520
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=ZQ3X2kKIVdd7QGc0Obd6FYCQ+lslLAxE4v/TzH04zFg=;
        b=EJhtKMJHSLLT7k+TjsgkVYl5TweyxXs7MXcMNVdXRMnyOQxzmuKghYKfKjn6JwLDo1+MD9EAGJJeX2oGS0nY+U3rRYxYZ1Zp4z0Bz0VgSWFQ9a0NGv3hycwnnfYhxtYYiGKu6o1O5ruGvUiA8BvYG+aAOPbrwrBvXshmqREB1RE=;
X-UUID: 061f921aa6cc47a083df4dae5b853384-20210520
Received: from mtkcas66.mediatek.inc [(172.29.193.44)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 828172061; Thu, 20 May 2021 00:22:12 -0700
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 MTKMBS62DR.mediatek.inc (172.29.94.18) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 20 May 2021 00:13:21 -0700
Received: from mtksdccf07 (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 20 May 2021 15:13:20 +0800
Message-ID: <0adde34f936a2dafca40b06b408d82afe0852327.camel@mediatek.com>
Subject: Re: [PATCH net-next v2 1/4] net: phy: add MediaTek Gigabit Ethernet
 PHY driver
From:   Landen Chao <landen.chao@mediatek.com>
To:     DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-staging@lists.linux.dev>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?ISO-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        "Frank Wunderlich" <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Date:   Thu, 20 May 2021 15:13:20 +0800
In-Reply-To: <20210520023828.3261270-1-dqfext@gmail.com>
References: <20210519033202.3245667-1-dqfext@gmail.com>
         <20210519033202.3245667-2-dqfext@gmail.com> <YKW0acoyM+5rVp0X@lunn.ch>
         <20210520023828.3261270-1-dqfext@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTA1LTIwIGF0IDEwOjM4ICswODAwLCBERU5HIFFpbmdmYW5nIHdyb3RlOg0K
PiBPbiBUaHUsIE1heSAyMCwgMjAyMSBhdCAwMjo1OToyMUFNICswMjAwLCBBbmRyZXcgTHVubiB3
cm90ZToNCj4gPiA+ICtzdGF0aWMgdm9pZCBtdGtfZ2VwaHlfY29uZmlnX2luaXQoc3RydWN0IHBo
eV9kZXZpY2UgKnBoeWRldikNCj4gPiA+ICt7DQo+ID4gPiArCS8qIERpc2FibGUgRUVFICovDQo+
ID4gPiArCXBoeV93cml0ZV9tbWQocGh5ZGV2LCBNRElPX01NRF9BTiwgTURJT19BTl9FRUVfQURW
LCAwKTsNCj4gPiANCj4gPiBJcyBFRUUgYnJva2VuIG9uIHRoaXMgUEhZPyBPciBpcyB0aGlzIGp1
c3QgdG8gZ2V0IGl0IGludG8gYSBkZWZpbmVkDQo+ID4gc3RhdGU/DQo+IA0KPiBBcyBJIHNhaWQg
aW4gY29tbWl0IG1lc3NhZ2UsIHRoZSBpbml0aWFsaXphdGlvbiAoaW5jbHVkaW5nIEVFRSkgaXMN
Cj4gZnJvbSB0aGUgdmVuZG9yIGRyaXZlci4NCj4gSSBoYXZlIGFsc28gdGVzdGVkIGl0IHdpdGgg
RUVFIGVuYWJsZWQgYnkgZGVmYXVsdCBvbiBvbmUgb2YgbXkgQVBzLA0KPiBhbmQgZ290IG9jY2Fz
aW9uYWwgbGluayBkcm9wcy4NCj4gDQoNCkVFRSBvZiB0aGUgMTAteWVhci1vbGQgTVQ3NTMwIGlu
dGVybmFsIGdlcGh5IGhhcyBtYW55IElPVCBwcm9ibGVtcywgc28NCml0IGlzIHJlY29tbWVuZGVk
IHRvIGRpc2FibGUgaXRzIEVFRS4NCkVFRSBvZiB0aGUgTVQ3NTMxIGludGVybmFsIGdlcGh5IGhh
cyBiZWVuIHVwZGF0ZWQsIGJ1dCBpdCBpcyBub3QgeWV0DQp3aWRlbHkgdXNlZC4NClRoZXJlZm9y
ZSwgRUVFIGlzIGRpc2FibGVkIGluIHZlbmRvciBkcml2ZXIuDQoNCkxhbmRlbg0KPiA+IE90aGVy
d2lzZQ0KPiA+IA0KPiA+IFJldmlld2VkLWJ5OiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+
DQo+ID4gDQo+ID4gICAgIEFuZHJldw0K


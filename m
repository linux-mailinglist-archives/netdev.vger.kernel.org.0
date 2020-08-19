Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8FE82499A0
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 11:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgHSJuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 05:50:40 -0400
Received: from mailgw02.mediatek.com ([216.200.240.185]:48161 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbgHSJui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 05:50:38 -0400
X-UUID: 1192dd65be0d4c80beae905e55f63a14-20200819
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=uVPKfloKa5GwHkVwJn0RmJIN/Tl5KQ2eePuutn7nOAQ=;
        b=dO+ybYB+ZMfqyhqSrEgUhWB1eHCNrnIY6xxoB3vofGTLCkPYzK6UTQ5+eX7J5fAjYkReioch2SFCdpfxTbheDMfYAHtdAJqlPmzqgKoFqByQrNJyroDW9XgOBdBoMgGxcQMUKJBwOvfvgIu3GWaW5hRnoKZeF/CAqdHthkbPO0w=;
X-UUID: 1192dd65be0d4c80beae905e55f63a14-20200819
Received: from mtkcas67.mediatek.inc [(172.29.193.45)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 687292246; Wed, 19 Aug 2020 01:50:31 -0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 MTKMBS62N2.mediatek.inc (172.29.193.42) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 19 Aug 2020 02:50:29 -0700
Received: from [172.21.84.99] (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 19 Aug 2020 17:50:28 +0800
Message-ID: <1597830629.31846.83.camel@mtksdccf07>
Subject: Re: [PATCH net-next v2 5/7] net: dsa: mt7530: Add the support of
 MT7531 switch
From:   Landen Chao <landen.chao@mediatek.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
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
        "frank-w@public-files.de" <frank-w@public-files.de>,
        "dqfext@gmail.com" <dqfext@gmail.com>
Date:   Wed, 19 Aug 2020 17:50:29 +0800
In-Reply-To: <20200818082347.353fe926@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1597729692.git.landen.chao@mediatek.com>
         <e980fda45e0fb478f55e72765643bb641f352c65.1597729692.git.landen.chao@mediatek.com>
         <20200818082347.353fe926@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFrdWIsDQoNClRoZXNlIDIgZnVuY3Rpb24gYXJlIHVzZWQgaW4gdGhlIHNhbWUgZmlsZSBv
bmx5Lg0KSSdsbCBmaXggd2FybmluZ3MgYnkgbWFraW5nIDIgZnVuY3Rpb25zICdzdGF0aWMnIGlu
IHYzLg0KDQpMYW5kZW4NCk9uIFR1ZSwgMjAyMC0wOC0xOCBhdCAyMzoyMyArMDgwMCwgSmFrdWIg
S2ljaW5za2kgd3JvdGU6DQpbc25pcF0NCj4gUGxlYXNlIGZpeCB0aGVzZSBXPTEgd2FybmluZ3M6
DQo+IA0KPiAuLi9kcml2ZXJzL25ldC9kc2EvbXQ3NTMwLmM6MTk3NjoxOiB3YXJuaW5nOiBubyBw
cmV2aW91cyBwcm90b3R5cGUgZm9yIOKAmG10NzUzMV9zZ21paV9saW5rX3VwX2ZvcmNl4oCZIFst
V21pc3NpbmctcHJvdG90eXBlc10NCj4gIDE5NzYgfCBtdDc1MzFfc2dtaWlfbGlua191cF9mb3Jj
ZShzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBwb3J0LA0KPiAgICAgICB8IF5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+DQo+IC4uL2RyaXZlcnMvbmV0L2RzYS9tdDc1MzAuYzoyMDgxOjY6IHdh
cm5pbmc6IG5vIHByZXZpb3VzIHByb3RvdHlwZSBmb3Ig4oCYbXQ3NTMxX3NnbWlpX3Jlc3RhcnRf
YW7igJkgWy1XbWlzc2luZy1wcm90b3R5cGVzXQ0KPiAgMjA4MSB8IHZvaWQgbXQ3NTMxX3NnbWlp
X3Jlc3RhcnRfYW4oc3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQgcG9ydCkNCj4gICAgICAgfCAg
ICAgIF5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+DQo+IC4uL2RyaXZlcnMvbmV0L2RzYS9tdDc1MzAu
YzoxOTc2OjE6IHdhcm5pbmc6IHN5bWJvbCAnbXQ3NTMxX3NnbWlpX2xpbmtfdXBfZm9yY2UnIHdh
cyBub3QgZGVjbGFyZWQuIFNob3VsZCBpdCBiZSBzdGF0aWM/DQo+IC4uL2RyaXZlcnMvbmV0L2Rz
YS9tdDc1MzAuYzoyMDgxOjY6IHdhcm5pbmc6IHN5bWJvbCAnbXQ3NTMxX3NnbWlpX3Jlc3RhcnRf
YW4nIHdhcyBub3QgZGVjbGFyZWQuIFNob3VsZCBpdCBiZSBzdGF0aWM/DQoNCg==


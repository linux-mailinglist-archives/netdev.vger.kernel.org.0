Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D27CD11AD29
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 15:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729790AbfLKOSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 09:18:05 -0500
Received: from mailgw02.mediatek.com ([216.200.240.185]:34817 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729671AbfLKOSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 09:18:05 -0500
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Dec 2019 09:18:05 EST
X-UUID: 8624b81f66794d988dc55291a6f9872d-20191211
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=Axc6RlNHq3r5/GnAxxkyvJrrLbwxm4JZnBh/iubqg2g=;
        b=WbANH9bYzqKU4Qs01Ukn8js+r5f8MbEjNt2YUOmrd+4dH1EUWHoeSRT23noh7xATcAUgWLA0dOpeNHH3ePSVC9qHWwXaczN1czCLKJrJyVlH2UuxGNiz7jkRrogCHYsyPgVjOVqQDdx5NbI5YWP9MN2xMuxagFE77qgsR4MXu6g=;
X-UUID: 8624b81f66794d988dc55291a6f9872d-20191211
Received: from mtkcas66.mediatek.inc [(172.29.193.44)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 118975065; Wed, 11 Dec 2019 06:12:55 -0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 MTKMBS62N2.mediatek.inc (172.29.193.42) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 11 Dec 2019 06:11:45 -0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 11 Dec 2019 22:10:42 +0800
Message-ID: <1576073444.23763.11.camel@mtksdccf07>
Subject: Re: [PATCH net-next 3/6] dt-bindings: net: dsa: add new MT7531
 binding to support MT7531
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
Date:   Wed, 11 Dec 2019 22:10:44 +0800
In-Reply-To: <20191210162010.GB27714@lunn.ch>
References: <cover.1575914275.git.landen.chao@mediatek.com>
         <1c382fd916b66bfe3ce8ef18c12f954dbcbddbbc.1575914275.git.landen.chao@mediatek.com>
         <20191210162010.GB27714@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpPbiBXZWQsIDIwMTktMTItMTEgYXQgMDA6MjAgKzA4MDAsIEFuZHJldyBM
dW5uIHdyb3RlOg0KPiA+ICtFeGFtcGxlIDQ6DQo+ID4gKw0KPiA+ICsmZXRoIHsNCj4gPiArCWdt
YWMwOiBtYWNAMCB7DQo+ID4gKwkJY29tcGF0aWJsZSA9ICJtZWRpYXRlayxldGgtbWFjIjsNCj4g
PiArCQlyZWcgPSA8MD47DQo+ID4gKwkJcGh5LW1vZGUgPSAiMjUwMGJhc2UteCI7DQo+ID4gKw0K
PiA+ICsJCWZpeGVkLWxpbmsgew0KPiA+ICsJCQlzcGVlZCA9IDwxMDAwPjsNCj4gPiArCQkJZnVs
bC1kdXBsZXg7DQo+ID4gKwkJCXBhdXNlOw0KPiA+ICsJCX07DQo+ID4gKwl9Ow0KPiANCj4gMjUw
MEJhc2UtWCwgYnV0IGZpeGVkIGxpbmsgc3BlZWQgMTAwMD8NCmZpeGVkLWxpbmsgc3BlZWQgc2hv
dWxkIGJlIDI1MDAuIEkgd2lsbCB1cGRhdGUgaXQuDQo+IA0KPiA+ICsJCQkJcG9ydEA2IHsNCj4g
PiArCQkJCQlyZWcgPSA8Nj47DQo+ID4gKwkJCQkJbGFiZWwgPSAiY3B1IjsNCj4gPiArCQkJCQll
dGhlcm5ldCA9IDwmZ21hYzA+Ow0KPiA+ICsJCQkJCXBoeS1tb2RlID0gIjI1MDBiYXNlLXgiOw0K
PiA+ICsNCj4gPiArCQkJCQlmaXhlZC1saW5rIHsNCj4gPiArCQkJCQkJc3BlZWQgPSA8MTAwMD47
DQo+ID4gKwkJCQkJCWZ1bGwtZHVwbGV4Ow0KPiA+ICsJCQkJCQlwYXVzZTsNCj4gPiArCQkJCQl9
Ow0KPiANCj4gU2FtZSBoZXJlIQ0KSSB3aWxsIHVwZGF0ZSBpdCBvciByZW1vdmUgZml4ZWQtbGlu
ayBibG9jayBhcyB0aGUgZGlzY3Vzc2lvbiBpbiBkdHMNCnRocmVhZC4NCj4gDQo+ICAgICAgQW5k
cmV3DQoNCnJlZ2FyZHMgTGFuZGVuDQo=


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B841249812
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 10:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgHSIPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 04:15:11 -0400
Received: from mailgw02.mediatek.com ([216.200.240.185]:43957 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgHSIPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 04:15:09 -0400
X-UUID: e63d220e6d6b41f697a4ae4aaa33dc7e-20200819
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=QpCVJ4N+EUwFvE449ymwTfmxve8XNAYqWnZtBe4BZEA=;
        b=TTPgISsfpcHTz1wn1542ppt7yDvS+sigVRpJ5bnyIPjKgbZvQckjKEqQFWY69joUd6hFcgWcTrX7jgcOaUIugl1DySfb1Kh/+kGqCnoEfM9kPikQKN6+aaH87hQpnvRr0hWe5zigEsYI2WXGM4Pf4bRVmQQWJbXxXAlV8vBVJ4Y=;
X-UUID: e63d220e6d6b41f697a4ae4aaa33dc7e-20200819
Received: from mtkcas68.mediatek.inc [(172.29.94.19)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 674850295; Wed, 19 Aug 2020 00:15:04 -0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 MTKMBS62N1.mediatek.inc (172.29.193.41) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 19 Aug 2020 01:15:02 -0700
Received: from [172.21.84.99] (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 19 Aug 2020 16:15:00 +0800
Message-ID: <1597824901.31846.42.camel@mtksdccf07>
Subject: Re: [PATCH net-next v2 7/7] arm64: dts: mt7622: add mt7531 dsa to
 bananapi-bpi-r64 board
From:   Landen Chao <landen.chao@mediatek.com>
To:     Vladimir Oltean <olteanv@gmail.com>
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
Date:   Wed, 19 Aug 2020 16:15:01 +0800
In-Reply-To: <20200818162433.elqh3dxmk6vilq6u@skbuf>
References: <cover.1597729692.git.landen.chao@mediatek.com>
         <2a986604b49f7bfbee3898c8870bb0cf8182e879.1597729692.git.landen.chao@mediatek.com>
         <20200818162433.elqh3dxmk6vilq6u@skbuf>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA4LTE5IGF0IDAwOjI0ICswODAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IE9uIFR1ZSwgQXVnIDE4LCAyMDIwIGF0IDAzOjE0OjEyUE0gKzA4MDAsIExhbmRlbiBDaGFv
IHdyb3RlOg0KPiA+IEFkZCBtdDc1MzEgZHNhIHRvIGJhbmFuYXBpLWJwaS1yNjQgYm9hcmQgZm9y
IDUgZ2lnYSBFdGhlcm5ldCBwb3J0cyBzdXBwb3J0Lg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6
IExhbmRlbiBDaGFvIDxsYW5kZW4uY2hhb0BtZWRpYXRlay5jb20+DQo+ID4gLS0tDQo+ID4gIC4u
Li9kdHMvbWVkaWF0ZWsvbXQ3NjIyLWJhbmFuYXBpLWJwaS1yNjQuZHRzICB8IDQ0ICsrKysrKysr
KysrKysrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDQ0IGluc2VydGlvbnMoKykNCj4gPiAN
Cj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9ib290L2R0cy9tZWRpYXRlay9tdDc2MjItYmFu
YW5hcGktYnBpLXI2NC5kdHMgYi9hcmNoL2FybTY0L2Jvb3QvZHRzL21lZGlhdGVrL210NzYyMi1i
YW5hbmFwaS1icGktcjY0LmR0cw0KPiA+IGluZGV4IGQxNzRhZDIxNDg1Ny4uYzU3YjI1NzExNjVm
IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQvYm9vdC9kdHMvbWVkaWF0ZWsvbXQ3NjIyLWJh
bmFuYXBpLWJwaS1yNjQuZHRzDQo+ID4gKysrIGIvYXJjaC9hcm02NC9ib290L2R0cy9tZWRpYXRl
ay9tdDc2MjItYmFuYW5hcGktYnBpLXI2NC5kdHMNCj4gPiBAQCAtMTQzLDYgKzE0Myw1MCBAQA0K
PiA+ICAJbWRpbzogbWRpby1idXMgew0KPiA+ICAJCSNhZGRyZXNzLWNlbGxzID0gPDE+Ow0KPiA+
ICAJCSNzaXplLWNlbGxzID0gPDA+Ow0KPiA+ICsNCj4gPiArCQlzd2l0Y2hAMCB7DQo+ID4gKwkJ
CWNvbXBhdGlibGUgPSAibWVkaWF0ZWssbXQ3NTMxIjsNCj4gPiArDQpbc25pcF0NCj4gPiArCQkJ
CXBvcnRANiB7DQo+ID4gKwkJCQkJcmVnID0gPDY+Ow0KPiA+ICsJCQkJCWxhYmVsID0gImNwdSI7
DQo+ID4gKwkJCQkJZXRoZXJuZXQgPSA8JmdtYWMwPjsNCj4gPiArCQkJCQlwaHktbW9kZSA9ICIy
NTAwYmFzZS14IjsNCj4gPiArCQkJCX07DQo+IA0KPiBJcyB0aGVyZSBhbnkgcmVhc29uIHdoeSB5
b3UncmUgbm90IHNwZWNpZnlpbmcgYSBmaXhlZC1saW5rIG5vZGUgaGVyZT8NCkkgZ290IHRoZSBi
ZWxvdyBmZWVkYmFjayBpbiB2MSwgc28gSSBmb2xsb3cgdGhlIERTQSBjb21tb24gZGVzaWduIGlu
IHYyLg0KdjIgY2FuIHdvcmsgd2l0aCBmaXhlZC1saW5rIG5vZGUgb3Igd2l0aG91dCBmaXhlZC1s
aW5rIG5vZGUgaW4gQ1BVIHBvcnQNCm5vZGUuDQoNCiAgIlRoaXMgZml4ZWQtbGluayBzaG91bGQg
bm90IGJlIG5lZWRlZC4gVGhlIERTQSBkcml2ZXIgaXMgc3VwcG9zZWQgdG8NCiAgIGNvbmZpZ3Vy
ZSB0aGUgQ1BVIHBvcnQgdG8gaXRzIGZhc3Rlc3Qgc3BlZWQgYnkgZGVmYXVsdC4gMjUwMCBpcw0K
ICAgdGhlIGZhc3Rlc3Qgc3BlZWQgYSAyNTAwQmFzZS1YIGxpbmsgY2FuIGRvLi4uIg0KPiA+ICsJ
CQl9Ow0KPiA+ICsJCX07DQo+ID4gKw0KPiA+ICAJfTsNCj4gPiAgfTsNCj4gPiAgDQo+ID4gLS0g
DQo+ID4gMi4xNy4xDQo+IA0KPiBUaGFua3MsDQo+IC1WbGFkaW1pcg0KDQo=


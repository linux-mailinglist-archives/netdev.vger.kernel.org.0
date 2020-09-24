Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F36277218
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 15:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbgIXNZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 09:25:47 -0400
Received: from mailgw02.mediatek.com ([216.200.240.185]:22843 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727846AbgIXNZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 09:25:46 -0400
X-UUID: b3e13f1d512a445aa0a2469b08f363b8-20200924
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=13CQbbbCVICRMofyq52vrwixbhSdHJNGZxZmv9+sfFk=;
        b=uKdAiTCcp84WiecPLMb8VJ4qqgSK3b1CbHzaTPHk0YiSpmKIGNFrmX4OcU4sb+/ZcX0SOgBPTo0kaB0+v/DIeCLXJUQltLi9kDrzY2FEaiqj/yMdAE2Y2Tr/219fqF6b9R+x/NBpNNZELXZmqS5Xy5FDbZI9uljg0j0rSUcgsck=;
X-UUID: b3e13f1d512a445aa0a2469b08f363b8-20200924
Received: from mtkcas66.mediatek.inc [(172.29.193.44)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1637863272; Thu, 24 Sep 2020 05:25:44 -0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 MTKMBS62N1.mediatek.inc (172.29.193.41) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 24 Sep 2020 06:25:41 -0700
Received: from [172.21.84.99] (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 24 Sep 2020 21:25:32 +0800
Message-ID: <1600953934.19244.2.camel@mtksdccf07>
Subject: Re: [PATCH v2] net: dsa: mt7530: Add some return-value checks
From:   Landen Chao <landen.chao@mediatek.com>
To:     Alex Dewar <alex.dewar90@gmail.com>
CC:     Sean Wang <Sean.Wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Thu, 24 Sep 2020 21:25:34 +0800
In-Reply-To: <9db38be8-9926-b74b-c860-018486b17f3a@gmail.com>
References: <1600327978.11746.22.camel@mtksdccf07>
         <20200919192809.29120-1-alex.dewar90@gmail.com>
         <1600949604.11746.27.camel@mtksdccf07>
         <9db38be8-9926-b74b-c860-018486b17f3a@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA5LTI0IGF0IDE0OjExICswMTAwLCBBbGV4IERld2FyIHdyb3RlOg0KPiBP
biAyMDIwLTA5LTI0IDEzOjEzLCBMYW5kZW4gQ2hhbyB3cm90ZToNCj4gPiBIaSBBbGV4LA0KPiA+
DQo+ID4gVGhhbmtzIGZvciB5b3VyIHBhdGNoLiBCeSBsaW51eC9zY3JpcHRzL2NoZWNrcGF0Y2gu
cGwNCj4gPg0KPiA+IE9uIFN1biwgMjAyMC0wOS0yMCBhdCAwMzoyOCArMDgwMCwgQWxleCBEZXdh
ciB3cm90ZToNCj4gPiBbLi5dDQo+ID4+IEBAIC0xNjMxLDkgKzE2MzUsMTEgQEAgbXQ3NTMwX3Nl
dHVwKHN0cnVjdCBkc2Ffc3dpdGNoICpkcykNCj4gPj4gICAJCW10NzUzMF9ybXcocHJpdiwgTVQ3
NTMwX1BDUl9QKGkpLCBQQ1JfTUFUUklYX01BU0ssDQo+ID4+ICAgCQkJICAgUENSX01BVFJJWF9D
TFIpOw0KPiA+PiAgIA0KPiA+PiAtCQlpZiAoZHNhX2lzX2NwdV9wb3J0KGRzLCBpKSkNCj4gPj4g
LQkJCW10NzUzeF9jcHVfcG9ydF9lbmFibGUoZHMsIGkpOw0KPiA+PiAtCQllbHNlDQo+ID4+ICsJ
CWlmIChkc2FfaXNfY3B1X3BvcnQoZHMsIGkpKSB7DQo+ID4+ICsJCQlyZXQgPSBtdDc1M3hfY3B1
X3BvcnRfZW5hYmxlKGRzLCBpKTsNCj4gPj4gKwkJCWlmIChyZXQpDQo+ID4+ICsJCQkJcmV0dXJu
IHJldDsNCj4gPj4gKwkJfSBlbHNlDQo+ID4+ICAgCQkJbXQ3NTMwX3BvcnRfZGlzYWJsZShkcywg
aSk7DQo+ID4gQ0hFQ0s6IGJyYWNlcyB7fSBzaG91bGQgYmUgdXNlZCBvbiBhbGwgYXJtcyBvZiB0
aGlzIHN0YXRlbWVudA0KPiA+IENIRUNLOiBVbmJhbGFuY2VkIGJyYWNlcyBhcm91bmQgZWxzZSBz
dGF0ZW1lbnQNCj4gPj4gICANCj4gPj4gICAJCS8qIEVuYWJsZSBjb25zaXN0ZW50IGVncmVzcyB0
YWcgKi8NCj4gPj4gQEAgLTE3ODUsOSArMTc5MSwxMSBAQCBtdDc1MzFfc2V0dXAoc3RydWN0IGRz
YV9zd2l0Y2ggKmRzKQ0KPiA+PiAgIA0KPiA+PiAgIAkJbXQ3NTMwX3NldChwcml2LCBNVDc1MzFf
REJHX0NOVChpKSwgTVQ3NTMxX0RJU19DTFIpOw0KPiA+PiAgIA0KPiA+PiAtCQlpZiAoZHNhX2lz
X2NwdV9wb3J0KGRzLCBpKSkNCj4gPj4gLQkJCW10NzUzeF9jcHVfcG9ydF9lbmFibGUoZHMsIGkp
Ow0KPiA+PiAtCQllbHNlDQo+ID4+ICsJCWlmIChkc2FfaXNfY3B1X3BvcnQoZHMsIGkpKSB7DQo+
ID4+ICsJCQlyZXQgPSBtdDc1M3hfY3B1X3BvcnRfZW5hYmxlKGRzLCBpKTsNCj4gPj4gKwkJCWlm
IChyZXQpDQo+ID4+ICsJCQkJcmV0dXJuIHJldDsNCj4gPj4gKwkJfSBlbHNlDQo+ID4+ICAgCQkJ
bXQ3NTMwX3BvcnRfZGlzYWJsZShkcywgaSk7DQo+ID4gQ0hFQ0s6IGJyYWNlcyB7fSBzaG91bGQg
YmUgdXNlZCBvbiBhbGwgYXJtcyBvZiB0aGlzIHN0YXRlbWVudA0KPiA+IENIRUNLOiBVbmJhbGFu
Y2VkIGJyYWNlcyBhcm91bmQgZWxzZSBzdGF0ZW1lbnQNCj4gPg0KPiA+IFsuLl0NCj4gPiByZWdh
cmRzIGxhbmRlbg0KPiBIaSBMYW5kZW4sDQo+IA0KPiBTb3JyeSBhYm91dCB0aGlzLi4uIEkgdXN1
YWxseSBydW4gY2hlY2twYXRjaCBvdmVyIG15IHBhdGNoZXMuIFdvdWxkIHlvdSANCj4gbGlrZSBt
ZSB0byBzZW5kIGEgc2VwYXJhdGUgZml4IG9yIGEgdjM/DQo+IA0KPiBCZXN0LA0KPiBBbGV4DQpI
aSBBbGV4LA0KDQpCZWNhdXNlIHYyIGhhcyBub3QgYmVlbiBtZXJnZWQgeWV0LCBjb3VsZCB5b3Ug
aGVscCB0byBmaXggaXQgaW4gdjM/DQoNCnJlZ2FyZHMgbGFuZGVuDQoNCg==


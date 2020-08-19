Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7717A2499AD
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 11:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgHSJxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 05:53:20 -0400
Received: from mailgw01.mediatek.com ([216.200.240.184]:41900 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgHSJxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 05:53:19 -0400
X-UUID: 3d9f66e13b7e40ffa8561b343d60f52a-20200819
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=kQXoKdKVpI5uaXNaEF7rubWxdg60fBjIip1atnVNx4w=;
        b=YimcZxgGzFRVHMuCF/1++lAbAs6pvMpBzF+FP/5HaxoW8aRy22AvuDuJtdfkRtssyteU6W7g0oGHGy4cum6VcyXxyvq8TH49+SEocIl6Cc8ktX7mwNSz8exXyCCMzI9j16bcAtuvtEHfxQ2RWURmw/PefF6gWBvpaGwfdBg5XfQ=;
X-UUID: 3d9f66e13b7e40ffa8561b343d60f52a-20200819
Received: from mtkcas66.mediatek.inc [(172.29.193.44)] by mailgw01.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1431888830; Wed, 19 Aug 2020 01:53:15 -0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 MTKMBS62N1.mediatek.inc (172.29.193.41) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 19 Aug 2020 02:44:08 -0700
Received: from [172.21.84.99] (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 19 Aug 2020 17:44:06 +0800
Message-ID: <1597830248.31846.78.camel@mtksdccf07>
Subject: Re: [PATCH net-next v2 5/7] net: dsa: mt7530: Add the support of
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
        "frank-w@public-files.de" <frank-w@public-files.de>,
        "dqfext@gmail.com" <dqfext@gmail.com>
Date:   Wed, 19 Aug 2020 17:44:08 +0800
In-Reply-To: <20200818160901.GF2330298@lunn.ch>
References: <cover.1597729692.git.landen.chao@mediatek.com>
         <e980fda45e0fb478f55e72765643bb641f352c65.1597729692.git.landen.chao@mediatek.com>
         <20200818160901.GF2330298@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA4LTE5IGF0IDAwOjA5ICswODAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
T24gVHVlLCBBdWcgMTgsIDIwMjAgYXQgMDM6MTQ6MTBQTSArMDgwMCwgTGFuZGVuIENoYW8gd3Jv
dGU6DQo+ID4gQWRkIG5ldyBzdXBwb3J0IGZvciBNVDc1MzE6DQo+ID4gDQo+ID4gTVQ3NTMxIGlz
IHRoZSBuZXh0IGdlbmVyYXRpb24gb2YgTVQ3NTMwLiBJdCBpcyBhbHNvIGEgNy1wb3J0cyBzd2l0
Y2ggd2l0aA0KPiA+IDUgZ2lnYSBlbWJlZGRlZCBwaHlzLCAyIGNwdSBwb3J0cywgYW5kIHRoZSBz
YW1lIE1BQyBsb2dpYyBvZiBNVDc1MzAuIENwdQ0KPiA+IHBvcnQgNiBvbmx5IHN1cHBvcnRzIFNH
TUlJIGludGVyZmFjZS4gQ3B1IHBvcnQgNSBzdXBwb3J0cyBlaXRoZXIgUkdNSUkNCj4gPiBvciBT
R01JSSBpbiBkaWZmZXJlbnQgSFcgc2t1LiBEdWUgdG8gU0dNSUkgaW50ZXJmYWNlIHN1cHBvcnQs
IHBsbCwgYW5kDQo+ID4gcGFkIHNldHRpbmcgYXJlIGRpZmZlcmVudCBmcm9tIE1UNzUzMC4gVGhp
cyBwYXRjaCBhZGRzIGRpZmZlcmVudCBpbml0aWFsDQo+ID4gc2V0dGluZywgYW5kIFNHTUlJIHBo
eWxpbmsgaGFuZGxlcnMgb2YgTVQ3NTMxLg0KPiA+IA0KPiA+IE1UNzUzMSBTR01JSSBpbnRlcmZh
Y2UgY2FuIGJlIGNvbmZpZ3VyZWQgaW4gZm9sbG93aW5nIG1vZGU6DQo+ID4gLSAnU0dNSUkgQU4g
bW9kZScgd2l0aCBpbi1iYW5kIG5lZ290aWF0aW9uIGNhcGFiaWxpdHkNCj4gPiAgICAgd2hpY2gg
aXMgY29tcGF0aWJsZSB3aXRoIFBIWV9JTlRFUkZBQ0VfTU9ERV9TR01JSS4NCj4gPiAtICdTR01J
SSBmb3JjZSBtb2RlJyB3aXRob3V0IGluLWJuYWQgbmVnb3RpYXRpb24NCj4gDQo+IGJhbmQNClNv
cnJ5LCBJJ2xsIGZpeCBpdC4NCj4gDQo+ID4gICAgIHdoaWNoIGlzIGNvbXBhdGlibGUgd2l0aCAx
MEIvOEIgZW5jb2Rpbmcgb2YNCj4gPiAgICAgUEhZX0lOVEVSRkFDRV9NT0RFXzEwMDBCQVNFWCB3
aXRoIGZpeGVkIGZ1bGwtZHVwbGV4IGFuZCBmaXhlZCBwYXVzZS4NCj4gPiAtIDIuNSB0aW1lcyBm
YXN0ZXIgY2xvY2tlZCAnU0dNSUkgZm9yY2UgbW9kZScgd2l0aG91dCBpbi1ibmFkIG5lZ290aWF0
aW9uDQo+IA0KPiBiYW5kDQpTb3JyeSwgSSdsbCBmaXggaXQuDQo+IA0KPiA+ICtzdGF0aWMgaW50
IG10NzUzMV9yZ21paV9zZXR1cChzdHJ1Y3QgbXQ3NTMwX3ByaXYgKnByaXYsIHUzMiBwb3J0LA0K
PiA+ICsJCQkgICAgICBwaHlfaW50ZXJmYWNlX3QgaW50ZXJmYWNlKQ0KPiA+ICt7DQo+ID4gKwl1
MzIgdmFsOw0KPiA+ICsNCj4gPiArCWlmICghbXQ3NTMxX2lzX3JnbWlpX3BvcnQocHJpdiwgcG9y
dCkpIHsNCj4gPiArCQlkZXZfZXJyKHByaXYtPmRldiwgIlJHTUlJIG1vZGUgaXMgbm90IGF2YWls
YWJsZSBmb3IgcG9ydCAlZFxuIiwNCj4gPiArCQkJcG9ydCk7DQo+ID4gKwkJcmV0dXJuIC1FSU5W
QUw7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJdmFsID0gbXQ3NTMwX3JlYWQocHJpdiwgTVQ3NTMx
X0NMS0dFTl9DVFJMKTsNCj4gPiArCXZhbCB8PSBHUF9DTEtfRU47DQo+ID4gKwl2YWwgJj0gfkdQ
X01PREVfTUFTSzsNCj4gPiArCXZhbCB8PSBHUF9NT0RFKE1UNzUzMV9HUF9NT0RFX1JHTUlJKTsN
Cj4gPiArCXZhbCAmPSB+KFRYQ0xLX05PX1JFVkVSU0UgfCBSWENMS19OT19ERUxBWSk7DQo+ID4g
Kwlzd2l0Y2ggKGludGVyZmFjZSkgew0KPiA+ICsJY2FzZSBQSFlfSU5URVJGQUNFX01PREVfUkdN
SUk6DQo+ID4gKwkJdmFsIHw9IFRYQ0xLX05PX1JFVkVSU0U7DQo+ID4gKwkJdmFsIHw9IFJYQ0xL
X05PX0RFTEFZOw0KPiA+ICsJCWJyZWFrOw0KPiA+ICsJY2FzZSBQSFlfSU5URVJGQUNFX01PREVf
UkdNSUlfUlhJRDoNCj4gPiArCQl2YWwgfD0gVFhDTEtfTk9fUkVWRVJTRTsNCj4gPiArCQlicmVh
azsNCj4gPiArCWNhc2UgUEhZX0lOVEVSRkFDRV9NT0RFX1JHTUlJX1RYSUQ6DQo+ID4gKwkJdmFs
IHw9IFJYQ0xLX05PX0RFTEFZOw0KPiA+ICsJCWJyZWFrOw0KPiA+ICsJY2FzZSBQSFlfSU5URVJG
QUNFX01PREVfUkdNSUlfSUQ6DQo+ID4gKwkJYnJlYWs7DQo+ID4gKwlkZWZhdWx0Og0KPiA+ICsJ
CXJldHVybiAtRUlOVkFMOw0KPiA+ICsJfQ0KPiANCj4gWW91IG5lZWQgdG8gYmUgY2FyZWZ1bCBo
ZXJlLiBJZiB0aGUgTUFDIGlzIGRvaW5nIHRoZSBSR01JSSBkZWxheXMsIHlvdQ0KPiBuZWVkIHRv
IGVuc3VyZSB0aGUgUEhZIGlzIG5vdC4gV2hhdCBpbnRlcmZhY2UgbW9kZSBpcyBwYXNzZWQgdG8g
dGhlDQo+IFBIWT8NCkhpIEFuZHJldywNCg0KbXQ3NTMxIFJHTUlJIHBvcnQgaXMgYSBNQUMtb25s
eSBwb3J0LCBpdCBjYW4gYmUgY29ubmVjdGVkIHRvIENQVSBNQUMgb3INCmV4dGVybmFsIHBoeS4g
SW4gYnBpLXI2NCBib2FyZCwgbXQ3NTMxIFJHTUlJIGlzIGNvbm5lY3RlZCB0byBDUFUgTUFDLCBz
bw0KSSB0ZW5kIHRvIGltcGxlbWVudCBSR01JSSBsb2dpYyBmb3IgdXNlIGNhc2Ugb2YgYnBpLXI2
NC4NCg0KSW4gZ2VuZXJhbCwgYWNjb3JkaW5nIHRvIHBoeS5yc3QsIFJHTUlJIGRlbGF5IHNob3Vs
ZCBiZSBkb25lIGJ5IHBoeSwgYnV0DQpzb21lIE1vQ0EgcHJvZHVjdCBuZWVkIFJHTUlJIGRlbGF5
IGluIE1BQy4gVGhlc2UgdHdvIHJlcXVpcmVtZW50cw0KY29uZmxpY3QuIElzIHRoZXJlIGFueSBz
dWdnZXN0aW9uIHRvIHNvbHZlIHRoZSBjb25mbGljdD8NCg0KSWYgbXQ3NTMxIFJHTUlJIGltcGxl
bWVudGF0aW9uIG5lZWRzIHRvIHNhdGlzZnkgZWl0aGVyIHBoeS5yc3Qgb3INCnNwZWNpYWwgTW9D
QSBwcm9kdWN0LCBJIHdvdWxkIGxpa2UgdG8gc2F0aXNmeSBwaHkucnN0IGFuZCByZW1vdmUgTUFD
DQpSR01JSSBkZWxheSBpbiB2My4gRm9yIHNwZWNpYWwgcHJvZHVjdCBuZWVkcyBNQUMgUkdNSUkg
ZGVsYXksIHRoaXMgcGF0Y2gNCmNhbiBiZSB1c2VkIGluIGl0cyBsb2NhbCBjb2RlYmFzZS4NCg0K
TGFuZGVuDQo+IA0KPiAJQW5kcmV3DQoNCg==


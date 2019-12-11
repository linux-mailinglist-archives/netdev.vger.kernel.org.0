Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5270F11BBBA
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731361AbfLKS2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:28:14 -0500
Received: from mailgw02.mediatek.com ([216.200.240.185]:58602 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731322AbfLKS2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:28:12 -0500
X-UUID: b929bc5011c94d5b845cbbfdf035042d-20191211
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=AJS94YiN8pfCT1+XiiAx5eqWRqmJb3Rr0RYdZSYfHVI=;
        b=J+FMENgS0ZD05uAjEI2c6d+L5p5r9IKFk7gDKqvIXx/e7nRys27SIFGcLJQ6o1l9/ce/ZvJw+NyN9mJeMVKqyQ6ABYD5nAniP8eHRDk/nEE0iBYfgwaE2GCwRpuUS2vWtyBzTOyN4iUS59nPVdNyKUcjFXUVr+Fj9EiL+9+fgkc=;
X-UUID: b929bc5011c94d5b845cbbfdf035042d-20191211
Received: from mtkcas66.mediatek.inc [(172.29.193.44)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1807329998; Wed, 11 Dec 2019 10:28:08 -0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 MTKMBS62N1.mediatek.inc (172.29.193.41) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 11 Dec 2019 10:19:07 -0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 12 Dec 2019 02:17:34 +0800
Message-ID: <1576088280.23763.73.camel@mtksdccf07>
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
Date:   Thu, 12 Dec 2019 02:18:00 +0800
In-Reply-To: <20191210164438.GD27714@lunn.ch>
References: <cover.1575914275.git.landen.chao@mediatek.com>
         <6d608dd024edc90b09ba4fe35417b693847f973c.1575914275.git.landen.chao@mediatek.com>
         <20191210164438.GD27714@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTEyLTExIGF0IDAwOjQ0ICswODAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
PiArc3RhdGljIGludA0KPiA+ICttdDc1MzFfaW5kX21tZF9waHlfcmVhZChzdHJ1Y3QgbXQ3NTMw
X3ByaXYgKnByaXYsIGludCBwb3J0LCBpbnQgZGV2YWQsDQo+ID4gKwkJCWludCByZWdudW0pDQo+
ID4gK3sNCj4gPiArCXN0cnVjdCBtaWlfYnVzICpidXMgPSBwcml2LT5idXM7DQo+ID4gKwlzdHJ1
Y3QgbXQ3NTMwX2R1bW15X3BvbGwgcDsNCj4gPiArCXUzMiByZWcsIHZhbDsNCj4gPiArCWludCBy
ZXQ7DQo+ID4gKw0KPiA+ICsJSU5JVF9NVDc1MzBfRFVNTVlfUE9MTCgmcCwgcHJpdiwgTVQ3NTMx
X1BIWV9JQUMpOw0KPiA+ICsNCj4gPiArCW11dGV4X2xvY2tfbmVzdGVkKCZidXMtPm1kaW9fbG9j
aywgTURJT19NVVRFWF9ORVNURUQpOw0KPiA+ICsNCj4gPiArCXJldCA9IHJlYWR4X3BvbGxfdGlt
ZW91dChfbXQ3NTMwX3VubG9ja2VkX3JlYWQsICZwLCB2YWwsDQo+ID4gKwkJCQkgISh2YWwgJiBQ
SFlfQUNTX1NUKSwgMjAsIDEwMDAwMCk7DQo+ID4gKwlpZiAocmV0IDwgMCkgew0KPiA+ICsJCWRl
dl9lcnIocHJpdi0+ZGV2LCAicG9sbCB0aW1lb3V0XG4iKTsNCj4gPiArCQlnb3RvIG91dDsNCj4g
PiArCX0NCj4gPiArDQo+ID4gKwlyZWcgPSBNRElPX0NMNDVfQUREUiB8IE1ESU9fUEhZX0FERFIo
cG9ydCkgfCBNRElPX0RFVl9BRERSKGRldmFkKSB8DQo+ID4gKwkgICAgICByZWdudW07DQo+IA0K
PiBJdCBtaWdodCBiZSBiZXR0ZXIgdG8gY2FsbCB0aGlzIG10NzUzMV9pbmRfYzQ1X3BoeV9yZWFk
KCkNCj4gDQo+ID4gK3N0YXRpYyBpbnQNCj4gPiArbXQ3NTMxX2luZF9waHlfcmVhZChzdHJ1Y3Qg
ZHNhX3N3aXRjaCAqZHMsIGludCBwb3J0LCBpbnQgcmVnbnVtKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1
Y3QgbXQ3NTMwX3ByaXYgKnByaXYgPSBkcy0+cHJpdjsNCj4gPiArCXN0cnVjdCBtaWlfYnVzICpi
dXMgPSBwcml2LT5idXM7DQo+ID4gKwlzdHJ1Y3QgbXQ3NTMwX2R1bW15X3BvbGwgcDsNCj4gPiAr
CWludCByZXQ7DQo+ID4gKwl1MzIgdmFsOw0KPiA+ICsNCj4gPiArCUlOSVRfTVQ3NTMwX0RVTU1Z
X1BPTEwoJnAsIHByaXYsIE1UNzUzMV9QSFlfSUFDKTsNCj4gPiArDQo+ID4gKwltdXRleF9sb2Nr
X25lc3RlZCgmYnVzLT5tZGlvX2xvY2ssIE1ESU9fTVVURVhfTkVTVEVEKTsNCj4gPiArDQo+ID4g
KwlyZXQgPSByZWFkeF9wb2xsX3RpbWVvdXQoX210NzUzMF91bmxvY2tlZF9yZWFkLCAmcCwgdmFs
LA0KPiA+ICsJCQkJICEodmFsICYgUEhZX0FDU19TVCksIDIwLCAxMDAwMDApOw0KPiA+ICsJaWYg
KHJldCA8IDApIHsNCj4gPiArCQlkZXZfZXJyKHByaXYtPmRldiwgInBvbGwgdGltZW91dFxuIik7
DQo+ID4gKwkJZ290byBvdXQ7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJdmFsID0gTURJT19DTDIy
X1JFQUQgfCBNRElPX1BIWV9BRERSKHBvcnQpIHwgTURJT19SRUdfQUREUihyZWdudW0pOw0KPiAN
Cj4gVGhpcyBpcyB0aGVuIG10NzUzMV9pbmRfYzIyX3BoeV9yZWFkKCkuDQo+IA0KPiBBbmQgdGhl
biB5b3UgY2FuIGFkZCBhIHdyYXBwZXIgYXJvdW5kIHRoaXMgdG8gcHJvdmlkZQ0KPiANCj4gbXQ3
NTMxX3BoeV9yZWFkKCkgd2hpY2ggY2FuIGRvIGJvdGggQzIyIGFuZCBDNDUuDQpJJ2xsIHVwZGF0
ZSB0aGUgY29kZSBiYXNlIG9uIGFib3ZlIHN1Z2dlc3Rpb24uDQo+IA0KPiA+ICsJW0lEX01UNzUz
MV0gPSB7DQo+ID4gKwkJLmlkID0gSURfTVQ3NTMxLA0KPiA+ICsJCS5zZXR1cCA9IG10NzUzMV9z
ZXR1cCwNCj4gPiArCQkucGh5X3JlYWQgPSBtdDc1MzFfaW5kX3BoeV9yZWFkLA0KPiANCj4gYW5k
IHVzZSBpdCBoZXJlLg0KRG8geW91IGFsc28gaGludCBhdCB1c2luZyB0aGUgc2FtZSBudW1iZXIg
b2YgcGFyYW1ldGVycyBmb3INCm10NzUzMV9pbmRfYzIyX3BoeV9yZWFkKCkgYW5kIG10NzUzMV9p
bmRfYzQ1X3BoeV9yZWFkKCk/DQoNCkxhbmRlbg0KPiANCj4gICBBbmRyZXcNCg0K


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6AF49D809
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 03:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbiA0C0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 21:26:34 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:34828 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229518AbiA0C0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 21:26:33 -0500
X-UUID: 2e794b65774f4810aa9a8ff785a389e5-20220127
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:CC:To:Subject; bh=chAJI6Jv+zvPg/bJzqsieWSytSGp/Qxf310ctQsoYBg=;
        b=gi0XEkl0czxbKTDc4P5/uj1yq3vaDJihFvPOOXOcz7ITQyKNpz1S0wBRBP5gS2G4+HVl5NJQ4gMgqbUkxrsEAYMS2wmRUsbcMwrZj6MQgCZP9V4IH5Xq98lG8Aidric/kglpNGrhy609hYGGk2+exiUpIuKOZ4AnEIO+Jpwlvs0=;
X-UUID: 2e794b65774f4810aa9a8ff785a389e5-20220127
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1066795832; Thu, 27 Jan 2022 10:26:30 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Thu, 27 Jan 2022 10:26:30 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 27 Jan 2022 10:26:29 +0800
Subject: Re: [PATCH net-next v2 5/9] net: ethernet: mtk-star-emac: add clock
 pad selection for RMII
To:     Biao Huang <biao.huang@mediatek.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        "Fabien Parent" <fparent@baylibre.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        "John Crispin" <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Yinghua Pan <ot_yinghua.pan@mediatek.com>,
        <srv_heupstream@mediatek.com>
References: <20220127015857.9868-1-biao.huang@mediatek.com>
 <20220127015857.9868-6-biao.huang@mediatek.com>
From:   Macpaul Lin <macpaul.lin@mediatek.com>
Message-ID: <436ff538-0067-30c1-3668-5ab0b840123d@mediatek.com>
Date:   Thu, 27 Jan 2022 10:26:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220127015857.9868-6-biao.huang@mediatek.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMS8yNy8yMiA5OjU4IEFNLCBCaWFvIEh1YW5nIHdyb3RlOg0KPiBUaGlzIHBhdGNoIGFkZCBh
IG5ldyBkdHMgcHJvcGVydHkgbmFtZWQgIm1lZGlhdGVrLHJtaWktcnhjIiBwYXJzaW5nDQo+IGlu
IGRyaXZlciwgd2hpY2ggd2lsbCBjb25maWd1cmUgTUFDIHRvIHNlbGVjdCB3aGljaCBwaW4gdGhl
IFJNSUkgcmVmZXJlbmNlDQo+IGNsb2NrIGlzIGNvbm5lY3RlZCB0bywgVFhDIG9yIFJYQy4NCj4g
DQo+IFRYQyBwYWQgaXMgdGhlIGRlZmF1bHQgcmVmZXJlbmNlIGNsb2NrIHBpbi4gSWYgdXNlciB3
YW50cyB0byB1c2UgUlhDIHBhZA0KPiBpbnN0ZWFkLCBhZGQgIm1lZGlhdGVrLHJtaWktcnhjIiB0
byBjb3JyZXNwb25kaW5nIGRldmljZSBub2RlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQmlhbyBI
dWFuZyA8Ymlhby5odWFuZ0BtZWRpYXRlay5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFlpbmdodWEg
UGFuIDxvdF95aW5naHVhLnBhbkBtZWRpYXRlay5jb20+DQo+IC0tLQ0KPiAgIGRyaXZlcnMvbmV0
L2V0aGVybmV0L21lZGlhdGVrL210a19zdGFyX2VtYWMuYyB8IDE5ICsrKysrKysrKysrKysrKysr
LS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMTcgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkN
Cj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfc3Rh
cl9lbWFjLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfc3Rhcl9lbWFjLmMN
Cj4gaW5kZXggYTM4ODRiZWFhM2ZlLi5kNjlmNzU2NjFlNzUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lZGlhdGVrL210a19zdGFyX2VtYWMuYw0KPiArKysgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfc3Rhcl9lbWFjLmMNCj4gQEAgLTE4OSw2ICsxODks
OCBAQCBzdGF0aWMgY29uc3QgY2hhciAqY29uc3QgbXRrX3N0YXJfY2xrX25hbWVzW10gPSB7ICJj
b3JlIiwgInJlZyIsICJ0cmFucyIgfTsNCj4gICAjZGVmaW5lIE1US19QRVJJQ0ZHX1JFR19OSUNf
Q0ZHX0NPTl9WMgkJMHgwYzEwDQo+ICAgI2RlZmluZSBNVEtfUEVSSUNGR19SRUdfTklDX0NGR19D
T05fQ0ZHX0lOVEYJR0VOTUFTSygzLCAwKQ0KPiAgICNkZWZpbmUgTVRLX1BFUklDRkdfQklUX05J
Q19DRkdfQ09OX1JNSUkJMQ0KPiArI2RlZmluZSBNVEtfUEVSSUNGR19CSVRfTklDX0NGR19DT05f
Q0xLCQlCSVQoMCkNCj4gKyNkZWZpbmUgTVRLX1BFUklDRkdfQklUX05JQ19DRkdfQ09OX0NMS19W
MglCSVQoOCkNCj4gICANCj4gICAvKiBSZXByZXNlbnRzIHRoZSBhY3R1YWwgc3RydWN0dXJlIG9m
IGRlc2NyaXB0b3JzIHVzZWQgYnkgdGhlIE1BQy4gV2UgY2FuDQo+ICAgICogcmV1c2UgdGhlIHNh
bWUgc3RydWN0dXJlIGZvciBib3RoIFRYIGFuZCBSWCAtIHRoZSBsYXlvdXQgaXMgdGhlIHNhbWUs
IG9ubHkNCj4gQEAgLTI2NSw2ICsyNjcsNyBAQCBzdHJ1Y3QgbXRrX3N0YXJfcHJpdiB7DQo+ICAg
CWludCBzcGVlZDsNCj4gICAJaW50IGR1cGxleDsNCj4gICAJaW50IHBhdXNlOw0KPiArCWJvb2wg
cm1paV9yeGM7DQo+ICAgDQo+ICAgCWNvbnN0IHN0cnVjdCBtdGtfc3Rhcl9jb21wYXQgKmNvbXBh
dF9kYXRhOw0KPiAgIA0KPiBAQCAtMTUyOCw2ICsxNTMxLDggQEAgc3RhdGljIGludCBtdGtfc3Rh
cl9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAgIAkJcmV0dXJuIC1FTk9E
RVY7DQo+ICAgCX0NCj4gICANCj4gKwlwcml2LT5ybWlpX3J4YyA9IG9mX3Byb3BlcnR5X3JlYWRf
Ym9vbChvZl9ub2RlLCAibWVkaWF0ZWsscm1paS1yeGMiKTsNCj4gKw0KPiAgIAlpZiAocHJpdi0+
Y29tcGF0X2RhdGEtPnNldF9pbnRlcmZhY2VfbW9kZSkgew0KPiAgIAkJcmV0ID0gcHJpdi0+Y29t
cGF0X2RhdGEtPnNldF9pbnRlcmZhY2VfbW9kZShuZGV2KTsNCj4gICAJCWlmIChyZXQpIHsNCj4g
QEAgLTE1NzEsMTcgKzE1NzYsMjUgQEAgc3RhdGljIGludCBtdDg1MTZfc2V0X2ludGVyZmFjZV9t
b2RlKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KQ0KPiAgIHsNCj4gICAJc3RydWN0IG10a19zdGFy
X3ByaXYgKnByaXYgPSBuZXRkZXZfcHJpdihuZGV2KTsNCj4gICAJc3RydWN0IGRldmljZSAqZGV2
ID0gbXRrX3N0YXJfZ2V0X2Rldihwcml2KTsNCj4gLQl1bnNpZ25lZCBpbnQgaW50Zl92YWw7DQo+
ICsJdW5zaWduZWQgaW50IGludGZfdmFsLCByZXQsIHJtaWlfcnhjOw0KPiAgIA0KPiAgIAlzd2l0
Y2ggKHByaXYtPnBoeV9pbnRmKSB7DQo+ICAgCWNhc2UgUEhZX0lOVEVSRkFDRV9NT0RFX1JNSUk6
DQo+ICAgCQlpbnRmX3ZhbCA9IE1US19QRVJJQ0ZHX0JJVF9OSUNfQ0ZHX0NPTl9STUlJOw0KPiAr
CQlybWlpX3J4YyA9IHByaXYtPnJtaWlfcnhjID8gMCA6IE1US19QRVJJQ0ZHX0JJVF9OSUNfQ0ZH
X0NPTl9DTEs7DQo+ICAgCQlicmVhazsNCj4gICAJZGVmYXVsdDoNCj4gICAJCWRldl9lcnIoZGV2
LCAiVGhpcyBpbnRlcmZhY2Ugbm90IHN1cHBvcnRlZFxuIik7DQo+ICAgCQlyZXR1cm4gLUVJTlZB
TDsNCj4gICAJfQ0KPiAgIA0KPiArCXJldCA9IHJlZ21hcF91cGRhdGVfYml0cyhwcml2LT5wZXJp
Y2ZnLA0KPiArCQkJCSBNVEtfUEVSSUNGR19SRUdfTklDX0NGRzFfQ09OLA0KPiArCQkJCSBNVEtf
UEVSSUNGR19CSVRfTklDX0NGR19DT05fQ0xLLA0KPiArCQkJCSBybWlpX3J4Yyk7DQo+ICsJaWYg
KHJldCkNCj4gKwkJcmV0dXJuIHJldDsNCj4gKw0KPiAgIAlyZXR1cm4gcmVnbWFwX3VwZGF0ZV9i
aXRzKHByaXYtPnBlcmljZmcsDQo+ICAgCQkJCSAgTVRLX1BFUklDRkdfUkVHX05JQ19DRkcwX0NP
TiwNCj4gICAJCQkJICBNVEtfUEVSSUNGR19SRUdfTklDX0NGR19DT05fQ0ZHX0lOVEYsDQo+IEBA
IC0xNTk3LDYgKzE2MTAsNyBAQCBzdGF0aWMgaW50IG10ODM2NV9zZXRfaW50ZXJmYWNlX21vZGUo
c3RydWN0IG5ldF9kZXZpY2UgKm5kZXYpDQo+ICAgCXN3aXRjaCAocHJpdi0+cGh5X2ludGYpIHsN
Cj4gICAJY2FzZSBQSFlfSU5URVJGQUNFX01PREVfUk1JSToNCj4gICAJCWludGZfdmFsID0gTVRL
X1BFUklDRkdfQklUX05JQ19DRkdfQ09OX1JNSUk7DQo+ICsJCWludGZfdmFsIHw9IHByaXYtPnJt
aWlfcnhjID8gMCA6IE1US19QRVJJQ0ZHX0JJVF9OSUNfQ0ZHX0NPTl9DTEtfVjI7DQo+ICAgCQli
cmVhazsNCj4gICAJZGVmYXVsdDoNCj4gICAJCWRldl9lcnIoZGV2LCAiVGhpcyBpbnRlcmZhY2Ug
bm90IHN1cHBvcnRlZFxuIik7DQo+IEBAIC0xNjA1LDcgKzE2MTksOCBAQCBzdGF0aWMgaW50IG10
ODM2NV9zZXRfaW50ZXJmYWNlX21vZGUoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYpDQo+ICAgDQo+
ICAgCXJldHVybiByZWdtYXBfdXBkYXRlX2JpdHMocHJpdi0+cGVyaWNmZywNCj4gICAJCQkJICBN
VEtfUEVSSUNGR19SRUdfTklDX0NGR19DT05fVjIsDQo+IC0JCQkJICBNVEtfUEVSSUNGR19SRUdf
TklDX0NGR19DT05fQ0ZHX0lOVEYsDQo+ICsJCQkJICBNVEtfUEVSSUNGR19SRUdfTklDX0NGR19D
T05fQ0ZHX0lOVEYgfA0KPiArCQkJCSAgTVRLX1BFUklDRkdfQklUX05JQ19DRkdfQ09OX0NMS19W
MiwNCj4gICAJCQkJICBpbnRmX3ZhbCk7DQo+ICAgfQ0KPiAgIA0KPiANCg0KUmV2aWV3ZWQtYnk6
IE1hY3BhdWwgTGluIDxtYWNwYXVsLmxpbkBtZWRpYXRlay5jb20+DQoNClJlZ2FyZHMsDQpNYWNw
YXVsIExpbg==


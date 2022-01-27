Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C83149D7EB
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 03:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbiA0CRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 21:17:24 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:45100 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229836AbiA0CRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 21:17:23 -0500
X-UUID: b4077e3a397e40c093f18109fffaeb80-20220127
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:CC:To:Subject; bh=QjvSFqDgio4ij1FhYl91UUt34DnWgW/KwRx42nXvVy8=;
        b=WHJIHTNBFTm/cbh99hv7Zxiyl+/7Apx8dggYr4Sr+VhmzU6KQnVnBb3yx3eWLa55quiDhHLiEGmOr0JtBfZB1i7SDLpMeceSb3MVNC6XvPGSwJM/zXFQb67/0H7IFdAsSOUIkvtc+5CDUr9joYcmHOCrdRnoFpnZjGuync2cFFI=;
X-UUID: b4077e3a397e40c093f18109fffaeb80-20220127
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1616764511; Thu, 27 Jan 2022 10:17:20 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Thu, 27 Jan 2022 10:17:18 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 27 Jan 2022 10:17:18 +0800
Subject: Re: [PATCH net-next v2 8/9] net: ethernet: mtk-star-emac: add support
 for MII interface
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
 <20220127015857.9868-9-biao.huang@mediatek.com>
From:   Macpaul Lin <macpaul.lin@mediatek.com>
Message-ID: <cef66664-192c-ab2f-2a3c-18c5d48b5093@mediatek.com>
Date:   Thu, 27 Jan 2022 10:17:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220127015857.9868-9-biao.huang@mediatek.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMS8yNy8yMiA5OjU4IEFNLCBCaWFvIEh1YW5nIHdyb3RlOg0KPiBBZGQgc3VwcG9ydCBmb3Ig
TUlJIGludGVyZmFjZS4NCj4gSWYgdXNlciB3YW50cyB0byB1c2UgTUlJLCBhc3NpZ24gIk1JSSIg
dG8gInBoeS1tb2RlIiBwcm9wZXJ0eSBpbiBkdHMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCaWFv
IEh1YW5nIDxiaWFvLmh1YW5nQG1lZGlhdGVrLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogWWluZ2h1
YSBQYW4gPG90X3lpbmdodWEucGFuQG1lZGlhdGVrLmNvbT4NCj4gLS0tDQo+ICAgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVkaWF0ZWsvbXRrX3N0YXJfZW1hYy5jIHwgMTMgKysrKysrKysrKystLQ0K
PiAgIDEgZmlsZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lZGlhdGVrL210a19zdGFyX2Vt
YWMuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lZGlhdGVrL210a19zdGFyX2VtYWMuYw0KPiBp
bmRleCBkNWU5NzRlMGRiNmQuLjE2N2EwMTlmZDhmNSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVkaWF0ZWsvbXRrX3N0YXJfZW1hYy5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21lZGlhdGVrL210a19zdGFyX2VtYWMuYw0KPiBAQCAtMTkzLDYgKzE5Myw3IEBA
IHN0YXRpYyBjb25zdCBjaGFyICpjb25zdCBtdGtfc3Rhcl9jbGtfbmFtZXNbXSA9IHsgImNvcmUi
LCAicmVnIiwgInRyYW5zIiB9Ow0KPiAgICNkZWZpbmUgTVRLX1BFUklDRkdfUkVHX05JQ19DRkcx
X0NPTgkJMHgwM2M4DQo+ICAgI2RlZmluZSBNVEtfUEVSSUNGR19SRUdfTklDX0NGR19DT05fVjIJ
CTB4MGMxMA0KPiAgICNkZWZpbmUgTVRLX1BFUklDRkdfUkVHX05JQ19DRkdfQ09OX0NGR19JTlRG
CUdFTk1BU0soMywgMCkNCj4gKyNkZWZpbmUgTVRLX1BFUklDRkdfQklUX05JQ19DRkdfQ09OX01J
SQkJMA0KPiAgICNkZWZpbmUgTVRLX1BFUklDRkdfQklUX05JQ19DRkdfQ09OX1JNSUkJMQ0KPiAg
ICNkZWZpbmUgTVRLX1BFUklDRkdfQklUX05JQ19DRkdfQ09OX0NMSwkJQklUKDApDQo+ICAgI2Rl
ZmluZSBNVEtfUEVSSUNGR19CSVRfTklDX0NGR19DT05fQ0xLX1YyCUJJVCg4KQ0KPiBAQCAtMTQ2
Myw2ICsxNDY0LDcgQEAgc3RhdGljIGludCBtdGtfc3Rhcl9zZXRfdGltaW5nKHN0cnVjdCBtdGtf
c3Rhcl9wcml2ICpwcml2KQ0KPiAgIAl1bnNpZ25lZCBpbnQgZGVsYXlfdmFsID0gMDsNCj4gICAN
Cj4gICAJc3dpdGNoIChwcml2LT5waHlfaW50Zikgew0KPiArCWNhc2UgUEhZX0lOVEVSRkFDRV9N
T0RFX01JSToNCj4gICAJY2FzZSBQSFlfSU5URVJGQUNFX01PREVfUk1JSToNCj4gICAJCWRlbGF5
X3ZhbCB8PSBGSUVMRF9QUkVQKE1US19TVEFSX0JJVF9JTlZfUlhfQ0xLLCBwcml2LT5yeF9pbnYp
Ow0KPiAgIAkJZGVsYXlfdmFsIHw9IEZJRUxEX1BSRVAoTVRLX1NUQVJfQklUX0lOVl9UWF9DTEss
IHByaXYtPnR4X2ludik7DQo+IEBAIC0xNTQ1LDcgKzE1NDcsOCBAQCBzdGF0aWMgaW50IG10a19z
dGFyX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICAgCXJldCA9IG9mX2dl
dF9waHlfbW9kZShvZl9ub2RlLCAmcHJpdi0+cGh5X2ludGYpOw0KPiAgIAlpZiAocmV0KSB7DQo+
ICAgCQlyZXR1cm4gcmV0Ow0KPiAtCX0gZWxzZSBpZiAocHJpdi0+cGh5X2ludGYgIT0gUEhZX0lO
VEVSRkFDRV9NT0RFX1JNSUkpIHsNCj4gKwl9IGVsc2UgaWYgKHByaXYtPnBoeV9pbnRmICE9IFBI
WV9JTlRFUkZBQ0VfTU9ERV9STUlJICYmDQo+ICsJCSAgIHByaXYtPnBoeV9pbnRmICE9IFBIWV9J
TlRFUkZBQ0VfTU9ERV9NSUkpIHsNCj4gICAJCWRldl9lcnIoZGV2LCAidW5zdXBwb3J0ZWQgcGh5
IG1vZGU6ICVzXG4iLA0KPiAgIAkJCXBoeV9tb2Rlcyhwcml2LT5waHlfaW50ZikpOw0KPiAgIAkJ
cmV0dXJuIC1FSU5WQUw7DQo+IEBAIC0xNjEwLDkgKzE2MTMsMTIgQEAgc3RhdGljIGludCBtdDg1
MTZfc2V0X2ludGVyZmFjZV9tb2RlKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KQ0KPiAgIHsNCj4g
ICAJc3RydWN0IG10a19zdGFyX3ByaXYgKnByaXYgPSBuZXRkZXZfcHJpdihuZGV2KTsNCj4gICAJ
c3RydWN0IGRldmljZSAqZGV2ID0gbXRrX3N0YXJfZ2V0X2Rldihwcml2KTsNCj4gLQl1bnNpZ25l
ZCBpbnQgaW50Zl92YWwsIHJldCwgcm1paV9yeGM7DQo+ICsJdW5zaWduZWQgaW50IGludGZfdmFs
LCByZXQsIHJtaWlfcnhjID0gMDsNCj4gICANCj4gICAJc3dpdGNoIChwcml2LT5waHlfaW50Zikg
ew0KPiArCWNhc2UgUEhZX0lOVEVSRkFDRV9NT0RFX01JSToNCj4gKwkJaW50Zl92YWwgPSBNVEtf
UEVSSUNGR19CSVRfTklDX0NGR19DT05fTUlJOw0KPiArCQlicmVhazsNCj4gICAJY2FzZSBQSFlf
SU5URVJGQUNFX01PREVfUk1JSToNCj4gICAJCWludGZfdmFsID0gTVRLX1BFUklDRkdfQklUX05J
Q19DRkdfQ09OX1JNSUk7DQo+ICAgCQlybWlpX3J4YyA9IHByaXYtPnJtaWlfcnhjID8gMCA6IE1U
S19QRVJJQ0ZHX0JJVF9OSUNfQ0ZHX0NPTl9DTEs7DQo+IEBAIC0xNjQyLDYgKzE2NDgsOSBAQCBz
dGF0aWMgaW50IG10ODM2NV9zZXRfaW50ZXJmYWNlX21vZGUoc3RydWN0IG5ldF9kZXZpY2UgKm5k
ZXYpDQo+ICAgCXVuc2lnbmVkIGludCBpbnRmX3ZhbDsNCj4gICANCj4gICAJc3dpdGNoIChwcml2
LT5waHlfaW50Zikgew0KPiArCWNhc2UgUEhZX0lOVEVSRkFDRV9NT0RFX01JSToNCj4gKwkJaW50
Zl92YWwgPSBNVEtfUEVSSUNGR19CSVRfTklDX0NGR19DT05fTUlJOw0KPiArCQlicmVhazsNCj4g
ICAJY2FzZSBQSFlfSU5URVJGQUNFX01PREVfUk1JSToNCj4gICAJCWludGZfdmFsID0gTVRLX1BF
UklDRkdfQklUX05JQ19DRkdfQ09OX1JNSUk7DQo+ICAgCQlpbnRmX3ZhbCB8PSBwcml2LT5ybWlp
X3J4YyA/IDAgOiBNVEtfUEVSSUNGR19CSVRfTklDX0NGR19DT05fQ0xLX1YyOw0KPiANCg0KUmV2
aWV3ZWQtYnk6IE1hY3BhdWwgTGluIDxtYWNwYXVsLmxpbkBtZWRpYXRlay5jb20+DQoNClJlZ2Fy
ZHMsDQpNYWNwYXVsIExpbg==


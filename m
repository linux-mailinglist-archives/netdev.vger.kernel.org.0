Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A125349D804
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 03:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbiA0CXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 21:23:40 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:58566 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229518AbiA0CXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 21:23:40 -0500
X-UUID: 8ec20c5efc0d4d26844421a251dfaa63-20220127
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:CC:To:Subject; bh=0G1UogeYiMHezzn69cabyVHv/Wsfv6Zk4JZ77udVd1Y=;
        b=YcpmWvmId3bhySd8sDKNe3IQCRuqG1u4/EsNlLExDdFz9KbW1P1sUuSqqYqMtW0UGkqHOb87eHc3D0JDAgKR6mgB7wxhRxG2NAQ3JU0oEe8I3y4kpDAN4XxRiMJ4XvGs0myLQaLXxF5W4/lhJf7Y2qHfC4YZTYchbkDrGL2ebBw=;
X-UUID: 8ec20c5efc0d4d26844421a251dfaa63-20220127
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 51761725; Thu, 27 Jan 2022 10:23:36 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Thu, 27 Jan 2022 10:23:35 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 27 Jan 2022 10:23:35 +0800
Subject: Re: [PATCH net-next v2 1/9] net: ethernet: mtk-star-emac: store
 bit_clk_div in compat structure
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
 <20220127015857.9868-2-biao.huang@mediatek.com>
From:   Macpaul Lin <macpaul.lin@mediatek.com>
Message-ID: <7a544fae-e7ff-d2a2-0ee5-1dca2f855be0@mediatek.com>
Date:   Thu, 27 Jan 2022 10:23:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220127015857.9868-2-biao.huang@mediatek.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMS8yNy8yMiA5OjU4IEFNLCBCaWFvIEh1YW5nIHdyb3RlOg0KPiBGcm9tOiBGYWJpZW4gUGFy
ZW50IDxmcGFyZW50QGJheWxpYnJlLmNvbT4NCj4gDQo+IE5vdCBhbGwgdGhlIFNvQyBhcmUgdXNp
bmcgdGhlIHNhbWUgY2xvY2sgZGl2aWRlci4gTW92ZSB0aGUgZGl2aWRlciBpbnRvDQo+IGEgY29t
cGF0IHN0cnVjdHVyZSBzcGVjaWZpYyB0byB0aGUgU29Dcy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IEJpYW8gSHVhbmcgPGJpYW8uaHVhbmdAbWVkaWF0ZWsuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBG
YWJpZW4gUGFyZW50IDxmcGFyZW50QGJheWxpYnJlLmNvbT4NCj4gLS0tDQo+ICAgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVkaWF0ZWsvbXRrX3N0YXJfZW1hYy5jIHwgMjMgKysrKysrKysrKysrKysr
LS0tLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygt
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lZGlhdGVrL210a19z
dGFyX2VtYWMuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lZGlhdGVrL210a19zdGFyX2VtYWMu
Yw0KPiBpbmRleCAxZDVkZDIwMTU0NTMuLjdmZDhlYzBmYzYzNiAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVkaWF0ZWsvbXRrX3N0YXJfZW1hYy5jDQo+ICsrKyBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lZGlhdGVrL210a19zdGFyX2VtYWMuYw0KPiBAQCAtMTcsNiArMTcs
NyBAQA0KPiAgICNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4NCj4gICAjaW5jbHVkZSA8bGludXgv
bmV0ZGV2aWNlLmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4L29mLmg+DQo+ICsjaW5jbHVkZSA8bGlu
dXgvb2ZfZGV2aWNlLmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4L29mX21kaW8uaD4NCj4gICAjaW5j
bHVkZSA8bGludXgvb2ZfbmV0Lmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4L3BsYXRmb3JtX2Rldmlj
ZS5oPg0KPiBAQCAtMjMyLDYgKzIzMywxMCBAQCBzdHJ1Y3QgbXRrX3N0YXJfcmluZyB7DQo+ICAg
CXVuc2lnbmVkIGludCB0YWlsOw0KPiAgIH07DQo+ICAgDQo+ICtzdHJ1Y3QgbXRrX3N0YXJfY29t
cGF0IHsNCj4gKwl1bnNpZ25lZCBjaGFyIGJpdF9jbGtfZGl2Ow0KPiArfTsNCj4gKw0KPiAgIHN0
cnVjdCBtdGtfc3Rhcl9wcml2IHsNCj4gICAJc3RydWN0IG5ldF9kZXZpY2UgKm5kZXY7DQo+ICAg
DQo+IEBAIC0yNTcsNiArMjYyLDggQEAgc3RydWN0IG10a19zdGFyX3ByaXYgew0KPiAgIAlpbnQg
ZHVwbGV4Ow0KPiAgIAlpbnQgcGF1c2U7DQo+ICAgDQo+ICsJY29uc3Qgc3RydWN0IG10a19zdGFy
X2NvbXBhdCAqY29tcGF0X2RhdGE7DQo+ICsNCj4gICAJLyogUHJvdGVjdHMgYWdhaW5zdCBjb25j
dXJyZW50IGRlc2NyaXB0b3IgYWNjZXNzLiAqLw0KPiAgIAlzcGlubG9ja190IGxvY2s7DQo+ICAg
DQo+IEBAIC04OTksNyArOTA2LDcgQEAgc3RhdGljIHZvaWQgbXRrX3N0YXJfaW5pdF9jb25maWco
c3RydWN0IG10a19zdGFyX3ByaXYgKnByaXYpDQo+ICAgCXJlZ21hcF93cml0ZShwcml2LT5yZWdz
LCBNVEtfU1RBUl9SRUdfU1lTX0NPTkYsIHZhbCk7DQo+ICAgCXJlZ21hcF91cGRhdGVfYml0cyhw
cml2LT5yZWdzLCBNVEtfU1RBUl9SRUdfTUFDX0NMS19DT05GLA0KPiAgIAkJCSAgIE1US19TVEFS
X01TS19NQUNfQ0xLX0NPTkYsDQo+IC0JCQkgICBNVEtfU1RBUl9CSVRfQ0xLX0RJVl8xMCk7DQo+
ICsJCQkgICBwcml2LT5jb21wYXRfZGF0YS0+Yml0X2Nsa19kaXYpOw0KPiAgIH0NCj4gICANCj4g
ICBzdGF0aWMgdm9pZCBtdGtfc3Rhcl9zZXRfbW9kZV9ybWlpKHN0cnVjdCBtdGtfc3Rhcl9wcml2
ICpwcml2KQ0KPiBAQCAtMTQ2MSw2ICsxNDY4LDcgQEAgc3RhdGljIGludCBtdGtfc3Rhcl9wcm9i
ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAgIA0KPiAgIAlwcml2ID0gbmV0ZGV2
X3ByaXYobmRldik7DQo+ICAgCXByaXYtPm5kZXYgPSBuZGV2Ow0KPiArCXByaXYtPmNvbXBhdF9k
YXRhID0gb2ZfZGV2aWNlX2dldF9tYXRjaF9kYXRhKCZwZGV2LT5kZXYpOw0KPiAgIAlTRVRfTkVU
REVWX0RFVihuZGV2LCBkZXYpOw0KPiAgIAlwbGF0Zm9ybV9zZXRfZHJ2ZGF0YShwZGV2LCBuZGV2
KTsNCj4gICANCj4gQEAgLTE1NTYsMTAgKzE1NjQsMTcgQEAgc3RhdGljIGludCBtdGtfc3Rhcl9w
cm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAgIAlyZXR1cm4gZGV2bV9yZWdp
c3Rlcl9uZXRkZXYoZGV2LCBuZGV2KTsNCj4gICB9DQo+ICAgDQo+ICtzdGF0aWMgY29uc3Qgc3Ry
dWN0IG10a19zdGFyX2NvbXBhdCBtdGtfc3Rhcl9tdDg1MTZfY29tcGF0ID0gew0KPiArCS5iaXRf
Y2xrX2RpdiA9IE1US19TVEFSX0JJVF9DTEtfRElWXzEwLA0KPiArfTsNCj4gKw0KPiAgIHN0YXRp
YyBjb25zdCBzdHJ1Y3Qgb2ZfZGV2aWNlX2lkIG10a19zdGFyX29mX21hdGNoW10gPSB7DQo+IC0J
eyAuY29tcGF0aWJsZSA9ICJtZWRpYXRlayxtdDg1MTYtZXRoIiwgfSwNCj4gLQl7IC5jb21wYXRp
YmxlID0gIm1lZGlhdGVrLG10ODUxOC1ldGgiLCB9LA0KPiAtCXsgLmNvbXBhdGlibGUgPSAibWVk
aWF0ZWssbXQ4MTc1LWV0aCIsIH0sDQo+ICsJeyAuY29tcGF0aWJsZSA9ICJtZWRpYXRlayxtdDg1
MTYtZXRoIiwNCj4gKwkgIC5kYXRhID0gJm10a19zdGFyX210ODUxNl9jb21wYXQgfSwNCj4gKwl7
IC5jb21wYXRpYmxlID0gIm1lZGlhdGVrLG10ODUxOC1ldGgiLA0KPiArCSAgLmRhdGEgPSAmbXRr
X3N0YXJfbXQ4NTE2X2NvbXBhdCB9LA0KPiArCXsgLmNvbXBhdGlibGUgPSAibWVkaWF0ZWssbXQ4
MTc1LWV0aCIsDQo+ICsJICAuZGF0YSA9ICZtdGtfc3Rhcl9tdDg1MTZfY29tcGF0IH0sDQo+ICAg
CXsgfQ0KPiAgIH07DQo+ICAgTU9EVUxFX0RFVklDRV9UQUJMRShvZiwgbXRrX3N0YXJfb2ZfbWF0
Y2gpOw0KPiANCg0KUmV2aWV3ZWQtYnk6IE1hY3BhdWwgTGluIDxtYWNwYXVsLmxpbkBtZWRpYXRl
ay5jb20+DQoNClJlZ2FyZHMsDQpNYWNwYXVsIExpbg==


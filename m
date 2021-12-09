Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7188246E055
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 02:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbhLIBpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 20:45:47 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:54064 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229680AbhLIBpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 20:45:47 -0500
X-UUID: b23cf152a0104789ba9f02164db44517-20211209
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=JEt3XG4GHhG9WFakPdTvxOX/lsmWXLVPAlDuPpzKZro=;
        b=okq6CjmdpC/VGZ97YGqF9AStRZdzKofxz0leGxwBj+1pfGc/1T67zHe00GHDhNwQQ1fcQokayO6cdMUWbENJcebobO/G3KfH3Re9WNtoX46CWCjl62/XUtodVbu8G51MzWSF0iaGYQjDiK/htxnh0ajm55F446joIriJegqgOLk=;
X-UUID: b23cf152a0104789ba9f02164db44517-20211209
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1554230953; Thu, 09 Dec 2021 09:42:11 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Thu, 9 Dec 2021 09:42:10 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 9 Dec 2021 09:42:09 +0800
Message-ID: <5713fa6121effde79c19e0b4475d02389d72d2cc.camel@mediatek.com>
Subject: Re: [PATCH net-next v7 5/6] stmmac: dwmac-mediatek: add support for
 mt8195
From:   Biao Huang <biao.huang@mediatek.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <srv_heupstream@mediatek.com>, <macpaul.lin@mediatek.com>,
        <angelogioacchino.delregno@collabora.com>, <dkirjanov@suse.de>
Date:   Thu, 9 Dec 2021 09:42:08 +0800
In-Reply-To: <20211208063820.264df62d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211208054716.603-1-biao.huang@mediatek.com>
         <20211208054716.603-6-biao.huang@mediatek.com>
         <20211208063820.264df62d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBKYWt1YiwNCg0KQWxsIHRoZXNlIHdhcm5pbmcgbGluZXMgc2hhcmUgYSBzaW1pbGFyIHNl
bWFudGljczoNCmRlbGF5X3ZhbCB8PSBGSUVMRF9QUkVQKHh4eCwgISF2YWwpOw0KDQphbmQsIHNo
b3VsZCBjb21lIGZyb20gdGhlIGV4cGFuc2lvbiBvZiBGSUVMRF9QUkVQIGluDQppbmNsdWRlL2xp
bnV4L2JpdGZpbGVkLmg6DQoNCiAgRklFTEQgX1BSRVAgLS0+IF9fQkZfRklMRURfQ0hFQ0sgLS0+
ICJ+KChfbWFzaykgPj4gX19iZl9zaGYoX21hc2spKSAmDQooX3ZhbCkgOiAwLCINCg0KPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
DQpfX0JGX0ZJTEVEX0NIRUNLIHsNCi4uLg0KICBCVUlMRF9CVUdfT05fTVNHKF9fYnVpbHRpbl9j
b25zdGFudF9wKF92YWwpID8gICAgICAgICAgIFwNCiAgICAgICAgICAgICAgICAgICB+KChfbWFz
aykgPj4gX19iZl9zaGYoX21hc2spKSAmIChfdmFsKSA6IDAsIFwNCiAgICAgICAgICAgICAgICAg
ICBfcGZ4ICJ2YWx1ZSB0b28gbGFyZ2UgZm9yIHRoZSBmaWVsZCIpOyBcDQouLi4NCj09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0K
DQpTaG91bGQgSSBmaXggaXQgYnkgY29udmVydGluZw0KICBkZWxheV92YWwgfD0gRklFTERfUFJF
UChFVEhfRExZX1RYQ19FTkFCTEUsICEhbWFjX2RlbGF5LT50eF9kZWxheSk7DQp0bw0KICBlbl92
YWwgPSAhIW1hY19kZWxheS0+dHhfZGVsYXk7DQogIGRlbGF5X3ZhbCB8PSBGSUVMRF9QUkVQKEVU
SF9ETFlfVFhDX0VOQUJMRSwgISFlbl92YWwpOw0KDQpvciBvdGhlciBzdWdnZXN0aW9ucyBmb3Ig
dGhlc2Ugd2FybmluZ3M/DQoNClRoYW5rc34NCg0KT24gV2VkLCAyMDIxLTEyLTA4IGF0IDA2OjM4
IC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gT24gV2VkLCA4IERlYyAyMDIxIDEzOjQ3
OjE1ICswODAwIEJpYW8gSHVhbmcgd3JvdGU6DQo+ID4gQWRkIEV0aGVybmV0IHN1cHBvcnQgZm9y
IE1lZGlhVGVrIFNvQ3MgZnJvbSB0aGUgbXQ4MTk1IGZhbWlseS4NCj4gPiANCj4gPiBTaWduZWQt
b2ZmLWJ5OiBCaWFvIEh1YW5nIDxiaWFvLmh1YW5nQG1lZGlhdGVrLmNvbT4NCj4gPiBBY2tlZC1i
eTogQW5nZWxvR2lvYWNjaGlubyBEZWwgUmVnbm8gPA0KPiA+IGFuZ2Vsb2dpb2FjY2hpbm8uZGVs
cmVnbm9AY29sbGFib3JhLmNvbT4NCj4gDQo+IHNwYXJzZSByZXBvcnRzIHdob2xlIGJ1bmNoIG9m
IHdhcm5pbmdzIGxpa2UgdGhpczoNCj4gDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8v
c3RtbWFjL2R3bWFjLW1lZGlhdGVrLmM6MjEzOjMwOiB3YXJuaW5nOg0KPiBkdWJpb3VzOiB4ICYg
IXkNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvZHdtYWMtbWVkaWF0ZWsu
YzoyMTc6MzA6IHdhcm5pbmc6DQo+IGR1YmlvdXM6IHggJiAheQ0KPiBkcml2ZXJzL25ldC9ldGhl
cm5ldC9zdG1pY3JvL3N0bW1hYy9kd21hYy1tZWRpYXRlay5jOjIyODozODogd2FybmluZzoNCj4g
ZHViaW91czogeCAmICF5DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3
bWFjLW1lZGlhdGVrLmM6MjMyOjM4OiB3YXJuaW5nOg0KPiBkdWJpb3VzOiB4ICYgIXkNCj4gZHJp
dmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvZHdtYWMtbWVkaWF0ZWsuYzoyNDc6NDY6
IHdhcm5pbmc6DQo+IGR1YmlvdXM6IHggJiAheQ0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1p
Y3JvL3N0bW1hYy9kd21hYy1tZWRpYXRlay5jOjI1NTo0Njogd2FybmluZzoNCj4gZHViaW91czog
eCAmICF5DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjLW1lZGlh
dGVrLmM6MjczOjMwOiB3YXJuaW5nOg0KPiBkdWJpb3VzOiB4ICYgIXkNCj4gZHJpdmVycy9uZXQv
ZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvZHdtYWMtbWVkaWF0ZWsuYzoyNzc6MzA6IHdhcm5pbmc6
DQo+IGR1YmlvdXM6IHggJiAheQ0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1h
Yy9kd21hYy1tZWRpYXRlay5jOjM3NTozMDogd2FybmluZzoNCj4gZHViaW91czogeCAmICF5DQo+
IGRyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjLW1lZGlhdGVrLmM6Mzc5
OjMwOiB3YXJuaW5nOg0KPiBkdWJpb3VzOiB4ICYgIXkNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQv
c3RtaWNyby9zdG1tYWMvZHdtYWMtbWVkaWF0ZWsuYzozOTA6NDM6IHdhcm5pbmc6DQo+IGR1Ymlv
dXM6IHggJiAheQ0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9kd21hYy1t
ZWRpYXRlay5jOjM5Nzo0Mzogd2FybmluZzoNCj4gZHViaW91czogeCAmICF5DQo+IGRyaXZlcnMv
bmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjLW1lZGlhdGVrLmM6NDE1OjQ2OiB3YXJu
aW5nOg0KPiBkdWJpb3VzOiB4ICYgIXkNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9z
dG1tYWMvZHdtYWMtbWVkaWF0ZWsuYzo0MjY6NDY6IHdhcm5pbmc6DQo+IGR1YmlvdXM6IHggJiAh
eQ0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9kd21hYy1tZWRpYXRlay5j
OjQzOTozNTogd2FybmluZzoNCj4gZHViaW91czogeCAmICF5DQo+IGRyaXZlcnMvbmV0L2V0aGVy
bmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjLW1lZGlhdGVrLmM6NDQzOjMwOiB3YXJuaW5nOg0KPiBk
dWJpb3VzOiB4ICYgIXkNCj4gDQo+IEFueSBpZGVhIG9uIHdoZXJlIHRoZXNlIGNvbWUgZnJvbT8N
Cg==


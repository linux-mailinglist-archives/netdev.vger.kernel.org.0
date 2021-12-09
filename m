Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164AE46E061
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 02:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233863AbhLIBwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 20:52:04 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:56716 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229680AbhLIBwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 20:52:04 -0500
X-UUID: 955d2fae56574faa96afa38d2971b794-20211209
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=XjABykCBjXFelT4zEiqGcJGg15Ult0B96f3Fb8EdYNs=;
        b=JEQMqBRWf7fQUOHn/Pm6V3VxkGp7vj6h5pUr6+CdfcdfmpjNOKXXWHfrJDhiC7ryTfZ5ehKNvACitzAGDeOhYvt0pn6jtmau31/68d9/+60/LRmrHMjzOuOwHlDy9kbsCeTNQrEtIzxSNBZKWVRK0d0+MUxwNrLdrGm9nQfTro8=;
X-UUID: 955d2fae56574faa96afa38d2971b794-20211209
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 440424674; Thu, 09 Dec 2021 09:48:27 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Thu, 9 Dec 2021 09:48:26 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 9 Dec 2021 09:48:25 +0800
Message-ID: <39aa23e1a48bc36a631b3074af2abfd5d1e2256d.camel@mediatek.com>
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
Date:   Thu, 9 Dec 2021 09:48:25 +0800
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

RGVhciBKYWt1YiwNCg0KU29ycnkgZm9yIHNvbWUgdHlwbyBpbiBwcmV2aW91cyByZXBseSwgZml4
IGl0IGhlcmUuDQoNCkFsbCB0aGVzZSB3YXJuaW5nIGxpbmVzIHNoYXJlIGEgc2ltaWxhciBzZW1h
bnRpY3M6DQpkZWxheV92YWwgfD0gRklFTERfUFJFUCh4eHgsICEhdmFsKTsNCg0KYW5kLCBzaG91
bGQgY29tZSBmcm9tIHRoZSBleHBhbnNpb24gb2YgRklFTERfUFJFUCBpbg0KaW5jbHVkZS9saW51
eC9iaXRmaWxlZC5oOg0KDQogIEZJRUxEIF9QUkVQIC0tPiBfX0JGX0ZJTEVEX0NIRUNLIC0tPiAi
figoX21hc2spID4+IF9fYmZfc2hmKF9tYXNrKSkgJg0KKF92YWwpIDogMCwiDQoNCj09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0K
X19CRl9GSUxFRF9DSEVDSyB7DQouLi4NCiAgQlVJTERfQlVHX09OX01TRyhfX2J1aWx0aW5fY29u
c3RhbnRfcChfdmFsKSA/ICAgICAgICAgICBcDQogICAgICAgICAgICAgICAgICAgfigoX21hc2sp
ID4+IF9fYmZfc2hmKF9tYXNrKSkgJiAoX3ZhbCkgOiAwLCBcDQogICAgICAgICAgICAgICAgICAg
X3BmeCAidmFsdWUgdG9vIGxhcmdlIGZvciB0aGUgZmllbGQiKTsgXCAuLi4NCj09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KDQpT
aG91bGQgSSBmaXggaXQgYnkgY29udmVydGluZw0KICBkZWxheV92YWwgfD0gRklFTERfUFJFUChF
VEhfRExZX1RYQ19FTkFCTEUsICEhbWFjX2RlbGF5LT50eF9kZWxheSk7DQp0bw0KICBlbl92YWwg
PSAhIW1hY19kZWxheS0+dHhfZGVsYXk7DQogIGRlbGF5X3ZhbCB8PSBGSUVMRF9QUkVQKEVUSF9E
TFlfVFhDX0VOQUJMRSwgZW5fdmFsKTsNCg0Kb3Igb3RoZXIgc3VnZ2VzdGlvbnMgZm9yIHRoZXNl
IHdhcm5pbmdzPw0KDQpUaGFua3N+DQpPbiBXZWQsIDIwMjEtMTItMDggYXQgMDY6MzggLTA4MDAs
IEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiBPbiBXZWQsIDggRGVjIDIwMjEgMTM6NDc6MTUgKzA4
MDAgQmlhbyBIdWFuZyB3cm90ZToNCj4gPiBBZGQgRXRoZXJuZXQgc3VwcG9ydCBmb3IgTWVkaWFU
ZWsgU29DcyBmcm9tIHRoZSBtdDgxOTUgZmFtaWx5Lg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6
IEJpYW8gSHVhbmcgPGJpYW8uaHVhbmdAbWVkaWF0ZWsuY29tPg0KPiA+IEFja2VkLWJ5OiBBbmdl
bG9HaW9hY2NoaW5vIERlbCBSZWdubyA8DQo+ID4gYW5nZWxvZ2lvYWNjaGluby5kZWxyZWdub0Bj
b2xsYWJvcmEuY29tPg0KPiANCj4gc3BhcnNlIHJlcG9ydHMgd2hvbGUgYnVuY2ggb2Ygd2Fybmlu
Z3MgbGlrZSB0aGlzOg0KPiANCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMv
ZHdtYWMtbWVkaWF0ZWsuYzoyMTM6MzA6IHdhcm5pbmc6DQo+IGR1YmlvdXM6IHggJiAheQ0KPiBk
cml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9kd21hYy1tZWRpYXRlay5jOjIxNzoz
MDogd2FybmluZzoNCj4gZHViaW91czogeCAmICF5DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L3N0
bWljcm8vc3RtbWFjL2R3bWFjLW1lZGlhdGVrLmM6MjI4OjM4OiB3YXJuaW5nOg0KPiBkdWJpb3Vz
OiB4ICYgIXkNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvZHdtYWMtbWVk
aWF0ZWsuYzoyMzI6Mzg6IHdhcm5pbmc6DQo+IGR1YmlvdXM6IHggJiAheQ0KPiBkcml2ZXJzL25l
dC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9kd21hYy1tZWRpYXRlay5jOjI0Nzo0Njogd2Fybmlu
ZzoNCj4gZHViaW91czogeCAmICF5DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3Rt
bWFjL2R3bWFjLW1lZGlhdGVrLmM6MjU1OjQ2OiB3YXJuaW5nOg0KPiBkdWJpb3VzOiB4ICYgIXkN
Cj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvZHdtYWMtbWVkaWF0ZWsuYzoy
NzM6MzA6IHdhcm5pbmc6DQo+IGR1YmlvdXM6IHggJiAheQ0KPiBkcml2ZXJzL25ldC9ldGhlcm5l
dC9zdG1pY3JvL3N0bW1hYy9kd21hYy1tZWRpYXRlay5jOjI3NzozMDogd2FybmluZzoNCj4gZHVi
aW91czogeCAmICF5DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFj
LW1lZGlhdGVrLmM6Mzc1OjMwOiB3YXJuaW5nOg0KPiBkdWJpb3VzOiB4ICYgIXkNCj4gZHJpdmVy
cy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvZHdtYWMtbWVkaWF0ZWsuYzozNzk6MzA6IHdh
cm5pbmc6DQo+IGR1YmlvdXM6IHggJiAheQ0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3Jv
L3N0bW1hYy9kd21hYy1tZWRpYXRlay5jOjM5MDo0Mzogd2FybmluZzoNCj4gZHViaW91czogeCAm
ICF5DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjLW1lZGlhdGVr
LmM6Mzk3OjQzOiB3YXJuaW5nOg0KPiBkdWJpb3VzOiB4ICYgIXkNCj4gZHJpdmVycy9uZXQvZXRo
ZXJuZXQvc3RtaWNyby9zdG1tYWMvZHdtYWMtbWVkaWF0ZWsuYzo0MTU6NDY6IHdhcm5pbmc6DQo+
IGR1YmlvdXM6IHggJiAheQ0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9k
d21hYy1tZWRpYXRlay5jOjQyNjo0Njogd2FybmluZzoNCj4gZHViaW91czogeCAmICF5DQo+IGRy
aXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjLW1lZGlhdGVrLmM6NDM5OjM1
OiB3YXJuaW5nOg0KPiBkdWJpb3VzOiB4ICYgIXkNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvc3Rt
aWNyby9zdG1tYWMvZHdtYWMtbWVkaWF0ZWsuYzo0NDM6MzA6IHdhcm5pbmc6DQo+IGR1YmlvdXM6
IHggJiAheQ0KPiANCj4gQW55IGlkZWEgb24gd2hlcmUgdGhlc2UgY29tZSBmcm9tPw0K


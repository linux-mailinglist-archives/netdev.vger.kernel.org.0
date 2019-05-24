Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1541729495
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 11:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390048AbfEXJYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 05:24:37 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:40634 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389710AbfEXJYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 05:24:37 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 667C4C0137;
        Fri, 24 May 2019 09:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558689862; bh=AVU6oZcHCROGnmkLrcWIelylachVoYTTTsYDpq5qRGE=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=D6N1xI62ExfnhyeopDP2KepGh9+jcTsoEdBgNxKAB8EyL2fnL9XREOHFmEEC3hEsi
         +sV5eTIn2eDF0X+zGLIclMhVbRmsCn1mnXSf8b6YXmO+JCj257l1HAgFEsprkN4IBi
         vaW9W8eRRXX+nnYrR92XoZ1bY6GQaFnMeybI/KjollFkG5VPauhnhwClD/xulaMaUJ
         mW55DXwY3yipCq7jOQRVF9ySTeXKTPNqceFkFoWHyrAVq6/Kky44Bhc3rbPQ5X0znp
         yZC8zLePl0nck3VrGBfDDtBFePDEP5Xy2yj/Mg+RJWCkK2qYWId9+WkoKX1J3JhSKy
         mKwbWs8/Mpt7g==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 5716EA0070;
        Fri, 24 May 2019 09:24:34 +0000 (UTC)
Received: from DE02WEHTCB.internal.synopsys.com (10.225.19.94) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 24 May 2019 02:24:33 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCB.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Fri,
 24 May 2019 11:24:31 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     biao huang <biao.huang@mediatek.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "yt.shen@mediatek.com" <yt.shen@mediatek.com>,
        "jianguo.zhang@mediatek.comi" <jianguo.zhang@mediatek.comi>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>
Subject: RE: [v2, PATCH] net: stmmac: add support for hash table size
 128/256 in dwmac4
Thread-Topic: [v2, PATCH] net: stmmac: add support for hash table size
 128/256 in dwmac4
Thread-Index: AQHVCgFP5uFdcKuEVU64Pxj/Ha7yEaZ5v7KAgABABhD//+D6AIAAL/0w
Date:   Fri, 24 May 2019 09:24:31 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B92D26F@DE02WEMBXB.internal.synopsys.com>
References: <1557802843-31718-1-git-send-email-biao.huang@mediatek.com>
         <1557802843-31718-2-git-send-email-biao.huang@mediatek.com>
         <1558679617.24897.43.camel@mhfsdcap03>
         <78EB27739596EE489E55E81C33FEC33A0B92CDA0@DE02WEMBXB.internal.synopsys.com>
 <1558686704.24897.45.camel@mhfsdcap03>
In-Reply-To: <1558686704.24897.45.camel@mhfsdcap03>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.107.19.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogYmlhbyBodWFuZyA8Ymlhby5odWFuZ0BtZWRpYXRlay5jb20+DQpEYXRlOiBGcmksIE1h
eSAyNCwgMjAxOSBhdCAwOTozMTo0NA0KDQo+IE9uIEZyaSwgMjAxOS0wNS0yNCBhdCAwODoyNCAr
MDAwMCwgSm9zZSBBYnJldSB3cm90ZToNCj4gPiBGcm9tOiBiaWFvIGh1YW5nIDxiaWFvLmh1YW5n
QG1lZGlhdGVrLmNvbT4NCj4gPiBEYXRlOiBGcmksIE1heSAyNCwgMjAxOSBhdCAwNzozMzozNw0K
PiA+IA0KPiA+ID4gYW55IGNvbW1lbnRzIGFib3V0IHRoaXMgcGF0Y2g/DQo+ID4gDQo+ID4gQ2Fu
IHlvdSBwbGVhc2UgdGVzdCB5b3VyIHNlcmllcyBvbiB0b3Agb2YgdGhpcyBvbmUgWzFdIGFuZCBs
ZXQgbWUga25vdyANCj4gPiB0aGUgb3V0cHV0IG9mIDoNCj4gPiAjIGV0aHRvb2wgLXQgZXRoMA0K
PiAiZXRodG9sIC1UIGV0aDAiPyBUaGlzIHBhdGNoIG9ubHkgYWZmZWN0IGhhc2ggdGFibGUgZmls
dGVyLCBzZWVtcyBubw0KPiByZWxhdGlvbiB0byB0aW1lc3RhbXAuDQo+ID4gDQo+ID4gSnVzdCB0
byBtYWtlIHN1cmUgdGhhdCB0aGlzIHBhdGNoIGRvZXMgbm90IGludHJvZHVjZSBhbnkgcmVncmVz
c2lvbnMuIFRoZSANCj4gPiByZW1haW5pbmcgb25lcyBvZiB0aGUgc2VyaWVzIGxvb2sgZmluZSBi
eSBtZSENCj4gPiANCj4gPiBbMV0gDQo+IHdoaWNoIG9uZT8gRGlkIEkgbWlzcyBhbnl0aGluZyBo
ZXJlPw0KDQpTb3JyeSwgbXkgbWFpbCBjbGllbnQgdHJpZWQgdG8gd3JhcCB0aGUgbG9uZyBsaW5r
IGFuZCBlbmRlZCB1cCBpbiBhIA0KbG9vb29uZyBlbWFpbC4NCg0KWzFdIGh0dHBzOi8vcGF0Y2h3
b3JrLm96bGFicy5vcmcvcHJvamVjdC9uZXRkZXYvbGlzdC8/c2VyaWVzPTEwOTY5OQ0KDQpUaGFu
a3MsDQpKb3NlIE1pZ3VlbCBBYnJldQ0K

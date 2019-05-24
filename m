Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D115B29303
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 10:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389509AbfEXIYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 04:24:32 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:38468 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389198AbfEXIYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 04:24:31 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id F36FDC0131;
        Fri, 24 May 2019 08:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558686257; bh=2d5krVqE1IwKQPL77HYD2SfvzObastRzptHMse61g4U=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=lm577U5VAIjKEPVxfUSdVuAFH8prU8fFxXAtoQ2E1Dm3/AiVFlXQRUH++PL5Wf5jI
         N+bfLEcAmg/hzWqPJPryP/GnshlqN2IwgjLkxc54Yt3ylZtEcTu7X7wG0/PeXR4JFT
         1D1tT50hBt3R9DOYf8KOWV6BaoNnCI2XW8K3xqApYXCC9YANRo0TziDXH2S7l3S6pw
         9ZWgtNbnGFc0U7TzGLW4BvXjgrWrxs3LWfHIT6rtWeh+WtZ8C2au7VDrYa/9DMbmlu
         4nbFdDy1P/ks4ttRJLy0NRTPIN/0v8F5wTEhbIuH3HRu0wcA/iJ467t/UHMnLVuLv2
         trTS1G2URXoSg==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 508BFA005D;
        Fri, 24 May 2019 08:24:29 +0000 (UTC)
Received: from DE02WEHTCB.internal.synopsys.com (10.225.19.94) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 24 May 2019 01:24:29 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCB.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Fri,
 24 May 2019 10:24:27 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     biao huang <biao.huang@mediatek.com>
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
Thread-Index: AQHVCgFP5uFdcKuEVU64Pxj/Ha7yEaZ5v7KAgABABhA=
Date:   Fri, 24 May 2019 08:24:26 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B92CDA0@DE02WEMBXB.internal.synopsys.com>
References: <1557802843-31718-1-git-send-email-biao.huang@mediatek.com>
         <1557802843-31718-2-git-send-email-biao.huang@mediatek.com>
 <1558679617.24897.43.camel@mhfsdcap03>
In-Reply-To: <1558679617.24897.43.camel@mhfsdcap03>
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
eSAyNCwgMjAxOSBhdCAwNzozMzozNw0KDQo+IGFueSBjb21tZW50cyBhYm91dCB0aGlzIHBhdGNo
Pw0KDQpDYW4geW91IHBsZWFzZSB0ZXN0IHlvdXIgc2VyaWVzIG9uIHRvcCBvZiB0aGlzIG9uZSBb
MV0gYW5kIGxldCBtZSBrbm93IA0KdGhlIG91dHB1dCBvZiA6DQojIGV0aHRvb2wgLXQgZXRoMA0K
DQpKdXN0IHRvIG1ha2Ugc3VyZSB0aGF0IHRoaXMgcGF0Y2ggZG9lcyBub3QgaW50cm9kdWNlIGFu
eSByZWdyZXNzaW9ucy4gVGhlIA0KcmVtYWluaW5nIG9uZXMgb2YgdGhlIHNlcmllcyBsb29rIGZp
bmUgYnkgbWUhDQoNClsxXSANCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0K
DQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoN
Cg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0K
DQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoN
Cg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0K
DQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoN
Cg0KDQoNCg0KDQpodHRwczovL3BhdGNod29yay5vemxhYnMub3JnL3Byb2plY3QvbmV0ZGV2L2xp
c3QvP3Nlcmllcz0xMDk2OTkNCg0KVGhhbmtzLA0KSm9zZSBNaWd1ZWwgQWJyZXUNCg==

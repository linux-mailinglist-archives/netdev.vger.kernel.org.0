Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66BB92950B
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 11:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389911AbfEXJpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 05:45:00 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:7320 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389582AbfEXJpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 05:45:00 -0400
X-UUID: daf92e84950644cfa0396206d837043a-20190524
X-UUID: daf92e84950644cfa0396206d837043a-20190524
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1523258147; Fri, 24 May 2019 17:44:48 +0800
Received: from MTKCAS32.mediatek.inc (172.27.4.184) by mtkmbs01n2.mediatek.inc
 (172.21.101.79) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 24 May
 2019 17:44:46 +0800
Received: from [10.17.3.153] (172.27.4.253) by MTKCAS32.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 24 May 2019 17:44:44 +0800
Message-ID: <1558691084.24897.51.camel@mhfsdcap03>
Subject: RE: [v2, PATCH] net: stmmac: add support for hash table size
 128/256 in dwmac4
From:   biao huang <biao.huang@mediatek.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
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
Date:   Fri, 24 May 2019 17:44:44 +0800
In-Reply-To: <78EB27739596EE489E55E81C33FEC33A0B92D26F@DE02WEMBXB.internal.synopsys.com>
References: <1557802843-31718-1-git-send-email-biao.huang@mediatek.com>
         <78EB27739596EE489E55E81C33FEC33A0B92D26F@DE02WEMBXB.internal.synopsys.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-TM-SNTS-SMTP: 238D8347CAB595BF80BC7F148B95AD8BE5BE1F4F748A6570F199B0DC4BF2A9D82000:8
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Seems I should modify this patch base on
"https://patchwork.ozlabs.org/project/netdev/list/?series=109699"

On Fri, 2019-05-24 at 09:24 +0000, Jose Abreu wrote:
> From: biao huang <biao.huang@mediatek.com>
> Date: Fri, May 24, 2019 at 09:31:44
> 
> > On Fri, 2019-05-24 at 08:24 +0000, Jose Abreu wrote:
> > > From: biao huang <biao.huang@mediatek.com>
> > > Date: Fri, May 24, 2019 at 07:33:37
> > > 
> > > > any comments about this patch?
> > > 
> > > Can you please test your series on top of this one [1] and let me know 
> > > the output of :
> > > # ethtool -t eth0
> > "ethtol -T eth0"? This patch only affect hash table filter, seems no
> > relation to timestamp.
> > > 
execute "ethtool -t eth0", then we got "Cannot test: Operation not
supported", is there any config should be enabled?
> > > Just to make sure that this patch does not introduce any regressions. The 
> > > remaining ones of the series look fine by me!
> > > 
> > > [1] 
> > which one? Did I miss anything here?
> 
> Sorry, my mail client tried to wrap the long link and ended up in a 
> loooong email.
> 
> [1] https://patchwork.ozlabs.org/project/netdev/list/?series=109699
> 
Got it.
> Thanks,
> Jose Miguel Abreu



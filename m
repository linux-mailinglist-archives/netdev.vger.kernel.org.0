Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5628F258
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 10:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfD3I6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 04:58:51 -0400
Received: from mailgw02.mediatek.com ([1.203.163.81]:33818 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725790AbfD3I6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 04:58:51 -0400
X-UUID: 5a55ebb6ad7941189c0f2739cd5def45-20190430
X-UUID: 5a55ebb6ad7941189c0f2739cd5def45-20190430
Received: from mtkcas32.mediatek.inc [(172.27.4.253)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLS)
        with ESMTP id 64381693; Tue, 30 Apr 2019 16:58:45 +0800
Received: from MTKCAS32.mediatek.inc (172.27.4.184) by MTKMBS31N2.mediatek.inc
 (172.27.4.87) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 30 Apr
 2019 16:58:44 +0800
Received: from [10.17.3.153] (172.27.4.253) by MTKCAS32.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 30 Apr 2019 16:58:43 +0800
Message-ID: <1556614723.24897.33.camel@mhfsdcap03>
Subject: RE: [PATCH 2/2] net-next: stmmac: add mdio clause 45 access from
 mac device for dwmac4
From:   biao huang <biao.huang@mediatek.com>
To:     "Ong, Boon Leong" <boon.leong.ong@intel.com>
CC:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
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
        "jianguo.zhang@mediatek.com" <jianguo.zhang@mediatek.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>
Date:   Tue, 30 Apr 2019 16:58:43 +0800
In-Reply-To: <AF233D1473C1364ABD51D28909A1B1B75C0C2849@pgsmsx114.gar.corp.intel.com>
References: <1556519724-1576-1-git-send-email-biao.huang@mediatek.com>
         <1556519724-1576-3-git-send-email-biao.huang@mediatek.com>
         <AF233D1473C1364ABD51D28909A1B1B75C0C27ED@pgsmsx114.gar.corp.intel.com>
         <78EB27739596EE489E55E81C33FEC33A0B46E5B4@DE02WEMBXB.internal.synopsys.com>
         <AF233D1473C1364ABD51D28909A1B1B75C0C2849@pgsmsx114.gar.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-04-29 at 15:23 +0000, Ong, Boon Leong wrote:
> >> What is the preference of the driver maintainer here?
> >
> >Your implementation doesn't need the mdelay() so I think we should follow
> >your way once you also address the review comments from Andrew and me.
> >
> >Maybe you can coordinate with Biao and submit a C45 implementation that
> >can be tested by both ?
> 
> Ok. We will address the review comments for that patch-series and resend the
> v3 patch-series soonest and for Biao to test. 
>  
I'll test it when your patch is ready. Please cc me, thanks.
> Thanks



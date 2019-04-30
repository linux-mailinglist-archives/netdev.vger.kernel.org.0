Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A71F3F25D
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 10:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfD3I7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 04:59:31 -0400
Received: from Mailgw01.mediatek.com ([1.203.163.78]:59355 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725790AbfD3I7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 04:59:31 -0400
X-UUID: 8a6c0375236e4cba8ee10aec64978726-20190430
X-UUID: 8a6c0375236e4cba8ee10aec64978726-20190430
Received: from mtkcas35.mediatek.inc [(172.27.4.253)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLS)
        with ESMTP id 1840663579; Tue, 30 Apr 2019 16:59:25 +0800
Received: from MTKCAS32.mediatek.inc (172.27.4.184) by MTKMBS31DR.mediatek.inc
 (172.27.6.102) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 30 Apr
 2019 16:59:23 +0800
Received: from [10.17.3.153] (172.27.4.253) by MTKCAS32.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 30 Apr 2019 16:59:23 +0800
Message-ID: <1556614763.24897.34.camel@mhfsdcap03>
Subject: RE: [PATCH 1/2] net-next: stmmac: add support for hash table size
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
        "jianguo.zhang@mediatek.com" <jianguo.zhang@mediatek.com>
Date:   Tue, 30 Apr 2019 16:59:23 +0800
In-Reply-To: <78EB27739596EE489E55E81C33FEC33A0B46DE20@DE02WEMBXB.internal.synopsys.com>
References: <1556519724-1576-1-git-send-email-biao.huang@mediatek.com>
         <1556519724-1576-2-git-send-email-biao.huang@mediatek.com>
         <78EB27739596EE489E55E81C33FEC33A0B46DE20@DE02WEMBXB.internal.synopsys.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-04-29 at 09:00 +0000, Jose Abreu wrote:
> From: Biao Huang <biao.huang@mediatek.com>
> Date: Mon, Apr 29, 2019 at 07:35:23
> 
> > +#define GMAC_HASH_TAB(x)		(0x10 + x * 4)
> 
> You need to guard x here with parenthesis.
> 
> >  	void __iomem *ioaddr = (void __iomem *)dev->base_addr;
> > -	unsigned int value = 0;
> > +	unsigned int value;
> > +	int i;
> > +	int numhashregs = (hw->multicast_filter_bins >> 5);
> > +	int mcbitslog2 = hw->mcast_bits_log2;
> 
> Reverse Christmas tree order here please.
OK.
> 
> Thanks,
> Jose Miguel Abreu



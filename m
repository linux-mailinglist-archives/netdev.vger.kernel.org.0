Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30CAB3CB034
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 02:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbhGPA5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 20:57:11 -0400
Received: from mga03.intel.com ([134.134.136.65]:31713 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229583AbhGPA5K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 20:57:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10046"; a="210700234"
X-IronPort-AV: E=Sophos;i="5.84,243,1620716400"; 
   d="scan'208";a="210700234"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2021 17:54:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,243,1620716400"; 
   d="scan'208";a="494767129"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga001.jf.intel.com with ESMTP; 15 Jul 2021 17:54:15 -0700
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 4586158073D;
        Thu, 15 Jul 2021 17:54:12 -0700 (PDT)
Date:   Fri, 16 Jul 2021 08:54:08 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     "menglong8.dong@gmail.com" <menglong8.dong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhang Yunkai <zhang.yunkai@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] net:stmmac: Fix the unsigned expression
 compared with zero
Message-ID: <20210716005408.GA31939@linux.intel.com>
References: <20210715074539.226600-1-zhang.yunkai@zte.com.cn>
 <DB8PR04MB679513459A42E7A7982CE91EE6129@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB8PR04MB679513459A42E7A7982CE91EE6129@DB8PR04MB6795.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 10:12:04AM +0000, Joakim Zhang wrote:
> 
> > -----Original Message-----
> > From: menglong8.dong@gmail.com <menglong8.dong@gmail.com>
> > Sent: 2021年7月15日 15:46
> > To: davem@davemloft.net
> > Cc: peppe.cavallaro@st.com; alexandre.torgue@foss.st.com;
> > joabreu@synopsys.com; kuba@kernel.org; mcoquelin.stm32@gmail.com;
> > netdev@vger.kernel.org; linux-stm32@st-md-mailman.stormreply.com;
> > linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Zhang
> > Yunkai <zhang.yunkai@zte.com.cn>; Zeal Robot <zealci@zte.com.cn>
> > Subject: [PATCH linux-next] net:stmmac: Fix the unsigned expression compared
> > with zero
> > 
> > From: Zhang Yunkai <zhang.yunkai@zte.com.cn>
> > 
> > WARNING:  Unsigned expression "queue" compared with zero.
> > Reported-by: Zeal Robot <zealci@zte.com.cn>
> > Signed-off-by: Zhang Yunkai <zhang.yunkai@zte.com.cn>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 8 ++------
> >  1 file changed, 2 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > index 7b8404a21544..a4cf2c640531 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > @@ -1699,7 +1699,7 @@ static int init_dma_rx_desc_rings(struct net_device
> > *dev, gfp_t flags)
> >  	return 0;
> > 
> >  err_init_rx_buffers:
> > -	while (queue >= 0) {
> > +	do {
> >  		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
> > 
> >  		if (rx_q->xsk_pool)
> > @@ -1710,11 +1710,7 @@ static int init_dma_rx_desc_rings(struct
> > net_device *dev, gfp_t flags)
> >  		rx_q->buf_alloc_num = 0;
> >  		rx_q->xsk_pool = NULL;
> > 
> > -		if (queue == 0)
> > -			break;
> > -
> > -		queue--;
> > -	}
> > +	} while (queue--);
> > 
> >  	return ret;
> >  }
> 
> 
> This is a real Coverity issue since queue variable is defined as u32, but there is no breakage from logic, it will break while loop when queue equal 0, and queue[0] actually need be handled.
> After your code change, queue[0] will not be handled, right? It will break the logic. If you want to fix the this issue, I think the easiest way is to define queue variable to int.
> 
> Best Regards,
> Joakim Zhang
> > --
> > 2.25.1
>

The function '__init_dma_rx_desc_rings' is expecting 'queue' to be u32 type.
I would suggest the following:-

@@ -1686,6 +1686,7 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
        struct stmmac_priv *priv = netdev_priv(dev);
        u32 rx_count = priv->plat->rx_queues_to_use;
        u32 queue;
+       u32 i;
        int ret;

        /* RX INITIALIZATION */
@@ -1701,21 +1702,16 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
        return 0;

 err_init_rx_buffers:
-       while (queue >= 0) {
-               struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+       for (i = 0; i <= queue; i++) {
+               struct stmmac_rx_queue *rx_q = &priv->rx_queue[i];

                if (rx_q->xsk_pool)
-                       dma_free_rx_xskbufs(priv, queue);
+                       dma_free_rx_xskbufs(priv, i);
                else
-                       dma_free_rx_skbufs(priv, queue);
+                       dma_free_rx_skbufs(priv, i);

                rx_q->buf_alloc_num = 0;
                rx_q->xsk_pool = NULL;
-
-               if (queue == 0)
-                       break;
-
-               queue--;
        }

Regards,
 VK 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAD6B5A8DB
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 06:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfF2ENh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 00:13:37 -0400
Received: from mga06.intel.com ([134.134.136.31]:43159 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbfF2ENg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 00:13:36 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jun 2019 21:13:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,430,1557212400"; 
   d="scan'208";a="314325099"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 28 Jun 2019 21:13:34 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hh4k1-000I9G-EY; Sat, 29 Jun 2019 12:13:33 +0800
Date:   Sat, 29 Jun 2019 12:13:26 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Catherine Sullivan <csully@google.com>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org,
        Catherine Sullivan <csully@google.com>,
        Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Subject: Re: [net-next 2/4] gve: Add transmit and receive support
Message-ID: <201906291243.kyt7M5KH%lkp@intel.com>
References: <20190626185251.205687-3-csully@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626185251.205687-3-csully@google.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Catherine,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Catherine-Sullivan/Add-gve-driver/20190629-070444
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/net/ethernet/google/gve/gve_main.c:25:12: sparse: sparse: symbol 'gve_version_str' was not declared. Should it be static?
   drivers/net/ethernet/google/gve/gve_main.c:26:12: sparse: sparse: symbol 'gve_version_prefix' was not declared. Should it be static?
>> drivers/net/ethernet/google/gve/gve_main.c:79:16: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected unsigned int val @@    got restricted __be3unsigned int val @@
>> drivers/net/ethernet/google/gve/gve_main.c:79:16: sparse:    expected unsigned int val
>> drivers/net/ethernet/google/gve/gve_main.c:79:16: sparse:    got restricted __be32 [usertype]
   drivers/net/ethernet/google/gve/gve_main.c:104:16: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected unsigned int val @@    got restricted __be3unsigned int val @@
   drivers/net/ethernet/google/gve/gve_main.c:104:16: sparse:    expected unsigned int val
   drivers/net/ethernet/google/gve/gve_main.c:104:16: sparse:    got restricted __be32 [usertype]
   drivers/net/ethernet/google/gve/gve_main.c:115:24: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected unsigned int val @@    got restricted __be3unsigned int val @@
   drivers/net/ethernet/google/gve/gve_main.c:115:24: sparse:    expected unsigned int val
   drivers/net/ethernet/google/gve/gve_main.c:115:24: sparse:    got restricted __be32 [usertype]
>> drivers/net/ethernet/google/gve/gve_main.c:84:5: sparse: sparse: symbol 'gve_napi_poll' was not declared. Should it be static?
>> drivers/net/ethernet/google/gve/gve_main.c:297:6: sparse: sparse: symbol 'gve_add_napi' was not declared. Should it be static?
>> drivers/net/ethernet/google/gve/gve_main.c:305:6: sparse: sparse: symbol 'gve_remove_napi' was not declared. Should it be static?
   drivers/net/ethernet/google/gve/gve_main.c:726:24: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected unsigned int val @@    got restricted __be3unsigned int val @@
   drivers/net/ethernet/google/gve/gve_main.c:726:24: sparse:    expected unsigned int val
   drivers/net/ethernet/google/gve/gve_main.c:726:24: sparse:    got restricted __be32 [usertype]
   drivers/net/ethernet/google/gve/gve_main.c:733:24: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected unsigned int val @@    got restricted __be3unsigned int val @@
   drivers/net/ethernet/google/gve/gve_main.c:733:24: sparse:    expected unsigned int val
   drivers/net/ethernet/google/gve/gve_main.c:733:24: sparse:    got restricted __be32 [usertype]
   drivers/net/ethernet/google/gve/gve_main.c:907:25: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/google/gve/gve_main.c:907:25: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/google/gve/gve_main.c:907:25: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/google/gve/gve_main.c:907:25: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/google/gve/gve_main.c:907:25: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/google/gve/gve_main.c:907:25: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/google/gve/gve_main.c:908:25: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/google/gve/gve_main.c:908:25: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/google/gve/gve_main.c:908:25: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/google/gve/gve_main.c:908:25: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/google/gve/gve_main.c:908:25: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/google/gve/gve_main.c:908:25: sparse: sparse: cast to restricted __be32
--
>> drivers/net/ethernet/google/gve/gve_tx.c:145:6: sparse: sparse: symbol 'gve_tx_free_ring' was not declared. Should it be static?
>> drivers/net/ethernet/google/gve/gve_tx.c:18:16: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected unsigned int val @@    got restricted __be3unsigned int val @@
>> drivers/net/ethernet/google/gve/gve_tx.c:18:16: sparse:    expected unsigned int val
>> drivers/net/ethernet/google/gve/gve_tx.c:18:16: sparse:    got restricted __be32 [usertype] val
>> drivers/net/ethernet/google/gve/gve_tx.c:18:16: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected unsigned int val @@    got restricted __be3unsigned int val @@
>> drivers/net/ethernet/google/gve/gve_tx.c:18:16: sparse:    expected unsigned int val
>> drivers/net/ethernet/google/gve/gve_tx.c:18:16: sparse:    got restricted __be32 [usertype] val
--
>> drivers/net/ethernet/google/gve/gve_rx.c:11:6: sparse: sparse: symbol 'gve_rx_remove_from_block' was not declared. Should it be static?
>> drivers/net/ethernet/google/gve/gve_rx.c:217:16: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected unsigned int val @@    got restricted __be3unsigned int val @@
>> drivers/net/ethernet/google/gve/gve_rx.c:217:16: sparse:    expected unsigned int val
>> drivers/net/ethernet/google/gve/gve_rx.c:217:16: sparse:    got restricted __be32 [usertype]
>> drivers/net/ethernet/google/gve/gve_rx.c:349:27: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __wsum [usertype] csum @@    got restricted __wsum [usertype] csum @@
>> drivers/net/ethernet/google/gve/gve_rx.c:349:27: sparse:    expected restricted __wsum [usertype] csum
>> drivers/net/ethernet/google/gve/gve_rx.c:349:27: sparse:    got restricted __be16 [usertype] csum
>> drivers/net/ethernet/google/gve/gve_rx.c:374:19: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] flags_seq @@    got resunsigned short [usertype] flags_seq @@
>> drivers/net/ethernet/google/gve/gve_rx.c:374:19: sparse:    expected unsigned short [usertype] flags_seq
>> drivers/net/ethernet/google/gve/gve_rx.c:374:19: sparse:    got restricted __be16 [usertype] flags_seq

Please review and possibly fold the followup patch.

vim +79 drivers/net/ethernet/google/gve/gve_main.c

    24	
  > 25	const char gve_version_str[] = GVE_VERSION;
    26	const char gve_version_prefix[] = GVE_VERSION_PREFIX;
    27	
    28	static void gve_get_stats(struct net_device *dev, struct rtnl_link_stats64 *s)
    29	{
    30		struct gve_priv *priv = netdev_priv(dev);
    31		int ring;
    32	
    33		if (priv->rx) {
    34			for (ring = 0; ring < priv->rx_cfg.num_queues; ring++) {
    35				s->rx_packets += priv->rx[ring].rpackets;
    36				s->rx_bytes += priv->rx[ring].rbytes;
    37			}
    38		}
    39		if (priv->tx) {
    40			for (ring = 0; ring < priv->tx_cfg.num_queues; ring++) {
    41				s->tx_packets += priv->tx[ring].pkt_done;
    42				s->tx_bytes += priv->tx[ring].bytes_done;
    43			}
    44		}
    45	}
    46	
    47	static int gve_alloc_counter_array(struct gve_priv *priv)
    48	{
    49		priv->counter_array =
    50			dma_alloc_coherent(&priv->pdev->dev,
    51					   priv->num_event_counters *
    52					   sizeof(*priv->counter_array),
    53					   &priv->counter_array_bus, GFP_KERNEL);
    54		if (!priv->counter_array)
    55			return -ENOMEM;
    56	
    57		return 0;
    58	}
    59	
    60	static void gve_free_counter_array(struct gve_priv *priv)
    61	{
    62		dma_free_coherent(&priv->pdev->dev,
    63				  priv->num_event_counters *
    64				  sizeof(*priv->counter_array),
    65				  priv->counter_array, priv->counter_array_bus);
    66		priv->counter_array = NULL;
    67	}
    68	
    69	static irqreturn_t gve_mgmnt_intr(int irq, void *arg)
    70	{
    71		return IRQ_HANDLED;
    72	}
    73	
    74	static irqreturn_t gve_intr(int irq, void *arg)
    75	{
    76		struct gve_notify_block *block = arg;
    77		struct gve_priv *priv = block->priv;
    78	
  > 79		writel(cpu_to_be32(GVE_IRQ_MASK), gve_irq_doorbell(priv, block));
    80		napi_schedule_irqoff(&block->napi);
    81		return IRQ_HANDLED;
    82	}
    83	
  > 84	int gve_napi_poll(struct napi_struct *napi, int budget)
    85	{
    86		struct gve_notify_block *block;
    87		__be32 __iomem *irq_doorbell;
    88		bool reschedule = false;
    89		struct gve_priv *priv;
    90	
    91		block = container_of(napi, struct gve_notify_block, napi);
    92		priv = block->priv;
    93	
    94		if (block->tx)
    95			reschedule |= gve_tx_poll(block, budget);
    96		if (block->rx)
    97			reschedule |= gve_rx_poll(block, budget);
    98	
    99		if (reschedule)
   100			return budget;
   101	
   102		napi_complete(napi);
   103		irq_doorbell = gve_irq_doorbell(priv, block);
   104		writel(cpu_to_be32(GVE_IRQ_ACK | GVE_IRQ_EVENT), irq_doorbell);
   105	
   106		/* Double check we have no extra work.
   107		 * Ensure unmask synchronizes with checking for work.
   108		 */
   109		dma_rmb();
   110		if (block->tx)
   111			reschedule |= gve_tx_poll(block, -1);
   112		if (block->rx)
   113			reschedule |= gve_rx_poll(block, -1);
   114		if (reschedule && napi_reschedule(napi))
   115			writel(cpu_to_be32(GVE_IRQ_MASK), irq_doorbell);
   116	
   117		return 0;
   118	}
   119	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

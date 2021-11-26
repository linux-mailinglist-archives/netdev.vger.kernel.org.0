Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C78D45F5A3
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 21:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhKZUJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 15:09:36 -0500
Received: from mga17.intel.com ([192.55.52.151]:23888 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238834AbhKZUHg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 15:07:36 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10180"; a="216419660"
X-IronPort-AV: E=Sophos;i="5.87,266,1631602800"; 
   d="scan'208";a="216419660"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2021 12:04:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,266,1631602800"; 
   d="scan'208";a="652265759"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 26 Nov 2021 12:04:19 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mqhSA-0008Wj-3C; Fri, 26 Nov 2021 20:04:14 +0000
Date:   Sat, 27 Nov 2021 04:04:11 +0800
From:   kernel test robot <lkp@intel.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Subject: Re: [PATCH net-next v3 4/4] net: ocelot: add FDMA support
Message-ID: <202111270323.iOXcpsFC-lkp@intel.com>
References: <20211126172739.329098-5-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211126172739.329098-5-clement.leger@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi "Clément,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on robh/for-next]
[also build test WARNING on net/master linus/master v5.16-rc2 next-20211126]
[cannot apply to net-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Cl-ment-L-ger/Add-FDMA-support-on-ocelot-switch-driver/20211127-013140
base:   https://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git for-next
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20211127/202111270323.iOXcpsFC-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/07c95fe9105be293d2b7edf193e5fd139c70c194
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Cl-ment-L-ger/Add-FDMA-support-on-ocelot-switch-driver/20211127-013140
        git checkout 07c95fe9105be293d2b7edf193e5fd139c70c194
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=m68k SHELL=/bin/bash drivers/net/ethernet/mscc/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/mscc/ocelot_fdma.c: In function 'ocelot_fdma_tx_cleanup':
>> drivers/net/ethernet/mscc/ocelot_fdma.c:306:22: warning: variable 'tmp_head' set but not used [-Wunused-but-set-variable]
     306 |         unsigned int tmp_head, new_null_llp_idx;
         |                      ^~~~~~~~


vim +/tmp_head +306 drivers/net/ethernet/mscc/ocelot_fdma.c

   302	
   303	static void ocelot_fdma_tx_cleanup(struct ocelot_fdma *fdma, int budget)
   304	{
   305		struct ocelot_fdma_ring *ring = &fdma->inj;
 > 306		unsigned int tmp_head, new_null_llp_idx;
   307		struct ocelot_fdma_dcb *dcb;
   308		bool end_of_list = false;
   309		int ret;
   310	
   311		spin_lock_bh(&fdma->xmit_lock);
   312	
   313		/* Purge the TX packets that have been sent up to the NULL llp or the
   314		 * end of done list.
   315		 */
   316		while (!ocelot_fdma_ring_empty(&fdma->inj)) {
   317			dcb = &ring->dcbs[ring->head];
   318			if (!(dcb->hw->stat & MSCC_FDMA_DCB_STAT_PD))
   319				break;
   320	
   321			tmp_head = ring->head;
   322			ring->head = ocelot_fdma_idx_incr(ring->head);
   323	
   324			dma_unmap_single(fdma->dev, dcb->mapping, dcb->mapped_size,
   325					 DMA_TO_DEVICE);
   326			napi_consume_skb(dcb->skb, budget);
   327	
   328			/* If we hit the NULL LLP, stop, we might need to reload FDMA */
   329			if (dcb->hw->llp == 0) {
   330				end_of_list = true;
   331				break;
   332			}
   333		}
   334	
   335		/* If there is still some DCBs to be processed by the FDMA or if the
   336		 * pending list is empty, there is no need to restart the FDMA.
   337		 */
   338		if (!end_of_list || ocelot_fdma_ring_empty(&fdma->inj))
   339			goto out_unlock;
   340	
   341		ret = ocelot_fdma_wait_chan_safe(fdma, MSCC_FDMA_INJ_CHAN);
   342		if (ret) {
   343			dev_warn(fdma->dev, "Failed to wait for TX channel to stop\n");
   344			goto out_unlock;
   345		}
   346	
   347		/* Set NULL LLP */
   348		new_null_llp_idx = ocelot_fdma_idx_decr(ring->tail);
   349		dcb = &ring->dcbs[new_null_llp_idx];
   350		dcb->hw->llp = 0;
   351	
   352		dcb = &ring->dcbs[ring->head];
   353		ocelot_fdma_activate_chan(fdma, dcb, MSCC_FDMA_INJ_CHAN);
   354	
   355	out_unlock:
   356		spin_unlock_bh(&fdma->xmit_lock);
   357	}
   358	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

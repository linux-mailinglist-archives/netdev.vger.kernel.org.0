Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C63129A6E
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 20:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfLWTjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 14:39:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:64403 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726756AbfLWTjB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 14:39:01 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Dec 2019 11:39:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,348,1571727600"; 
   d="scan'208";a="418768668"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 23 Dec 2019 11:38:58 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1ijTXe-000ARz-50; Tue, 24 Dec 2019 03:38:58 +0800
Date:   Tue, 24 Dec 2019 03:38:43 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     kbuild-all@lists.01.org, davem@davemloft.net,
        michal.simek@xilinx.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        git@xilinx.com,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH net-next v2 2/3] net: emaclite: In kconfig remove arch
 dependency
Message-ID: <201912240321.RasGegIt%lkp@intel.com>
References: <1576832220-9631-3-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1576832220-9631-3-git-send-email-radhey.shyam.pandey@xilinx.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Radhey,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on net/master v5.5-rc3 next-20191220]
[cannot apply to xlnx/master]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Radhey-Shyam-Pandey/net-emaclite-Fix-coding-style/20191223-163233
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git ac80010fc94eb0680d9a432b639583bd7ac29066
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-129-g341daf20-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/xilinx/xilinx_emaclite.c:411:24: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/xilinx/xilinx_emaclite.c:411:24: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/xilinx/xilinx_emaclite.c:411:24: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/xilinx/xilinx_emaclite.c:411:24: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/xilinx/xilinx_emaclite.c:411:24: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/xilinx/xilinx_emaclite.c:411:24: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/xilinx/xilinx_emaclite.c:420:36: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/xilinx/xilinx_emaclite.c:420:36: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/xilinx/xilinx_emaclite.c:420:36: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/xilinx/xilinx_emaclite.c:420:36: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/xilinx/xilinx_emaclite.c:420:36: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/xilinx/xilinx_emaclite.c:420:36: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/xilinx/xilinx_emaclite.c:612:17: sparse: sparse: non size-preserving pointer to integer cast

vim +411 drivers/net/ethernet/xilinx/xilinx_emaclite.c

bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  363  
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  364  /**
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  365   * xemaclite_recv_data - Receive a frame
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  366   * @drvdata:	Pointer to the Emaclite device private data
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  367   * @data:	Address where the data is to be received
f713d50f33c1fb drivers/net/ethernet/xilinx/xilinx_emaclite.c Radhey Shyam Pandey 2018-06-28  368   * @maxlen:    Maximum supported ethernet packet length
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  369   *
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  370   * This function is intended to be called from the interrupt context or
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  371   * with a wrapper which waits for the receive frame to be available.
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  372   *
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  373   * Return:	Total number of bytes received
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  374   */
cd224553641848 drivers/net/ethernet/xilinx/xilinx_emaclite.c Anssi Hannula       2017-02-14  375  static u16 xemaclite_recv_data(struct net_local *drvdata, u8 *data, int maxlen)
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  376  {
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  377  	void __iomem *addr;
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  378  	u16 length, proto_type;
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  379  	u32 reg_data;
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  380  
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  381  	/* Determine the expected buffer address */
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  382  	addr = (drvdata->base_addr + drvdata->next_rx_buf_to_use);
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  383  
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  384  	/* Verify which buffer has valid data */
acf138f1b00bdd drivers/net/ethernet/xilinx/xilinx_emaclite.c Anssi Hannula       2017-02-14  385  	reg_data = xemaclite_readl(addr + XEL_RSR_OFFSET);
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  386  
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  387  	if ((reg_data & XEL_RSR_RECV_DONE_MASK) == XEL_RSR_RECV_DONE_MASK) {
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  388  		if (drvdata->rx_ping_pong != 0)
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  389  			drvdata->next_rx_buf_to_use ^= XEL_BUFFER_OFFSET;
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  390  	} else {
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  391  		/* The instance is out of sync, try other buffer if other
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  392  		 * buffer is configured, return 0 otherwise. If the instance is
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  393  		 * out of sync, do not update the 'next_rx_buf_to_use' since it
49a83f002731db drivers/net/ethernet/xilinx/xilinx_emaclite.c Radhey Shyam Pandey 2018-06-28  394  		 * will correct on subsequent calls
49a83f002731db drivers/net/ethernet/xilinx/xilinx_emaclite.c Radhey Shyam Pandey 2018-06-28  395  		 */
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  396  		if (drvdata->rx_ping_pong != 0)
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  397  			addr = (void __iomem __force *)((u32 __force)addr ^
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  398  							 XEL_BUFFER_OFFSET);
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  399  		else
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  400  			return 0;	/* No data was available */
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  401  
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  402  		/* Verify that buffer has valid data */
acf138f1b00bdd drivers/net/ethernet/xilinx/xilinx_emaclite.c Anssi Hannula       2017-02-14  403  		reg_data = xemaclite_readl(addr + XEL_RSR_OFFSET);
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  404  		if ((reg_data & XEL_RSR_RECV_DONE_MASK) !=
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  405  		     XEL_RSR_RECV_DONE_MASK)
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  406  			return 0;	/* No data was available */
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  407  	}
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  408  
49a83f002731db drivers/net/ethernet/xilinx/xilinx_emaclite.c Radhey Shyam Pandey 2018-06-28  409  	/* Get the protocol type of the ethernet frame that arrived
49a83f002731db drivers/net/ethernet/xilinx/xilinx_emaclite.c Radhey Shyam Pandey 2018-06-28  410  	 */
acf138f1b00bdd drivers/net/ethernet/xilinx/xilinx_emaclite.c Anssi Hannula       2017-02-14 @411  	proto_type = ((ntohl(xemaclite_readl(addr + XEL_HEADER_OFFSET +
44180a573ec936 drivers/net/xilinx_emaclite.c                 Michal Simek        2010-09-10  412  			XEL_RXBUFF_OFFSET)) >> XEL_HEADER_SHIFT) &
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  413  			XEL_RPLR_LENGTH_MASK);
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  414  
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  415  	/* Check if received ethernet frame is a raw ethernet frame
49a83f002731db drivers/net/ethernet/xilinx/xilinx_emaclite.c Radhey Shyam Pandey 2018-06-28  416  	 * or an IP packet or an ARP packet
49a83f002731db drivers/net/ethernet/xilinx/xilinx_emaclite.c Radhey Shyam Pandey 2018-06-28  417  	 */
cd224553641848 drivers/net/ethernet/xilinx/xilinx_emaclite.c Anssi Hannula       2017-02-14  418  	if (proto_type > ETH_DATA_LEN) {
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  419  		if (proto_type == ETH_P_IP) {
acf138f1b00bdd drivers/net/ethernet/xilinx/xilinx_emaclite.c Anssi Hannula       2017-02-14  420  			length = ((ntohl(xemaclite_readl(addr +
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  421  					XEL_HEADER_IP_LENGTH_OFFSET +
44180a573ec936 drivers/net/xilinx_emaclite.c                 Michal Simek        2010-09-10  422  					XEL_RXBUFF_OFFSET)) >>
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  423  					XEL_HEADER_SHIFT) &
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  424  					XEL_RPLR_LENGTH_MASK);
cd224553641848 drivers/net/ethernet/xilinx/xilinx_emaclite.c Anssi Hannula       2017-02-14  425  			length = min_t(u16, length, ETH_DATA_LEN);
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  426  			length += ETH_HLEN + ETH_FCS_LEN;
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  427  
69ddb40fcc98c1 drivers/net/ethernet/xilinx/xilinx_emaclite.c Radhey Shyam Pandey 2019-12-20  428  		} else if (proto_type == ETH_P_ARP) {
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  429  			length = XEL_ARP_PACKET_SIZE + ETH_HLEN + ETH_FCS_LEN;
69ddb40fcc98c1 drivers/net/ethernet/xilinx/xilinx_emaclite.c Radhey Shyam Pandey 2019-12-20  430  		} else {
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  431  			/* Field contains type other than IP or ARP, use max
49a83f002731db drivers/net/ethernet/xilinx/xilinx_emaclite.c Radhey Shyam Pandey 2018-06-28  432  			 * frame size and let user parse it
49a83f002731db drivers/net/ethernet/xilinx/xilinx_emaclite.c Radhey Shyam Pandey 2018-06-28  433  			 */
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  434  			length = ETH_FRAME_LEN + ETH_FCS_LEN;
69ddb40fcc98c1 drivers/net/ethernet/xilinx/xilinx_emaclite.c Radhey Shyam Pandey 2019-12-20  435  		}
69ddb40fcc98c1 drivers/net/ethernet/xilinx/xilinx_emaclite.c Radhey Shyam Pandey 2019-12-20  436  	} else {
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  437  		/* Use the length in the frame, plus the header and trailer */
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  438  		length = proto_type + ETH_HLEN + ETH_FCS_LEN;
69ddb40fcc98c1 drivers/net/ethernet/xilinx/xilinx_emaclite.c Radhey Shyam Pandey 2019-12-20  439  	}
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  440  
cd224553641848 drivers/net/ethernet/xilinx/xilinx_emaclite.c Anssi Hannula       2017-02-14  441  	if (WARN_ON(length > maxlen))
cd224553641848 drivers/net/ethernet/xilinx/xilinx_emaclite.c Anssi Hannula       2017-02-14  442  		length = maxlen;
cd224553641848 drivers/net/ethernet/xilinx/xilinx_emaclite.c Anssi Hannula       2017-02-14  443  
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  444  	/* Read from the EmacLite device */
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  445  	xemaclite_aligned_read((u32 __force *)(addr + XEL_RXBUFF_OFFSET),
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  446  			       data, length);
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  447  
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  448  	/* Acknowledge the frame */
acf138f1b00bdd drivers/net/ethernet/xilinx/xilinx_emaclite.c Anssi Hannula       2017-02-14  449  	reg_data = xemaclite_readl(addr + XEL_RSR_OFFSET);
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  450  	reg_data &= ~XEL_RSR_RECV_DONE_MASK;
acf138f1b00bdd drivers/net/ethernet/xilinx/xilinx_emaclite.c Anssi Hannula       2017-02-14  451  	xemaclite_writel(reg_data, addr + XEL_RSR_OFFSET);
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  452  
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  453  	return length;
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  454  }
bb81b2ddfa194b drivers/net/xilinx_emaclite.c                 John Linn           2009-08-20  455  

:::::: The code at line 411 was first introduced by commit
:::::: acf138f1b00bdd1b7cd9894562ed0c2a1670888e net: xilinx_emaclite: fix freezes due to unordered I/O

:::::: TO: Anssi Hannula <anssi.hannula@bitwise.fi>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation

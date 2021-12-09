Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 761D546E15B
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 04:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhLIDxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 22:53:42 -0500
Received: from mga18.intel.com ([134.134.136.126]:59952 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231596AbhLIDxl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 22:53:41 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="224878337"
X-IronPort-AV: E=Sophos;i="5.88,191,1635231600"; 
   d="scan'208";a="224878337"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 19:50:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,191,1635231600"; 
   d="scan'208";a="461974441"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 08 Dec 2021 19:50:06 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mvARZ-0001Q6-HG; Thu, 09 Dec 2021 03:50:05 +0000
Date:   Thu, 9 Dec 2021 11:49:31 +0800
From:   kernel test robot <lkp@intel.com>
To:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        Joe Damato <jdamato@fastly.com>
Subject: Re: [PATCH] net/i40e: fix unsigned stat widths
Message-ID: <202112091109.hhwYyNeJ-lkp@intel.com>
References: <1638989778-126260-1-git-send-email-jdamato@fastly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1638989778-126260-1-git-send-email-jdamato@fastly.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joe,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on tnguy-next-queue/dev-queue]
[also build test WARNING on net/master horms-ipvs/master net-next/master v5.16-rc4 next-20211208]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Joe-Damato/net-i40e-fix-unsigned-stat-widths/20211209-025738
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue.git dev-queue
config: i386-randconfig-c001-20211207 (https://download.01.org/0day-ci/archive/20211209/202112091109.hhwYyNeJ-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 097a1cb1d5ebb3a0ec4bcaed8ba3ff6a8e33c00a)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/0231b0742caf367642f2a31147e272cf48cff9d5
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Joe-Damato/net-i40e-fix-unsigned-stat-widths/20211209-025738
        git checkout 0231b0742caf367642f2a31147e272cf48cff9d5
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/ethernet/intel/i40e/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/intel/i40e/i40e_debugfs.c:245:4: warning: format specifies type 'int' but the argument has type 'u64' (aka 'unsigned long long') [-Wformat]
                    vsi->rx_buf_failed, vsi->rx_page_failed);
                    ^~~~~~~~~~~~~~~~~~
   include/linux/dev_printk.h:150:67: note: expanded from macro 'dev_info'
           dev_printk_index_wrap(_dev_info, KERN_INFO, dev, dev_fmt(fmt), ##__VA_ARGS__)
                                                                    ~~~     ^~~~~~~~~~~
   include/linux/dev_printk.h:110:23: note: expanded from macro 'dev_printk_index_wrap'
                   _p_func(dev, fmt, ##__VA_ARGS__);                       \
                                ~~~    ^~~~~~~~~~~
   drivers/net/ethernet/intel/i40e/i40e_debugfs.c:245:24: warning: format specifies type 'int' but the argument has type 'u64' (aka 'unsigned long long') [-Wformat]
                    vsi->rx_buf_failed, vsi->rx_page_failed);
                                        ^~~~~~~~~~~~~~~~~~~
   include/linux/dev_printk.h:150:67: note: expanded from macro 'dev_info'
           dev_printk_index_wrap(_dev_info, KERN_INFO, dev, dev_fmt(fmt), ##__VA_ARGS__)
                                                                    ~~~     ^~~~~~~~~~~
   include/linux/dev_printk.h:110:23: note: expanded from macro 'dev_printk_index_wrap'
                   _p_func(dev, fmt, ##__VA_ARGS__);                       \
                                ~~~    ^~~~~~~~~~~
   2 warnings generated.


vim +245 drivers/net/ethernet/intel/i40e/i40e_debugfs.c

c3c7ea27bec070 Mitch Williams     2016-06-20  109  
02e9c290814cc1 Jesse Brandeburg   2013-09-11  110  /**
e625f71ba1faa0 Shannon Nelson     2013-11-26  111   * i40e_dbg_dump_vsi_seid - handles dump vsi seid write into command datum
02e9c290814cc1 Jesse Brandeburg   2013-09-11  112   * @pf: the i40e_pf created in command write
02e9c290814cc1 Jesse Brandeburg   2013-09-11  113   * @seid: the seid the user put in
02e9c290814cc1 Jesse Brandeburg   2013-09-11  114   **/
02e9c290814cc1 Jesse Brandeburg   2013-09-11  115  static void i40e_dbg_dump_vsi_seid(struct i40e_pf *pf, int seid)
02e9c290814cc1 Jesse Brandeburg   2013-09-11  116  {
02e9c290814cc1 Jesse Brandeburg   2013-09-11  117  	struct rtnl_link_stats64 *nstat;
02e9c290814cc1 Jesse Brandeburg   2013-09-11  118  	struct i40e_mac_filter *f;
02e9c290814cc1 Jesse Brandeburg   2013-09-11  119  	struct i40e_vsi *vsi;
278e7d0b9d6864 Jacob Keller       2016-10-05  120  	int i, bkt;
02e9c290814cc1 Jesse Brandeburg   2013-09-11  121  
02e9c290814cc1 Jesse Brandeburg   2013-09-11  122  	vsi = i40e_dbg_find_vsi(pf, seid);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  123  	if (!vsi) {
02e9c290814cc1 Jesse Brandeburg   2013-09-11  124  		dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  125  			 "dump %d: seid not found\n", seid);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  126  		return;
02e9c290814cc1 Jesse Brandeburg   2013-09-11  127  	}
02e9c290814cc1 Jesse Brandeburg   2013-09-11  128  	dev_info(&pf->pdev->dev, "vsi seid %d\n", seid);
de1017f76a9ba9 Shannon Nelson     2015-12-23  129  	if (vsi->netdev) {
de1017f76a9ba9 Shannon Nelson     2015-12-23  130  		struct net_device *nd = vsi->netdev;
de1017f76a9ba9 Shannon Nelson     2015-12-23  131  
de1017f76a9ba9 Shannon Nelson     2015-12-23  132  		dev_info(&pf->pdev->dev, "    netdev: name = %s, state = %lu, flags = 0x%08x\n",
de1017f76a9ba9 Shannon Nelson     2015-12-23  133  			 nd->name, nd->state, nd->flags);
de1017f76a9ba9 Shannon Nelson     2015-12-23  134  		dev_info(&pf->pdev->dev, "        features      = 0x%08lx\n",
de1017f76a9ba9 Shannon Nelson     2015-12-23  135  			 (unsigned long int)nd->features);
de1017f76a9ba9 Shannon Nelson     2015-12-23  136  		dev_info(&pf->pdev->dev, "        hw_features   = 0x%08lx\n",
de1017f76a9ba9 Shannon Nelson     2015-12-23  137  			 (unsigned long int)nd->hw_features);
de1017f76a9ba9 Shannon Nelson     2015-12-23  138  		dev_info(&pf->pdev->dev, "        vlan_features = 0x%08lx\n",
de1017f76a9ba9 Shannon Nelson     2015-12-23  139  			 (unsigned long int)nd->vlan_features);
de1017f76a9ba9 Shannon Nelson     2015-12-23  140  	}
02e9c290814cc1 Jesse Brandeburg   2013-09-11  141  	dev_info(&pf->pdev->dev,
0da36b9774cc24 Jacob Keller       2017-04-19  142  		 "    flags = 0x%08lx, netdev_registered = %i, current_netdev_flags = 0x%04x\n",
0da36b9774cc24 Jacob Keller       2017-04-19  143  		 vsi->flags, vsi->netdev_registered, vsi->current_netdev_flags);
0da36b9774cc24 Jacob Keller       2017-04-19  144  	for (i = 0; i < BITS_TO_LONGS(__I40E_VSI_STATE_SIZE__); i++)
0da36b9774cc24 Jacob Keller       2017-04-19  145  		dev_info(&pf->pdev->dev,
0da36b9774cc24 Jacob Keller       2017-04-19  146  			 "    state[%d] = %08lx\n",
0da36b9774cc24 Jacob Keller       2017-04-19  147  			 i, vsi->state[i]);
2ddb80c9c4b181 Shannon Nelson     2015-02-27  148  	if (vsi == pf->vsi[pf->lan_vsi])
2ddb80c9c4b181 Shannon Nelson     2015-02-27  149  		dev_info(&pf->pdev->dev, "    MAC address: %pM SAN MAC: %pM Port MAC: %pM\n",
2ddb80c9c4b181 Shannon Nelson     2015-02-27  150  			 pf->hw.mac.addr,
2ddb80c9c4b181 Shannon Nelson     2015-02-27  151  			 pf->hw.mac.san_addr,
2ddb80c9c4b181 Shannon Nelson     2015-02-27  152  			 pf->hw.mac.port_addr);
278e7d0b9d6864 Jacob Keller       2016-10-05  153  	hash_for_each(vsi->mac_filter_hash, bkt, f, hlist) {
02e9c290814cc1 Jesse Brandeburg   2013-09-11  154  		dev_info(&pf->pdev->dev,
1bc87e807a6510 Jacob Keller       2016-10-05  155  			 "    mac_filter_hash: %pM vid=%d, state %s\n",
1bc87e807a6510 Jacob Keller       2016-10-05  156  			 f->macaddr, f->vlan,
1bc87e807a6510 Jacob Keller       2016-10-05  157  			 i40e_filter_state_string[f->state]);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  158  	}
5951cf9495bcd2 Jacob Keller       2016-11-21  159  	dev_info(&pf->pdev->dev, "    active_filters %u, promisc_threshold %u, overflow promisc %s\n",
c3c7ea27bec070 Mitch Williams     2016-06-20  160  		 vsi->active_filters, vsi->promisc_threshold,
0da36b9774cc24 Jacob Keller       2017-04-19  161  		 (test_bit(__I40E_VSI_OVERFLOW_PROMISC, vsi->state) ?
c3c7ea27bec070 Mitch Williams     2016-06-20  162  		  "ON" : "OFF"));
02e9c290814cc1 Jesse Brandeburg   2013-09-11  163  	nstat = i40e_get_vsi_stats_struct(vsi);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  164  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  165  		 "    net_stats: rx_packets = %lu, rx_bytes = %lu, rx_errors = %lu, rx_dropped = %lu\n",
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  166  		 (unsigned long int)nstat->rx_packets,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  167  		 (unsigned long int)nstat->rx_bytes,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  168  		 (unsigned long int)nstat->rx_errors,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  169  		 (unsigned long int)nstat->rx_dropped);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  170  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  171  		 "    net_stats: tx_packets = %lu, tx_bytes = %lu, tx_errors = %lu, tx_dropped = %lu\n",
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  172  		 (unsigned long int)nstat->tx_packets,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  173  		 (unsigned long int)nstat->tx_bytes,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  174  		 (unsigned long int)nstat->tx_errors,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  175  		 (unsigned long int)nstat->tx_dropped);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  176  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  177  		 "    net_stats: multicast = %lu, collisions = %lu\n",
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  178  		 (unsigned long int)nstat->multicast,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  179  		 (unsigned long int)nstat->collisions);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  180  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  181  		 "    net_stats: rx_length_errors = %lu, rx_over_errors = %lu, rx_crc_errors = %lu\n",
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  182  		 (unsigned long int)nstat->rx_length_errors,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  183  		 (unsigned long int)nstat->rx_over_errors,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  184  		 (unsigned long int)nstat->rx_crc_errors);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  185  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  186  		 "    net_stats: rx_frame_errors = %lu, rx_fifo_errors = %lu, rx_missed_errors = %lu\n",
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  187  		 (unsigned long int)nstat->rx_frame_errors,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  188  		 (unsigned long int)nstat->rx_fifo_errors,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  189  		 (unsigned long int)nstat->rx_missed_errors);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  190  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  191  		 "    net_stats: tx_aborted_errors = %lu, tx_carrier_errors = %lu, tx_fifo_errors = %lu\n",
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  192  		 (unsigned long int)nstat->tx_aborted_errors,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  193  		 (unsigned long int)nstat->tx_carrier_errors,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  194  		 (unsigned long int)nstat->tx_fifo_errors);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  195  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  196  		 "    net_stats: tx_heartbeat_errors = %lu, tx_window_errors = %lu\n",
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  197  		 (unsigned long int)nstat->tx_heartbeat_errors,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  198  		 (unsigned long int)nstat->tx_window_errors);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  199  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  200  		 "    net_stats: rx_compressed = %lu, tx_compressed = %lu\n",
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  201  		 (unsigned long int)nstat->rx_compressed,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  202  		 (unsigned long int)nstat->tx_compressed);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  203  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  204  		 "    net_stats_offsets: rx_packets = %lu, rx_bytes = %lu, rx_errors = %lu, rx_dropped = %lu\n",
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  205  		 (unsigned long int)vsi->net_stats_offsets.rx_packets,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  206  		 (unsigned long int)vsi->net_stats_offsets.rx_bytes,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  207  		 (unsigned long int)vsi->net_stats_offsets.rx_errors,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  208  		 (unsigned long int)vsi->net_stats_offsets.rx_dropped);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  209  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  210  		 "    net_stats_offsets: tx_packets = %lu, tx_bytes = %lu, tx_errors = %lu, tx_dropped = %lu\n",
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  211  		 (unsigned long int)vsi->net_stats_offsets.tx_packets,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  212  		 (unsigned long int)vsi->net_stats_offsets.tx_bytes,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  213  		 (unsigned long int)vsi->net_stats_offsets.tx_errors,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  214  		 (unsigned long int)vsi->net_stats_offsets.tx_dropped);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  215  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  216  		 "    net_stats_offsets: multicast = %lu, collisions = %lu\n",
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  217  		 (unsigned long int)vsi->net_stats_offsets.multicast,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  218  		 (unsigned long int)vsi->net_stats_offsets.collisions);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  219  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  220  		 "    net_stats_offsets: rx_length_errors = %lu, rx_over_errors = %lu, rx_crc_errors = %lu\n",
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  221  		 (unsigned long int)vsi->net_stats_offsets.rx_length_errors,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  222  		 (unsigned long int)vsi->net_stats_offsets.rx_over_errors,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  223  		 (unsigned long int)vsi->net_stats_offsets.rx_crc_errors);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  224  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  225  		 "    net_stats_offsets: rx_frame_errors = %lu, rx_fifo_errors = %lu, rx_missed_errors = %lu\n",
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  226  		 (unsigned long int)vsi->net_stats_offsets.rx_frame_errors,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  227  		 (unsigned long int)vsi->net_stats_offsets.rx_fifo_errors,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  228  		 (unsigned long int)vsi->net_stats_offsets.rx_missed_errors);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  229  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  230  		 "    net_stats_offsets: tx_aborted_errors = %lu, tx_carrier_errors = %lu, tx_fifo_errors = %lu\n",
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  231  		 (unsigned long int)vsi->net_stats_offsets.tx_aborted_errors,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  232  		 (unsigned long int)vsi->net_stats_offsets.tx_carrier_errors,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  233  		 (unsigned long int)vsi->net_stats_offsets.tx_fifo_errors);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  234  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  235  		 "    net_stats_offsets: tx_heartbeat_errors = %lu, tx_window_errors = %lu\n",
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  236  		 (unsigned long int)vsi->net_stats_offsets.tx_heartbeat_errors,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  237  		 (unsigned long int)vsi->net_stats_offsets.tx_window_errors);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  238  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  239  		 "    net_stats_offsets: rx_compressed = %lu, tx_compressed = %lu\n",
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  240  		 (unsigned long int)vsi->net_stats_offsets.rx_compressed,
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  241  		 (unsigned long int)vsi->net_stats_offsets.tx_compressed);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  242  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  243  		 "    tx_restart = %d, tx_busy = %d, rx_buf_failed = %d, rx_page_failed = %d\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  244  		 vsi->tx_restart, vsi->tx_busy,
02e9c290814cc1 Jesse Brandeburg   2013-09-11 @245  		 vsi->rx_buf_failed, vsi->rx_page_failed);
9f65e15b4f9823 Alexander Duyck    2013-09-28  246  	rcu_read_lock();
02e9c290814cc1 Jesse Brandeburg   2013-09-11  247  	for (i = 0; i < vsi->num_queue_pairs; i++) {
6aa7de059173a9 Mark Rutland       2017-10-23  248  		struct i40e_ring *rx_ring = READ_ONCE(vsi->rx_rings[i]);
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  249  
9f65e15b4f9823 Alexander Duyck    2013-09-28  250  		if (!rx_ring)
9f65e15b4f9823 Alexander Duyck    2013-09-28  251  			continue;
9f65e15b4f9823 Alexander Duyck    2013-09-28  252  
02e9c290814cc1 Jesse Brandeburg   2013-09-11  253  		dev_info(&pf->pdev->dev,
bd6cd4e6dd38a3 Jesse Brandeburg   2017-08-29  254  			 "    rx_rings[%i]: state = %lu, queue_index = %d, reg_idx = %d\n",
bd6cd4e6dd38a3 Jesse Brandeburg   2017-08-29  255  			 i, *rx_ring->state,
9f65e15b4f9823 Alexander Duyck    2013-09-28  256  			 rx_ring->queue_index,
9f65e15b4f9823 Alexander Duyck    2013-09-28  257  			 rx_ring->reg_idx);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  258  		dev_info(&pf->pdev->dev,
1a557afc4dd59b Jesse Brandeburg   2016-04-20  259  			 "    rx_rings[%i]: rx_buf_len = %d\n",
1a557afc4dd59b Jesse Brandeburg   2016-04-20  260  			 i, rx_ring->rx_buf_len);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  261  		dev_info(&pf->pdev->dev,
b32bfa17246d83 Jesse Brandeburg   2016-04-18  262  			 "    rx_rings[%i]: next_to_use = %d, next_to_clean = %d, ring_active = %i\n",
b32bfa17246d83 Jesse Brandeburg   2016-04-18  263  			 i,
9f65e15b4f9823 Alexander Duyck    2013-09-28  264  			 rx_ring->next_to_use,
9f65e15b4f9823 Alexander Duyck    2013-09-28  265  			 rx_ring->next_to_clean,
9f65e15b4f9823 Alexander Duyck    2013-09-28  266  			 rx_ring->ring_active);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  267  		dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  268  			 "    rx_rings[%i]: rx_stats: packets = %lld, bytes = %lld, non_eop_descs = %lld\n",
9f65e15b4f9823 Alexander Duyck    2013-09-28  269  			 i, rx_ring->stats.packets,
9f65e15b4f9823 Alexander Duyck    2013-09-28  270  			 rx_ring->stats.bytes,
9f65e15b4f9823 Alexander Duyck    2013-09-28  271  			 rx_ring->rx_stats.non_eop_descs);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  272  		dev_info(&pf->pdev->dev,
420136cccb3b04 Mitch Williams     2013-12-18  273  			 "    rx_rings[%i]: rx_stats: alloc_page_failed = %lld, alloc_buff_failed = %lld\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  274  			 i,
420136cccb3b04 Mitch Williams     2013-12-18  275  			 rx_ring->rx_stats.alloc_page_failed,
420136cccb3b04 Mitch Williams     2013-12-18  276  			 rx_ring->rx_stats.alloc_buff_failed);
f16704e5e8aed1 Mitch Williams     2016-01-13  277  		dev_info(&pf->pdev->dev,
f16704e5e8aed1 Mitch Williams     2016-01-13  278  			 "    rx_rings[%i]: rx_stats: realloc_count = %lld, page_reuse_count = %lld\n",
f16704e5e8aed1 Mitch Williams     2016-01-13  279  			 i,
f16704e5e8aed1 Mitch Williams     2016-01-13  280  			 rx_ring->rx_stats.realloc_count,
f16704e5e8aed1 Mitch Williams     2016-01-13  281  			 rx_ring->rx_stats.page_reuse_count);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  282  		dev_info(&pf->pdev->dev,
7be78aa444794d Mitch Williams     2018-01-22  283  			 "    rx_rings[%i]: size = %i\n",
7be78aa444794d Mitch Williams     2018-01-22  284  			 i, rx_ring->size);
a75e8005d506f3 Kan Liang          2016-02-19  285  		dev_info(&pf->pdev->dev,
40588ca6513729 Alexander Duyck    2017-12-29  286  			 "    rx_rings[%i]: itr_setting = %d (%s)\n",
40588ca6513729 Alexander Duyck    2017-12-29  287  			 i, rx_ring->itr_setting,
40588ca6513729 Alexander Duyck    2017-12-29  288  			 ITR_IS_DYNAMIC(rx_ring->itr_setting) ? "dynamic" : "fixed");
02e9c290814cc1 Jesse Brandeburg   2013-09-11  289  	}
02e9c290814cc1 Jesse Brandeburg   2013-09-11  290  	for (i = 0; i < vsi->num_queue_pairs; i++) {
6aa7de059173a9 Mark Rutland       2017-10-23  291  		struct i40e_ring *tx_ring = READ_ONCE(vsi->tx_rings[i]);
6995b36c0fc3dd Jesse Brandeburg   2015-08-28  292  
9f65e15b4f9823 Alexander Duyck    2013-09-28  293  		if (!tx_ring)
9f65e15b4f9823 Alexander Duyck    2013-09-28  294  			continue;
1b60f3c41654a8 Jesse Brandeburg   2013-11-28  295  
02e9c290814cc1 Jesse Brandeburg   2013-09-11  296  		dev_info(&pf->pdev->dev,
bd6cd4e6dd38a3 Jesse Brandeburg   2017-08-29  297  			 "    tx_rings[%i]: state = %lu, queue_index = %d, reg_idx = %d\n",
bd6cd4e6dd38a3 Jesse Brandeburg   2017-08-29  298  			 i, *tx_ring->state,
9f65e15b4f9823 Alexander Duyck    2013-09-28  299  			 tx_ring->queue_index,
9f65e15b4f9823 Alexander Duyck    2013-09-28  300  			 tx_ring->reg_idx);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  301  		dev_info(&pf->pdev->dev,
4668607aa30b38 Mitch Williams     2016-01-13  302  			 "    tx_rings[%i]: next_to_use = %d, next_to_clean = %d, ring_active = %i\n",
4668607aa30b38 Mitch Williams     2016-01-13  303  			 i,
9f65e15b4f9823 Alexander Duyck    2013-09-28  304  			 tx_ring->next_to_use,
9f65e15b4f9823 Alexander Duyck    2013-09-28  305  			 tx_ring->next_to_clean,
9f65e15b4f9823 Alexander Duyck    2013-09-28  306  			 tx_ring->ring_active);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  307  		dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  308  			 "    tx_rings[%i]: tx_stats: packets = %lld, bytes = %lld, restart_queue = %lld\n",
9f65e15b4f9823 Alexander Duyck    2013-09-28  309  			 i, tx_ring->stats.packets,
9f65e15b4f9823 Alexander Duyck    2013-09-28  310  			 tx_ring->stats.bytes,
9f65e15b4f9823 Alexander Duyck    2013-09-28  311  			 tx_ring->tx_stats.restart_queue);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  312  		dev_info(&pf->pdev->dev,
c304fdac6cc0aa Alexander Duyck    2013-09-28  313  			 "    tx_rings[%i]: tx_stats: tx_busy = %lld, tx_done_old = %lld\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  314  			 i,
9f65e15b4f9823 Alexander Duyck    2013-09-28  315  			 tx_ring->tx_stats.tx_busy,
9f65e15b4f9823 Alexander Duyck    2013-09-28  316  			 tx_ring->tx_stats.tx_done_old);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  317  		dev_info(&pf->pdev->dev,
7be78aa444794d Mitch Williams     2018-01-22  318  			 "    tx_rings[%i]: size = %i\n",
7be78aa444794d Mitch Williams     2018-01-22  319  			 i, tx_ring->size);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  320  		dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  321  			 "    tx_rings[%i]: DCB tc = %d\n",
9f65e15b4f9823 Alexander Duyck    2013-09-28  322  			 i, tx_ring->dcb_tc);
a75e8005d506f3 Kan Liang          2016-02-19  323  		dev_info(&pf->pdev->dev,
40588ca6513729 Alexander Duyck    2017-12-29  324  			 "    tx_rings[%i]: itr_setting = %d (%s)\n",
40588ca6513729 Alexander Duyck    2017-12-29  325  			 i, tx_ring->itr_setting,
40588ca6513729 Alexander Duyck    2017-12-29  326  			 ITR_IS_DYNAMIC(tx_ring->itr_setting) ? "dynamic" : "fixed");
02e9c290814cc1 Jesse Brandeburg   2013-09-11  327  	}
890c402c7b1131 Ciara Loftus       2020-06-23  328  	if (i40e_enabled_xdp_vsi(vsi)) {
890c402c7b1131 Ciara Loftus       2020-06-23  329  		for (i = 0; i < vsi->num_queue_pairs; i++) {
890c402c7b1131 Ciara Loftus       2020-06-23  330  			struct i40e_ring *xdp_ring = READ_ONCE(vsi->xdp_rings[i]);
890c402c7b1131 Ciara Loftus       2020-06-23  331  
890c402c7b1131 Ciara Loftus       2020-06-23  332  			if (!xdp_ring)
890c402c7b1131 Ciara Loftus       2020-06-23  333  				continue;
890c402c7b1131 Ciara Loftus       2020-06-23  334  
890c402c7b1131 Ciara Loftus       2020-06-23  335  			dev_info(&pf->pdev->dev,
890c402c7b1131 Ciara Loftus       2020-06-23  336  				 "    xdp_rings[%i]: state = %lu, queue_index = %d, reg_idx = %d\n",
890c402c7b1131 Ciara Loftus       2020-06-23  337  				 i, *xdp_ring->state,
890c402c7b1131 Ciara Loftus       2020-06-23  338  				 xdp_ring->queue_index,
890c402c7b1131 Ciara Loftus       2020-06-23  339  				 xdp_ring->reg_idx);
890c402c7b1131 Ciara Loftus       2020-06-23  340  			dev_info(&pf->pdev->dev,
890c402c7b1131 Ciara Loftus       2020-06-23  341  				 "    xdp_rings[%i]: next_to_use = %d, next_to_clean = %d, ring_active = %i\n",
890c402c7b1131 Ciara Loftus       2020-06-23  342  				 i,
890c402c7b1131 Ciara Loftus       2020-06-23  343  				 xdp_ring->next_to_use,
890c402c7b1131 Ciara Loftus       2020-06-23  344  				 xdp_ring->next_to_clean,
890c402c7b1131 Ciara Loftus       2020-06-23  345  				 xdp_ring->ring_active);
890c402c7b1131 Ciara Loftus       2020-06-23  346  			dev_info(&pf->pdev->dev,
890c402c7b1131 Ciara Loftus       2020-06-23  347  				 "    xdp_rings[%i]: tx_stats: packets = %lld, bytes = %lld, restart_queue = %lld\n",
890c402c7b1131 Ciara Loftus       2020-06-23  348  				 i, xdp_ring->stats.packets,
890c402c7b1131 Ciara Loftus       2020-06-23  349  				 xdp_ring->stats.bytes,
890c402c7b1131 Ciara Loftus       2020-06-23  350  				 xdp_ring->tx_stats.restart_queue);
890c402c7b1131 Ciara Loftus       2020-06-23  351  			dev_info(&pf->pdev->dev,
890c402c7b1131 Ciara Loftus       2020-06-23  352  				 "    xdp_rings[%i]: tx_stats: tx_busy = %lld, tx_done_old = %lld\n",
890c402c7b1131 Ciara Loftus       2020-06-23  353  				 i,
890c402c7b1131 Ciara Loftus       2020-06-23  354  				 xdp_ring->tx_stats.tx_busy,
890c402c7b1131 Ciara Loftus       2020-06-23  355  				 xdp_ring->tx_stats.tx_done_old);
890c402c7b1131 Ciara Loftus       2020-06-23  356  			dev_info(&pf->pdev->dev,
890c402c7b1131 Ciara Loftus       2020-06-23  357  				 "    xdp_rings[%i]: size = %i\n",
890c402c7b1131 Ciara Loftus       2020-06-23  358  				 i, xdp_ring->size);
890c402c7b1131 Ciara Loftus       2020-06-23  359  			dev_info(&pf->pdev->dev,
890c402c7b1131 Ciara Loftus       2020-06-23  360  				 "    xdp_rings[%i]: DCB tc = %d\n",
890c402c7b1131 Ciara Loftus       2020-06-23  361  				 i, xdp_ring->dcb_tc);
890c402c7b1131 Ciara Loftus       2020-06-23  362  			dev_info(&pf->pdev->dev,
890c402c7b1131 Ciara Loftus       2020-06-23  363  				 "    xdp_rings[%i]: itr_setting = %d (%s)\n",
890c402c7b1131 Ciara Loftus       2020-06-23  364  				 i, xdp_ring->itr_setting,
890c402c7b1131 Ciara Loftus       2020-06-23  365  				 ITR_IS_DYNAMIC(xdp_ring->itr_setting) ?
890c402c7b1131 Ciara Loftus       2020-06-23  366  				 "dynamic" : "fixed");
890c402c7b1131 Ciara Loftus       2020-06-23  367  		}
890c402c7b1131 Ciara Loftus       2020-06-23  368  	}
9f65e15b4f9823 Alexander Duyck    2013-09-28  369  	rcu_read_unlock();
02e9c290814cc1 Jesse Brandeburg   2013-09-11  370  	dev_info(&pf->pdev->dev,
a75e8005d506f3 Kan Liang          2016-02-19  371  		 "    work_limit = %d\n",
a75e8005d506f3 Kan Liang          2016-02-19  372  		 vsi->work_limit);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  373  	dev_info(&pf->pdev->dev,
1a557afc4dd59b Jesse Brandeburg   2016-04-20  374  		 "    max_frame = %d, rx_buf_len = %d dtype = %d\n",
bec60fc42b2853 Jesse Brandeburg   2016-04-18  375  		 vsi->max_frame, vsi->rx_buf_len, 0);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  376  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  377  		 "    num_q_vectors = %i, base_vector = %i\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  378  		 vsi->num_q_vectors, vsi->base_vector);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  379  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  380  		 "    seid = %d, id = %d, uplink_seid = %d\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  381  		 vsi->seid, vsi->id, vsi->uplink_seid);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  382  	dev_info(&pf->pdev->dev,
15369ac3e39777 Maciej Fijalkowski 2019-05-28  383  		 "    base_queue = %d, num_queue_pairs = %d, num_tx_desc = %d, num_rx_desc = %d\n",
15369ac3e39777 Maciej Fijalkowski 2019-05-28  384  		 vsi->base_queue, vsi->num_queue_pairs, vsi->num_tx_desc,
15369ac3e39777 Maciej Fijalkowski 2019-05-28  385  		 vsi->num_rx_desc);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  386  	dev_info(&pf->pdev->dev, "    type = %i\n", vsi->type);
3118025a070f33 Mitch Williams     2017-04-12  387  	if (vsi->type == I40E_VSI_SRIOV)
3118025a070f33 Mitch Williams     2017-04-12  388  		dev_info(&pf->pdev->dev, "    VF ID = %i\n", vsi->vf_id);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  389  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  390  		 "    info: valid_sections = 0x%04x, switch_id = 0x%04x\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  391  		 vsi->info.valid_sections, vsi->info.switch_id);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  392  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  393  		 "    info: sw_reserved[] = 0x%02x 0x%02x\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  394  		 vsi->info.sw_reserved[0], vsi->info.sw_reserved[1]);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  395  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  396  		 "    info: sec_flags = 0x%02x, sec_reserved = 0x%02x\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  397  		 vsi->info.sec_flags, vsi->info.sec_reserved);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  398  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  399  		 "    info: pvid = 0x%04x, fcoe_pvid = 0x%04x, port_vlan_flags = 0x%02x\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  400  		 vsi->info.pvid, vsi->info.fcoe_pvid,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  401  		 vsi->info.port_vlan_flags);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  402  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  403  		 "    info: pvlan_reserved[] = 0x%02x 0x%02x 0x%02x\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  404  		 vsi->info.pvlan_reserved[0], vsi->info.pvlan_reserved[1],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  405  		 vsi->info.pvlan_reserved[2]);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  406  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  407  		 "    info: ingress_table = 0x%08x, egress_table = 0x%08x\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  408  		 vsi->info.ingress_table, vsi->info.egress_table);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  409  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  410  		 "    info: cas_pv_stag = 0x%04x, cas_pv_flags= 0x%02x, cas_pv_reserved = 0x%02x\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  411  		 vsi->info.cas_pv_tag, vsi->info.cas_pv_flags,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  412  		 vsi->info.cas_pv_reserved);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  413  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  414  		 "    info: queue_mapping[0..7 ] = 0x%04x 0x%04x 0x%04x 0x%04x 0x%04x 0x%04x 0x%04x 0x%04x\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  415  		 vsi->info.queue_mapping[0], vsi->info.queue_mapping[1],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  416  		 vsi->info.queue_mapping[2], vsi->info.queue_mapping[3],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  417  		 vsi->info.queue_mapping[4], vsi->info.queue_mapping[5],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  418  		 vsi->info.queue_mapping[6], vsi->info.queue_mapping[7]);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  419  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  420  		 "    info: queue_mapping[8..15] = 0x%04x 0x%04x 0x%04x 0x%04x 0x%04x 0x%04x 0x%04x 0x%04x\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  421  		 vsi->info.queue_mapping[8], vsi->info.queue_mapping[9],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  422  		 vsi->info.queue_mapping[10], vsi->info.queue_mapping[11],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  423  		 vsi->info.queue_mapping[12], vsi->info.queue_mapping[13],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  424  		 vsi->info.queue_mapping[14], vsi->info.queue_mapping[15]);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  425  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  426  		 "    info: tc_mapping[] = 0x%04x 0x%04x 0x%04x 0x%04x 0x%04x 0x%04x 0x%04x 0x%04x\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  427  		 vsi->info.tc_mapping[0], vsi->info.tc_mapping[1],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  428  		 vsi->info.tc_mapping[2], vsi->info.tc_mapping[3],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  429  		 vsi->info.tc_mapping[4], vsi->info.tc_mapping[5],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  430  		 vsi->info.tc_mapping[6], vsi->info.tc_mapping[7]);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  431  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  432  		 "    info: queueing_opt_flags = 0x%02x  queueing_opt_reserved[0..2] = 0x%02x 0x%02x 0x%02x\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  433  		 vsi->info.queueing_opt_flags,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  434  		 vsi->info.queueing_opt_reserved[0],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  435  		 vsi->info.queueing_opt_reserved[1],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  436  		 vsi->info.queueing_opt_reserved[2]);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  437  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  438  		 "    info: up_enable_bits = 0x%02x\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  439  		 vsi->info.up_enable_bits);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  440  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  441  		 "    info: sched_reserved = 0x%02x, outer_up_table = 0x%04x\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  442  		 vsi->info.sched_reserved, vsi->info.outer_up_table);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  443  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  444  		 "    info: cmd_reserved[] = 0x%02x 0x%02x 0x%02x 0x0%02x 0x%02x 0x%02x 0x%02x 0x0%02x\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  445  		 vsi->info.cmd_reserved[0], vsi->info.cmd_reserved[1],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  446  		 vsi->info.cmd_reserved[2], vsi->info.cmd_reserved[3],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  447  		 vsi->info.cmd_reserved[4], vsi->info.cmd_reserved[5],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  448  		 vsi->info.cmd_reserved[6], vsi->info.cmd_reserved[7]);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  449  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  450  		 "    info: qs_handle[] = 0x%04x 0x%04x 0x%04x 0x%04x 0x%04x 0x%04x 0x%04x 0x%04x\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  451  		 vsi->info.qs_handle[0], vsi->info.qs_handle[1],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  452  		 vsi->info.qs_handle[2], vsi->info.qs_handle[3],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  453  		 vsi->info.qs_handle[4], vsi->info.qs_handle[5],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  454  		 vsi->info.qs_handle[6], vsi->info.qs_handle[7]);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  455  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  456  		 "    info: stat_counter_idx = 0x%04x, sched_id = 0x%04x\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  457  		 vsi->info.stat_counter_idx, vsi->info.sched_id);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  458  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  459  		 "    info: resp_reserved[] = 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  460  		 vsi->info.resp_reserved[0], vsi->info.resp_reserved[1],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  461  		 vsi->info.resp_reserved[2], vsi->info.resp_reserved[3],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  462  		 vsi->info.resp_reserved[4], vsi->info.resp_reserved[5],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  463  		 vsi->info.resp_reserved[6], vsi->info.resp_reserved[7],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  464  		 vsi->info.resp_reserved[8], vsi->info.resp_reserved[9],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  465  		 vsi->info.resp_reserved[10], vsi->info.resp_reserved[11]);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  466  	dev_info(&pf->pdev->dev, "    idx = %d\n", vsi->idx);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  467  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  468  		 "    tc_config: numtc = %d, enabled_tc = 0x%x\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  469  		 vsi->tc_config.numtc, vsi->tc_config.enabled_tc);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  470  	for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++) {
02e9c290814cc1 Jesse Brandeburg   2013-09-11  471  		dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  472  			 "    tc_config: tc = %d, qoffset = %d, qcount = %d, netdev_tc = %d\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  473  			 i, vsi->tc_config.tc_info[i].qoffset,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  474  			 vsi->tc_config.tc_info[i].qcount,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  475  			 vsi->tc_config.tc_info[i].netdev_tc);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  476  	}
02e9c290814cc1 Jesse Brandeburg   2013-09-11  477  	dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  478  		 "    bw: bw_limit = %d, bw_max_quanta = %d\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  479  		 vsi->bw_limit, vsi->bw_max_quanta);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  480  	for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++) {
02e9c290814cc1 Jesse Brandeburg   2013-09-11  481  		dev_info(&pf->pdev->dev,
02e9c290814cc1 Jesse Brandeburg   2013-09-11  482  			 "    bw[%d]: ets_share_credits = %d, ets_limit_credits = %d, max_quanta = %d\n",
02e9c290814cc1 Jesse Brandeburg   2013-09-11  483  			 i, vsi->bw_ets_share_credits[i],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  484  			 vsi->bw_ets_limit_credits[i],
02e9c290814cc1 Jesse Brandeburg   2013-09-11  485  			 vsi->bw_ets_max_quanta[i]);
02e9c290814cc1 Jesse Brandeburg   2013-09-11  486  	}
02e9c290814cc1 Jesse Brandeburg   2013-09-11  487  }
02e9c290814cc1 Jesse Brandeburg   2013-09-11  488  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC20A4A92EA
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 05:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244577AbiBDED7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 23:03:59 -0500
Received: from mga06.intel.com ([134.134.136.31]:57157 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239888AbiBDED6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 23:03:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643947438; x=1675483438;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=enODRzoB0jh6G0zwvFew0nggpLDbEQ0yZNG7y7oQu20=;
  b=N71xoZYWAM+Qa+4lb9JR+LMhRyzckDZFKlM2+Sc9Gh3ilh72yhYmtAoL
   NlQ69Zg8Zo1ZJhxSBGnJHnB9CwhuDoajWHf5MPOHBTXsdFtlThNgor34H
   EQiFsGHtewLc3W+NOyMDSCTzSl9U9DjtpR5SEm4XMCV5vgDzX7iusPWly
   X9KnURXuZ9v1z3lv6li0uiThCn0R6E+2XMUEbwb5eR8w21Fz2EVk9bo5t
   Kd5M3J5GlatnZt2fo1+97Wj8iZWVbH0BrWsv1Sr5klv8kVFIyugOyyWWJ
   NVDAGxXL7SRLYcKwkA+XUQf/P4WOwaUfEf8lBxSEgL7p0iX9RL4y6moUe
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10247"; a="309050975"
X-IronPort-AV: E=Sophos;i="5.88,341,1635231600"; 
   d="scan'208";a="309050975"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2022 20:03:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,341,1635231600"; 
   d="scan'208";a="631583575"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 03 Feb 2022 20:03:55 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nFppC-000X6z-SY; Fri, 04 Feb 2022 04:03:54 +0000
Date:   Fri, 4 Feb 2022 12:03:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kbuild-all@lists.01.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH net-next 15/15] mlx5: support BIG TCP packets
Message-ID: <202202041153.aALvQUP0-lkp@intel.com>
References: <20220203015140.3022854-16-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220203015140.3022854-16-eric.dumazet@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Eric-Dumazet/tcp-BIG-TCP-implementation/20220203-095336
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 52dae93f3bad842c6d585700460a0dea4d70e096
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20220204/202202041153.aALvQUP0-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/7561f5d66d00583e6d88fa6b2fffd868dcc82b2e
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Eric-Dumazet/tcp-BIG-TCP-implementation/20220203-095336
        git checkout 7561f5d66d00583e6d88fa6b2fffd868dcc82b2e
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arc SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/container_of.h:5,
                    from include/linux/kernel.h:21,
                    from include/linux/skbuff.h:13,
                    from include/linux/tcp.h:17,
                    from drivers/net/ethernet/mellanox/mlx5/core/en_tx.c:33:
   include/linux/build_bug.h:78:41: error: static assertion failed: "BITS_PER_LONG >= NR_MSG_FRAG_IDS"
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                         ^~~~~~~~~~~~~~
   include/linux/build_bug.h:77:34: note: in expansion of macro '__static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/skmsg.h:41:1: note: in expansion of macro 'static_assert'
      41 | static_assert(BITS_PER_LONG >= NR_MSG_FRAG_IDS);
         | ^~~~~~~~~~~~~
   drivers/net/ethernet/mellanox/mlx5/core/en_tx.c: In function 'mlx5i_sq_xmit':
>> drivers/net/ethernet/mellanox/mlx5/core/en_tx.c:1055:86: error: 'h6' undeclared (first use in this function)
    1055 |                         memcpy(eseg->inline_hdr.start, skb->data, ETH_HLEN + sizeof(*h6));
         |                                                                                      ^~
   drivers/net/ethernet/mellanox/mlx5/core/en_tx.c:1055:86: note: each undeclared identifier is reported only once for each function it appears in


vim +/h6 +1055 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c

  1011	
  1012	void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
  1013			   struct mlx5_av *av, u32 dqpn, u32 dqkey, bool xmit_more)
  1014	{
  1015		struct mlx5e_tx_wqe_attr wqe_attr;
  1016		struct mlx5e_tx_attr attr;
  1017		struct mlx5i_tx_wqe *wqe;
  1018	
  1019		struct mlx5_wqe_datagram_seg *datagram;
  1020		struct mlx5_wqe_ctrl_seg *cseg;
  1021		struct mlx5_wqe_eth_seg  *eseg;
  1022		struct mlx5_wqe_data_seg *dseg;
  1023		struct mlx5e_tx_wqe_info *wi;
  1024	
  1025		struct mlx5e_sq_stats *stats = sq->stats;
  1026		int num_dma;
  1027		u16 pi;
  1028	
  1029		mlx5e_sq_xmit_prepare(sq, skb, NULL, &attr);
  1030		mlx5i_sq_calc_wqe_attr(skb, &attr, &wqe_attr);
  1031	
  1032		pi = mlx5e_txqsq_get_next_pi(sq, wqe_attr.num_wqebbs);
  1033		wqe = MLX5I_SQ_FETCH_WQE(sq, pi);
  1034	
  1035		stats->xmit_more += xmit_more;
  1036	
  1037		/* fill wqe */
  1038		wi       = &sq->db.wqe_info[pi];
  1039		cseg     = &wqe->ctrl;
  1040		datagram = &wqe->datagram;
  1041		eseg     = &wqe->eth;
  1042		dseg     =  wqe->data;
  1043	
  1044		mlx5i_txwqe_build_datagram(av, dqpn, dqkey, datagram);
  1045	
  1046		mlx5e_txwqe_build_eseg_csum(sq, skb, NULL, eseg);
  1047	
  1048		eseg->mss = attr.mss;
  1049	
  1050		if (attr.ihs) {
  1051			if (unlikely(attr.hopbyhop)) {
  1052				/* remove the HBH header.
  1053				 * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
  1054				 */
> 1055				memcpy(eseg->inline_hdr.start, skb->data, ETH_HLEN + sizeof(*h6));

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

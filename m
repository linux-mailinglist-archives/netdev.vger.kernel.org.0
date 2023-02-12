Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18EF7693669
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 08:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjBLH4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 02:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjBLH4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 02:56:48 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CD4107;
        Sat, 11 Feb 2023 23:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676188606; x=1707724606;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1z59c0A+4cjBAtzlll8QbX3Ys90B50L6QvIxHeJZpA8=;
  b=AdjlkyIu8t79BG+wRN3O1T6AQ5taPSJ8ialQ3WU8jttr+ltCakgwJasG
   16AXHZwjamfvt+5959Q77gVSugeaoy0JBngyqyPcMQhIG1kKVW9CcsD1k
   N0Le+k9h1ncvS1oNEsXCPaVYg4Lc9pO/g7IqKwRbzgFQf084VkH/oWEG9
   0cGJph0lSyELSuZicD/21VL5XDn5TshPfusgRCSC3diIU0WqNRl3lUgf+
   lgQLx8YHyz6dFcJlYIfUiIIQDd91ayN5vx7cpGN0wcK0SqE1PJMbKM4yh
   P52e65cBwFBE0vFRH1BSKAfZLGeeLTHv7UoJCJN+NXu2HXdG+iMBHTSCX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10618"; a="332003998"
X-IronPort-AV: E=Sophos;i="5.97,291,1669104000"; 
   d="scan'208";a="332003998"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2023 23:56:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10618"; a="842443833"
X-IronPort-AV: E=Sophos;i="5.97,291,1669104000"; 
   d="scan'208";a="842443833"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 11 Feb 2023 23:56:40 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pR7Dz-00078b-2b;
        Sun, 12 Feb 2023 07:56:39 +0000
Date:   Sun, 12 Feb 2023 15:56:26 +0800
From:   kernel test robot <lkp@intel.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH 22/33] virtio_net: xsk: introduce xsk disable
Message-ID: <202302121555.BtDmbIKI-lkp@intel.com>
References: <20230202110058.130695-23-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202110058.130695-23-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xuan,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on next-20230210]
[cannot apply to net/master mst-vhost/linux-next linus/master v6.2-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Xuan-Zhuo/virtio_ring-virtqueue_add-support-premapped/20230202-190707
patch link:    https://lore.kernel.org/r/20230202110058.130695-23-xuanzhuo%40linux.alibaba.com
patch subject: [PATCH 22/33] virtio_net: xsk: introduce xsk disable
config: nios2-randconfig-s033-20230202 (https://download.01.org/0day-ci/archive/20230212/202302121555.BtDmbIKI-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/3c385ac45368b585d2ca1a45263b4a0536cef0dd
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Xuan-Zhuo/virtio_ring-virtqueue_add-support-premapped/20230202-190707
        git checkout 3c385ac45368b585d2ca1a45263b4a0536cef0dd
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=nios2 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=nios2 SHELL=/bin/bash drivers/net/virtio/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302121555.BtDmbIKI-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/net/virtio/xsk.c:133:35: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct xsk_buff_pool *pool @@     got struct xsk_buff_pool [noderef] __rcu *pool @@
   drivers/net/virtio/xsk.c:133:35: sparse:     expected struct xsk_buff_pool *pool
   drivers/net/virtio/xsk.c:133:35: sparse:     got struct xsk_buff_pool [noderef] __rcu *pool

vim +133 drivers/net/virtio/xsk.c

   116	
   117	static int virtnet_xsk_pool_disable(struct net_device *dev, u16 qid)
   118	{
   119		struct virtnet_info *vi = netdev_priv(dev);
   120		struct receive_queue *rq;
   121		struct send_queue *sq;
   122		int err1, err2;
   123	
   124		if (qid >= vi->curr_queue_pairs)
   125			return -EINVAL;
   126	
   127		sq = &vi->sq[qid];
   128		rq = &vi->rq[qid];
   129	
   130		virtio_dma_unmap(&vi->vdev->dev, sq->xsk.hdr_dma_address, vi->hdr_len,
   131				 DMA_TO_DEVICE);
   132	
 > 133		xsk_pool_dma_unmap(sq->xsk.pool, 0);

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

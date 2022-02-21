Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F086E4BDFD6
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349412AbiBUJ1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 04:27:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350003AbiBUJ1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 04:27:01 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DFA20F5B;
        Mon, 21 Feb 2022 01:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645434671; x=1676970671;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UHJyMtuKTt6keT+yxnngiSoVONkyZhQhlKsTRvMsUrU=;
  b=n7dxZU+d09qhlft/6iSKcBe+de+pr37sj+Mpxyh/dDtkO2Lnvpxqp0dr
   oyeB6x6cKqoJA7Nw0Cy4ZVJ0BccDQIGiAKgJn9MibgLeCjODceZEaqXfU
   2kFtWBqqaBET5pUAptiTh3D9Z23jAkWC2M4jZCiPRga/O95unXAdwipIY
   rPDSgnOtHEd1voNqaViVrK84Osu/aKysde13Z6pHQg3s9SrG9YTDjhkNN
   1mAl+ePYmS09bgSswVytpuF/cJWOLgHnK9UeOb+Cm8cVknV6HUKlLfWKG
   XswovNBBtctk+SU10ic2BQqCdUyxKD3QCcfQDM5Wru0dSUlgklFv7IFUq
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="238884535"
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="238884535"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 01:11:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="778639289"
Received: from lkp-server01.sh.intel.com (HELO da3212ac2f54) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 21 Feb 2022 01:11:10 -0800
Received: from kbuild by da3212ac2f54 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nM4ir-0001SA-Es; Mon, 21 Feb 2022 09:11:09 +0000
Date:   Mon, 21 Feb 2022 17:10:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Marek =?iso-8859-1?Q?Marczykowski-G=F3recki?= 
        <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] Revert "xen-netback: remove 'hotplug-status' once it
 has served its purpose"
Message-ID: <202202211740.AbFni9u8-lkp@intel.com>
References: <20220221034214.2237097-1-marmarek@invisiblethingslab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221034214.2237097-1-marmarek@invisiblethingslab.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi "Marek,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linux/master]
[also build test ERROR on linus/master v5.17-rc5 next-20220217]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Marek-Marczykowski-G-recki/Revert-xen-netback-remove-hotplug-status-once-it-has-served-its-purpose/20220221-114409
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 2c271fe77d52a0555161926c232cd5bc07178b39
config: x86_64-randconfig-a011-20220221 (https://download.01.org/0day-ci/archive/20220221/202202211740.AbFni9u8-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d271fc04d5b97b12e6b797c6067d3c96a8d7470e)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/0605cde993ca8f5f7ab43ae68117d73623edd227
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Marek-Marczykowski-G-recki/Revert-xen-netback-remove-hotplug-status-once-it-has-served-its-purpose/20220221-114409
        git checkout 0605cde993ca8f5f7ab43ae68117d73623edd227
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/net/xen-netback/xenbus.c:259:22: error: use of undeclared identifier 'dev'
                   xenbus_rm(XBT_NIL, dev->nodename, "hotplug-status");
                                      ^
   1 error generated.


vim +/dev +259 drivers/net/xen-netback/xenbus.c

   249	
   250	static void backend_disconnect(struct backend_info *be)
   251	{
   252		struct xenvif *vif = be->vif;
   253	
   254		if (vif) {
   255			unsigned int num_queues = vif->num_queues;
   256			unsigned int queue_index;
   257	
   258			xen_unregister_watchers(vif);
 > 259			xenbus_rm(XBT_NIL, dev->nodename, "hotplug-status");
   260	#ifdef CONFIG_DEBUG_FS
   261			xenvif_debugfs_delif(vif);
   262	#endif /* CONFIG_DEBUG_FS */
   263			xenvif_disconnect_data(vif);
   264	
   265			/* At this point some of the handlers may still be active
   266			 * so we need to have additional synchronization here.
   267			 */
   268			vif->num_queues = 0;
   269			synchronize_net();
   270	
   271			for (queue_index = 0; queue_index < num_queues; ++queue_index)
   272				xenvif_deinit_queue(&vif->queues[queue_index]);
   273	
   274			vfree(vif->queues);
   275			vif->queues = NULL;
   276	
   277			xenvif_disconnect_ctrl(vif);
   278		}
   279	}
   280	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

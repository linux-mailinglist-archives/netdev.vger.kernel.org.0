Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4046AA785
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 03:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjCDCPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 21:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCDCPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 21:15:35 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E01312F09
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 18:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677896134; x=1709432134;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Jdb/WolmlDHQZMvxcui4agr9sC64oqj953fE2F76G7w=;
  b=c6lj8H0CnNE02gLxV9TNOao6XAA+ojsQn/iYiFIBOBw9Vo3eYs6APMwL
   dwTSsMLBzpNX4v632cekuSKBMq5f4wDNH/2vncIgl6nC6j1vLXhqmtuez
   EXjnX6UE1AoZ4Sk3BM50rDVlcF7X5jjv+2Xbslc/M4rP4S0+8D1hb1WaC
   kAcx2Tn0BGjeuImWITKcdYl+KFdFgBr1ZuQU4MxIG5jeTIY+vv+lcHYjT
   mlNNB7muikH2Rey8u6Ubuk+kidwQeMbI1dS276ijW6HNwKbJhTYU8gEc4
   TuA/ZmS5b1JZ1xR4cWVXgGHEyCF/M9IjBQLEwx8hpOPpJwdoaYuzTUwgj
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="421481953"
X-IronPort-AV: E=Sophos;i="5.98,232,1673942400"; 
   d="scan'208";a="421481953"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 18:15:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="1004791693"
X-IronPort-AV: E=Sophos;i="5.98,232,1673942400"; 
   d="scan'208";a="1004791693"
Received: from lkp-server01.sh.intel.com (HELO 776573491cc5) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 03 Mar 2023 18:15:31 -0800
Received: from kbuild by 776573491cc5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pYHQp-0001nU-0W;
        Sat, 04 Mar 2023 02:15:31 +0000
Date:   Sat, 4 Mar 2023 10:15:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
        netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com,
        Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Subject: Re: [PATCH v1] netdevice: use ifmap isteand of plain fields
Message-ID: <202303041014.jTNcXi96-lkp@intel.com>
References: <20230303150818.132386-1-vincenzopalazzodev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303150818.132386-1-vincenzopalazzodev@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincenzo,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Vincenzo-Palazzo/netdevice-use-ifmap-isteand-of-plain-fields/20230303-231003
patch link:    https://lore.kernel.org/r/20230303150818.132386-1-vincenzopalazzodev%40gmail.com
patch subject: [PATCH v1] netdevice: use ifmap isteand of plain fields
config: riscv-randconfig-r006-20230303 (https://download.01.org/0day-ci/archive/20230304/202303041014.jTNcXi96-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project 67409911353323ca5edf2049ef0df54132fa1ca7)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/4efa870f9b2112fdebe7d1fffe30f5626b8d5229
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vincenzo-Palazzo/netdevice-use-ifmap-isteand-of-plain-fields/20230303-231003
        git checkout 4efa870f9b2112fdebe7d1fffe30f5626b8d5229
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash drivers/net/ethernet/ drivers/net/fddi/ drivers/net/plip/ drivers/net/slip/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303041014.jTNcXi96-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:13123:7: error: no member named 'mem_start' in 'struct net_device'
           dev->mem_start = pci_resource_start(pdev, 0);
           ~~~  ^
   drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:13124:7: error: no member named 'base_addr' in 'struct net_device'
           dev->base_addr = dev->mem_start;
           ~~~  ^
   drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:13124:24: error: no member named 'mem_start' in 'struct net_device'
           dev->base_addr = dev->mem_start;
                            ~~~  ^
   drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:13125:7: error: no member named 'mem_end' in 'struct net_device'
           dev->mem_end = pci_resource_end(pdev, 0);
           ~~~  ^
   drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:13117:49: warning: shift count >= width of type [-Wshift-count-overflow]
           rc = dma_set_mask_and_coherent(&bp->pdev->dev, DMA_BIT_MASK(64));
                                                          ^~~~~~~~~~~~~~~~
   include/linux/dma-mapping.h:76:54: note: expanded from macro 'DMA_BIT_MASK'
   #define DMA_BIT_MASK(n) (((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
                                                        ^ ~~~
   drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:14011:14: error: no member named 'base_addr' in 'struct net_device'
                  dev->base_addr, bp->pdev->irq, dev->dev_addr);
                  ~~~  ^
   drivers/net/ethernet/broadcom/bnx2x/bnx2x.h:141:35: note: expanded from macro 'BNX2X_DEV_INFO'
                   dev_info(&bp->pdev->dev, fmt, ##__VA_ARGS__);    \
                                                   ^~~~~~~~~~~
   include/linux/dev_printk.h:150:67: note: expanded from macro 'dev_info'
           dev_printk_index_wrap(_dev_info, KERN_INFO, dev, dev_fmt(fmt), ##__VA_ARGS__)
                                                                            ^~~~~~~~~~~
   include/linux/dev_printk.h:110:23: note: expanded from macro 'dev_printk_index_wrap'
                   _p_func(dev, fmt, ##__VA_ARGS__);                       \
                                       ^~~~~~~~~~~
>> drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:15206:26: warning: shift count >= width of type [-Wshift-count-overflow]
           bp->cyclecounter.mask = CYCLECOUNTER_MASK(64);
                                   ^~~~~~~~~~~~~~~~~~~~~
   include/linux/timecounter.h:14:59: note: expanded from macro 'CYCLECOUNTER_MASK'
   #define CYCLECOUNTER_MASK(bits) (u64)((bits) < 64 ? ((1ULL<<(bits))-1) : -1)
                                                             ^ ~~~~~~
   2 warnings and 5 errors generated.


vim +15206 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c

eeed018cbfa30c Michal Kalderon         2014-08-17  15201  
eeed018cbfa30c Michal Kalderon         2014-08-17  15202  static void bnx2x_init_cyclecounter(struct bnx2x *bp)
eeed018cbfa30c Michal Kalderon         2014-08-17  15203  {
eeed018cbfa30c Michal Kalderon         2014-08-17  15204  	memset(&bp->cyclecounter, 0, sizeof(bp->cyclecounter));
eeed018cbfa30c Michal Kalderon         2014-08-17  15205  	bp->cyclecounter.read = bnx2x_cyclecounter_read;
f28ba401dbd9e9 Richard Cochran         2015-01-02 @15206  	bp->cyclecounter.mask = CYCLECOUNTER_MASK(64);
a6e2846cacf97d Sudarsana Reddy Kalluru 2016-10-21  15207  	bp->cyclecounter.shift = 0;
eeed018cbfa30c Michal Kalderon         2014-08-17  15208  	bp->cyclecounter.mult = 1;
eeed018cbfa30c Michal Kalderon         2014-08-17  15209  }
eeed018cbfa30c Michal Kalderon         2014-08-17  15210  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

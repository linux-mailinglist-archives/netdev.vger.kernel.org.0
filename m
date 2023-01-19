Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0FD46740AF
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 19:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjASSPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 13:15:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjASSPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 13:15:38 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B701CAEF
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 10:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674152134; x=1705688134;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AuObEufoA3Wm8tjf1nQYv9YRCZkJED8LzXERE8u9S8E=;
  b=MQh34vZ8QzzXl/mLlUHwyYcwGLchbHAsoH3j1S0m31dzOV97Uw9aO5Yl
   r8os4r6mNFmTroNcnmoQqziUxwLgn3W10wiH0ZUvF8yY/9wFg9sELJ8+B
   YidspZBGjGG/sXoqtXYd/URq/cPrMqsJVl+VAcGGv+SmHNOIKrRcnJrtL
   sk1TKUsxoKOmOj5911fL0psVhIXVysw0aor2emXEaiW/pfTHu7AaMZICk
   4ANjtSWwyRC/G+ldhPxdNygG9S1l4l21MzFflEZbGiepaAaDJufXnEnpT
   P62V257HrnBneYVx13sTbBWV6od2fSIh98cCZpuwqVpVkagjHFr/GL8Kz
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="324058310"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="324058310"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 10:15:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="834082782"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="834082782"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 19 Jan 2023 10:15:10 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pIZRI-0001iQ-1T;
        Thu, 19 Jan 2023 18:15:04 +0000
Date:   Fri, 20 Jan 2023 02:14:35 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
        mengyuanlou@net-swift.com
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH net-next 01/10] net: libwx: Add irq flow functions
Message-ID: <202301200204.6nSc8Rre-lkp@intel.com>
References: <20230118065504.3075474-2-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118065504.3075474-2-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiawen,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Jiawen-Wu/net-libwx-Add-irq-flow-functions/20230118-154258
patch link:    https://lore.kernel.org/r/20230118065504.3075474-2-jiawenwu%40trustnetic.com
patch subject: [PATCH net-next 01/10] net: libwx: Add irq flow functions
config: arm-randconfig-c002-20230118 (https://download.01.org/0day-ci/archive/20230120/202301200204.6nSc8Rre-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 4196ca3278f78c6e19246e54ab0ecb364e37d66a)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        # https://github.com/intel-lab-lkp/linux/commit/f807094d578ff552800fe8f9fd9f29ad766384b6
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jiawen-Wu/net-libwx-Add-irq-flow-functions/20230118-154258
        git checkout f807094d578ff552800fe8f9fd9f29ad766384b6
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash drivers/net/ethernet/wangxun/libwx/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/wangxun/libwx/wx_hw.c:890:41: warning: shift count >= width of type [-Wshift-count-overflow]
           wr32(wx, WX_PX_ISB_ADDR_H, wx->isb_dma >> 32);
                                                  ^  ~~
   drivers/net/ethernet/wangxun/libwx/wx_type.h:478:37: note: expanded from macro 'wr32'
   #define wr32(a, reg, value)     writel((value), ((a)->hw_addr + (reg)))
                                           ^~~~~
   arch/arm/include/asm/io.h:290:51: note: expanded from macro 'writel'
   #define writel(v,c)             ({ __iowmb(); writel_relaxed(v,c); })
                                                                ^
   arch/arm/include/asm/io.h:282:68: note: expanded from macro 'writel_relaxed'
   #define writel_relaxed(v,c)     __raw_writel((__force u32) cpu_to_le32(v),c)
                                                                          ^
   include/uapi/linux/byteorder/little_endian.h:34:51: note: expanded from macro '__cpu_to_le32'
   #define __cpu_to_le32(x) ((__force __le32)(__u32)(x))
                                                     ^
   1 warning generated.


vim +890 drivers/net/ethernet/wangxun/libwx/wx_hw.c

   885	
   886	static void wx_configure_isb(struct wx *wx)
   887	{
   888		/* set ISB Address */
   889		wr32(wx, WX_PX_ISB_ADDR_L, wx->isb_dma & DMA_BIT_MASK(32));
 > 890		wr32(wx, WX_PX_ISB_ADDR_H, wx->isb_dma >> 32);
   891	}
   892	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

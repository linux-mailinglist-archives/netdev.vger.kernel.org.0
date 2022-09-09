Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632985B3DEB
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 19:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbiIIR0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 13:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiIIR0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 13:26:52 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7118211B00E;
        Fri,  9 Sep 2022 10:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662744411; x=1694280411;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2XgdYbkWHU5wpwgtFuAdOr2mJB8qz3+43GTBZWw+MgY=;
  b=D64wy3a2WPMCW3Kuxj26EWmPLxhrfH03wo3GFb9YqqPXecMEb8QO1EBf
   UAaBNduKFdJilCa/5oNOJTjcMidnX4g8Q8iGHDG6QtmPpYxMZCkqPxMD+
   8rykCNQUgPszNo8yS7IWVlIj+JqTMfzXk/8vvqKhbYTaz9r47fjSqAimY
   qteioV57oqc++lMa5az8+wNLca7uO4u17FMLcEnrqIGm2b3mVDwUPHZds
   HvnkGUjkilm4uTRKqeNiOhf+AaJSEG4ZFguUE0d1L86MtJUujb1669Z58
   1jur8dFLo9Bz1cpnBqXKhuhcvyhs0HXfQ+izY6n+w5MP+AE64FJlaQ0/R
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10465"; a="298330945"
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="298330945"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 10:26:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="566441041"
Received: from lkp-server02.sh.intel.com (HELO b2938d2e5c5a) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 09 Sep 2022 10:26:47 -0700
Received: from kbuild by b2938d2e5c5a with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oWhmB-0001WX-07;
        Fri, 09 Sep 2022 17:26:47 +0000
Date:   Sat, 10 Sep 2022 01:26:01 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, geert+renesas@glider.be
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: Re: [PATCH 3/5] net: ethernet: renesas: Add Ethernet Switch driver
Message-ID: <202209100156.WIC248Uh-lkp@intel.com>
References: <20220909132614.1967276-4-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909132614.1967276-4-yoshihiro.shimoda.uh@renesas.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yoshihiro,

I love your patch! Perhaps something to improve:

[auto build test WARNING on next-20220909]
[also build test WARNING on v6.0-rc4]
[cannot apply to geert-renesas-devel/next net-next/master net/master linus/master v6.0-rc4 v6.0-rc3 v6.0-rc2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yoshihiro-Shimoda/treewide-Add-R-Car-S4-8-Ethernet-Switch-support/20220909-212759
base:    9a82ccda91ed2b40619cb3c10d446ae1f97bab6e
config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20220910/202209100156.WIC248Uh-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/9c5c4dd0ca6beb269dd0a6ef12c386198e193c68
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yoshihiro-Shimoda/treewide-Add-R-Car-S4-8-Ethernet-Switch-support/20220909-212759
        git checkout 9c5c4dd0ca6beb269dd0a6ef12c386198e193c68
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh SHELL=/bin/bash M=drivers/net/ethernet/renesas

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/renesas/rswitch_serdes.c:16:6: warning: no previous prototype for 'rswitch_serdes_write32' [-Wmissing-prototypes]
      16 | void rswitch_serdes_write32(void __iomem *addr, u32 offs,  u32 bank, u32 data)
         |      ^~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/renesas/rswitch_serdes.c:22:5: warning: no previous prototype for 'rswitch_serdes_read32' [-Wmissing-prototypes]
      22 | u32 rswitch_serdes_read32(void __iomem *addr, u32 offs,  u32 bank)
         |     ^~~~~~~~~~~~~~~~~~~~~


vim +/rswitch_serdes_write32 +16 drivers/net/ethernet/renesas/rswitch_serdes.c

    15	
  > 16	void rswitch_serdes_write32(void __iomem *addr, u32 offs,  u32 bank, u32 data)
    17	{
    18		iowrite32(bank, addr + RSWITCH_SERDES_BANK_SELECT);
    19		iowrite32(data, addr + offs);
    20	}
    21	
  > 22	u32 rswitch_serdes_read32(void __iomem *addr, u32 offs,  u32 bank)
    23	{
    24		iowrite32(bank, addr + RSWITCH_SERDES_BANK_SELECT);
    25	
    26		return ioread32(addr + offs);
    27	}
    28	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

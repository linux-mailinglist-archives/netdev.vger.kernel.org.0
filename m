Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3BB46CAC44
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjC0Rw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjC0RwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:52:25 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F9810E;
        Mon, 27 Mar 2023 10:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679939544; x=1711475544;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zp7GDJJT8bOwVslnKFXWafUO/OPv2Ix3nPBVGY3BpZM=;
  b=MLV2HDrC3Yz1LIlBOkhrlkQ4Gx6aPm9VEWSjCdQkLaFc7vZmxwyAFzpa
   /awpnoJbTVOjoUcjrj2DGywn4+a8SKu7EYH2IUNE35/os30RjorbBbvO4
   W/VibomOvfkKz3XElo+y6/9YPvb6UoIPHhCom1UCqlF9h0OmBdfoQAdy6
   AX7+7ebk7CoM1ol7D1x1nC80IxV+nUPeLvvUl01gjwqyqPTtb/wss4lb+
   OOR3AM89YgjujWfsjbt2cYttSnIWNdNtwy3Gzruj1yw5pX9yNanR1xaQH
   HrN+sVI6DLEtL4T7o1Eg9lsiYDhMJ2D9/PAYO2KmglHIVynnKkRUeuN2v
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="337845293"
X-IronPort-AV: E=Sophos;i="5.98,295,1673942400"; 
   d="scan'208";a="337845293"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 10:52:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="827139264"
X-IronPort-AV: E=Sophos;i="5.98,295,1673942400"; 
   d="scan'208";a="827139264"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 27 Mar 2023 10:52:20 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pgr12-000Hsw-0R;
        Mon, 27 Mar 2023 17:52:20 +0000
Date:   Tue, 28 Mar 2023 01:51:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     Harini Katakam <harini.katakam@amd.com>,
        nicolas.ferre@microchip.com, davem@davemloft.net,
        richardcochran@gmail.com, claudiu.beznea@microchip.com,
        andrei.pistirica@microchip.com, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com
Cc:     oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, michal.simek@amd.com,
        harinikatakamlinux@gmail.com, harini.katakam@amd.com
Subject: Re: [PATCH net-next v3 1/3] net: macb: Update gem PTP support check
Message-ID: <202303280125.0cmGPLT1-lkp@intel.com>
References: <20230327110607.21964-2-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327110607.21964-2-harini.katakam@amd.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harini,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Harini-Katakam/net-macb-Update-gem-PTP-support-check/20230327-190937
patch link:    https://lore.kernel.org/r/20230327110607.21964-2-harini.katakam%40amd.com
patch subject: [PATCH net-next v3 1/3] net: macb: Update gem PTP support check
config: riscv-rv32_defconfig (https://download.01.org/0day-ci/archive/20230328/202303280125.0cmGPLT1-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/0a2f03b6a91caa746dfd1b56b998534464dae83d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Harini-Katakam/net-macb-Update-gem-PTP-support-check/20230327-190937
        git checkout 0a2f03b6a91caa746dfd1b56b998534464dae83d
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=riscv olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash drivers/net/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303280125.0cmGPLT1-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/net/ethernet/cadence/macb_main.c: In function 'macb_configure_caps':
>> drivers/net/ethernet/cadence/macb_main.c:3897:35: error: 'struct macb' has no member named 'hw_dma_cap'
    3897 |                                 bp->hw_dma_cap |= HW_DMA_CAP_PTP;
         |                                   ^~
>> drivers/net/ethernet/cadence/macb_main.c:3897:51: error: 'HW_DMA_CAP_PTP' undeclared (first use in this function)
    3897 |                                 bp->hw_dma_cap |= HW_DMA_CAP_PTP;
         |                                                   ^~~~~~~~~~~~~~
   drivers/net/ethernet/cadence/macb_main.c:3897:51: note: each undeclared identifier is reported only once for each function it appears in
>> drivers/net/ethernet/cadence/macb_main.c:3898:49: error: 'gem_ptp_info' undeclared (first use in this function); did you mean 'gem_ptp_init'?
    3898 |                                 bp->ptp_info = &gem_ptp_info;
         |                                                 ^~~~~~~~~~~~
         |                                                 gem_ptp_init


vim +3897 drivers/net/ethernet/cadence/macb_main.c

5f1fa992382cf8 drivers/net/macb.c                       Alexander Beregalov 2009-04-11  3866  
64ec42fe272322 drivers/net/ethernet/cadence/macb.c      Moritz Fischer      2016-03-29  3867  /* Configure peripheral capabilities according to device tree
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3868   * and integration options used
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3869   */
64ec42fe272322 drivers/net/ethernet/cadence/macb.c      Moritz Fischer      2016-03-29  3870  static void macb_configure_caps(struct macb *bp,
64ec42fe272322 drivers/net/ethernet/cadence/macb.c      Moritz Fischer      2016-03-29  3871  				const struct macb_config *dt_conf)
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3872  {
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3873  	u32 dcfg;
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3874  
f6970505defd0e drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2015-03-31  3875  	if (dt_conf)
f6970505defd0e drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2015-03-31  3876  		bp->caps = dt_conf->caps;
f6970505defd0e drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2015-03-31  3877  
f2ce8a9e48385f drivers/net/ethernet/cadence/macb.c      Andy Shevchenko     2015-07-24  3878  	if (hw_is_gem(bp->regs, bp->native_io)) {
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3879  		bp->caps |= MACB_CAPS_MACB_IS_GEM;
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3880  
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3881  		dcfg = gem_readl(bp, DCFG1);
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3882  		if (GEM_BFEXT(IRQCOR, dcfg) == 0)
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3883  			bp->caps |= MACB_CAPS_ISR_CLEAR_ON_WRITE;
e4e143e26ce8f5 drivers/net/ethernet/cadence/macb_main.c Parshuram Thombare  2020-10-29  3884  		if (GEM_BFEXT(NO_PCS, dcfg) == 0)
e4e143e26ce8f5 drivers/net/ethernet/cadence/macb_main.c Parshuram Thombare  2020-10-29  3885  			bp->caps |= MACB_CAPS_PCS;
e4e143e26ce8f5 drivers/net/ethernet/cadence/macb_main.c Parshuram Thombare  2020-10-29  3886  		dcfg = gem_readl(bp, DCFG12);
e4e143e26ce8f5 drivers/net/ethernet/cadence/macb_main.c Parshuram Thombare  2020-10-29  3887  		if (GEM_BFEXT(HIGH_SPEED, dcfg) == 1)
e4e143e26ce8f5 drivers/net/ethernet/cadence/macb_main.c Parshuram Thombare  2020-10-29  3888  			bp->caps |= MACB_CAPS_HIGH_SPEED;
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3889  		dcfg = gem_readl(bp, DCFG2);
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3890  		if ((dcfg & (GEM_BIT(RX_PKT_BUFF) | GEM_BIT(TX_PKT_BUFF))) == 0)
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3891  			bp->caps |= MACB_CAPS_FIFO_MODE;
ab91f0a9b5f4b9 drivers/net/ethernet/cadence/macb_main.c Rafal Ozieblo       2017-06-29  3892  		if (gem_has_ptp(bp)) {
7b4296148066f1 drivers/net/ethernet/cadence/macb.c      Rafal Ozieblo       2017-06-29  3893  			if (!GEM_BFEXT(TSU, gem_readl(bp, DCFG5)))
7897b071ac3b45 drivers/net/ethernet/cadence/macb_main.c Antoine Tenart      2019-11-13  3894  				dev_err(&bp->pdev->dev,
7897b071ac3b45 drivers/net/ethernet/cadence/macb_main.c Antoine Tenart      2019-11-13  3895  					"GEM doesn't support hardware ptp.\n");
ab91f0a9b5f4b9 drivers/net/ethernet/cadence/macb_main.c Rafal Ozieblo       2017-06-29  3896  			else {
7b4296148066f1 drivers/net/ethernet/cadence/macb.c      Rafal Ozieblo       2017-06-29 @3897  				bp->hw_dma_cap |= HW_DMA_CAP_PTP;
ab91f0a9b5f4b9 drivers/net/ethernet/cadence/macb_main.c Rafal Ozieblo       2017-06-29 @3898  				bp->ptp_info = &gem_ptp_info;
7b4296148066f1 drivers/net/ethernet/cadence/macb.c      Rafal Ozieblo       2017-06-29  3899  			}
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3900  		}
ab91f0a9b5f4b9 drivers/net/ethernet/cadence/macb_main.c Rafal Ozieblo       2017-06-29  3901  	}
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3902  
a35919e174350d drivers/net/ethernet/cadence/macb.c      Andy Shevchenko     2015-07-24  3903  	dev_dbg(&bp->pdev->dev, "Cadence caps 0x%08x\n", bp->caps);
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3904  }
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3905  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

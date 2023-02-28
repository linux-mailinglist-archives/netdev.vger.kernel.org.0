Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73AC6A520F
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 04:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjB1DvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 22:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbjB1DvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 22:51:21 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D342449A;
        Mon, 27 Feb 2023 19:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677556279; x=1709092279;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=08veLCnIeVNEA3aProyx9JAotQXJN9lfAnNzhsSQfFs=;
  b=SX5pwXi+u0cdLVtQGIDwU0X2Q8vrfO7YgoQupIfTKIt7jsapF3sOzX7G
   53q+AUPYNLHNaeRSdh6iWdReN7udD7zKZgTJp4Kiu0rGD4gYxpOGMYZyl
   Lhb1+Wf8Lf1Zyy2rGV8AKqpy2rem+XHNibci3gLPbulPdu3Pw5FGybe4B
   rKDJiNxtL/vF2m9bZfKKD6eTDwnDtK1QO9sdESkqk2BPWz+E/jWhCTvHK
   87RlQIWfYDIkS1Kl0eTOScWPkbpuN49I3Zgw8UaDcKt39xNw3OhMJICA7
   3riJ5aJyS9LwzmW98qfvXZJJYg6Q1zWsZLRstpI+m9EbVOr19Uuq4M1hO
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="317839829"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="317839829"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 19:51:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="673977032"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="673977032"
Received: from lkp-server01.sh.intel.com (HELO 3895f5c55ead) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 27 Feb 2023 19:51:15 -0800
Received: from kbuild by 3895f5c55ead with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pWr1H-00053d-09;
        Tue, 28 Feb 2023 03:51:15 +0000
Date:   Tue, 28 Feb 2023 11:50:19 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, pkshih@realtek.com
Cc:     oe-kbuild-all@lists.linux.dev, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] rtlwifi: rtl8192se: Remove the unused variable
 bcntime_cfg
Message-ID: <202302281153.D9CuZbhm-lkp@intel.com>
References: <20230228021132.88910-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228021132.88910-1-jiapeng.chong@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiapeng,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on wireless-next/main]
[also build test WARNING on wireless/main]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jiapeng-Chong/rtlwifi-rtl8192se-Remove-the-unused-variable-bcntime_cfg/20230228-101333
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
patch link:    https://lore.kernel.org/r/20230228021132.88910-1-jiapeng.chong%40linux.alibaba.com
patch subject: [PATCH] rtlwifi: rtl8192se: Remove the unused variable bcntime_cfg
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20230228/202302281153.D9CuZbhm-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/c8de031d7e616764eacd615d106a5484bacc675d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jiapeng-Chong/rtlwifi-rtl8192se-Remove-the-unused-variable-bcntime_cfg/20230228-101333
        git checkout c8de031d7e616764eacd615d106a5484bacc675d
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/wireless/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302281153.D9CuZbhm-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c: In function 'rtl92se_set_beacon_related_registers':
>> drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:1555:25: warning: unused variable 'bcn_ifs' [-Wunused-variable]
    1555 |         u16 bcn_cw = 6, bcn_ifs = 0xf;
         |                         ^~~~~~~
>> drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:1555:13: warning: unused variable 'bcn_cw' [-Wunused-variable]
    1555 |         u16 bcn_cw = 6, bcn_ifs = 0xf;
         |             ^~~~~~


vim +/bcn_ifs +1555 drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c

24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1550  
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1551  void rtl92se_set_beacon_related_registers(struct ieee80211_hw *hw)
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1552  {
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1553  	struct rtl_priv *rtlpriv = rtl_priv(hw);
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1554  	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03 @1555  	u16 bcn_cw = 6, bcn_ifs = 0xf;
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1556  	u16 atim_window = 2;
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1557  
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1558  	/* ATIM Window (in unit of TU). */
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1559  	rtl_write_word(rtlpriv, ATIMWND, atim_window);
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1560  
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1561  	/* Beacon interval (in unit of TU). */
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1562  	rtl_write_word(rtlpriv, BCN_INTERVAL, mac->beacon_interval);
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1563  
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1564  	/* DrvErlyInt (in unit of TU). (Time to send
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1565  	 * interrupt to notify driver to change
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1566  	 * beacon content) */
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1567  	rtl_write_word(rtlpriv, BCN_DRV_EARLY_INT, 10 << 4);
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1568  
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1569  	/* BcnDMATIM(in unit of us). Indicates the
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1570  	 * time before TBTT to perform beacon queue DMA  */
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1571  	rtl_write_word(rtlpriv, BCN_DMATIME, 256);
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1572  
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1573  	/* Force beacon frame transmission even
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1574  	 * after receiving beacon frame from
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1575  	 * other ad hoc STA */
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1576  	rtl_write_byte(rtlpriv, BCN_ERR_THRESH, 100);
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1577  
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1578  	/*for beacon changed */
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1579  	rtl92s_phy_set_beacon_hwreg(hw, mac->beacon_interval);
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1580  }
24284531497def drivers/net/wireless/rtlwifi/rtl8192se/hw.c Chaoming Li 2011-05-03  1581  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

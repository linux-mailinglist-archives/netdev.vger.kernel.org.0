Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8125B67F982
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 17:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234303AbjA1QXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 11:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234296AbjA1QXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 11:23:00 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EAC16312
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 08:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674922975; x=1706458975;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+bEiU2wtQ3gf1HortIvIXlSNrPxk7lxjwVFECHMel3M=;
  b=FNeiqSJ06fJWFdj4eTpjY7+NjgJr0YUGGP0hn/o6/kJC/ESMn0Gh2eb0
   u1E+k7avNxqwAKGoOzOZHqlNm08vZuserkhW1L+hPDOZf4O78d96nNanc
   1RkWctdoM79UTZFwRW5aZ1iW0XJ2gIMNSjrfgnlNnyrGyEbxDli8SbCiv
   aiwvtwka5ayygWr7GRkZX9dgJgFbRzO2aTmcnP+1cRENUX3jWIJ3IXJa3
   tFJPpwUr1IkguwCGevDy91ZBmKhSQQb1ZV242i0Lcn7gfY96+2sh4PV/C
   YlgOBTAXMJJE2FrYG9qN49EaCxy3TPAp8f7s+IHTB19wvLssATRTaruMC
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="329434547"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="329434547"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2023 08:22:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="613538240"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="613538240"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 28 Jan 2023 08:22:41 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pLnyS-0000tf-1Z;
        Sat, 28 Jan 2023 16:22:40 +0000
Date:   Sun, 29 Jan 2023 00:21:53 +0800
From:   kernel test robot <lkp@intel.com>
To:     alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com
Cc:     oe-kbuild-all@lists.linux.dev, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        habetsm.xilinx@gmail.com, ecree.xilinx@gmail.com,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: Re: [PATCH v3 net-next 2/8] sfc: add devlink info support for ef100
Message-ID: <202301290027.qcZWh4vW-lkp@intel.com>
References: <20230127093651.54035-3-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127093651.54035-3-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/alejandro-lucero-palau-amd-com/sfc-add-devlink-support-for-ef100/20230128-140152
patch link:    https://lore.kernel.org/r/20230127093651.54035-3-alejandro.lucero-palau%40amd.com
patch subject: [PATCH v3 net-next 2/8] sfc: add devlink info support for ef100
config: openrisc-randconfig-r031-20230123 (https://download.01.org/0day-ci/archive/20230129/202301290027.qcZWh4vW-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/3bb8891806410a1773641919d271bd2cd1c7cc0b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review alejandro-lucero-palau-amd-com/sfc-add-devlink-support-for-ef100/20230128-140152
        git checkout 3bb8891806410a1773641919d271bd2cd1c7cc0b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=openrisc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=openrisc SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   or1k-linux-ld: or1k-linux-ld: DWARF error: could not find abbrev number 49
   drivers/net/ethernet/sfc/efx_devlink.o: in function `efx_devlink_info_running_v2.constprop.0':
>> efx_devlink.c:(.text+0xc54): undefined reference to `rtc_time64_to_tm'
   efx_devlink.c:(.text+0xc54): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `rtc_time64_to_tm'
>> or1k-linux-ld: efx_devlink.c:(.text+0xdec): undefined reference to `rtc_time64_to_tm'
   efx_devlink.c:(.text+0xdec): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `rtc_time64_to_tm'
   or1k-linux-ld: drivers/net/ethernet/sfc/efx_devlink.o: in function `efx_devlink_info_nvram_partition.isra.0':
>> efx_devlink.c:(.text+0x1150): undefined reference to `efx_mcdi_nvram_metadata'
   efx_devlink.c:(.text+0x1150): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `efx_mcdi_nvram_metadata'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610B3686EBD
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 20:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbjBATPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 14:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBATPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 14:15:51 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF8265EFC;
        Wed,  1 Feb 2023 11:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675278950; x=1706814950;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qUn91Yoz8Yg2m3couikOrAFCjGFevfgvmBr+dnLp7Bs=;
  b=CURC4Q5c9t4ADAxVrc6cQR6hij6psznMtw/w2vnY8hBD7HnxNEDc3+AP
   shJ8eFyQEjdjtMn199Nz1/UaX9h8ChylFji6KdkrxhDL0DUXOA1D75IQe
   MgZb5WqyZUAAhAHorXiUsCZaCVNNa5wt/qtG3DSURmWqVbi195QqWMqbK
   PsH+1F0+VAFWsDBv9yzf5cpOYzzXgCmpZiw0GbWgZV+DIl1o/f8H8NTVn
   xSymyXx/Fc8NKZt5tEVKRGaBtBsfzYD9GwtctYBnOq+2ju3Di5DDX6mcc
   yhAQQFNgeS/7f/o0tKYSj3/gFqOnX3/ZJelWojWo+Gipq5BASifz/c98F
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="329539240"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="329539240"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 11:15:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="733694309"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="733694309"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 01 Feb 2023 11:15:46 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pNIa9-0005jv-1z;
        Wed, 01 Feb 2023 19:15:45 +0000
Date:   Thu, 2 Feb 2023 03:15:20 +0800
From:   kernel test robot <lkp@intel.com>
To:     alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com
Cc:     oe-kbuild-all@lists.linux.dev, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        habetsm.xilinx@gmail.com, ecree.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: Re: [PATCH v4 net-next 7/8] sfc: add support for devlink
 port_function_hw_addr_get in ef100
Message-ID: <202302020326.IUUr19ny-lkp@intel.com>
References: <20230131145822.36208-8-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131145822.36208-8-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/alejandro-lucero-palau-amd-com/sfc-add-devlink-support-for-ef100/20230131-230245
patch link:    https://lore.kernel.org/r/20230131145822.36208-8-alejandro.lucero-palau%40amd.com
patch subject: [PATCH v4 net-next 7/8] sfc: add support for devlink port_function_hw_addr_get in ef100
config: ia64-randconfig-c031-20230129 (https://download.01.org/0day-ci/archive/20230202/202302020326.IUUr19ny-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/11c7bb1c959cd61c59ee9a12872d4e5afd4352c9
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review alejandro-lucero-palau-amd-com/sfc-add-devlink-support-for-ef100/20230131-230245
        git checkout 11c7bb1c959cd61c59ee9a12872d4e5afd4352c9
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   ia64-linux-ld: drivers/net/ethernet/sfc/ef100_nic.o: in function `ef100_remove':
   ef100_nic.c:(.text+0x2f02): undefined reference to `efx_ef100_fini_reps'
   ia64-linux-ld: ef100_nic.c:(.text+0x2f12): undefined reference to `efx_fini_mae'
   ia64-linux-ld: drivers/net/ethernet/sfc/efx_devlink.o: in function `ef100_set_devlink_port':
   efx_devlink.c:(.text+0x32): undefined reference to `efx_mae_lookup_mport'
   ia64-linux-ld: efx_devlink.c:(.text+0x72): undefined reference to `efx_mae_get_mport'
   ia64-linux-ld: efx_devlink.c:(.text+0xa2): undefined reference to `ef100_mport_on_local_intf'
   ia64-linux-ld: drivers/net/ethernet/sfc/efx_devlink.o: in function `efx_devlink_port_addr_get':
>> efx_devlink.c:(.text+0x212): undefined reference to `ef100_mport_on_local_intf'
>> ia64-linux-ld: efx_devlink.c:(.text+0x2c2): undefined reference to `ef100_mport_is_vf'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F563673DF5
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 16:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjASPvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 10:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjASPvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 10:51:04 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18B48386C
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 07:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674143463; x=1705679463;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0H5YW96PNnkoGhhv0HY5XIr75+SWIeoKVf0ByH/0kdw=;
  b=hTuVOhaU1QUyQNKp6OOZeRZx2rf7MFl3vJum/jl+hNFXDZzhl8/GhAI3
   SbVuYw+jzBNHwNGgOJXE/MwJDF3zPoZ+LCXAAPB6mZve/1V5b4t0yZR+w
   SMu8CzqHK0fnNF76d1doLOmrrhVuV+RgQp0XMc7V8GswxHC5UgyUemkKu
   9dlanUMu6e676mXQ/uLx7cL7nkm9bk7CfTgxfck8X8AhEn5zP+nWaQEOk
   lepTC3hkPBiKn7WKFFjTyGwE3atRxImVuVh1iDAJ+jcEwPBpv2O/Njntu
   JY5wqNUo74PcvU6WktexGWt6bvHk2wbE3UdN2TM6uJDcrGWTkg1XT3cwP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="304996513"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="304996513"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 07:51:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="660243140"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="660243140"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 19 Jan 2023 07:50:58 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pIXBp-0001ai-0n;
        Thu, 19 Jan 2023 15:50:57 +0000
Date:   Thu, 19 Jan 2023 23:50:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com
Cc:     oe-kbuild-all@lists.linux.dev, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        habetsm@gmail.com, ecree.xilinx@gmail.com,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: Re: [PATCH net-next 1/7] sfc: add devlink support for ef100
Message-ID: <202301192303.3zOqMgPP-lkp@intel.com>
References: <20230119113140.20208-2-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119113140.20208-2-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/alejandro-lucero-palau-amd-com/sfc-add-devlink-support-for-ef100/20230119-193440
patch link:    https://lore.kernel.org/r/20230119113140.20208-2-alejandro.lucero-palau%40amd.com
patch subject: [PATCH net-next 1/7] sfc: add devlink support for ef100
config: sparc-allyesconfig (https://download.01.org/0day-ci/archive/20230119/202301192303.3zOqMgPP-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/f393f2642abb0e7536df6f9f08e0d69ecfd5b435
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review alejandro-lucero-palau-amd-com/sfc-add-devlink-support-for-ef100/20230119-193440
        git checkout f393f2642abb0e7536df6f9f08e0d69ecfd5b435
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc SHELL=/bin/bash drivers/net/ethernet/sfc/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/sfc/efx_devlink.c: In function 'efx_fini_devlink':
>> drivers/net/ethernet/sfc/efx_devlink.c:402:37: warning: variable 'devlink_private' set but not used [-Wunused-but-set-variable]
     402 |                 struct efx_devlink *devlink_private;
         |                                     ^~~~~~~~~~~~~~~


vim +/devlink_private +402 drivers/net/ethernet/sfc/efx_devlink.c

   398	
   399	void efx_fini_devlink(struct efx_nic *efx)
   400	{
   401		if (efx->devlink) {
 > 402			struct efx_devlink *devlink_private;
   403	
   404			devlink_private = devlink_priv(efx->devlink);
   405	
   406			devlink_unregister(efx->devlink);
   407			devlink_free(efx->devlink);
   408			efx->devlink = NULL;
   409		}
   410	}
   411	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

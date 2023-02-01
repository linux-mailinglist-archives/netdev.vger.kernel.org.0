Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB2B686939
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 15:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbjBAO6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 09:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjBAO6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 09:58:35 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0724365EF9;
        Wed,  1 Feb 2023 06:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675263514; x=1706799514;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=y7lIjMgMVtPV5bm6OW/RddCvD8S3NDjqYUBxTdcVV5w=;
  b=oAvhkJPyBeNkg0NeDeSoM5sy5dWFGsgjREPE2c5Dvvzae7hh/R/GMwb4
   rqcpeY4II0Y160K1bJkG5aVfI0995bo2aKQo1+qK5BSUMOXUqHRfuk16N
   EJGwClD9BLDmnDyaP/RTEbBL2PNbTB1Ddk5B7QlS66R8MRBzz2VdIV+0/
   HcigVnI1iYEhGrHhRIAD+wxNeDhMv8vhuCW238T9V2EhCjYJOnbU81g3I
   cot1e5aWj0MD29QsTFKHHVJzseSo30565Av4sEdzm+HvF6UWdMIUedSIa
   IH1HyvQJ5ArVlmc2raNrsjf8NKkyEVIXA87XqkBekJv9H/zRmDKHZ9+hR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="308502812"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="308502812"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 06:58:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="910343874"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="910343874"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 01 Feb 2023 06:58:30 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pNEZB-0005Vw-2Y;
        Wed, 01 Feb 2023 14:58:29 +0000
Date:   Wed, 1 Feb 2023 22:57:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com
Cc:     oe-kbuild-all@lists.linux.dev, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        habetsm.xilinx@gmail.com, ecree.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: Re: [PATCH v4 net-next 5/8] sfc: add devlink port support for ef100
Message-ID: <202302012256.duJZ1JQ7-lkp@intel.com>
References: <20230131145822.36208-6-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131145822.36208-6-alejandro.lucero-palau@amd.com>
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

url:    https://github.com/intel-lab-lkp/linux/commits/alejandro-lucero-palau-amd-com/sfc-add-devlink-support-for-ef100/20230131-230245
patch link:    https://lore.kernel.org/r/20230131145822.36208-6-alejandro.lucero-palau%40amd.com
patch subject: [PATCH v4 net-next 5/8] sfc: add devlink port support for ef100
config: ia64-randconfig-c031-20230129 (https://download.01.org/0day-ci/archive/20230201/202302012256.duJZ1JQ7-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/b74c06500aff0021c9aaa6edf390252c3e5de2cf
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review alejandro-lucero-palau-amd-com/sfc-add-devlink-support-for-ef100/20230131-230245
        git checkout b74c06500aff0021c9aaa6edf390252c3e5de2cf
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   ia64-linux-ld: drivers/net/ethernet/sfc/ef100_nic.o: in function `ef100_remove':
   ef100_nic.c:(.text+0x2e82): undefined reference to `efx_ef100_fini_reps'
   ia64-linux-ld: ef100_nic.c:(.text+0x2e92): undefined reference to `efx_fini_mae'
   ia64-linux-ld: drivers/net/ethernet/sfc/efx_devlink.o: in function `ef100_set_devlink_port':
>> efx_devlink.c:(.text+0x32): undefined reference to `efx_mae_lookup_mport'
>> ia64-linux-ld: efx_devlink.c:(.text+0x72): undefined reference to `efx_mae_get_mport'
>> ia64-linux-ld: efx_devlink.c:(.text+0xa2): undefined reference to `ef100_mport_on_local_intf'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

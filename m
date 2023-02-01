Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D4668651B
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 12:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbjBALNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 06:13:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjBALNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 06:13:39 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709D27694;
        Wed,  1 Feb 2023 03:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675250018; x=1706786018;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=flh3PUhvuWgfXNSYtuUGSsOuSsEecDIk0rcyzyHID84=;
  b=C34X5F6rQ9CZEle9u8KiUpI/Eh/LY9RyZAHGrDbtkLF5CJhU9xjk745J
   dInaVkTmOK3KxqdjgfVuh9xhXZkr3+7ar9/+cv7DB8Gj1UfASSJ7nb0Gi
   s1oC4DpSUGZd3HEycso3cRc/EPIaICPN24eeteXVonlFvspXsOCdO3743
   BxJXs6AcKAza6yTotArVu9D8Th+nz5DanxyECyUNgbo0jmPs+HseuL7Rx
   1g+2xBAAsfBExFcrcNNPk0+tsS6p94QJ3NZIbs1fZfBYGvxFYo+DSFWfe
   3UmNKEVm5yWexGptMtFEC6XiO/zGRFXdfhb+IkVw8unxjqEk9kaak9z2L
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="355447990"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="355447990"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 03:13:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="993649169"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="993649169"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 01 Feb 2023 03:13:22 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pNB3J-0005NS-1d;
        Wed, 01 Feb 2023 11:13:21 +0000
Date:   Wed, 1 Feb 2023 19:12:51 +0800
From:   kernel test robot <lkp@intel.com>
To:     alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com
Cc:     oe-kbuild-all@lists.linux.dev, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        habetsm.xilinx@gmail.com, ecree.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: Re: [PATCH v4 net-next 3/8] sfc: enumerate mports in ef100
Message-ID: <202302011904.D2L0bvLa-lkp@intel.com>
References: <20230131145822.36208-4-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131145822.36208-4-alejandro.lucero-palau@amd.com>
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
patch link:    https://lore.kernel.org/r/20230131145822.36208-4-alejandro.lucero-palau%40amd.com
patch subject: [PATCH v4 net-next 3/8] sfc: enumerate mports in ef100
config: ia64-randconfig-c031-20230129 (https://download.01.org/0day-ci/archive/20230201/202302011904.D2L0bvLa-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/82f66ed4b7c25c6b5bbfb1d23dbea705736d7b50
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review alejandro-lucero-palau-amd-com/sfc-add-devlink-support-for-ef100/20230131-230245
        git checkout 82f66ed4b7c25c6b5bbfb1d23dbea705736d7b50
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   ia64-linux-ld: drivers/net/ethernet/sfc/ef100_nic.o: in function `ef100_remove':
>> ef100_nic.c:(.text+0x2e82): undefined reference to `efx_ef100_fini_reps'
>> ia64-linux-ld: ef100_nic.c:(.text+0x2e92): undefined reference to `efx_fini_mae'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

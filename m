Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D5B67B108
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 12:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbjAYLVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 06:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235526AbjAYLVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 06:21:17 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DF154208
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 03:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674645660; x=1706181660;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VN0QQh82k1BcojhCMMpLNoUwuv+wMO6dQc/9vOAZnWI=;
  b=htQiqR1Ju3bs8i3aoJFTKI5gVKMxmpqskZpQtS/I0uZiMEzRFZSrYrwq
   IyU/FBJ5zq5koZ9qccaWYx+vd8738BvEhtrs+sr/xp0y1pd99dUxm3j0t
   l5N4irQFCoxP5IFX7kal1iKVBuP3Xn72c2tD6ph3IgUikykS4EARAkMxw
   piXhCBkWNslS0EwkLE1VofisZmJTjNU3insIhyhiqHMszgjCH93BR9mpk
   eyaYFUHXZkLFQsDyt/irhew5KisVvYOOcHOIuZP9iBaS8Ioyk1zcOSWgN
   inr1GCrGWNdOyXHKA1llKDxphDNOBe5e2Q+eg+x7tfYu1RITm03imtXce
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="391037108"
X-IronPort-AV: E=Sophos;i="5.97,245,1669104000"; 
   d="scan'208";a="391037108"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 03:20:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="751160490"
X-IronPort-AV: E=Sophos;i="5.97,245,1669104000"; 
   d="scan'208";a="751160490"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 25 Jan 2023 03:20:56 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pKdpo-0007GT-03;
        Wed, 25 Jan 2023 11:20:56 +0000
Date:   Wed, 25 Jan 2023 19:20:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: Re: [PATCH v2 net-next 2/8] sfc: add devlink info support for ef100
Message-ID: <202301251924.Vt4cZmeM-lkp@intel.com>
References: <20230124223029.51306-3-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124223029.51306-3-alejandro.lucero-palau@amd.com>
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

url:    https://github.com/intel-lab-lkp/linux/commits/alejandro-lucero-palau-amd-com/sfc-add-devlink-support-for-ef100/20230125-063245
patch link:    https://lore.kernel.org/r/20230124223029.51306-3-alejandro.lucero-palau%40amd.com
patch subject: [PATCH v2 net-next 2/8] sfc: add devlink info support for ef100
config: i386-randconfig-a016-20230123 (https://download.01.org/0day-ci/archive/20230125/202301251924.Vt4cZmeM-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/c6a73da54918310be8c54a4b2caf2ab4a3419594
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review alejandro-lucero-palau-amd-com/sfc-add-devlink-support-for-ef100/20230125-063245
        git checkout c6a73da54918310be8c54a4b2caf2ab4a3419594
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "efx_mcdi_nvram_metadata" [drivers/net/ethernet/sfc/sfc.ko] undefined!
--
>> drivers/net/ethernet/sfc/efx_devlink.c:350:20: warning: variable 'offset' set but not used [-Wunused-but-set-variable]
size_t outlength, offset;
^
1 warning generated.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

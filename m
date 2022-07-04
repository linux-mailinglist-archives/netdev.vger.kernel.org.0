Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D153564FB9
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 10:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbiGDI2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 04:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbiGDI2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 04:28:02 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31062B1DA
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 01:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656923282; x=1688459282;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=1Jl1/QYdQy4gTteXenR4N4cevWANLr+exdqRiqeiCxM=;
  b=KgRq3SR9BuEyKFJKhaaqHJCNw2b66Sn7phpptO2LyIzwnEHWRBN9+Dl1
   ofQm9nNWkhMeg02vf21JNLeoz2Dximim6IE0pZ7oHS5SXTOBWixbkbg9w
   riOMyvXFoSkiiGSRwhwmwjaJzcmsAoio1zbAMv98z7kruY1LfjpcJl5Uo
   DBZw3DegbnXe5wl+7nSlm0kfOzzLUzp8PnxdzKKDaI9A4JaInR8CEh/me
   8ure7CQIHqSbtJZtdlqx/fSoKPzJj+PdGo2JDHpyfa2YlPLjMSZCIrKsL
   QAItCeWMUY87YyB6Mv9VBlzRmfwTHxWLjYdgbbBockNV3ydo4lZXiqjg2
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10397"; a="283800240"
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="283800240"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2022 01:28:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="567095308"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 04 Jul 2022 01:28:00 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o8HR1-000HiZ-CL;
        Mon, 04 Jul 2022 08:27:59 +0000
Date:   Mon, 4 Jul 2022 16:27:54 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jianbo Liu <jianbol@nvidia.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: [net-next:master 681/702]
 meter.c:(.text.mlx5e_tc_meter_modify+0x32c): undefined reference to
 `__udivdi3'
Message-ID: <202207041653.sy0phH8z-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   d0bf1fe6454e976e39bc1524b9159fa2c0fcf321
commit: 6ddac26cf7633766e4e59d513d81f6fd5afa6fcd [681/702] net/mlx5e: Add support to modify hardware flow meter parameters
config: mips-allyesconfig (https://download.01.org/0day-ci/archive/20220704/202207041653.sy0phH8z-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=6ddac26cf7633766e4e59d513d81f6fd5afa6fcd
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch --no-tags net-next master
        git checkout 6ddac26cf7633766e4e59d513d81f6fd5afa6fcd
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arch/mips/kernel/head.o: in function `kernel_entry':
   (.ref.text+0xac): relocation truncated to fit: R_MIPS_26 against `start_kernel'
   init/main.o: in function `set_reset_devices':
   main.c:(.init.text+0x20): relocation truncated to fit: R_MIPS_26 against `_mcount'
   main.c:(.init.text+0x30): relocation truncated to fit: R_MIPS_26 against `__sanitizer_cov_trace_pc'
   init/main.o: in function `debug_kernel':
   main.c:(.init.text+0xa4): relocation truncated to fit: R_MIPS_26 against `_mcount'
   main.c:(.init.text+0xb4): relocation truncated to fit: R_MIPS_26 against `__sanitizer_cov_trace_pc'
   init/main.o: in function `quiet_kernel':
   main.c:(.init.text+0x128): relocation truncated to fit: R_MIPS_26 against `_mcount'
   main.c:(.init.text+0x138): relocation truncated to fit: R_MIPS_26 against `__sanitizer_cov_trace_pc'
   init/main.o: in function `warn_bootconfig':
   main.c:(.init.text+0x1ac): relocation truncated to fit: R_MIPS_26 against `_mcount'
   main.c:(.init.text+0x1bc): relocation truncated to fit: R_MIPS_26 against `__sanitizer_cov_trace_pc'
   init/main.o: in function `init_setup':
   main.c:(.init.text+0x238): relocation truncated to fit: R_MIPS_26 against `_mcount'
   main.c:(.init.text+0x258): additional relocation overflows omitted from the output
   mips-linux-ld: drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.o: in function `mlx5e_tc_meter_modify':
>> meter.c:(.text.mlx5e_tc_meter_modify+0x32c): undefined reference to `__udivdi3'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

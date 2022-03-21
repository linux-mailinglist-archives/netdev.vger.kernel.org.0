Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA0F4E3184
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 21:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347295AbiCUUOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 16:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353801AbiCUUNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 16:13:38 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81DB1903C3;
        Mon, 21 Mar 2022 13:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647893500; x=1679429500;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=z8WP1RGPL88u36PT8SomMKEO3KoX3/fuD+pk4+0xO5s=;
  b=GQthUszUsCsySLpMhb2ahpHnj54CRKqlkqgpebrsHk8iIaqaEjg7S0D3
   ADbh9s8ansYvWkKeb4je6H/pghdF0iBzUouJgMkINq/nRt5KoDSmJuJEd
   4ru4mRrvT2Xsy8T7t25UTVoopE+FNKBW7J0O0OhG+Sr5qZscWCetKrZou
   aisNQspWo6Gm82cLMXtgAASfEhTAlXa/k9V+cW6MfqugVKb1bMgvQvTV0
   81U/6EpAMCf6QK+NG+4KOWiqrIS/4kNnM4pd0bHDpEfF0PlRVI6SCWzW/
   0g5tB9jui5S3lzIgPHjTJYH2aLw5iuY6KcfvzSErVwe6fXGZLXfrZD9Vb
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10293"; a="245112937"
X-IronPort-AV: E=Sophos;i="5.90,199,1643702400"; 
   d="scan'208";a="245112937"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 13:11:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,199,1643702400"; 
   d="scan'208";a="518572519"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 21 Mar 2022 13:11:36 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nWONL-000I7U-9Q; Mon, 21 Mar 2022 20:11:35 +0000
Date:   Tue, 22 Mar 2022 04:11:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, oliver@neukum.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn,
        sunshouxin@chinatelecom.cn
Subject: Re: [PATCH v5 4/4] net:bonding:Add support for IPV6 RLB to
 balance-alb mode
Message-ID: <202203220325.jryz7YMX-lkp@intel.com>
References: <20220321084704.36370-5-sunshouxin@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321084704.36370-5-sunshouxin@chinatelecom.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sun,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on 092d992b76ed9d06389af0bc5efd5279d7b1ed9f]

url:    https://github.com/0day-ci/linux/commits/Sun-Shouxin/Add-support-for-IPV6-RLB-to-balance-alb-mode/20220321-164934
base:   092d992b76ed9d06389af0bc5efd5279d7b1ed9f
config: parisc-buildonly-randconfig-r002-20220320 (https://download.01.org/0day-ci/archive/20220322/202203220325.jryz7YMX-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/d84e696c74aa408d01d0e142f8ec11dd5b6410a5
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Sun-Shouxin/Add-support-for-IPV6-RLB-to-balance-alb-mode/20220321-164934
        git checkout d84e696c74aa408d01d0e142f8ec11dd5b6410a5
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=parisc SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   hppa-linux-ld: drivers/net/phy/micrel.o: in function `lan8814_ts_info':
   (.text+0xd74): undefined reference to `ptp_clock_index'
   hppa-linux-ld: drivers/net/phy/micrel.o: in function `lan8814_probe':
   (.text+0x2ee8): undefined reference to `ptp_clock_register'
   hppa-linux-ld: drivers/net/bonding/bond_alb.o: in function `rlb_nd_recv':
>> (.text+0x2538): undefined reference to `ipv6_get_ifaddr'
>> hppa-linux-ld: (.text+0x25d0): undefined reference to `inet6_ifa_finish_destroy'

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for MICREL_PHY
   Depends on NETDEVICES && PHYLIB && PTP_1588_CLOCK_OPTIONAL
   Selected by
   - KS8851_MLL && NETDEVICES && ETHERNET && NET_VENDOR_MICREL && HAS_IOMEM
   Selected by
   - KS8851 && NETDEVICES && ETHERNET && NET_VENDOR_MICREL && SPI

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

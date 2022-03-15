Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 743F44D9DCD
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 15:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243749AbiCOOj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 10:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243674AbiCOOj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 10:39:57 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBC53BBCB;
        Tue, 15 Mar 2022 07:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647355125; x=1678891125;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jZc6rbA3KtDzxwr5RamwrlspVzRzBAtnbcHlUkft5pI=;
  b=At633+HOj8gsX44hej/nVPUHMd5SdsKVv31qZxJQH1TdHpwgJt25P7qr
   VPjxBCi8ADOfMPizqsVisHdQbpkIRwxUrbZOTFUTcJoV2uu56h4ylJYsE
   jYk18VGGXRP23fpx0ep+54Yoru/LDJY5d19fMY5zPG6zgRL4GRLPin6KE
   MQEWf4mEbk9YoE+0r9o67gsIFiBL6WXcHRf520M5L3c/3azjhvqKvobtF
   LNpMJN9+71yky3jBYPCA8F2jI67indvDKXmVybFtqP2E3nynknBI4QC43
   rxf1O8xEZfK38TC5dlMW+1eM1pb/8VpPqeWTNPKwy8lzXilRzIxtc83q/
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="256045939"
X-IronPort-AV: E=Sophos;i="5.90,183,1643702400"; 
   d="scan'208";a="256045939"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 07:38:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,183,1643702400"; 
   d="scan'208";a="646249692"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 15 Mar 2022 07:37:58 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nU8JB-000B6B-Iq; Tue, 15 Mar 2022 14:37:57 +0000
Date:   Tue, 15 Mar 2022 22:37:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        oliver@neukum.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn,
        sunshouxin@chinatelecom.cn
Subject: Re: [PATCH v2 3/4] net:bonding:Add support for IPV6 RLB to
 balance-alb mode
Message-ID: <202203152231.edfJfrCg-lkp@intel.com>
References: <20220315073008.17441-4-sunshouxin@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315073008.17441-4-sunshouxin@chinatelecom.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

[auto build test ERROR on bdd6a89de44b9e07d0b106076260d2367fe0e49a]

url:    https://github.com/0day-ci/linux/commits/Sun-Shouxin/net-bonding-Add-support-for-IPV6-RLB-to-balance-alb-mode/20220315-153427
base:   bdd6a89de44b9e07d0b106076260d2367fe0e49a
config: nios2-randconfig-r016-20220314 (https://download.01.org/0day-ci/archive/20220315/202203152231.edfJfrCg-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/e28b865b25b88aec1ae5991aaa525549fb5d1fca
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Sun-Shouxin/net-bonding-Add-support-for-IPV6-RLB-to-balance-alb-mode/20220315-153427
        git checkout e28b865b25b88aec1ae5991aaa525549fb5d1fca
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=nios2 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   nios2-linux-ld: drivers/net/bonding/bond_alb.o: in function `rlb6_update_client':
>> bond_alb.c:(.text+0x874): undefined reference to `ndisc_send_na'
   bond_alb.c:(.text+0x874): relocation truncated to fit: R_NIOS2_CALL26 against `ndisc_send_na'
>> nios2-linux-ld: bond_alb.c:(.text+0x89c): undefined reference to `ndisc_send_na'
   bond_alb.c:(.text+0x89c): relocation truncated to fit: R_NIOS2_CALL26 against `ndisc_send_na'
   nios2-linux-ld: drivers/net/bonding/bond_alb.o: in function `rlb_nd_recv':
>> bond_alb.c:(.text+0x2410): undefined reference to `ipv6_get_ifaddr'
   bond_alb.c:(.text+0x2410): relocation truncated to fit: R_NIOS2_CALL26 against `ipv6_get_ifaddr'
>> nios2-linux-ld: bond_alb.c:(.text+0x2458): undefined reference to `inet6_ifa_finish_destroy'
   bond_alb.c:(.text+0x2458): relocation truncated to fit: R_NIOS2_CALL26 against `inet6_ifa_finish_destroy'

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBEF4DC001
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 08:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiCQHM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 03:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiCQHMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 03:12:53 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEE616A698;
        Thu, 17 Mar 2022 00:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647501097; x=1679037097;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tSam5KRaNM/8DfVu9EshgRDDpoP1gUPFMYRqDojPRDo=;
  b=EXOCMSjFiQuWJNR6bv+sEGoLixckiav3bpCO523JM/7CplkQJE48Jugg
   lNs0+/vVdjr82uHx+hlBByHOrDFAKqhaHEhmdypq/QrqNzRUHmdZDNcZH
   yjoak+MPNdzGlQcv6bwPIyO2IE0ik8JTwJC6el7B37PoiHUrfzmxdyS5d
   6Yz9olfCeEDAK/7Hv6mzYiiak/W1nP1WqwuhhF4P2iH0dhdTXMcs5+G4j
   bkNOYBvx9R3nIEgB6eL+XBA0JXZ9GdfJHi4G+Lp3fDkS9NSDqVXDHkk3D
   tnt8kgcVO3NPBYRaMP7CURNam+O3Uou65j/2bbnEuOAfpZPrY4kCLCvav
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="320011600"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="320011600"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 00:11:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="690856282"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 17 Mar 2022 00:11:33 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nUkIH-000DQP-3v; Thu, 17 Mar 2022 07:11:33 +0000
Date:   Thu, 17 Mar 2022 15:10:53 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        oliver@neukum.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn,
        sunshouxin@chinatelecom.cn
Subject: Re: [PATCH v3 3/4] net:bonding:Add support for IPV6 RLB to
 balance-alb mode
Message-ID: <202203171423.P1bFFyoQ-lkp@intel.com>
References: <20220316084958.21169-4-sunshouxin@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316084958.21169-4-sunshouxin@chinatelecom.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sun,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on c84d86a0295c24487db5b7db1a61d9c0eddfbb66]

url:    https://github.com/0day-ci/linux/commits/Sun-Shouxin/net-bonding-Add-support-for-IPV6-RLB-to-balance-alb-mode/20220316-165337
base:   c84d86a0295c24487db5b7db1a61d9c0eddfbb66
config: parisc-randconfig-r015-20220317 (https://download.01.org/0day-ci/archive/20220317/202203171423.P1bFFyoQ-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/3a611f03dffa0db3ae6be64c95ea878718762ae9
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Sun-Shouxin/net-bonding-Add-support-for-IPV6-RLB-to-balance-alb-mode/20220316-165337
        git checkout 3a611f03dffa0db3ae6be64c95ea878718762ae9
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=parisc SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   hppa-linux-ld: drivers/net/bonding/bond_alb.o: in function `rlb_nd_recv':
>> (.text+0x221c): undefined reference to `ipv6_get_ifaddr'
>> hppa-linux-ld: (.text+0x2408): undefined reference to `inet6_ifa_finish_destroy'

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

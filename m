Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20AB6E1AB4
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 05:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjDNDWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 23:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjDNDWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 23:22:16 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 589CC2D40;
        Thu, 13 Apr 2023 20:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681442535; x=1712978535;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Q5Ibw2FngF2YUSfjjWDM0GHcL85te3irCjtxTaLGbYY=;
  b=kfr0dmTTpOZvSBIEARdjOxXkWzYokVMtkeZyMR31YHh9CsfXg3XCrG2D
   Cow2FgElfbfAFGyX210SERhx8B+/FfN6Q6xQReIoHhZuMG1cmctTK2HUR
   NQgyx8UqMMVRvxb6tR66rbcain8Kqj0lMmlaVav9+w8uIkwZeZfBiAhX7
   Ei3BRldKDbCkpg8DOKLSHXpMTknhnwLKc51wFj/d6SrE/ZEaTKcZq8Bna
   +UIg27G0KFTClNwIrI5xpBxZJxyHs0XQgnfS5FSJp/1rkV5H9lqDmA+oB
   BmfYb2hNwY1mpahOmeVVKJEII/vPyCND5KgS92PI+epiG+VObX1gagdhk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="341871397"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="341871397"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 20:22:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="801028511"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="801028511"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 13 Apr 2023 20:22:13 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pnA0q-000ZBJ-1R;
        Fri, 14 Apr 2023 03:22:12 +0000
Date:   Fri, 14 Apr 2023 11:21:59 +0800
From:   kernel test robot <lkp@intel.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH v2 1/2] net: extend drop reasons for multiple subsystems
Message-ID: <202304141104.ixaAlfxh-lkp@intel.com>
References: <20230330212227.928595-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330212227.928595-1-johannes@sipsolutions.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes,

kernel test robot noticed the following build warnings:

[auto build test WARNING on wireless-next/main]
[also build test WARNING on wireless/main horms-ipvs/master net/main net-next/main linus/master v6.3-rc6 next-20230413]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Johannes-Berg/mac80211-use-the-new-drop-reasons-infrastructure/20230331-052445
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
patch link:    https://lore.kernel.org/r/20230330212227.928595-1-johannes%40sipsolutions.net
patch subject: [PATCH v2 1/2] net: extend drop reasons for multiple subsystems
config: m68k-randconfig-s042-20230413 (https://download.01.org/0day-ci/archive/20230414/202304141104.ixaAlfxh-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/64925179be74db98280d706236e37e05bf7b5cca
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Johannes-Berg/mac80211-use-the-new-drop-reasons-infrastructure/20230331-052445
        git checkout 64925179be74db98280d706236e37e05bf7b5cca
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=m68k olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=m68k SHELL=/bin/bash net/core/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304141104.ixaAlfxh-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> net/core/skbuff.c:138:42: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct drop_reason_list const [noderef] __rcu * @@     got struct drop_reason_list const * @@
   net/core/skbuff.c:138:42: sparse:     expected struct drop_reason_list const [noderef] __rcu *
   net/core/skbuff.c:138:42: sparse:     got struct drop_reason_list const *

vim +138 net/core/skbuff.c

   135	
   136	const struct drop_reason_list __rcu *
   137	drop_reasons_by_subsys[SKB_DROP_REASON_SUBSYS_NUM] = {
 > 138		[SKB_DROP_REASON_SUBSYS_CORE] = &drop_reasons_core,
   139	};
   140	EXPORT_SYMBOL(drop_reasons_by_subsys);
   141	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

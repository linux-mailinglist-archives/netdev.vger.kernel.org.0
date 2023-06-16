Return-Path: <netdev+bounces-11252-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 56113732406
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 02:03:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F2A61C20EDD
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 00:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0995366;
	Fri, 16 Jun 2023 00:03:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D061F7E
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 00:03:04 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F518CD;
	Thu, 15 Jun 2023 17:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686873783; x=1718409783;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0lncjRivOzRs0P/v7LzH4bWBVMXhsYgp6N/aJVRQWqI=;
  b=H4dub/I0hBXIQxeQj9C9ICSEuAMfAPc0LHMOi4zz+nLsR0QVulA3Ni7J
   yfC4zhi+R1UbKJeSomv8evAXPKHOsnExcIOVL/LcLlxswEmn9G1rgHQ+s
   BjxYsL4DdvjIpUnThmwgw6GF83ZNzGyi5TgOjwEgtNIUpsKT+HK0vIDMT
   WiFvLrbUFs6O7SnveKmXFq2ZdnL8QxqSdc5OCkx8efE3aMM82TUN34AWT
   a1PzDcJwoYrUXvTg7RxfhBe2tBVGW2TnkGcQ1WiVXqUYX//wumsR1Z88n
   BreyktHx9e3a3unZGgDOuNnWFw2OanPs37OK+Bd4EVZd6BNztCVEI/GWk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="362489228"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="362489228"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 17:03:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="802607734"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="802607734"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Jun 2023 17:02:57 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q9wvY-0000XO-2H;
	Fri, 16 Jun 2023 00:02:56 +0000
Date: Fri, 16 Jun 2023 08:02:20 +0800
From: kernel test robot <lkp@intel.com>
To: Wei Hu <weh@microsoft.com>, netdev@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org,
	longli@microsoft.com, sharmaajay@microsoft.com, jgg@ziepe.ca,
	leon@kernel.org, kys@microsoft.com, haiyangz@microsoft.com,
	wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	vkuznets@redhat.com, ssengar@linux.microsoft.com,
	shradhagupta@linux.microsoft.com
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v3 1/1] RDMA/mana_ib: Add EQ interrupt support to mana ib
 driver.
Message-ID: <202306160702.qHOTsE7v-lkp@intel.com>
References: <20230615111412.1687573-1-weh@microsoft.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615111412.1687573-1-weh@microsoft.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Wei,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on horms-ipvs/master v6.4-rc6 next-20230615]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Wei-Hu/RDMA-mana_ib-Add-EQ-interrupt-support-to-mana-ib-driver/20230615-191709
base:   linus/master
patch link:    https://lore.kernel.org/r/20230615111412.1687573-1-weh%40microsoft.com
patch subject: [PATCH v3 1/1] RDMA/mana_ib: Add EQ interrupt support to mana ib driver.
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20230616/202306160702.qHOTsE7v-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build):
        git checkout linus/master
        b4 shazam https://lore.kernel.org/r/20230615111412.1687573-1-weh@microsoft.com
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/infiniband/hw/mana/

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306160702.qHOTsE7v-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/infiniband/hw/mana/main.c: In function 'mana_ib_destroy_eq':
>> drivers/infiniband/hw/mana/main.c:150:27: warning: unused variable 'ibdev' [-Wunused-variable]
     150 |         struct ib_device *ibdev = ucontext->ibucontext.device;
         |                           ^~~~~


vim +/ibdev +150 drivers/infiniband/hw/mana/main.c

   145	
   146	static void mana_ib_destroy_eq(struct mana_ib_ucontext *ucontext,
   147				       struct mana_ib_dev *mdev)
   148	{
   149		struct gdma_context *gc = mdev->gdma_dev->gdma_context;
 > 150		struct ib_device *ibdev = ucontext->ibucontext.device;
   151		struct gdma_queue *eq;
   152		int i;
   153	
   154		if (!ucontext->eqs)
   155			return;
   156	
   157		for (i = 0; i < gc->max_num_queues; i++) {
   158			eq = ucontext->eqs[i].eq;
   159			if (!eq)
   160				continue;
   161	
   162			mana_gd_destroy_queue(gc, eq);
   163		}
   164	
   165		kfree(ucontext->eqs);
   166		ucontext->eqs = NULL;
   167	}
   168	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


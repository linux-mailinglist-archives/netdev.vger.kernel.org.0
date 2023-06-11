Return-Path: <netdev+bounces-9940-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 274AF72B356
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 19:51:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C821028114D
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 17:51:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5780F510;
	Sun, 11 Jun 2023 17:51:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97803F509
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 17:51:15 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E453E187
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 10:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686505873; x=1718041873;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xYKAcdrJ39rdgCYXNRMarqKIDpIvzW5PC63ZEqfAMHQ=;
  b=TCcGPKbwSGIZN6Erqox58rUza92ydFuUd2O2SmL1JpTKEAxOwaab+bRp
   zGRqSsUyp7/mGsx5OOdEgoMuPugf3GR+1dQUVE8GLitW0sVkvoUUiD6kx
   fUTPHAXdZKENnLPHBFS/gCNFfOa+tUospsB4QajtrcS6QNWvvjxGG2DV6
   Dps7xBAVu8MZj4kF3C0SICLFFcV77gWiuKg8mlL0DE5V7F+lXu8IX5n2c
   lBHZbNb332eU2X+oxozUTmVIlatRRT9jLAF9p/3mAbeUD/ShQZCL8pp8G
   m/iOlMfGZddp95mRcTADRUyQmsUpoyh4vgtGZzbCVNzCt6w22cyIdDRZV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="357881636"
X-IronPort-AV: E=Sophos;i="6.00,234,1681196400"; 
   d="scan'208";a="357881636"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2023 10:51:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="800773183"
X-IronPort-AV: E=Sophos;i="6.00,234,1681196400"; 
   d="scan'208";a="800773183"
Received: from lkp-server01.sh.intel.com (HELO 15ab08e44a81) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Jun 2023 10:51:12 -0700
Received: from kbuild by 15ab08e44a81 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q8PDb-000B1p-1E;
	Sun, 11 Jun 2023 17:51:11 +0000
Date: Mon, 12 Jun 2023 01:50:33 +0800
From: kernel test robot <lkp@intel.com>
To: Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Sabrina Dubroca <sd@queasysnail.net>,
	kuba@kernel.org
Subject: Re: [PATCH net-next] netdevsim: add dummy macsec offload
Message-ID: <202306120146.8tukbUAq-lkp@intel.com>
References: <0b87a0b7f9faf82de05c5689fbe8b8b4a83aa25d.1686494112.git.sd@queasysnail.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b87a0b7f9faf82de05c5689fbe8b8b4a83aa25d.1686494112.git.sd@queasysnail.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Sabrina,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Sabrina-Dubroca/netdevsim-add-dummy-macsec-offload/20230611-234644
base:   net-next/main
patch link:    https://lore.kernel.org/r/0b87a0b7f9faf82de05c5689fbe8b8b4a83aa25d.1686494112.git.sd%40queasysnail.net
patch subject: [PATCH net-next] netdevsim: add dummy macsec offload
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20230612/202306120146.8tukbUAq-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build):
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch net-next main
        git checkout net-next/main
        b4 shazam https://lore.kernel.org/r/0b87a0b7f9faf82de05c5689fbe8b8b4a83aa25d.1686494112.git.sd@queasysnail.net
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/netdevsim/

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306120146.8tukbUAq-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/net/netdevsim/macsec.c: In function 'nsim_macsec_add_txsa':
>> drivers/net/netdevsim/macsec.c:274:27: warning: variable 'secy' set but not used [-Wunused-but-set-variable]
     274 |         struct nsim_secy *secy;
         |                           ^~~~
   drivers/net/netdevsim/macsec.c: In function 'nsim_macsec_upd_txsa':
   drivers/net/netdevsim/macsec.c:294:27: warning: variable 'secy' set but not used [-Wunused-but-set-variable]
     294 |         struct nsim_secy *secy;
         |                           ^~~~
   drivers/net/netdevsim/macsec.c: In function 'nsim_macsec_del_txsa':
   drivers/net/netdevsim/macsec.c:314:27: warning: variable 'secy' set but not used [-Wunused-but-set-variable]
     314 |         struct nsim_secy *secy;
         |                           ^~~~


vim +/secy +274 drivers/net/netdevsim/macsec.c

   270	
   271	static int nsim_macsec_add_txsa(struct macsec_context *ctx)
   272	{
   273		struct netdevsim *ns = netdev_priv(ctx->netdev);
 > 274		struct nsim_secy *secy;
   275		int idx;
   276	
   277		idx = nsim_macsec_find_secy(ns, ctx->secy->sci);
   278		if (idx < 0) {
   279			netdev_err(ctx->netdev, "%s: sci %08llx not found in secy table\n",
   280				   __func__, be64_to_cpu(ctx->secy->sci));
   281			return -ENOENT;
   282		}
   283		secy = &ns->macsec.nsim_secy[idx];
   284	
   285		netdev_dbg(ctx->netdev, "%s: SECY with sci %08llx, AN %u\n",
   286			   __func__, be64_to_cpu(ctx->secy->sci), ctx->sa.assoc_num);
   287	
   288		return 0;
   289	}
   290	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


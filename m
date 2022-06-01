Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C69153A950
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 16:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354849AbiFAOjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 10:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiFAOjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 10:39:15 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B1F31233;
        Wed,  1 Jun 2022 07:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654094354; x=1685630354;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kgeZ5dHKGAmvtm2SI9klD7xeCUa8LmfIDO8LskDbpCY=;
  b=MyuPw3nzSlQyeCaTmkm7Ejw6KJHsH675eqa5SmbWap7jFNJ/xMaYJDqT
   LcG5mXaQwjwZTpl3btRS16ja0lzt3brAE2pkcGnCa+H5YaGJJsZg/uYMt
   rifWWALy9MFPYaDKDwg+sMrx3kDu/iAgkTZRjfYKxXnLMZSfsq+AjgvS8
   5QStByOq5thYnnAcjfm3VW0QqCWk/vK0fu/G5YuaEfqeAtAt+dbpE8kvc
   tM9DeShSxR+0pB/CGmcQEmEO4SxdmohNxwGq+hVZG16A1fMerHoxsDnRQ
   14cM7nsGN0lOtB8N4oL+XWK7KClFKQBPmTEwpEa7gprXfSfu1CnNDZBTN
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10365"; a="338656201"
X-IronPort-AV: E=Sophos;i="5.91,268,1647327600"; 
   d="scan'208";a="338656201"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 07:39:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,268,1647327600"; 
   d="scan'208";a="581611535"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 01 Jun 2022 07:39:10 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nwPV2-00044e-Nc;
        Wed, 01 Jun 2022 14:39:04 +0000
Date:   Wed, 1 Jun 2022 22:38:35 +0800
From:   kernel test robot <lkp@intel.com>
To:     Haowen Bai <baihaowen@meizu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, Haowen Bai <baihaowen@meizu.com>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tulip: de4x5: remove unused variable
Message-ID: <202206012206.rmnA2Zg6-lkp@intel.com>
References: <1654068277-6691-1-git-send-email-baihaowen@meizu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1654068277-6691-1-git-send-email-baihaowen@meizu.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Haowen,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on horms-ipvs/master]
[also build test ERROR on v5.18]
[cannot apply to net-next/master net/master linus/master next-20220601]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Haowen-Bai/net-tulip-de4x5-remove-unused-variable/20220601-152922
base:   https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs.git master
config: i386-randconfig-a004 (https://download.01.org/0day-ci/archive/20220601/202206012206.rmnA2Zg6-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project c825abd6b0198fb088d9752f556a70705bc99dfd)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/98c118e28527e7ff29469521c68414943a7cfc3a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Haowen-Bai/net-tulip-de4x5-remove-unused-variable/20220601-152922
        git checkout 98c118e28527e7ff29469521c68414943a7cfc3a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/net/ethernet/dec/tulip/de4x5.c:3823:2: error: use of undeclared identifier 'imr'
           UNMASK_IRQs;
           ^
   drivers/net/ethernet/dec/tulip/de4x5.c:694:5: note: expanded from macro 'UNMASK_IRQs'
       imr |= lp->irq_mask;\
       ^
>> drivers/net/ethernet/dec/tulip/de4x5.c:3823:2: error: use of undeclared identifier 'imr'
   drivers/net/ethernet/dec/tulip/de4x5.c:695:10: note: expanded from macro 'UNMASK_IRQs'
       outl(imr, DE4X5_IMR);               /* Unmask the IRQs */\
            ^
   drivers/net/ethernet/dec/tulip/de4x5.c:3826:2: error: use of undeclared identifier 'imr'
           ENABLE_IRQs;
           ^
   drivers/net/ethernet/dec/tulip/de4x5.c:683:5: note: expanded from macro 'ENABLE_IRQs'
       imr |= lp->irq_en;\
       ^
   drivers/net/ethernet/dec/tulip/de4x5.c:3826:2: error: use of undeclared identifier 'imr'
   drivers/net/ethernet/dec/tulip/de4x5.c:684:10: note: expanded from macro 'ENABLE_IRQs'
       outl(imr, DE4X5_IMR);               /* Enable the IRQs */\
            ^
   4 errors generated.


vim +/imr +3823 drivers/net/ethernet/dec/tulip/de4x5.c

^1da177e4c3f41 drivers/net/tulip/de4x5.c              Linus Torvalds 2005-04-16  3814  
^1da177e4c3f41 drivers/net/tulip/de4x5.c              Linus Torvalds 2005-04-16  3815  static void
^1da177e4c3f41 drivers/net/tulip/de4x5.c              Linus Torvalds 2005-04-16  3816  de4x5_setup_intr(struct net_device *dev)
^1da177e4c3f41 drivers/net/tulip/de4x5.c              Linus Torvalds 2005-04-16  3817  {
^1da177e4c3f41 drivers/net/tulip/de4x5.c              Linus Torvalds 2005-04-16  3818      struct de4x5_private *lp = netdev_priv(dev);
^1da177e4c3f41 drivers/net/tulip/de4x5.c              Linus Torvalds 2005-04-16  3819      u_long iobase = dev->base_addr;
98c118e28527e7 drivers/net/ethernet/dec/tulip/de4x5.c Haowen Bai     2022-06-01  3820      s32 sts;
^1da177e4c3f41 drivers/net/tulip/de4x5.c              Linus Torvalds 2005-04-16  3821  
^1da177e4c3f41 drivers/net/tulip/de4x5.c              Linus Torvalds 2005-04-16  3822      if (inl(DE4X5_OMR) & OMR_SR) {   /* Only unmask if TX/RX is enabled */
^1da177e4c3f41 drivers/net/tulip/de4x5.c              Linus Torvalds 2005-04-16 @3823  	UNMASK_IRQs;
^1da177e4c3f41 drivers/net/tulip/de4x5.c              Linus Torvalds 2005-04-16  3824  	sts = inl(DE4X5_STS);        /* Reset any pending (stale) interrupts */
^1da177e4c3f41 drivers/net/tulip/de4x5.c              Linus Torvalds 2005-04-16  3825  	outl(sts, DE4X5_STS);
^1da177e4c3f41 drivers/net/tulip/de4x5.c              Linus Torvalds 2005-04-16  3826  	ENABLE_IRQs;
^1da177e4c3f41 drivers/net/tulip/de4x5.c              Linus Torvalds 2005-04-16  3827      }
^1da177e4c3f41 drivers/net/tulip/de4x5.c              Linus Torvalds 2005-04-16  3828  }
^1da177e4c3f41 drivers/net/tulip/de4x5.c              Linus Torvalds 2005-04-16  3829  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

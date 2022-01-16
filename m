Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2DF48FDAB
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 16:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235524AbiAPPiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 10:38:19 -0500
Received: from mga14.intel.com ([192.55.52.115]:62118 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233304AbiAPPiT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Jan 2022 10:38:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642347498; x=1673883498;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=glNv3OI3JbTJUCwTNsmkJ1SZaAvxAzvULziq2BBzk+s=;
  b=bRTTlDT7bxunBm1bAlBXSxkMOySeNmiZzPS/3v+o3VnA6Bf6EipF2VEg
   818qoJV6ODxfUi4DW+ZWWqMFWVQjnUl6ESQ/2SxvNKoxuTO0n49fBsO0f
   IgCA3s5OneqdMnJyWwHGPO0ncC2xVvhQKDW/VAKiKcQ+oYzEz445kPp7e
   60Pt5D8nQn5FWisdmd3nZRI4dXyvtzLCI2Uf8ZiNaEE/Dw8xwiOD/pWCq
   g4J0OoP8Y9ivKIfMvIV7WyINIAsNNThLpVHsRUMhGulbA0x/ilomYtJV5
   ltzy820j7rlo1Tvb76AyJLOiME0t3CjV6v+3O7OdTabSpb98LaBX0+nI7
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10228"; a="244694076"
X-IronPort-AV: E=Sophos;i="5.88,293,1635231600"; 
   d="scan'208";a="244694076"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2022 07:38:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,293,1635231600"; 
   d="scan'208";a="492091230"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 16 Jan 2022 07:38:04 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n97bV-000AoG-6m; Sun, 16 Jan 2022 15:38:01 +0000
Date:   Sun, 16 Jan 2022 23:37:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     kbuild-all@lists.01.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, m.chetan.kumar@intel.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com
Subject: Re: [PATCH net-next v4 03/13] net: wwan: t7xx: Add core components
Message-ID: <202201162348.afiiNcX1-lkp@intel.com>
References: <20220114010627.21104-4-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114010627.21104-4-ricardo.martinez@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ricardo,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Ricardo-Martinez/net-wwan-t7xx-PCIe-driver-for-MediaTek-M-2-modem/20220114-090852
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 8aaaf2f3af2ae212428f4db1af34214225f5cec3
config: ia64-randconfig-m031-20220116 (https://download.01.org/0day-ci/archive/20220116/202201162348.afiiNcX1-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/e62b3a8ab00c63ee38d0d31cd402a1a40e8b2769
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Ricardo-Martinez/net-wwan-t7xx-PCIe-driver-for-MediaTek-M-2-modem/20220114-090852
        git checkout e62b3a8ab00c63ee38d0d31cd402a1a40e8b2769
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=ia64 SHELL=/bin/bash drivers/net/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from arch/ia64/include/asm/pgtable.h:153,
                    from include/linux/pgtable.h:6,
                    from include/linux/mm.h:33,
                    from include/linux/scatterlist.h:8,
                    from include/linux/dma-mapping.h:10,
                    from drivers/net/wwan/t7xx/t7xx_pci.c:23:
   arch/ia64/include/asm/mmu_context.h: In function 'reload_context':
>> arch/ia64/include/asm/mmu_context.h:127:48: error: variable 'old_rr4' set but not used [-Werror=unused-but-set-variable]
     127 |         unsigned long rr0, rr1, rr2, rr3, rr4, old_rr4;
         |                                                ^~~~~~~
   cc1: all warnings being treated as errors


vim +/old_rr4 +127 arch/ia64/include/asm/mmu_context.h

^1da177e4c3f41 include/asm-ia64/mmu_context.h Linus Torvalds       2005-04-16  121  
^1da177e4c3f41 include/asm-ia64/mmu_context.h Linus Torvalds       2005-04-16  122  static inline void
badea125d7cbd9 include/asm-ia64/mmu_context.h David Mosberger-Tang 2005-07-25  123  reload_context (nv_mm_context_t context)
^1da177e4c3f41 include/asm-ia64/mmu_context.h Linus Torvalds       2005-04-16  124  {
^1da177e4c3f41 include/asm-ia64/mmu_context.h Linus Torvalds       2005-04-16  125  	unsigned long rid;
^1da177e4c3f41 include/asm-ia64/mmu_context.h Linus Torvalds       2005-04-16  126  	unsigned long rid_incr = 0;
^1da177e4c3f41 include/asm-ia64/mmu_context.h Linus Torvalds       2005-04-16 @127  	unsigned long rr0, rr1, rr2, rr3, rr4, old_rr4;
^1da177e4c3f41 include/asm-ia64/mmu_context.h Linus Torvalds       2005-04-16  128  
0a41e250116058 include/asm-ia64/mmu_context.h Peter Chubb          2005-08-16  129  	old_rr4 = ia64_get_rr(RGN_BASE(RGN_HPAGE));
^1da177e4c3f41 include/asm-ia64/mmu_context.h Linus Torvalds       2005-04-16  130  	rid = context << 3;	/* make space for encoding the region number */
^1da177e4c3f41 include/asm-ia64/mmu_context.h Linus Torvalds       2005-04-16  131  	rid_incr = 1 << 8;
^1da177e4c3f41 include/asm-ia64/mmu_context.h Linus Torvalds       2005-04-16  132  
^1da177e4c3f41 include/asm-ia64/mmu_context.h Linus Torvalds       2005-04-16  133  	/* encode the region id, preferred page size, and VHPT enable bit: */
^1da177e4c3f41 include/asm-ia64/mmu_context.h Linus Torvalds       2005-04-16  134  	rr0 = (rid << 8) | (PAGE_SHIFT << 2) | 1;
^1da177e4c3f41 include/asm-ia64/mmu_context.h Linus Torvalds       2005-04-16  135  	rr1 = rr0 + 1*rid_incr;
^1da177e4c3f41 include/asm-ia64/mmu_context.h Linus Torvalds       2005-04-16  136  	rr2 = rr0 + 2*rid_incr;
^1da177e4c3f41 include/asm-ia64/mmu_context.h Linus Torvalds       2005-04-16  137  	rr3 = rr0 + 3*rid_incr;
^1da177e4c3f41 include/asm-ia64/mmu_context.h Linus Torvalds       2005-04-16  138  	rr4 = rr0 + 4*rid_incr;
^1da177e4c3f41 include/asm-ia64/mmu_context.h Linus Torvalds       2005-04-16  139  #ifdef  CONFIG_HUGETLB_PAGE
^1da177e4c3f41 include/asm-ia64/mmu_context.h Linus Torvalds       2005-04-16  140  	rr4 = (rr4 & (~(0xfcUL))) | (old_rr4 & 0xfc);
0a41e250116058 include/asm-ia64/mmu_context.h Peter Chubb          2005-08-16  141  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0DC96B7305
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 10:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbjCMJpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 05:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjCMJpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 05:45:12 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9886D20D06;
        Mon, 13 Mar 2023 02:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678700711; x=1710236711;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TReTk24bbiXEi1gHGeFE2C7gjJwpDCxBUwc5iby4wHM=;
  b=a9mxAPbIllxPmOEf+1KCJspPsqGmevYyplak1HxrG3xGedjRW1eu9J9U
   RPecdcYPXPn1z7abnyX+c7G+4FGYlAtt13cjuFrOFtEHN2gLpq4wq+/qj
   CH5T/yaA/KHbSfL2iQlnuDf22KYBWUAPEjGnF6ZXFcZPjIuRK3xXPTS5i
   zbDQZc46VnnQBYkd/zzEE3soJVgtLjLRqHbHXMMPLphUHakEC7UKQSTGE
   m2t1IEr0fTZdeExvItmU+3o9DTXXjQqOigeDRkc0bEzbO+7dMuTvhvfoF
   olC1rIIOeg/Yo+p088x50TNF54b9eB/9eYnWJg63phwv4H7YB8oIPT8pP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="401974930"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="401974930"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 02:45:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="678624245"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="678624245"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 13 Mar 2023 02:45:08 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pbejr-0005Ww-2S;
        Mon, 13 Mar 2023 09:45:07 +0000
Date:   Mon, 13 Mar 2023 17:44:13 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dongliang Mu <dzm91@hust.edu.cn>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
        Dongliang Mu <dzm91@hust.edu.cn>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] wifi: ray_cs: remove one redundant del_timer
Message-ID: <202303131721.wELY9b9M-lkp@intel.com>
References: <20230313065823.256731-1-dzm91@hust.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313065823.256731-1-dzm91@hust.edu.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dongliang,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on wireless-next/main]
[also build test WARNING on wireless/main linus/master v6.3-rc2 next-20230310]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Dongliang-Mu/wifi-ray_cs-add-sanity-check-on-local-sram-rmem-amem/20230313-150341
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
patch link:    https://lore.kernel.org/r/20230313065823.256731-1-dzm91%40hust.edu.cn
patch subject: [PATCH 1/2] wifi: ray_cs: remove one redundant del_timer
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20230313/202303131721.wELY9b9M-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/8b405d9c164f51ae0d9a2b1e0b0460b09e71e5c9
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Dongliang-Mu/wifi-ray_cs-add-sanity-check-on-local-sram-rmem-amem/20230313-150341
        git checkout 8b405d9c164f51ae0d9a2b1e0b0460b09e71e5c9
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303131721.wELY9b9M-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/net/wireless/ray_cs.c: In function 'ray_detach':
>> drivers/net/wireless/ray_cs.c:325:20: warning: unused variable 'local' [-Wunused-variable]
     325 |         ray_dev_t *local;
         |                    ^~~~~
   In file included from include/linux/string.h:254,
                    from include/linux/bitmap.h:11,
                    from include/linux/cpumask.h:12,
                    from arch/x86/include/asm/paravirt.h:17,
                    from arch/x86/include/asm/cpuid.h:62,
                    from arch/x86/include/asm/processor.h:19,
                    from arch/x86/include/asm/timex.h:5,
                    from include/linux/timex.h:67,
                    from include/linux/time32.h:13,
                    from include/linux/time.h:60,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:13,
                    from drivers/net/wireless/ray_cs.c:20:
   In function 'strncpy',
       inlined from 'init_startup_params' at drivers/net/wireless/ray_cs.c:625:3:
   include/linux/fortify-string.h:68:33: warning: '__builtin_strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
      68 | #define __underlying_strncpy    __builtin_strncpy
         |                                 ^
   include/linux/fortify-string.h:151:16: note: in expansion of macro '__underlying_strncpy'
     151 |         return __underlying_strncpy(p, q, size);
         |                ^~~~~~~~~~~~~~~~~~~~


vim +/local +325 drivers/net/wireless/ray_cs.c

141fa61f10c419 John Daiker       2009-03-10  321  
fba395eee7d3f3 Dominik Brodowski 2006-03-31  322  static void ray_detach(struct pcmcia_device *link)
^1da177e4c3f41 Linus Torvalds    2005-04-16  323  {
cc3b4866bee996 Dominik Brodowski 2005-11-14  324  	struct net_device *dev;
cc3b4866bee996 Dominik Brodowski 2005-11-14 @325  	ray_dev_t *local;
^1da177e4c3f41 Linus Torvalds    2005-04-16  326  
624dd66957e53e Dominik Brodowski 2009-10-24  327  	dev_dbg(&link->dev, "ray_detach\n");
^1da177e4c3f41 Linus Torvalds    2005-04-16  328  
fd238232cd0ff4 Dominik Brodowski 2006-03-05  329  	this_device = NULL;
cc3b4866bee996 Dominik Brodowski 2005-11-14  330  	dev = link->priv;
cc3b4866bee996 Dominik Brodowski 2005-11-14  331  
^1da177e4c3f41 Linus Torvalds    2005-04-16  332  	ray_release(link);
^1da177e4c3f41 Linus Torvalds    2005-04-16  333  
^1da177e4c3f41 Linus Torvalds    2005-04-16  334  	if (link->priv) {
141fa61f10c419 John Daiker       2009-03-10  335  		unregister_netdev(dev);
^1da177e4c3f41 Linus Torvalds    2005-04-16  336  		free_netdev(dev);
^1da177e4c3f41 Linus Torvalds    2005-04-16  337  	}
624dd66957e53e Dominik Brodowski 2009-10-24  338  	dev_dbg(&link->dev, "ray_cs ray_detach ending\n");
^1da177e4c3f41 Linus Torvalds    2005-04-16  339  } /* ray_detach */
141fa61f10c419 John Daiker       2009-03-10  340  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

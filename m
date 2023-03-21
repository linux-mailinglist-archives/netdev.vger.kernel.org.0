Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A75D6C2B50
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 08:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjCUHZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 03:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjCUHZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 03:25:28 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34DFE195
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 00:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679383526; x=1710919526;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tiqBbCtdZWSDGBrFauYtNNRFuabN5SnCzI7+Y8VNfec=;
  b=gF/xZgXhlcsw4UyuVlniVfPchp0TUvsfMnfo59abchAntL1MsmSimF3i
   V7Rox8RjGmlBz038OSPmA5q7quSPmyIcAM/9wLCzy8u5qQv77OrZQZbj7
   JaYoiBFEck9y4MJOrqAeiOUtTKwH6tzEhlS7Cf0c7zqjcn4fhZrRHTyKp
   82y5XS4U2AZSP+/fBm7/nYNAO41rzgDWZB1255PogT/pOmqg+ISoeX7Mh
   uJw7BR/8hGOrcboCpbiJpwxK2aZdILsTzaSSKzFymgxTCrJ6H5PcozTFm
   M1MDi8OmW+3IA0l6dCuh5JGMGjqm2jNr80O7wDucb17cQAAnoU6THa2Ee
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="322711890"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="322711890"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 00:25:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="683748123"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="683748123"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 21 Mar 2023 00:25:18 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1peWMv-000BiW-34;
        Tue, 21 Mar 2023 07:25:17 +0000
Date:   Tue, 21 Mar 2023 15:24:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] net: introduce a config option to tweak
 MAX_SKB_FRAGS
Message-ID: <202303211550.hxkdeVey-lkp@intel.com>
References: <20230321033704.936685-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321033704.936685-1-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Dumazet/net-introduce-a-config-option-to-tweak-MAX_SKB_FRAGS/20230321-113826
patch link:    https://lore.kernel.org/r/20230321033704.936685-1-eric.dumazet%40gmail.com
patch subject: [PATCH net-next] net: introduce a config option to tweak MAX_SKB_FRAGS
config: riscv-randconfig-r016-20230319 (https://download.01.org/0day-ci/archive/20230321/202303211550.hxkdeVey-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project 67409911353323ca5edf2049ef0df54132fa1ca7)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/d0eaa3eabce1c80d067a739749e4253546417722
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Eric-Dumazet/net-introduce-a-config-option-to-tweak-MAX_SKB_FRAGS/20230321-113826
        git checkout d0eaa3eabce1c80d067a739749e4253546417722
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash drivers/bus/mhi/host/ kernel/bpf/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303211550.hxkdeVey-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/bus/mhi/host/init.c:15:
   In file included from include/linux/mhi.h:12:
>> include/linux/skbuff.h:593:19: error: use of undeclared identifier 'CONFIG_MAX_SKB_FRAGS'
           skb_frag_t      frags[MAX_SKB_FRAGS];
                                 ^
   include/linux/skbuff.h:348:23: note: expanded from macro 'MAX_SKB_FRAGS'
   #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
                         ^
   1 error generated.
--
   In file included from drivers/bus/mhi/host/main.c:13:
   In file included from include/linux/mhi.h:12:
>> include/linux/skbuff.h:593:19: error: use of undeclared identifier 'CONFIG_MAX_SKB_FRAGS'
           skb_frag_t      frags[MAX_SKB_FRAGS];
                                 ^
   include/linux/skbuff.h:348:23: note: expanded from macro 'MAX_SKB_FRAGS'
   #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
                         ^
   drivers/bus/mhi/host/main.c:803:13: warning: parameter 'event_quota' set but not used [-Wunused-but-set-parameter]
                                u32 event_quota)
                                    ^
   1 warning and 1 error generated.
--
   In file included from kernel/bpf/core.c:21:
   In file included from include/linux/filter.h:12:
>> include/linux/skbuff.h:593:19: error: use of undeclared identifier 'CONFIG_MAX_SKB_FRAGS'
           skb_frag_t      frags[MAX_SKB_FRAGS];
                                 ^
   include/linux/skbuff.h:348:23: note: expanded from macro 'MAX_SKB_FRAGS'
   #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
                         ^
   kernel/bpf/core.c:1632:12: warning: no previous prototype for function 'bpf_probe_read_kernel' [-Wmissing-prototypes]
   u64 __weak bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr)
              ^
   kernel/bpf/core.c:1632:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   u64 __weak bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr)
   ^
   static 
   1 warning and 1 error generated.
--
   In file included from kernel/bpf/btf.c:19:
   In file included from include/linux/bpf_verifier.h:9:
   In file included from include/linux/filter.h:12:
>> include/linux/skbuff.h:593:19: error: use of undeclared identifier 'CONFIG_MAX_SKB_FRAGS'
           skb_frag_t      frags[MAX_SKB_FRAGS];
                                 ^
   include/linux/skbuff.h:348:23: note: expanded from macro 'MAX_SKB_FRAGS'
   #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
                         ^
   In file included from kernel/bpf/btf.c:23:
>> include/linux/skmsg.h:32:23: error: use of undeclared identifier 'CONFIG_MAX_SKB_FRAGS'
           DECLARE_BITMAP(copy, MAX_MSG_FRAGS + 2);
                                ^
   include/linux/skmsg.h:16:25: note: expanded from macro 'MAX_MSG_FRAGS'
   #define MAX_MSG_FRAGS                   MAX_SKB_FRAGS
                                           ^
   include/linux/skbuff.h:348:23: note: expanded from macro 'MAX_SKB_FRAGS'
   #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
                         ^
   In file included from kernel/bpf/btf.c:23:
   include/linux/skmsg.h:39:27: error: use of undeclared identifier 'CONFIG_MAX_SKB_FRAGS'
           struct scatterlist              data[MAX_MSG_FRAGS + 2];
                                                ^
   include/linux/skmsg.h:16:25: note: expanded from macro 'MAX_MSG_FRAGS'
   #define MAX_MSG_FRAGS                   MAX_SKB_FRAGS
                                           ^
   include/linux/skbuff.h:348:23: note: expanded from macro 'MAX_SKB_FRAGS'
   #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
                         ^
   In file included from kernel/bpf/btf.c:23:
   include/linux/skmsg.h:151:45: error: use of undeclared identifier 'CONFIG_MAX_SKB_FRAGS'
           return end >= start ? end - start : end + (NR_MSG_FRAG_IDS - start);
                                                      ^
   include/linux/skmsg.h:17:28: note: expanded from macro 'NR_MSG_FRAG_IDS'
   #define NR_MSG_FRAG_IDS                 (MAX_MSG_FRAGS + 1)
                                            ^
   include/linux/skmsg.h:16:25: note: expanded from macro 'MAX_MSG_FRAGS'
   #define MAX_MSG_FRAGS                   MAX_SKB_FRAGS
                                           ^
   include/linux/skbuff.h:348:23: note: expanded from macro 'MAX_SKB_FRAGS'
   #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
                         ^
   In file included from kernel/bpf/btf.c:23:
   include/linux/skmsg.h:177:47: error: use of undeclared identifier 'CONFIG_MAX_SKB_FRAGS'
           BUILD_BUG_ON(ARRAY_SIZE(msg->sg.data) - 1 != NR_MSG_FRAG_IDS);
                                                        ^
   include/linux/skmsg.h:17:28: note: expanded from macro 'NR_MSG_FRAG_IDS'
   #define NR_MSG_FRAG_IDS                 (MAX_MSG_FRAGS + 1)
                                            ^
   include/linux/skmsg.h:16:25: note: expanded from macro 'MAX_MSG_FRAGS'
   #define MAX_MSG_FRAGS                   MAX_SKB_FRAGS
                                           ^
   include/linux/skbuff.h:348:23: note: expanded from macro 'MAX_SKB_FRAGS'
   #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
                         ^
   In file included from kernel/bpf/btf.c:23:
   include/linux/skmsg.h:179:31: error: use of undeclared identifier 'CONFIG_MAX_SKB_FRAGS'
           sg_init_marker(msg->sg.data, NR_MSG_FRAG_IDS);
                                        ^
   include/linux/skmsg.h:17:28: note: expanded from macro 'NR_MSG_FRAG_IDS'
   #define NR_MSG_FRAG_IDS                 (MAX_MSG_FRAGS + 1)
                                            ^
   include/linux/skmsg.h:16:25: note: expanded from macro 'MAX_MSG_FRAGS'
   #define MAX_MSG_FRAGS                   MAX_SKB_FRAGS
                                           ^
   include/linux/skbuff.h:348:23: note: expanded from macro 'MAX_SKB_FRAGS'
   #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
                         ^
   In file included from kernel/bpf/btf.c:23:
   include/linux/skmsg.h:201:57: error: use of undeclared identifier 'CONFIG_MAX_SKB_FRAGS'
           return sk_msg_iter_dist(msg->sg.start, msg->sg.end) == MAX_MSG_FRAGS;
                                                                  ^
   include/linux/skmsg.h:16:25: note: expanded from macro 'MAX_MSG_FRAGS'
   #define MAX_MSG_FRAGS                   MAX_SKB_FRAGS
                                           ^
   include/linux/skbuff.h:348:23: note: expanded from macro 'MAX_SKB_FRAGS'
   #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
                         ^
   In file included from kernel/bpf/btf.c:23:
   include/linux/skmsg.h:254:2: error: use of undeclared identifier 'CONFIG_MAX_SKB_FRAGS'
           sk_msg_iter_next(msg, end);
           ^
   include/linux/skmsg.h:173:2: note: expanded from macro 'sk_msg_iter_next'
           sk_msg_iter_var_next(msg->sg.which)
           ^
   include/linux/skmsg.h:165:14: note: expanded from macro 'sk_msg_iter_var_next'
                   if (var == NR_MSG_FRAG_IDS)             \
                              ^
   include/linux/skmsg.h:17:28: note: expanded from macro 'NR_MSG_FRAG_IDS'
   #define NR_MSG_FRAG_IDS                 (MAX_MSG_FRAGS + 1)
                                            ^
   include/linux/skmsg.h:16:25: note: expanded from macro 'MAX_MSG_FRAGS'
   #define MAX_MSG_FRAGS                   MAX_SKB_FRAGS
                                           ^
   include/linux/skbuff.h:348:23: note: expanded from macro 'MAX_SKB_FRAGS'
   #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
                         ^
   In file included from kernel/bpf/btf.c:23:
   include/linux/skmsg.h:264:3: error: use of undeclared identifier 'CONFIG_MAX_SKB_FRAGS'
                   sk_msg_iter_var_next(i);
                   ^
   include/linux/skmsg.h:165:14: note: expanded from macro 'sk_msg_iter_var_next'
                   if (var == NR_MSG_FRAG_IDS)             \
                              ^
   include/linux/skmsg.h:17:28: note: expanded from macro 'NR_MSG_FRAG_IDS'
   #define NR_MSG_FRAG_IDS                 (MAX_MSG_FRAGS + 1)
                                            ^
   include/linux/skmsg.h:16:25: note: expanded from macro 'MAX_MSG_FRAGS'
   #define MAX_MSG_FRAGS                   MAX_SKB_FRAGS
                                           ^
   include/linux/skbuff.h:348:23: note: expanded from macro 'MAX_SKB_FRAGS'


vim +/CONFIG_MAX_SKB_FRAGS +593 include/linux/skbuff.h

6f89dbce8e11344 Sowmini Varadhan 2018-02-15  565  
^1da177e4c3f415 Linus Torvalds   2005-04-16  566  /* This data is invariant across clones and lives at
^1da177e4c3f415 Linus Torvalds   2005-04-16  567   * the end of the header data, ie. at skb->end.
^1da177e4c3f415 Linus Torvalds   2005-04-16  568   */
^1da177e4c3f415 Linus Torvalds   2005-04-16  569  struct skb_shared_info {
06b4feb37e64e54 Jonathan Lemon   2021-01-06  570  	__u8		flags;
de8f3a83b0a0fdd Daniel Borkmann  2017-09-25  571  	__u8		meta_len;
de8f3a83b0a0fdd Daniel Borkmann  2017-09-25  572  	__u8		nr_frags;
9f42f126154786e Ian Campbell     2012-01-05  573  	__u8		tx_flags;
7967168cefdbc63 Herbert Xu       2006-06-22  574  	unsigned short	gso_size;
7967168cefdbc63 Herbert Xu       2006-06-22  575  	/* Warning: this field is not always filled in (UFO)! */
7967168cefdbc63 Herbert Xu       2006-06-22  576  	unsigned short	gso_segs;
^1da177e4c3f415 Linus Torvalds   2005-04-16  577  	struct sk_buff	*frag_list;
ac45f602ee3d1b6 Patrick Ohly     2009-02-12  578  	struct skb_shared_hwtstamps hwtstamps;
7f564528a480084 Steffen Klassert 2017-04-08  579  	unsigned int	gso_type;
09c2d251b707236 Willem de Bruijn 2014-08-04  580  	u32		tskey;
ec7d2f2cf3a1b76 Eric Dumazet     2010-05-05  581  
ec7d2f2cf3a1b76 Eric Dumazet     2010-05-05  582  	/*
ec7d2f2cf3a1b76 Eric Dumazet     2010-05-05  583  	 * Warning : all fields before dataref are cleared in __alloc_skb()
ec7d2f2cf3a1b76 Eric Dumazet     2010-05-05  584  	 */
ec7d2f2cf3a1b76 Eric Dumazet     2010-05-05  585  	atomic_t	dataref;
d16697cb6261d4c Lorenzo Bianconi 2022-01-21  586  	unsigned int	xdp_frags_size;
ec7d2f2cf3a1b76 Eric Dumazet     2010-05-05  587  
69e3c75f4d541a6 Johann Baudy     2009-05-18  588  	/* Intermediate layers must ensure that destructor_arg
69e3c75f4d541a6 Johann Baudy     2009-05-18  589  	 * remains valid until skb destructor */
69e3c75f4d541a6 Johann Baudy     2009-05-18  590  	void *		destructor_arg;
a6686f2f382b13f Shirley Ma       2011-07-06  591  
fed66381d65a351 Eric Dumazet     2010-07-22  592  	/* must be last field, see pskb_expand_head() */
fed66381d65a351 Eric Dumazet     2010-07-22 @593  	skb_frag_t	frags[MAX_SKB_FRAGS];
^1da177e4c3f415 Linus Torvalds   2005-04-16  594  };
^1da177e4c3f415 Linus Torvalds   2005-04-16  595  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

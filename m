Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E658A6C47CA
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 11:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbjCVKhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 06:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbjCVKhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 06:37:37 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E835661300
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 03:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679481455; x=1711017455;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cwld4tUfzCXVS+ZhLuw6JZwRrQeuSkHkSbXxsbtzY2k=;
  b=Zm4quzJwWHV76sV+hVKtQzbCKulgdelnBanvMxLkXOlgqV4l8HP+gcZP
   vWP+b07h+Xwxs9ReaKGY2aSvJeBPh3y+FUWhqdevlvzmL57aOs+Kluhbu
   6eO7TbwdhTNlfizkH9yQlqZRS6WE+YAcycYxzGUU03SFet19hxx7FO6qp
   YWjEZHLnxmDKlLz1HeyBuOGqTq4WQB9EMuPIjv56G7qkqJatnLqjhIjMh
   vNdsnA2Ok0cyA7Q7ddEKU5PX3oZ4g4e+Z5iRB9pQyLUpVR819yLL33IdH
   Tt/8t+s5smNPGouxr58WlZEEwxv1oO0u0SQCGfQ4rup4iiQuKBsJZznNv
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="318824509"
X-IronPort-AV: E=Sophos;i="5.98,281,1673942400"; 
   d="scan'208";a="318824509"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 03:37:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="631951832"
X-IronPort-AV: E=Sophos;i="5.98,281,1673942400"; 
   d="scan'208";a="631951832"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 22 Mar 2023 03:37:33 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pevqW-000DBE-1b;
        Wed, 22 Mar 2023 10:37:32 +0000
Date:   Wed, 22 Mar 2023 18:36:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v2 net-next] net: introduce a config option to tweak
 MAX_SKB_FRAGS
Message-ID: <202303221833.CjbkODlQ-lkp@intel.com>
References: <20230321163550.1574254-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321163550.1574254-1-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Dumazet/net-introduce-a-config-option-to-tweak-MAX_SKB_FRAGS/20230322-003641
patch link:    https://lore.kernel.org/r/20230321163550.1574254-1-eric.dumazet%40gmail.com
patch subject: [PATCH v2 net-next] net: introduce a config option to tweak MAX_SKB_FRAGS
config: ia64-randconfig-r005-20230322 (https://download.01.org/0day-ci/archive/20230322/202303221833.CjbkODlQ-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/69776fdcf56a3d545d8b37c25829fcadec2d9144
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Eric-Dumazet/net-introduce-a-config-option-to-tweak-MAX_SKB_FRAGS/20230322-003641
        git checkout 69776fdcf56a3d545d8b37c25829fcadec2d9144
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 SHELL=/bin/bash kernel/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303221833.CjbkODlQ-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/filter.h:12,
                    from include/linux/bpf_verifier.h:9,
                    from kernel/bpf/btf.c:19:
   include/linux/skbuff.h:348:23: error: 'CONFIG_MAX_SKB_FRAGS' undeclared here (not in a function); did you mean 'MAX_SKB_FRAGS'?
     348 | #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
         |                       ^~~~~~~~~~~~~~~~~~~~
   include/linux/skbuff.h:593:31: note: in expansion of macro 'MAX_SKB_FRAGS'
     593 |         skb_frag_t      frags[MAX_SKB_FRAGS];
         |                               ^~~~~~~~~~~~~
   include/linux/skbuff.h: In function '__skb_fill_page_desc_noacc':
   include/linux/skbuff.h:2392:51: warning: parameter 'i' set but not used [-Wunused-but-set-parameter]
    2392 |                                               int i, struct page *page,
         |                                               ~~~~^
   include/linux/skbuff.h: In function 'skb_frag_ref':
   include/linux/skbuff.h:3380:58: warning: parameter 'f' set but not used [-Wunused-but-set-parameter]
    3380 | static inline void skb_frag_ref(struct sk_buff *skb, int f)
         |                                                      ~~~~^
   include/linux/skbuff.h: In function 'skb_frag_unref':
   include/linux/skbuff.h:3411:60: warning: parameter 'f' set but not used [-Wunused-but-set-parameter]
    3411 | static inline void skb_frag_unref(struct sk_buff *skb, int f)
         |                                                        ~~~~^
   include/linux/skbuff.h: In function 'skb_frag_set_page':
   include/linux/skbuff.h:3478:63: warning: parameter 'f' set but not used [-Wunused-but-set-parameter]
    3478 | static inline void skb_frag_set_page(struct sk_buff *skb, int f,
         |                                                           ~~~~^
   In file included from <command-line>:
   include/linux/skmsg.h: In function 'sk_msg_init':
>> include/linux/build_bug.h:16:51: error: bit-field '<anonymous>' width not an integer constant
      16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
         |                                                   ^
   include/linux/compiler_types.h:377:23: note: in definition of macro '__compiletime_assert'
     377 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:397:9: note: in expansion of macro '_compiletime_assert'
     397 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   include/linux/skmsg.h:177:9: note: in expansion of macro 'BUILD_BUG_ON'
     177 |         BUILD_BUG_ON(ARRAY_SIZE(msg->sg.data) - 1 != NR_MSG_FRAG_IDS);
         |         ^~~~~~~~~~~~
   include/linux/compiler.h:232:33: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     232 | #define __must_be_array(a)      BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
         |                                 ^~~~~~~~~~~~~~~~~
   include/linux/kernel.h:55:59: note: in expansion of macro '__must_be_array'
      55 | #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
         |                                                           ^~~~~~~~~~~~~~~
   include/linux/skmsg.h:177:22: note: in expansion of macro 'ARRAY_SIZE'
     177 |         BUILD_BUG_ON(ARRAY_SIZE(msg->sg.data) - 1 != NR_MSG_FRAG_IDS);
         |                      ^~~~~~~~~~
   In file included from kernel/bpf/btf.c:23:
   include/linux/skmsg.h: In function 'sk_msg_xfer':
   include/linux/skmsg.h:183:36: warning: parameter 'which' set but not used [-Wunused-but-set-parameter]
     183 |                                int which, u32 size)
         |                                ~~~~^~~~~
   include/linux/skmsg.h: In function 'sk_msg_elem':
   include/linux/skmsg.h:209:71: warning: parameter 'which' set but not used [-Wunused-but-set-parameter]
     209 | static inline struct scatterlist *sk_msg_elem(struct sk_msg *msg, int which)
         |                                                                   ~~~~^~~~~
   include/linux/skmsg.h: In function 'sk_msg_elem_cpy':
   include/linux/skmsg.h:214:74: warning: parameter 'which' set but not used [-Wunused-but-set-parameter]
     214 | static inline struct scatterlist sk_msg_elem_cpy(struct sk_msg *msg, int which)
         |                                                                      ~~~~^~~~~
   kernel/bpf/btf.c: In function 'btf_seq_show':
   kernel/bpf/btf.c:7101:29: warning: function 'btf_seq_show' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
    7101 |         seq_vprintf((struct seq_file *)show->target, fmt, args);
         |                             ^~~~~~~~
   kernel/bpf/btf.c: In function 'btf_snprintf_show':
   kernel/bpf/btf.c:7138:9: warning: function 'btf_snprintf_show' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
    7138 |         len = vsnprintf(show->target, ssnprintf->len_left, fmt, args);
         |         ^~~


vim +16 include/linux/build_bug.h

bc6245e5efd70c Ian Abbott       2017-07-10   6  
bc6245e5efd70c Ian Abbott       2017-07-10   7  #ifdef __CHECKER__
bc6245e5efd70c Ian Abbott       2017-07-10   8  #define BUILD_BUG_ON_ZERO(e) (0)
bc6245e5efd70c Ian Abbott       2017-07-10   9  #else /* __CHECKER__ */
bc6245e5efd70c Ian Abbott       2017-07-10  10  /*
bc6245e5efd70c Ian Abbott       2017-07-10  11   * Force a compilation error if condition is true, but also produce a
8788994376d84d Rikard Falkeborn 2019-12-04  12   * result (of value 0 and type int), so the expression can be used
bc6245e5efd70c Ian Abbott       2017-07-10  13   * e.g. in a structure initializer (or where-ever else comma expressions
bc6245e5efd70c Ian Abbott       2017-07-10  14   * aren't permitted).
bc6245e5efd70c Ian Abbott       2017-07-10  15   */
8788994376d84d Rikard Falkeborn 2019-12-04 @16  #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
527edbc18a70e7 Masahiro Yamada  2019-01-03  17  #endif /* __CHECKER__ */
527edbc18a70e7 Masahiro Yamada  2019-01-03  18  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A684817F3
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 01:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbhL3A52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 19:57:28 -0500
Received: from mga06.intel.com ([134.134.136.31]:51232 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233673AbhL3A52 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 19:57:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640825848; x=1672361848;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WwDri9jJu3hZEwl7yyP74fwvRjKINBNWg+MB7eyLwL4=;
  b=kfS+8hspyeJjmSoJZ/EDUAnwzq5k3Juob3IfTtu4ptbkf0y6yEymsJQ8
   4vn8OsXrolUZw+f5bDQ8unhU+mWj7KzemqNTe4g6+oO66YOLtUgc5856s
   /fjPekcPTgvqY6gIuiUD9fz8//pEKxQksux0G47wtRrdYv4T3mOw8e+v4
   33sPprJrdIprIM9WIEv3qOBP41Qgu8fNcIdvNizzxWo6GbxCZttTA3CaW
   ghtXUIAURLapoMHQaV67j9sVp7fsLox3dtgpxjq11987/0uo29zWQ58gx
   yrXX9K8mlsmRr2BLNHxIhWrKjfx4oA03cRBRfHlMaYtjoUEFCvV7hMNnK
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10212"; a="302346504"
X-IronPort-AV: E=Sophos;i="5.88,246,1635231600"; 
   d="scan'208";a="302346504"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2021 16:57:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,246,1635231600"; 
   d="scan'208";a="619225745"
Received: from lkp-server01.sh.intel.com (HELO e357b3ef1427) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 29 Dec 2021 16:57:25 -0800
Received: from kbuild by e357b3ef1427 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n2jkz-0009Wi-0O; Thu, 30 Dec 2021 00:57:25 +0000
Date:   Thu, 30 Dec 2021 08:57:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH bpf-next 2/2] bpf: invert the dependency between
 bpf-netns.h and netns/bpf.h
Message-ID: <202112300828.wqqaIPJ3-lkp@intel.com>
References: <20211229223139.708975-3-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211229223139.708975-3-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

I love your patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/0day-ci/linux/commits/Jakub-Kicinski/lighten-uapi-bpf-h-rebuilds/20211230-063309
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: x86_64-randconfig-a002-20211230 (https://download.01.org/0day-ci/archive/20211230/202112300828.wqqaIPJ3-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project cd284b7ac0615afc6e0f1a30da2777e361de27a3)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/df4183ffb29b84cb3cfb6ac82457f151e6fa2a28
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jakub-Kicinski/lighten-uapi-bpf-h-rebuilds/20211230-063309
        git checkout df4183ffb29b84cb3cfb6ac82457f151e6fa2a28
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash net/ipv6/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   In file included from net/ipv6/anycast.c:39:
   In file included from include/net/ip6_route.h:24:
>> include/net/ip6_fib.h:548:2: error: type name requires a specifier or qualifier
           __bpf_md_ptr(struct bpf_iter_meta *, meta);
           ^
>> include/net/ip6_fib.h:548:22: warning: declaration of 'struct bpf_iter_meta' will not be visible outside of this function [-Wvisibility]
           __bpf_md_ptr(struct bpf_iter_meta *, meta);
                               ^
>> include/net/ip6_fib.h:548:39: warning: declaration specifier missing, defaulting to 'int'
           __bpf_md_ptr(struct bpf_iter_meta *, meta);
                                                ^
                                                int
   include/net/ip6_fib.h:549:2: error: type name requires a specifier or qualifier
           __bpf_md_ptr(struct fib6_info *, rt);
           ^
   include/net/ip6_fib.h:549:35: warning: declaration specifier missing, defaulting to 'int'
           __bpf_md_ptr(struct fib6_info *, rt);
                                            ^
                                            int
>> include/net/ip6_fib.h:549:2: error: duplicate member '__bpf_md_ptr'
           __bpf_md_ptr(struct fib6_info *, rt);
           ^
   include/net/ip6_fib.h:548:2: note: previous declaration is here
           __bpf_md_ptr(struct bpf_iter_meta *, meta);
           ^
   3 warnings and 3 errors generated.
--
   In file included from net/ipv6/route.c:48:
>> include/net/ip6_fib.h:548:2: error: type name requires a specifier or qualifier
           __bpf_md_ptr(struct bpf_iter_meta *, meta);
           ^
>> include/net/ip6_fib.h:548:22: warning: declaration of 'struct bpf_iter_meta' will not be visible outside of this function [-Wvisibility]
           __bpf_md_ptr(struct bpf_iter_meta *, meta);
                               ^
>> include/net/ip6_fib.h:548:39: warning: declaration specifier missing, defaulting to 'int'
           __bpf_md_ptr(struct bpf_iter_meta *, meta);
                                                ^
                                                int
   include/net/ip6_fib.h:549:2: error: type name requires a specifier or qualifier
           __bpf_md_ptr(struct fib6_info *, rt);
           ^
   include/net/ip6_fib.h:549:35: warning: declaration specifier missing, defaulting to 'int'
           __bpf_md_ptr(struct fib6_info *, rt);
                                            ^
                                            int
>> include/net/ip6_fib.h:549:2: error: duplicate member '__bpf_md_ptr'
           __bpf_md_ptr(struct fib6_info *, rt);
           ^
   include/net/ip6_fib.h:548:2: note: previous declaration is here
           __bpf_md_ptr(struct bpf_iter_meta *, meta);
           ^
>> net/ipv6/route.c:6612:5: error: no member named 'rt' in 'bpf_iter__ipv6_route'
                   { offsetof(struct bpf_iter__ipv6_route, rt),
                     ^                                     ~~
   include/linux/stddef.h:17:32: note: expanded from macro 'offsetof'
   #define offsetof(TYPE, MEMBER)  __compiler_offsetof(TYPE, MEMBER)
                                   ^                         ~~~~~~
   include/linux/compiler_types.h:140:35: note: expanded from macro '__compiler_offsetof'
   #define __compiler_offsetof(a, b)       __builtin_offsetof(a, b)
                                           ^                     ~
   3 warnings and 4 errors generated.
--
   In file included from net/ipv6/netfilter/nf_reject_ipv6.c:8:
   In file included from include/net/ip6_route.h:24:
>> include/net/ip6_fib.h:548:2: error: type name requires a specifier or qualifier
           __bpf_md_ptr(struct bpf_iter_meta *, meta);
           ^
>> include/net/ip6_fib.h:548:22: warning: declaration of 'struct bpf_iter_meta' will not be visible outside of this function [-Wvisibility]
           __bpf_md_ptr(struct bpf_iter_meta *, meta);
                               ^
>> include/net/ip6_fib.h:548:39: warning: declaration specifier missing, defaulting to 'int'
           __bpf_md_ptr(struct bpf_iter_meta *, meta);
                                                ^
                                                int
   include/net/ip6_fib.h:549:2: error: type name requires a specifier or qualifier
           __bpf_md_ptr(struct fib6_info *, rt);
           ^
   include/net/ip6_fib.h:549:35: warning: declaration specifier missing, defaulting to 'int'
           __bpf_md_ptr(struct fib6_info *, rt);
                                            ^
                                            int
>> include/net/ip6_fib.h:549:2: error: duplicate member '__bpf_md_ptr'
           __bpf_md_ptr(struct fib6_info *, rt);
           ^
   include/net/ip6_fib.h:548:2: note: previous declaration is here
           __bpf_md_ptr(struct bpf_iter_meta *, meta);
           ^
   net/ipv6/netfilter/nf_reject_ipv6.c:287:18: warning: variable 'ip6h' set but not used [-Wunused-but-set-variable]
           struct ipv6hdr *ip6h;
                           ^
   4 warnings and 3 errors generated.


vim +548 include/net/ip6_fib.h

180ca444b985c4 Wei Wang      2017-10-06  537  
8d1c802b2815ed David Ahern   2018-04-17  538  void fib6_metric_set(struct fib6_info *f6i, int metric, u32 val);
8d1c802b2815ed David Ahern   2018-04-17  539  static inline bool fib6_metric_locked(struct fib6_info *f6i, int metric)
d4ead6b34b67fd David Ahern   2018-04-17  540  {
d4ead6b34b67fd David Ahern   2018-04-17  541  	return !!(f6i->fib6_metrics->metrics[RTAX_LOCK - 1] & (1 << metric));
d4ead6b34b67fd David Ahern   2018-04-17  542  }
907eea486888cf Amit Cohen    2021-02-01  543  void fib6_info_hw_flags_set(struct net *net, struct fib6_info *f6i,
0c5fcf9e249ee1 Amit Cohen    2021-02-07  544  			    bool offload, bool trap, bool offload_failed);
180ca444b985c4 Wei Wang      2017-10-06  545  
3c32cc1bceba8a Yonghong Song 2020-05-13  546  #if IS_BUILTIN(CONFIG_IPV6) && defined(CONFIG_BPF_SYSCALL)
3c32cc1bceba8a Yonghong Song 2020-05-13  547  struct bpf_iter__ipv6_route {
3c32cc1bceba8a Yonghong Song 2020-05-13 @548  	__bpf_md_ptr(struct bpf_iter_meta *, meta);
3c32cc1bceba8a Yonghong Song 2020-05-13 @549  	__bpf_md_ptr(struct fib6_info *, rt);
3c32cc1bceba8a Yonghong Song 2020-05-13  550  };
3c32cc1bceba8a Yonghong Song 2020-05-13  551  #endif
3c32cc1bceba8a Yonghong Song 2020-05-13  552  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

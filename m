Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413224817EF
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 01:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbhL3Ar2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 19:47:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:1590 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233486AbhL3Ar2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 19:47:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640825248; x=1672361248;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IhOnjEemiak5dLYADtUqYRKLqx+wIMf26glnGWonR6k=;
  b=UR93S7Hs8MNcYxANeOs+Xhg95wEyMoo6HLboauBHVD44NhbTCAFb7zLv
   rwu0HXY+vefRj1cv77Cu3Q0yrmtBOlhFBevuBH/1iyVhOCDHVAUFJ7Yz5
   gpHkxFfgH4XyRMRJCjpezEC2r7QsFcB6GA86cheuunuxWBSd4SB4diZKt
   8O7r2ueRqHJhv6rVvOqSA8GrIzE0XvzwRG/q28i9Y4Alma09mozVABHzj
   tgb8IIp5FevRNMIFOb9qo0ynacbNUCrCICJbhP/C82w/impnihYWe06/8
   mFy4XYrkzYv5d/qCNFy1Mv37vfyHHsYRcXgGUqFqmtEl9ey2QrU3aQokx
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10212"; a="241395111"
X-IronPort-AV: E=Sophos;i="5.88,246,1635231600"; 
   d="scan'208";a="241395111"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2021 16:47:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,246,1635231600"; 
   d="scan'208";a="619223975"
Received: from lkp-server01.sh.intel.com (HELO e357b3ef1427) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 29 Dec 2021 16:47:25 -0800
Received: from kbuild by e357b3ef1427 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n2jbI-0009WO-SD; Thu, 30 Dec 2021 00:47:24 +0000
Date:   Thu, 30 Dec 2021 08:46:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH bpf-next 2/2] bpf: invert the dependency between
 bpf-netns.h and netns/bpf.h
Message-ID: <202112300831.1tdh6vYJ-lkp@intel.com>
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
config: arm-randconfig-r025-20211230 (https://download.01.org/0day-ci/archive/20211230/202112300831.1tdh6vYJ-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project cd284b7ac0615afc6e0f1a30da2777e361de27a3)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        # https://github.com/0day-ci/linux/commit/df4183ffb29b84cb3cfb6ac82457f151e6fa2a28
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jakub-Kicinski/lighten-uapi-bpf-h-rebuilds/20211230-063309
        git checkout df4183ffb29b84cb3cfb6ac82457f151e6fa2a28
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash net/ipv6/netfilter/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

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
--
   In file included from net/ipv6/netfilter/nf_dup_ipv6.c:13:
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

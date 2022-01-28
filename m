Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846074A0346
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 23:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344561AbiA1WGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 17:06:22 -0500
Received: from mga17.intel.com ([192.55.52.151]:41251 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229608AbiA1WGV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 17:06:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643407581; x=1674943581;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=t24vwgVtLBEZI6DLnLJFgIhaUz97/DCwP4/ZWj3byU0=;
  b=HRxW5BWiGeY0fJWxpELIjQt6eEOchkIfG6HPDkNrTrzs+Is/IZ7Kk8oB
   ijQHa+86LTnjgiquGEvTHUte4cVuYcN5oNw6Cs5XVuNGr6pf/PWadRj30
   hIMTOYhYMtPTGyNs8e94dMF5irrQpyNMGBJoMRsOpwDsPMBdgv6PuTvYR
   52SDBasczRm8+x9mzSWTWMtcG+Gqmm8EWHUEWwL/ZMCkkUtUTDHGg3Kev
   4ul7ECxyznHCrBUtsmfLPaY0+AWjf4yVO01A3NEl3dd2IaS7sCARPYuIg
   zw+/udbM1NPuIwRV9XdYLAcWtJKvEaJJG+qk8texUpuzWpohumO/LeuLo
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10241"; a="227874509"
X-IronPort-AV: E=Sophos;i="5.88,325,1635231600"; 
   d="scan'208";a="227874509"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2022 14:06:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,325,1635231600"; 
   d="scan'208";a="770232931"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 28 Jan 2022 14:06:04 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nDZNb-000ONu-RA; Fri, 28 Jan 2022 22:06:03 +0000
Date:   Sat, 29 Jan 2022 06:05:19 +0800
From:   kernel test robot <lkp@intel.com>
To:     Akhmat Karakotov <hmukos@yandex-team.ru>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, eric.dumazet@gmail.com, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        tom@herbertland.com
Subject: Re: [PATCH net-next v4 2/5] txhash: Add socket option to control TX
 hash rethink behavior
Message-ID: <202201290514.oladOq5e-lkp@intel.com>
References: <20220128194408.17742-3-hmukos@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128194408.17742-3-hmukos@yandex-team.ru>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Akhmat,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Akhmat-Karakotov/Make-hash-rethink-configurable/20220129-034621
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git b76bbb34dc80258f5079b4067f0dae07b394b8fe
config: nds32-allnoconfig (https://download.01.org/0day-ci/archive/20220129/202201290514.oladOq5e-lkp@intel.com/config)
compiler: nds32le-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/92d1267cbe457eff1ea65aa32f38356861bfa5f5
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Akhmat-Karakotov/Make-hash-rethink-configurable/20220129-034621
        git checkout 92d1267cbe457eff1ea65aa32f38356861bfa5f5
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=nds32 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/tcp.h:19,
                    from include/linux/ipv6.h:92,
                    from include/net/ipv6.h:12,
                    from include/linux/sunrpc/clnt.h:29,
                    from include/linux/nfs_fs.h:32,
                    from init/do_mounts.c:23:
   include/net/sock.h: In function 'sk_rethink_txhash':
>> include/net/sock.h:2071:34: error: 'struct sock' has no member named 'sk_txrehash'; did you mean 'sk_txhash'?
    2071 |         if (sk->sk_txhash && sk->sk_txrehash == SOCK_TXREHASH_ENABLED) {
         |                                  ^~~~~~~~~~~
         |                                  sk_txhash
--
   In file included from fs/io_uring.c:63:
   include/net/sock.h: In function 'sk_rethink_txhash':
>> include/net/sock.h:2071:34: error: 'struct sock' has no member named 'sk_txrehash'; did you mean 'sk_txhash'?
    2071 |         if (sk->sk_txhash && sk->sk_txrehash == SOCK_TXREHASH_ENABLED) {
         |                                  ^~~~~~~~~~~
         |                                  sk_txhash
   fs/io_uring.c: In function '__io_submit_flush_completions':
   fs/io_uring.c:2523:40: warning: variable 'prev' set but not used [-Wunused-but-set-variable]
    2523 |         struct io_wq_work_node *node, *prev;
         |                                        ^~~~
--
   In file included from include/linux/tcp.h:19,
                    from include/linux/ipv6.h:92,
                    from include/net/addrconf.h:52,
                    from lib/vsprintf.c:40:
   include/net/sock.h: In function 'sk_rethink_txhash':
>> include/net/sock.h:2071:34: error: 'struct sock' has no member named 'sk_txrehash'; did you mean 'sk_txhash'?
    2071 |         if (sk->sk_txhash && sk->sk_txrehash == SOCK_TXREHASH_ENABLED) {
         |                                  ^~~~~~~~~~~
         |                                  sk_txhash
   lib/vsprintf.c: In function 'va_format':
   lib/vsprintf.c:1684:9: warning: function 'va_format' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
    1684 |         buf += vsnprintf(buf, end > buf ? end - buf : 0, va_fmt->fmt, va);
         |         ^~~


vim +2071 include/net/sock.h

  2068	
  2069	static inline bool sk_rethink_txhash(struct sock *sk)
  2070	{
> 2071		if (sk->sk_txhash && sk->sk_txrehash == SOCK_TXREHASH_ENABLED) {
  2072			sk_set_txhash(sk);
  2073			return true;
  2074		}
  2075		return false;
  2076	}
  2077	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

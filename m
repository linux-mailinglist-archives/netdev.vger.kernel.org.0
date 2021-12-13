Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEAA7473658
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 22:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238674AbhLMVE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 16:04:58 -0500
Received: from mga07.intel.com ([134.134.136.100]:38344 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233931AbhLMVE6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 16:04:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639429498; x=1670965498;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=THcQiUiV4UwwBCtowU+WfkOlBtQsdm0RKlLSpEz32jo=;
  b=fAwwQmtD1f1CdzDy9BEkpM9kLdM9Q/1CF97kIigqdUhDoO/G15Y9Xkr5
   +e+6qLnGOy9GTqAEC0W9d6HxxzWfWedFEz/Ft8doFluagckj2hDsbL1E3
   +JkSBWUh9KPKs2FPQI2bbCTwVEdg6ZCHW/PDYyAsWHKg7uLUz9rt/IG8Z
   V059QkebgQoawrE9EFPscb7dMHoKyOE+9aZ1VX/WXrSNo58OIPm5kceMl
   4tDps7KABw3BFzuhVR1Fpt9kwkgLrtuuM0Ol2pQVoTpgCH5N3kQwVPh5t
   ytuEi3lpou+UGEpXHi7oVoGRcU85cC+oDrk+f6yQ2kQAie+AriKfSSpoJ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="302210415"
X-IronPort-AV: E=Sophos;i="5.88,203,1635231600"; 
   d="scan'208";a="302210415"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 13:04:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,203,1635231600"; 
   d="scan'208";a="544917650"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 13 Dec 2021 13:04:56 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mwsVD-00073s-Kc; Mon, 13 Dec 2021 21:04:55 +0000
Date:   Tue, 14 Dec 2021 05:03:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net-next 1/4] fib: remove suppress indirection
Message-ID: <202112140516.lS6zCrEh-lkp@intel.com>
References: <20211213153147.17635-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213153147.17635-2-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Florian-Westphal/fib-remove-suppress-indirection-merge-nl-policies/20211213-233429
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 97884b07122aabb2d6891ce17f54e0e8e94d0bc5
config: i386-randconfig-a015-20211213 (https://download.01.org/0day-ci/archive/20211214/202112140516.lS6zCrEh-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/585507534b121a41b45edaec79fe6c3d94a50b5f
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Florian-Westphal/fib-remove-suppress-indirection-merge-nl-policies/20211213-233429
        git checkout 585507534b121a41b45edaec79fe6c3d94a50b5f
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/core/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/core/fib_rules.c: In function 'fib4_rule_suppress':
   net/core/fib_rules.c:300:31: error: implicit declaration of function 'fib_info_nhc'; did you mean 'fib_info_put'? [-Werror=implicit-function-declaration]
     300 |   struct fib_nh_common *nhc = fib_info_nhc(result->fi, 0);
         |                               ^~~~~~~~~~~~
         |                               fib_info_put
>> net/core/fib_rules.c:300:31: warning: initialization of 'struct fib_nh_common *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
   net/core/fib_rules.c: In function 'fib6_rule_suppress':
   net/core/fib_rules.c:330:27: error: dereferencing pointer to incomplete type 'struct fib6_result'
     330 |  struct rt6_info *rt = res->rt6;
         |                           ^~
   net/core/fib_rules.c:336:8: error: dereferencing pointer to incomplete type 'struct rt6_info'
     336 |  if (rt->rt6i_idev)
         |        ^~
   net/core/fib_rules.c:354:2: error: implicit declaration of function 'ip6_rt_put_flags' [-Werror=implicit-function-declaration]
     354 |  ip6_rt_put_flags(rt, flags);
         |  ^~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +300 net/core/fib_rules.c

   291	
   292	static bool fib4_rule_suppress(struct fib_rule *rule,
   293				       int flags,
   294				       struct fib_lookup_arg *arg)
   295	{
   296		struct fib_result *result = (struct fib_result *)arg->result;
   297		struct net_device *dev = NULL;
   298	
   299		if (result->fi) {
 > 300			struct fib_nh_common *nhc = fib_info_nhc(result->fi, 0);
   301	
   302			dev = nhc->nhc_dev;
   303		}
   304	
   305		/* do not accept result if the route does
   306		 * not meet the required prefix length
   307		 */
   308		if (result->prefixlen <= rule->suppress_prefixlen)
   309			goto suppress_route;
   310	
   311		/* do not accept result if the route uses a device
   312		 * belonging to a forbidden interface group
   313		 */
   314		if (rule->suppress_ifgroup != -1 && dev && dev->group == rule->suppress_ifgroup)
   315			goto suppress_route;
   316	
   317		return false;
   318	
   319	suppress_route:
   320		if (!(arg->flags & FIB_LOOKUP_NOREF))
   321			fib_info_put(result->fi);
   322		return true;
   323	}
   324	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7439F473626
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 21:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242356AbhLMUj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 15:39:58 -0500
Received: from mga06.intel.com ([134.134.136.31]:47728 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242303AbhLMUj6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 15:39:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639427998; x=1670963998;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fDWIlcry4ypNPsbHlT3uMh+3D5ug6LzsG+vP/SCx3pk=;
  b=WSDJIr5X+ygtPh6csMOa/XUeYy1lwWSU69mNVxxIGAKc0bLJW9ADz4mT
   kbyCHn23vwZsLeGq63Uw5BAYHp/avOToB+ZOxtyPdk3BHJ/mP9rwl/GEp
   9jRtezgw2TaHe6XhE0R3vMO55kPvxOGOUUIGJYgNoj5pu1WQV5t3h215m
   O9VtjkTp9pmWbMb1xYKSKQPK/R1G1oT072xHptxZUtaeeYKzZuH8tVM4m
   CoN8vfcYeC35zXICYp5NPmLOkndxb7hvTCqV64IfZv/psmXE0IfJRq0Ub
   QykgpAeRLvrXg52DuZ5u6N2TyhGBrE30Io97zf4QWhfFWNvQFObd2G21M
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="299607069"
X-IronPort-AV: E=Sophos;i="5.88,203,1635231600"; 
   d="scan'208";a="299607069"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 12:39:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,203,1635231600"; 
   d="scan'208";a="505063903"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 13 Dec 2021 12:39:55 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mws71-00072q-8m; Mon, 13 Dec 2021 20:39:55 +0000
Date:   Tue, 14 Dec 2021 04:39:14 +0800
From:   kernel test robot <lkp@intel.com>
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, davem@davemloft.net,
        kuba@kernel.org, dsahern@kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net-next 1/4] fib: remove suppress indirection
Message-ID: <202112140418.ghGEE99T-lkp@intel.com>
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
config: i386-randconfig-a001-20211213 (https://download.01.org/0day-ci/archive/20211214/202112140418.ghGEE99T-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project b6a2ddb6c8ac29412b1361810972e15221fa021c)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/585507534b121a41b45edaec79fe6c3d94a50b5f
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Florian-Westphal/fib-remove-suppress-indirection-merge-nl-policies/20211213-233429
        git checkout 585507534b121a41b45edaec79fe6c3d94a50b5f
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/core/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/core/fib_rules.c:300:31: error: implicit declaration of function 'fib_info_nhc' [-Werror,-Wimplicit-function-declaration]
                   struct fib_nh_common *nhc = fib_info_nhc(result->fi, 0);
                                               ^
   net/core/fib_rules.c:300:31: note: did you mean 'fib_info_put'?
   include/net/ip_fib.h:574:20: note: 'fib_info_put' declared here
   static inline void fib_info_put(struct fib_info *fi)
                      ^
>> net/core/fib_rules.c:300:25: warning: incompatible integer to pointer conversion initializing 'struct fib_nh_common *' with an expression of type 'int' [-Wint-conversion]
                   struct fib_nh_common *nhc = fib_info_nhc(result->fi, 0);
                                         ^     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/core/fib_rules.c:330:27: error: incomplete definition of type 'struct fib6_result'
           struct rt6_info *rt = res->rt6;
                                 ~~~^
   include/net/ipv6_stubs.h:17:8: note: forward declaration of 'struct fib6_result'
   struct fib6_result;
          ^
   net/core/fib_rules.c:336:8: error: incomplete definition of type 'struct rt6_info'
           if (rt->rt6i_idev)
               ~~^
   include/net/netns/ipv6.h:70:9: note: forward declaration of 'struct rt6_info'
           struct rt6_info         *ip6_null_entry;
                  ^
   net/core/fib_rules.c:337:11: error: incomplete definition of type 'struct rt6_info'
                   dev = rt->rt6i_idev->dev;
                         ~~^
   include/net/netns/ipv6.h:70:9: note: forward declaration of 'struct rt6_info'
           struct rt6_info         *ip6_null_entry;
                  ^
   net/core/fib_rules.c:342:8: error: incomplete definition of type 'struct rt6_info'
           if (rt->rt6i_dst.plen <= rule->suppress_prefixlen)
               ~~^
   include/net/netns/ipv6.h:70:9: note: forward declaration of 'struct rt6_info'
           struct rt6_info         *ip6_null_entry;
                  ^
   net/core/fib_rules.c:354:2: error: implicit declaration of function 'ip6_rt_put_flags' [-Werror,-Wimplicit-function-declaration]
           ip6_rt_put_flags(rt, flags);
           ^
   1 warning and 6 errors generated.


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

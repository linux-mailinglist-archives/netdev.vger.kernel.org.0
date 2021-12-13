Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659FE473671
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 22:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243086AbhLMVO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 16:14:59 -0500
Received: from mga03.intel.com ([134.134.136.65]:11306 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237803AbhLMVO6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 16:14:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639430098; x=1670966098;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ptKqL7oMgKhL4X4s748LcMcghUog4TnfCfHyu4EXUfA=;
  b=GjfLvhCBSSo8x6yer+oqf29dYLp/9XAUN7i5956HZoQP9P9KB7atgbvx
   EYYqMIfqH86fb/j4r3FlHRwIWW1Tq8xmHDG7VjMWZdZcwmZ+Fs5f/rdjF
   sCKqdHv+xY0em5dIiFfHe0yBKoIfU8qcFiQCpm3n3WPP6RdSgSE9GT4ft
   fPETD5O3qKQlBc3F5iRVvCASGNL0bGyvdOSqffMSV3UeWQGSKXOfBjhBd
   MP4R8ffzbjockxmEQRU9Zofgv4kbxGO82xpCHLuhdpmW/wYO1L500ces2
   y/1HxYgF4BzmMfv/GLAYLMvF93e/vRAPE7cQXblQfO8pOfQ2tsUfbcZxm
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="238777631"
X-IronPort-AV: E=Sophos;i="5.88,203,1635231600"; 
   d="scan'208";a="238777631"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 13:14:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,203,1635231600"; 
   d="scan'208";a="481659770"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 13 Dec 2021 13:14:56 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mwset-00074N-Pn; Mon, 13 Dec 2021 21:14:55 +0000
Date:   Tue, 14 Dec 2021 05:14:16 +0800
From:   kernel test robot <lkp@intel.com>
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, davem@davemloft.net,
        kuba@kernel.org, dsahern@kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net-next 1/4] fib: remove suppress indirection
Message-ID: <202112140528.DqSB8cFq-lkp@intel.com>
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

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Florian-Westphal/fib-remove-suppress-indirection-merge-nl-policies/20211213-233429
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 97884b07122aabb2d6891ce17f54e0e8e94d0bc5
config: hexagon-randconfig-r041-20211213 (https://download.01.org/0day-ci/archive/20211214/202112140528.DqSB8cFq-lkp@intel.com/config)
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
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash net/core/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

>> net/core/fib_rules.c:300:31: error: implicit declaration of function 'fib_info_nhc' [-Werror,-Wimplicit-function-declaration]
                   struct fib_nh_common *nhc = fib_info_nhc(result->fi, 0);
                                               ^
   net/core/fib_rules.c:300:31: note: did you mean 'fib_info_put'?
   include/net/ip_fib.h:574:20: note: 'fib_info_put' declared here
   static inline void fib_info_put(struct fib_info *fi)
                      ^
>> net/core/fib_rules.c:300:25: warning: incompatible integer to pointer conversion initializing 'struct fib_nh_common *' with an expression of type 'int' [-Wint-conversion]
                   struct fib_nh_common *nhc = fib_info_nhc(result->fi, 0);
                                         ^     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> net/core/fib_rules.c:330:27: error: incomplete definition of type 'struct fib6_result'
           struct rt6_info *rt = res->rt6;
                                 ~~~^
   include/net/ipv6_stubs.h:17:8: note: forward declaration of 'struct fib6_result'
   struct fib6_result;
          ^
>> net/core/fib_rules.c:336:8: error: incomplete definition of type 'struct rt6_info'
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
>> net/core/fib_rules.c:354:2: error: implicit declaration of function 'ip6_rt_put_flags' [-Werror,-Wimplicit-function-declaration]
           ip6_rt_put_flags(rt, flags);
           ^
   1 warning and 6 errors generated.


vim +/fib_info_nhc +300 net/core/fib_rules.c

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
   325	static bool fib6_rule_suppress(struct fib_rule *rule,
   326				       int flags,
   327				       struct fib_lookup_arg *arg)
   328	{
   329		struct fib6_result *res = arg->result;
 > 330		struct rt6_info *rt = res->rt6;
   331		struct net_device *dev = NULL;
   332	
   333		if (!rt)
   334			return false;
   335	
 > 336		if (rt->rt6i_idev)
   337			dev = rt->rt6i_idev->dev;
   338	
   339		/* do not accept result if the route does
   340		 * not meet the required prefix length
   341		 */
   342		if (rt->rt6i_dst.plen <= rule->suppress_prefixlen)
   343			goto suppress_route;
   344	
   345		/* do not accept result if the route uses a device
   346		 * belonging to a forbidden interface group
   347		 */
   348		if (rule->suppress_ifgroup != -1 && dev && dev->group == rule->suppress_ifgroup)
   349			goto suppress_route;
   350	
   351		return false;
   352	
   353	suppress_route:
 > 354		ip6_rt_put_flags(rt, flags);
   355		return true;
   356	}
   357	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

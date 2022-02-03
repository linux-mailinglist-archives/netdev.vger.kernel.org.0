Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C4F4A7ED3
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 06:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbiBCFDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 00:03:04 -0500
Received: from mga17.intel.com ([192.55.52.151]:9341 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234084AbiBCFCx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 00:02:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643864573; x=1675400573;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QBfdj7tYzksi+0VE/7A42i+ZwHjEqKj3LFuh0F1qJHc=;
  b=CH0uQF3zK8+f6a3Zxyyi+SiWddUa9zsE+cFRVoz4qgvi4G12dvUc5QcA
   lORjJA2+s391JtUQFOJdYQO8+idcqEe2z0HblrnKKydTewmnoasDsJhTE
   uln8GLFQuZ0HZYb+6atXIdgNV5GEGhXedQF0Tyj+u7Dt5VXZkEELAE6U1
   K62+612jGZz3SnVtdeyFYEfe6Q7QSG5ZyewlIQBDZ250n2RgYg8lMG8bY
   U74QlBBBSYHk9DR32RST7m0gtVUtStOFKbT7ZKtXSjqC3xmAxcYYU8Ce2
   PPkr6lwaN+/aK8PVdYLAB2fCaChQyp4DgB3UtUZiK3AiJQwhUk+q1r8Py
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="228729932"
X-IronPort-AV: E=Sophos;i="5.88,339,1635231600"; 
   d="scan'208";a="228729932"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 21:02:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,339,1635231600"; 
   d="scan'208";a="599806074"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 02 Feb 2022 21:02:49 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nFUGc-000Vbv-Ca; Thu, 03 Feb 2022 05:02:46 +0000
Date:   Thu, 3 Feb 2022 13:02:26 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kbuild-all@lists.01.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>
Subject: Re: [PATCH net-next 09/15] net: increase MAX_SKB_FRAGS
Message-ID: <202202031206.1nNLT568-lkp@intel.com>
References: <20220203015140.3022854-10-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220203015140.3022854-10-eric.dumazet@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Eric-Dumazet/tcp-BIG-TCP-implementation/20220203-095336
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 52dae93f3bad842c6d585700460a0dea4d70e096
config: arc-randconfig-r043-20220130 (https://download.01.org/0day-ci/archive/20220203/202202031206.1nNLT568-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/64ec6b0260be94b2ed90ee6d139591bdbd49c82d
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Eric-Dumazet/tcp-BIG-TCP-implementation/20220203-095336
        git checkout 64ec6b0260be94b2ed90ee6d139591bdbd49c82d
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arc SHELL=/bin/bash kernel/bpf/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/container_of.h:5,
                    from include/linux/list.h:5,
                    from include/linux/rculist.h:10,
                    from include/linux/pid.h:5,
                    from include/linux/sched.h:14,
                    from include/linux/ptrace.h:6,
                    from include/uapi/asm-generic/bpf_perf_event.h:4,
                    from ./arch/arc/include/generated/uapi/asm/bpf_perf_event.h:1,
                    from include/uapi/linux/bpf_perf_event.h:11,
                    from kernel/bpf/btf.c:6:
>> include/linux/build_bug.h:78:41: error: static assertion failed: "BITS_PER_LONG >= NR_MSG_FRAG_IDS"
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                         ^~~~~~~~~~~~~~
   include/linux/build_bug.h:77:34: note: in expansion of macro '__static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/skmsg.h:41:1: note: in expansion of macro 'static_assert'
      41 | static_assert(BITS_PER_LONG >= NR_MSG_FRAG_IDS);
         | ^~~~~~~~~~~~~
   kernel/bpf/btf.c: In function 'btf_seq_show':
   kernel/bpf/btf.c:6049:29: warning: function 'btf_seq_show' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
    6049 |         seq_vprintf((struct seq_file *)show->target, fmt, args);
         |                             ^~~~~~~~
   kernel/bpf/btf.c: In function 'btf_snprintf_show':
   kernel/bpf/btf.c:6086:9: warning: function 'btf_snprintf_show' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
    6086 |         len = vsnprintf(show->target, ssnprintf->len_left, fmt, args);
         |         ^~~


vim +78 include/linux/build_bug.h

bc6245e5efd70c4 Ian Abbott       2017-07-10  60  
6bab69c65013bed Rasmus Villemoes 2019-03-07  61  /**
6bab69c65013bed Rasmus Villemoes 2019-03-07  62   * static_assert - check integer constant expression at build time
6bab69c65013bed Rasmus Villemoes 2019-03-07  63   *
6bab69c65013bed Rasmus Villemoes 2019-03-07  64   * static_assert() is a wrapper for the C11 _Static_assert, with a
6bab69c65013bed Rasmus Villemoes 2019-03-07  65   * little macro magic to make the message optional (defaulting to the
6bab69c65013bed Rasmus Villemoes 2019-03-07  66   * stringification of the tested expression).
6bab69c65013bed Rasmus Villemoes 2019-03-07  67   *
6bab69c65013bed Rasmus Villemoes 2019-03-07  68   * Contrary to BUILD_BUG_ON(), static_assert() can be used at global
6bab69c65013bed Rasmus Villemoes 2019-03-07  69   * scope, but requires the expression to be an integer constant
6bab69c65013bed Rasmus Villemoes 2019-03-07  70   * expression (i.e., it is not enough that __builtin_constant_p() is
6bab69c65013bed Rasmus Villemoes 2019-03-07  71   * true for expr).
6bab69c65013bed Rasmus Villemoes 2019-03-07  72   *
6bab69c65013bed Rasmus Villemoes 2019-03-07  73   * Also note that BUILD_BUG_ON() fails the build if the condition is
6bab69c65013bed Rasmus Villemoes 2019-03-07  74   * true, while static_assert() fails the build if the expression is
6bab69c65013bed Rasmus Villemoes 2019-03-07  75   * false.
6bab69c65013bed Rasmus Villemoes 2019-03-07  76   */
6bab69c65013bed Rasmus Villemoes 2019-03-07  77  #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
6bab69c65013bed Rasmus Villemoes 2019-03-07 @78  #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
6bab69c65013bed Rasmus Villemoes 2019-03-07  79  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

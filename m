Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9143C21E7AD
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 07:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgGNFnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 01:43:20 -0400
Received: from mga12.intel.com ([192.55.52.136]:26281 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgGNFnT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 01:43:19 -0400
IronPort-SDR: Qjh+rzaxGarn9sJ7UmRfL48G79OheM7Ks3PkgpA2GctIczVcHcWFEqRHckdAmlPsSAIaWFScOH
 6a92WtBV3PGw==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="128373973"
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="gz'50?scan'50,208,50";a="128373973"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 22:43:14 -0700
IronPort-SDR: sS8pO+953IlkXTkpiXPVDUijpUpdiZMOm8i7uX4qmvUyIqE20LgUVFuudA53DVh/0upIxzwbSk
 U/emk3rMN5jA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="gz'50?scan'50,208,50";a="360277932"
Received: from lkp-server02.sh.intel.com (HELO fb03a464a2e3) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 13 Jul 2020 22:43:10 -0700
Received: from kbuild by fb03a464a2e3 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1jvDif-00016j-VJ; Tue, 14 Jul 2020 05:43:09 +0000
Date:   Tue, 14 Jul 2020 13:42:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net,
        dsahern@gmail.com
Cc:     kbuild-all@lists.01.org, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, Andrii Nakryiko <andriin@fb.com>,
        Andrey Ignatov <rdna@fb.com>,
        Takshak Chahande <ctakshak@fb.com>
Subject: Re: [PATCH v2 bpf-next 4/8] bpf, xdp: implement LINK_UPDATE for BPF
 XDP link
Message-ID: <202007141318.38Z75aHy%lkp@intel.com>
References: <20200714040643.1135876-5-andriin@fb.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <20200714040643.1135876-5-andriin@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andrii,

I love your patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/0day-ci/linux/commits/Andrii-Nakryiko/BPF-XDP-link/20200714-120909
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: parisc-defconfig (attached as .config)
compiler: hppa-linux-gcc (GCC) 9.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=parisc 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/core/dev.c:8717:18: error: field 'link' has incomplete type
    8717 |  struct bpf_link link;
         |                  ^~~~
   In file included from include/linux/instrumented.h:10,
                    from include/linux/uaccess.h:5,
                    from net/core/dev.c:71:
   net/core/dev.c: In function 'bpf_xdp_link_release':
   include/linux/kernel.h:1003:32: error: dereferencing pointer to incomplete type 'struct bpf_link'
    1003 |  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
         |                                ^~~~~~
   include/linux/compiler.h:372:9: note: in definition of macro '__compiletime_assert'
     372 |   if (!(condition))     \
         |         ^~~~~~~~~
   include/linux/compiler.h:392:2: note: in expansion of macro '_compiletime_assert'
     392 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |  ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/kernel.h:1003:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
    1003 |  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
         |  ^~~~~~~~~~~~~~~~
   include/linux/kernel.h:1003:20: note: in expansion of macro '__same_type'
    1003 |  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
         |                    ^~~~~~~~~~~
   net/core/dev.c:8972:34: note: in expansion of macro 'container_of'
    8972 |  struct bpf_xdp_link *xdp_link = container_of(link, struct bpf_xdp_link, link);
         |                                  ^~~~~~~~~~~~
   In file included from arch/parisc/include/asm/atomic.h:10,
                    from include/linux/atomic.h:7,
                    from arch/parisc/include/asm/bitops.h:13,
                    from include/linux/bitops.h:29,
                    from include/linux/kernel.h:12,
                    from arch/parisc/include/asm/bug.h:5,
                    from include/linux/bug.h:5,
                    from include/linux/thread_info.h:12,
                    from include/asm-generic/current.h:5,
                    from ./arch/parisc/include/generated/asm/current.h:1,
                    from include/linux/sched.h:12,
                    from include/linux/uaccess.h:6,
                    from net/core/dev.c:71:
   net/core/dev.c: In function 'bpf_xdp_link_update':
>> arch/parisc/include/asm/cmpxchg.h:50:27: warning: initialization of 'int' from 'struct bpf_prog *' makes integer from pointer without a cast [-Wint-conversion]
      50 |  __typeof__(*(ptr)) _x_ = (x);     \
         |                           ^
   net/core/dev.c:9026:13: note: in expansion of macro 'xchg'
    9026 |  old_prog = xchg(&link->prog, new_prog);
         |             ^~~~
   net/core/dev.c:9026:11: warning: assignment to 'struct bpf_prog *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
    9026 |  old_prog = xchg(&link->prog, new_prog);
         |           ^
   net/core/dev.c: At top level:
   net/core/dev.c:9034:21: error: variable 'bpf_xdp_link_lops' has initializer but incomplete type
    9034 | static const struct bpf_link_ops bpf_xdp_link_lops = {
         |                     ^~~~~~~~~~~~
   net/core/dev.c:9035:3: error: 'const struct bpf_link_ops' has no member named 'release'
    9035 |  .release = bpf_xdp_link_release,
         |   ^~~~~~~
   net/core/dev.c:9035:13: warning: excess elements in struct initializer
    9035 |  .release = bpf_xdp_link_release,
         |             ^~~~~~~~~~~~~~~~~~~~
   net/core/dev.c:9035:13: note: (near initialization for 'bpf_xdp_link_lops')
   net/core/dev.c:9036:3: error: 'const struct bpf_link_ops' has no member named 'dealloc'
    9036 |  .dealloc = bpf_xdp_link_dealloc,
         |   ^~~~~~~
   net/core/dev.c:9036:13: warning: excess elements in struct initializer
    9036 |  .dealloc = bpf_xdp_link_dealloc,
         |             ^~~~~~~~~~~~~~~~~~~~
   net/core/dev.c:9036:13: note: (near initialization for 'bpf_xdp_link_lops')
   net/core/dev.c:9037:3: error: 'const struct bpf_link_ops' has no member named 'update_prog'
    9037 |  .update_prog = bpf_xdp_link_update,
         |   ^~~~~~~~~~~
   net/core/dev.c:9037:17: warning: excess elements in struct initializer
    9037 |  .update_prog = bpf_xdp_link_update,
         |                 ^~~~~~~~~~~~~~~~~~~
   net/core/dev.c:9037:17: note: (near initialization for 'bpf_xdp_link_lops')
   net/core/dev.c: In function 'bpf_xdp_link_attach':
   net/core/dev.c:9043:25: error: storage size of 'link_primer' isn't known
    9043 |  struct bpf_link_primer link_primer;
         |                         ^~~~~~~~~~~
   net/core/dev.c:9058:2: error: implicit declaration of function 'bpf_link_init'; did you mean 'bio_list_init'? [-Werror=implicit-function-declaration]
    9058 |  bpf_link_init(&link->link, BPF_LINK_TYPE_XDP, &bpf_xdp_link_lops, prog);
         |  ^~~~~~~~~~~~~
         |  bio_list_init
   net/core/dev.c:9062:8: error: implicit declaration of function 'bpf_link_prime' [-Werror=implicit-function-declaration]
    9062 |  err = bpf_link_prime(&link->link, &link_primer);
         |        ^~~~~~~~~~~~~~
   net/core/dev.c:9073:3: error: implicit declaration of function 'bpf_link_cleanup' [-Werror=implicit-function-declaration]
    9073 |   bpf_link_cleanup(&link_primer);
         |   ^~~~~~~~~~~~~~~~
   net/core/dev.c:9077:7: error: implicit declaration of function 'bpf_link_settle' [-Werror=implicit-function-declaration]
    9077 |  fd = bpf_link_settle(&link_primer);
         |       ^~~~~~~~~~~~~~~
   net/core/dev.c:9043:25: warning: unused variable 'link_primer' [-Wunused-variable]
    9043 |  struct bpf_link_primer link_primer;
         |                         ^~~~~~~~~~~
   net/core/dev.c: At top level:
   net/core/dev.c:9034:34: error: storage size of 'bpf_xdp_link_lops' isn't known
    9034 | static const struct bpf_link_ops bpf_xdp_link_lops = {
         |                                  ^~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

vim +50 arch/parisc/include/asm/cmpxchg.h

9e5228ce0b9619 Paul Gortmaker 2012-04-01  37  
9e5228ce0b9619 Paul Gortmaker 2012-04-01  38  /*
9e5228ce0b9619 Paul Gortmaker 2012-04-01  39  ** REVISIT - Abandoned use of LDCW in xchg() for now:
9e5228ce0b9619 Paul Gortmaker 2012-04-01  40  ** o need to test sizeof(*ptr) to avoid clearing adjacent bytes
9e5228ce0b9619 Paul Gortmaker 2012-04-01  41  ** o and while we are at it, could CONFIG_64BIT code use LDCD too?
9e5228ce0b9619 Paul Gortmaker 2012-04-01  42  **
9e5228ce0b9619 Paul Gortmaker 2012-04-01  43  **	if (__builtin_constant_p(x) && (x == NULL))
9e5228ce0b9619 Paul Gortmaker 2012-04-01  44  **		if (((unsigned long)p & 0xf) == 0)
9e5228ce0b9619 Paul Gortmaker 2012-04-01  45  **			return __ldcw(p);
9e5228ce0b9619 Paul Gortmaker 2012-04-01  46  */
9e5228ce0b9619 Paul Gortmaker 2012-04-01  47  #define xchg(ptr, x)							\
75cf9797006a3a Helge Deller   2019-12-20  48  ({									\
75cf9797006a3a Helge Deller   2019-12-20  49  	__typeof__(*(ptr)) __ret;					\
75cf9797006a3a Helge Deller   2019-12-20 @50  	__typeof__(*(ptr)) _x_ = (x);					\
75cf9797006a3a Helge Deller   2019-12-20  51  	__ret = (__typeof__(*(ptr)))					\
75cf9797006a3a Helge Deller   2019-12-20  52  		__xchg((unsigned long)_x_, (ptr), sizeof(*(ptr)));	\
75cf9797006a3a Helge Deller   2019-12-20  53  	__ret;								\
75cf9797006a3a Helge Deller   2019-12-20  54  })
9e5228ce0b9619 Paul Gortmaker 2012-04-01  55  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--ZGiS0Q5IWpPtfppv
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
QUMUq/ksAQA=

--ZGiS0Q5IWpPtfppv--

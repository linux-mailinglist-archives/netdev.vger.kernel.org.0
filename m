Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A1B21E7B0
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 07:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbgGNFtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 01:49:20 -0400
Received: from mga12.intel.com ([192.55.52.136]:26809 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgGNFtU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 01:49:20 -0400
IronPort-SDR: 9nVca1qGUrY8wsyOVX8Zwc/FNC1UidYx1kqi+ijAfJ+GHGX5aw9CF2ngFbpdbncMSxmSRwTX5n
 LVURElNw2Ogg==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="128375393"
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="gz'50?scan'50,208,50";a="128375393"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 22:49:19 -0700
IronPort-SDR: 8bgU7ZQqh/YWs+4k4sfpsdaaqnxdeLuz4h/fZoORPL1wGuNF3/725fdZMfpNcZ0Wbr3bpswl7x
 m/5p3mFM4Ibg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="gz'50?scan'50,208,50";a="307731590"
Received: from lkp-server02.sh.intel.com (HELO fb03a464a2e3) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 13 Jul 2020 22:49:16 -0700
Received: from kbuild by fb03a464a2e3 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1jvDoZ-00016p-UB; Tue, 14 Jul 2020 05:49:15 +0000
Date:   Tue, 14 Jul 2020 13:48:19 +0800
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
Message-ID: <202007141322.lc2XiNkI%lkp@intel.com>
References: <20200714040643.1135876-5-andriin@fb.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <20200714040643.1135876-5-andriin@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andrii,

I love your patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/0day-ci/linux/commits/Andrii-Nakryiko/BPF-XDP-link/20200714-120909
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: alpha-defconfig (attached as .config)
compiler: alpha-linux-gcc (GCC) 9.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=alpha 

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
   In file included from arch/alpha/include/asm/atomic.h:7,
                    from include/linux/atomic.h:7,
                    from include/linux/rcupdate.h:25,
                    from include/linux/rculist.h:11,
                    from include/linux/pid.h:5,
                    from include/linux/sched.h:14,
                    from include/linux/uaccess.h:6,
                    from net/core/dev.c:71:
   net/core/dev.c: In function 'bpf_xdp_link_update':
>> arch/alpha/include/asm/cmpxchg.h:48:27: warning: initialization of 'int' from 'struct bpf_prog *' makes integer from pointer without a cast [-Wint-conversion]
      48 |  __typeof__(*(ptr)) _x_ = (x);     \
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

vim +48 arch/alpha/include/asm/cmpxchg.h

5ba840f9da1ff9 Paul Gortmaker 2012-04-02  40  
fbfcd019917098 Andrea Parri   2018-02-27  41  /*
fbfcd019917098 Andrea Parri   2018-02-27  42   * The leading and the trailing memory barriers guarantee that these
fbfcd019917098 Andrea Parri   2018-02-27  43   * operations are fully ordered.
fbfcd019917098 Andrea Parri   2018-02-27  44   */
5ba840f9da1ff9 Paul Gortmaker 2012-04-02  45  #define xchg(ptr, x)							\
5ba840f9da1ff9 Paul Gortmaker 2012-04-02  46  ({									\
fbfcd019917098 Andrea Parri   2018-02-27  47  	__typeof__(*(ptr)) __ret;					\
5ba840f9da1ff9 Paul Gortmaker 2012-04-02 @48  	__typeof__(*(ptr)) _x_ = (x);					\
fbfcd019917098 Andrea Parri   2018-02-27  49  	smp_mb();							\
fbfcd019917098 Andrea Parri   2018-02-27  50  	__ret = (__typeof__(*(ptr)))					\
fbfcd019917098 Andrea Parri   2018-02-27  51  		__xchg((ptr), (unsigned long)_x_, sizeof(*(ptr)));	\
fbfcd019917098 Andrea Parri   2018-02-27  52  	smp_mb();							\
fbfcd019917098 Andrea Parri   2018-02-27  53  	__ret;								\
5ba840f9da1ff9 Paul Gortmaker 2012-04-02  54  })
5ba840f9da1ff9 Paul Gortmaker 2012-04-02  55  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--huq684BweRXVnRxX
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
RD/IqsxHiW9m1+g/iA0WrWvfAAA=

--huq684BweRXVnRxX--

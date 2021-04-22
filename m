Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA69B368883
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 23:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239406AbhDVVYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 17:24:03 -0400
Received: from mga06.intel.com ([134.134.136.31]:63721 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239136AbhDVVYB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 17:24:01 -0400
IronPort-SDR: PFh34yObnvd1LaxQ0WsPgdbKuXztF4nqlmUl5a+nuNIP4COMM8DWK/j10E25Sq7RgjmpwhBDaI
 Xk2hTeU0XoOQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9962"; a="257282503"
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="gz'50?scan'50,208,50";a="257282503"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 14:23:24 -0700
IronPort-SDR: e7K07W2lbpjcIA06+MI/S3Ygp75z1SZltA0vOJzvkAdWO6hTzPr8nuvPC8LadO7/NhIC/SuJtf
 gmw9WnDdf7fA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="gz'50?scan'50,208,50";a="464094991"
Received: from lkp-server01.sh.intel.com (HELO a48ff7ddd223) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 22 Apr 2021 14:23:22 -0700
Received: from kbuild by a48ff7ddd223 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lZgnB-0004LV-DY; Thu, 22 Apr 2021 21:23:21 +0000
Date:   Fri, 23 Apr 2021 05:23:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tanner Love <tannerlove.kernel@gmail.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, davem@davemloft.net,
        Tanner Love <tannerlove@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>
Subject: Re: [PATCH net-next 2/3] once: replace uses of
 __section(".data.once") with DO_ONCE_LITE(_IF)?
Message-ID: <202104230511.lg9BxfyN-lkp@intel.com>
References: <20210422194738.2175542-3-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <20210422194738.2175542-3-tannerlove.kernel@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Tanner,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Tanner-Love/net-update-netdev_rx_csum_fault-print-dump-only-once/20210423-034958
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 5d869070569a23aa909c6e7e9d010fc438a492ef
config: i386-tinyconfig (attached as .config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/eaeb33f0f85f70fc4e5fbae1e2344e9c6867c840
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Tanner-Love/net-update-netdev_rx_csum_fault-print-dump-only-once/20210423-034958
        git checkout eaeb33f0f85f70fc4e5fbae1e2344e9c6867c840
        # save the attached .config to linux build tree
        make W=1 W=1 ARCH=i386 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/once.h:6,
                    from include/asm-generic/bug.h:7,
                    from arch/x86/include/asm/bug.h:93,
                    from include/linux/bug.h:5,
                    from include/linux/page-flags.h:10,
                    from kernel/bounds.c:10:
   include/linux/jump_label.h: In function 'static_key_slow_inc':
>> include/linux/jump_label.h:81:35: error: implicit declaration of function 'WARN' [-Werror=implicit-function-declaration]
      81 | #define STATIC_KEY_CHECK_USE(key) WARN(!static_key_initialized,        \
         |                                   ^~~~
   include/linux/jump_label.h:278:2: note: in expansion of macro 'STATIC_KEY_CHECK_USE'
     278 |  STATIC_KEY_CHECK_USE(key);
         |  ^~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/once.h:6,
                    from include/asm-generic/bug.h:7,
                    from arch/x86/include/asm/bug.h:93,
                    from include/linux/bug.h:5,
                    from include/linux/page-flags.h:10,
                    from kernel/bounds.c:10:
   include/linux/jump_label.h: In function 'static_key_enable':
>> include/linux/jump_label.h:309:3: error: implicit declaration of function 'WARN_ON_ONCE' [-Werror=implicit-function-declaration]
     309 |   WARN_ON_ONCE(atomic_read(&key->enabled) != 1);
         |   ^~~~~~~~~~~~
   cc1: some warnings being treated as errors
--
   In file included from include/linux/once.h:6,
                    from include/asm-generic/bug.h:7,
                    from arch/x86/include/asm/bug.h:93,
                    from include/linux/bug.h:5,
                    from include/linux/page-flags.h:10,
                    from kernel/bounds.c:10:
   include/linux/jump_label.h: In function 'static_key_slow_inc':
>> include/linux/jump_label.h:81:35: error: implicit declaration of function 'WARN' [-Werror=implicit-function-declaration]
      81 | #define STATIC_KEY_CHECK_USE(key) WARN(!static_key_initialized,        \
         |                                   ^~~~
   include/linux/jump_label.h:278:2: note: in expansion of macro 'STATIC_KEY_CHECK_USE'
     278 |  STATIC_KEY_CHECK_USE(key);
         |  ^~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/once.h:6,
                    from include/asm-generic/bug.h:7,
                    from arch/x86/include/asm/bug.h:93,
                    from include/linux/bug.h:5,
                    from include/linux/page-flags.h:10,
                    from kernel/bounds.c:10:
   include/linux/jump_label.h: In function 'static_key_enable':
>> include/linux/jump_label.h:309:3: error: implicit declaration of function 'WARN_ON_ONCE' [-Werror=implicit-function-declaration]
     309 |   WARN_ON_ONCE(atomic_read(&key->enabled) != 1);
         |   ^~~~~~~~~~~~
   cc1: some warnings being treated as errors
   make[2]: *** [scripts/Makefile.build:116: kernel/bounds.s] Error 1
   make[2]: Target '__build' not remade because of errors.
   make[1]: *** [Makefile:1235: prepare0] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:215: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +/WARN_ON_ONCE +309 include/linux/jump_label.h

b202952075f626 Gleb Natapov    2011-11-27  303  
e33886b38cc82a Peter Zijlstra  2015-07-24  304  static inline void static_key_enable(struct static_key *key)
e33886b38cc82a Peter Zijlstra  2015-07-24  305  {
5cdda5117e125e Borislav Petkov 2017-10-18  306  	STATIC_KEY_CHECK_USE(key);
e33886b38cc82a Peter Zijlstra  2015-07-24  307  
1dbb6704de91b1 Paolo Bonzini   2017-08-01  308  	if (atomic_read(&key->enabled) != 0) {
1dbb6704de91b1 Paolo Bonzini   2017-08-01 @309  		WARN_ON_ONCE(atomic_read(&key->enabled) != 1);
1dbb6704de91b1 Paolo Bonzini   2017-08-01  310  		return;
1dbb6704de91b1 Paolo Bonzini   2017-08-01  311  	}
1dbb6704de91b1 Paolo Bonzini   2017-08-01  312  	atomic_set(&key->enabled, 1);
e33886b38cc82a Peter Zijlstra  2015-07-24  313  }
e33886b38cc82a Peter Zijlstra  2015-07-24  314  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--J2SCkAp4GZ/dPZZf
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
Xm+v/Qfl6QvKRGoAAA==

--J2SCkAp4GZ/dPZZf--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B0247C872
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 21:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235285AbhLUUz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 15:55:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:43237 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235188AbhLUUz0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 15:55:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640120126; x=1671656126;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sppWd41fOVgGNssqFeeK2sIEGZ4mkqbCXqqgYXuu/EQ=;
  b=emmGiWJ8VVBuuPE8xgCHyPvA/DBixoHDlvAWFj6jZJGNhdaX3Jwng5+n
   pki/Wwg1r4MKaufXdkbyBGPut50xUgkYrERy/rUwDYGe1C4xVjefBGYrt
   Y0hnY316t900H388JSxkYB5dZ32oPbA4ZR89zTZMVejMslsD8ONb3nzby
   JxqtPjAMbpg4x6aLijVZrLj9l5NCzoZa7JIZxjlN9eLFda70kjEtqE7YP
   l1vTyXcb/+kvDTmBZn6gJIsk4JB1PS/q7AumS3y1lR+9gIkQ9vBxYIUxm
   /nW5+GmnyTXiqYQ43riqsSyiH01976QPUPML+hwtIWTC0Ih5QkRMf5UzL
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="227785123"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="227785123"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 12:55:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="467931443"
Received: from lkp-server02.sh.intel.com (HELO 9f38c0981d9f) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 21 Dec 2021 12:55:17 -0800
Received: from kbuild by 9f38c0981d9f with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mzmAH-0009Xs-5U; Tue, 21 Dec 2021 20:55:17 +0000
Date:   Wed, 22 Dec 2021 04:55:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     Antony Antony <antony.antony@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     kbuild-all@lists.01.org, Thomas Egerer <thomas.egerer@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Antony Antony <antony.antony@secunet.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH ipsec-next v2] xfrm: rate limit SA mapping change message
 to user space
Message-ID: <202112220439.Errml0C2-lkp@intel.com>
References: <e7382eefea550d10cb5f13030dbe809f0366c9bf.1639758955.git.antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7382eefea550d10cb5f13030dbe809f0366c9bf.1639758955.git.antony.antony@secunet.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Antony,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on klassert-ipsec-next/master]
[also build test ERROR on klassert-ipsec/master net-next/master net/master v5.16-rc6 next-20211221]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Antony-Antony/xfrm-rate-limit-SA-mapping-change-message-to-user-space/20211218-004825
base:   https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20211222/202112220439.Errml0C2-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/0deffb6fd76e1afc0a82880f4ab1b7a32517cd2e
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Antony-Antony/xfrm-rate-limit-SA-mapping-change-message-to-user-space/20211218-004825
        git checkout 0deffb6fd76e1afc0a82880f4ab1b7a32517cd2e
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   In function 'xfrm_xlate32_attr',
       inlined from 'xfrm_xlate32' at net/xfrm/xfrm_compat.c:571:9:
>> include/linux/compiler_types.h:335:38: error: call to '__compiletime_assert_1663' declared with attribute error: BUILD_BUG_ON failed: XFRMA_MAX != XFRMA_IF_ID
     335 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                      ^
   include/linux/compiler_types.h:316:4: note: in definition of macro '__compiletime_assert'
     316 |    prefix ## suffix();    \
         |    ^~~~~~
   include/linux/compiler_types.h:335:2: note: in expansion of macro '_compiletime_assert'
     335 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |  ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |  BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |  ^~~~~~~~~~~~~~~~
   net/xfrm/xfrm_compat.c:434:3: note: in expansion of macro 'BUILD_BUG_ON'
     434 |   BUILD_BUG_ON(XFRMA_MAX != XFRMA_IF_ID);
         |   ^~~~~~~~~~~~
   In function 'xfrm_xlate64_attr',
       inlined from 'xfrm_xlate64' at net/xfrm/xfrm_compat.c:308:10,
       inlined from 'xfrm_alloc_compat' at net/xfrm/xfrm_compat.c:338:8:
   include/linux/compiler_types.h:335:38: error: call to '__compiletime_assert_1656' declared with attribute error: BUILD_BUG_ON failed: XFRMA_MAX != XFRMA_IF_ID
     335 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                      ^
   include/linux/compiler_types.h:316:4: note: in definition of macro '__compiletime_assert'
     316 |    prefix ## suffix();    \
         |    ^~~~~~
   include/linux/compiler_types.h:335:2: note: in expansion of macro '_compiletime_assert'
     335 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |  ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |  BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |  ^~~~~~~~~~~~~~~~
   net/xfrm/xfrm_compat.c:279:3: note: in expansion of macro 'BUILD_BUG_ON'
     279 |   BUILD_BUG_ON(XFRMA_MAX != XFRMA_IF_ID);
         |   ^~~~~~~~~~~~


vim +/__compiletime_assert_1663 +335 include/linux/compiler_types.h

eb5c2d4b45e3d2d Will Deacon 2020-07-21  321  
eb5c2d4b45e3d2d Will Deacon 2020-07-21  322  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2d Will Deacon 2020-07-21  323  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2d Will Deacon 2020-07-21  324  
eb5c2d4b45e3d2d Will Deacon 2020-07-21  325  /**
eb5c2d4b45e3d2d Will Deacon 2020-07-21  326   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2d Will Deacon 2020-07-21  327   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2d Will Deacon 2020-07-21  328   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2d Will Deacon 2020-07-21  329   *
eb5c2d4b45e3d2d Will Deacon 2020-07-21  330   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2d Will Deacon 2020-07-21  331   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2d Will Deacon 2020-07-21  332   * compiler has support to do so.
eb5c2d4b45e3d2d Will Deacon 2020-07-21  333   */
eb5c2d4b45e3d2d Will Deacon 2020-07-21  334  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2d Will Deacon 2020-07-21 @335  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2d Will Deacon 2020-07-21  336  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D004B474E3A
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234614AbhLNWye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:54:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:30023 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232893AbhLNWyd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 17:54:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639522473; x=1671058473;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XA79n3ICZ4l7KCKofg6S+/v8gH7JjrFgwW2adNrEMy4=;
  b=AZq8Bm5XJ/fxVeDXGICkI0KQgEzMNlcLMMeeji/0vnn3f1FUIlRZnebJ
   JYETI39OxXbD0v04WiXkCXA4IEtQt0W6T3i2s3YTESj2rZhr5ONh10/Mi
   TatEwtywt9pocsAMwM8ZqT19cr3lh1OiraqZErkvVZgtLMmEL4z9Ts+Xx
   Jko+gU5PLIqyJH6/DjS+lHJYMAwmLHr940P9I+dEr9tXCvlIxCn58nqLl
   qeS7kWztSGI1fLiPuKedO1zZ/IFioghNTnmmOYbX0LhH7vXoHWdaYcuNs
   nHE4TrQVN2PMnr3H9ab8moIU2SMXUWNWrgq2iUfWQ3nmNOPWDXKRV1LZn
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="238911939"
X-IronPort-AV: E=Sophos;i="5.88,206,1635231600"; 
   d="scan'208";a="238911939"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 14:54:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,206,1635231600"; 
   d="scan'208";a="614477083"
Received: from lkp-server02.sh.intel.com (HELO 9f38c0981d9f) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 14 Dec 2021 14:54:31 -0800
Received: from kbuild by 9f38c0981d9f with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mxGgo-0000t4-Pz; Tue, 14 Dec 2021 22:54:30 +0000
Date:   Wed, 15 Dec 2021 06:53:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 net-next 1/4] fib: remove suppress indirection
Message-ID: <202112150646.Jm2ooptn-lkp@intel.com>
References: <20211214172731.3591-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214172731.3591-2-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Florian-Westphal/fib-remove-suppress-indirection-merge-nl-policies/20211215-013026
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git a3c62a042237d1adeb0290dcb768e17edd6dcd25
config: csky-randconfig-r013-20211214 (https://download.01.org/0day-ci/archive/20211215/202112150646.Jm2ooptn-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/596c4af51db7c6900f25406b25d4d7f813920801
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Florian-Westphal/fib-remove-suppress-indirection-merge-nl-policies/20211215-013026
        git checkout 596c4af51db7c6900f25406b25d4d7f813920801
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=csky SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   csky-linux-ld: net/core/fib_rules.o: in function `fib_rule_suppress':
>> fib_rules.c:(.text+0x58e): undefined reference to `free_fib_info'
>> csky-linux-ld: fib_rules.c:(.text+0x5f4): undefined reference to `free_fib_info'

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

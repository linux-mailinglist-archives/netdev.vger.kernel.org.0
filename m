Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7AC5475087
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 02:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238832AbhLOBdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 20:33:41 -0500
Received: from mga06.intel.com ([134.134.136.31]:57417 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233511AbhLOBdl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 20:33:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639532021; x=1671068021;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N8ZlgcN3c7Mxv/dd2KVjtWP2qqOP295Gc8qhTcYoZNA=;
  b=GEnw7UD8gOxgGoZT1+/THia0ZLUJYE4UmLBxqCeIdZlo1Q4Xo9PTGyX/
   aA9XCGKdo8WihCMedpFvLykS/2xnTL8UJZE1inixNZz/n1qukH26lL00O
   TXGsR2JU9YOPdgmcKx6hNPW7/m7iB+QmianO7GVpT7r4oOr3zHbLAJY01
   iKwY2AI3hIr/h91hcLkpV4fjBUBQs4GxcZ5TysZ16snabINqedzVnHF4U
   NjmB7A9STJ23to4x11XHrHZE5VBIAnDiddqMWLfVD8MsWBHOTaE7Yv2Ur
   DutIsg23KNfbgorzw1h0kW1MjMoTYm2Stq8XZKl5GtXdcdn0kqU1wofdw
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="299899744"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="299899744"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 17:33:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="465334880"
Received: from lkp-server02.sh.intel.com (HELO 9f38c0981d9f) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 14 Dec 2021 17:33:39 -0800
Received: from kbuild by 9f38c0981d9f with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mxJAo-00013Z-H4; Wed, 15 Dec 2021 01:33:38 +0000
Date:   Wed, 15 Dec 2021 09:32:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 net-next 2/4] fib: place common code in a helper
Message-ID: <202112150951.hp1nDYE8-lkp@intel.com>
References: <20211214172731.3591-3-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214172731.3591-3-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Florian-Westphal/fib-remove-suppress-indirection-merge-nl-policies/20211215-013026
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git a3c62a042237d1adeb0290dcb768e17edd6dcd25
config: parisc-randconfig-r001-20211214 (https://download.01.org/0day-ci/archive/20211215/202112150951.hp1nDYE8-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/59837eba57ced3afe03ce1e6d8bd6da39efd398c
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Florian-Westphal/fib-remove-suppress-indirection-merge-nl-policies/20211215-013026
        git checkout 59837eba57ced3afe03ce1e6d8bd6da39efd398c
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=parisc SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   hppa-linux-ld: net/core/fib_rules.o: in function `fib_rules_lookup':
>> (.text+0xb98): undefined reference to `free_fib_info'

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

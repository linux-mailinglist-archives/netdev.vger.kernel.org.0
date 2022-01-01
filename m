Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05FB48272D
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 11:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbiAAKEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jan 2022 05:04:40 -0500
Received: from mga07.intel.com ([134.134.136.100]:26025 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229624AbiAAKEk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jan 2022 05:04:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641031480; x=1672567480;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yNHXNBtjjqAVJb76i919G1PmmPUXGG2WzOs+akbi2go=;
  b=MB/KEo3ruOOg9T/+O1GL5zPdZx2sOrkv91O/N/2N8GONq34fO16mNRxf
   5/MH5SFqGeCcuWW9CorUudkScOZuBcyNpIS+gmBsq4mMbfLF41mGUOujT
   ZOzpyCWoLWJGGNq/yVqTN/taKsYSgNSysvRXoSxJTzXS9jFeiCJOe6aD7
   ULBKUurk4wucOb6INb94ABJBAqu8M5p2Lz1HmrjwwlypGh29FKINKtQrP
   OP58scqS9p2QsniGhXqDy+zaGGsTS9T3diPFbjEYxyHcjCcgcqwZ2zj7k
   x1ZCGrrTim2JVcJ7uCcd0uVn33WMS26CzZJwrgWXUbfy/12gjwqxNUdeM
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10214"; a="305242521"
X-IronPort-AV: E=Sophos;i="5.88,253,1635231600"; 
   d="scan'208";a="305242521"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jan 2022 02:04:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,253,1635231600"; 
   d="scan'208";a="471136875"
Received: from lkp-server01.sh.intel.com (HELO e357b3ef1427) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 01 Jan 2022 02:04:36 -0800
Received: from kbuild by e357b3ef1427 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n3bFb-000CL2-QD; Sat, 01 Jan 2022 10:04:35 +0000
Date:   Sat, 1 Jan 2022 18:03:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Luis Chamberlain <mcgrof@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH bpf-next v5 1/9] kernel: Add kallsyms_on_each_symbol
 variant for single module
Message-ID: <202201011858.vOPCCeDV-lkp@intel.com>
References: <20211230023705.3860970-2-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211230023705.3860970-2-memxor@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kumar,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/0day-ci/linux/commits/Kumar-Kartikeya-Dwivedi/Introduce-unstable-CT-lookup-helpers/20211230-103958
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: ia64-randconfig-s031-20211230 (https://download.01.org/0day-ci/archive/20220101/202201011858.vOPCCeDV-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 11.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/25d6b438335605e4e002f7afde50a3eaf17a0b6c
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Kumar-Kartikeya-Dwivedi/Introduce-unstable-CT-lookup-helpers/20211230-103958
        git checkout 25d6b438335605e4e002f7afde50a3eaf17a0b6c
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=ia64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
   kernel/module.c:2762:23: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct mod_kallsyms [noderef] __rcu *kallsyms @@     got void * @@
   kernel/module.c:2762:23: sparse:     expected struct mod_kallsyms [noderef] __rcu *kallsyms
   kernel/module.c:2762:23: sparse:     got void *
>> kernel/module.c:4510:18: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct mod_kallsyms *kallsyms @@     got struct mod_kallsyms [noderef] __rcu *kallsyms @@
   kernel/module.c:4510:18: sparse:     expected struct mod_kallsyms *kallsyms
   kernel/module.c:4510:18: sparse:     got struct mod_kallsyms [noderef] __rcu *kallsyms
   kernel/module.c:2764:12: sparse: sparse: dereference of noderef expression
   kernel/module.c:2765:12: sparse: sparse: dereference of noderef expression
   kernel/module.c:2767:12: sparse: sparse: dereference of noderef expression
   kernel/module.c:2768:12: sparse: sparse: dereference of noderef expression
   kernel/module.c:2777:18: sparse: sparse: dereference of noderef expression
   kernel/module.c:2778:35: sparse: sparse: dereference of noderef expression
   kernel/module.c:2779:20: sparse: sparse: dereference of noderef expression
   kernel/module.c:2784:32: sparse: sparse: dereference of noderef expression
   kernel/module.c:2787:45: sparse: sparse: dereference of noderef expression

vim +4510 kernel/module.c

  4499	
  4500	int module_kallsyms_on_each_symbol(struct module *mod,
  4501					   int (*fn)(void *, const char *,
  4502						     struct module *, unsigned long),
  4503					   void *data)
  4504	{
  4505		struct mod_kallsyms *kallsyms;
  4506		int ret = 0;
  4507	
  4508		mutex_lock(&module_mutex);
  4509		/* We hold module_mutex: no need for rcu_dereference_sched */
> 4510		kallsyms = mod->kallsyms;
  4511		if (mod->state != MODULE_STATE_UNFORMED)
  4512			ret = __module_kallsyms_on_each_symbol(kallsyms, mod, fn, data);
  4513		mutex_unlock(&module_mutex);
  4514	
  4515		return ret;
  4516	}
  4517	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

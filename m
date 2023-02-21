Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D02D69DEDB
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 12:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbjBULbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 06:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232613AbjBULbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 06:31:11 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12F823654;
        Tue, 21 Feb 2023 03:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676979065; x=1708515065;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N5rFekad14CxU869B3zGTSTqJQLOKVV8Uwl9VAdFVRQ=;
  b=nT3tmbpnBpgYR5sIjZpWyIEdd59JNv04p/YGfbC3v4Km5ydgIapfARe3
   mgD+yoQsBhGF7ZTBagt2jBGfYYqV7uW/dC64eZlYZV/l7iuZgBCQRxDFz
   GbKT/SpKrst+nFydurCCMasmXHitWEOgBnLqWvoasm7nqO2EeA2aODsuM
   IOcupoWjrgyiFzFLOv5dnJ4mgjhqw5y+WARyFUWgJOqlEpVRhzxc11upi
   /A5JBYnSH+ekjwZi8aLFMh8LYLGcGhrIfl2bjaKm7c0PHG8JdRpAzvINB
   mJDP1XHENJXCwMf6hapnXCtDAQomfXB+7I11DDccJUXsCuCF0zjfejfw8
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="395089428"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="395089428"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 03:31:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="664942388"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="664942388"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 21 Feb 2023 03:31:01 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pUQrM-000EjB-1T;
        Tue, 21 Feb 2023 11:31:00 +0000
Date:   Tue, 21 Feb 2023 19:30:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/2] net/smc: Introduce BPF injection capability
 for SMC
Message-ID: <202302211908.BgagxpRo-lkp@intel.com>
References: <1676966191-47736-2-git-send-email-alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1676966191-47736-2-git-send-email-alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wythe,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/D-Wythe/net-smc-Introduce-BPF-injection-capability-for-SMC/20230221-155712
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
patch link:    https://lore.kernel.org/r/1676966191-47736-2-git-send-email-alibuda%40linux.alibaba.com
patch subject: [PATCH bpf-next 1/2] net/smc: Introduce BPF injection capability for SMC
config: i386-randconfig-a013-20230220 (https://download.01.org/0day-ci/archive/20230221/202302211908.BgagxpRo-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/e2b31aece49068d7a07ca4bbd5fbdbd92f45a25e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review D-Wythe/net-smc-Introduce-BPF-injection-capability-for-SMC/20230221-155712
        git checkout e2b31aece49068d7a07ca4bbd5fbdbd92f45a25e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302211908.BgagxpRo-lkp@intel.com/

All errors (new ones prefixed by >>):

>> net/smc/bpf_smc_struct_ops.c:61:33: error: use of undeclared identifier 'BTF_SMC_TYPE_MAX'; did you mean 'BTF_SMC_TYPE_SOCK'?
   BTF_ID_LIST_GLOBAL(btf_smc_ids, BTF_SMC_TYPE_MAX)
                                   ^~~~~~~~~~~~~~~~
                                   BTF_SMC_TYPE_SOCK
   include/linux/btf_ids.h:211:61: note: expanded from macro 'BTF_ID_LIST_GLOBAL'
   #define BTF_ID_LIST_GLOBAL(name, n) u32 __maybe_unused name[n];
                                                               ^
   include/linux/btf_ids.h:275:1: note: 'BTF_SMC_TYPE_SOCK' declared here
   BTF_SMC_TYPE_xxx
   ^
   include/linux/btf_ids.h:269:15: note: expanded from macro 'BTF_SMC_TYPE_xxx'
           BTF_SMC_TYPE(BTF_SMC_TYPE_SOCK, smc_sock)               \
                        ^
   1 error generated.


vim +61 net/smc/bpf_smc_struct_ops.c

    59	
    60	/* define global smc ID for smc_struct_ops */
  > 61	BTF_ID_LIST_GLOBAL(btf_smc_ids, BTF_SMC_TYPE_MAX)
    62	#define BTF_SMC_TYPE(name, type) BTF_ID(struct, type)
    63	BTF_SMC_TYPE_xxx
    64	#undef BTF_SMC_TYPE
    65	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

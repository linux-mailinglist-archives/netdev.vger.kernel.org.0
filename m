Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB3B4F99F6
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 17:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237856AbiDHP5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 11:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbiDHP47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 11:56:59 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF8F21B2;
        Fri,  8 Apr 2022 08:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649433296; x=1680969296;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8Ef7bdwQ2vU8g4RXlOQh1N7SEV6OmzR0EZJITs0lq1o=;
  b=isZHfSAybSAoTiv9tZ8yWLHbv7QtyilT5nDNLqMWcYUBMcgIQvDCeipl
   6jZ/JxfBushqWHbXyHDHJP7MjD5+yWHvPnzfSEbiDL2iVZy9fLBBiMP41
   Ba13AVBjoh38Iyz5OY8JGz91w4Qn7k9oFPnOAtebMdNuwiUMidRWgjsCN
   ZwBGn3fmm3+FTWgDhT2/3eRmBn3KGBOcswviktPDlPiLrjlj7HpatIGdw
   tPUkr8VCSwGrEUZ3v4DKW6fnoJmfrXZKOAIIuKedwXyN0p+E5uqlR57vn
   jsr7zC/uQSIBmOiSPASyQYHgtIooQBNd3wAs5fkeKqiK5yF+B8DkJCTuW
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="242218311"
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="242218311"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 08:54:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="852115822"
Received: from lkp-server02.sh.intel.com (HELO 7e80bc2a00a0) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 08 Apr 2022 08:54:34 -0700
Received: from kbuild by 7e80bc2a00a0 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ncqwU-0000Q4-8H;
        Fri, 08 Apr 2022 15:54:34 +0000
Date:   Fri, 8 Apr 2022 23:53:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf-next v3 2/7] bpf: per-cgroup lsm flavor
Message-ID: <202204082305.Qs2g5Dzf-lkp@intel.com>
References: <20220407223112.1204582-3-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407223112.1204582-3-sdf@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stanislav,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Stanislav-Fomichev/bpf-cgroup_sock-lsm-flavor/20220408-063705
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: x86_64-randconfig-a005 (https://download.01.org/0day-ci/archive/20220408/202204082305.Qs2g5Dzf-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project c29a51b3a257908aebc01cd7c4655665db317d66)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/3c3f15b5422ca616e2585d699c47aa4e7b7dcf1d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Stanislav-Fomichev/bpf-cgroup_sock-lsm-flavor/20220408-063705
        git checkout 3c3f15b5422ca616e2585d699c47aa4e7b7dcf1d
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: btf_obj_id
   >>> referenced by trampoline.c
   >>>               bpf/trampoline.o:(bpf_trampoline_link_cgroup_shim) in archive kernel/built-in.a
   >>> referenced by trampoline.c
   >>>               bpf/trampoline.o:(bpf_trampoline_unlink_cgroup_shim) in archive kernel/built-in.a

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

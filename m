Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C42524F97E4
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 16:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbiDHOWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 10:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236850AbiDHOWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 10:22:37 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D824B352761;
        Fri,  8 Apr 2022 07:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649427633; x=1680963633;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XvAC40jVHJmWg5km7px+Bf8Niyr+ZCE4dlUOfiX4Ybw=;
  b=I2uh+8dhjrtwn+kcTWUqwC0u4mnIJIizpPc/nRBxDA6LnrKNsphn8tKf
   +zWM/4YkRPBm5DO5gKJ78JPo7hIw8aR9uo06xV03WDuOZc02uMi/G25Xk
   +NDbQwEhiaDvfFIbfTtC8+EC1ZkbTvgL7egtRoyWK0kgQ5/DqfX8AjYbc
   heKWtlLY3U80w8ENA5JlHWcoSfH6xzO39rcmu3/6vMdGMdc+ytsypTjI4
   RHrUhVZf04STkZb9gvRqkT/O2GkeoQuwjhcoy717Q740z5VJmfuLa1Kwg
   FlbDj7yE+7D+iOxWtz1KAuK1Qf7X9kxqHwKM//SE/EaTyLtG1hnohrift
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="261292337"
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="261292337"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 07:20:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="589231623"
Received: from lkp-server02.sh.intel.com (HELO 7e80bc2a00a0) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 08 Apr 2022 07:20:31 -0700
Received: from kbuild by 7e80bc2a00a0 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ncpTS-0000LK-R2;
        Fri, 08 Apr 2022 14:20:30 +0000
Date:   Fri, 8 Apr 2022 22:20:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf-next v3 2/7] bpf: per-cgroup lsm flavor
Message-ID: <202204082214.0EUCPtwa-lkp@intel.com>
References: <20220407223112.1204582-3-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407223112.1204582-3-sdf@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
config: arm64-randconfig-r011-20220408 (https://download.01.org/0day-ci/archive/20220408/202204082214.0EUCPtwa-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/3c3f15b5422ca616e2585d699c47aa4e7b7dcf1d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Stanislav-Fomichev/bpf-cgroup_sock-lsm-flavor/20220408-063705
        git checkout 3c3f15b5422ca616e2585d699c47aa4e7b7dcf1d
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   aarch64-linux-ld: Unexpected GOT/PLT entries detected!
   aarch64-linux-ld: Unexpected run-time procedure linkages detected!
   aarch64-linux-ld: ID map text too big or misaligned
   aarch64-linux-ld: kernel/bpf/trampoline.o: in function `bpf_trampoline_compute_key':
   include/linux/bpf_verifier.h:540: undefined reference to `btf_obj_id'
>> aarch64-linux-ld: include/linux/bpf_verifier.h:540: undefined reference to `btf_obj_id'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

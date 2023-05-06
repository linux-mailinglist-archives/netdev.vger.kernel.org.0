Return-Path: <netdev+bounces-686-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EC996F906C
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 10:04:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 460641C21B07
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 08:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B69F11FB8;
	Sat,  6 May 2023 08:04:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A3F1FB0
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 08:04:10 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5BE93E6
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 01:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683360249; x=1714896249;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=h68TUjskaDqvAA+e3rP9zftk3pA8fsmIJdsUemOgUKI=;
  b=OXSoFYUi6m4bHLkbwX/zoOF6be6Hg15c9F10rosN/yMyQecYKandPg/B
   V5H4n2Me3Tv2K/E6ViADyRApwwKFwk7d3NS5Iw8NlTC7k6pA6YuvPR8K4
   aD88tyt0HJ/OKbntT5jKtfUpBwZydiTB84kmDlZa+qxTS9XAQI2my1Rb/
   pUFWAKPRWDcCQjfD+rX6bfGBhEPIFfQ5SQNQIUjGMteX8ZzNx76JB2deP
   75DNoYxUwE/bMO0W5mFTdPlh7o4CIXDi484RHQZnk6lJAHjligBDXN8BI
   iWfH/20OxdsXlfJEDPag6YI+hQ0Fyuep2lfB6xtZrBiQXOJBYae6xY75d
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="333789764"
X-IronPort-AV: E=Sophos;i="5.99,254,1677571200"; 
   d="scan'208";a="333789764"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2023 01:04:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="697873655"
X-IronPort-AV: E=Sophos;i="5.99,254,1677571200"; 
   d="scan'208";a="697873655"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 06 May 2023 01:04:05 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1pvCth-00002h-0V;
	Sat, 06 May 2023 08:04:05 +0000
Date: Sat, 6 May 2023 16:03:32 +0800
From: kernel test robot <lkp@intel.com>
To: Cathy Zhang <cathy.zhang@intel.com>, edumazet@google.com,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	jesse.brandeburg@intel.com, suresh.srinivas@intel.com,
	tim.c.chen@intel.com, lizhen.you@intel.com, cathy.zhang@intel.com,
	eric.dumazet@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] net: Add sysctl_reclaim_threshold
Message-ID: <202305061521.bAXb1ha9-lkp@intel.com>
References: <20230506042958.15051-3-cathy.zhang@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230506042958.15051-3-cathy.zhang@intel.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Cathy,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]
[also build test ERROR on net/main horms-ipvs/master linus/master v6.3 next-20230505]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Cathy-Zhang/net-Keep-sk-sk_forward_alloc-as-a-proper-size/20230506-123121
base:   net-next/main
patch link:    https://lore.kernel.org/r/20230506042958.15051-3-cathy.zhang%40intel.com
patch subject: [PATCH 2/2] net: Add sysctl_reclaim_threshold
config: mips-randconfig-r033-20230430 (https://download.01.org/0day-ci/archive/20230506/202305061521.bAXb1ha9-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project b0fb98227c90adf2536c9ad644a74d5e92961111)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install mips cross compiling tool for clang build
        # apt-get install binutils-mips-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/24beb0b9f6d299a34b853699e5bcaa28a74cad5f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Cathy-Zhang/net-Keep-sk-sk_forward_alloc-as-a-proper-size/20230506-123121
        git checkout 24beb0b9f6d299a34b853699e5bcaa28a74cad5f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=mips olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305061521.bAXb1ha9-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: sysctl_reclaim_threshold
   >>> referenced by sock.c
   >>>               net/core/sock.o:(sock_rfree) in archive vmlinux.a
   >>> referenced by sock.c
   >>>               net/core/sock.o:(sock_rfree) in archive vmlinux.a
   >>> referenced by filter.c
   >>>               net/core/filter.o:(bpf_msg_pop_data) in archive vmlinux.a
   >>> referenced 15 more times

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests


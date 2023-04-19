Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A326E72CD
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 07:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbjDSF5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 01:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjDSF5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 01:57:50 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1AF358A;
        Tue, 18 Apr 2023 22:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681883869; x=1713419869;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wW4NhzeAjoIIRZByQbApPxvAShLZ2TJXmk9n+CDaUQQ=;
  b=jHhfJUDIkEdoQj3s4n6cUEC7m/gE0zWD9ixFfFlItbJVG8mLccyepMo2
   nn4iln3GMEZOM2Vd0LC+ndlZTqGdSiZBkKKWCOGaaRLPkWsSLJY7Klnkq
   dNif3Xxxx89ZV+dekCpx5ywCfdFpDsSqUKUiDRORrbJF8NDeDv6US0rAZ
   YC+WcN8MYPeEiu/ZN7JdlJ4/WO9A9fSg6uEvv93EGTKtEmLC63a3OMDTL
   4DNiyOQcDVikU2gaQ4/qauJJBufKsFuy0sH/yS1bq6vOlogShKfKBM69z
   e45sNYLoUK1pUjFonVlHqCtx4N9r4HjdejXHAJFLVyvsQwiZSRiJKdyjJ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="408268070"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="408268070"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 22:57:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="760618042"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="760618042"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 18 Apr 2023 22:57:32 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pp0ov-000ead-06;
        Wed, 19 Apr 2023 05:57:33 +0000
Date:   Wed, 19 Apr 2023 13:57:09 +0800
From:   kernel test robot <lkp@intel.com>
To:     Florian Westphal <fw@strlen.de>, bpf@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, dxu@dxuuu.xyz, qde@naccy.de,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH bpf-next v3 1/6] bpf: add bpf_link support for
 BPF_NETFILTER programs
Message-ID: <202304191332.9uIkDScp-lkp@intel.com>
References: <20230418131038.18054-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418131038.18054-2-fw@strlen.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

kernel test robot noticed the following build errors:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Florian-Westphal/bpf-add-bpf_link-support-for-BPF_NETFILTER-programs/20230418-211350
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
patch link:    https://lore.kernel.org/r/20230418131038.18054-2-fw%40strlen.de
patch subject: [PATCH bpf-next v3 1/6] bpf: add bpf_link support for BPF_NETFILTER programs
config: arm-allmodconfig (https://download.01.org/0day-ci/archive/20230419/202304191332.9uIkDScp-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/13cdccc8c376b453ae0ca2280ec22baa6210b450
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Florian-Westphal/bpf-add-bpf_link-support-for-BPF_NETFILTER-programs/20230418-211350
        git checkout 13cdccc8c376b453ae0ca2280ec22baa6210b450
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304191332.9uIkDScp-lkp@intel.com/

All errors (new ones prefixed by >>):

   arm-linux-gnueabi-ld: net/netfilter/nf_bpf_link.o: in function `bpf_nf_link_release':
>> nf_bpf_link.c:(.text+0x174): undefined reference to `__bad_cmpxchg'
   arm-linux-gnueabi-ld: net/netfilter/nf_bpf_link.o: in function `bpf_nf_link_detach':
   nf_bpf_link.c:(.text+0x200): undefined reference to `__bad_cmpxchg'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013CF515879
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 00:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239831AbiD2Wiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 18:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237836AbiD2Wis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 18:38:48 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA0168331;
        Fri, 29 Apr 2022 15:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651271727; x=1682807727;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=7GIX14AiQKWP9CyC8uIIv8SPou3ILuL8utid5Axi1Ao=;
  b=mcCZpZn4GH1oOauvStvv6q3MPm4G+ALS8mxv+4HNq5lK7qc0KWilDzk2
   tmM3D58OQoejRmO7+Cw5aK4S4nJ8fFSN6YNk21JVHj26sKCMo4eRW4G6s
   NzZYTGkd4VVsjRS+nfO6DwJPwreHr2pS5xA4OjEhHboZB8/n6tz3hh9ZV
   1mxQgrrsm+YZQK8kaMeklE263Bj3cE/GmGtK2HYNbN68wp1kBPP4J3Qsj
   llE/+yWwzTPHBMYtiNrzmLFBLBfbY6ISwHosnE3ZMi5DHp+26WNPYr6dA
   mnyE+aMUUhvqyx5ZlwC0CwJT1xPtIp7XbKhEZowhfEsc9PT3T2S/DQy20
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="291962610"
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="291962610"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 15:35:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="566341183"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 29 Apr 2022 15:35:24 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nkZCt-0006eF-DV;
        Fri, 29 Apr 2022 22:35:23 +0000
Date:   Sat, 30 Apr 2022 06:34:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     kbuild-all@lists.01.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [linux-next:master 6297/7959] kernel/bpf/helpers.c:1389:29: sparse:
 sparse: symbol 'bpf_kptr_xchg_proto' was not declared. Should it be static?
Message-ID: <202204300646.B29EmUql-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   5469f0c06732a077c70a759a81f2a1f00b277694
commit: c0a5a21c25f37c9fd7b36072f9968cdff1e4aa13 [6297/7959] bpf: Allow storing referenced kptr in map
config: x86_64-randconfig-s022 (https://download.01.org/0day-ci/archive/20220430/202204300646.B29EmUql-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=c0a5a21c25f37c9fd7b36072f9968cdff1e4aa13
        git remote add linux-next https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
        git fetch --no-tags linux-next master
        git checkout c0a5a21c25f37c9fd7b36072f9968cdff1e4aa13
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash kernel/bpf/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> kernel/bpf/helpers.c:1389:29: sparse: sparse: symbol 'bpf_kptr_xchg_proto' was not declared. Should it be static?

Please review and possibly fold the followup patch.

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

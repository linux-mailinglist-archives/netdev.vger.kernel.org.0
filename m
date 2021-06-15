Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331C93A74FB
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 05:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhFODWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 23:22:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:46188 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231161AbhFODWn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 23:22:43 -0400
IronPort-SDR: mKe1jgISq1SqtBqalwi9ULXDBDX2etQcvDwDYOAchAxksthMg5J4nqB4PQhbeTt8TZB96TVjaI
 tW66KPgOhlNQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10015"; a="205862755"
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="205862755"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 18:12:29 -0700
IronPort-SDR: ZL+gT/YzRL+OG6aN98EjhZ2bKzs31OmRzbVJqM6YCVcRfr90yAuseGjSxJi8pSiIanzvu20XqJ
 hLSsiiEnK8gQ==
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="450065673"
Received: from shao2-debian.sh.intel.com (HELO localhost) ([10.239.13.11])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 18:12:26 -0700
Date:   Tue, 15 Jun 2021 09:12:24 +0800
From:   kernel test robot <rong.a.chen@intel.com>
To:     Ingo Molnar <mingo@kernel.org>
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org
Subject: [tip:tmp.tmp2 341/364] kernel/bpf/inode.c: linux/seq_file.h is
 included more than once.
Message-ID: <20210615011224.GQ237458@shao2-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git tmp.tmp2
head:   adcceb5eb7aee38e4a9c15bdf599655f0e1b1324
commit: 324790b01da9f4a1e5ed4ab395e18a27a8768b8f [341/364] sched/headers, net: Optimize <net/net_namespace_types.h> and <net/net_namespace.h>
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


includecheck warnings: (new ones prefixed by >>)
>> kernel/bpf/inode.c: linux/seq_file.h is included more than once.

Please review and possibly fold the followup patch.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

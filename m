Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362393A74F4
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 05:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhFODWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 23:22:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:46188 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhFODWm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 23:22:42 -0400
IronPort-SDR: ikxlpmTw1kd6N4Ib4R8gmUPerrsX7iNcMDJoNp3blZyJ0iMHimQsitR5az2aqeTn5KJC4u3CEi
 ZWqjCa3OBdcQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10015"; a="205862569"
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="205862569"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 18:10:30 -0700
IronPort-SDR: UE+HV1hrVRzhZPsgjzzqc49Ts2SWRElZhyuzokjyKw03gQEmFKhrMnYsCi7xydKgJqO3af3GX0
 bGEMAfYJArcw==
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="554284095"
Received: from shao2-debian.sh.intel.com (HELO localhost) ([10.239.13.11])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 18:10:26 -0700
Date:   Tue, 15 Jun 2021 09:10:24 +0800
From:   kernel test robot <rong.a.chen@intel.com>
To:     Ingo Molnar <mingo@kernel.org>
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Aring <aahringo@redhat.com>, netdev@vger.kernel.org
Subject: [tip:tmp.tmp2 324/364] net/core/sock.c: linux/poll.h is included
 more than once.
Message-ID: <20210615011024.GO237458@shao2-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git tmp.tmp2
head:   adcceb5eb7aee38e4a9c15bdf599655f0e1b1324
commit: 35a241c0a90b26d9d234159ba6bab28fb5b5b490 [324/364] sched/headers, net: Uninline sock_poll_wait()
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


includecheck warnings: (new ones prefixed by >>)
>> net/core/sock.c: linux/poll.h is included more than once.

Please review and possibly fold the followup patch.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

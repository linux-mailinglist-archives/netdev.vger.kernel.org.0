Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69CF21BCCBA
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 21:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729150AbgD1Tun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 15:50:43 -0400
Received: from mga07.intel.com ([134.134.136.100]:9320 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728559AbgD1Tum (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 15:50:42 -0400
IronPort-SDR: 96rFOUP9Rqp1Xr2ec/E3MYI5i2BwiNvjwpzS5VqKQI4PApijhdw4nvS39ub+0vfrDwHI/P8o0R
 VXRHCc+8JBAA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2020 12:50:41 -0700
IronPort-SDR: GTYNg69nGgw8fjAn8quT7aUu8wxBewWfoX/bExzZ8Fm22cOIrDWJ0ZKxGKCZsGuqJH35yt2lnj
 kL6/HvFV/zkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,328,1583222400"; 
   d="scan'208";a="261207282"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 28 Apr 2020 12:50:39 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jTWFa-000Aja-Pu; Wed, 29 Apr 2020 03:50:38 +0800
Date:   Wed, 29 Apr 2020 03:49:55 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
Subject: Re: [PATCH bpf-next v1 10/19] bpf: add netlink and ipv6_route targets
Message-ID: <202004290302.TrXGQ81j%lkp@intel.com>
References: <20200427201246.2995471-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427201246.2995471-1-yhs@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yonghong,

I love your patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]
[also build test WARNING on bpf/master net/master vhost/linux-next net-next/master linus/master v5.7-rc3 next-20200428]
[cannot apply to ipvs/master]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Yonghong-Song/bpf-implement-bpf-iterator-for-kernel-data/20200428-115101
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-191-gc51a0382-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> net/netlink/af_netlink.c:2643:12: sparse: sparse: symbol '__bpf_iter__netlink' was not declared. Should it be static?
   net/netlink/af_netlink.c:2534:13: sparse: sparse: context imbalance in 'netlink_walk_start' - wrong count at exit
   net/netlink/af_netlink.c:2540:13: sparse: sparse: context imbalance in 'netlink_walk_stop' - unexpected unlock
   net/netlink/af_netlink.c:2576:13: sparse: sparse: context imbalance in 'netlink_seq_start' - wrong count at exit

Please review and possibly fold the followup patch.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

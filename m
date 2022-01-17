Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA9049107E
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 19:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241447AbiAQSzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 13:55:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:1175 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233202AbiAQSzq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jan 2022 13:55:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642445746; x=1673981746;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=6lVm6lLsjz6rqvT91yxdYMdAQWa98dgFJHffUpwMuAs=;
  b=Zl6/voHqYTY6Ov9y941pS9sjOVzzso+f9+cu7kZpks7dsOATbCSLRbvk
   gty/N7IxseGpkRmLUM+KwmC2lE9jXhVLEViSDVnSKg3NCRVgyyDMshDV1
   /OvwdpxRA7VvOQ32x9EtDpzYbPnBms2XRVT+2RGcXZG6G7R1t5CSycvqO
   dqY+oCOg4fjOJHcFcaua/MqQprnb6ZX+CzaxG28TuoOa9vcaEvRtGtOE3
   75TeqexBDcQMlel6UlfJoVW1cBRGumR7Nj9Lb7nZWmQVzmkpzZxb5+2b0
   9lregcOISpM5qbiy2t0FGu6fNSyfHel7WXAzbm57MKvFewYXXZbTAnfjD
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10230"; a="232035683"
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; 
   d="scan'208";a="232035683"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 10:55:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; 
   d="scan'208";a="578156706"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jan 2022 10:55:45 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n9XAO-000Bmh-Of; Mon, 17 Jan 2022 18:55:44 +0000
Date:   Tue, 18 Jan 2022 02:55:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Gal Pressman <gal@nvidia.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: [net:master 63/64] undefined reference to `__sk_defer_free_flush'
Message-ID: <202201180234.dBCoLWV3-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master
head:   9ea674d7ca4f6ce080b813ac2d9a9397f13d2427
commit: 79074a72d335dbd021a716d8cc65cba3b2f706ab [63/64] net: Flush deferred skb free on socket destroy
config: h8300-randconfig-r006-20220116 (https://download.01.org/0day-ci/archive/20220118/202201180234.dBCoLWV3-lkp@intel.com/config)
compiler: h8300-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=79074a72d335dbd021a716d8cc65cba3b2f706ab
        git remote add net https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
        git fetch --no-tags net master
        git checkout 79074a72d335dbd021a716d8cc65cba3b2f706ab
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=h8300 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   h8300-linux-ld: section .init.text LMA [0000000000466120,0000000000498245] overlaps section .text LMA [0000000000000280,0000000000f8ea7f]
   h8300-linux-ld: section .data VMA [0000000000400000,000000000046611f] overlaps section .text VMA [0000000000000280,0000000000f8ea7f]
   h8300-linux-ld: net/core/sock.o: in function `sk_destruct':
>> (.text+0x51f1): undefined reference to `__sk_defer_free_flush'

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

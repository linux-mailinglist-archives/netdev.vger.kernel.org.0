Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BB245A452
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 15:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbhKWOEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 09:04:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:22680 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234982AbhKWOEt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 09:04:49 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10176"; a="232516438"
X-IronPort-AV: E=Sophos;i="5.87,257,1631602800"; 
   d="scan'208";a="232516438"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 06:01:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,257,1631602800"; 
   d="scan'208";a="597092585"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by fmsmga002.fm.intel.com with ESMTP; 23 Nov 2021 06:01:39 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mpWMd-0001v4-48; Tue, 23 Nov 2021 14:01:39 +0000
Date:   Tue, 23 Nov 2021 22:00:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org
Subject: [net-next:master 20/31] net/ipv4/arp.c:1412:36: warning: unused
 variable 'arp_seq_ops'
Message-ID: <202111232112.j3yZPaVD-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   2106efda785b55a8957efed9a52dfa28ee0d7280
commit: e968b1b3e9b86c4751faea019a5d340fee9e9142 [20/31] arp: Remove #ifdef CONFIG_PROC_FS
config: hexagon-buildonly-randconfig-r006-20211123 (https://download.01.org/0day-ci/archive/20211123/202111232112.j3yZPaVD-lkp@intel.com/config.gz)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 49e3838145dff1ec91c2e67a2cb562775c8d2a08)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=e968b1b3e9b86c4751faea019a5d340fee9e9142
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch --no-tags net-next master
        git checkout e968b1b3e9b86c4751faea019a5d340fee9e9142
        # save the config file to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 ARCH=hexagon 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/ipv4/arp.c:1412:36: warning: unused variable 'arp_seq_ops' [-Wunused-const-variable]
   static const struct seq_operations arp_seq_ops = {
                                      ^
   1 warning generated.


vim +/arp_seq_ops +1412 net/ipv4/arp.c

^1da177e4c3f415 Linus Torvalds    2005-04-16  1411  
f690808e17925fc Stephen Hemminger 2007-03-12 @1412  static const struct seq_operations arp_seq_ops = {
^1da177e4c3f415 Linus Torvalds    2005-04-16  1413  	.start	= arp_seq_start,
^1da177e4c3f415 Linus Torvalds    2005-04-16  1414  	.next	= neigh_seq_next,
^1da177e4c3f415 Linus Torvalds    2005-04-16  1415  	.stop	= neigh_seq_stop,
^1da177e4c3f415 Linus Torvalds    2005-04-16  1416  	.show	= arp_seq_show,
^1da177e4c3f415 Linus Torvalds    2005-04-16  1417  };
^1da177e4c3f415 Linus Torvalds    2005-04-16  1418  

:::::: The code at line 1412 was first introduced by commit
:::::: f690808e17925fc45217eb22e8670902ecee5c1b [NET]: make seq_operations const

:::::: TO: Stephen Hemminger <shemminger@linux-foundation.org>
:::::: CC: David S. Miller <davem@sunset.davemloft.net>

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

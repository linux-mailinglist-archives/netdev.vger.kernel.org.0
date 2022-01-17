Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09F24911AB
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 23:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbiAQWTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 17:19:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:48097 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229783AbiAQWTv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jan 2022 17:19:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642457991; x=1673993991;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Ov1UX6sBHCPt5TWvK4Q04ZZjqgd30A878T+4krErDt8=;
  b=CPeAr/3gxIHXxmbnXAa1ZIqCB8OAhTqDnZj1thaLuvPZJJEpltzzxqET
   XqNykQ08EqUhMvmlkBzUfLD6gAzTvVbXnVT3/15cIQ8f0r4v/nxwfy6nl
   RlNfzzJHBuuwKiXf1Phn8GMSr6DS5C+TjJVWDaK/+g7OltsKK06Au9CxG
   Wn9Xx8S2hHlMRZ2IJE2lO/qP1rGW/SvZnSceZewFgzmigkwSHUu1o4quK
   /Lz/KceSXhCeiL7LnTGoafJKaJA+OPvN6Q8Swff0BJ1HIAobfiOlacP0w
   pPCoYVMLFzuev1tLQHxWOvKSLCoPj+9eEQ/tqVRZbis+MxDrWnU46rEM9
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10230"; a="244496738"
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; 
   d="scan'208";a="244496738"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 14:19:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; 
   d="scan'208";a="531490856"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 17 Jan 2022 14:19:50 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n9aLt-000Buk-PT; Mon, 17 Jan 2022 22:19:49 +0000
Date:   Tue, 18 Jan 2022 06:18:52 +0800
From:   kernel test robot <lkp@intel.com>
To:     Gal Pressman <gal@nvidia.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: [net:master 63/65] csky-linux-ld: sock.c:undefined reference to
 `__sk_defer_free_flush'
Message-ID: <202201180610.noKfNl47-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master
head:   5765cee119bf5a36c94d20eceb37c445508934be
commit: 79074a72d335dbd021a716d8cc65cba3b2f706ab [63/65] net: Flush deferred skb free on socket destroy
config: csky-randconfig-r035-20220117 (https://download.01.org/0day-ci/archive/20220118/202201180610.noKfNl47-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=79074a72d335dbd021a716d8cc65cba3b2f706ab
        git remote add net https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
        git fetch --no-tags net master
        git checkout 79074a72d335dbd021a716d8cc65cba3b2f706ab
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=csky SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   csky-linux-ld: net/core/sock.o: in function `sk_destruct':
   sock.c:(.text+0x1780): undefined reference to `__sk_defer_free_flush'
>> csky-linux-ld: sock.c:(.text+0x17c4): undefined reference to `__sk_defer_free_flush'

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

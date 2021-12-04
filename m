Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6892468218
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 04:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345320AbhLDDQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 22:16:56 -0500
Received: from mga17.intel.com ([192.55.52.151]:57035 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244657AbhLDDQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 22:16:56 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10187"; a="217778396"
X-IronPort-AV: E=Sophos;i="5.87,286,1631602800"; 
   d="scan'208";a="217778396"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 19:13:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,286,1631602800"; 
   d="scan'208";a="577743953"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 03 Dec 2021 19:13:29 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mtLUP-000INh-3b; Sat, 04 Dec 2021 03:13:29 +0000
Date:   Sat, 4 Dec 2021 11:13:24 +0800
From:   kernel test robot <lkp@intel.com>
To:     cgel.zte@gmail.com, davem@davemloft.net
Cc:     kbuild-all@lists.01.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhang Yunkai <zhang.yunkai@zte.com.cn>
Subject: Re: [PATCH linux-next] macvlan: judge ACCEPT_LOCAL before broadcast
Message-ID: <202112041109.HnEJ2McL-lkp@intel.com>
References: <20211203072515.345503-1-zhang.yunkai@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211203072515.345503-1-zhang.yunkai@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on next-20211202]

url:    https://github.com/0day-ci/linux/commits/cgel-zte-gmail-com/macvlan-judge-ACCEPT_LOCAL-before-broadcast/20211203-152701
base:    9606f9efb1cec7f8f5912326f182fbfbcad34382
config: arm-randconfig-c002-20211203 (https://download.01.org/0day-ci/archive/20211204/202112041109.HnEJ2McL-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/05cf69fa8abf1b7a7016dc8ee1adada1f80809b8
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review cgel-zte-gmail-com/macvlan-judge-ACCEPT_LOCAL-before-broadcast/20211203-152701
        git checkout 05cf69fa8abf1b7a7016dc8ee1adada1f80809b8
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arm-linux-gnueabi-ld: drivers/net/macvlan.o: in function `macvlan_broadcast':
>> macvlan.c:(.text+0x24a4): undefined reference to `in_dev_finish_destroy'
>> arm-linux-gnueabi-ld: macvlan.c:(.text+0x2618): undefined reference to `in_dev_finish_destroy'

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

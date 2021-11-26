Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33AF45EA30
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 10:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237279AbhKZJVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 04:21:24 -0500
Received: from mga03.intel.com ([134.134.136.65]:21447 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231935AbhKZJTX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 04:19:23 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10179"; a="235576428"
X-IronPort-AV: E=Sophos;i="5.87,265,1631602800"; 
   d="scan'208";a="235576428"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2021 01:15:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,265,1631602800"; 
   d="scan'208";a="607790551"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 26 Nov 2021 01:15:22 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mqXKD-0007t6-JZ; Fri, 26 Nov 2021 09:15:21 +0000
Date:   Fri, 26 Nov 2021 17:14:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        davem@davemloft.net
Cc:     kbuild-all@lists.01.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Subject: Re: [PATCH net-next 4/4] net: mvneta: Add TC traffic shaping offload
Message-ID: <202111261722.xQYnccxe-lkp@intel.com>
References: <20211125154813.579169-5-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125154813.579169-5-maxime.chevallier@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxime,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Maxime-Chevallier/net-mvneta-mqprio-cleanups-and-shaping-support/20211125-235035
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 305e95bb893cc50f7c59edf2b47d95effe73498a
config: arm-defconfig (https://download.01.org/0day-ci/archive/20211126/202111261722.xQYnccxe-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/789fe6c5e8c95ee076c1476c860591c00fa06555
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Maxime-Chevallier/net-mvneta-mqprio-cleanups-and-shaping-support/20211125-235035
        git checkout 789fe6c5e8c95ee076c1476c860591c00fa06555
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arm-linux-gnueabi-ld: drivers/net/ethernet/marvell/mvneta.o: in function `mvneta_setup_mqprio':
>> mvneta.c:(.text+0x2a3c): undefined reference to `__aeabi_uldivmod'

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

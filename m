Return-Path: <netdev+bounces-8191-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A2F1872309B
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 22:01:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1654E1C20D3B
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B45D224EBE;
	Mon,  5 Jun 2023 20:01:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3E02414D
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 20:01:25 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABF4FD
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685995284; x=1717531284;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=fT2guEvWUpPkUReyjtcCwFqtI9nShZWpy2Wk46k8D/A=;
  b=h7nHNUXFmMD7Yb+GtP3R6eru6XShoaFopr0fTLnHOPrPMkf3lhuqc124
   G92JV9YGpUc52lqVDxcXiCVaOtXgzcOWpBtd12606/v2lMcCaYPhlNXPc
   5CJRTRLodjKKRoBWalQhkU/kmQ7o2HpVt/whCVpT75CjGj3x+TAtcKkWR
   7eRFEisZGTRgT443XuRwjFqFlcQZMSiNy+8x7YadKLS1l8LValb1FN0Rw
   nnLKSRN8I88eSRq3i+EJ08Hjd8yVHySCjmVNkwGWpCZvdnkzGTrry3VnT
   GuoeMslSw2XyJ4obbTJmRxd0Sd0Tr+VTsmjgY3v9VEjtOK3OUs4TO/K6W
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="359782015"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="359782015"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 13:01:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="708783368"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="708783368"
Received: from lkp-server01.sh.intel.com (HELO 15ab08e44a81) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 05 Jun 2023 13:01:22 -0700
Received: from kbuild by 15ab08e44a81 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q6GOH-0004P9-1o;
	Mon, 05 Jun 2023 20:01:21 +0000
Date: Tue, 6 Jun 2023 04:00:31 +0800
From: kernel test robot <lkp@intel.com>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	Simon Horman <simon.horman@corigine.com>
Subject: [net-next:main 3/19] csky-linux-ld:
 drivers/net/ethernet/altera/altera_tse_main.c:1451: undefined reference to
 `lynx_pcs_destroy'
Message-ID: <202306060333.4xvu5BJd-lkp@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git main
head:   69da40ac3481993d6f599c98e84fcdbbf0bcd7e0
commit: db48abbaa18e571106711b42affe68ca6f36ca5a [3/19] net: ethernet: altera-tse: Convert to mdio-regmap and use PCS Lynx
config: csky-randconfig-r004-20230605 (https://download.01.org/0day-ci/archive/20230606/202306060333.4xvu5BJd-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 12.3.0
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=db48abbaa18e571106711b42affe68ca6f36ca5a
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch --no-tags net-next main
        git checkout db48abbaa18e571106711b42affe68ca6f36ca5a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=csky olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=csky SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306060333.4xvu5BJd-lkp@intel.com/

All errors (new ones prefixed by >>):

   csky-linux-ld: drivers/net/ethernet/altera/altera_tse_main.o: in function `altera_tse_remove':
   drivers/net/ethernet/altera/altera_tse_main.c:1473: undefined reference to `lynx_pcs_destroy'
   csky-linux-ld: drivers/net/ethernet/altera/altera_tse_main.o: in function `reset_mac':
   drivers/net/ethernet/altera/altera_tse_main.c:687: undefined reference to `lynx_pcs_destroy'
   csky-linux-ld: drivers/net/ethernet/altera/altera_tse_main.o: in function `altera_tse_probe':
   drivers/net/ethernet/altera/altera_tse_main.c:1419: undefined reference to `lynx_pcs_create_mdiodev'
>> csky-linux-ld: drivers/net/ethernet/altera/altera_tse_main.c:1451: undefined reference to `lynx_pcs_destroy'
>> csky-linux-ld: drivers/net/ethernet/altera/altera_tse_main.c:1456: undefined reference to `lynx_pcs_create_mdiodev'
   csky-linux-ld: drivers/net/ethernet/altera/altera_tse_main.c:1456: undefined reference to `lynx_pcs_destroy'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


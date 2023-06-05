Return-Path: <netdev+bounces-8185-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D858722FCB
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:28:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD516281202
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:28:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF59724E8A;
	Mon,  5 Jun 2023 19:28:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D111D2260B
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:28:26 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4BAE8
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685993305; x=1717529305;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=AFD+y5if85TAm808QiIwk2oVqtc5sYk/jdKDDIr/qqw=;
  b=RXhRtsKDvsLMpQ7mm3UPQilXXZmpQZjsWtwd/9facLc4+J3g8D5YJCpZ
   ufsbzknNtC5b5vMHgluE0k/9vPhe+l44Dy9G0GNtrqiyDWofdZbnY02Rf
   vJAfgr5cIuPmEEMv2C9awc5riaiyQ0YIEw5ht0MJBP60y3h3kjF26Y8nW
   tdSpvmonXb2N9Hycj/ZcS9gETB2v3pq9qvx5WiR5mAofb58lIpXF5Onkc
   3E+JZwH2hBBEXniawz06+QC1Gf6wSVtlg5p8MIGFLXT/0rF8Eorbbn1kM
   Z2KK3yZXfmur6ZOEFpN+EmqW3YCwt3ZMDREY0D2vqkeLlOzBq4c6GBV2C
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="341098723"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="341098723"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 12:28:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="798552339"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="798552339"
Received: from lkp-server01.sh.intel.com (HELO 15ab08e44a81) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Jun 2023 12:28:21 -0700
Received: from kbuild by 15ab08e44a81 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q6FsK-0004OB-2h;
	Mon, 05 Jun 2023 19:28:20 +0000
Date: Tue, 6 Jun 2023 03:28:05 +0800
From: kernel test robot <lkp@intel.com>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	Simon Horman <simon.horman@corigine.com>
Subject: [net-next:main 5/19] ERROR: modpost: "lynx_pcs_destroy"
 [drivers/net/ethernet/stmicro/stmmac/stmmac.ko] undefined!
Message-ID: <202306060326.B8HGnS3V-lkp@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git main
head:   69da40ac3481993d6f599c98e84fcdbbf0bcd7e0
commit: 5d1f3fe7d2d54d04b44aa5b9b62b305fdcf653ec [5/19] net: stmmac: dwmac-sogfpga: use the lynx pcs driver
config: riscv-rv32_defconfig (https://download.01.org/0day-ci/archive/20230606/202306060326.B8HGnS3V-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 12.3.0
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=5d1f3fe7d2d54d04b44aa5b9b62b305fdcf653ec
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch --no-tags net-next main
        git checkout 5d1f3fe7d2d54d04b44aa5b9b62b305fdcf653ec
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=riscv olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306060326.B8HGnS3V-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "lynx_pcs_destroy" [drivers/net/ethernet/stmicro/stmmac/stmmac.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


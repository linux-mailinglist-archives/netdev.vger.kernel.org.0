Return-Path: <netdev+bounces-8265-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57F04723591
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 05:01:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD58E2814E6
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 03:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9CC9394;
	Tue,  6 Jun 2023 03:01:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF56D635
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 03:01:45 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369691B8
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 20:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686020504; x=1717556504;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=OFHb0QArF8tl2a80Bq8oJ/Rc9e+y8vmzJK8AhdywsYc=;
  b=ex1IAHw0016spsdv5mYmZsEDmWmGUwX689s0ug7dc8+TzHYCsjJ9bk+g
   GUoiZl/DUqdP2F2Nyuo3VdGYGLpAfD9/HjjQCnHZiGqxa3MfiE5RTlQKm
   6M38UJKyNvIqJzRz5fknuTX9hskGtpZ8Ufsp5JWLf7/Z8xU+egG+z9JMd
   0r+pFLZc1/aJ3rckNri2zbJEaMg9HBMeRgrsRyOwX+kDnFCO7NaNkP7MV
   RT5rzGtCIqoP8UZA9OFvD3JZoUAPQ2tQsNElI6OZpUreHAmGH9Wb8wpqx
   swKUE6rI3+f0XRbXn8FoHJnx3J8v6+kXaCE4kY/zPhDDcQv5HwY1ggZJR
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="336904692"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="336904692"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 20:01:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="708901732"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="708901732"
Received: from lkp-server01.sh.intel.com (HELO 15ab08e44a81) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 05 Jun 2023 20:01:42 -0700
Received: from kbuild by 15ab08e44a81 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q6Mx3-0004kf-1n;
	Tue, 06 Jun 2023 03:01:41 +0000
Date: Tue, 6 Jun 2023 11:01:01 +0800
From: kernel test robot <lkp@intel.com>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	Simon Horman <simon.horman@corigine.com>
Subject: [net-next:main 5/19]
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c:669: undefined reference
 to `lynx_pcs_destroy'
Message-ID: <202306061016.ZObwe4Oh-lkp@intel.com>
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
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git main
head:   28cfea989d6f55c3d10608eba2a2bae609c5bf3e
commit: 5d1f3fe7d2d54d04b44aa5b9b62b305fdcf653ec [5/19] net: stmmac: dwmac-sogfpga: use the lynx pcs driver
config: x86_64-randconfig-x066-20230605 (https://download.01.org/0day-ci/archive/20230606/202306061016.ZObwe4Oh-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build):
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=5d1f3fe7d2d54d04b44aa5b9b62b305fdcf653ec
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch --no-tags net-next main
        git checkout 5d1f3fe7d2d54d04b44aa5b9b62b305fdcf653ec
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306061016.ZObwe4Oh-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: drivers/net/ethernet/altera/altera_tse_main.o: in function `altera_tse_remove':
   drivers/net/ethernet/altera/altera_tse_main.c:1473: undefined reference to `lynx_pcs_destroy'
   ld: drivers/net/ethernet/altera/altera_tse_main.o: in function `altera_tse_probe':
   drivers/net/ethernet/altera/altera_tse_main.c:1419: undefined reference to `lynx_pcs_create_mdiodev'
   ld: drivers/net/ethernet/altera/altera_tse_main.c:1451: undefined reference to `lynx_pcs_destroy'
   ld: drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.o: in function `stmmac_mdio_unregister':
>> drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c:669: undefined reference to `lynx_pcs_destroy'


vim +669 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c

   652	
   653	/**
   654	 * stmmac_mdio_unregister
   655	 * @ndev: net device structure
   656	 * Description: it unregisters the MII bus
   657	 */
   658	int stmmac_mdio_unregister(struct net_device *ndev)
   659	{
   660		struct stmmac_priv *priv = netdev_priv(ndev);
   661	
   662		if (!priv->mii)
   663			return 0;
   664	
   665		if (priv->hw->xpcs)
   666			xpcs_destroy(priv->hw->xpcs);
   667	
   668		if (priv->hw->lynx_pcs)
 > 669			lynx_pcs_destroy(priv->hw->lynx_pcs);

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


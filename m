Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7995651C10B
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379786AbiEENqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379771AbiEENqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:46:01 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7227757158;
        Thu,  5 May 2022 06:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651758141; x=1683294141;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Klh2w7LNZv2eWeVfq9/1/u2/n898gwlGd/zAyuhv2Ck=;
  b=D6HB/XyINBWflW+0U3NVPO4hEX9hL9QEQG8adrCWWHPxjLTmIF2D492L
   qvl/wOvGQu9oG7zuBvTJlrZj2GUNlgDEaHXYYCoukhe1aoxrDacdiD0Qc
   7Ge4f7xN5X0hba/bW3FEFXW0S/4NCo0NlQmq7n55uLLFzGPAByWQ0fwgQ
   01lCNzdeKdCwLVzuVEceVOz9vwHl+Dp1zJC8yNjg6sVNTs/ewbw+sV4sJ
   osGr5tCByFjkamInAS24ZbGfjLycVafM9d1noZ5Gw0cxIwXfPZZw7dJVK
   kCCX5NvDNHiRmIS9SRqdxQLjCpUTuEjBKzCPxnwPWUzIRjqQTZGIaozLT
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248019615"
X-IronPort-AV: E=Sophos;i="5.91,201,1647327600"; 
   d="scan'208";a="248019615"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 06:42:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,201,1647327600"; 
   d="scan'208";a="708942820"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 05 May 2022 06:42:18 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nmbkH-000CR9-R7;
        Thu, 05 May 2022 13:42:17 +0000
Date:   Thu, 5 May 2022 21:41:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/7] net: phy: introduce
 genphy_c45_pma_baset1_read_master_slave()
Message-ID: <202205052146.y8znPT8Q-lkp@intel.com>
References: <20220505063318.296280-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505063318.296280-5-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Oleksij-Rempel/add-ti-dp83td510-support/20220505-143922
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 4950b6990e3b1efae64a5f6fc5738d25e3b816b3
config: x86_64-randconfig-a016 (https://download.01.org/0day-ci/archive/20220505/202205052146.y8znPT8Q-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 5e004fb787698440a387750db7f8028e7cb14cfc)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/80dad43edb356876484acb116b8a906dd4bef941
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Oleksij-Rempel/add-ti-dp83td510-support/20220505-143922
        git checkout 80dad43edb356876484acb116b8a906dd4bef941
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/phy/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/phy/phy-c45.c:558: warning: expecting prototype for genphy_c45_baset1_read_master_slave(). Prototype was for genphy_c45_pma_baset1_read_master_slave() instead


vim +558 drivers/net/phy/phy-c45.c

   552	
   553	/**
   554	 * genphy_c45_baset1_read_master_slave - read forced master/slave configuration
   555	 * @phydev: target phy_device struct
   556	 */
   557	int genphy_c45_pma_baset1_read_master_slave(struct phy_device *phydev)
 > 558	{
   559		int val;
   560	
   561		phydev->master_slave_state = MASTER_SLAVE_STATE_UNKNOWN;
   562	
   563		val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_PMD_BT1_CTRL);
   564		if (val < 0)
   565			return val;
   566	
   567		if (val & MDIO_PMA_PMD_BT1_CTRL_CFG_MST)
   568			phydev->master_slave_state = MASTER_SLAVE_STATE_MASTER;
   569		else
   570			phydev->master_slave_state = MASTER_SLAVE_STATE_SLAVE;
   571	
   572		return 0;
   573	}
   574	EXPORT_SYMBOL_GPL(genphy_c45_pma_baset1_read_master_slave);
   575	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

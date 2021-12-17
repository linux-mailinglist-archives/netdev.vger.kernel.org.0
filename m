Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CB34783AA
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 04:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbhLQDdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 22:33:39 -0500
Received: from mga04.intel.com ([192.55.52.120]:46469 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232444AbhLQDdj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 22:33:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639712019; x=1671248019;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Tajfqun6szNw9LJdTzsf45Rc7oxTwt5fDuRrO2dd1No=;
  b=ZV6ntsyGr90g0fnFjO0Ph2ycksiekdxqrBeOJeuWThDxcx2Ha8l8Olyd
   +4SOEtDuvvs45gaVpE7+wmSz7bh0J4MrPgK9+VcydkYtJSWl5Hc1fOnhW
   3hDOKjyJ4Sn1+Uc6mt/EdwUjbpByA2I4w3tiRRLYcdeQOStX8Nb77xlCN
   PTIcQNT06lvJ5CJPjuh4SuGPwany3Ohks2pyLrUs/AeXUkAAo/NRAFDwj
   crLDSfne9Y38vvHaj3wnxhjLHL9SxQZOSRVSs5htfv3odHen0tXtTL94/
   uh7PsnofOTwY9I5jHrX2Bf9hl4uk/H/mg6f+9PLHpa3xlrOm+CSO7mGf7
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="238413120"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="238413120"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 19:33:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="464970411"
Received: from lkp-server02.sh.intel.com (HELO 9f38c0981d9f) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 16 Dec 2021 19:33:35 -0800
Received: from kbuild by 9f38c0981d9f with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1my3zz-0004Av-1v; Fri, 17 Dec 2021 03:33:35 +0000
Date:   Fri, 17 Dec 2021 11:33:20 +0800
From:   kernel test robot <lkp@intel.com>
To:     luizluca@gmail.com, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: Re: [PATCH net-next 08/13] net: dsa: realtek: add new mdio interface
 for drivers
Message-ID: <202112171150.GzuAOv0N-lkp@intel.com>
References: <20211216201342.25587-9-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216201342.25587-9-luizluca@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/luizluca-gmail-com/net-dsa-realtek-MDIO-interface-and-RTL8367S/20211217-041735
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 0f473bb6ed2d0b8533a079ee133f625f83de5315
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20211217/202112171150.GzuAOv0N-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/15bfe75ad3669cdcef7bfab281d7744c226fc503
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review luizluca-gmail-com/net-dsa-realtek-MDIO-interface-and-RTL8367S/20211217-041735
        git checkout 15bfe75ad3669cdcef7bfab281d7744c226fc503
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arc SHELL=/bin/bash drivers/net/dsa/realtek/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/dsa/realtek/realtek-mdio.c:54:5: warning: no previous prototype for 'realtek_mdio_read_reg' [-Wmissing-prototypes]
      54 | int realtek_mdio_read_reg(struct realtek_priv *priv, u32 addr, u32 *data)
         |     ^~~~~~~~~~~~~~~~~~~~~


vim +/realtek_mdio_read_reg +54 drivers/net/dsa/realtek/realtek-mdio.c

    53	
  > 54	int realtek_mdio_read_reg(struct realtek_priv *priv, u32 addr, u32 *data)
    55	{
    56	        u32 phy_id = priv->phy_id;
    57		struct mii_bus *bus = priv->bus;
    58	
    59	        BUG_ON(in_interrupt());
    60	
    61	        mutex_lock(&bus->mdio_lock);
    62	        /* Write Start command to register 29 */
    63	        bus->write(bus, phy_id, MDC_MDIO_START_REG, MDC_MDIO_START_OP);
    64	
    65	        /* Write address control code to register 31 */
    66	        bus->write(bus, phy_id, MDC_MDIO_CTRL0_REG, MDC_MDIO_ADDR_OP);
    67	
    68	        /* Write Start command to register 29 */
    69	        bus->write(bus, phy_id, MDC_MDIO_START_REG, MDC_MDIO_START_OP);
    70	
    71	        /* Write address to register 23 */
    72	        bus->write(bus, phy_id, MDC_MDIO_ADDRESS_REG, addr);
    73	
    74	        /* Write Start command to register 29 */
    75	        bus->write(bus, phy_id, MDC_MDIO_START_REG, MDC_MDIO_START_OP);
    76	
    77	        /* Write read control code to register 21 */
    78	        bus->write(bus, phy_id, MDC_MDIO_CTRL1_REG, MDC_MDIO_READ_OP);
    79	
    80	        /* Write Start command to register 29 */
    81	        bus->write(bus, phy_id, MDC_MDIO_START_REG, MDC_MDIO_START_OP);
    82	
    83	        /* Read data from register 25 */
    84	        *data = bus->read(bus, phy_id, MDC_MDIO_DATA_READ_REG);
    85	
    86	        mutex_unlock(&bus->mdio_lock);
    87	
    88	        return 0;
    89	}
    90	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C9B6BDBD2
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 23:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjCPWiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 18:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjCPWit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 18:38:49 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CA510C2
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 15:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679006327; x=1710542327;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=j1fmTxkC1CxWeWvPfsAJQ45SiyiioD+JZSudxc6rsM0=;
  b=NLlQEuLMKGspw3PTEEYH984FGe3eI8Mp/pb/R6n1vSJYUoqZc67WBJia
   Bi2M3fPh8T4R9bAnP9ZYjJ/V5mka+8tMoPjzE+ZETqaPLS0Xgc7Mf4Ml2
   jLlvKuVavwS0PAEGtOlL4+XxfwBQP/xctbFKP5Dn3uKzXPxFpquPLz+eA
   w7XrXgE3zAj9cPS+86HdU7/fyX1WlbD7waPvZEYRs6pBirsu1ZfKIm6pv
   wVK5AAkEIsQBNuKf42/60WPglgjgTyAhqeA9xtEV8ZmWSwF+yPOY3KuMj
   E33PPDdAj9KDzHZYST/LMVolN70DU0LjlcibfOhwOrVyQaPwYkUwbft1b
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="338143572"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="338143572"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 15:38:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="790492028"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="790492028"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 16 Mar 2023 15:38:46 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pcwFB-0008sA-1g;
        Thu, 16 Mar 2023 22:38:45 +0000
Date:   Fri, 17 Mar 2023 06:38:02 +0800
From:   kernel test robot <lkp@intel.com>
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] net: mdio: fix owner field for mdio buses registered
 using device-tree
Message-ID: <202303170623.MPjYVWU5-lkp@intel.com>
References: <20230316205301.2087667-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316205301.2087667-2-f.fainelli@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net/main]
[also build test WARNING on net-next/main horms-ipvs/master linus/master v6.3-rc2 next-20230316]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Florian-Fainelli/net-mdio-fix-owner-field-for-mdio-buses-registered-using-device-tree/20230317-050628
patch link:    https://lore.kernel.org/r/20230316205301.2087667-2-f.fainelli%40gmail.com
patch subject: [PATCH 1/2] net: mdio: fix owner field for mdio buses registered using device-tree
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20230317/202303170623.MPjYVWU5-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/1449da923a3f5684696a0e559f7e7a970aa025ae
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Florian-Fainelli/net-mdio-fix-owner-field-for-mdio-buses-registered-using-device-tree/20230317-050628
        git checkout 1449da923a3f5684696a0e559f7e7a970aa025ae
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash drivers/net/mdio/ drivers/net/phy/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303170623.MPjYVWU5-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/net/mdio/of_mdio.c:151: warning: Function parameter or member 'owner' not described in '__of_mdiobus_register'
>> drivers/net/mdio/of_mdio.c:151: warning: expecting prototype for of_mdiobus_register(). Prototype was for __of_mdiobus_register() instead
--
   drivers/net/phy/mdio_devres.c:108: warning: Function parameter or member 'owner' not described in '__devm_of_mdiobus_register'
>> drivers/net/phy/mdio_devres.c:108: warning: expecting prototype for devm_of_mdiobus_register(). Prototype was for __devm_of_mdiobus_register() instead


vim +151 drivers/net/mdio/of_mdio.c

801a8ef54e8b21 drivers/of/of_mdio.c       Andrew Lunn           2016-01-06  140  
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25  141  /**
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25  142   * of_mdiobus_register - Register mii_bus and create PHYs from the device tree
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25  143   * @mdio: pointer to mii_bus structure
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25  144   * @np: pointer to device_node of MDIO bus.
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25  145   *
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25  146   * This function registers the mii_bus structure and registers a phy_device
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25  147   * for each child node of @np.
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25  148   */
1449da923a3f56 drivers/net/mdio/of_mdio.c Maxime Bizon          2023-03-16  149  int __of_mdiobus_register(struct mii_bus *mdio, struct device_node *np,
1449da923a3f56 drivers/net/mdio/of_mdio.c Maxime Bizon          2023-03-16  150  			  struct module *owner)
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25 @151  {
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25  152  	struct device_node *child;
2e79cb303010d5 drivers/of/of_mdio.c       Florian Fainelli      2013-12-05  153  	bool scanphys = false;
e7f4dc3536a400 drivers/of/of_mdio.c       Andrew Lunn           2016-01-06  154  	int addr, rc;
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25  155  
6d07a68a59274f drivers/of/of_mdio.c       Florian Fainelli      2018-05-15  156  	if (!np)
1449da923a3f56 drivers/net/mdio/of_mdio.c Maxime Bizon          2023-03-16  157  		return __mdiobus_register(mdio, owner);
6d07a68a59274f drivers/of/of_mdio.c       Florian Fainelli      2018-05-15  158  
a77f4f70fd34ac drivers/of/of_mdio.c       Florian Fainelli      2016-04-28  159  	/* Do not continue if the node is disabled */
a77f4f70fd34ac drivers/of/of_mdio.c       Florian Fainelli      2016-04-28  160  	if (!of_device_is_available(np))
a77f4f70fd34ac drivers/of/of_mdio.c       Florian Fainelli      2016-04-28  161  		return -ENODEV;
a77f4f70fd34ac drivers/of/of_mdio.c       Florian Fainelli      2016-04-28  162  
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25  163  	/* Mask out all PHYs from auto probing.  Instead the PHYs listed in
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25  164  	 * the device tree are populated after the bus has been registered */
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25  165  	mdio->phy_mask = ~0;
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25  166  
7e33d84db1a8a6 drivers/net/mdio/of_mdio.c Ioana Ciornei         2021-06-17  167  	device_set_node(&mdio->dev, of_fwnode_handle(np));
25106022002128 drivers/of/of_mdio.c       David Daney           2012-05-02  168  
69226896ad636b drivers/of/of_mdio.c       Roger Quadros         2017-04-21  169  	/* Get bus level PHY reset GPIO details */
69226896ad636b drivers/of/of_mdio.c       Roger Quadros         2017-04-21  170  	mdio->reset_delay_us = DEFAULT_GPIO_RESET_DELAY;
69226896ad636b drivers/of/of_mdio.c       Roger Quadros         2017-04-21  171  	of_property_read_u32(np, "reset-delay-us", &mdio->reset_delay_us);
bb3831294cd507 drivers/of/of_mdio.c       Bruno Thomsen         2020-07-30  172  	mdio->reset_post_delay_us = 0;
bb3831294cd507 drivers/of/of_mdio.c       Bruno Thomsen         2020-07-30  173  	of_property_read_u32(np, "reset-post-delay-us", &mdio->reset_post_delay_us);
69226896ad636b drivers/of/of_mdio.c       Roger Quadros         2017-04-21  174  
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25  175  	/* Register the MDIO bus */
1449da923a3f56 drivers/net/mdio/of_mdio.c Maxime Bizon          2023-03-16  176  	rc = __mdiobus_register(mdio, owner);
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25  177  	if (rc)
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25  178  		return rc;
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25  179  
801a8ef54e8b21 drivers/of/of_mdio.c       Andrew Lunn           2016-01-06  180  	/* Loop over the child nodes and register a phy_device for each phy */
e207e7619cc9be drivers/of/of_mdio.c       Alexander Sverdlin    2012-11-29  181  	for_each_available_child_of_node(np, child) {
8f8382888cbaf6 drivers/of/of_mdio.c       Daniel Mack           2014-05-24  182  		addr = of_mdio_parse_addr(&mdio->dev, child);
8f8382888cbaf6 drivers/of/of_mdio.c       Daniel Mack           2014-05-24  183  		if (addr < 0) {
779d835e7eee11 drivers/of/of_mdio.c       Sebastian Hesselbarth 2013-04-07  184  			scanphys = true;
194588604765ac drivers/of/of_mdio.c       David Daney           2010-10-27  185  			continue;
194588604765ac drivers/of/of_mdio.c       David Daney           2010-10-27  186  		}
194588604765ac drivers/of/of_mdio.c       David Daney           2010-10-27  187  
801a8ef54e8b21 drivers/of/of_mdio.c       Andrew Lunn           2016-01-06  188  		if (of_mdiobus_child_is_phy(child))
66bdede495c71d drivers/of/of_mdio.c       Geert Uytterhoeven    2017-10-18  189  			rc = of_mdiobus_register_phy(mdio, child, addr);
a9049e0c513c45 drivers/of/of_mdio.c       Andrew Lunn           2016-01-06  190  		else
66bdede495c71d drivers/of/of_mdio.c       Geert Uytterhoeven    2017-10-18  191  			rc = of_mdiobus_register_device(mdio, child, addr);
95f566de0269a0 drivers/of/of_mdio.c       Madalin Bucur         2018-01-09  192  
95f566de0269a0 drivers/of/of_mdio.c       Madalin Bucur         2018-01-09  193  		if (rc == -ENODEV)
95f566de0269a0 drivers/of/of_mdio.c       Madalin Bucur         2018-01-09  194  			dev_err(&mdio->dev,
95f566de0269a0 drivers/of/of_mdio.c       Madalin Bucur         2018-01-09  195  				"MDIO device at address %d is missing.\n",
95f566de0269a0 drivers/of/of_mdio.c       Madalin Bucur         2018-01-09  196  				addr);
95f566de0269a0 drivers/of/of_mdio.c       Madalin Bucur         2018-01-09  197  		else if (rc)
66bdede495c71d drivers/of/of_mdio.c       Geert Uytterhoeven    2017-10-18  198  			goto unregister;
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25  199  	}
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25  200  
779d835e7eee11 drivers/of/of_mdio.c       Sebastian Hesselbarth 2013-04-07  201  	if (!scanphys)
779d835e7eee11 drivers/of/of_mdio.c       Sebastian Hesselbarth 2013-04-07  202  		return 0;
779d835e7eee11 drivers/of/of_mdio.c       Sebastian Hesselbarth 2013-04-07  203  
779d835e7eee11 drivers/of/of_mdio.c       Sebastian Hesselbarth 2013-04-07  204  	/* auto scan for PHYs with empty reg property */
779d835e7eee11 drivers/of/of_mdio.c       Sebastian Hesselbarth 2013-04-07  205  	for_each_available_child_of_node(np, child) {
779d835e7eee11 drivers/of/of_mdio.c       Sebastian Hesselbarth 2013-04-07  206  		/* Skip PHYs with reg property set */
2fca6d288d7cac drivers/of/of_mdio.c       Sergei Shtylyov       2016-02-28  207  		if (of_find_property(child, "reg", NULL))
779d835e7eee11 drivers/of/of_mdio.c       Sebastian Hesselbarth 2013-04-07  208  			continue;
779d835e7eee11 drivers/of/of_mdio.c       Sebastian Hesselbarth 2013-04-07  209  
779d835e7eee11 drivers/of/of_mdio.c       Sebastian Hesselbarth 2013-04-07  210  		for (addr = 0; addr < PHY_MAX_ADDR; addr++) {
779d835e7eee11 drivers/of/of_mdio.c       Sebastian Hesselbarth 2013-04-07  211  			/* skip already registered PHYs */
7f854420fbfe9d drivers/of/of_mdio.c       Andrew Lunn           2016-01-06  212  			if (mdiobus_is_registered_device(mdio, addr))
779d835e7eee11 drivers/of/of_mdio.c       Sebastian Hesselbarth 2013-04-07  213  				continue;
779d835e7eee11 drivers/of/of_mdio.c       Sebastian Hesselbarth 2013-04-07  214  
779d835e7eee11 drivers/of/of_mdio.c       Sebastian Hesselbarth 2013-04-07  215  			/* be noisy to encourage people to set reg property */
a613b26a50136a drivers/of/of_mdio.c       Rob Herring           2018-08-27  216  			dev_info(&mdio->dev, "scan phy %pOFn at address %i\n",
a613b26a50136a drivers/of/of_mdio.c       Rob Herring           2018-08-27  217  				 child, addr);
779d835e7eee11 drivers/of/of_mdio.c       Sebastian Hesselbarth 2013-04-07  218  
66bdede495c71d drivers/of/of_mdio.c       Geert Uytterhoeven    2017-10-18  219  			if (of_mdiobus_child_is_phy(child)) {
5a8d7f126c97d0 drivers/of/of_mdio.c       Florian Fainelli      2020-06-19  220  				/* -ENODEV is the return code that PHYLIB has
5a8d7f126c97d0 drivers/of/of_mdio.c       Florian Fainelli      2020-06-19  221  				 * standardized on to indicate that bus
5a8d7f126c97d0 drivers/of/of_mdio.c       Florian Fainelli      2020-06-19  222  				 * scanning should continue.
5a8d7f126c97d0 drivers/of/of_mdio.c       Florian Fainelli      2020-06-19  223  				 */
66bdede495c71d drivers/of/of_mdio.c       Geert Uytterhoeven    2017-10-18  224  				rc = of_mdiobus_register_phy(mdio, child, addr);
5a8d7f126c97d0 drivers/of/of_mdio.c       Florian Fainelli      2020-06-19  225  				if (!rc)
209c65b61d9434 drivers/of/of_mdio.c       Dajun Jin             2020-03-02  226  					break;
5a8d7f126c97d0 drivers/of/of_mdio.c       Florian Fainelli      2020-06-19  227  				if (rc != -ENODEV)
5a8d7f126c97d0 drivers/of/of_mdio.c       Florian Fainelli      2020-06-19  228  					goto unregister;
66bdede495c71d drivers/of/of_mdio.c       Geert Uytterhoeven    2017-10-18  229  			}
779d835e7eee11 drivers/of/of_mdio.c       Sebastian Hesselbarth 2013-04-07  230  		}
779d835e7eee11 drivers/of/of_mdio.c       Sebastian Hesselbarth 2013-04-07  231  	}
779d835e7eee11 drivers/of/of_mdio.c       Sebastian Hesselbarth 2013-04-07  232  
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25  233  	return 0;
66bdede495c71d drivers/of/of_mdio.c       Geert Uytterhoeven    2017-10-18  234  
66bdede495c71d drivers/of/of_mdio.c       Geert Uytterhoeven    2017-10-18  235  unregister:
1c48709e6d9d35 drivers/net/mdio/of_mdio.c Liang He              2022-09-13  236  	of_node_put(child);
66bdede495c71d drivers/of/of_mdio.c       Geert Uytterhoeven    2017-10-18  237  	mdiobus_unregister(mdio);
66bdede495c71d drivers/of/of_mdio.c       Geert Uytterhoeven    2017-10-18  238  	return rc;
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25  239  }
1449da923a3f56 drivers/net/mdio/of_mdio.c Maxime Bizon          2023-03-16  240  EXPORT_SYMBOL(__of_mdiobus_register);
8bc487d150b939 drivers/of/of_mdio.c       Grant Likely          2009-04-25  241  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

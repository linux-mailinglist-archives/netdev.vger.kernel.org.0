Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFA3F4F4495
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352579AbiDEUDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573185AbiDESNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 14:13:31 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBA786E36;
        Tue,  5 Apr 2022 11:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649182291; x=1680718291;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oxPQbPe4XPubEIZ9VBAYgBlsoGlrAVDbxPfSfEgWaik=;
  b=LfSxmPxROu31CFUZmczCwD6nc/o1ArszMxKtTv5n84YIScGgf3yaeOeX
   v1oEOTqOW7Y7r04slza/bMD2zaHzTth7mRw2QpvXeJHC81rJngLeBKgzo
   dfdJJD7a6+TeFgg33lG5YZiOGrCDdO6TiK/O8QLY3VFX1vxNFBM6wDpzZ
   +pJn8De0iKr4nxC/3yJKpppo8KdvBvg34/0jQI4Yen+s5ntnYIjTEFW4U
   8hrwIQ6gaaArZ7RMgxJe9RPBuxQUjQqylwz/o8hYaYYWvHmrFHIEWIMr2
   DaH7LJ/QJO9HkZqqO7dC8gwNvEr2dfa+0XGPg1aLubYSZH+rcG7mt1h0w
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="241415947"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="241415947"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 11:11:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="658050302"
Received: from lkp-server02.sh.intel.com (HELO a44fdfb70b94) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 05 Apr 2022 11:11:25 -0700
Received: from kbuild by a44fdfb70b94 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nbneG-0003eR-Qg;
        Tue, 05 Apr 2022 18:11:24 +0000
Date:   Wed, 6 Apr 2022 02:11:06 +0800
From:   kernel test robot <lkp@intel.com>
To:     Wells Lu <wellslutw@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de, pabeni@redhat.com, krzk+dt@kernel.org,
        roopa@nvidia.com, andrew@lunn.ch, edumazet@google.com
Cc:     kbuild-all@lists.01.org, wells.lu@sunplus.com,
        Wells Lu <wellslutw@gmail.com>
Subject: Re: [PATCH net-next v6 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Message-ID: <202204060205.cewHqDER-lkp@intel.com>
References: <1649016459-23989-3-git-send-email-wellslutw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1649016459-23989-3-git-send-email-wellslutw@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wells,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net/master]
[also build test WARNING on robh/for-next linus/master v5.18-rc1 next-20220405]
[cannot apply to net-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Wells-Lu/This-is-a-patch-series-for-Ethernet-driver-of-Sunplus-SP7021-SoC/20220404-040949
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 692930cc435099580a4b9e32fa781b0688c18439
config: alpha-randconfig-c004-20220405 (https://download.01.org/0day-ci/archive/20220406/202204060205.cewHqDER-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/d8d2085594ea52869669a553bb6d60e0b3a1f412
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Wells-Lu/This-is-a-patch-series-for-Ethernet-driver-of-Sunplus-SP7021-SoC/20220404-040949
        git checkout d8d2085594ea52869669a553bb6d60e0b3a1f412
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=alpha SHELL=/bin/bash drivers/net/ethernet/sunplus/ drivers/pinctrl/sunplus/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/sunplus/spl2sw_driver.c: In function 'spl2sw_get_eth_child_node':
   drivers/net/ethernet/sunplus/spl2sw_driver.c:328:9: error: implicit declaration of function 'for_each_child_of_node'; did you mean 'for_each_online_node'? [-Werror=implicit-function-declaration]
     328 |         for_each_child_of_node(ether_np, port_np) {
         |         ^~~~~~~~~~~~~~~~~~~~~~
         |         for_each_online_node
   drivers/net/ethernet/sunplus/spl2sw_driver.c:328:50: error: expected ';' before '{' token
     328 |         for_each_child_of_node(ether_np, port_np) {
         |                                                  ^~
         |                                                  ;
   drivers/net/ethernet/sunplus/spl2sw_driver.c:326:13: warning: unused variable 'port_id' [-Wunused-variable]
     326 |         int port_id;
         |             ^~~~~~~
   drivers/net/ethernet/sunplus/spl2sw_driver.c:342:1: error: no return statement in function returning non-void [-Werror=return-type]
     342 | }
         | ^
   drivers/net/ethernet/sunplus/spl2sw_driver.c: In function 'spl2sw_probe':
   drivers/net/ethernet/sunplus/spl2sw_driver.c:407:24: error: implicit declaration of function 'of_get_child_by_name' [-Werror=implicit-function-declaration]
     407 |         eth_ports_np = of_get_child_by_name(pdev->dev.of_node, "ethernet-ports");
         |                        ^~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/sunplus/spl2sw_driver.c:407:22: warning: assignment to 'struct device_node *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     407 |         eth_ports_np = of_get_child_by_name(pdev->dev.of_node, "ethernet-ports");
         |                      ^
   drivers/net/ethernet/sunplus/spl2sw_driver.c:428:26: error: implicit declaration of function 'of_parse_phandle' [-Werror=implicit-function-declaration]
     428 |                 phy_np = of_parse_phandle(port_np, "phy-handle", 0);
         |                          ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/sunplus/spl2sw_driver.c:428:24: warning: assignment to 'struct device_node *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     428 |                 phy_np = of_parse_phandle(port_np, "phy-handle", 0);
         |                        ^
   cc1: some warnings being treated as errors

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for PINCTRL_SPPCTL
   Depends on PINCTRL && SOC_SP7021 && OF && HAS_IOMEM
   Selected by
   - SP7021_EMAC && NETDEVICES && ETHERNET && NET_VENDOR_SUNPLUS && (SOC_SP7021 || COMPILE_TEST


vim +407 drivers/net/ethernet/sunplus/spl2sw_driver.c

   343	
   344	static int spl2sw_probe(struct platform_device *pdev)
   345	{
   346		struct device_node *eth_ports_np;
   347		struct device_node *port_np;
   348		struct spl2sw_common *comm;
   349		struct device_node *phy_np;
   350		phy_interface_t phy_mode;
   351		struct net_device *ndev;
   352		u8 mac_addr[ETH_ALEN];
   353		struct spl2sw_mac *mac;
   354		int irq, i;
   355		int ret;
   356	
   357		if (platform_get_drvdata(pdev))
   358			return -ENODEV;
   359	
   360		/* Allocate memory for 'spl2sw_common' area. */
   361		comm = devm_kzalloc(&pdev->dev, sizeof(*comm), GFP_KERNEL);
   362		if (!comm)
   363			return -ENOMEM;
   364		comm->pdev = pdev;
   365	
   366		spin_lock_init(&comm->rx_lock);
   367		spin_lock_init(&comm->tx_lock);
   368		spin_lock_init(&comm->mdio_lock);
   369	
   370		/* Get memory resource 0 from dts. */
   371		comm->l2sw_reg_base = devm_platform_ioremap_resource(pdev, 0);
   372		if (IS_ERR(comm->l2sw_reg_base))
   373			return PTR_ERR(comm->l2sw_reg_base);
   374	
   375		/* Get irq resource from dts. */
   376		ret = platform_get_irq(pdev, 0);
   377		if (ret < 0)
   378			return ret;
   379		irq = ret;
   380	
   381		/* Get clock controller. */
   382		comm->clk = devm_clk_get(&pdev->dev, NULL);
   383		if (IS_ERR(comm->clk)) {
   384			dev_err_probe(&pdev->dev, PTR_ERR(comm->clk),
   385				      "Failed to retrieve clock controller!\n");
   386			return PTR_ERR(comm->clk);
   387		}
   388	
   389		/* Get reset controller. */
   390		comm->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
   391		if (IS_ERR(comm->rstc)) {
   392			dev_err_probe(&pdev->dev, PTR_ERR(comm->rstc),
   393				      "Failed to retrieve reset controller!\n");
   394			return PTR_ERR(comm->rstc);
   395		}
   396	
   397		/* Enable clock. */
   398		clk_prepare_enable(comm->clk);
   399		udelay(1);
   400	
   401		reset_control_assert(comm->rstc);
   402		udelay(1);
   403		reset_control_deassert(comm->rstc);
   404		udelay(1);
   405	
   406		/* Get child node ethernet-ports. */
 > 407		eth_ports_np = of_get_child_by_name(pdev->dev.of_node, "ethernet-ports");
   408		if (!eth_ports_np) {
   409			dev_err(&pdev->dev, "No ethernet-ports child node found!\n");
   410			ret = -ENODEV;
   411			goto out_clk_disable;
   412		}
   413	
   414		for (i = 0; i < MAX_NETDEV_NUM; i++) {
   415			/* Get port@i of node ethernet-ports. */
   416			port_np = spl2sw_get_eth_child_node(eth_ports_np, i);
   417			if (!port_np)
   418				continue;
   419	
   420			/* Get phy-mode. */
   421			if (of_get_phy_mode(port_np, &phy_mode)) {
   422				dev_err(&pdev->dev, "Failed to get phy-mode property of port@%d!\n",
   423					i);
   424				continue;
   425			}
   426	
   427			/* Get phy-handle. */
   428			phy_np = of_parse_phandle(port_np, "phy-handle", 0);
   429			if (!phy_np) {
   430				dev_err(&pdev->dev, "Failed to get phy-handle property of port@%d!\n",
   431					i);
   432				continue;
   433			}
   434	
   435			/* Get mac-address from nvmem. */
   436			ret = spl2sw_nvmem_get_mac_address(&pdev->dev, port_np, mac_addr);
   437			if (ret) {
   438				dev_info(&pdev->dev, "Generate a random mac address!\n");
   439	
   440				/* Generate a mac address using OUI of Sunplus Technology
   441				 * and random controller number.
   442				 */
   443				mac_addr[0] = 0xfc; /* OUI of Sunplus: fc:4b:bc */
   444				mac_addr[1] = 0x4b;
   445				mac_addr[2] = 0xbc;
   446				mac_addr[3] = get_random_int() % 256;
   447				mac_addr[4] = get_random_int() % 256;
   448				mac_addr[5] = get_random_int() % 256;
   449			}
   450	
   451			/* Initialize the net device. */
   452			ret = spl2sw_init_netdev(pdev, mac_addr, &ndev);
   453			if (ret)
   454				goto out_unregister_dev;
   455	
   456			ndev->irq = irq;
   457			comm->ndev[i] = ndev;
   458			mac = netdev_priv(ndev);
   459			mac->phy_node = phy_np;
   460			mac->phy_mode = phy_mode;
   461			mac->comm = comm;
   462	
   463			mac->lan_port = 0x1 << i;	/* forward to port i */
   464			mac->to_vlan = 0x1 << i;	/* vlan group: i     */
   465			mac->vlan_id = i;		/* vlan group: i     */
   466	
   467			/* Set MAC address */
   468			ret = spl2sw_mac_addr_add(mac);
   469			if (ret)
   470				goto out_unregister_dev;
   471	
   472			spl2sw_mac_rx_mode_set(mac);
   473		}
   474	
   475		/* Find first valid net device. */
   476		for (i = 0; i < MAX_NETDEV_NUM; i++) {
   477			if (comm->ndev[i])
   478				break;
   479		}
   480		if (i >= MAX_NETDEV_NUM) {
   481			dev_err(&pdev->dev, "No valid ethernet port!\n");
   482			ret = -ENODEV;
   483			goto out_clk_disable;
   484		}
   485	
   486		/* Save first valid net device */
   487		ndev = comm->ndev[i];
   488		platform_set_drvdata(pdev, ndev);
   489	
   490		/* Request irq. */
   491		ret = devm_request_irq(&pdev->dev, irq, spl2sw_ethernet_interrupt,
   492				       0, ndev->name, ndev);
   493		if (ret) {
   494			netdev_err(ndev, "Failed to request irq #%d for \"%s\"!\n",
   495				   irq, ndev->name);
   496			goto out_unregister_dev;
   497		}
   498	
   499		/* Initialize mdio bus */
   500		ret = spl2sw_mdio_init(comm);
   501		if (ret) {
   502			netdev_err(ndev, "Failed to initialize mdio bus!\n");
   503			goto out_unregister_dev;
   504		}
   505	
   506		ret = spl2sw_mac_addr_del_all(comm);
   507		if (ret)
   508			goto out_free_mdio;
   509	
   510		ret = spl2sw_descs_init(comm);
   511		if (ret) {
   512			dev_err(&comm->pdev->dev, "Fail to initialize mac descriptors!\n");
   513			spl2sw_descs_free(comm);
   514			goto out_free_mdio;
   515		}
   516	
   517		spl2sw_mac_init(comm);
   518	
   519		ret = spl2sw_phy_connect(comm);
   520		if (ret) {
   521			netdev_err(ndev, "Failed to connect phy!\n");
   522			goto out_free_mdio;
   523		}
   524	
   525		netif_napi_add(ndev, &comm->rx_napi, spl2sw_rx_poll, SPL2SW_RX_NAPI_WEIGHT);
   526		napi_enable(&comm->rx_napi);
   527		netif_napi_add(ndev, &comm->tx_napi, spl2sw_tx_poll, SPL2SW_TX_NAPI_WEIGHT);
   528		napi_enable(&comm->tx_napi);
   529		return 0;
   530	
   531	out_free_mdio:
   532		spl2sw_mdio_remove(comm);
   533	
   534	out_unregister_dev:
   535		for (i = 0; i < MAX_NETDEV_NUM; i++)
   536			if (comm->ndev[i])
   537				unregister_netdev(comm->ndev[i]);
   538	
   539	out_clk_disable:
   540		clk_disable_unprepare(comm->clk);
   541		return ret;
   542	}
   543	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

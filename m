Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3935B5173
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 00:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiIKWLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 18:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiIKWLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 18:11:15 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1D6252BE;
        Sun, 11 Sep 2022 15:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662934274; x=1694470274;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7i2KnNq7yrgZB6ZJd5EtHLTUqcedo4CZx9AqVi8sgNE=;
  b=FvxKMGLN9/9P5Cjp4uOkl7QvqgHCkc+MFlCI1BYdyij1aO64lFZ0D5Qr
   spkitk9q1JbpPMBnDT0jDEMuwExwrlqaVReQGsqroXT/F5firylsoe/4j
   45pMSIlW0Fjlh/Vf8+6Fj1VpwvFRAmtVo7a/0AeDkA/h8BwXGBIgHB5lq
   AhgZLDX+5eSQ3EmxM4nv9hWcyX/njTM5Enhi/nipcnJhV7LEb3dCYqox2
   D4VWhwN5FVcjawYyOAe4RybZKr1ToMkz+0i7yDfkiBO8VRRI0gJ6x7Vro
   AZmMfP3srZrR4LoYk89vyGMKg1Cf2XGXKScJbURQbs3cGyU4Y02K2Cd4i
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10467"; a="323982604"
X-IronPort-AV: E=Sophos;i="5.93,307,1654585200"; 
   d="scan'208";a="323982604"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2022 15:11:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,307,1654585200"; 
   d="scan'208";a="704973933"
Received: from lkp-server02.sh.intel.com (HELO 4011df4f4fd3) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Sep 2022 15:11:11 -0700
Received: from kbuild by 4011df4f4fd3 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oXVAU-0001st-10;
        Sun, 11 Sep 2022 22:11:10 +0000
Date:   Mon, 12 Sep 2022 06:11:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>
Cc:     kbuild-all@lists.01.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v4 1/5] net: ipqess: introduce the Qualcomm
 IPQESS driver
Message-ID: <202209120614.ZJKTCvbf-lkp@intel.com>
References: <20220909152454.7462-2-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909152454.7462-2-maxime.chevallier@bootlin.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxime,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Maxime-Chevallier/net-ipqess-introduce-Qualcomm-IPQESS-driver/20220909-232946
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 169ccf0e40825d9e465863e4707d8e8546d3c3cb
config: xtensa-allyesconfig (https://download.01.org/0day-ci/archive/20220912/202209120614.ZJKTCvbf-lkp@intel.com/config)
compiler: xtensa-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/0f2d032fe80cfabb7db162b9c19ed6e23077baeb
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Maxime-Chevallier/net-ipqess-introduce-Qualcomm-IPQESS-driver/20220909-232946
        git checkout 0f2d032fe80cfabb7db162b9c19ed6e23077baeb
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=xtensa SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/net/ethernet/qualcomm/ipqess/ipqess.c: In function 'ipqess_axi_probe':
>> drivers/net/ethernet/qualcomm/ipqess/ipqess.c:1191:17: error: implicit declaration of function 'netif_tx_napi_add'; did you mean 'netif_napi_add'? [-Werror=implicit-function-declaration]
    1191 |                 netif_tx_napi_add(netdev, &ess->tx_ring[i].napi_tx,
         |                 ^~~~~~~~~~~~~~~~~
         |                 netif_napi_add
   cc1: some warnings being treated as errors


vim +1191 drivers/net/ethernet/qualcomm/ipqess/ipqess.c

  1097	
  1098	static int ipqess_axi_probe(struct platform_device *pdev)
  1099	{
  1100		struct device_node *np = pdev->dev.of_node;
  1101		struct net_device *netdev;
  1102		phy_interface_t phy_mode;
  1103		struct resource *res;
  1104		struct ipqess *ess;
  1105		int i, err = 0;
  1106	
  1107		netdev = devm_alloc_etherdev_mqs(&pdev->dev, sizeof(struct ipqess),
  1108						 IPQESS_NETDEV_QUEUES,
  1109						 IPQESS_NETDEV_QUEUES);
  1110		if (!netdev)
  1111			return -ENOMEM;
  1112	
  1113		ess = netdev_priv(netdev);
  1114		ess->netdev = netdev;
  1115		ess->pdev = pdev;
  1116		spin_lock_init(&ess->stats_lock);
  1117		SET_NETDEV_DEV(netdev, &pdev->dev);
  1118		platform_set_drvdata(pdev, netdev);
  1119	
  1120		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
  1121		ess->hw_addr = devm_ioremap_resource(&pdev->dev, res);
  1122		if (IS_ERR(ess->hw_addr))
  1123			return PTR_ERR(ess->hw_addr);
  1124	
  1125		err = of_get_phy_mode(np, &phy_mode);
  1126		if (err) {
  1127			dev_err(&pdev->dev, "incorrect phy-mode\n");
  1128			return err;
  1129		}
  1130	
  1131		ess->ess_clk = devm_clk_get(&pdev->dev, "ess");
  1132		if (!IS_ERR(ess->ess_clk))
  1133			clk_prepare_enable(ess->ess_clk);
  1134	
  1135		ess->ess_rst = devm_reset_control_get(&pdev->dev, "ess");
  1136		if (IS_ERR(ess->ess_rst))
  1137			goto err_clk;
  1138	
  1139		ipqess_reset(ess);
  1140	
  1141		ess->phylink_config.dev = &netdev->dev;
  1142		ess->phylink_config.type = PHYLINK_NETDEV;
  1143		ess->phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_10 |
  1144						       MAC_100 | MAC_1000FD;
  1145	
  1146		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
  1147			  ess->phylink_config.supported_interfaces);
  1148	
  1149		ess->phylink = phylink_create(&ess->phylink_config,
  1150					      of_fwnode_handle(np), phy_mode,
  1151					      &ipqess_phylink_mac_ops);
  1152		if (IS_ERR(ess->phylink)) {
  1153			err = PTR_ERR(ess->phylink);
  1154			goto err_clk;
  1155		}
  1156	
  1157		for (i = 0; i < IPQESS_MAX_TX_QUEUE; i++) {
  1158			ess->tx_irq[i] = platform_get_irq(pdev, i);
  1159			scnprintf(ess->tx_irq_names[i], sizeof(ess->tx_irq_names[i]),
  1160				  "%s:txq%d", pdev->name, i);
  1161		}
  1162	
  1163		for (i = 0; i < IPQESS_MAX_RX_QUEUE; i++) {
  1164			ess->rx_irq[i] = platform_get_irq(pdev, i + IPQESS_MAX_TX_QUEUE);
  1165			scnprintf(ess->rx_irq_names[i], sizeof(ess->rx_irq_names[i]),
  1166				  "%s:rxq%d", pdev->name, i);
  1167		}
  1168	
  1169		netdev->netdev_ops = &ipqess_axi_netdev_ops;
  1170		netdev->features = NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
  1171				   NETIF_F_HW_VLAN_CTAG_RX |
  1172				   NETIF_F_HW_VLAN_CTAG_TX |
  1173				   NETIF_F_TSO | NETIF_F_GRO | NETIF_F_SG;
  1174		/* feature change is not supported yet */
  1175		netdev->hw_features = 0;
  1176		netdev->vlan_features = NETIF_F_HW_CSUM | NETIF_F_SG | NETIF_F_RXCSUM |
  1177					NETIF_F_TSO |
  1178					NETIF_F_GRO;
  1179		netdev->watchdog_timeo = 5 * HZ;
  1180		netdev->base_addr = (u32)ess->hw_addr;
  1181		netdev->max_mtu = 9000;
  1182		netdev->gso_max_segs = IPQESS_TX_RING_SIZE / 2;
  1183	
  1184		ipqess_set_ethtool_ops(netdev);
  1185	
  1186		err = ipqess_hw_init(ess);
  1187		if (err)
  1188			goto err_phylink;
  1189	
  1190		for (i = 0; i < IPQESS_NETDEV_QUEUES; i++) {
> 1191			netif_tx_napi_add(netdev, &ess->tx_ring[i].napi_tx,
  1192					  ipqess_tx_napi, 64);
  1193			netif_napi_add(netdev, &ess->rx_ring[i].napi_rx, ipqess_rx_napi,
  1194				       64);
  1195		}
  1196	
  1197		err = register_netdev(netdev);
  1198		if (err)
  1199			goto err_hw_stop;
  1200	
  1201		return 0;
  1202	
  1203	err_hw_stop:
  1204		ipqess_hw_stop(ess);
  1205	
  1206		ipqess_tx_ring_free(ess);
  1207		ipqess_rx_ring_free(ess);
  1208	err_phylink:
  1209		phylink_destroy(ess->phylink);
  1210	
  1211	err_clk:
  1212		clk_disable_unprepare(ess->ess_clk);
  1213	
  1214		return err;
  1215	}
  1216	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

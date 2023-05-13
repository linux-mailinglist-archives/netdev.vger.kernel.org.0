Return-Path: <netdev+bounces-2373-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4BCB701922
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 20:24:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DD32281745
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 18:24:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80AC379E1;
	Sat, 13 May 2023 18:24:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628AC63BD
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 18:24:23 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E1E2133;
	Sat, 13 May 2023 11:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684002260; x=1715538260;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5G+5+Etoz27RfboThw2vuGImFntcqFRFw5uuJgUkIag=;
  b=JUwgelacYqIB3dg3vhrczLoEwY/IJLwYZhBDciMKEJ3S1R5/jWgSuGH8
   d0X0RLqJVn7h0CzaDPFHH+RiAAltEqJzyGEHe8f7Kx/Scz20eAIkvN/iu
   LskaVHRMTz01VTApzZfRdBFVuYePcaMz7xuVgkPqPvgtQMZdB2vohDtr/
   ikip4TpvB1VGoklM5gqLKecgb811aTq7AlfqtFA3Rii2bLtDXZ1pGna+f
   ETTeER3oPSeLxW9L7rFnV2cd4GfPPJUUZOo/3edJfIdVmVFTARcgW4f3z
   YdfTjKH3WaVaaBt3FH4TYQGtyZ2D64404Qz6wh184xW/O35uQNw2gfjcj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10709"; a="351006695"
X-IronPort-AV: E=Sophos;i="5.99,272,1677571200"; 
   d="scan'208";a="351006695"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2023 11:24:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10709"; a="824694956"
X-IronPort-AV: E=Sophos;i="5.99,272,1677571200"; 
   d="scan'208";a="824694956"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 13 May 2023 11:24:15 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1pxtug-0005dM-2W;
	Sat, 13 May 2023 18:24:14 +0000
Date: Sun, 14 May 2023 02:23:50 +0800
From: kernel test robot <lkp@intel.com>
To: Harini Katakam <harini.katakam@amd.com>, andrew@lunn.ch,
	hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
	kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
	vladimir.oltean@nxp.com, wsa+renesas@sang-engineering.com,
	simon.horman@corigine.com, mkl@pengutronix.de
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, harinikatakamlinux@gmail.com,
	michal.simek@amd.com, harini.katakam@amd.com,
	radhey.shyam.pandey@amd.com
Subject: Re: [PATCH net-next v3 2/3] phy: mscc: Add support for RGMII delay
 configuration
Message-ID: <202305140248.lh4LUw2j-lkp@intel.com>
References: <20230511120808.28646-3-harini.katakam@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511120808.28646-3-harini.katakam@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Harini,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Harini-Katakam/phy-mscc-Use-PHY_ID_MATCH_VENDOR-to-minimize-PHY-ID-table/20230511-200935
base:   net-next/main
patch link:    https://lore.kernel.org/r/20230511120808.28646-3-harini.katakam%40amd.com
patch subject: [PATCH net-next v3 2/3] phy: mscc: Add support for RGMII delay configuration
config: openrisc-randconfig-m041-20230509 (https://download.01.org/0day-ci/archive/20230514/202305140248.lh4LUw2j-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 12.1.0

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305140248.lh4LUw2j-lkp@intel.com/

smatch warnings:
drivers/net/phy/mscc/mscc_main.c:1819 vsc85xx_config_init() warn: unsigned 'vsc8531->rx_delay' is never less than zero.
drivers/net/phy/mscc/mscc_main.c:1829 vsc85xx_config_init() warn: unsigned 'vsc8531->tx_delay' is never less than zero.

vim +1819 drivers/net/phy/mscc/mscc_main.c

  1807	
  1808	static const int vsc8531_internal_delay[] = {200, 800, 1100, 1700, 2000, 2300,
  1809						     2600, 3400};
  1810	static int vsc85xx_config_init(struct phy_device *phydev)
  1811	{
  1812		int delay_size = ARRAY_SIZE(vsc8531_internal_delay);
  1813		struct vsc8531_private *vsc8531 = phydev->priv;
  1814		struct device *dev = &phydev->mdio.dev;
  1815		int rc, i, phy_id;
  1816	
  1817		vsc8531->rx_delay = phy_get_internal_delay(phydev, dev, &vsc8531_internal_delay[0],
  1818							   delay_size, true);
> 1819		if (vsc8531->rx_delay < 0) {
  1820			if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID ||
  1821			    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
  1822				vsc8531->rx_delay = RGMII_CLK_DELAY_2_0_NS;
  1823			else
  1824				vsc8531->rx_delay = RGMII_CLK_DELAY_0_2_NS;
  1825		}
  1826	
  1827		vsc8531->tx_delay = phy_get_internal_delay(phydev, dev, &vsc8531_internal_delay[0],
  1828							   delay_size, false);
> 1829		if (vsc8531->tx_delay < 0) {
  1830			if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
  1831			    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
  1832				vsc8531->rx_delay = RGMII_CLK_DELAY_2_0_NS;
  1833			else
  1834				vsc8531->rx_delay = RGMII_CLK_DELAY_0_2_NS;
  1835		}
  1836	
  1837		rc = vsc85xx_default_config(phydev);
  1838		if (rc)
  1839			return rc;
  1840	
  1841		rc = vsc85xx_mac_if_set(phydev, phydev->interface);
  1842		if (rc)
  1843			return rc;
  1844	
  1845		rc = vsc85xx_edge_rate_cntl_set(phydev, vsc8531->rate_magic);
  1846		if (rc)
  1847			return rc;
  1848	
  1849		phy_id = phydev->drv->phy_id & phydev->drv->phy_id_mask;
  1850		if (PHY_ID_VSC8531 == phy_id || PHY_ID_VSC8541 == phy_id ||
  1851		    PHY_ID_VSC8530 == phy_id || PHY_ID_VSC8540 == phy_id) {
  1852			rc = vsc8531_pre_init_seq_set(phydev);
  1853			if (rc)
  1854				return rc;
  1855		}
  1856	
  1857		rc = vsc85xx_eee_init_seq_set(phydev);
  1858		if (rc)
  1859			return rc;
  1860	
  1861		for (i = 0; i < vsc8531->nleds; i++) {
  1862			rc = vsc85xx_led_cntl_set(phydev, i, vsc8531->leds_mode[i]);
  1863			if (rc)
  1864				return rc;
  1865		}
  1866	
  1867		return 0;
  1868	}
  1869	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC49ECBA5
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 23:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfKAWqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 18:46:42 -0400
Received: from mga07.intel.com ([134.134.136.100]:47388 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727029AbfKAWql (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 18:46:41 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Nov 2019 15:46:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,257,1569308400"; 
   d="gz'50?scan'50,208,50";a="226171177"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 01 Nov 2019 15:46:36 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iQfgh-0009Vn-W6; Sat, 02 Nov 2019 06:46:35 +0800
Date:   Sat, 2 Nov 2019 06:45:41 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     kbuild-all@lists.01.org, linux-mips@vger.kernel.org,
        davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        axboe@kernel.dk, peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, bhelgaas@google.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: Re: [PATCH 2/5] net: stmmac: Split devicetree parse
Message-ID: <201911020631.i0Ng7Rxd%lkp@intel.com>
References: <20191030135347.3636-3-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nrwphbjjfjjzyrqi"
Content-Disposition: inline
In-Reply-To: <20191030135347.3636-3-jiaxun.yang@flygoat.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--nrwphbjjfjjzyrqi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jiaxun,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]
[cannot apply to v5.4-rc5 next-20191031]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Jiaxun-Yang/PCI-Devices-for-Loongson-PCH/20191102-045600
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 52340b82cf1a9c8d466b6e36a0881bc44174b969
config: sparc64-allmodconfig (attached as .config)
compiler: sparc64-linux-gcc (GCC) 7.4.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=7.4.0 make.cross ARCH=sparc64 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c: In function 'stmmac_parse_config_dt':
>> drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:401:3: error: 'mac' undeclared (first use in this function); did you mean 'max'?
     *mac = of_get_mac_address(np);
      ^~~
      max
   drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:401:3: note: each undeclared identifier is reported only once for each function it appears in
   In file included from include/linux/platform_device.h:13:0,
                    from drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:11:
>> drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:445:13: error: 'pdev' undeclared (first use in this function); did you mean 'cdev'?
      dev_warn(&pdev->dev, "snps,phy-addr property is deprecated\n");
                ^
   include/linux/device.h:1743:12: note: in definition of macro 'dev_warn'
     _dev_warn(dev, dev_fmt(fmt), ##__VA_ARGS__)
               ^~~
   drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c: In function 'stmmac_probe_config_dt':
>> drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:633:3: error: implicit declaration of function 'free' [-Werror=implicit-function-declaration]
      free(plat);
      ^~~~
>> drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:633:3: warning: incompatible implicit declaration of built-in function 'free'
   drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:633:3: note: include '<stdlib.h>' or provide a declaration of 'free'
   cc1: some warnings being treated as errors

vim +401 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c

0060c8783330ab Alexandru Ardelean  2019-09-06  386  
732fdf0e5253e9 Giuseppe CAVALLARO  2014-11-18  387  /**
af5ab092fba22b Jiaxun Yang         2019-10-30  388   * stmmac_parse_config_dt - parse device-tree driver parameters
af5ab092fba22b Jiaxun Yang         2019-10-30  389   * @np: device_mode structure
af5ab092fba22b Jiaxun Yang         2019-10-30  390   * @plat: plat_stmmacenet_data structure
732fdf0e5253e9 Giuseppe CAVALLARO  2014-11-18  391   * Description:
732fdf0e5253e9 Giuseppe CAVALLARO  2014-11-18  392   * this function is to read the driver parameters from device-tree and
732fdf0e5253e9 Giuseppe CAVALLARO  2014-11-18  393   * set some private fields that will be used by the main at runtime.
732fdf0e5253e9 Giuseppe CAVALLARO  2014-11-18  394   */
af5ab092fba22b Jiaxun Yang         2019-10-30  395  int stmmac_parse_config_dt(struct device_node *np,
af5ab092fba22b Jiaxun Yang         2019-10-30  396  				struct plat_stmmacenet_data *plat)
6a228452d11eaf Stefan Roese        2012-03-13  397  {
25c83b5c2e8256 Srinivas Kandagatla 2013-07-04  398  	struct stmmac_dma_cfg *dma_cfg;
2ee2132ffb83e3 Niklas Cassel       2018-02-19  399  	int rc;
6a228452d11eaf Stefan Roese        2012-03-13  400  
6a228452d11eaf Stefan Roese        2012-03-13 @401  	*mac = of_get_mac_address(np);
195b2919ccd7ff Martin Blumenstingl 2019-07-27  402  	if (IS_ERR(*mac)) {
195b2919ccd7ff Martin Blumenstingl 2019-07-27  403  		if (PTR_ERR(*mac) == -EPROBE_DEFER)
195b2919ccd7ff Martin Blumenstingl 2019-07-27  404  			return ERR_CAST(*mac);
195b2919ccd7ff Martin Blumenstingl 2019-07-27  405  
195b2919ccd7ff Martin Blumenstingl 2019-07-27  406  		*mac = NULL;
195b2919ccd7ff Martin Blumenstingl 2019-07-27  407  	}
195b2919ccd7ff Martin Blumenstingl 2019-07-27  408  
0060c8783330ab Alexandru Ardelean  2019-09-06  409  	plat->phy_interface = of_get_phy_mode(np);
0060c8783330ab Alexandru Ardelean  2019-09-06  410  	if (plat->phy_interface < 0)
af5ab092fba22b Jiaxun Yang         2019-10-30  411  		return plat->phy_interface;
0060c8783330ab Alexandru Ardelean  2019-09-06  412  
0060c8783330ab Alexandru Ardelean  2019-09-06  413  	plat->interface = stmmac_of_get_mac_mode(np);
0060c8783330ab Alexandru Ardelean  2019-09-06  414  	if (plat->interface < 0)
0060c8783330ab Alexandru Ardelean  2019-09-06  415  		plat->interface = plat->phy_interface;
4838a54050284d Jose Abreu          2019-06-14  416  
4838a54050284d Jose Abreu          2019-06-14  417  	/* Some wrapper drivers still rely on phy_node. Let's save it while
4838a54050284d Jose Abreu          2019-06-14  418  	 * they are not converted to phylink. */
4838a54050284d Jose Abreu          2019-06-14  419  	plat->phy_node = of_parse_phandle(np, "phy-handle", 0);
4838a54050284d Jose Abreu          2019-06-14  420  
4838a54050284d Jose Abreu          2019-06-14  421  	/* PHYLINK automatically parses the phy-handle property */
4838a54050284d Jose Abreu          2019-06-14  422  	plat->phylink_node = np;
25c83b5c2e8256 Srinivas Kandagatla 2013-07-04  423  
9cbadf094d9d47 Srinivas Kandagatla 2014-01-16  424  	/* Get max speed of operation from device tree */
9cbadf094d9d47 Srinivas Kandagatla 2014-01-16  425  	if (of_property_read_u32(np, "max-speed", &plat->max_speed))
9cbadf094d9d47 Srinivas Kandagatla 2014-01-16  426  		plat->max_speed = -1;
9cbadf094d9d47 Srinivas Kandagatla 2014-01-16  427  
25c83b5c2e8256 Srinivas Kandagatla 2013-07-04  428  	plat->bus_id = of_alias_get_id(np, "ethernet");
25c83b5c2e8256 Srinivas Kandagatla 2013-07-04  429  	if (plat->bus_id < 0)
25c83b5c2e8256 Srinivas Kandagatla 2013-07-04  430  		plat->bus_id = 0;
25c83b5c2e8256 Srinivas Kandagatla 2013-07-04  431  
436f7ecdcc08f7 Chen-Yu Tsai        2014-01-17  432  	/* Default to phy auto-detection */
436f7ecdcc08f7 Chen-Yu Tsai        2014-01-17  433  	plat->phy_addr = -1;
436f7ecdcc08f7 Chen-Yu Tsai        2014-01-17  434  
5e7f7fc538d894 Biao Huang          2019-05-24  435  	/* Default to get clk_csr from stmmac_clk_crs_set(),
5e7f7fc538d894 Biao Huang          2019-05-24  436  	 * or get clk_csr from device tree.
5e7f7fc538d894 Biao Huang          2019-05-24  437  	 */
5e7f7fc538d894 Biao Huang          2019-05-24  438  	plat->clk_csr = -1;
81311c03ab4dca Christophe Roullier 2019-03-05  439  	of_property_read_u32(np, "clk_csr", &plat->clk_csr);
81311c03ab4dca Christophe Roullier 2019-03-05  440  
436f7ecdcc08f7 Chen-Yu Tsai        2014-01-17  441  	/* "snps,phy-addr" is not a standard property. Mark it as deprecated
436f7ecdcc08f7 Chen-Yu Tsai        2014-01-17  442  	 * and warn of its use. Remove this when phy node support is added.
436f7ecdcc08f7 Chen-Yu Tsai        2014-01-17  443  	 */
436f7ecdcc08f7 Chen-Yu Tsai        2014-01-17  444  	if (of_property_read_u32(np, "snps,phy-addr", &plat->phy_addr) == 0)
436f7ecdcc08f7 Chen-Yu Tsai        2014-01-17 @445  		dev_warn(&pdev->dev, "snps,phy-addr property is deprecated\n");
25c83b5c2e8256 Srinivas Kandagatla 2013-07-04  446  
a7657f128c279a Giuseppe CAVALLARO  2016-04-01  447  	/* To Configure PHY by using all device-tree supported properties */
ce339abc9a40af Niklas Cassel       2018-02-19  448  	rc = stmmac_dt_phy(plat, np, &pdev->dev);
ce339abc9a40af Niklas Cassel       2018-02-19  449  	if (rc)
af5ab092fba22b Jiaxun Yang         2019-10-30  450  		return rc;
6a228452d11eaf Stefan Roese        2012-03-13  451  
e7877f52fd4a8d Vince Bridgers      2015-04-15  452  	of_property_read_u32(np, "tx-fifo-depth", &plat->tx_fifo_size);
e7877f52fd4a8d Vince Bridgers      2015-04-15  453  
e7877f52fd4a8d Vince Bridgers      2015-04-15  454  	of_property_read_u32(np, "rx-fifo-depth", &plat->rx_fifo_size);
e7877f52fd4a8d Vince Bridgers      2015-04-15  455  
8c2a7a5d2c6ec6 Giuseppe CAVALLARO  2014-10-14  456  	plat->force_sf_dma_mode =
8c2a7a5d2c6ec6 Giuseppe CAVALLARO  2014-10-14  457  		of_property_read_bool(np, "snps,force_sf_dma_mode");
6aedb8c06df732 Chen-Yu Tsai        2014-01-17  458  
b4b7b772e8b018 jpinto              2017-01-09  459  	plat->en_tx_lpi_clockgating =
b4b7b772e8b018 jpinto              2017-01-09  460  		of_property_read_bool(np, "snps,en-tx-lpi-clockgating");
b4b7b772e8b018 jpinto              2017-01-09  461  
2618abb73c8953 Vince Bridgers      2014-01-20  462  	/* Set the maxmtu to a default of JUMBO_LEN in case the
2618abb73c8953 Vince Bridgers      2014-01-20  463  	 * parameter is not present in the device tree.
2618abb73c8953 Vince Bridgers      2014-01-20  464  	 */
2618abb73c8953 Vince Bridgers      2014-01-20  465  	plat->maxmtu = JUMBO_LEN;
2618abb73c8953 Vince Bridgers      2014-01-20  466  
4ed2d8fca7979a Joachim Eastwood    2015-07-17  467  	/* Set default value for multicast hash bins */
4ed2d8fca7979a Joachim Eastwood    2015-07-17  468  	plat->multicast_filter_bins = HASH_TABLE_SIZE;
4ed2d8fca7979a Joachim Eastwood    2015-07-17  469  
4ed2d8fca7979a Joachim Eastwood    2015-07-17  470  	/* Set default value for unicast filter entries */
4ed2d8fca7979a Joachim Eastwood    2015-07-17  471  	plat->unicast_filter_entries = 1;
4ed2d8fca7979a Joachim Eastwood    2015-07-17  472  
6a228452d11eaf Stefan Roese        2012-03-13  473  	/*
6a228452d11eaf Stefan Roese        2012-03-13  474  	 * Currently only the properties needed on SPEAr600
6a228452d11eaf Stefan Roese        2012-03-13  475  	 * are provided. All other properties should be added
6a228452d11eaf Stefan Roese        2012-03-13  476  	 * once needed on other platforms.
6a228452d11eaf Stefan Roese        2012-03-13  477  	 */
84c9f8c41df9f6 Dinh Nguyen         2012-07-18  478  	if (of_device_is_compatible(np, "st,spear600-gmac") ||
f9a09687a87887 Alexandre TORGUE    2016-08-29  479  		of_device_is_compatible(np, "snps,dwmac-3.50a") ||
84c9f8c41df9f6 Dinh Nguyen         2012-07-18  480  		of_device_is_compatible(np, "snps,dwmac-3.70a") ||
84c9f8c41df9f6 Dinh Nguyen         2012-07-18  481  		of_device_is_compatible(np, "snps,dwmac")) {
2618abb73c8953 Vince Bridgers      2014-01-20  482  		/* Note that the max-frame-size parameter as defined in the
2618abb73c8953 Vince Bridgers      2014-01-20  483  		 * ePAPR v1.1 spec is defined as max-frame-size, it's
2618abb73c8953 Vince Bridgers      2014-01-20  484  		 * actually used as the IEEE definition of MAC Client
2618abb73c8953 Vince Bridgers      2014-01-20  485  		 * data, or MTU. The ePAPR specification is confusing as
2618abb73c8953 Vince Bridgers      2014-01-20  486  		 * the definition is max-frame-size, but usage examples
2618abb73c8953 Vince Bridgers      2014-01-20  487  		 * are clearly MTUs
2618abb73c8953 Vince Bridgers      2014-01-20  488  		 */
2618abb73c8953 Vince Bridgers      2014-01-20  489  		of_property_read_u32(np, "max-frame-size", &plat->maxmtu);
3b57de958e2aa3 Vince Bridgers      2014-07-31  490  		of_property_read_u32(np, "snps,multicast-filter-bins",
3b57de958e2aa3 Vince Bridgers      2014-07-31  491  				     &plat->multicast_filter_bins);
3b57de958e2aa3 Vince Bridgers      2014-07-31  492  		of_property_read_u32(np, "snps,perfect-filter-entries",
3b57de958e2aa3 Vince Bridgers      2014-07-31  493  				     &plat->unicast_filter_entries);
3b57de958e2aa3 Vince Bridgers      2014-07-31  494  		plat->unicast_filter_entries = dwmac1000_validate_ucast_entries(
c3a502deaf1f0d Andy Shevchenko     2019-09-05  495  				&pdev->dev, plat->unicast_filter_entries);
3b57de958e2aa3 Vince Bridgers      2014-07-31  496  		plat->multicast_filter_bins = dwmac1000_validate_mcast_bins(
c3a502deaf1f0d Andy Shevchenko     2019-09-05  497  				&pdev->dev, plat->multicast_filter_bins);
6a228452d11eaf Stefan Roese        2012-03-13  498  		plat->has_gmac = 1;
6a228452d11eaf Stefan Roese        2012-03-13  499  		plat->pmt = 1;
6a228452d11eaf Stefan Roese        2012-03-13  500  	}
6a228452d11eaf Stefan Roese        2012-03-13  501  
ee2ae1ed46251d Alexandre TORGUE    2016-04-01  502  	if (of_device_is_compatible(np, "snps,dwmac-4.00") ||
026e57585ff159 Christophe Roullier 2018-05-25  503  	    of_device_is_compatible(np, "snps,dwmac-4.10a") ||
026e57585ff159 Christophe Roullier 2018-05-25  504  	    of_device_is_compatible(np, "snps,dwmac-4.20a")) {
ee2ae1ed46251d Alexandre TORGUE    2016-04-01  505  		plat->has_gmac4 = 1;
7cc99fd29b9829 Niklas Cassel       2016-12-07  506  		plat->has_gmac = 0;
ee2ae1ed46251d Alexandre TORGUE    2016-04-01  507  		plat->pmt = 1;
ee2ae1ed46251d Alexandre TORGUE    2016-04-01  508  		plat->tso_en = of_property_read_bool(np, "snps,tso");
ee2ae1ed46251d Alexandre TORGUE    2016-04-01  509  	}
ee2ae1ed46251d Alexandre TORGUE    2016-04-01  510  
25c83b5c2e8256 Srinivas Kandagatla 2013-07-04  511  	if (of_device_is_compatible(np, "snps,dwmac-3.610") ||
25c83b5c2e8256 Srinivas Kandagatla 2013-07-04  512  		of_device_is_compatible(np, "snps,dwmac-3.710")) {
25c83b5c2e8256 Srinivas Kandagatla 2013-07-04  513  		plat->enh_desc = 1;
25c83b5c2e8256 Srinivas Kandagatla 2013-07-04  514  		plat->bugged_jumbo = 1;
25c83b5c2e8256 Srinivas Kandagatla 2013-07-04  515  		plat->force_sf_dma_mode = 1;
25c83b5c2e8256 Srinivas Kandagatla 2013-07-04  516  	}
25c83b5c2e8256 Srinivas Kandagatla 2013-07-04  517  
a3f142478a5aa1 Jose Abreu          2018-08-08  518  	if (of_device_is_compatible(np, "snps,dwxgmac")) {
a3f142478a5aa1 Jose Abreu          2018-08-08  519  		plat->has_xgmac = 1;
a3f142478a5aa1 Jose Abreu          2018-08-08  520  		plat->pmt = 1;
a3f142478a5aa1 Jose Abreu          2018-08-08  521  		plat->tso_en = of_property_read_bool(np, "snps,tso");
a3f142478a5aa1 Jose Abreu          2018-08-08  522  	}
a3f142478a5aa1 Jose Abreu          2018-08-08  523  
64c3b252e9fc82 Byungho An          2013-08-24  524  	dma_cfg = devm_kzalloc(&pdev->dev, sizeof(*dma_cfg),
64c3b252e9fc82 Byungho An          2013-08-24  525  			       GFP_KERNEL);
277323814e4956 Mathieu Olivari     2015-05-27  526  	if (!dma_cfg) {
d2ed0a7755fe14 Johan Hovold        2016-11-30  527  		stmmac_remove_config_dt(pdev, plat);
af5ab092fba22b Jiaxun Yang         2019-10-30  528  		return -ENOMEM;
277323814e4956 Mathieu Olivari     2015-05-27  529  	}
25c83b5c2e8256 Srinivas Kandagatla 2013-07-04  530  	plat->dma_cfg = dma_cfg;
a332e2fa56343c Niklas Cassel       2016-12-07  531  
25c83b5c2e8256 Srinivas Kandagatla 2013-07-04  532  	of_property_read_u32(np, "snps,pbl", &dma_cfg->pbl);
a332e2fa56343c Niklas Cassel       2016-12-07  533  	if (!dma_cfg->pbl)
a332e2fa56343c Niklas Cassel       2016-12-07  534  		dma_cfg->pbl = DEFAULT_DMA_PBL;
89caaa2d80b7bf Niklas Cassel       2016-12-07  535  	of_property_read_u32(np, "snps,txpbl", &dma_cfg->txpbl);
89caaa2d80b7bf Niklas Cassel       2016-12-07  536  	of_property_read_u32(np, "snps,rxpbl", &dma_cfg->rxpbl);
4022d039a31595 Niklas Cassel       2016-12-07  537  	dma_cfg->pblx8 = !of_property_read_bool(np, "snps,no-pbl-x8");
a332e2fa56343c Niklas Cassel       2016-12-07  538  
afea03656add70 Giuseppe Cavallaro  2016-02-29  539  	dma_cfg->aal = of_property_read_bool(np, "snps,aal");
a332e2fa56343c Niklas Cassel       2016-12-07  540  	dma_cfg->fixed_burst = of_property_read_bool(np, "snps,fixed-burst");
a332e2fa56343c Niklas Cassel       2016-12-07  541  	dma_cfg->mixed_burst = of_property_read_bool(np, "snps,mixed-burst");
a332e2fa56343c Niklas Cassel       2016-12-07  542  
e2a240c7d3bceb Sonic Zhang         2013-08-28  543  	plat->force_thresh_dma_mode = of_property_read_bool(np, "snps,force_thresh_dma_mode");
e2a240c7d3bceb Sonic Zhang         2013-08-28  544  	if (plat->force_thresh_dma_mode) {
e2a240c7d3bceb Sonic Zhang         2013-08-28  545  		plat->force_sf_dma_mode = 0;
c3a502deaf1f0d Andy Shevchenko     2019-09-05  546  		dev_warn(&pdev->dev,
c3a502deaf1f0d Andy Shevchenko     2019-09-05  547  			 "force_sf_dma_mode is ignored if force_thresh_dma_mode is set.\n");
356f9e74ffaafd Olof Johansson      2013-09-05  548  	}
25c83b5c2e8256 Srinivas Kandagatla 2013-07-04  549  
02e57b9d7c8ce9 Giuseppe CAVALLARO  2016-06-24  550  	of_property_read_u32(np, "snps,ps-speed", &plat->mac_port_sel_speed);
02e57b9d7c8ce9 Giuseppe CAVALLARO  2016-06-24  551  
afea03656add70 Giuseppe Cavallaro  2016-02-29  552  	plat->axi = stmmac_axi_setup(pdev);
afea03656add70 Giuseppe Cavallaro  2016-02-29  553  
2ee2132ffb83e3 Niklas Cassel       2018-02-19  554  	rc = stmmac_mtl_setup(pdev, plat);
2ee2132ffb83e3 Niklas Cassel       2018-02-19  555  	if (rc) {
2ee2132ffb83e3 Niklas Cassel       2018-02-19  556  		stmmac_remove_config_dt(pdev, plat);
af5ab092fba22b Jiaxun Yang         2019-10-30  557  		return rc;
2ee2132ffb83e3 Niklas Cassel       2018-02-19  558  	}
d976a525c37127 Joao Pinto          2017-03-10  559  
f573c0b9c4e026 jpinto              2017-01-09  560  	/* clock setup */
ddfbee9e3204a0 Thierry Reding      2019-07-26  561  	if (!of_device_is_compatible(np, "snps,dwc-qos-ethernet-4.10")) {
f573c0b9c4e026 jpinto              2017-01-09  562  		plat->stmmac_clk = devm_clk_get(&pdev->dev,
f573c0b9c4e026 jpinto              2017-01-09  563  						STMMAC_RESOURCE_NAME);
f573c0b9c4e026 jpinto              2017-01-09  564  		if (IS_ERR(plat->stmmac_clk)) {
f573c0b9c4e026 jpinto              2017-01-09  565  			dev_warn(&pdev->dev, "Cannot get CSR clock\n");
f573c0b9c4e026 jpinto              2017-01-09  566  			plat->stmmac_clk = NULL;
f573c0b9c4e026 jpinto              2017-01-09  567  		}
f573c0b9c4e026 jpinto              2017-01-09  568  		clk_prepare_enable(plat->stmmac_clk);
ddfbee9e3204a0 Thierry Reding      2019-07-26  569  	}
f573c0b9c4e026 jpinto              2017-01-09  570  
f573c0b9c4e026 jpinto              2017-01-09  571  	plat->pclk = devm_clk_get(&pdev->dev, "pclk");
f573c0b9c4e026 jpinto              2017-01-09  572  	if (IS_ERR(plat->pclk)) {
f573c0b9c4e026 jpinto              2017-01-09  573  		if (PTR_ERR(plat->pclk) == -EPROBE_DEFER)
f573c0b9c4e026 jpinto              2017-01-09  574  			goto error_pclk_get;
f573c0b9c4e026 jpinto              2017-01-09  575  
f573c0b9c4e026 jpinto              2017-01-09  576  		plat->pclk = NULL;
f573c0b9c4e026 jpinto              2017-01-09  577  	}
f573c0b9c4e026 jpinto              2017-01-09  578  	clk_prepare_enable(plat->pclk);
f573c0b9c4e026 jpinto              2017-01-09  579  
f573c0b9c4e026 jpinto              2017-01-09  580  	/* Fall-back to main clock in case of no PTP ref is passed */
9fbb9dd8eee459 Thierry Reding      2017-03-10  581  	plat->clk_ptp_ref = devm_clk_get(&pdev->dev, "ptp_ref");
f573c0b9c4e026 jpinto              2017-01-09  582  	if (IS_ERR(plat->clk_ptp_ref)) {
f573c0b9c4e026 jpinto              2017-01-09  583  		plat->clk_ptp_rate = clk_get_rate(plat->stmmac_clk);
f573c0b9c4e026 jpinto              2017-01-09  584  		plat->clk_ptp_ref = NULL;
f573c0b9c4e026 jpinto              2017-01-09  585  		dev_warn(&pdev->dev, "PTP uses main clock\n");
f573c0b9c4e026 jpinto              2017-01-09  586  	} else {
f573c0b9c4e026 jpinto              2017-01-09  587  		plat->clk_ptp_rate = clk_get_rate(plat->clk_ptp_ref);
fd3984e6e78a56 Heiner Kallweit     2017-02-02  588  		dev_dbg(&pdev->dev, "PTP rate %d\n", plat->clk_ptp_rate);
f573c0b9c4e026 jpinto              2017-01-09  589  	}
f573c0b9c4e026 jpinto              2017-01-09  590  
f573c0b9c4e026 jpinto              2017-01-09  591  	plat->stmmac_rst = devm_reset_control_get(&pdev->dev,
f573c0b9c4e026 jpinto              2017-01-09  592  						  STMMAC_RESOURCE_NAME);
f573c0b9c4e026 jpinto              2017-01-09  593  	if (IS_ERR(plat->stmmac_rst)) {
f573c0b9c4e026 jpinto              2017-01-09  594  		if (PTR_ERR(plat->stmmac_rst) == -EPROBE_DEFER)
f573c0b9c4e026 jpinto              2017-01-09  595  			goto error_hw_init;
f573c0b9c4e026 jpinto              2017-01-09  596  
f573c0b9c4e026 jpinto              2017-01-09  597  		dev_info(&pdev->dev, "no reset control found\n");
f573c0b9c4e026 jpinto              2017-01-09  598  		plat->stmmac_rst = NULL;
f573c0b9c4e026 jpinto              2017-01-09  599  	}
f573c0b9c4e026 jpinto              2017-01-09  600  
af5ab092fba22b Jiaxun Yang         2019-10-30  601  	return 0;
f573c0b9c4e026 jpinto              2017-01-09  602  
f573c0b9c4e026 jpinto              2017-01-09  603  error_hw_init:
f573c0b9c4e026 jpinto              2017-01-09  604  	clk_disable_unprepare(plat->pclk);
f573c0b9c4e026 jpinto              2017-01-09  605  error_pclk_get:
f573c0b9c4e026 jpinto              2017-01-09  606  	clk_disable_unprepare(plat->stmmac_clk);
f573c0b9c4e026 jpinto              2017-01-09  607  
af5ab092fba22b Jiaxun Yang         2019-10-30  608  	return -EPROBE_DEFER;
af5ab092fba22b Jiaxun Yang         2019-10-30  609  }
af5ab092fba22b Jiaxun Yang         2019-10-30  610  

:::::: The code at line 401 was first introduced by commit
:::::: 6a228452d11eaf1f1577261540ec0903a2af7f61 stmmac: Add device-tree support

:::::: TO: Stefan Roese <sr@denx.de>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--nrwphbjjfjjzyrqi
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICAalvF0AAy5jb25maWcAjFxbc+M2sn7Pr1BNXpKqM4kvM052T/kBJEEJEUlwAFCy/MJS
NJqJK7blleScnX9/usEbbqSnamtjft1o3Bp9AzQ//vDjjLyeD0/b88Nu+/j4bfZ1/7w/bs/7
z7MvD4/7/50lfFZwNaMJU78Ac/bw/PrfX08v2+Pu5sPs4y8ffrl4f9xdz5b74/P+cRYfnr88
fH0FAQ+H5x9+/AH+9yOATy8g6/jvWdvu/SNKef91t5v9NI/jn2e/oRzgjXmRsnkdxzWTNVBu
v3UQfNQrKiTjxe1vFx8uLnrejBTznnRhiFgQWROZ13Ou+CCoJayJKOqcbCJaVwUrmGIkY/c0
MRh5IZWoYsWFHFAmPtVrLpaA6LnN9XI9zk778+vLMAOUWNNiVRMxrzOWM3V7fTVIzkuW0VpR
qQbJC0oSKhxwSUVBszAt4zHJuom/e9fBUcWypJYkUwaY0JRUmaoXXKqC5PT23U/Ph+f9zz2D
XJNyEC03csXK2APwv7HKBrzkkt3V+aeKVjSMek1iwaWsc5pzsamJUiReDMRK0oxFwzepQO+M
NSIrCksaLxoCiiZZ5rAPqN4h2LHZ6fXP07fTef807NCcFlSwWG+oXPC1vcWloGnG13VKpKKc
GXpoNIsXrLSbJTwnrLAxyfIQU71gVOBUNja17XEgw6SLJKOmEnaDyCXDNsY2lURIamPmiBMa
VfMUJf042z9/nh2+OMvTLySucQwatpS8EjGtE6KIL1OxnNYrbxs6shZAV7RQstsN9fC0P55C
G6JYvKx5QWEzjB0veL24xxOT80IPu9OE+7qEPnjC4tnDafZ8OOMRtFsxWDazTYOmVZaNNTE0
jc0XtaBST1FYK+ZNoVd7QWleKhBVWP12+IpnVaGI2Jjdu1yBoXXtYw7Nu4WMy+pXtT39PTvD
cGZbGNrpvD2fZtvd7vD6fH54/uosLTSoSaxlsGJujm/FhHLIuIWBkUQygdHwmMIJBmZjn1xK
vboeiIrIpVRESRsCdczIxhGkCXcBjHF7+N3iSGZ99KYuYZJEmbbo/dZ9x6L1ZgrWg0meEcW0
5ulFF3E1kwHVhQ2qgTYMBD5qegcaasxCWhy6jQPhMvlyYOWybDgCBqWgFCw9ncdRxkzPgLSU
FLxStzcffLDOKElvL29silTuGdBd8DjCtTBX0V4F2+9ErLgy/AZbNn/cPrmI1haTsfFxcuDM
OApNwTqzVN1e/mbiuDs5uTPpV8NxYYVaggdMqSvjutlGuftr//kVIpLZl/32/Hrcn4a9rCCg
yEu9F4ZbasCoAnOmZHsQPw4rEhDY69Fc8Ko0NL8kc9pIoGJAwR/Gc+fTccoDBpFFp9oWbQn/
MY5ktmx7N5yv/q7XgikakXjpUWS8MOWmhIk6SIlTWUfgmdYsUYYDB0sSZDeWtQ6PqWSJ9ECR
5MQDUzg69+bitfiimlOVGdEDaImkptVBncOOWoonIaErFlMPBm7bIHVDpiL1wKj0Me13DUvA
42VPshwrxmbgxMGMGksHGleYISjEYeY3zERYAE7Q/C6osr5hZ+JlyeGUoIeD+NaYsd42iKMU
d3YJnDzseELBGcVEmVvrUurVlaEPaOJtnYRF1vGxMGTob5KDnCbeMEJXkdTzezPQAiAC4MpC
sntTUQC4u3fo3Pn+YOUEvARHDwlAnXKh95WLnBSx5cddNgl/BJykG/DqoLViyeWNtWbAAy4i
piU6GHAHxFQ8S4lcR+LIysHbMVQCQzwchByPmheaNZsVgnE8Hp42wacb2vdBkWVy3e+6yA3f
bJ0AmqVgA03FiwgErhibGZ1Xit45n6DchpSSW5Ng84JkqaFWepwmoINRE5ALy2YSZqgJRByV
sIINkqyYpN0yGQsAQiIiBDM3YYksm1z6SG2tcY/qJcADo9jK1gV/YxD8A3JMkq3JRtZmZICq
oEMga+J5RJPEPLZaLVHT6z5C73YPQZBSr3Lo0/TSZXx58aELhtqUv9wfvxyOT9vn3X5G/9k/
QzhFwCvGGFBBnDx41mBf2jKGeux963d20wlc5U0fnYs1+pJZFXmmGLHWs+qjYa4kJupE1ZFO
93szIDMShY49SLLZeJiNYIcCgoA2UjUHAzT0bhjO1QKOHs/HqAsiEkizLFWu0jSjTYChl5GA
bXemioETJIlY7rBOv6K5dkVYSWEpi7uwd3CcKcuss6AtlvYiVnZkF0Q65psPkZnHY54aO583
hkHW6ScsTxs8vtsed381Radfd7rCdOpKUPXn/ZcGemc11p5+iSamBqthum5YgAgPRJEwUjhd
EmXE3hB3x0s9y1pWZcmFXXtZgsfzCVrMgkVUFHoJ0WBKFpkmVBcpNKNzGCEiaYKKJhkT1AwM
MNTvSPow1ykToAfxoiqWI3xaE4JseV45Y25nIrsTCU3dwz9XGHVC9rCiYPs+hJtXsPIR7fP9
8njY7U+nw3F2/vbSpFx+zC1zw70Xeuwg/+JfN1a+f3lxEThPQLj6eHFrlwaubVZHSljMLYix
o6CFwMR5GFlX1lisKZsvlE8AE80iATFQk9k6K5yTTWt04zpNfPW3l4ESkW1SI5iVNEZ7ZOgM
V2VWzdvsrCsKzNLj/j+v++fdt9lpt3206gCoE2BAPtmnAZF6zldYjBO1HRabZDcD7YmY2gfg
LhHHtmMRVZCXr8Fsw0IFtzDYBF2eDpu/vwkvEgrjSb6/BdCgm5X2zt/fSqtSpVio5mQtr71E
QY5uYYYc2aL3qzBC76Y8QjbnN8LST8ZUuC+uws0+Hx/+sVy/1nAY3zWK0xr45JKuqEEzCzYB
hR4ines6jwdZRWUmAQVPqGwz/48OWJKi5mqBiRMCri3UZVSICtpEe5TseXDYQXAXWJm45wXl
4KIFVh26E9v6BYqWIsP82+jZcBqGzc3hdCWNx1Z2nR9JGaWlzYyIbUgAxXTO512TJdUV3jDa
XltcDlctFnVueobcEuGEWDiAZIV6nQRIzYgdPNFdqXiR8BFUh/ZY4Lq8MsfXWeKmxm7MbP2p
OT41TSG6YRggepvntw+ssMvBzUQNSPNNnYNKmdGVdiYyVy6UG0sY5wmEV7SOOM889PYdhDin
w+P+9nz+Ji/+51834MOOh8P59tfP+39+PX3eXr4bzsyUy9WHNno9zQ4veEN3mv1Uxmy2P+9+
+dk4rVFlRs3wFUO0aSBVUWcwf2lDvKQFOH9I4p3TDa4NevH9HYB4hWFGjyNDswNyK3DV11I9
rueXP5x27UWl7ipgj4zhQsbXD5dHZZ1mRC4GSJEEskyIIuXlxVVdxUpkAzGK4ppdGRaIFiub
I2GyhFDgN0mNGiiHoDLDO5U709aNDtu6aMRQ+OG83+F+vv+8f4HGkAx1i2b4egHTcHJs3oTx
hnXX8UgPDylpH8S1wB9VXtaQf1h6DW4fDsKSQv4pIaG3bycrV8RSUOViunuvswYdY7eKCsOF
oA7UF5wH4jUwh/ouqFYLiKndFBiviOHEthepbm+CziFdL5ImG8AbCH3DUbpjgFEFLNYwvNAC
Nh3EVd3E1ZjajRILXrNiBfElJGmuP+oHoEvecV7exYu5w7MmYPHwqDQ3hN21cYCpTXq/i5dn
icFv2K3mkl2vGWyioniL3t2LmROEvzE907u3tNJLTR65mRrZ/wKPDVp2LARjAmPkOzypMnD8
WGPA2hNWWRwp9A6yMldDeJJgSVuyOYltz4xTB1hWEuyI9WxAL0dLdlvpPFj7Lq/F9VWAVOIN
jOGz0tRQUIEJcoWoVTZD/2zWQPpcbB7z1fs/t6f959nfTVHl5Xj48mDnCMjUPjswThKCOjpV
9Yf6NyvfnxDau01IU/DGm0sVxxjCeNWCN6xaP2NV51gFNI2CrppJrBsNrz+a7cYNaEftaYIL
tJFbxs3db0lVEYSbFj2xTwMMYxJME7rBibhlw2JNIDsYJuF1LbtQM0ixCoUGLhfk0hmoQbq6
+jA53Jbr4813cF3//j2yPl5eTU4bbcji9t3pLwxvbCqeGQGW2JtnR+juDNyue/rd/XjfWPhY
1zmTEg1OfydTs1zXOAwnV4BBgYO+ySOeeYORzSVvBk7JvEmJ8ICan8tafGoKds7xR5KMJYOT
/qmyvGt3jxLJeRC0HtEMly6KzgVTgfsYzFYSHwZzyJWy634+DWa4tuldNKsdiLBp68iZR3sR
xvCunRbxZoQac3cBQFKdf3JHhtUr00qaaGieuIG8JH1KW26P5wc0OzMF4bNZv+6SsD6dMVwi
BFqFkaaNEeoYUtSCjNMplfxunMxiOU4kSTpB1ekPeOJxDsFkzMzO2V1oSlymwZnm4O6CBEUE
CxFyEgdhmXAZIuAbE4inl04YlbMCBiqrKNAEH3DAtOq7329CEitouYaYISQ2S/JQE4TdO4R5
cHqQW4rwCmL6EYCXBFxViEDTYAeY/dz8HqIY568nDfmho+CWXfJSLDwi+Sc7gWsxjM7M+zKE
dSmgeXfHh2cRximCdow3+W8CoZZOb78FiMtNBJZjeDbSwlFq1I7go+7Mg/PeAEnO5fvw5M0a
2XC87at4IotLS1MKvaSyhEgGnb5pw+0SOFGQVca1yA2rqMOWpjGcNL4uTLMo1pLmY0S9KyM0
3S/GtPqpZaLZnJLOOMVtLNbhph4+vL/QG03/u9+9nrd/Pu71k+GZvqY7G1sesSLNFcbdXtAb
IsGHnbbqW5wEE6iusIohfPde6JvTjYwFK5WhJA0M3tzI01EkSjTVYmweTU1h/3Q4fpvl2+ft
1/1TMOPuy4LDkPRtjL6fL3UOl3jZbPsOFmMSWjg3ZG0J8g6iCDMqGEgr+L+8fw40weF32hx2
HFGdO4+McDzmy7deaAb5SakaK6FvaJxGEcYwlsFugGaznUwohIEHEcRlg6xvXrtXUYsNHLMk
EbVyrxaX0lj/Tl/0KoGf0G2am6WWYzptDFHbK3cztgyy5c1jgUCU6bLry7aYgAEz5p1RCDFs
LBWwGPabsNh6HgXew3FNPWRGBgji7aK87d/U3dti70urDHkfVcalwf11Ctmt8S3bS/se6W4K
YdVLK3bsWJ0rI9gmKgRaKf3gvrm3xCdBA4uu32jcLxWkguAzZF1kMHSECkyfnXenc3yhBVHm
IifCMOCY9YN9zTYQ1pb6cU/qWkosaJQKHQCNm9vzoXI3ahwGQ6Ac1VeIgUcBTwrpCEzMebAF
M7QTHASpg8llhPaBFl3pStuqYn/+v8Pxb7yJ8YwUnLklNaxj8w3xDzHqkxgW2V9gVY1jpRG7
icqk9eE9pUNMcQO4S0Vuf9U8Te1MW6MkmxslWg3p1042hMmNSK3LL41DXAihb8bMvEITGmPj
DKgpakplxdmN/FLfvj6Z27GkGw8IyE1K/eLPeologM5KMktXWNn4j5hIG+2vVCDGsV6SAi1l
ERwTRl3l74ShM9In1KZpSS0HMR919rQVFRGXNECJMwLZcmJRyqJ0v+tkEftgxLnyUUFE6ZyJ
kjk7wMo5xgY0r+5cQq2qAotYPn9IRCRA8bxFztvJOTffPSXEPLXCJcslOOXLEGi8Z5Qb9Jl8
yTyjUK4Us4dfJeGZprzygGFVzGEhkSxsBaypLH2kP6A2xT0aGtSHxh2YpgRB/wzUKi5DME44
AAuyDsEIgX6AY+GGAUDR8Oc8kMn3pIgZHq1H4yqMr6GLNedJgLSAv0KwHME3UUYC+IrOiQzg
xSoA4mtBHRP6pCzU6YoWPABvqKkYPcwycFychUaTxOFZxck8gEaRYca7YE3gWLwQrmtz++64
fz68M0XlyUerSAqn5MZQA/hqjaT+WZfN15ovyBG4Q2ie+qIrqBOS2OflxjswN/6JuRk/Mjf+
mcEuc1a6A2emLjRNR0/WjY+iCMtkaEQy5SP1jfUgG9EigaRJJwlqU1KHGOzLsq4asexQh4Qb
T1hOHGIVYTnVhX1D3INvCPTtbtMPnd/U2bodYYAGoWNsmWWncAQI/kIUH2zZQSbao1KVra9M
N34TyGt0CRj8dm5HzsCRssxy9D0UsGKRYAnEykOrp+6nuMc9xoeQ4J73R+/nup7kUBTaktrw
1XIyLSklOYNQuhlEqG3L4Dp4W3Lzw7CA+I7e/Op0giHj8ykyl6lBxgfpRaGzCwvVPzdqAgAX
BkEQ5oa6QFHNr4SCHdSOYpgkX21MKhaw5QgN37ymY0T34bVF7B7TjFO1Ro7Qtf47ohWORnHw
B3EZpszNEo9JkLEaaQKuP2OKjgyD4Ns2MrLgqSpHKIvrq+sREhPxCGUIF8N00ISIcf27nTCD
LPKxAZXl6FglKegYiY01Ut7cVeDwmnCvDyPkBc1KMwHzj9Y8qyBsthWqILZA+A7tGcLuiBFz
NwMxd9KIedNFUNCECeoPCA6iBDMiSBK0UxCIg+bdbSx5rTPxIf12NgDbGd2At+bDoCh8wogP
HJ5MzLKC8K1/me7FFZqz/VmhAxZF85bPgm3jiIDPg6tjI3ohbcjZVz/AR4xHf2DsZWGu/dYQ
V8Tt8Q/qrkCDNQvrzFXfXljYwnrPpReQRR4QEKYrFBbSZOzOzKQzLeWpjAorUlKVvgsB5jE8
XSdhHEbv442aNIU4d24GLXSK73oV10HDnS6Kn2a7w9OfD8/7z7OnA96dnEIBw51qfFtQqlbF
CXJzfqw+z9vj1/15rCtFxByzV/2vRIRltiz6N4+yyt/g6iKzaa7pWRhcnS+fZnxj6ImMy2mO
RfYG/e1BYH1V/1pumg1/dDzNEA65BoaJodiGJNC2wF81vrEWRfrmEIp0NHI0mLgbCgaYsNBH
5Ruj7n3PG+vSO6JJPujwDQbX0IR4hFUoDbF8l+pC9p1L+SYPpNJSCe2rrcP9tD3v/pqwIwp/
kpUkQmef4U4aJvy57BS9/Rn8JEtWSTWq/i0PpAG0GNvIjqcooo2iY6sycDVp45tcjlcOc01s
1cA0pdAtV1lN0nU0P8lAV28v9YRBaxhoXEzT5XR79Phvr9t4FDuwTO9P4E7AZxGkmE9rLytX
09qSXanpXjJazNVimuXN9cCyxjT9DR1ryi34c8gpriIdy+t7FjukCtD1K4gpjvbGZ5JlsZEj
2fvAs1Rv2h43ZPU5pr1Ey0NJNhacdBzxW7ZHZ86TDG78GmBReHn1Foeui77BpX86P8Uy6T1a
FnwPOcVQXV/dmr8Xm6pvdWJYaWdqzTf+auv26uONg0YMY46alR5/T7EOjk20T0NLQ/MUEtji
9jmzaVPykDYuFalFYNZ9p/4cNGmUAMImZU4RpmjjUwQis294W6r+Qby7paZN1Z/NvcA3G3Pe
SzQgpD+4gRL/UaHmLRtY6Nn5uH0+vRyOZ3zhfj7sDo+zx8P28+zP7eP2eYe37afXF6Qb/wyg
FtcUr5Rz8dkTqmSEQBpPF6SNEsgijLdVtWE6p+4JnDtcIdyFW/tQFntMPpRyF+Gr1JMU+Q0R
87pMFi4iPST3ecyMpYGKT10gqhdCLsbXArSuV4bfjTb5RJu8acOKhN7ZGrR9eXl82GljNPtr
//jit7VqV+1o01h5W0rb0lcr+9/fUdNP8SpNEH2T8cEqBjRewcebTCKAt2UtxK3iVVeWcRo0
FQ0f1VWXEeH21YBdzHCbhKTr+jwKcTGPcWTQTX2xwH/1i0jmlx69Ki2Cdi0Z9gpwVroFwwZv
05tFGP9/zq6kuW0kWf8VRh9ezBz8motISQcfsJJlogAIBZJQXxAcm24rWpY9ktw98+9fZRWW
zKqE3PEmYlrm92XtC2rJyiRLYExU5XCjw7B1nbkELz7sTenhGiH9QytLk306CcFtYomAu4N3
MuNulPui5dtsKsZu3yamImUqst+Y+nVVBScX0vvgg3kz4eC6b/HtGky1kCbGoozKyG8M3m50
/7n5e+N7HMcbOqSGcbzhhhr9LNJxTAIM49hBu3FMI6cDlnJcNFOJ9oOWXIxvpgbWZmpkISI5
iM3VBAcT5AQFhxgT1C6bICDfVk95QkBOZZLrRJiuJwhV+TEyp4QdM5HG5OSAWW522PDDdcOM
rc3U4NowUwxOl59jsERu1L/RCHtrALHfx03/aY2T6Ony+jeGnxbMzdFiu62C8JAZ00soEz+L
yB+W3e05GWndtb5M3EuSjvDvSqwFTC8qcpVJyV51IG2T0B1gHacJuAE91H4woGqvXxGStC1i
bubLdsUygSzwVhIz+AuPcDEFb1jcORxBDN2MIcI7GkCcqvnkj1mQTxWjSsrsniXjqQqDvLU8
5X9KcfamIiQn5wh3ztTDfm7Cq1J6NGh176JRg8+OJg3MokjEL1PDqIuoBaElszkbyNUEPBWm
TquoJa8iCeO9EZrM6liQzjDd7vzxD/KCuo+Yj9MJhQLR0xv41cYh2KT4EJGXIYbotOKslqhR
SQI1OPwoYVIOngGzr3MnQ8DDfc6UHcj7OZhiu+fHuIfYFInWZhUr8qMl+oQAOC1cg+WBr/iX
nh91nHRfbXCaUlBL8kMvJfG00SPG9EKElV+AyYgmBiCyLAKKhNVyc3PFYbq53SFEz3jh1/Bw
g6LYsLYBhBsuwUfBZC7akvlS+pOnN/zFVu+AVF4UVB2tY2FC6yZ733iDmQIUsWFnga8OoL94
W5j9F3c8FVaR9FWwHIE3gsLcmuQxL7FVJ1epvKcm85pMMrLe88Re/cYTd9FEVLpqb1fzFU+q
D8FiMV/zpP6uiwx/fk0zORU8Yu32iDfbiJCEsEucMYZuyeO+P8jwcY7+scQDIMj2OIJjG5Rl
llBYlHFcOj/bJI/wA6VmicqeBSXS5yh3BcnmRm9ESvzd7QD/XVRP5LvIl9ag0SPnGVg40qtB
zO6KkifovgYzsghFRlbGmIU6J6frmDzETGpbTYChlV1c8dnZvhUS5j8upzhWvnKwBN1ccRLO
mlIkSQI9cX3FYW2edf8wBpIF1D+2aook3XsPRHndQ3+q3DTtp8q+Lzbf/7sflx8X/fn+tXtH
TL7/nXQbhXdeFO2uDhkwVZGPku9TD5YVtlfVo+bmjUmtctQ1DKhSJgsqZYLXyV3GoGHqg1Go
fDCpGck64MuwZTMbK+/a0eD6b8JUT1xVTO3c8SmqfcgT0a7YJz58x9VRZIy9eTA8P+eZKODi
5qLe7ZjqKwUTulfT9qWzw5appcHy3bD265d96R27NBxXhbpMb0r0BX9TSNFkHFavjdLCeKTw
n4F0RXj/y/fPD5+/tZ/PL6+/dKrtj+eXl4fP3fk6HY5R5jyk0oB3rtvBdWRP7j3CTE5XPp6e
fMxeS3ZgB7juAjrUfyNgElPHksmCRjdMDsAAi4cySi+23I6yzBCFc6ducHOqBAaFCJMY2Hmb
OtwOR3vk7ApRkft+ssONvgzLkGpEuHMAMhLG1jNHREEuYpYRpUr4MMSMQF8hAVEi1mAA6umg
buAUAXCw/4VX31aTPfQjkKLypj/AVSDLjInYyxqArv6czVri6kbaiIXbGAbdh7x45KpO2lyX
mfJResrRo16vM9FyqkuWqc2TLC6HsmAqSqRMLVlFZP+Zrk2AYjoCE7mXm47wvxQdwc4XddS/
zaZtbaZ6gd+axRHqDnGuwCVHAW7d0FZMrwQCY3WIw/p/IkVyTGI7dwiPiY2XEc8jFpb0aSyO
yF1FuxzLGFv7LAOHkmQvCXY6j3qTBhPOVwakb84wcWxITyRhkjzBVo6P/QNtD3EODazNG06e
Etx+1byMoNGZEUR6CCB6U1pQGX/Fb1A9DTBPf3N8L75T7orI1AB9eAA6FCs4WQfdGkLdVTUK
D79aJWMH0ZlwchBhr1zwqy0SCWaJWnuEj3pZhZ0jValxH4af0zWY70z6QBpmQHKE9xTd7FLB
V5S6b6nHkPDOd6lBAVVXSSA9Q2YQpbnhsifH1PDC7PXy8uptCcp9TV92wI69Kkq91cuFtVwx
nBR6ETkENu0wNHQgqyA2ddLZMfv4x+V1Vp0/PXwbNFaQrm1A9tDwS08KMgA3E0f6GKYq0Nxf
wfv/7jw3aP53uZ49dZn9dPnz4ePFN7Yr9wIvTTcl0UINy7sEDHHjqe1eD54WvBqlccPiOwbX
TTRi9wFkeai2NzM6dCE8Wegf9MYKgBAfMwGwdQQ+LG5Xt33taGAW26Rit05A+OgleGw8SGUe
RJQWAYiCLAIVFXivjGdO4IL6dkGl0yzxk9lWHvQhyH/TG/8gX1F8fwygCcpIJGnsZPaQX6G3
xqVddzmZnYD0ViWowVgny0XCgaPr6zkDtQKfzI0wH7lIBfx1iyH9LMo3smi5Wv/nqlk3lCuT
YM9X1YcAPFFQMJHKL6oFZSScgqU3i818MdU2fDYmMhfRPtPhfpJl1vixdCXxa74n+FpTRUo/
aAjUy008iFQpZg/g5efz+ePFGUQ7sVosnEqXUblcL4htbSaaIfqDCiejv4EzSi3gN4kPqhjA
JUW3jGTXSh4uozDwUdMaHnqwXZQU0CkInTPAAKa1yUPc9TCT1DCv4ktCuPBNYmzKU39TU1jk
ECELtTWxMarD5klJI9OALm/r3oL0lNVZZNhI1jSmnYgdQJEA2C6a/ukd9xmRmIbxrZkjsE2i
eMczxO8C3NwOa2Nrd//xx+X127fXL5OfSriizmu8noMKiZw6rilPbhCgAiIR1qTDIND6gnCN
VmOBEFt6woTEHt4wUWFvdz2hYrxfsughqGoOg286WXUianfFwnmxF16xDRNGqmSDBPVu5ZXA
MJmXfwOvTqJKWMY2EscwtWdwaCQ2U9tN07CMrI5+tUZyOV81XsuWeqb10ZTpBHGdLfyOsYo8
LDskUVDFLn7c4fk/7LLpAq3X+rbyiVy996Q05vWROz2jkC2HzUilBJ7/JsfWsMBN9R6gwlfF
PeIowI1wbhTSsgLbvxhYZ29bNXtsJEaL7fGwndhGgOZcRc2RQ5/LiMmNHqGnCafEvKfFHdRA
1K2ugVR57wkJNNqidAs3Hqhf2JuVhXE4D95MfFn4liRZAZ7GTkGV64+2YoSiRG+Ke29ybZEf
OCEwbq2LaNw3gj2zZBuHjBhYKrV26a2IcTzByIG9zGAUgefqo9MclKj+kWTZIQv0dkIQ0xhE
CDwFNEYHoGJroTuy5oL7hheHeqniwPcdN9An6rEOw3DXRT3RidBpvB7RqdyXtQ5VTnIROZJ1
yHovONLp+N11GUq/R4zFROzmbyCqCIxxwpjIeHaw2/l3pN7/8vXh6eX1+fLYfnn9xROUidox
4elHf4C9NsPxqN7+JNlm0bBaLj8wZF5YA8IM1VnVm6rZVmZymlS1Z/RzbIB6kgK33lOcCJWn
ZTOQ5TQly+wNTn8BptndSXpOoEgLgrqpN+lSiUhN14QReCPrdZxNk7ZdfX+ipA26x1KN8Qo8
eqI4CRmgL7P52UVo/Ci+vxm+IOle4HsW+9vppx0o8hJb6+nQbekeUd+W7u/eaLcLu3ZjA4GO
6+EXJwGBndMIkTp7laTcGb07DwG1HL1PcKPtWZjuyXH4eCKVktcYoNa1FXDzT8Acr1M6AKxg
+yBdcQC6c8OqXZxF4ynf+XmWPlwewfvs168/nvonPf/Qov/s1h/4UbuOoK7S69vreeBEKyQF
YGpf4FMBAFO8wekA6nXKBM3XV1cMxEquVgxEG26E2QiWTLVJEVWF8Z/Dw35MdPHYI35GLOon
CDAbqd/Sql4u9F+3BTrUj0XVfhey2JQs07uakumHFmRiWaWnKl+zIJfm7droB6Cz4b/VL/tI
Su5ukVyj+UbweoT6J4/Bvyw1Vb2tCrO8wraKwW5478GqbaRwr8aAl4ravINlpjFUNYDGBjQ1
T50GIivIjZl16DQe6Ful3Ymz2M4nK7qwcH/47gQB9Hxyw1EajGDiPq/30gohQICKB3hi64Bu
44HPUYUuTVRFjqgifhc7xHOxOOKe0sfAve1ylYrBuvVvCY/+TBldD1OmUjrV0calU8i2rJ1C
tuGJtoNUTmvBdmLvNJZfK+bJPdgit9bzzcGI08D1ISSt0JoLIRckJpYB0BtnmudWFEcK6A2Y
AwTkygr1Gr4rRZOM2pXDpwo8KH789vT6/O3x8fKMzpvs4ef50wXcqWupCxJ78d8xm3qPgjgh
zmkxapx7TVAJcbPw01RxtaS1/i98EUllQVqeUeaB6Nz+OZlpwH15Q8UbEKXQcdWqRAoncADn
kAFtdpNWvTvkMZy4J5LJSc96HSJp9S59H+1EOQHbOuumrZeH359O52dTZdbCgWIbKD65o+nU
JqUzDqrgumk4zBPNgns9zqOgTFwKXO7VZRJteNRp8DcLMDil4Xvq0IuTp0/fvz080SKDE3fj
gd4Zfx3aWix1h6cexbVVViXJD0kMib789fD68Qs/gvA8ceou1cG7khPpdBRjDPSczb14sb+N
Z7o2Evg0QQezn5ouw+8+np8/zf71/PDpd7z+vAe92DE+87MtkNlbi+ghU+xcsBYuokcM3Pcn
nmShdiJEh5xlvLle3o7pipvl/HaJywUFgLcl1pEo2s4EpSAngx3Q1kpcLxc+bswU9zYrV3OX
7ib4qmnrpnU8uA1RSCjalmzQB8456huiPUhXibDnwL9E7sPGf1wb2T2TabXq/P3hEzgksv3E
61+o6OvrhklIb2obBgf5zQ0vr2e9pc9UjWFWuAdP5G50SPvwsVtPzQrX08TBuqDsrCz9l4Vb
42dgPJ7TFVPLEg/YHmmlsaY7riZrMByaEY+iekNp4k5FJY1Xr/AgskFnO314/voXTEJgtANb
XkhPZnCRc9keMsvNWEeE/ROZA8Y+EZT7MdTBKCk4JWdpvXi1nsA5OeTlcGgStxh9KOOPFW4r
kWujjrLuDHluCjXXhZUgG+/hErFKlIua+y8bQC+sZIFVSAwX2AMcK2Ec+6LTcb0KI4vmKtkS
r0T2dxtEt9eo41qQ7Iw6TGVCQoQejv32DpgUnuBp4UFSYn2jPvHqzo8wikI/l/iKBSYbtQsq
27NSUseaSs2qydrow55W+QE3uPT2Dh5k0dRYtRVuUvSuSGBPEwL2gODX3FYXccTt7hj1n9w6
2Rmi3OZYtQd+wV2ewIcxBpT1nieUqFKeOYSNR8g6Jj9M1xp0BUbHdt/Pzy9UB0nLBtW1cYin
aBRhJDerpuEo7EbPoYqUQ+39TiuknjVqouc3knXVUBx6QqkyLj7dQ8A3yluUfedr3G8Zn3Tv
FpMRtIfc7Hj0/ht7s/XE4KwGfCG9Z50G9nVrqvyg/zmT1hzsLNCiNRhJerTnDtn5v14jhNle
TyBuE5ic+5BeDo9oWlOTws6vtkKrX0H5Ko1pcKXSGI1HJSltGrgonVwaF1lui1r3iuDlzShP
9h+bKpC/VoX8NX08v+jV35eH74xeHPSwVNAoPyRxEjnTI+D6y+zOml14ozULziqI8/KezIvO
s9foCLdjQv19vAd/VprnnfV2gtmEoCO2TQqZ1NU9zQPMfWGQ79uTiOtdu3iTXb7JXr3J3ryd
7uZNerX0a04sGIyTu2IwJzfEvdEgBEoE5L3C0KIyVu5MB7he9AQ+eqiF03erQDpA4QBBqOxr
xXGpN91jrQPE8/fvoHbageAd0UqdP+pvhNutC/isNL0DOKdfguVF6Y0lC3r+RzGny1/V7+f/
uZmb/3EiWZK/ZwlobdPY75ccXaR8kuCiW+9OsBYRprcJeJ+d4Eq9qjYOBwkNzl8PaUaMkhs8
Wi/nUexUS57UhnA+e2q9njsYUcyzAN1Ijlgb6F3XvV5ROw1jemR7rPSsUTnhsqCuqE7tzzqE
6TXq8vj5HWx+z8ZwuI5qWk0YkpHRer1wkjZYC9ey2Dkxotx7O82AK1emjge4PVXC+jMjflio
jDdqZbQrl6v9cr1xmk7Vy7UzBlXmjcJy50H6/y6mf+vNdB1k9iYRO6vs2KQyLu+BXSxvcHTm
q7m0qyR7ePTw8se74uldBA0zdQBuSl1EW2x8xZoM1ut2+X5x5aP1+6uxJ/y8kUmP1hs3q7hC
v7d5AgwLdu1kG82ZWTuJ/tCPDe41ZE8sG/iobit8PDfkMYkiONrZBVLSlxe8gF5FRM6qKji1
fplw0NA8ousOAv76VS+tzo+Pl8cZyMw+25l4PCGlLWbiiXU5MsEkYAl/UjBkIOGyO6sDhiv0
1LWcwLv8TlHdftsPq/fq2IXjgHcrX4aJgjThMl7LhBOXQXVMMo5RWdRmZbRaNg0X7k0WjEdM
tJ/eNFxdN03OzDG2Spo8UAy+1ZvNqT6R6j2ASCOGOaabxZzee49FaDhUz15pFrlrWtszgqPI
2W5RN81tHqeSi/DDb1fXN3OG0D0/yUUEPZrpGhDsam5IPs7lOjS9airFCTJVbC71t7XhSrYT
SqznVwwDe2KuVus9W9fuDGPrLdlW3FBStVwtW12f3HiSicLPw1APEdxQQUr0djn28PKRzgfK
t5EyhIb/EGWDgbGnvkwvEWpf5OaG4i3S7kkYB2RvycbmTGv+c9Gd2HLzDZILw5r5KKhyGGSm
srJSpzn7H/t3OdOLoNlX67KXXYUYMVrsO3iNOmzAhi/fzyP2suWurDrQ6LtcGe9fejOPr801
H6gSHImTPg94f8F2dwhionwAJPT5VqVOEDiIYcVBLUH/dfejh9AH2lPW1jvdiDvwA+0sUIxA
mITdy7jl3OXgXT91Od4R4DOKS82eDhDx3X2ZVOSAbxfKSH/XNthsR1yjKQkv8IsUzkQ1HyoC
6tm8Bh+DBNSNLj1wX4QfCBDf54EUJD1jARv/luRSo0h73SYiBIoMWYDWpMb5tNQjoe41FeDc
gSqB9sBXB2ixvnOPuYdqo6zzNBkR5s5f8Jx3YdWnc8jDsvTxoLm5ub7d+IRezF75KeSFKcaA
h9mePlHtgDY/6DYNsSUhl2mtVqnVryBu5ntJ8kwrJttmnR8RD08fy36pprHZl4ffv7x7vPyp
f/oXhCZYW8ZuTLpQDJb6UO1DWzYbg1lyzz9TFy6o8QPUDgxLfPbWgfRhTwfGCr8F7sBU1EsO
XHlgQjxzITC6Ia1uYadHmVgrbONmAMuTB+6Jk94erLEj1A4scry3HsGN34vgilspWBuIslsx
Dmdlv+ktBHM21gc9SGyspkezAhtiwigoPluF01E/tOeNcnbBh42rEPUp+PXzLp/jID2o9hzY
3Pgg2b4isMv+YsNx3s7WjDV4Ih3FR3cI9nB3V6LGKqH0ydFBC+CaG26bqD28Q37EZ7/du30y
b4xYq8hL9qEMXJ1VyvQJqyN6lImvpQGos/UdWuFIHF2AIOOI3eBpEFYiUo40UYoFgNhNtIgx
j8uCTl/EjB9xj0+HsWmPmom4Noblq39hpZJc6cUP+HNYZcf5ElVyEK+X66aNy6JmQXoNiAmy
0okPUt6bW7txzO+CvMYTvT0Fk0IvuvGEUYtUOo1nIL0NRCdWumFuV0t1hV/mml1rq7CNL71s
ywp1gFcvSWUfZY5LmbIVGVoomGu7qNCbNrLFNTAspuijpjJWtzfzZYAtswiVLW/n2JagRfDU
19d9rZn1miHC3YK8ue5xk+Itfn62k9FmtUZfhVgtNjdE9QPc72A9Olh4CVAVi8pVp7aDUqpc
fbpBw6cmRuesjler4jTB+zTQDqlqhXJYHssgx5+IaNmtn0zvTBJY9PlqcBbX7blEq8wRXHtg
lmwD7Iaog2XQbG6uffHbVdRsGLRprnxYxHV7c7srE1ywjkuSxdxsd4ch6BRpKHd4vZg7vdpi
rl7+COrtiDrI4cLJ1Fh9+c/5ZSbgGc6Pr5en15fZy5fz8+UTcpry+PB0mX3S4/7hO/xzrNUa
LjZwXv8fkXEzCB35hLGThbVhAca4z7O03Aazz71uxadvfz0Z3y52JTX7x/Pl3z8eni86V8vo
n8iGhtELhHuJMusjFE+vej2m9wJ6X/h8eTy/6oyPPckRgWt2ex7bcyoSKQMfi5Ki/adKLxbs
RsiJefft5dWJYyQjUBRj0p2U/6bXlnCq/+15pl51kWby/HT+/QKt83+MvUmT27iyNvxXKuLb
3BNx+2uR1EAtekGRlAQXQbIISmLVhuG263Q7jocO231P+9+/SIBDJpBU98KDngcTMSaARObD
/6SVkv9Cx8pTgZnCokXWqEgOTqJmY+13am+MecrL2xPqsPb3dETS501TgRZKCqv/83zQkKfn
ypkWkkL3feeUdJwulmDyOuGcHJIy6RPyGJWsbnNIvXkT+C0l3k58fH377VWLjq8P2Zd3pteb
O/SfP7x/hT///1fdmnDDAm5jfv7w+d9fHr58NkK/2XCgNRTk106LST19twmwtQ+iKKilpJqR
cIBSmqOBT9iXjvndM2HupInFlklozYtHUfo4BGfELANPb+ZMWys2L12InBa3TdRjL6oUv1c3
+6mm0nvfaTKDaoWbLC3Ij33v51///O3fH/7CFT1tCzzzFqgMRtPnePwF6WOj1BlNaxSXaHiP
eHU8HirQF/UY7wZkiqKn6i1Wm3TKx+aT5OmWnIpPRCGCTRcxhMx2ay5GKrPtmsHbRoAtGiaC
2pAbT4xHDH6u22jLbNjemJdHTM9SaRCumIRqIZjiiDYOdiGLhwFTEQZn0ilVvFsHGybbLA1X
urL7qmD6+8SW+Y35lOvtkRlTShgdJIYo0v0q52qrbaQWCX38KpI4TDuuZfXOfZuuVotda+z2
sIkarwS9Hg9kT2z6NYmAOaRt0IeZfRj51dsMMDLYWHNQZ3SbwgylePj+4w+9umtB4j//+/D9
7R+v//uQZj9pQelf/ohUeF96bizWMjXccJiesMqswk/IxyROTLL4zsN8w7RfcPDUaE+T1+sG
L6rTiTxSNqgyFqFAEZNURjuKVd+cVjFnz3476K0fCwvzN8eoRC3ihTiohI/gti+gRmoghlYs
1dRTDvPFtPN1ThXd7AvceSkwONk3W8joxlmThU71d6dDZAMxzJplDmUXLhKdrtsKD9s8dIKO
XSq69XpMdmawOAmda2yKyUA69J4M4RH1qz6hzxEslqRMPolIdyTRAYAZH3zUNYPBIWQNdgzR
5Mo87iuS516qXzZIm2cMYvcaVncfHeoQVuoF/RcvJphtsI+L4Z0V9Z0xFHvvFnv/t8Xe/32x
93eLvb9T7P0/KvZ+7RQbAHenZruAsMPF7RkDTEVbOwNf/eAGY9O3DMhTRe4WVF4v0k3dXBDq
EeTCTSrxfGnnOp10iG/J9CbaLAl6AQQLij88Ap9Vz2AiikPVMYy7K58Ipga0aMGiIXy/ee5/
Ilo4ONY9PrSpIt8r0DISXlA9CdbXiuYvR3VO3VFoQaZFNdFntxRs0bKkieUJr1PUFF7f3+HH
pJdDQG9j4IPyeiscJtRuJT83Bx/C3lDEAZ9Nmp947qS/bAWTQ58JGobl0V1FM9lFwT5wa/xo
nwPzKFPXp6x113NRe4tnKYhdhhFMiD0AK9DU7vQupFv/4sU8Iqyx4utMKHgQkraNu4i2ubtE
qGe5idJYTzPhIgObiOFWH/SgzMYzWAo7WHZpE70RnS8HnFAwcEyI7XopBHmNMdSpO5NoZHpG
4eL0wYuBn7TUpDuDHq1ujVuGHAcPeELOx9tUAhaSVRGB7FwKiYyL/DQfPOWZYLWyNXFc8N4E
Qk19TJdmjyyN9pu/3BkYKnS/WzvwLdsFe7cv2MI7veBSgitip4NKTlyoZWz3CrTIhyPU4VKh
XXMlVrg654USFTfCR6luvJVGx8ZW8/WcBJsQHwVb3BvTA25b3oNtR9x4QxNbBhyAvskSd9LR
6FmPwpsP55IJmxSXxJNrnf3UJBW0xAtVQk9KUOmAq+X0zDhFL7H/++H777o1Pv+kjseHz2+/
f/i/19mwJNojQBIJMZZiIOO7Jtd9UVrD+OgIborCrBsGFrJzkDS/Jg5k321T7Kkit8Mmo0E7
m4IaSYMt7gK2UOY1KvM1ShT4uN9A84kO1NA7t+re/fnt+5dPD3pe5KpNb+j1dCkTJ58nRV5W
2bw7J+eDxNtqjfAFMMHQMTU0NTnbMKnrFdxH4BDC2VqPjDt5jfiVI0B3C3Tu3b5xdYDSBeCe
QqjcQZs08SoHP3sYEOUi15uDXAq3ga/CbYqraPVaNh/O/tN6rk1HKoiWASAyc5EmUWCb+Ojh
bVW7WKtbzgfreIvfAxvUPWmzoHOaNoERC25d8LmmrmUMqlfxxoHcU7gJ9IoJYBeWHBqxIO2P
hnAP32bQzc07BTSopzFs0DJvUwYV5ZskCl3UPc4zqB49dKRZVIsOZMQb1J7sedUD8wM5CTQo
2HYnGyiLZqmDuGebA3h2kVx/f3Ormkc3ST2strGXgHCDje/9HdQ90629EWaQmygP1aygWYvq
py+fP/5wR5kztEz/XlEJ27YmU+e2fdwPqerWjezrrwHoLU82+nGJaV4Ge97kcfy/3378+Ovb
d/95+Pnh4+tvb98xGqd2oXLO7k2S3j6VOfXHU4vUW1tR5nhkyswcEK08JPARP9CaPHTJkEYK
Ro1AT4o5OmWfsYPVzXF+uyvKgA5Hnd7Jw3RhJM1Lg1Yw2kwZapfMM4ZkYh6xPDmGGR6cyqRM
TnnTww9yfuqEM16OfFOQkL4APWFBlLszYw1Jj6EWzBNkRETT3AWMXIoa+//RqNHzIogqk1qd
Kwq2Z2Fehl71ZrsqyUMVSIRW+4j0Sj4R1ChR+4GJ0RuIbAwuYAQcF2GxRUPgcRosHKg6SWlg
uinQwEve0LZgehhGe+yPjhCqddoUdGgJcnGCWEMUpO2ORUJ8BWkIXh61HDS+SWqqqjW2H5Wg
HWEIdsTW9aERHU82Q4WZBlAEBj2kk5f7C7w2npFB4crRS9I7TuE8qgbsqMVy3PkBq+nxMkDQ
eGi1AzWvg+nujv6YSRJNWsP5uRMKo/ZYHElbh9oLf7wooqdof1NljgHDmY/B8GHdgDHHcAND
XsgMGPEZNGLTdYq9IM7z/CGI9uuH/zl++Pp603/+5V9sHUWTGwvin1ykr8g2Y4J1dYQMTNyZ
zmiloGfMmhP3CjXGtgY7BycA43wtsIXC3LUqDes0nVZAh27+mT9dtMj74jqPO6JuL1yPk22O
tUZHxJwcgWP5JDPuphYCNNWlzBq9xywXQyRlVi1mkKStuObQo13veHMYMMBySAp41IIWtiSl
vs0AaPFDZlEb77lFhJUsahpJ/yZxHC9VrmeqE/Z3oDNUWLUN5NWqVJVjxnHA/EcJmqMOkIxj
Io3ARWLb6P8QQ6vtwbPw2gjqXdf+BsNK7nvUgWl8hriLInWhmf5qumBTKUV8N1yJFu+goUuK
Uhaeg+hrg3ZY6lKecgnPs2csaahPY/u71yJ04IOrjQ8SH0EDluJPGrFK7ld//bWE41l5TFno
SZwLr8V7vJ9zCCoduyTWvwF35NYeD7ZvDyAd4ACRS9HB/3kiKJSXPuAKYCMMFsS0KNZgm4Ej
Z2DoUcH2doeN75Hre2S4SDZ3M23uZdrcy7TxMy1FCuYMaI0NoHkMprurYKMYVmTtbgcewEkI
g4ZY9RajXGNMXJOCbk+xwPIFEomTkWeAG1C9Wcp178tp2BE1SXsXiSREC3ejYFlkvi8gvM1z
hbmzk9s5X/gEPU9WaExYS9fuoDBoiwUxg4B6hPWWxuDPZeokcMZylkGmw+3xrf73rx9+/RNU
HgeDa8nXd79/+P767vufXzlvMRusfbQxCq+j0S6CS2PFjiPg5TZHqCY58AR4anGcfoLf+YOW
BdUx9AnnkcCIJmUrnvqTloYZVrY7cjo14dc4zrerLUfBIY95EvqoXjjni36o/Xq3+wdBHNPL
i8Go9WcuWLzbb/5BkIWUzLeTiyWP6k9FpaWWkK7vNEiNbSGMNLjqgsnES3og7saC0euTT2kS
P/oJgtHdNtcbaMl8o5Iqha6xj/BbBY7lG4WEoK8txyDD0W5/Veku4irTCcA3hhsInQnNZk//
4XCe5GjwgkiejPpfYJXI+ggerbs3W1G6wdd4MxojI5zXqiF3vO1zfa48qcnmkmRJ3eLd6wAY
MzxHsrE5NUQ6w4mccryZyNsgCjo+ZJGk5hQCX6EVIq1cv+ZT+DbH+8Qkzcntvv3dV1LoRV+c
9C4OT/1Wcb9VOZ+2TF5w2oTCbn5kFgfgcwZ/fQ0iFzkutk1RypRI+noxcjYYOrleb5AZhLoJ
huI4d2AT1F9D/pP0Nk3PuegcPXkyDwLZwE3Kfzz00YqIiwURNoqA/srpT9w8xUI3uDRVg0tp
fvflIY5XKzaG3TDiEXHAnhD0D2umGxyf5UWO/XcPHGx47/H4hFJCJWO1z7LDLv9IFzTdLnJ/
9+cbMVxt9P5ognraaYjN8MNJ4ktk8xMKk7gYo47zrNpc0ufhOg/nl5chYNYpPOicw37YIUmP
NIjzXbSJwFYBDp+wbenZGLf7qaLLs0T3b1IJJNpVXFAHGA1vwwSAn1Rj/LqAH04dTzSYsDma
dXHCCvF0oYaLR4RkhsttFRmwVrDVbGixY88J64MTEzRigq45jDYZwo0eBUPgUo8o8eWCP0Wo
FH0InYtxON0RRYkGuL2kn5e/OccODKfjQ1u63Z/TzHJnumovhSDmbMNghS9GB0Cv5cW8b7CR
PpGfvbyh0T9ARPXIYiV58DJjekxoAU+P+4Q+vrYhMrkHv32onOsOCWHDJVkfr9HEZ+KgGUcn
tAm3vkJLJ5rUPQMbq4sqyWdFiG/pdYenq9KIOB+OEszlBS795tGdh3SONL+9ec+i+h8GizzM
rJWNB6vH53Nye+TL9UJN7CPqmDRanHnmuSbPwbUHGhPkQSkYajoS+96A1E+OwAagmbIc/CSS
klyfQ0BYVFIGIjPHjPo5WVzPR3BJgw/+Z1L3RTCSrsU3WZNrK/ztlzeiVciB2agfJa9vgphf
sk9VdcKVdbryUhXog4JAh/rAWXSbcxb2dGY3asrH3MHq1ZoKWmcRRF1g484plsqpHY2QHyDB
HylCl3SNRPRXf04L/JrGYGQ2nUNdj064fGnaOl+SWy7YZhBxuMFuGjBFfY/mRD80p06lzU/8
CO50ID/cIakhXHzRkfBUNDU/vQR8YdVColZ4kjagm5UGvHBrUvz1yk08IYlonvzG09hRBqtH
/PWoc72RfI8dtUTmLdl1u4YNH+mH8ko7nIQjbGwQ7Frje526S4Jt7FileMTdC3552laAgeyp
sA8IPfthvVz9y41XpbBNaruwl0QbfsYTXjaR+sOTssImN4tOj0B8/2EB2iQGdOw7AuRa6RyD
WXcE2EBx0W0Mw1slLjp1u0sfb4wyKf4wkRKXko8qjteoFuE3Pum3v3XKBcZedCTnibCTR0UX
Hy3XhvEbfHY1Ivby17VFqtkuXGsaxdANsltH/CxssqS+a6RK9QY4zQt4vuTcO/vc8ItP/Bk7
LIJfwQr32GOeFCVfrjJpaalGYA6s4igO+c2d/i8YnkJTjArxWLt2uBjwa3RIAHrf9ESbJttU
ZYX9T5VH4mav7pO6HnZAJJDBk4M5jqeE08Nxdvjzjf7qoGkiQSFkcYGIoz3xfGQ1mDt6Y+Va
0xqAwZgEKk346GhO2fTqdCn78qr3LkhS1/vKNM/IvFXU6XLxq0fiR+nck/VDp1PxW4Q6SR/z
dnDHgl2pJXqlP6MveM7Bs8XRvQgek8lLBRfBaLWolnYlg5r3FPKpSCJy1vpU0K29/e3umgeU
zIcD5m+OOz1z0jSxYscTGPxzUs8zfpmCG3hjsWsOmiY7IgkMAD3OHEHqWdG6iSDCVyOX2hgU
EKdcm+1qzQ/j4dh3DhoH0R7fKcLvtqo8oK/xnmMEzfVhexODyX2HjYNwT1Gj1NwM7/dQeeNg
u18obwnP0NCsc6YLdpNc+X0wePDChRp+c0FVIuFOGmViRKWlo1SV50/s7KKqImmORYIPWqnh
R/CK2WaE7WWawbvrkqJOl5sC+g+KwREpdLuS5mMxmh0uq4Az0DmVdB+uooD/XiLoCLUnry2E
CvZ8X4NbAG/WVDLdByn2P5XXIqVvq3S8fYBPpw2yXliZVJWChgP21K303E6uAwHQUVydjSmJ
1izaKIFWwn6RioYWU3lxtN5O3ND+kV92AxxU858qRVOzlKdvamG9JDXkSNjCon6KV/iIwcJ6
7tc7Qg+WuV40YKw7uJ1W2vMTvm+11OQMz8F1FYNdHg/GKrwjJPGJ+wBSa8ATGPMym2bwWlPX
zzLHdjLBniWZFTXwRM9JTtjMX5rAezhBAlwHbQxyOzngaFXN5BU/DirFhS/xc1nVoBQ+n+Xo
Nu8KupuesUVxtc3PF+zqbfjNBsXBxGhN2lkvEEG3Ri14rtTye31+hh5NkgIChSR3JagAVyyS
6B99cxb4JmSCnPMqwPVmTo9afJGPEr6JF3L9Zn/3tw2ZJSY0Mui08Rjww0UNLnnY7QkKJUo/
nB8qKZ/5EvkXk8NnuI4uB6NoSec20kAUhW7upYP14RTRnU0BDvET1mOW4ZGWH8m8AD/dF5uP
WNzWY5945qqSrAFHw2jdnDG9C2q0AN04jkWsp74r2fMbkNgJNoi1p+wGA6VZsBXC4JdSkBqy
hGgPCXEMMOTWy0vHo8uZDLxj/RtTUH9NvpDdoAld5F3eOCGGuxEKMvlwh26GIFftBpFVRyRG
C8KGUgrhZmUPGhxQT3lr4WDDXYuDOveceuIwp9cUwA/Fb6DgN3WLQovRbSNOoNRvCWt/UogH
/XPRGYnCvTPJQMWeqA3KzAGG21UHtVuxg4O28SrqKDY5IXNAY8/CBeMdA/bp86nUncHDYTS7
lTRemdLQqUiTzPmE4bqGgjC3e7GzGnbxoQ+2aRwETNh1zIDbHQWPosuduhZpXbgfam12drfk
meIF2JNog1UQpA7RtRQYjvp4MFidHAKs9/enzg1vjpZ8zOr3LMBtwDBwQkLh0lwhJU7qYLa9
BT0ct0s8+SmMujcOaHY6Dji6ISaoUa+hSJsHK/w4EbQqdIcTqZPgqDBDwGEBOunBGDYnooY+
VOSjivf7DXk4R+7o6pr+6A8KurUD6vVHi8g5BY+iIJtHwGRdO6HMtOo4oK/rKmklCVeRaC3N
vypCBxlsMBHIuMckOoaKfKoqzinlJveg2O+CIYwdEQczau3wv+04B4KFyJ++fXj/+nBRh8ki
Fkgjr6/vX98bc4PAlK/f//vl638ekvdv//j++tV/6KADWc2oQW/yEybSBN9rAfKY3MiWBLA6
PyXq4kRt2iIOsCnaGQwpCOeiZCsCoP5DpOqxmDArB7tuidj3wS5OfDbNUnNHzTJ9jiV/TJQp
Q9ibn2UeCHkQDJPJ/Rbrpo+4ava71YrFYxbXY3m3catsZPYscyq24YqpmRJm2JjJBObpgw/L
VO3iiAnfaJHYWvjiq0RdDsocDBrjSneCUA4cIcnNFjv5M3AZ7sIVxQ7WFiUN10g9A1w6iua1
XgHCOI4p/JiGwd5JFMr2klwat3+bMndxGAWr3hsRQD4mhRRMhT/pmf12w/sjYM6q8oPqhXET
dE6HgYqqz5U3OkR99sqhRN405mU0xa/FlutX6XkfcnjylAYBKsaNHAPBg6ZCz2T9LUMiPYSZ
lRElOT/Uv+MwINpmZ29jTRLAdtQhsKepfrZ3BsawtKIEmOYaHtNY580AnP9BuDRvrJFqcnam
g24eSdE3j0x5NvaFKV6lLEpU0oaA4GM5PSd6g1TQQu0f+/ONZKYRt6YwypREc4c2rfIOHIEM
rkemPa3hmV3skDee/ifI5nH0SjqUQO/PUv3pBc4mTZpiH+xWfE7bx4Jko3/3ihw9DCCZkQbM
/2BAvde9A64beTAWMzPNZhNaz+lTj9aTZbBiDwF0OsGKq7FbWkZbPPMOgF9btGfLnL7bwD7S
jOqjC9mLJIom7W6bblaOfWOcEadoiV8grCOrkojpXqkDBfSONVcmYG+cZBl+qhsagq2+OYiO
yznd0Pyywmf0Nwqfke02P9yvohcRJh0POD/3Jx8qfaiofezsFEPvXBVFzremdNJ3X8ivI9do
wATdq5M5xL2aGUJ5BRtwv3gDsVRIatYDFcOp2Dm06TG1OYHIcqfboFDALnWdOY87wcAsoUzS
RfLokMxgcfQhE9FU5PUdDuuo9Ij6FpIzxwGA2xrRYiNOI+HUMMChm0C4lAAQYF2karFXrpGx
5njSC3EWO5JPFQM6hSnEQWAXPfa3V+Sb23E1st5vNwSI9msAzPblw38/ws+Hn+F/EPIhe/31
z99+A5+01R9gPB1bRb/xfZHiZoadHnD8kwxQOjfiO20AnMGi0ewqSSjp/Daxqtps1/RflyJp
SHzDH+B99LCFRe/S71eAiel//wwfFUfAiSpaC+f3LYuV4XbtBiw1zTcrlSJvfu1veNcub+QK
0yH68kr8gAx0jd8RjBi+5hgwPPb0Lk7m3m9jtgNnYFFrMON46+EFiR4+6CSg6LykWpl5WAmP
bgoPhvnYx8zSvABbsQgf5la6+au0omt2vVl7Ah5gXiCqDqIBcqcwAJPJRutCBH2+5mn3NhWI
PfDhnuDp0umJQEvH2F7DiNCSTmjKBVWOwv0I4y+ZUH9qsriu7DMDg20V6H5MSiO1mOQUwH7L
rKAGwyrveOW1WxGzciGuxvF6db750ILbKkA3hAB4HpY1RBvLQKSiAflrFVIV/xFkQjL+RgG+
uIBTjr9CPmLohXNSWkVOiGCT831Nbx3smd1UtU0bditu70CiuVoq5rApJvd8FtoxKWkGNikZ
6qUm8D7EV1IDpHwoc6BdGCU+dHAjxnHup+VCeq/spgXluhCIrmADQCeJESS9YQSdoTBm4rX2
8CUcbneZAh8AQeiu6y4+0l9K2Pbi48+mvcUxDql/OkPBYs5XAaQrKTzkTloGTT3U+9QJXNql
NdiPnP7R77GmSaOYNRhAOr0BQqve+ADAby9wnti6QnqjduHsbxucZkIYPI3ipLEawK0Iwg05
24HfblyLkZwAJNvdgiqU3AradPa3m7DFaMLmzH72CJQRXwL4O16eM6zmBcdVLxk1/wG/g6C5
+YjbDXDC5kIwL/FLp6e2PJLr1QEwniW9xb5JnlNfBNAy8AYXTkePV7oweveluPNie6R6I8oU
YHagHwa7kRtvH2TSPYDFoI+v3749HL5+efv+17dazPM89N0EGFMS4Xq1kri6Z9Q5PsCMVcy1
ThfiWZD829ynxPCR4Tkr8OsQ/YvaYhkR58kIoHZrRrFj4wDkaskgHXbwpptMDxL1jE8bk7Ij
pyzRakVUGo9JQ+994Hlzn6lwuwmx8lKB5yb4BRasZq+XRVIfnJsIXTS4U0IbiTzPoV9oEc27
lUHcMXnMiwNLJW28bY4hPqbnWGbnMIeSOsj6zZpPIk1DYpeUpE46EWay4y7Eyvo4t7Qh1xOI
cgbHVYIONX6Ya1UPDlXR0pPu0pg/IpFhVB0TUVTENoZQGX4Go3+BGSBi8EOL0o4x8imY+YtU
xsRIkWVFTndG0uT2ifzU/ah2oSKozBWiGeSfAHr4/e3X99bFnef53EQ5H1PX7ZlFzU0og1O5
0KDJVR4b0b64uNG6OSadi4OgXFIdEYPftlussGlBXf1vcAsNBSGzwZBsnfiYwg/vyivazugf
fU3cwI7INM0PXvH++PP7ojcjUdYXtOqan1bw/kSx41GL8rIgpnUtA/a4iM0tC6taTx/5oyT2
xgwjk7YR3cCYMl6+vX79CFPoZH76m1PEXlYXlTPZjHhfqwTfeTmsSps8L/vul2AVru+Hef5l
t41pkDfVM5N1fmVBa3Qe1X1m6z5ze7CN8Jg/Ox7SRkTPHqhDILTebLDU6DB7jmkfsQvgCX9q
gxW+sSbEjifCYMsRaVGrHVFHnijzgBfUDLfxhqGLR75web0nJk8mgmqDEdj0xpxLrU2T7TrY
8ky8DrgKtT2VK7KMozBaICKO0EviLtpwbSOx2DSjdRNgJ3gTocqr6utbQyx/TmyZ31o8M01E
VeclSJ5cXrUU4KSCreqqyI4CXhOA9VEusmqrW3JLuMIo07vBixdHXkq+2XVmJhaboMQaL/PH
6blkzbWsDPu2uqRnvrK6hVEB+kx9zhVAL3GgusS1V/to6pGdn9BSCD/1XIXXiRHqEz2EmKD9
4TnjYHgDpP+ta47UkltSg2LTXbJX8nBhg4x21BkKpIJHc+3MsTnYyiJWcXxuOVuVw90CftqE
8jUtKdhcj1UKZyF8tmxuKm8EVpe3aFLXRW4ycplDKjfE8YiF0+cEu7exIHyno4dKcMP9WODY
0l6VHp+Jl5GjF2s/bGpcpgQzSUXWcZlTmkMHSiMCTy10d5sjzESUcShWr57QtDpgA80Tfjpi
iw4z3GCFMgL3kmUuQk/+Er8JnThzsJ+kHKVElt8E1eWdyFbiRXhOzjwuXCRo7bpkiN9+TKSW
mRtRcWUA15gF2RLPZQej1VXDZWaoQ4KfAc8cKHjw33sTmf7BMC/nvDxfuPbLDnuuNRKZpxVX
6Paity6nJjl2XNdRmxVWlJkIEMIubLt3dcJ1QoB74/qEZejxMmqG4lH3FC39cIWolYlLjnQY
ks+27hquLx2VSLbeYGxBaQzNdfa31fBK8zQhRrVnStTkLROiTi0+RUDEOSlv5GEA4h4P+gfL
eCqQA2fnVV2NaSXX3kfBzGrlbPRlMwjXt3XetAK/o8V8kqldjL3LU3IXYxuJHre/x9HpkuFJ
o1N+KWKjtxvBnYRBpaWX2LgVS/dttFuojws8Oe1S0fBJHC5hsMKORzwyXKgU0KeuyrwXaRlH
WDomgZ7jtJWnADtjoHzbqto19+4HWKyhgV+sesu7Bhy4EH+TxXo5jyzZr7AGL+FgPcVOATB5
TmStzmKpZHneLuSoh1aBzx18zhNfSJAOzvIWmmS0mMOSp6rKxELGZ71M5jXPiUKEYBqKJ+kD
IkyprXrebYOFwlzKl6Wqe2yPYRAujPWcrJWUWWgqM131t5h4h/YDLHYivb0Lgngpst7ibRYb
REoVBOsFLi+OcN8r6qUAjqxK6l1220vRt2qhzKLMO7FQH/JxFyx0eb2R1LJkuTBn5VnbH9tN
t1qYo6U4VQtzlfl/I07nhaTN/29ioWlbcA4YRZtu+YMv6SFYLzXDvVn0lrXmEdNi89/0tj9Y
6P43ud91dzhsFNvlgvAOF/Gc0ZiuZF0p0S4MH9mpvmgWly1Jrg5oRw6iXbywnBg1cztzLRas
Tso3eAfn8pFc5kR7h8yNULnM28lkkc5kCv0mWN3JvrFjbTlA5t7He4WAd+xaOPqbhE4VuFVb
pN8kiti59aqiuFMPeSiWyZdnMDMj7qXdamEkXW8uWE3WDWTnleU0EvV8pwbM/0UbLkktrVrH
S4NYN6FZGRdmNU2Hq1V3R1qwIRYmW0suDA1LLqxIA9mLpXqpiRMGzDSyx+duZPUURU72AYRT
y9OVagOyB6WcPC5mSM/fCEVfyFKqWS+0l6aOejcTLQtfqou3m6X2qNV2s9otzK0vebsNw4VO
9OLs34lAWBXi0Ij+etwsFLupznKQnhfSF0+KvEkaDgMFNvVhsTgGR7NdX5XkkNKSeucRrL1k
LEqblzCkNgemES9VmYChCHMq6NJmq6E7oSNPWPYgE/KwbbjqiLqVroWWHDgPH6pkf9WVmBAf
ocN9kYz368A7wp5IeEK8HNeeVC/EhjunVNWPXjw4fd/pvsLXsmX30VA5Hm0XPchz4WtlEq/9
+jnVYeJj8Ahey9G5V0ZDZXlaZQucqRSXSWHmWC5aosWiBo7E8tCl4JBdL8cD7bFd+2bPgsMV
y6jTTtsHzI/JxE/uOU/oO/ih9DJYebk0+elSQOsvtEej1/rlLzaTQhjEd+qkq0M94OrcK87F
Xoe6nS7VE8E20h1AXhguJnbsB/gmF1oZGLYhm8cYHBew/do0f1O1SfMMdva4HmI3qXz/Bm4b
8ZyVXHu/luiKNE4vXRFx85GB+QnJUsyMJKTSmXg1msqEbl4JzOUBcpc5dyv0/w6JXzXNNdzq
Bl+Y+gy93dynd0u0MUNhuj1TuU1yBfWv5a6oxYLdON3NXCOFe6JhIPLtBiHVahF5cJDjCm0U
RsSVkgweZnD/ovCDCxs+CDwkdJFo5SFrF9n4yGbUUziPmh7i5+oBlBSweQtaWD3Jn2EjedbV
DzVcj0LfDxKhF/EK695YUP9NjctbWK8c5DJwQFNB7uosqsUDBiXqXBYa3DYwgTUEGipehCbl
Qic1l2EF1gyTmrizt58IshiXjr0hx/jFqVo4tKfVMyJ9qTabmMGLNQPm8hKsHgOGOUp7TDLp
03ENPzkJ5JRXrP/3399+ffsO3vd7Sn9glWDqCVesUzr4mWubpFSFsU+hcMgxAIfp2QVOv2Z9
vhsbeob7g7COCGdlzVJ0e70utdgC1vi+awHUqcFRS7jZ4pbUW8hS59ImZUY0R4zxvpa2X/qc
FgnxgZQ+v8B1GBrlYCDHvuoq6H1il1jjDBgFnUBYy/FVzIj1J6yMVr1U2G6qwA6lXB2osj8p
pLVmzaE21YW45bWoIoJEeQGLUNgQxTVF6RaZlrnNC0HqEyLLrzKX5PejBayv+tevH95+ZAzt
2NrPk6Z4TokxQkvEIZYDEagzqBvwD5Bnxqkz6Xo43BHa4ZHnqJ97RBAdOEzkHfFDjxi8lGFc
mmOeA0+WjTG+qX5Zc2yju6qQ+b0gedfmZUYsgOC8k1L3+qppF+rGGsLqr9QAKA6hzvD0SjRP
CxWYt3naLvONWqjg7AavTFjqkMowjjYJNqJFo/J404Zx3PFperYKMannkfos8oV2hYtdYqaV
pquWml1kHkG9h5txUX75/BOEf/hmB4ixweJpFQ7xnZfeGPUnT8LW2EwrYfRIT1qPezxlh77E
VpsHwtdKGwi954uoOU2M++GF9DHohgU5ZHWIebwETgi9RFO3tTP+IoimxUzgSxuEJv5Y1fD5
6qd91vKmP09YeC5qyPPc3HNW0FOjkOmp7NeZpw9ey48LJnX1OkR5g1eFATOmOU/Ef+dYVnEU
V789VJqWXc3AwVYoEMCpsO3SdyISRR6PVbXfI/UMecibLCn8DAerah5+avTkoyUooWWQBoRB
dv4bhM03bXK6x/8dByPATsHuBI4DHZJL1sA+Pwg24WrlDpZjt+22/uACo9ps/nAhkbDMYHSr
VgsRQb/LlGhpQplC+BNK48+SIIDrkWArwB20TR16ETQ2D53IHTvgzKSo2ZIbSpTHIu9YPgVj
vUmpN6DiJFItvfjzvdL7a+V/A6zgL0G0YcITq7Nj8Gt+uPA1ZKmlmq1uhV8dmT9LaGy5dURx
yBM4elFExmTYfuyV0+7AEdLcyGnbFFZDzs0VtL2JmU29qsBr4LJ95LDhDdAkghsUr79F7X9g
XRPt8PM1HR2UzvsF6xU6dV1ii1oK0MrJCnLOAyisx87zMIsnYLTdKOmyjGobshcx1PBY3nwM
HMM7eWFx3QJ6enWgW9Km5wyvVzZTOBCpjm7ox1T1B4kN7FiBDnATgJBlbQxKLrBD1EPLcBo5
3Pk6vUlzXa5PkHE5pLfEMmfZMmywptRMTL5xPcYZdTNhjDJyhGsCFUXBHXSG8+65xGaqQYtV
WHdaRmqzj/Ee3i3vmacNHN4WwOtgLZL3a3IeN6P4VkelTUhOBuvRSBbe6y8WZIwGL+BcP77w
JM/g+VXhnXCb6j81vhMGQCj3es+iHuDcOQ0gaOA6loYw5b/9wWx5uVatSzKpXXWxQdWte2ZK
1UbRSx2ulxnnXs9lyWfpOhvsXw2AXk+LZzL3jYjzrHOCKzSKrV7v1Jz+IczcjnYwNRe9SB2q
qoXdt5n77MOYMGXeIpGjXV2dRrNe1zh2iWHfZ9d4D2Awve+jr3E0aO0aWwO6f378/uGPj69/
6bJC5unvH/5gS6AlgIM9J9NJFkVeYn8tQ6KO2vWMEkPKI1y06TrC6jAjUafJfrMOloi/GEKU
sKj5BDG0DGCW3w0viy6tiwy35d0awvHPeVGDGHppnXaxiuskr6Q4VQfR+qD+xLFpILPpDPDw
5zfULMPk9aBT1vjvX759f3j35fP3r18+foQ+5z2oMomLYINlnwncRgzYuaDMdputh8XEGKCp
BesJjoKCaIAZRJHbVI3UQnRrCpXmMtpJy3qz0Z3qQnEl1Gaz33jgljx9tdh+6/THKzbPOABW
fXEelj++fX/99PCrrvChgh/+55Ou+Y8/Hl4//fr6Hkyt/jyE+unL55/e6X7yL6cNHHvlBus6
N2/GuLiBwZpVe6BgCjORP+yyXIlTaczt0EnfIX2fE04AVYAjjB9L0fG2Gbj8SNZ0A53CldPR
/fKaicWapxHlmzylxq2gv0hnIAupZ5DamxrfvKx3sdPgj7m0YxphenuO31aY8U/FDgO1W6qt
YLDdNnR6c+W8IDPYzZlf9NBeqG9m3w5wI4TzdercSz1vFLnbo2Wbu0FBujquOXDngJdyqyXT
8OZkr0Wfp4sxW0lg/5QNo/2R4vBkPWm9Eg8PtZ2qHVweUKyo924TNKk5vDVDM/9LL7Of9W5H
Ez/b+fDtYOCYnQczUcGDoovbcbKidDpunTgXYgjUO1SijmlKVR2q9nh5eekruh+A703g5dzV
afdWlM/OeyMz9dTwhB0uMIZvrL7/bhef4QPRHEQ/bnigB36VytzpfkdFRJTF1YX2l4tTOGY+
MNBoVcqZR8BQBD3xmnFY7jjcvvIiBfXKFqHWS7NSAaLlYUV2n9mNhenhU+3ZuwFoiEMxdAtS
iwf59ht0snRed72HzBDLHg6R3MFwKH5yYaBGgs3+iBh/tmGJlGyhfaC7DT0cAbwT5l/rcI1y
w2E8C9ITeos7520z2J8VEaQHqn/yUdevhgEvLWw7i2cKj/7CKeifUZvWGpcfB785tz0WkyJz
jmgHXJJzFQDJDGAq0nlobR4wmZMr72MB1rNl5hFg2B/OsjyCLoKA6DVO/3sULuqU4I1zKKuh
Qu5WfVHUDlrH8TroG2y5d/oE4mtjANmv8j/JOk3Q/0vTBeLoEs46ajG6jprK0vvg/oi9JE2o
X+XwZlY89Uo5mVV2YnVAmeg9oFuGVjD9FoL2wQo7mTUwdakFkK6BKGSgXj05adZdErqZ+96y
DOqVhzvV17CK0q33QSoNYi3yrpxSqbP7Ww9jNx/vjgAwM7fLNtx5OdVN5iP0gatBnbPVEWIq
Xu+IdWOuHZDqzw7Q1oV8WcX0sU44naPNT01CnpVMaLjq1bFI3LqaOKqnZyhPijGo3sQV4niE
U32H6Tpn2meuLDXaGSeQFHJEI4O5Ax7ukFWi/6He1oB60RXEVDnAsu5PAzMtbvXXL9+/vPvy
cVjlnDVN/yFnCmY0VlV9SFJrwdz57CLfht2K6Vl0VradDc4ZuU6onvWSLOFQuG0qsiJKQX8Z
LVvQiIUzi5k643Nb/YMco1hVKyXQPvrbuNE28McPr5+x6hUkAIcrc5I1NlKgf1BzMxoYE/HP
VyC07jPgRPbRnLOSVEfKqGywjCeqIm5YZ6ZC/Pb6+fXr2+9fvvoHCm2ti/jl3X+YArZ6StyA
DT7jlP4Hj/cZ8c5CuSc9gT4h4ayOo+16RT3JOFHsAJoPSb3yTfGG85ypXINjxJHoT011Ic0j
Somt4qDwcAx0vOhoVBUFUtL/47MghJVivSKNRTFatmgamHCZ+eBBBnG88hPJkhi0Wy41E2fU
kfAiybQOI7WK/SjNSxL44TUacmjJhFWiPOFN3oS3Er9mH+FRGcNPHbR9/fCDS2svOGyy/bKA
EO2jew4djmQW8P60XqY2y9TWp4ysHXDNMormHmHOgJyLupEbvISRTjxybre1WL2QUqnCpWRq
njjkTYG9Jsxfr7cvS8H7w2mdMi04XGb5hBaZWDDcMP0J8B2DS2wIeiqn8YO6ZoYgEDFDiPpp
vQqYQSuWkjLEjiF0ieItVgHAxJ4lwFdQwAwKiNEt5bHHJp0IsV+KsV+MwUwZT6lar5iUjLRq
VmFq9Yfy6rDEq3QXxEwtqEyy1abxeM1Uji43eZoz4ee+PjITj8UXxogmYUlYYCFeLvMrM1kC
1cTJLkqYiWQkd2tm1MxkdI+8mywzp8wkN1RnllsPZja9F3cX3yP3d8j9vWT390q0v1P3u/29
Gtzfq8H9vRrcM7M8Iu9GvVv5e27Fn9n7tbRUZHXehauFigBuu1APhltoNM1FyUJpNEe8cnnc
QosZbrmcu3C5nLvoDrfZLXPxcp3t4oVWVueOKaXZFbMouEiPt5xcYjbIPHxch0zVDxTXKsMB
/5op9EAtxjqzM42hZB1w1deKXlRZXmAbdyM3bWy9WNNNQZExzTWxWva5R6siY6YZHJtp05nu
FFPlqGTbw106YOYiRHP9HucdjZtC+fr+w9v29T8Pf3z4/O77V0avPhd6CwfaLb40vwD2siIH
7pjS+0TBCIdwvrNiPskc0TGdwuBMP5JtHHCCLOAh04Eg34BpCNlud9z8CfieTUeXh00nDnZs
+eMg5vFNwAwdnW9k8p2VApYazosK2h2JPz609LQrAuYbDcFVoiG4mcoQ3KJgCVQvIL4Qdf0B
6I+JamtwfFcIKdpfNsGkr1kdHaFnjCKaJ3N46Wx7/cBwcIPtShts2Dw7qLEFupp1U14/ffn6
4+HT2z/+eH3/ACH88WHi7dajX/JPBHfvXizoXMJbkN7I2HelOqTeuzTPcBOAtaTtW+VU9o8V
NgtvYfeS3qrMuNcbFvXuN+xT51tSuwnkoKpITlwtLF2APGuxt+ot/LPCFjxwEzBX0pZu6AWF
Ac/FzS2CqNya8d5ojCjVh7ctfoi3aueheflCjBhZtLbGWJ0+Y68RKGgO/xbqbLg8Jj00kckm
C/XAqQ4XlxOVWzxVwukaqBY5Hd3PTA8r483aHxIpvkwwoDlodgLa4+p46wZ1TH1Y0DuNNrB/
xGwfzXfxZuNg7iGzBQu3gV/cNgA36kd6Vndn7E4aNQZ9/euPt5/f+2Pas+Y8oKVbmtOtJ9od
aCZxa8igofuBRqss8lF4wO6ibS3SMA68qlfr/Wr1i3O97nyfndOO2d98t7VH4c422X6zC+Tt
6uCuCTYLkotMA71Jype+bQsHdjVjhpEa7bE/yAGMd14dAbjZur3IXfKmqgdDE974AMMpTp+f
H4I4hDFr4g+GwbABB+8DtybaJ9l5SXgGsAzqGq8aQXuCMnd1v0kH/TzxN03t6s/Zmiq6w9HD
9Dx79nqoj2iJPNP/CdwPBBVWS2EFWjsfZnpiNp+JtJG9kk83Q3e/SC/EwdbNwLwc23sVaYeo
9/VpFMWx2xK1UJVyZ7BOz4zrldtRZdW1xq/A/BrCL7U1rq8O97+GKOJMyTHRnAKkjxc0Sd2w
R50A7q9G6T/46b8fBuUb75pNh7Q6KMbWOl6CZiZToZ52lpg45BjZpXyE4CY5ggoBM65ORJuI
+RT8ierj2/97pV83XPaBhzyS/nDZR54ZTDB8F74eoES8SIBHsAxuJ+cZhYTAJrVo1O0CES7E
iBeLFwVLxFLmUaSljHShyNHC125WHU8QtUhKLJQszvEBL2WCHdP8QzNP+xB47NInV7zjNFCT
K2zBF4FGfqZitcuCdM2Sp1yKEj2x4QPRE1yHgf+25MEXDmEvoe6V3ugwM498cJiiTcP9JuQT
uJs/GCZqqzLn2UGmvMP9TdU0rmopJl+wk7McHi5YO0cTOGTBcqQoxrLLXIISzA3ciwaeyotn
t8gWdVX36iyxPFoUhm1OkqX9IQHlM3RaNRj5gZmBTNkWdlIyrtkdDDQATtDJtbS6wvZah6z6
JG3j/XqT+ExKDQmNMAxIfM+B8XgJZzI2eOjjRX7S28Rr5DNgNsVHvWfzI6EOyq8HAsqkTDxw
jH54gn7QLRL01YtLnrOnZTJr+4vuCbq9qGegqWocoXksvMbJlREKT/Cp0Y29LKbNHXy0q0W7
DqBx3B8vedGfkgt+TjMmBMZzd+Q1mcMw7WuYEEtbY3FHc10+43TFERaqhkx8QucR71dMQrAh
wPv2EadSxJyM6R9zA03JtNEWOyJE+QbrzY7JwNqvqIYgW/xSBUV2diCU2TPfYy8r5eHgU7qz
rYMNU82G2DPZABFumMIDscO6uYjYxFxSukjRmklp2Art/G5hephde9bMbDG6s/GZpt2suD7T
tHpaY8psVNC1jIw1U6Zi67kfi0Fz3x+XBS/KJVXBCqsznm+SPg7VP7WknrnQoHtujyitiY63
3z/8H+MwzZr2UmAjMiKKgTO+XsRjDpdg3X6J2CwR2yViv0BEfB77kLw/nYh21wULRLRErJcJ
NnNNbMMFYreU1I6rEqNLwsCpozU8EfRUd8LbrmaCZ2obMsnrbRCb+mBEkBiGHjmxedQ7+YNP
HEGRYXPkiTg8njhmE+02yidGU5tsCY6t3pJdWljwfPJUbIKY2gqZiHDFElr+SFiYadnh4Vbp
M2dx3gYRU8niIJOcyVfjdd4xOBw801E/UW2889E36ZopqV5+myDkWr0QZZ6ccoYw0yXTOw2x
55JqU70qMD0IiDDgk1qHIVNeQyxkvg63C5mHWyZzY4SfG7BAbFdbJhPDBMzMY4gtM+0BsWda
wxz/7Lgv1MyWHW6GiPjMt1uucQ2xYerEEMvF4tpQpnXEzt+y6Jr8xPf2NiXWmKcoeXkMg4NM
l3qwHtAd0+cLiV/lzig3J2qUD8v1Hblj6kKjTIMWMmZzi9ncYjY3bngWkh05cs8NArlnc9Mb
6IipbkOsueFnCKaIdRrvIm4wAbEOmeKXbWqPrYRqqe2ZgU9bPT6YUgOx4xpFE3prx3w9EPsV
852j0qRPqCTiprgqTfs6pnsqxHGff4w3e1STNX3EPoXjYZBPQu5b9STfp8djzcQRpaovetdR
K5Ztok3IjUpNUBXMmajVZr3ioqhiG+sFlesnod4jMZKYmfHZUWKJ2TjzvJ1BQaKYm/uH6Zeb
N5IuXO24hcTOW9xoA2a95mQ/2K9tY6bwdZfrWZ6JoTcSa729ZPqkZjbRdsdMzpc0269WTGJA
hBzxUmwDDgdb0Owsi6/kFyZUdW65qtYw13k0HP3FwikX2jUxMMmHMg92XH/KteBG7igQEQYL
xPYWcr1WSZWud/IOw82gljtE3Bqo0vNma6y8Sb4ugefmQENEzDBRbavYbquk3HJyhl7/gjDO
Yn4jpXZxuETsuF2ArryYnSTKhDy6wDg3j2o8YmebNt0xw7U9y5STPlpZB9zEbnCm8Q3OfLDG
2YkMcK6UV5Fs4y0jxF/bIOQEwWsbh9x28hZHu13E7FSAiANmwwXEfpEIlwimMgzOdBmLwwQB
Wk7+dKv5Qk+QLbOIWGpb8h+ku/qZ2a5ZJmcp54Z4mvGKtkmwuGEEhgQVdgD0gElaoag/2pHL
Zd6c8hIMHg8H973Rtuyl+mXlBq6OfgK3Rhjng33biJrJIMutyY1TddUFyev+JoxP3v/v4U7A
YyIaa0724cO3h89fvj98e/1+PwoY07ZuN/9xlOHuqCiqFBZVHM+JRcvkf6T7cQwNz9TNXzw9
F5/nnbKi88z64rd8ll+PTf603CVyebE2uH2K6rgZE/tjMhMKhlE80Dy+82FV50njw+PLZIZJ
2fCA6p4a+dSjaB5vVZX5TFaN978YHewg+KHBVUPo46DVOoODc/nvrx8fwGTGJ2Kp2pBJWosH
UbbRetUxYaYbzfvhZjPsXFYmncPXL2/fv/vyiclkKPrw7sv/puGWkyFSqSV8Hle4XaYCLpbC
lLF9/evtN/0R375//fOTeZm6WNhW9KpK/axb4XdkeEAf8fCahzfMMGmS3SZE+PRNf19qq6zy
9tO3Pz//tvxJ1jggV2tLUaeP1lNF5dcFvmp0+uTTn28/6ma40xvMVUMLCwgatdNbqjaXtZ5h
EqMsMZVzMdUxgZcu3G93fkknZXSPmexW/nARx47LBJfVLXmuLi1DWVOdxsxdn5ewEmVMqKo2
XgplDomsPHpUHzb1eHv7/d3v77/89lB/ff3+4dPrlz+/P5y+6G/+/IVoz4yR6yYfUoaZmsmc
BtALOFMXbqCywjqvS6GMfVHTWncC4iUPkmXWub+LZvNx6yezriF8kzTVsWWMkxIY5YTGoz0C
96MaYrNAbKMlgkvKKth58HyIxnIvq+2eYcwg7RhiuN33icGksk+8CGE81vjM6MiGKVjRgXtM
b2WLwHKrHzxRch9uVxzT7oNGwgZ6gVSJ3HNJWq3mNcMM6ugMc2x1mVcBl5WK0nDNMtmNAa3t
HIYw5lV8uC679WoVs93lKsqUM6nblJt2G3Bx1KXsuBij6Vwmht5LRaA90LRcP7Ma1yyxC9kE
4eSZrwF73xxyqWnhLaTdRiO7S1FT0Hj6YhKuOrD4TYIq0Rxh5ea+GJTyuU8CpXMGN8sRSdwa
/Dl1hwM7NIHk8Ewkbf7INfVo0pvhhmcF7CAoErXj+odekFWi3LqzYPOS0PFp3+77qUyLJZNB
mwUBHnzzZhSe/DG93DzM5r6hEHIXrAKn8dINdBPSH7bRapWrA0WtIrfzoVaxl4JaVFybAeCA
RhJ1QfPAZRl1ta80t1tFsdt/T7WWh2i3qeG77IdNseV1u+62K7eDlX0SOrUySyR1QFSIJoK4
bpoliUu5Rgr0F1nghhh1tn/69e231/fzSpq+/foeLaDg+SplFpWstdbHRtXiv0kGNCSYZBS4
Aq6UEgdiEx6bCIQgytjaw3x/AIspxKQ7JJWKc2W01pgkR9ZJZx0ZPfJDI7KTFwGsVN9NcQxA
cZWJ6k60kaaoNXcNhTHuMfioNBDLUZVP3UkTJi2ASS9P/Bo1qP2MVCykMfEcrOdhB56LzxOS
nNvYslsbVRRUHFhy4FgpMkn7VJYLrF9lxJiRsYn87z8/v/v+4cvn0Q2Zt6WRx8zZNADia0QC
al2znWqi4GCCz8YOaTLG6w1Y1kux2cmZOhepnxYQSqY0Kf19m/0KTyQG9Z/cmDQc5b4Zo7dr
5uMHc5zEWBYQ7hOZGfMTGXBiussk7r4gncCIA2MOxK9GZxDrJsNDukFfkoQctgPEluaIYz2R
CYs8jOhUGoy8WwJk2KIXdYLdM5laSYOoc5tsAP26Ggm/cn2H7xYON1qy8/Cz2K71akQtlwzE
ZtM5xLkFe7FKpOjbQeIS+OEOAMQWNiRnnmulssqI1zlNuA+2ALOOklccuHG7kqs/OaCOYuSM
4pdSM7qPPDTer9xk7aNpio07ObRPeOmsS1XaEalGKkDkNQ7CQRamiK/oOnmqJS06oVQ9dXgM
5hjONgkbJ8zOxOWbujGlml5VYdDRpTTYY4xvfAxktzVOPmK927oOmQwhN/hqaIKcSdzgj8+x
7gDOIBt8rdJvSA7dZqwDmsbwYs+esbXyw7uvX14/vr77/vXL5w/vvj0Y3hyMfv33W/YEAgIM
E8d84vbPE3JWDTBd3aTSKaTzFgKwVvSJjCI9SluVeiPbffQ4xCiwZ2PQrg1WWOfXvkjEF+i+
63WTkvdycUKJtu6Yq/PYEsHkuSVKJGZQ8vgRo/48ODHe1HkrgnAXMf2ukNHG7cycDy+DO48u
zXimD5DNOjq8ff3BgH6ZR4JfGbGdGPMdcgNXsR4WrFws3mMbExMWexhc/TGYvyjeHKtbdhzd
1rE7QVjLqEXt2ICcKUMoj8Em9sYjqaHFqB+LJZltiuxrscxex53t3kwcRQfeJ6uiJWqUcwBw
AnSxvrvUhXzaHAZu2cwl291Qel07xdh7A6HoOjhTIHPGeORQioqjiMs2EbZ9hphS/1OzzNAr
i6wK7vF6toU3TGwQR8ScGV9SRZwvr86ks56iNnXewlBmu8xEC0wYsC1gGLZCjkm5iTYbtnHo
wjzjVg5bZq6biC2FFdM4RqhiH63YQoC2WLgL2B6iJ8FtxCYIC8qOLaJh2Io1z2cWUqMrAmX4
yvOWC0S1abSJ90vUdrflKF98pNwmXormyJeEi7drtiCG2i7GIvKmQ/Ed2lA7tt/6wq7L7Zfj
EdVNxA17DsdfPeF3MZ+spuL9Qqp1oOuS57TEzY8xYEI+K83EfCU78vvM1AeRKJZYmGR8gRxx
x8tLHvDTdn2N4xXfBQzFF9xQe57Cj9xn2BxsN7U8L5JKZhBgmSdGqGfSke4R4cr4iHJ2CTPj
vp9CjCfZI644adGHr2ErVRyqirrIcANcm/x4uByXA9Q3VmIYhJz+KvGZC+J1qVdbdmbVVEwc
580UqKAG24j9WF9Gp1wY8f3JSuj8GPFlepfjZw7DBcvlpLK/x7Gdw3KL9eII/Ui68qwAIenM
6NExhKveRhgi0aZ56uwVASmrVhyJEUBAa2w7uEndCRIctqBZpBDYBEIDh2lplYEQPIGi6ct8
IuaoGm/SzQK+ZfE3Vz4dVZXPPJGUzxXPnJOmZhmpZdzHQ8ZyneTjCPumkfsSKX3C1BO4+VSk
7hK9i2xyWWEz7TqNvKS/fR9utgB+iZrk5n4a9Wekw7Vaohe00EdwPvpIYzretxrq0xPa2HUi
CV+fg7fliFY83g/C77bJE/mCO5VGb6I8VGXmFU2cqqYuLifvM06XBJtl0lDb6kBO9KbD2s+m
mk7ub1NrPxzs7EO6U3uY7qAeBp3TB6H7+Sh0Vw/Vo4TBtqTrjP4dyMdYM3ZOFVgzSx3BQKMf
Qw34lqKtBDf2FDE+iRmob5ukVFK0xEUT0E5JjAoIybQ7VF2fXTMSDNu2MJfTxrqE9acwX3d8
ApOPD+++fH313SPYWGkizUn9EPkHZXXvKapT316XAsDldwtftxiiScCC0wKpsmaJglnXo4ap
uM+bBjY55RsvlvW0UeBKdhldl4c7bJM/XcBqRoJPRK4iyyt6J2Kh67oIdTkP4IWaiQE0G4X4
mrd4kl3d4wpL2KMKKUoQtHT3wBOkDdFeSjyTmhxkLkMwU0ILDYy5YusLnWZakEsKy95KYtHE
5KAFKVAVZNAMbvJODHGVRrt4IQpUuMBaFNeDs6gCIiU+ZAekxGZsWri/9ry4mYhJp+szqVtY
dIMtprLnMoEbIlOfiqZuPa2q3DjS0NOHUvqvEw1zKXLnYtEMMv8m0XSsC1wVT93Y6ru9/vru
7SffbTMEtc3pNItD6H5fX9o+v0LL/sCBTsq6YkWQ3BDHSqY47XW1xecxJmoRYyFzSq0/5OUT
h6fg0p4lapEEHJG1qSKbhJnK20oqjgAHzbVg83mTg+rbG5YqwtVqc0gzjnzUSaYty1SlcOvP
MjJp2OLJZg92CNg45S1esQWvrhv8SJkQ+IGoQ/RsnDpJQ3yqQJhd5LY9ogK2kVROHu0gotzr
nPDLJpdjP1av86I7LDJs88FfmxXbGy3FF9BQm2Vqu0zxXwXUdjGvYLNQGU/7hVIAkS4w0UL1
tY+rgO0TmgmCiM8IBnjM19+l1IIi25f11p4dm21lnQozxKUmEjGirvEmYrveNV0Ra6aI0WNP
ckQnGuvNXrCj9iWN3MmsvqUe4C6tI8xOpsNsq2cy5yNemog6sLMT6uMtP3ilV2GIDzltmppo
r6OMlnx++/HLbw/t1Rho9BYEG6O+Npr1pIgBdi1VU5JIOg4F1SGOnhRyznQIptRXoYgvQUuY
Xrhdea8xCevCp2q3wnMWRqlrWcIMXucXo5kKX/XEC62t4Z/ff/jtw/e3H/+mppPLijzdxKiV
5FyJzVKNV4lpF0YB7iYEXo7QJ4VKlmJBYzpUK7fkkAyjbFoDZZMyNZT9TdUYkQe3yQC442mC
xSHSWWB1iZFKyE0XimAEFS6LkbJutp/Z3EwIJjdNrXZchhfZ9uT+eyTSjv1QAw9bIb8EoOXe
cbnrjdHVx6/1boUfWWI8ZNI51XGtHn28rK56mu3pzDCSZpPP4FnbasHo4hNVrTeBAdNix/1q
xZTW4t6xzEjXaXtdb0KGyW4heVw81bEWyprTc9+ypb5uAq4hkxct2+6Yz8/TcylUslQ9VwaD
LwoWvjTi8PJZ5cwHJpftlutbUNYVU9Y034YREz5PA2ywZuoOWkxn2qmQebjhspVdEQSBOvpM
0xZh3HVMZ9D/qsdnH3/JAmL7GHDT0/rDJTvlLcdk2MW7kspm0DgD4xCm4aAWWfuTjctyM0+i
bLdCG6z/hSntf96SBeBf96Z/vV+O/TnbouxGfqC4eXagmCl7YJp0LK368u/vxqH5+9d/f/j8
+v7h69v3H77wBTU9STSqRs0D2DlJH5sjxaQSoZWiJ8vR50yKhzRPR2/zTsr1pVB5DIcsNKUm
EaU6J1l1o5zd4cIW3Nnh2h3xO53Hn9zJ0yAcVEW1JdbdhiXqtomxeZER3XorM2Bb5HkDZfrz
20m0WsheXFvvMAcw3bvqJk+TNs96UaVt4QlXJhTX6McDm+o578RFDqZ+F0jHUbPlZOf1nqyN
AiNULn7yz7//+PXrh/d3vjztAq8qAVsUPmJsuWU4GDReSvrU+x4dfkOsWRB4IYuYKU+8VB5N
HArd3w8Ca1Uilhl0BrevOfVKG602a18A0yEGioss69w95OoPbbx25mgN+VOISpJdEHnpDjD7
mSPnS4ojw3zlSPHytWH9gZVWB92YtEchcRnM6ifebGGm3OsuCFa9+H+cXVtz3LiO/iv9dCqp
PadG1271wzyodelWrJtFtdyeF5Un8Uxc69gp2zk72V+/AHUjASqZsw8zcX8gKV5BgASBhnBi
Ceu9MiatRKynHfYNw7mfaUOZEmdGOKRbygDX+FrlB9tJzYojVNNmAxp0WxEZIi6ghUROqFub
AqrtIYaCF6ZDT0nQsVNV16ruI49Cj9odmKxFPD6BMaK4JQyLQG+PKDKMtUBKT9pzjVewhomW
1WcXBkLtA9gf56g844sMxji7+b6BTcIx1hBdlOObzwi2soZrUwq1ZdTpBWZXZylI46LWQr4Z
0kRh3Z4bevANA7v1vG0faQ8zJpLr+2uUrd+Dxpyuf/KQrFULX5s6fYePprsmZRr8QmaqKnEo
Oi78EyamaJcxCAPn0lMGjFH7F0Wl+QiMpHZ3MHzLjZDA2z2YXMRRwXaM6W1jlLAKhYXn7kD2
qlM2LDTsj4r2bc149UjpWjZW0hEIziEjAUaL1Uq+yMkEa0mbQdtzfU3MtzDmJRFVMVsM6Ayl
iysjXqsxvcZRm56mfjBsUTOxq/lwT7QiXi+0w0t61mfL3RJeijd5GLEBEjA9ziUI/X7dHx0+
KRWyqeIqvUh5BS4OSNKwEBpW9Snn+A7nKFhmAQN1wLVnIpw6vhkP8LAV8MM2JMdJ3hrzSUJf
yCau5Rsnh2nd8jUxLZc0rpmUNdE+8MGes0Ws1ROpE4YSJ686zZGfJSEXY+M+oOaLTMk3uqQ8
M74hc8WF6Rt8/HCdaSisMxnoYHXfKVgZgDkFB8lsH3b7tV1N3lkGeFuoMSh5Sf2TrXB6ZReZ
1hY+QQ8rnYaF6pbFfJ0YCpNTF7Q+Mw1Z8hp1eFDPqXhl/7PWSc4JtHTWcQdNBJTbooh+waez
BhUUjweQpJ8PDPYD813udx1vk9DfaZZzg7lB5u3ohQrFMidi2JKb3oVQbO4CSpiKVbGl2C2p
VNEE9KIrFoeGZi3CSyb/YmWewubKCJKLi6tEExYHtR7P70pyt1OEe/WQR+lmVXcYPwQqxc7a
nnjyFDRzh8GGlzYDZXiwM80W7iwJ6cFfm7QYr9k370S7kY/V3y/zZykq0CKD/WfFqUxlKDET
IZ/oM4k2BaXSloJN22hmSCrKuin8DQ8wKXpMCu2ybRyB1N6mmhmvAjd8BJKmgW09YnhzFqzS
7W19qtRTiQH+rcrbJpuPXZalnT683N9gSKV3WZIkG9vde+9XdMc0a5KYHo+P4HAjxw108IKp
r2q0zJhdK6EjKXwYNIzi81d8JsTO9fAIw7OZrNh21HAkuq2bRAisSHETMlXgcE4doq4tuOF8
UOIgJVU13e4kxWQFo5S3Zj3jrFrcOPqZANVmf6DnGjdreV7gbWm3jXDfKaMnOXcWlsCotFFd
cPUcY0FXBCpphjTI8MqhxN3Tx4fHx7uX75Opzebd27cn+Pefm9f7p9dn/OPB+Qi/vj78c/PH
y/PTGzCA1/fUIgeNtZquD0GHF0mOpiDU6K1tw+jETv2a8TXfHAo0efr4/El+/9P99NdYE6gs
sB70cLb5fP/4Ff75+Pnh6+LQ7xue8C65vr48f7x/nTN+efhLWzHTfA3PMRcA2jjceS5TXgDe
Bx4/XI1De7/f8cWQhFvP9g1SAOAOK6YQtevxi8dIuK7Fz/KE73rsIhzR3HW4xJd3rmOFWeS4
7NzhDLV3PdbWmyLQfJQvqOqPf5xbtbMTRc3P6NBY+tCm/UCTw9TEYh4kdnodhtsh1KtM2j18
un9eTRzGHcbVYIqkhF0T7AWshghvLXZ+N8JSSOMGhbuAd9cIm3Ic2sBmXQagz9gAgFsGXglL
C4E8TpY82EIdt+YTSX4BMMB8iuLzr53HumvCTe1pu9q3PQPrB9jniwMvYS2+lG6cgPd7e7PX
wkkpKOsXRHk7u/riDrE9lCmE6/9OYw+Gmbez+QqWJ+weKe3+6Qdl8JGScMBWkpynO/P05esO
YZcPk4T3Rti3md45wuZZvXeDPeMN4VUQGCbNSQTOcgkW3X25f7kbufSqGQjIGGUIEn5OS0NP
ZzabCYj6jOshujOldfkKQ5SbClWds+UcHFGflYAoZzASNZTrG8sF1JyWzZOq0wOXLGn5LJGo
sdy9Ad05PpsLgGovTGfU2IqdsQ67nSltYGBsVbc3lrs3tth2Az70ndhuHTb0RbsvLIu1TsJ8
/0bY5usC4FqLoTXDrbns1rZNZXeWsezOXJPOUBPRWK5VRy7rlBJ0Bss2kgq/qHJ29tN88L2S
l+9fbUN+pIYoYyKAekl05Ju6f+UfQnYWnbRBcsVGTfjRzi1mJTQHHsGNuicW5AdcKAqvdi6f
6fHNfsd5BqCBteu7qJi+lz7evX5eZUkxvqBl7UZ3Fty8Dt93S7ld2QgevoCM+e97VH9nUVQX
reoYpr1rsx4fCMHcL1J2/WUoFdSvry8guKJzBmOpKCXtfOckZm0xbjZSaqfp8VgJA4gMG8og
9j+8frwHif/p/vnbK5WjKZffuXwzLnxHC5Y0MlvHcBKGTsuyWO79i6Ps/5+MP0cd/1GNj8Le
brWvsRyK6oM0rkhHl9gJAgvfjo1HZovfDJ5N13GmByPDrvjt9e35y8P/3uOF76BTUaVJpget
rag1NykKDTWLwNE8MunUwNn/iKi5n2Hlql4JCHUfqAGbNKI8tVrLKYkrOQuRaexUo7WO7neN
0LYrrZQ0d5XmqOI0odnuSl2uW1uzZFRpF2Kur9N8zW5Up3mrtOKSQ0Y12B+n7toVauR5IrDW
egDX/pbZmahzwF5pTBpZ2m7GaM4PaCvVGb+4kjNZ76E0AllwrfeCoBFof7vSQ+053K9OO5E5
tr8yXbN2b7srU7KBnWptRC65a9mq3Zg2two7tqGLvJVOkPQDtMZTOY+Jl6hM5vV+E3eHTTod
z0xHIvK54usb8NS7l0+bd693b8D6H97u3y8nOfoRomgPVrBXBOER3DJTUXwOsbf+MoDUTgXA
LSikPOlWE4CkkQbMdZULSCwIYuEOQXJMjfp49/vj/ea/NsCPYdd8e3lAg8SV5sXNhVj9Toww
cuKYVDDTl46sSxkE3s4xgXP1APqX+Dt9Dbqlx4x6JKg6H5BfaF2bfPS3HEZEjbu0gHT0/JOt
HTZNA+WoBmLTOFumcXb4jJBDapoRFuvfwApc3umW5iphSupQO9wuEfZlT/OP6zO2WXUH0tC1
/KtQ/oWmD/ncHrJvTeDONFy0I2Dm0FncCtg3SDqY1qz+xSHYhvTTQ3/J3XqeYu3m3d+Z8aKG
jZzWD7ELa4jD7PoH0DHMJ5caajUXsnxy0HADatcs2+GRT5eXlk87mPK+Ycq7PhnU6WHEwQxH
DN4hbERrhu759BpaQBaONHMnFUsiI8t0t2wGgbzpWI0B9WxqnCbNy6lh+wA6RhA1AANbo/VH
O+8+JbZqg2U6vt6tyNgOzydYhlF0VmdpNPLn1fmJ6zugC2PoZcc4eyhvHPjTblakWgHfLJ9f
3j5vwi/3Lw8f755+uXp+ub972rTLevklkrtG3HarNYNp6Vj0EUrV+HrYtAm06QAcIlAjKYvM
j3HrurTQEfWNqOoTZ4Ad7fHXvCQtwqPDc+A7jgnr2SXhiHdebijYnvlOJuK/z3j2dPxgQQVm
fudYQvuEvn3+4z/6bhuhGzvTFu258x3E9DxLKXDz/PT4fZStfqnzXC9VO7Zc9hl8DWVR9qqQ
9vNiEEkEiv3T28vz43Qcsfnj+WWQFpiQ4u4vtx/IuJeHk0OnCGJ7htW05yVGugR92Xl0zkmQ
5h5AsuxQ8XTpzBTBMWezGEC6GYbtAaQ6ysdgfW+3PhETswtovz6ZrlLkd9hckq+KSKVOVXMW
LllDoYiqlj6kOiX5YMwxCNbDHfjidPZdUvqW49jvp2F8vH/hJ1kTG7SYxFTPD2na5+fH180b
3kX8+/7x+evm6f5/VgXWc1HcDoyWKgNM5peFH1/uvn5Gp7n8mcIx7MNGtXsdAOnV4VifVY8O
aBSZ1eeOenuNm0L7IQ94+viQmVCh+O1ANK6Bz1z66BQ22rNgScM7a4y5lKLJmV7aVSFwcHRL
7RFPDxNJKy6VnkMM4fMWYtUlzWAMAJsKJ+dJeNXXp1uMV5oUegH4ZLYHnS1ebBpoQ7UbFsTa
lvRc14SFsVnHpOhlnABDu7DJazTMJ05oP2qidqQNIjol83tePJMbL7U2z+xyXcmFZljRCYSl
rV7nwTwr1x5CTHh5qeWB0l69fGVEecSlHRKuVWjY5ptCOdVdYvUp8BJuCz/WhHFSlcagk0gO
ixiWgEqeYgRu3g12BdFzPdkTvIcfT388/Pnt5Q5NY0iwwL+RQf92WZ27JDwbAn7JgYNxJTPn
SvXqIWvfZviq4qiFRkDCYK0787SmjciAjua8aVbEppy+57rSpVhpou7WScACLnQKjpQui7PJ
0mg6CJanvoeXh09/3psrGNeZsTDGZOb0RhgNL1eqOwdOE99+/xfn60tSNLs2FZHV5m+mWREZ
CU3V6v6VFZqIwnyl/9D0WsPPcU6mA+WgxTE8amG3EYyyBrbG/jpRHZvLpSLtTG+GzuKUvIvJ
9Lu+kAocquhE0qDfZ7S3q8nH6rBM8qnr44fXr4933zf13dP9I+l9mRBDp/VoMggzPk8MJRlq
N+D0kH2hpEl2i1Ff01uQ5Bwvzpxt6FqxKWmWZ2i9n+V7VxOneIJsHwR2ZExSllUO22Bt7fa/
qX5xliQf4qzPW6hNkVj6ifKS5iorj+NDl/4qtva72PKM7R4tmfN4b3nGknIgHkCxvraMTULy
0fNVb7kLEZ0tlnkACvEp17SiJUXVyRcPZeuCjrw1JanyrEgufR7F+Gd5vmSq9aySrslEgkac
fdWie++9sfMqEeN/tmW3jh/set9tjRMC/h+is5yo77qLbaWW65XmrlZDzbfVGaZ21CSq1y41
6W2MD0+bYruz98YOUZIEbE2OSaroSrbzw8nyd6VFTtWUdOWh6ht0yBC7xhSzHfs2trfxT5Ik
7ik0TgElydb9YF0s41zQUhU/+1YQhuYkSXZV9Z5706X20ZhAOtPMr2GAG1tcLGMnj4mE5e66
XXzzk0Se29p5spIoaxt0qdSLdrf7G0mCfWdMg4ZwYXTxt354VZhStDXaEVpO0MLQG78zpvDc
ok3C9RT1UT+ZXajNOb/Fhej7+11/c32Rj09m0YUwX42fkwhgS5kzRePfi9Zk3NMHpx/QYWF5
2Wkve+W+FJfDvq6hoAgdpMYSh4StIsfvk5K4PZXbXnIM8ZkNbKdtXF/QBfcx6Q+Bb4Fik97o
iVESrdvS9bas81B27GsRbCnTB5EX/suAYFFCttcdj4yg4xIu3Z6yEoNfR1sXGmJbDqVX4pQd
wtEej8rXhLojVOBXae3R2YCvf8qtD10cEH48D4z6dG0S1ZlNGSH0gyHtdyMZ1HIzgVqjybE2
yR4j2IenQ09MdlVy5ogfkYdHN2zO8wmrVbagmgu+GQxRfYQlwJ6bTiny+MBB3rAMXxxnZFIn
bRl2WWcETRGyYeyaqD4S4epY2M7ZVSdnm5W3SDldAtffxZyAooujnjOpBNezOaHIgGm51y2n
NEkdaurtRABGqUUIUPCd65NV3HaJaZ9Mm4qKuWPczmNKhquIYiL55cgZbomGHtN8ja3e9I+C
NBVrCSDCTot8ookvSdnK84j++pw1V0QsyTN8PFTGMpzjYLz0cvflfvP7tz/+AOU3pjZM6aGP
ihgEJoUxp4fB0/atCi2fmY4r5OGFlitWX1tjySm+HMnzRnPqOBKiqr6FUkJGyApo+yHP9Czi
VpjLQoKxLCSYy0qrJsmOJfD7OAtLrQmHqj0t+KxhIwX+GQhG/R9SwGfaPDEkIq3QHp1gtyUp
CIbSp4lWFwE7FYynlhZdJufZ8aQ3qIBtazywEVoRqOBg82FtHI0T4vPdy6fBww1VViH3semO
ZHykuqdBdeHQ3zBQaYUsDdBSe8WBReS10G3IATx3idC/VHeNXi6GdcdzRP3rwo5J4D6cvXg6
EBog3bXvApNHNgth6W6V2GSdXjoCrGwJ8pIlbC430yxhcVxDEAovBgj4JWwbJagAWgET8Va0
2fU5MdGOJlCzu1PKCTtVQ8HKywMwA8RbP8ArHTgQeeeE7a3GLmdopSAg0sR9xJKge+SkASUN
tENOuzDI/C3h6jPPlfxOS0HY9gyx3hnhMIqSXCdkZH5noncti6bpXTVSZ3rQt5DhNyxAZJZ9
DZpgKmjqHiPJFDXsJAc8b7jVZ39SAePM9Elxdav6GgXA1fa6ETC0ScK0B7qqiis1pBViLQjB
ei+3oBrAhqcPsvqsVnIcPU8UNkVWJiYM9sgQRKBOyj0z79aI0Vm0VWFm322R6V2AwNBiMox6
EEWJiOhM+ks7c8P1fwBp69J6moNd5MNVHqeZOJERljHQ9HWboBJZFXrb8XbUISxyxKQbnSOZ
xhONDtmhqcJYnJKEbMACr/h3pLU7m7Bv9IzCkenOhnqTn+nlGS9TxK8uzyndbWemTLEQpk9B
Bs5yCI2slIUaoQt6WE5Zcw0iZtiupdMOmTUKMNNohTSoFYOjVprCm1Mwkr9OGsoV8RpFO/PW
KLAU+jS66msZSPrqV8tccp4kdR+mLaTChoGcLpLZyxymSw/DKYA8lh/P6Hn4zrnQUfmGfT50
t6aZMiWg2ihPUMe2IzSXkXOaUSLBCHJd9kO6rmMZEswBGAypBmE9rk0ljDQBA16skvNjfQK+
XAv1WHXWOH/evVNKo/Qvh+hw9/G/Hx/+/Py2+ccG9sUpgiO78cUT1cG3/RABZqkyUnIvtSzH
c1r1OE8SCgEK3TFVjQMk3naub113OjoojBcOanongm1cOV6hY93x6HiuE3o6PPmB0NGwEO52
nx7V28exwsCzr1LakEHJ1bEK3XM4apDHWWRY6auFPsoiJhINgbpQtEBjC0yjLSoZimDv2f1N
rvqcWsg0EtNCCeM60MINENLOSOIR2bRWbV3L2FeStDdS6kCLrLhQeGiyhcajYCn9rnloUb7U
+Y61y2sT7RBvbctYWthEl6gsTaQxYKq6Xn+y1qYyQNvCnYU6MTBrdyPXH+1Mnl6fH0GJG0+i
RqcLbC0PhiDwQ1SaozkVxo3uXJTi18Ay05vqRvzq+DPjAqEJNs40RYtZWrKBCEujHcRSUM6b
2x+nlbebg+3FYrny48bO67Q6Kuo0/urlvVAv/aqYCND99tZIifJz66gRgCVNnEuFMtePGc9M
mUR1LpXVKH/2lRAk0pmO9+jxNA8zRdETWill3JPwvgjV6t4yAn2Sx1opEsySaO8HOh4XYVIe
USRm5Zxu4qTWIZFcM36HeBPeFHhNr4GodEhPHlWaogmMTv2Arli+U2QMBKDZ+4ihj9A6Rwel
zQCSePvXQPQaCa0VvHOGntXgU2Po7rXANbJC4QU1jBhkWEfrtkHm7UG418MTyY+D0tanpKQO
A9aLhGl0Oi0rW9KHROidoSkTb/elOTP1XH6lCEVLe0RgVKYyon0ipwVyDgYPqflwYI6xe/FQ
DP3Ksy/1OKVAg9OUQpVmRqUZFyeBEsXzFPXZs+z+HDbkE1Wdu712IqeiWKBO6S48dRjtdz1x
ZSYHhHoxkiDvvhADp5HPGBvR1qrf1QES6tXP0AcyANrZ3vrq88ClF8h6gflahKVz8QyNqqsb
fAsFu5/eCEKcR9bSJx1ZAGFsB2pEYYm1WXapTZg8ASWcKjwHgW1xzDFgLsVuHB04tNpjhxmS
FoBRXlG2FYWWrUqYEpO+XMnkudyCQGiYVBIn+YXnBDbDtHhRC9aXyQ1oGTWpl/B91yd3W5LQ
XlJStzhs8pD2FvBJhuXhLU845Pb+j7ErW3IbV7K/oh/oGZHUeif8AJKQxBY3E6Sk8guj2tZ0
V0TZ5amy4976+0ECJAUkErJf7NI5IHYkElsm8fWC+hqBcpJmCMkQwJNDFe1tLCvTbF9RGC6v
RtM/6bAXOjCCeSmCaD2nQNRMu2KDx5KCRiN54DIXzWOHVKCuDgjq43LODda47sDuZ765zGkU
xXCsmn1gvaZUbVLlqLbzy2qxWnCBG+XiSMmyCJeo59fJ5YBmhyar2yzFGkPBo9CBtisCWqJw
p4xtQjwSBpCSDmr7rBKoV5wuYYgifih2etQqTfuQ/qEuZhqv41XLMNxUTFe4Bx6V4FRfGURB
tI7lwA3XgMto/Sjm1Fc3TlXDhwAHUHa4Rw8+zudqqpJJg1X5o1saTQ8OWDysyPYFI+tC8yc8
sm+UvQljc/gsCrHgA49hJcHgpYDGs4PN4p6IWVe4GiHUa1x/hdi27EfW2RqYmoiaPacFx9Qn
3dQa7kYms+1tbX7BJt+nLEAXkPOczPwn/mG1sIb3hcEocyYxgbVa1q6jJDQfuZlo37IGDMPH
WQuWED8s4KGPGRDcj7wjAN/TsGD5F7/jfXQM27EAS2fl/4Vl7KMHxpYQp6hEEIa5+9EKLCi6
8CHbMbxsipPUfpUyBoZT+pUL11VKggcCbuWoGDzRIubEpCaIxCfk+Zw1SJ8bUbe9U2cJWF3M
G1JqGhL26fUUY2XdZVAVweMqpnOkfDhZ7+ostmXCcvlmkUXVdi7ltoNcByVyDNvrn0stVT2O
8l+nqrclO9z9WYOkO2wZsCJdb7HCqfYSpH4XBS4OLgIQWiUOoPXsuENLCGDG4097We8EG5fm
LtNWdSUF/IPLMGfBpcGeXdQ1Kj8p6jTDFQZ0ASsGvMMwEMknqVauw2BbXLawKyvX1qY1VhS0
acFsFhFGW4l3KnGCZYN6KcsQtk0J4f1KUvciBZqIeBtolhXbfTjXVhMDXxyS3c7xusyM4rL8
RQxq5zr110mBp6YbSbZ0kR2bSu1WtEhAF8mhHr+TP1C0cVKEsnX9EScP+xLP/LzeRnIO0o06
OG9KBmue8ERy93q9vn1+fL7OkrqbTFsMD/RuQQc7tcQn/7JVPqH2Z/KeiYYYi8AIRgwN9Ukn
q/Li+Uh4PvIMF6C4NyXZYrsMb3tArcLVw6Rw+9xIQhY7vAgqPNU77HOiOnv6r+Iy++vl8fUL
VXUQGRebyLzsYXJi3+ZLZxacWH9lMNVBWJP6C5ZZJqjvdhOr/LKvHrJVCI51cK/889NivZjT
PfaYNcdzVRFS22TgUQpLmVxO9ilWo1Te967wlaDKVVaSHyjOckViktPVU28IVcveyDXrjz4T
YKoXDHGDGwq5QLAvXU9h1XJIiBYmmZyfeE5MMkmdDQEL22mQHUth2Qa2uTg9qwlh7Zs0hmBw
x+HM89wTqmiPfdwmJ3FzYwodyBwC7Ovzy99Pn2ffnx9/yN9f3+zeP/gQuOzVLTkkF29ck6aN
j2yre2RawAVHWVEt3pG1A6l2cdUeKxBufIt02v7G6jMMdxgaIaD73IsBeH/ycjaiqH0QgvNj
WDa21ij/jVYiVjSkngWeMlw0r+HYN6k7H+WeRtt8Vn/czFfEtKBpBnSwcmnRkpEO4XsRe4rg
+AWeSLlAXP2SxauZG8d29ygpBYjJaqBxo96oRnYVuMPq+1J4v5TUnTSJES6kIoW3nFRFp8XG
tMI64qMflvsTY3P9dn17fAP2zZ0OxWEhZ6+Mnpe80TixZA0xKwJKrZJtrneXhVOADu9EKqba
3RHZwDqb3SMB8pxmKir/gA++BUiyrIjzFES6N8zMQKKVy6O2Z3HWJweeHIklEAQjDsRGSo7s
hE+JqY02fxT6eE0O3PpeoPFEL6vxItIKplOWgWQLisw2VOCGHhwtDlfdpISW5b0XHuLd5aCj
KJMKVEi63kHZut899IT7O2H8/UXz3o6m6YOcSOT6QFXknWCslUJxCHsvnE8yQoiYPbQNgwdd
97rbGMoTx6SC3I9kDEbHUvCmkWXheXo/mls4z1iVK384DTjy+/HcwtHxaBerv47nFo6OJ2Fl
WZW/jucWzhNPtdtx/hvxTOE8fSL5jUiGQL6cFLxVceSefmeG+FVux5CE7ooC3I+pzfbgPO5X
JZuC0cnx/HhgTfvreIyAdEx6P9s/8oDPs1Jq50zw3Lr+bQa7tLwUxKJX1NSKEVB4+EVlup3O
hERbPH1+fbk+Xz//eH35Bld/lP+umQw3OAxwbmLdogFHX+Quh6aUHtwQauHgtXEnlNJ0Uxt+
PzN6+fL8/O+nb2D12VE4UG67cpFRNxcksfkVQZ4QSX45/0WABbWLqGBqD0AlyFJ1XNE3fF8w
6xrevbIazl9Mfct1UEUrcK2cNcD5j3NfaiDFjfT40ZI6qpkysWcy+idllDo2kkVylz4l1MYJ
3Cfu3f29iSqSmIp04PRazFOBegdo9u+nH//8dmWqeIejv1vj/W7b4Ni6MqsPmXM7yWB6RunG
E5unAd6VN+n6IsI7tFRuGDk6ZKDB8yk5/AdOK+eeBb0RzrMldml39Z7RKajn0/B3PYkylU/3
LeC0qMxzXRRqX7/JPjmXNoA4S62qi4kvJMGcSw4qKnhdP/dVmu8GleLSYBMRazeJbyNCiGp8
qAGas97GmdyG2Jxk6TqKqN7CUtb1cgmbkycirAuideRh1vhs8sZcvMzqDuMr0sB6KgNYfPvI
ZO7FurkX63a99jP3v/OnaTsLMpjTBp8a3gi6dCfLMPqNEEGAr4Qp4rgI8DnMiAfEbrfEF0sa
X0bEdgPg+PLAgK/wyfqIL6iSAU7VkcTx9SWNL6MNNbSOyyWZ/zxZWq/5LAJfrgAiTsMN+UXc
9iIhJHRSJ4wQH8nH+XwbnYieMbl2paVHIqJlTuVME0TONEG0hiaI5tMEUY9w+ptTDaKIJdEi
A0EPAk16o/NlgJJCQKzIoixCfPttwj35Xd/J7tojJYC7XIguNhDeGKPAOWYfCGpAKHxL4us8
oMu/zvHlu4mgG18SGx+xpTMrCbIZwUcf9cUlnC/IfiQJy1nTSAyHV55BAWy4jH10TnQYdUZP
ZE3hvvBE++qzfhKPqIKo51BE7dKa7fDmkiwVF+uAGtYSD6m+A0eZ1Oa874hT43THHThyKOzb
YkVNU3L1S12WMyjqoFf1eEregXm5vjlGc0pQZYLFPM+JBXZeLLaLJdHABdw2I3JQsItUozZE
BWmGGhEDQzSzYqLl2peQcyt3YpbUhK2YFaGbKGIb+nKwDalTBc34YiO1vyFrvpxRBJxdBKv+
DO8cqQU1CgO3qFpG7CDKlWqworQ9INb4Xr5B0F1akVtixA7E3a/okQDkhjouGwh/lED6oozm
c6IzKoKq74HwpqVIb1qyhomuOjL+SBXri3UZzEM61mUQ/sdLeFNTJJmYlA+kbGvylXuNTePR
ghqcTWt5YzRgSt+U8JZKFdwtUam2gWUU38LJeJbLgMzNckVJeMDJ0ra2J0cLJ/OzXFFKnsKJ
8QY41SUVTggThXvSXdH1sKKUO32Hwod7eorkNsQ047/kI7LFmhrc6io5uWcwMnRHnthpU9AJ
AJZdeyb/hdMQYp/FOCr1HTfSWzBCFCHZBYFYUnoPECtq/ToQdC2PJF0BolgsqclMtIzUpQCn
5h6JL0OiP8Jtn+16RV5QyHrBiH2PlolwSS1RJLGcU2MfiHVA5FYR+AXSQMhVLjGelW9uSrls
d2y7WVPEzfv1XZJuADMA2Xy3AFTBRzIK8BsXm/aSUgukFrCtiFgYrgllrhV6eeVhqC0I5QOc
Upu1c3AiKkVQG2lSO9lG1BLqnAchpSydwYErFVERhMt5z0+EbD0X7kX7AQ9pfBl4caIfA07n
abP04VTnUjhRrYCTlVds1tRcCDilgiqckEPUdeEJ98RDrY4Ap2SJwunyrqm5R+HE6ACcml8k
vqE0e43T43TgyCGqrljT+dpSe4TUlewRp3QDwKn1K+DUXK9wur63K7o+ttQaSOGefK7pfrHd
eMpL7W4o3BMPtcRTuCefW0+6W0/+qYXi2XPDS+F0v95SOue52M6pRRLgdLm2a0oRABy/wJxw
oryf1LHQdlXjt4pAykX4ZulZZ64pTVIRlAqolpmUrlckQbSmOkCRh6uAklRFu4oo7VbhRNIl
+JKihkhJveqeCKo+NEHkSRNEc7Q1W8nFAbNMLtknY9YnWnWEy67kCc+NtgmtS+4bVh8QO73k
GR+dZql7Ji/B2xfyRx+rA8IHuMzGy31r3ISWbMPOt9+d8+3t5aG+0fD9+hm8WUHCzmEghGcL
MC1vx8GSpFOW7THcmC8JJqjf7awc9qy2fCtMUNYgUJhvPxTSweNEVBs8P5rXhzXWVjWka6PZ
PualAycHsNaPsUz+wmDVCIYzmVTdniGsYAnLc/R13VRpduQPqEj4AanC6tDyGK8wWfI2A4ND
8dwaMIp80O+5LFB2hX1VgheEG37DnFbh4B8JVQ3PWYkRbt2K1liFgE+ynLjfFXHW4M64a1BU
h8p+fax/O3ndV9VeDrUDKywDLYpqV5sIYTI3RH89PqBO2CVgzjyxwTPLW9MOB2CnjJ+VMwiU
9EOjbRhZaJawFCWUtQj4k8UN6gPtOSsPuPaPvBSZHPI4jTxRD4cRyFMMlNUJNRWU2B3hI9qb
ZhMsQv6ojVqZcLOlAGy6Is55zdLQofZSNXLA84HzXDgNroyUFlUnUMUVsnUaXBsFe9jlTKAy
NVx3fhQ2g6PCatciuII3E7gTF13eZkRPKtsMA022t6GqsTs2SARWgm32vDLHhQE6tVDzUtZB
ifJa85blDyUSvbUUYGAFlwLByvc7hRP2cE3asqprETwVNJNkDSKkSFEOMBIkrpSZsAtuMxkU
j56mShKG6kDKZad6B/chCLSkuvKzgWtZmYWHG4boy5azwoFkZ5XzKUdlkenWOZ68mgL1kj34
hWHClP4T5OaqYE37Z/Vgx2uizidyukCjXUoywbFYAJ8S+wJjTSfawQbUxJiok1oHqkdfm8aT
FRzuPvEG5ePMnEnknGVFheXiJZMd3oYgMrsORsTJ0aeHVCogeMQLKUPB6mcXk7i2Cjz8QtpH
ruy5325gEsqT0qo6EdOqnLYE4AxKY1QNIbQFNCuy+OXlx6x+ffnx8hmcgmJlDT48xkbUAIwS
c8ryLyLDwaw7k+BljywVXC/TpbI88rkRfPtxfZ5l4uCJRl26l7QTGf3dZBXDTMcofHVIMttU
v13NzjVlZfMB3TxW5hh42iuBboXs8jobdHfr+7JEFiiVkYoG5kwm+kNiN7YdzDKOpb4rSynw
4cEJ2HhSpvfE2DGKp7fP1+fnx2/Xl59vqsmGN812pxjsiICVX5EJVFyfOTtVf+3eAfrzQQra
3IkHqDhXs4do1dhy6J35cmuoVqHqdS+liQTsd0natEdbyTWAnPbAjh14TQnt3l2O6xjVYV/e
foDNyNHbqmOBWLXPan2Zz1UzWEldoLPQaBrv4fbRu0NYr1FuqPP87xa/rJyYwIv2SKEnHncE
Dm71bJiTmVdoU1WqPfoWtZhi2xY6lnbu6bJO+RS6Ezmdel/WSbE295Etlq6X6tKFwfxQu9nP
RB0EqwtNRKvQJXaym8GjbYeQekW0CAOXqMiKG9E+r5MoxAWaWKd6JkYI3P/vV0JHZqMD00MO
KvJNQJRkgmX1VEjOKSpBgqrZgPvk7dqNquElF1JUyb8PwqUhjTgx7QmMqMDiDEB4TYaeyTmJ
mKNYm66eJc+Pb2/0LMcSVH3KEiZHY+KcolBtMe16lFLR+NdM1U1byUUBn325fgenyDMwEZGI
bPbXzx+zOD+CyO1FOvv6+D4aknh8fnuZ/XWdfbtev1y//M/s7Xq1Yjpcn7+rS+tfX16vs6dv
//ti534Ih1pPg/jdoUk5hrkGQAnJuqA/SlnLdiymE9tJXdNSw0wyE6l1MmJy8m/W0pRI08b0
LI85c9Pb5P7silocKk+sLGddymiuKjlakZnsEYwt0NSwZ9LLKko8NST7aN/Fq3CJKqJjVpfN
vj7+/fTtb8PDsCl70mSDK1ItOq3GlGhWo8fWGjtRsuGGq9e84sOGIEup5MpRH9jUwfKDNQTv
TIs1GiO6Irjai+ySKKjfs3TPsSKlGJWahRdtFynlDmEqKOlwaQqhkyEcdkwh0o6Bn8ucu2lS
BSqUkEqbxMmQIu5mCP65nyGlXxkZUv2lHqwQzPbPP6+z/PH9+or6i5JV8p+Vdco5Ud1FOw3R
KqCSmAWTwubL9RaPCih1UDk48gek8J0T1ISAKGX2w7tdREXcrQQV4m4lqBC/qAStp80EtVhS
31fWRY4JnrxVO3lmNQXD3iuYRSMoNCQ0+NERjhIOcVcBzKklVcr945e/rz/+O/35+PzHK9gx
h0aavV7/7+fT61Ur7DrI9Nbph5pZrt8e/3q+fhme6dgJSSU+qw/git5f4aFvGOgYsNaiv3AH
h8Idu9ET0zZgr7vIhOCwq7ITRBj9shzyXKWm+UslHw6ZXPhyJJxH1LIPYBFO/iemSz1JEFII
dMj1Co2vAXTWaAMRDClYrTJ9I5NQVe4dLGNIPV6csERIZ9xAl1EdhdSLOiGsmzFqJlNmnyls
Ogl6Jzjs/tqgWCbXH7GPbI5RYF6eMzh8TmNQycG6p28warl54I66oVm41aqdMnF38TjGXcsl
wYWmBg2g2JA0L2q+J5ldm2ayjiqSPGXWxpHBZLVpZdIk6PBcdhRvuUaybzM6j5sgNG9829Qy
oqtkrxxkeXJ/pvGuI3EQtzUrwWbiPZ7mckGX6ljFYHMhoeukSNq+85VaucyimUqsPSNHc8ES
jGi5m0VGmM3C8/2l8zZhyU6FpwLqPIzmEUlVbbbaLOku+zFhHd2wH6Usgb0tkhR1Um8uWDUf
OMvKDyJktaQp3juYZAhvGgaGOHPraNIM8lDEFS2dPL06eYh5o3xHUOxFyiZnQTMIkrOnprXB
GZoqyqzkdNvBZ4nnuwtsHkulk85IJg6xo4WMFSK6wFl1DQ3Y0t26q9P1ZjdfR/RnemI3Fiv2
riE5kfAiW6HEJBQisc7SrnU720lgmZnzfdXap5MKxvsKozROHtbJCi8zHpQTYzRdp+hAEEAl
mu1ja5VZuF/guF5WWc6E/M9yf2rBsKNr9+8cZVxqQmXCT1ncsBZL/qw6s0aqPwhWJnbQNpmQ
SoHaLNlll7ZDC8HBmu4OieAHGQ7vt31S1XBBDQhbgPL/cBlc8CaNyBL4I1pigTMyi5V5t01V
AdjfkFUJPticoiQHVgnrAoBqgRYPTDhmI5buyQVujaAFN2f7nDtRXDrYiSjM7l3/8/729Pnx
WS+t6P5dH4xF0bgqmJgphbKqdSoJN11rsyKKlpfRzDSEcDgZjY1DNHAo0J+sA4OWHU6VHXKC
tEYZP7j+UUYVMVLvw6wzG0/prWzotfpXF6MWAQNDLgPMr8BjMxf3eJqE+ujVnaWQYMd9GHAN
qf1FCSPcNCdMvqhuveD6+vT9n+urrInbgYDdCci93XEHGe+H9PvGxcYdVIRau6fuRzcajTaw
RLhG+SlObgyARXj3tyQ2jxQqP1ebzigOyDiSEHGaDInZa3RyXQ6BnZUYK9LlMlo5OZZzaBiu
QxJUlmnfHWKDZrN9dUQige/DOd2NtZ0MlDXt6/1knfoCoT2e6f01eyiRXcgWgjEY0gZbbHgS
cveod3Ju73OU+NiFMcphtsMgMuw3REp8v+urGM8Ku750c8RdqD5UjsYjA3K3NF0s3IBNmWYC
gwVYtSS3vXcgFhDSsSSgMNAjWPJAUKGDnRInD5bbJI1ZB/FD8amThF3f4orSf+LMj+jYKu8k
yZLCw6hmo6nS+xG/x4zNRAfQreX5mPuiHboITVptTQfZyWHQC1+6O2emMCjVN+6RYye5Eyb0
kqqP+MgDvqRhxnrCG083buxRPr7FzWdflhmR/lDWtl1GJdVskTDIP7uWDJCsHSlrkGBtD1TP
ANjpFHtXrOj0nHHdlQmss/y4ysi7hyPyY7DkTpZf6gw1on2QIIoUqMqtHKk30QIjSbWLBWJm
AK3ymDEMSpnQFwKj6rohCVIVMlIJ3gbdu5JuD5catMU0Bx0cC3r2JocwlITb92ceW9442ofa
fD6pfsoeX+MggJnKhAabNlgHwQHDO1CdzEdYQxTgEXa7uZiLgfb9+/WPZFb8fP7x9P+cXVtz
4ziu/iupeZqtOnvGkm1ZfpgHWZJjrUVJEeVL+kWVTXt6Ut2ddCXp2sn++kOQugAklEydl3T7
A8ULCII3EPjx7fLX5fm35IJ+Xcn/PLze/+maIpksxUEt5bO5Lm85J48E/j+529WKvr1enh/v
Xi9XAi4GnK2KqURStVHeCGIFaSjFMYN4NyOVq91EIWRJCvFX5SlrsE91IVDHVacaYiimHCiT
cBWuXNg6QVafthsdPc+Feuuj4RJT6og+JN4YJO62mubmS8S/yeQ3SPmx4Q98bG1uAJLJDkvd
AKlduz5VlpLYRI30yv5MaZ9yp3nGpc6breCKAWeqDX7+NJLAZryIU460hX/xaQ+qN8QLpQTj
YU9SEI4Ca4u32VatFhIKXpd5ss2wIbUuq3KYZtofW8U0Qj+hrt1muFzPWnkrYTMQM6QxsIBD
d33+ARpvVp7FoaMaKjIhEqzF4mT/5vpLoZv8kFreczuKfQ/ZwbtsvlqH8ZGYUXS0/dwt1RFF
LVD4nbluxkEpIyvDg9zZXAG2BWpgWyl7mxFXgDsCOYvQnLxxxkhTyl22idxMunAuFCS2baOo
ntMCn56iQUEue0c8EgF+iSxSIZuMqJMOGUa60ROX70/Pb/L14f6rq2GHTw6FPs2uU3kQaN0q
pBpQjtqSA+KU8LEm6kvU4w1P+QPlX9o6pGjn4Zmh1mTfPsJsx9pU0rtgUUrt9rVBpo4NNKYa
sdZ6U6EpmxqOJQs4t92d4OSvuNbXAZozKoXLc/1ZFDWejx9OGrRQ8/pyHdmwnAeLpY0qYQuI
V5IRXdqo5T7OYPVs5i087AFE47mYL+d2zTToc+DcBYmzvQFcY98LAzrzbBQeSvp2rvJQ0LBy
GlWtWrvV6lBjhEz7ltolm0pU8/XC4YECl04jquXyfHYMpAea73Ggwx8FBm7W4XLmfh4S10dj
45Y2zzqUazKQgrn9wUmEc+8Mriyagy3s2reYXcNEbZ/8hZzhR88m/5OwkDq9PuT0JsCIZuKH
M6flzXy5tnnkvLo1ltJxFCxnKxvN4+WauIowWUTn1SpY2uwzsFMgSPLyLwssGzJzme/TYut7
GzyJanzfJH6wthuXybm3zefe2q5dR/CdasvYXykZ2+TNcA45KhHjZfjbw+PXX71/6DVufb3R
dLVV+fn4GVbc7ouMq1/HNy7/sNTQBu4x7P6rRDhzNIjIzzW+2NLgQaZ2J0t4E3Db2CNVbcty
cZgYO6Ac7G4F0PhKGpjQPD98+eKq0s6A3lbjvV29FcKe0Eqlt4nNJaGqDeZ+IlPRJBOUXapW
7Rtir0Ho4wMzng5hdficI7XbP2bN7cSHjGobGtI9gBhfCzz8eAUTq5erV8PTUYCKy+sfD7Bl
urp/evzj4cvVr8D617vnL5dXW3oGFtdRITMSpp62KRLEJx4hVlGBTy4IrUgbeAc09SE8AreF
aeAWPRkyu5lsk+XAwaG0yPNu1RQeZTm8Wx+uUYZDgUz9LdRSr0iY04C6iXVg0DcMKNW1CEIv
dClmXUGgXayWkrc82D12+f2X59f72S84gYT7ul1Mv+rA6a+s7R9AxVHo8ywtEgq4enhUHf/H
HTHhhYRq+7GFErZWVTWut1wubB5wMWh7yFK1kz7klJzUR7K/hQdUUCdn/dQnDkNQVEiB9oRo
s1l+SrGh7khJy09rDj+zOW3qWJAHKz0hkd4cz0QUb2M1Fg71rdtAoGP3IxRvTzj8AqIF+O6o
x3e3IlwGTCvVHBcQ5y2IEK65aptZEbuhGig61tixbmKXVu9D7FZugOUynnMVzmTu+dwXhuBP
fuIzFTsrfOnCVbyljoUIYcaxS1Pmk5RJQsixfuE1Icd5jfP9u7mZ+3v3E6nW1utZ5BK2gjr7
HfiuZNjj8SV23YLT+wwLU6E2IYyQ1EeFc/19DInb8KEBS8GAiRofYT/G1WLh/TEOfFtP8Hk9
MY5mjBxpnGkr4Asmf41PjO81P7KCtceIab0mPu1H3i8m+iTw2D6EMbVgmG/GOtNiJaK+xw0E
EVertcUKJjwCdM3d4+eP1XAi58TgkOJqUyyw+RCt3pSUrWMmQ0MZMqR39O9WMRalZPWqz6k8
hS89pm8AX/KyEoTLdhuJDHs8oWS8qCCUNWsujZKs/HD5YZrF30gT0jRcLmw3+osZN9KsTSLG
OZUpm723aiJOhBdhw049Cp8zYxbw5drtTyFF4HNN2NwsYN/pfFBXy5gbnCBnzBg0W2amZXrL
xuBVip+pIsmHeYhh0afb4kZULt658u9H5tPjP9Um4X2Jj6RY+wHTiC44DkPIrsFhRcnUWK8B
XJieU47TFrNSMBGrGU7XC4/D4VKgVi3gFjFAgxjfLmX07GQX04RLLiuIrnR05ULBZ4ZDsolq
fQblLlvPi/WcqZA4MtU3sY9DptXOlccw4zfqf+zcHpe79cybzxkplg0nS/QccJwTPNU/TJWM
v3wXz6vYX3AfOEZlQ8EiZEto0uuaWeTI4iiZepZncic24E0wX3Pr2mYVcMvKM4gKM8Os5pw+
0EHFGN7zvKybxIMDH0dKjAXW78jRmbw8vkCg0/dGMnLMAScZjNQ7V1QJ+KDvHSU4mL0RRJQj
uTiAV3WJ/aAzkrdFrAS+j64JB94FRLW2bk8hBlhaXENwOoIds7o56Acv+jtaQ3jzNG7Nc7W7
j5RWvyah26NzZl2CbcDKZxO1ahePrqa6keGFtAQQaLxAB0xGnne2sUMRIB2QnJiCjVaj9ns6
SD2pMEQIF0lMA9B3nj4UFiwctKwgPDBKvZ/Tr0W8tQoRooI40agigDQUUXJfIjsccZa07sWm
2natHHOuwAcWBrpgfPjDARKHs40KmhKiDNLs5lqTGNYO6bRWADtUygg1Ajb08yH2mKB9o0c4
TfrpbHGx2bc76UDxDYF0/Ogd9FQrrvGLhpFAxASqYV35dqibjNxVwT2qnVkXZy/DToHkgTaj
t6elfNadluoIkQ6Kvo2j2qobMs+1KF3cPzpO6CKg0cKjFyxqRNZYk8TfHiBuHaNJSMXVD2pP
PyoSM8DHLDeHrevvRWcKptio1SeNIlMd8zEpVP1WajbfQuHExZFV0FD7w7l/TDFks0sWVLns
pZq0Q/u3CT89+2u+Ci2C5eEFNEck4yyjT0V2jRfs8fqxe5kFJ6lpjmFQzP2zrZkF16Xm0pLC
5v4SVnyS2C8a6gZcqfS0X34Ztxnqs1p7T8uVCt+yOxGcpGD2IYhurllp2Uixm4RIBRCjYDC4
wCYDAFTd6jCrbyghEalgCRG22gJApnVckrf/kG+cuYtOIBRpc7aS1gfyBExBYhtgX63HLbyO
UDXZJhS0khRlVgqBLgk0SlRJj6hJALvtGWA1z5wtWJBz9gHqj5PHKaq+aTe3FdyGi6hQcoD2
CzC3qyVJdiSXMYDiS0nzGy7SDg5IWzFgjtlmTxLYLLsDN1Gel3i/0uFZUR0aBxWCMHgE21iA
C7zU9Tl1//z08vTH69Xu7cfl+Z/Hqy8/Ly+vyIJuUB0fJe1Lva7TW/IqpgPalETbbCKlBdHC
raozKXxq0gAxj7Gdt/ltL/kG1FwLad2XfUrb/eZ3f7YI30kmojNOObOSikzGrgR0xE1ZJE7N
qLLvwF5n2biUSiCLysEzGU2WWsU5cRCPYDz6MBywMD5yHeEQe6nFMJtJiENgDLCYc1WB+ByK
mVmpdsHQwokEaiM2D96nB3OWrkSd+GXBsNuoJIpZVHqBcNmrcDWfcaXqLziUqwsknsCDBVed
xiehLRHMyICGXcZreMnDKxbGhi09LNTiN3JFeJsvGYmJYMrJSs9vXfkAWpbVZcuwLdOWmP5s
HzukODjDkU7pEEQVB5y4JTee72iStlCUplVL8aXbCx3NLUITBFN2T/ACVxMoWh5tqpiVGjVI
IvcThSYROwAFV7qCDxxDwGj8Zu7gcslqgmxQNTYt9JdLOoUNvFV/TpHaICc4TBmmRpCxN5sz
sjGSl8xQwGRGQjA54Hp9IAdnV4pHsv9+1WgQEYc89/x3yUtm0CLyma1aDrwOyIUipa3O88nv
lILmuKFpa49RFiONKw8O1jKPmNzaNJYDPc2VvpHG1bOjBZN5tgkj6WRKYQUVTSnv0tWU8h49
8ycnNCAyU2kM7qbjyZqb+YQrMmnmM26GuC30ztmbMbJzrVYpu4pZJ6kl+dmteBZX9kuUoVo3
mzKqE5+rwr9qnkl7sDQ50EczPRe0A1Q9u03TpiiJqzYNRUx/JLivRLrg2iPAm96NAyu9HSx9
d2LUOMN8wIMZj6943MwLHC8LrZE5iTEUbhqom2TJDEYZMOpekPdLY9Zql6DmHm6GibNocoJQ
PNfLH/JOgEg4Qyi0mLUriBI/SYUxvZigG+7xNL3RcSk3h8g4v49uKo6uD4cmGpk0a25RXOiv
Ak7TKzw5uB1v4G3EbBAMSUe6c2hHsQ+5Qa9mZ3dQwZTNz+PMImRv/gXDrvc063tale/2yV6b
ED0OrstDk2Ff73Wjthtr/0AQUnfzu43r26pRYhDT+yJMa/bZJO2UVk6hKUXU/LbBtznhyiP1
UtuiMEUA/FJTv+U0tW7Uigwzq4ybtCzMW3HyZvvYBAHuV/0beG8My7Ly6uW1c1g5XLtoUnR/
f/l2eX76fnkllzFRkqlh62Mrlw7Sl2PDjt/63uT5ePft6Qt4tvv88OXh9e4bGFaqQu0SVmTP
qH572JxY/TYuAcay3ssXl9yT//3wz88Pz5d7OMicqEOzmtNKaIC+d+pBE1LMrs5HhRmffnc/
7u5Vssf7y9/gC9l6qN+rRYAL/jgzc2Csa6P+MWT59vj65+XlgRS1DueE5er3Ahc1mYfxqXt5
/c/T81fNibf/Xp7/5yr7/uPyWVcsZpu2XM/nOP+/mUMnqq9KdNWXl+cvb1da4ECgsxgXkK5C
rPQ6gEaD60HTyUiUp/I31qKXl6dvYJL+Yf/50jMR0oesP/p28HrPDNQ+3+2mlcJE2uvDON19
/fkD8nkBT5MvPy6X+z/RvUCVRvsDjoZqALgaaHZtFBcN1vguFStji1qVOY7/Y1EPSdXUU9RN
IadISRo3+f4danpu3qFO1zd5J9t9ejv9Yf7OhzSAjEWr9uVhktqcq3q6IeCc5HcacYLr5+Fr
c0jawqwY4fPiJC3bKM/T67pskyM5BwbSTodk4VEIt7IHT5p2fpk4dwX1VvX/K87L34LfVlfi
8vnh7kr+/LfrEnn8NpaZXaKCVx0+NPm9XOnXnbEuidhrKHBNt7BBY+fyxoBtnCY18dME97GQ
c9/Ul6f79v7u++X57urFWDHYU+nj5+enh8/4vm8nsPeEqEjqEkJJSfxiN8PGguqHtmtPBTyr
qLQN3TDdmOz7pHmTtteJULtltPIDax1wv+f4NNiemuYWDrPbpmzA2aB2IR0sXLoOdWfI8+Fi
7lq22+o6guuwMc9Dkam6yipCV+xKSzV4XJjfbXQtPD9Y7Ntt7tA2SQCxwxcOYXdWs9FsU/CE
VcLiy/kEzqRXC9u1h033ED7HGyaCL3l8MZEeezlF+CKcwgMHr+JEzVcug+ooDFdudWSQzPzI
zV7hnucz+M7zZm6pUiaeH65ZnJgWE5zPh9hrYXzJ4M1qNV/WLB6ujw6uNgG35Hq0x3MZ+jOX
a4fYCzy3WAUTw+UerhKVfMXkc9KvccoGSfspy2OPnCT0iPZvwMF4oTmgu1Nblhu4tcTWK8SL
O/xqY3KHqSGyLdCILA/4GkpjWvNZWJIJ34LIskkj5O5tL1fERq+/xbN91HQwaI8a++rsCUpr
iVOEDUh6CvFi0oPWY7IBxifNI1hWG+I7tKdY0fN6GPzSOaDr6HFoU50l12lCvQj2RPpArUcJ
U4fanBi+SJaNRGR6kHrOGFDcW0Pv1PEOsRqMybQ4UBOe7mF/e1TrAHQEBrFNnTf/Zh514Cpb
6NV+5xn95evlFS0OhonNovRfn7McLNBAOraIC9ofg/YgiEV/J+ApOTRP0vhMqrHnjqJPXGu1
ciVBE9WH2jKEjJt9FesDzjcLaCmPepT0SA+Sbu5BY01kNuUyKa7iqMpcS0hA2+iIlg6Q2JhU
HsXGazceORrkqMfFu1/Dqd1kBuovOQOzyM27pccLhnSdXUfEd1wH6KYix1Udqo24nLTCw7MO
Qj0Xte7/d7eqJqjX4Wdf9rj7cnpkWOnITXs62N49T9rx0ybaTsCcc80TG/Znd4os8LQhPyAF
BU7ERwcgmbcIZ+hMKT1vo4Z42zNIooZBq2NKtkf1e6xfR86kDlhsw2CpBW7/iWGZoe3hNCq3
m9t/B65AhWQIxsgCYi9XYF61mK/4FFkJFlAgPr/8fP0jHN543uTYzVehfZYWCcT5QxuXXUW8
K4ttgl4X9ONtp6aldAjUhE0qnKQGoKO7B+sK2ummlbumcmGiNXpQ6aKmdMrXJmBE4fUEPRdu
8KuLnnLcMDXUvYFFYqiMfupKYSWZlQ7/SmyeRJrnUVGex7hW4wpFv5hvd2VT5QfEiA7Hk1mZ
VzEw9o0A59JbLTmM9MHupFhXaH8snYlS/O3p/uuVfPr5fM851YL38MTS2iCK1xt02hrne1nH
xj5qAPtp0Lypx3C7L4vIxrvHJg7cPzVxCKc2qjY2um0aUauVlY1n5woMhy1U74EDGy1PuQ3V
iVNfeA/i1NZsfS3QvCix0S78mw13j3FsuONwsoF4Nor9MTbqi/NKrjzPzavJI7lyGn2WNqSD
yfpODZWsqP2wzclCN1It6eDUna9mlckmUqsfJA1RLY4roXfoWbzHdRRgYZo1NoS9N3bZdiFq
9YqPGNFvG+F04rmI1JK0ctoKZtt2V4KhOd+Sf8GyhVZP7rpBEAsOFc0BPx/rLKTVBkAwiRvc
jWnXCNX0zGXpGR1R7cI5CJSoQwbzAgfEbiJMEXCkBH4D4sZts9qrKO2B+yNWDPCQCI/n6Zz2
GDgdZfmmRMaj+gwMkHGd2ynCVuzQ9GuePbVzGB71SfUt/ag/YjOw8waEpN1l80CNJhsMfN8G
u9paRobacD+qYrX3qKxnJFUS21nAiwCR3FiwNsFVf4+RjZEVnIHGMKtm7Q9n6g/3V5p4Vd19
uWhfHK6b6b6QtrpudMCZtymK6tzoI/Jg3v5OOj2i5YcJcFbjxuWDZtE8+6n3zYa7UK2RlI1a
hxyukSF4uW0t02fdlT3W3Ut8f3q9/Hh+umeeVKUQX7lzV4FuI5wvTE4/vr98YTKhqxr9Uy9I
bEzX7VrHCSiiJjum7ySosUNQhyqJmTMiS2yCYPDO2hrftpB2DOoKjkFOxqOWuUB5+vn4+fTw
fEFvvgyhjK9+lW8vr5fvV+XjVfznw49/wLH7/cMfqrcd/24w01ZCLavV4Ctku0vzyp6IR3Lf
a9H3b09fVG7yiXkJZ06146g4YjOWDs336n+RPOBnmYZ0rbRhGWfFtmQopAqEmKbvEAXOczyL
ZmpvmgW3E5/5Vql8+heBaKGgfbTDOk8pcXQ2jAiyKMvKoVR+1H8yVsstfVT/a0/XYHxQs3l+
uvt8//Sdr22/8DPHRG+4Eb2PFMQQNi9zR3qufts+Xy4v93dKNdw8PWc3fIFJFanVS9x55MF3
pB/kMFzE8PnCfHVdxUef9jK5bHHzg6XmX39N5GiWoTfiGqmADiwqUncmm86B4ueHu+bydUL+
uymITkpKCOso3mKHrgqtIJT1qSYOJBUs48q4GRrfJnBF6src/Lz7pvpuQhCMWkqLrMVnEgaV
m8yC8jyOLUgmIlwsOcqNyDp1IS2KUm07S+lTndhrQ6pIh4TazV3q5FD5lZNYOt93452ip7iQ
0hqk3bqixj3OMhOPnm4xiYbUrYwhsMZqtZiz6JJFVzMWjjwWjtnUqzWHrtm0azbjtc+iCxZl
G7IOeJRPzLd6HfLwREtwRWqIYRjjKzyTkIEEBGLD5kn9Eva63jIoN6mAAHQbIHweBM50u9CN
Dsxmo69sZR0JmjXecuigqZbKPz98e3ic0GomhEh7jA9YnJkvcIGf8CD7dPbXwWpCzf69RcWw
pfi/1r6tuW1cWff9/ApXnvauykx0t/QwDxBJSYx4M0HKsl9YHluTuFZ8ObazV7J//UE3CLIb
AJ2sqlO1ZsX6ugHijgbQlxTutzdldGGK3v482z4pxscntnNoUrPND60P7ibPwigV9NmHMqkF
B84rgrleYAyw6UlxGCCDE0RZiMHUSpTV0h8ruSM4KdHadHJ7oY8Vpieo9i7CIfXt00QHcMP3
0y4Iwib7LA8Kt6yMpShSdndaBb3PnejH2+3TowlT7tRDMzdCHaV4mDpDKOPrPBMOvpFiNaPW
sy3On41aMBXH8Wx+fu4jTKdU96/HLb+fLaGosjnTMGtxvfir/RSN2hxyWS1X51O3FjKdz6lh
UgvXbfgrHyFw71XVnpVT93FwIRJvyPlduzFosog6XDd3KWngLBsSXhr7sxYtSAw2kxhaijG0
WEMjgxMYfB0r4axmvjWBvocHKuDicOuWUYmq7bcYVf9Jr1xJGl4s81UJ87ZjmVAWeemarWrY
sA8UTU+eh9/TBSXPLAZaUeiYMCd4LWDrUmqQ3Z+vUzGm80D9nkzY70ANWB311Y/a+REK+3wo
WJipUEypJkCYijKkGgwaWFkAffImzkr056j6CfZee8GuqXZAI+ylyiSF584BGvgre48OTmgt
+v4ow5X103qqRIg/VB6Dz/vxaEyd1QfTCY89IJRMNncAS1ugBa3IAeJ8seB5Kdl4woDVfD5u
7BACiNoALeQxmI3o86ACFkzVXQaC283Iar+cjiccWIv5/zf95gbV9eHlrKLuXMLz8YSpqJ5P
FlwPerIaW7+X7PfsnPMvRs5vtXiq/RnsikEHMBkgW1NT7RcL6/ey4UVh3h7gt1XU8xXTGD9f
0jgh6vdqwumr2Yr/po6j9aFdpGIeTmB7JZRjMRkdXWy55BhccWKEDA6jIyMOhWIFa8a24GiS
WV+OskOU5AVYyVdRwHRC2p2HscM7RVKCaMBg2N7S42TO0V28nFEFit2RGXLHmZgcrUrHGRxN
rdxBpzLkUFIE46WduHVdZYFVMJmdjy2AOUEHgDqfAtmEOdAEYMzfXRFZcoC5IFXAiullpUEx
nVDzKABm1LkVACuWBHRTIepBWi2UrAQ+S3hvRFlzPbYHSSbqc2YADq9anAVlo4PQQZ6YP2+k
aFdfzTF3E6FAFQ/ghwFcwdQNIPis2V6VOS9T6zidY+CBz4JwJIBlie2iXrsr0pWiq22H21C4
kWHqZdYUO4maJRzC10ZrilVY3dFy7MGocYLBZnJEdRg1PJ6Mp0sHHC3leORkMZ4sJXPk2MKL
MTeIQ1hlQC3jNaZO8iMbW06pgmaLLZZ2oaQOKcBRHUHWbpUqCWZzqj162CzQPxTTdS4gTCuo
7DK8Pcy2o/8/t6DZvDw9vp1Fj3f02k/JG2WktlF+PemmaC+4n7+po621JS6nC2bKQrj0Q/7X
0wMGs9WO4mhaeAZuil0rbVFhL1pw4RF+2wIhYlzjIpDMRUIsLvjILlJ5PqIGUPDluEQV7W1B
JSJZSPrzcL3EXax/YLRr5RMQdb2kNb08HO8Sm0QJpCLbJt3xe3d/Z9zugXlJ8PTw8PTYtysR
YPVhgy9vFrk/TnSV8+dPi5jKrnS6V/QriyxMOrtMKNnKgjQJFMoWfTsGHeC1v2lxMrYkZl4Y
P40NFYvW9lBrZKXnkZpSN3oi+GXB+WjBZL75dDHiv7lgNZ9Nxvz3bGH9ZoLTfL6alJbeXIta
wNQCRrxci8ms5LVX2/2YCe2w/y+43dicuVLXv23pcr5YLWxDrPk5FdHx95L/Xoyt37y4tvw5
5RaLS+YcJSzyCty6EETOZlQYN2ISY0oXkymtrpJU5mMu7cyXEy65zM6pnQAAqwk7auCuKdwt
1vGlV2lPNMsJj0Sj4fn8fGxj5+xM22ILetDRG4n+OjH1e2ckd2akd98fHn62V6F8wuqoytFB
yaPWzNFXksawaYCiryIkv/pgDN2VDTOXYwXCYm5eTv/3++nx9mdnrvi/EBMmDOWnIknMI69W
+sAn/Ju3p5dP4f3r28v939/BfJNZSGrf+payyEA67aH7683r6Y9EsZ3uzpKnp+ez/1Lf/e+z
f7pyvZJy0W9tlPTPVgEFnLOA7/9p3ibdL9qELWVffr48vd4+PZ9aOyfnJmjElyqAmHt+Ay1s
aMLXvGMpZ3O2c2/HC+e3vZMjxpaWzVHIiTptUL4e4+kJzvIg+xxK2vQaJy3q6YgWtAW8G4hO
7b2pQdLwRQ6SPfc4cbWdaiN7Z666XaW3/NPNt7evRIYy6MvbWanjgj7ev/Ge3USzGVs7EaDR
98RxOrLPdICwIKnejxAiLZcu1feH+7v7t5+ewZZOplT2DncVXdh2IOCPjt4u3NUQv5cGDtpV
ckKXaP2b92CL8XFR1TSZjM/ZLRP8nrCuceqjl061XLxBlKqH083r95fTw0kJy99V+ziTazZy
ZtJs4UJc4o2teRN75k3szJt9elyw64UDjOwFjmx2X04JbMgTgk9gSmS6COVxCPfOH0N7J78m
nrKd653GpRlAyzXMHQRF++1FR9+6//L1zbcAflaDjG2wIlHCAY1aIopQrljATkRWrIt24/O5
9Zt2aaBkgTG1EASA+aNSZ0bmQwkCC8757wW9MaVnBVQaB/Vn0jXbYiIKNZbFaEQeMjpRWSaT
1Yje33AKjZKCyJiKP/SSPJFenBfmsxTqRE89kBfliEUb7I47dkDGquRhBQ9qhZqxKLXiOOPe
flqEyNNZLriJY16A0yWSb6EKOBlxTMbjMS0L/J7RxaLaT6djdgPd1IdYTuYeiE+OHmbzogrk
dEYd+iFAH2FMO1WqU1hgHwSWFnBOkypgNqd2m7Wcj5cT6qs1yBLelBphtmFRmixG55QnWbDX
nmvVuBP9utRNaT79tMrQzZfH05u+iPdMzP1yRU2I8Tc9WuxHK3ZV2L4RpWKbeUHvixIS+IuG
2E7HAw9CwB1VeRpVUckFijSYzifUYLhd4DB/v3RgyvQe2SM8mP7fpcF8OZsOEqzhZhFZlQ2x
TKdMHOC4P8OWZnne8Hat7vQ+tLp1E5XW7IqFMbZb7u23+8eh8ULvNbIgiTNPNxEe/bralHkl
qhjvR8ju4/kOlsBEbzz7A5x6PN6pQ9XjiddiV7Yq9L5nWgyBXdZF5SfrA2NSvJODZnmHoYKd
AGxkB9KDVZDv0sdfNXaMeH56U/vwvec1eT6hy0wIDk/5O8B8Zh+3mbW8BugBXB2v2eYEwHhq
ncjnNjBmxstVkdjC7EBVvNVUzUCFuSQtVq0l+GB2Ook+M76cXkF08Sxs62K0GKVEAXudFhMu
/sFve71CzBGijASwFtT3R1jI6cAaVpQR9eK9K1hXFcmYSuj6t/UOrDG+aBbJlCeUc/70g7+t
jDTGM1LY9Nwe83ahKeqVOTWF76xzdhraFZPRgiS8LoQSxxYOwLM3oLXcOZ3dS5yP4PnHHQNy
usI9le+PjLkdRk8/7h/g9AGBzO7uX7WTKCdDFNG4nBSHolT/X0XNgc699ZiHOtuANyr6piLL
DT0lyuOK+WwFMpmYh2Q+TUZG8ict8m65/2P/Syt2YAJ/THwm/iIvvXqfHp7hjsc7K9USFKcN
uGFL8yCviyTyzp4qoh7m0uS4Gi2ouKYR9sqVFiP6mo+/yQiv1JJM+w1/U5kMDuXj5Zy9sviq
0om6NNin+qHmFFGiBCAOK86hI99UVH0L4CLOtkVOHfIBWuV5YvFF5cb5pGWxhCkhxi73in5I
IzTvbw9p6ufZ+uX+7otHKQ9YKwk20Tz5Ruy7y3tM/3TzcudLHgO3OpTNKfeQCiDw8tDQzLxP
/bCDyQJkTB5ZKlc3DsDWQJCDu3hNHTsBhLHdpxwDfXgI3WGh7Vs5RzF2Or1nBhCVgTnSWgSC
UR4jgBWihfBYUh2kiuqgRWS6Ni4vzm6/3j+TKANmPquGoOGTIZhTKRoW0OIzGjwKymZKrISq
AJjVaPUQywtPkvJajC1SJWdLkHHpR40qRhXUSHDy2S3158kdd3nRx/MRcRhRU7X0CHRZRdal
t90yXYJCBHvu/UK/DFfoMZ1J6uAcSiXIg4o6iVLbILhk6N1k/OQUUe2oxnwLHuV4dLTRdVQm
vIURdaILI7yT4d5mBR0WG0tEVsUXDqrfbGxYx/Dzgdo/TSNKpyAek19N0JYOOYtm3RMK+vSu
cRmksYPha4adA06GtBjPnerKPACnWw7MnZhpsIpRSZ9FLUSCGV5DeLNN6sgmQlxGYlGLz6+m
r9AWtU9gERdacVNLI7srcN32ikrv/QRu48egy5yfHrBJY3WODRkZYPM2B5rFeUW2GSBa8e0A
0tomzGtHCy9i8g2buPKkwWGzXANh4qE022PyK9rUSxtPxHDClji14mEBR3C1zcBrkEPA0HAl
r0HnrAC+1Dh1BnImPcXoCVbhMznxfBpQ7SY5tPIpoVCCKkGSonoqp6NCqu4Zwu0qGIpUA7q0
PoOa5OlxmV54+jU+RsnQWGgNrJ1ErTW2B1dLG8yHtScrCTGIstzTynpRaw7lsfVRH3nppdpV
eOI2rub5HFXqk1rC/YUza9JDtK4bxaYyryu6KFHq8ggFd8pdHEUzWWZK0pA04BMjuTXS2pVu
Y4ui2OVZBIHrVAOOODUPoiQHHYsyjCQn4bbj5qdN6NzPI45edeQgwa5NKdDu2PmGVr2Lsqln
FvSGTk6fdaTqqoisT7VaomFhO2EjRByRw2T8IOtlYwjhtka3zr9Pmg6Q3LqBIgxoGY6n4xEU
1FlCO/psgB7vZqNzz8KMUiE4ndldWW2GVkDj1awpqBdtcPFppBW+rKndsIiLyKpUpfJuPfNS
NG62aQzWncyWmG9eXQIwjApoiLGUmoukOsYAB5Ki03kqTi8QuxsPtw/6edQXRus9tm6jpiaU
1a7OQlAETHpjDscbqfY+SmyvW3ek6xjSomuIARo9t1ipTKywD3/fP96dXj5+/Xf7x/883um/
Pgx/z+tVwfFzGq+zQxin5OyzTvbwYSsaGnimo+561e8gETE5hgEHddcIP6ivBSs//Co4CKYx
W8WxjQPAMGZ/hgDJhjmBxZ/2YVCDKPHHqZUU4TzIqQspTTACUQQeHpxkhupJCErpVo5wRow2
tWPifLHheXcrm8WsM4Yt3VtUPbfByxbJq1tkvHlpJSW7mMYpgTcJhFBW9d4WVNoVB7BzcBqp
1Z42+WhdhMuzt5ebW7xWs4+dkh6+1Q/tqQs07uLARwC/NBUnWBpQAMm8LoOIWP27tJ1aS6t1
JCovdVOVzA5TB9Stdi7CF6YO3Xp5pRdVe4wv38qXr3EG1ytGuI1rEuEp54H+atJt2Z1/BimN
oIt56zqngKXF0qFzSOizx5OxYbRug216cCg8RDg1DdWlVcj256pW0Jmt02RoqTqPHvOJh6pd
jzqV3JRRdB051LYABSzZ+saytPIro21Mz49qQfTiCIbMkXOLNBsarpuiDfMVwSh2QRlx6NuN
2NQelA1x1i9pYfcMdUWufjRZhEaUTcZCcAAlFShac2tWQtD6xy4uwEPvhpPUEZ2sI1XUrT3q
T2KT3l/dErhbBCEyk+rAI3ah/U7qcadRg3HB9nw1oYGfNSjHM3o/DyivJyBtbDnfY6tTuELt
AAWRj2RMFTvgV+O6xpVJnLKLKwD0BsQ9TvR4tg0tGj6Xqr+zKGDxc6zAU/RNNMgqm2DeUxkJ
XLNd1CLUfub7Bz1+G6y1T+/BRz9KjfR+WMADS6XWawk2eZJ5+5Pg0InKlNGxmliOOxFojqKi
rs4MXOQyVr0ZJC5JRkFdgiYcpUztzKfDuUwHc5nZucyGc5m9k4vlNvTzOiTnFPhlc6is0nUg
mBfjMoolCKqsTB2oWAN2w9jiaBnIHSaRjOzmpiRPNSnZrepnq2yf/Zl8HkxsNxMwgjYCuCIk
ouTR+g78vqjzSnAWz6cBLiv+O88wIrAMynrtpZRRIeKSk6ySAiSkapqq2Qi4b+4v/TaSj/MW
aMC3JwS1CBMiOas932I3SJNP6Cmsgzs/FU17PeLhgTaU9kdap7VC7sGpuJdIxfd1ZY88g/ja
uaPhqGxdUbLu7jjKOlNH+0wRGx2m3WKxWlqDuq19uUWbRh1c4g35VBYndqtuJlZlEIB2YpVu
2exJYmBPxQ3JHd9I0c3hfAKtjkDGtfLRroGzz2q1ZyE0htYgeEmkmRtEHRrVaFObFv1wDC4E
9SCkL01ZCBaUVwN0lVeUYYwwu0DQ6qy+BvIsbS1hXcdql8/AhjwTVV1GtHgyyyvWjaENxBrQ
j5J9QmHzGQTdCEh0MZHGUm3T1N2OtX7gT/C3jHdmuO1uWAcVpQJbtktRZqyVNGzVW4NVGdHz
5yatmsPYBsjmgKmCinSzqKt8I/nOpDE+olWzMCBgp8k2KDpbalS3JOJqAFNTK4xLNRKbkC6G
PgaRXAp1NNxABKVLLytcjxy9lKPqVayOl5pGqjHy4so8oQY3t19pGJ6NtPbMFrCXQAPDfXa+
ZT6WDMkZtRrO1zAbmyRmbm+BBBOGNneHOYHaewr9Pol9hpXSFQz/UEf6T+EhRKnLEbpima/g
pp5tu3kS01fWa8VEV4U63Gj+/ov+r2glsFx+Unvap6zyl8B2wJ5KlYIhB5vlV67RBxyj378+
LZfz1R/jDz7GutoQJ7tZZU0HBKyOQKy8pG0/UFt9s/l6+n73dPaPrxVQymK6DwDs8YjOMXjC
pNMZQWiBJs3VLpiXFinYxUlYRmSxBVf0G+5cjv6s0sL56dsuNMHa2nb1Vq15a5pBC2EZyUYR
aTfzEfPBB3E3mp2QGKMgq+LASqX/0V1DWt3Tst13YhngXqRDRlExphTZNrK6WYR+QHezwTYW
U4Q7mh+C+ziJ8cdIk1jp1e8iqS3xyC4aArY0YxfEkaBtycUgbU4jB79UW2tku37qqYriCEia
Kus0FaUDu2Okw72yvZE5PQI+kOAJDlQRwcQ8RylC2izXYMBiYcl1bkOoVuyA9RpVMtTKyb4K
QUebLM+is/vXs8cn0Lt/+z8eFrWt522xvVnI+Jpl4WXaiENel6rIno+p8ll9bBAI8g3u6kLd
RmS9NgysETqUN1cPyyq0YQFNRjxX22msju5wtzP7QtfVLoKZLrhEGKhNjUdbgN9aEIUoDxZj
k9LSyotayB1NbhAtlupNnnQRJ2sxxNP4HRvcD6aF6k30IuDLqOXAeyhvh3s5QbYMivq9T1tt
3OG8Gzs4uZ550dyDHq99+UpfyzYzfF6CVyYY0h6GKF1HYRj50m5KsU3Br2ArW0EG0263t0/n
aZypVcKHtC601YkijAUZO3lqr6+FBVxkx5kLLfyQteaWTvYagRBa4MnuSg9SOipsBjVYvWPC
ySivdp6xoNnUAmg+ZPZ7JQwy7xz4GyScBO7VzNLpMKjR8B5x9i5xFwyTl7N+wbaLiQNrmDpI
sGtjBDja3p56GTZvu3uq+pv8pPa/k4I2yO/wszbyJfA3WtcmH+5O/3y7eTt9cBj1Y5rduAUL
QtSCG+tuoYXh1NGvr1fywHcle5fSyz1KF2QbcKdXVNonUYMMcTpXvgb33XEYmuei1ZCuaVDX
Du20h0DUTuI0rv4adweBqLrMy71fzszskwRcYEys31P7Ny82YjPOIy/pfbjmaMYOQpwvF5nZ
4dRxmAXfRYpeTTi2SaKjN4X5XoMKm7Ca4wbexGHr2fevD/86vTyevv359PLlg5MqjSG0DNvx
W5rpGIh1HyV2M5qdm4BwT6F9RjZhZrW7fWDbyJBVIVQ94bR0CN1hAz6umQUU7FiFELZp23ac
IgMZewmmyb3EdxpoW6I3QyWb56SSKC9ZP+2SQ906qY71cOvqqN/C66xkoaDxd7Ola3+LwS6m
jt5ZRsvY0vjQVYiqE2TS7Mv13MkpjCWGGYkzrDrs9wEojUknX/uiJCp2/ApLA9YgalHfcmFI
Q20exCz7uL0ElhPOAkGm88u+Aq2LU85zGYl9U1zC8XdnkeoiUDlYoLXqIYZVsDC7UTrMLqS+
tA9rJYxyhR5NHSqH2555KPgZ2j5Tu6USvow6vka1mqQ3G6uCZYg/rcSI+fpUE9z1P6Nm9+pH
v4m6F0dANjdPzYya1zHK+TCFGl4zypL6PLAok0HKcG5DJVguBr9DPV5YlMESULt5izIbpAyW
mvpYtSirAcpqOpRmNdiiq+lQfZjPVV6Cc6s+scxhdDTLgQTjyeD3FclqaiGDOPbnP/bDEz88
9cMDZZ/74YUfPvfDq4FyDxRlPFCWsVWYfR4vm9KD1RxLRQAnI5G5cBCps3Xgw7MqqqmZb0cp
cyWeePO6KuMk8eW2FZEfLyNqQmbgWJWKhR/oCFkdVwN18xapqst9LHecgPfZHQKvxPSHE3c1
iwOm1NMCTQZBEJL4Wkt3nTIqufxn2hzabeHp9vsLWKo+PYPLL3LNzfcV+IVnFhphFcEyuqgj
WTXWmg5RYGIlXmcQT1X1Q7alz71O/lUJInuo0f44od8fDU4/3IS7JlcfEda9Yrf9h2kk0QCo
KuOgchk8SeDEg+LLLs/3njw3vu+0B4phSnPc0KiiHVk1JREeEpmCG/ACbkwaEYblX4v5fLow
5B3ofWLU1Ey1BjyDwtsYCiuBYC8JDtM7pGajMsB44u/wwPInC3ppg4oaAXLAJagdIsxL1tX9
8On17/vHT99fTy8PT3enP76evj0TnequbdTgVVPr6Gm1loLR18EduK9lDU8rjb7HEaH763c4
xCGwXxQdHnzqV/MAVGVBN6qO+sv6njll7cxxUBvMtrW3IEhXY0kdNCrWzJxDFEWUhfqBPfGV
tsrT/CofJICpNT6bF5Wad1V59ddkNFu+y1yHcYVx6sejyWyIM1fHb6K6kuRg4Dpcik7w7jQG
oqpiLzJdClVjoUaYLzNDsiR0P51cSw3yWWvwAEOrrOJrfYtRvzRFPk5oIWbOa1NU92zyMvCN
6yuRCt8IERswaKTmEiRTdczMLzNYgX5BbiJRJmQ9QU0TJLYhs7FY+PZCr/gG2DpNIe+t2kAi
pIbwCqF2Op60TehRQOqgXv3ERxTyKk0j2C6s7aZnIdtUyQZlz9KFT32HB2cOIdBOUz9MRMSm
CMomDo9qflEq9ERZJ5GkjQwE8M8AF66+VlHkbNtx2CllvP1VavP43mXx4f7h5o/H/sKIMuG0
kjuMXsY+ZDNM5gtv9/t45+PJL8qGs/3D69ebMSsV3mSq86US+a54Q5eRCL0ENV1LEcvIQuHN
+z12XLXezxEFJojhvInL9FKU8KhCZSMv7z46glPsXzOiX/zfylKX8T1OlZeicuLwBFBEI+hp
tasKZ1v7OtIu5mr9UytLnoXs9RnSrhO1iYGqjT9rWPqa43y04jAgRrI4vd1++tfp5+unHwCq
wfknNddiNWsLFmd0FkaHlP1o4NKm2ci6ZmHcDhDlqypFu+3i1Y60EoahF/dUAuDhSpz+54FV
woxzj5zUzRyXB8rpnWQOq96Df4/XbGi/xx2KwDN3Ycv5AB6I757+/fjx583DzcdvTzd3z/eP
H19v/jkpzvu7j/ePb6cvcEb5+Hr6dv/4/cfH14eb2399fHt6ePr59PHm+flGCZOqkfBAs8eb
7LOvNy93J/Qo1B9s2lCdivfn2f3jPfjYvP/fG+4hGYYEyHsgcultjBLA2QJI3F396IWr4QCL
Fc5AgnZ6P27Iw2XvnMHbxzXz8aOaWXiBTe/u5FVmu9/WWBqlQXFlo0cah0BDxYWNqAkULtQi
EuQHm1R1ErdKB3IwxJciV4Q2E5TZ4cIDH0ipWifu5efz29PZ7dPL6ezp5UwfF/re0syqT7Ys
ajeDJy6uFn0v6LKuk30QFzsWhN6iuImsW+EedFlLus71mJfRFVNN0QdLIoZKvy8Kl3tPDV1M
DnDmd1lTkYmtJ98WdxNwb0KcuxsQllJ4y7XdjCfLtE4cQlYnftD9fIH/OgXAf0IH1oougYNz
p04tGGXbOOvsnorvf3+7v/1DLeFntzh2v7zcPH/96QzZUjpjvgndURMFbimiINx5wDKUwpRC
fH/7Cj75bm/eTndn0SMWRa0XZ/++f/t6Jl5fn27vkRTevN04ZQuC1Ml/G6RO4YKdUP+bjJQk
ccX9y3ZzahvLMXWm2xJkdBEfPJXdCbWIHkwt1uibHu4JXt0yrgO3PJu128OVO0gDzyCLgrWD
JeWlk1/u+UYBhbHBo+cjSrLhoZ3NmN0NNyGoy1S12yGgV9e11O7m9etQQ6XCLdwOQLt0R181
Djq58RF5en1zv1AG04mbUsONOvWXAX1XoGS31Y64eHqYq/EojDfu4uBdbAebMw3dkqTh3F3H
wvlgydNYjVP0s+JWukxD33gHmHkZ6uDJfOGDpxOXuz1OueBgScEPuD5j+dINw4MZ6kOYL5WC
30s1dcHUg4HFxDrfOoRqW45X7mi5LOboVVuLCvfPX5mdKGkEEbmTcQBrqPk3gYcqJ7J6HUtv
06sEHn4fqCS3y03sGfiG4AQyMhNDpFGSxGKQMDz/0Jx3KFdZuXMHUHewQkWZixuzmfmxwfJs
/Dv0fieuhbtDS5FI4ZkjZkvy7DiRJ5eoLKLM/ahM3fJVkdvI1WXu7bUW75tXD9Cnh2dwlcrO
G13LoKac27pU+bPFljN3JoDqqAfbuSsU6oi2JSpvHu+eHs6y7w9/n15MEBhf8UQm4yYoysyd
mmG5xkCEtSvOAMW702iKb+FGim/PBoIDfo6rKirhspo9cxCRsxGFO50NofHuNR1VGuF5kMPX
Hh0RTxnuCic8cgFecHG7XUO5dFsCjPpjsRWlcMcBEFuvSt7OUmQ5dwUQwEWlVoxB0ZdweCe2
oVb+eW/Iait4hxp7xIie6pOFWc6T0cyfe8AWFnGI69TCaNNWLHaDQ2qCLJvPj36WNnNQS/SR
LwJ3ims8Twc7LE63VRT4ByvQXc+ntEC7KJHUN0ELNHEBilwxmj17x5hhrBJ/h2qrQv8QE5vo
yIJb03wDZhZJKOhWTlIHY/xGHt2PsfsEQyzqddLyyHo9yFYVKePpvoM3cEGkKrQB64bIcWpQ
7AO5BIuRA1Ahj5ajy8LkbeOQ8tw893jzPcdzJSTuU7UXlEWkdUDRiqe3u9DbCUSJ+QePeK9n
/4BLrfsvj9op8u3X0+2/7h+/EJ8Z3bUwfufDrUr8+glSKLZGnVb/fD499M+wqBc7fNfr0uVf
H+zU+pKUNKqT3uHQ5gWz0ap79u4ui39ZmHfujx0OXG/RrFOVureM/I0GNVmu4wwKhZbBm7+6
IDt/v9y8/Dx7efr+dv9Iz2L60oxephmkWavVVm2SVIEAHN+yCqzVwhOpMUCfI4yHUSUzZwG8
5JfoDZAOLsqSRNkANQPvqVVMn4yDvAyZS8ESbImyOl1HNF6n1r1gHhCM29Mgtp2AgDvk1r0a
XW4CtR7EFVuKgzGTMtW0dY5+auGq6oanmrJzifpJNWA4rtaKaH21pLfmjDLz3mm3LKK8tB7J
LA7VW56r7sCWevkxICCKWkqkds/UATlVtqfkn31HZGGe0hp3JGbW8UBRbcvEcTBMAkEkYdP1
Wsv4loTKLFF+UpTkTHCfacqQTQpw+3LhdigPDPbV53gNcJ9e/26Oy4WDoSvEwuWNxWLmgIIq
9PRYtVNTxCHgicdB18FnB+ODta9Qs2V2DoSwVoSJl5Jc01t1QqCWY4w/H8Bn7vz2qB2pTT1s
ZJ7kKXfa3KOgzbX0J4APDpFUqvFiOBmlrQMiIVVqe5ERvNj2DD3W7GkoA4KvUy+8kdRhI3p2
6HtPlKW40laBVO6QeRBrqzdk6ElgNR3nzI+ihkCrv2HLJuDsfSTD+m8BbNSivqU6ZEgDAuiR
wVHDNtcGGuiWNVWzmK3p4ydSwG8w13NhcEMNjuQ20cOAPICp427d2Npg2g+KR/EiKGpwSdPk
mw0+uDFKU7JmCC/oLpPka/7Ls9RnCde5T8q6sRxGBMl1UwmSFfivL3L6qJAWMbfVdKsRxilj
UT82IXXEGYfo901W9Ml7k2eVa8cBqLSYlj+WDkIHPUKLH+OxBZ3/GM8sCPzYJp4MhdrwMw8+
Hv0Y25isM8/3FTqe/JhMLFidzseLH3RnlhBePKEjT4Ib2pwansBgCKMip0xqsLIBAW/PVL82
X38WW3J+Aq3PbOtVgnXENP5ubCRnRJ9f7h/f/qXDuDycXr+4arIoAu4bbqDegmCBwaaCNuUD
lbkEFA+7F73zQY6LGvx7dMp15hzh5NBxgF6k+X4IhklkpF5lIo1705uuRQZr2d1b3X87/fF2
/9BKwq/IeqvxF7dNogyf89Iarhi5r7JNKZQoCV50uHqh6q5CLZngSpYa5IF+DuYlqHKa67Jq
F4FWITibUaOHTmBDsIoB7ghSddjQB2AmbLdLnfbDBD4pUlEFXIeQUbAy4D/syq5lkaMzIafc
qMimTYjAM19R07747dbuhoTYxuhqhMboIGCniqB75S81p31cOoiGXVate2ej4KjDHHpalYbw
9Pf3L1/YmRPNJtQOGmWSGQ8inl9m7ByMh+M8ljnvDI43Wd76DxvkuI7K3C4uspTRxsa1fx85
AHuEaU7fMCGA09Dp4mDOXF+c08Ax/o4pKHC69jrQ+YEc4GpnoFkduh6XSb02rFTDFGDrbhI1
zttRoESVRI1XZ3T8Agc9E1zc9cF+vBiNRgOctujLiJ0yzcbpw44H/Eg1MqBq6u1MRmWeWjLn
NJp0cNaUQ4ovntyUoSOVaw9YbNXBaOv0tSoXuFbjKmbteNSzHqQ0eujGK75mL9QIN4J2T9Ww
lpPGjkJRP/us3FSiID9oj3MNPd20bbPTkX308y5kcgbB2L8/6zVnd/P4hQYBzIN9DYf4So0x
pnadb6pBYqeoT9kKNYuD3+Fp1enHVLUMvtDsID5ApeRHz1n78kItymppDnO2zQ1VsF9K4IPg
rIZ5z2NwVx5GhOkOBsC91r8aQKGjNI4gv+dHzLYvQD49bkGl39q7dNfBJ/dRVOjlUt8/gbpE
NxTO/uv1+f4RVCheP549fH87/TipP05vt3/++ed/807VWW5RYLIdxhRlfvA4B8RkUG67XHCA
qdXBKXJmhFRl5U4w2pniZ7+81BS1OOWX3Fam/dKlZMb7GsWCWQcT7YimcABQjURhgQwuk4ci
e0ZWq+Vf5SBHySSKCt/3oSHxBandQaTVbmp+wBnCWvT6CvuE1v+gb02GetarGW4tUDiyLEcR
KMSoxmjqDJ5K1fjTl0rOeqt3mAFY7bJqMabXlGQXUf8dIKiDdJbWYQr3vdcunz5QOhIcOoKM
PbtwUEatAUEXeU9tul4JBse+ItrTATZpXgp/lwIfxAf0wMMJYGtAKbZbViZjlpL3HEDRRW+l
3UeFZJWyJtdFK4aWRgDlHYLDVMlucGNLFQ5V0XZqqU70voquXTBeCbmDaJu9icoSoxEbj6b9
bXLqZyKHuQ0qmA7nR475UaW9nL/LNexdVcSJTOgdACBaYrQWESSkYh8Zi0eLhOGHdX9xwgYm
NcVYWTyHGf2lNPB9iKftZ3JjW4fBZW0WXFXUuC3DwMiKu7Qm6KbOdIbvU7elKHZ+HnO2tB3Q
6Ax0EVMUWrFry9BiAVeJOOSBEw9OtigatAl1LmTmYXHQIM36tv5qwPccvBawfeapozTcVih+
tsnB4IZJoCOEOhUnWbVeI7izjEIdEFJ10FSnK2+1nO+Z61X7Qy2juznbrT3Yj7/oQlJSbApq
EVJeKJls4yTRQoozFi7VuHO/rnui7WPp9J3MlCS8y91ONYROZOYNvFZ7FBjklDm+ktp2ZwYX
WQaBzsESBRNE0u/HybCrYehjpLunU0UTw8d177xX+a4jp11rP7wuNg5m5paN+3MYmondEGjr
6fbPwPw0vecchw2hEmorKxpO7KfU73DgC7h/fMDA51fi8ITbBnG3xxJOMd+bKp2rPfnBR/aX
lkwRvFazNm5djQjMGeDyHRqYzGs4g5nhZfdLqdocnlchP6yr1qXqDSH3YZV6Byw2Gj5oS7Uq
DLMMUvXQlNQnu5dv3e0yMAiG+Up8GHHohkpfbjr51iwzcJsBrefNoZ+j+vZj4AtaLl/MuARt
iMR8ZTB/bK9ddATPOu80qL5c1i8dvjXCcEltZcNT7xWhyo9DyVqdggcGttffdlYKVlJP4vdQ
iBxgvDZM1S9Xw3Rwx71RG9swRwkv0eg04Z32VCzD1DgUw0R9zT/UVMk+dZrkkKLcNpQE1fPQ
K4LVwIXT5KAussvxFu1AP7OJIfBaTJaZoY8ZC08r59YttF3yGteV4dGEThW4fww9nlJ0IsYz
AwsvtRP7zrC6Z633EvMNOLxSjyYmM44qgK+O+kKxCUUlQHukrE3QgN6HqgDnc77JgtKdfpPd
hkQSd3+ZSM+BHV8MidZJu8fQ/WZOxQtCw/cSPaH/+nAYb8aj0QfGtmelCNfv3KcDVXUQhqnm
aUCSjLMa3NlWQoK+6i4O+uuiei3pxSX+hMtukcTbDBz2kW0OhwryW5uPOei7YmLrLSzYJDVV
G+kkadcAkWs74eUAxlEAK7Q8qNNW5Ph/CqM9z3uvAwA=

--nrwphbjjfjjzyrqi--

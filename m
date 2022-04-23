Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61DE950C6DC
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 05:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbiDWDQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 23:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbiDWDQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 23:16:41 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E59DC24;
        Fri, 22 Apr 2022 20:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650683625; x=1682219625;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mto+Vzxn6JKa+YbM4+e4HPrTh2VU2rRn+mkbkVddMG4=;
  b=XhhFSbMEG71pxZssP+iOx9kYPnLMqZxgS314QbUHafn00JkIKPB5pAaN
   uVBoWwr5cDQ4cljacggFIu6wAU6BGzCKv5G94VLzQ+6zpa/LyBkas4dvp
   aHRN7nIybw+HwFrr8iDXvmWH4F9G5EoXqZNQUpFGXfRBpm8aMNFpXhVI1
   uorGbU5IwswcQSpV0g3u345+LTiyr07zm3dQYhPAzjZkbXS8H9FdJ9f2z
   b3qb1YlQtnJaNszOLdjr6QUjgg2X81iR94EUQwaTNGBAfuRXNVXXVda0X
   D9hTetYJlDijJOVMe6J0B0+bnXLLnQv0QP2UwYpaqR+PYmQ1XpGr603mA
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="245410921"
X-IronPort-AV: E=Sophos;i="5.90,283,1643702400"; 
   d="scan'208";a="245410921"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 20:13:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,283,1643702400"; 
   d="scan'208";a="556691793"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 22 Apr 2022 20:13:40 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ni6DL-000AwR-MR;
        Sat, 23 Apr 2022 03:13:39 +0000
Date:   Sat, 23 Apr 2022 11:00:39 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: Re: [PATCH net-next 1/4] net: pcs: xpcs: add CL37 1000BASE-X AN
 support
Message-ID: <202204231033.DjMxbbXU-lkp@intel.com>
References: <20220422073505.810084-2-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422073505.810084-2-boon.leong.ong@intel.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ong,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Ong-Boon-Leong/pcs-xpcs-stmmac-add-1000BASE-X-AN-for-network-switch/20220422-154446
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 9c8774e629a1950c24b44e3c8fb93d76fb644b49
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20220423/202204231033.DjMxbbXU-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/dc88c5b7c183eeaff9db0e88d7b0d1d7f73e830b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Ong-Boon-Leong/pcs-xpcs-stmmac-add-1000BASE-X-AN-for-network-switch/20220422-154446
        git checkout dc88c5b7c183eeaff9db0e88d7b0d1d7f73e830b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/net/dsa/sja1105/sja1105_main.c: In function 'sja1105_static_config_reload':
>> drivers/net/dsa/sja1105/sja1105_main.c:2334:22: error: too few arguments to function 'xpcs_do_config'
    2334 |                 rc = xpcs_do_config(xpcs, priv->phy_mode[i], mode);
         |                      ^~~~~~~~~~~~~~
   In file included from drivers/net/dsa/sja1105/sja1105_main.c:19:
   include/linux/pcs/pcs-xpcs.h:33:5: note: declared here
      33 | int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
         |     ^~~~~~~~~~~~~~


vim +/xpcs_do_config +2334 drivers/net/dsa/sja1105/sja1105_main.c

2eea1fa82f681b Vladimir Oltean 2019-11-12  2224  
6666cebc5e306f Vladimir Oltean 2019-05-02  2225  /* For situations where we need to change a setting at runtime that is only
6666cebc5e306f Vladimir Oltean 2019-05-02  2226   * available through the static configuration, resetting the switch in order
6666cebc5e306f Vladimir Oltean 2019-05-02  2227   * to upload the new static config is unavoidable. Back up the settings we
6666cebc5e306f Vladimir Oltean 2019-05-02  2228   * modify at runtime (currently only MAC) and restore them after uploading,
6666cebc5e306f Vladimir Oltean 2019-05-02  2229   * such that this operation is relatively seamless.
6666cebc5e306f Vladimir Oltean 2019-05-02  2230   */
2eea1fa82f681b Vladimir Oltean 2019-11-12  2231  int sja1105_static_config_reload(struct sja1105_private *priv,
2eea1fa82f681b Vladimir Oltean 2019-11-12  2232  				 enum sja1105_reset_reason reason)
6666cebc5e306f Vladimir Oltean 2019-05-02  2233  {
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2234  	struct ptp_system_timestamp ptp_sts_before;
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2235  	struct ptp_system_timestamp ptp_sts_after;
82760d7f2ea638 Vladimir Oltean 2021-05-24  2236  	int speed_mbps[SJA1105_MAX_NUM_PORTS];
84db00f2c04338 Vladimir Oltean 2021-05-31  2237  	u16 bmcr[SJA1105_MAX_NUM_PORTS] = {0};
6666cebc5e306f Vladimir Oltean 2019-05-02  2238  	struct sja1105_mac_config_entry *mac;
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2239  	struct dsa_switch *ds = priv->ds;
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2240  	s64 t1, t2, t3, t4;
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2241  	s64 t12, t34;
6666cebc5e306f Vladimir Oltean 2019-05-02  2242  	int rc, i;
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2243  	s64 now;
6666cebc5e306f Vladimir Oltean 2019-05-02  2244  
af580ae2dcb250 Vladimir Oltean 2019-11-09  2245  	mutex_lock(&priv->mgmt_lock);
af580ae2dcb250 Vladimir Oltean 2019-11-09  2246  
6666cebc5e306f Vladimir Oltean 2019-05-02  2247  	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
6666cebc5e306f Vladimir Oltean 2019-05-02  2248  
8400cff60b472c Vladimir Oltean 2019-06-08  2249  	/* Back up the dynamic link speed changed by sja1105_adjust_port_config
8400cff60b472c Vladimir Oltean 2019-06-08  2250  	 * in order to temporarily restore it to SJA1105_SPEED_AUTO - which the
8400cff60b472c Vladimir Oltean 2019-06-08  2251  	 * switch wants to see in the static config in order to allow us to
8400cff60b472c Vladimir Oltean 2019-06-08  2252  	 * change it through the dynamic interface later.
6666cebc5e306f Vladimir Oltean 2019-05-02  2253  	 */
542043e91df452 Vladimir Oltean 2021-05-24  2254  	for (i = 0; i < ds->num_ports; i++) {
3ad1d171548e85 Vladimir Oltean 2021-06-11  2255  		u32 reg_addr = mdiobus_c45_addr(MDIO_MMD_VEND2, MDIO_CTRL1);
3ad1d171548e85 Vladimir Oltean 2021-06-11  2256  
41fed17fdbe531 Vladimir Oltean 2021-05-31  2257  		speed_mbps[i] = sja1105_port_speed_to_ethtool(priv,
41fed17fdbe531 Vladimir Oltean 2021-05-31  2258  							      mac[i].speed);
41fed17fdbe531 Vladimir Oltean 2021-05-31  2259  		mac[i].speed = priv->info->port_speed[SJA1105_SPEED_AUTO];
6666cebc5e306f Vladimir Oltean 2019-05-02  2260  
3ad1d171548e85 Vladimir Oltean 2021-06-11  2261  		if (priv->xpcs[i])
3ad1d171548e85 Vladimir Oltean 2021-06-11  2262  			bmcr[i] = mdiobus_read(priv->mdio_pcs, i, reg_addr);
84db00f2c04338 Vladimir Oltean 2021-05-31  2263  	}
ffe10e679cec9a Vladimir Oltean 2020-03-20  2264  
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2265  	/* No PTP operations can run right now */
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2266  	mutex_lock(&priv->ptp_data.lock);
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2267  
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2268  	rc = __sja1105_ptp_gettimex(ds, &now, &ptp_sts_before);
61c77533b82ba8 Vladimir Oltean 2021-06-18  2269  	if (rc < 0) {
61c77533b82ba8 Vladimir Oltean 2021-06-18  2270  		mutex_unlock(&priv->ptp_data.lock);
61c77533b82ba8 Vladimir Oltean 2021-06-18  2271  		goto out;
61c77533b82ba8 Vladimir Oltean 2021-06-18  2272  	}
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2273  
6666cebc5e306f Vladimir Oltean 2019-05-02  2274  	/* Reset switch and send updated static configuration */
6666cebc5e306f Vladimir Oltean 2019-05-02  2275  	rc = sja1105_static_config_upload(priv);
61c77533b82ba8 Vladimir Oltean 2021-06-18  2276  	if (rc < 0) {
61c77533b82ba8 Vladimir Oltean 2021-06-18  2277  		mutex_unlock(&priv->ptp_data.lock);
61c77533b82ba8 Vladimir Oltean 2021-06-18  2278  		goto out;
61c77533b82ba8 Vladimir Oltean 2021-06-18  2279  	}
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2280  
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2281  	rc = __sja1105_ptp_settime(ds, 0, &ptp_sts_after);
61c77533b82ba8 Vladimir Oltean 2021-06-18  2282  	if (rc < 0) {
61c77533b82ba8 Vladimir Oltean 2021-06-18  2283  		mutex_unlock(&priv->ptp_data.lock);
61c77533b82ba8 Vladimir Oltean 2021-06-18  2284  		goto out;
61c77533b82ba8 Vladimir Oltean 2021-06-18  2285  	}
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2286  
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2287  	t1 = timespec64_to_ns(&ptp_sts_before.pre_ts);
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2288  	t2 = timespec64_to_ns(&ptp_sts_before.post_ts);
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2289  	t3 = timespec64_to_ns(&ptp_sts_after.pre_ts);
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2290  	t4 = timespec64_to_ns(&ptp_sts_after.post_ts);
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2291  	/* Mid point, corresponds to pre-reset PTPCLKVAL */
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2292  	t12 = t1 + (t2 - t1) / 2;
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2293  	/* Mid point, corresponds to post-reset PTPCLKVAL, aka 0 */
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2294  	t34 = t3 + (t4 - t3) / 2;
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2295  	/* Advance PTPCLKVAL by the time it took since its readout */
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2296  	now += (t34 - t12);
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2297  
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2298  	__sja1105_ptp_adjtime(ds, now);
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2299  
6cf99c13ea07b5 Vladimir Oltean 2019-11-09  2300  	mutex_unlock(&priv->ptp_data.lock);
6666cebc5e306f Vladimir Oltean 2019-05-02  2301  
2eea1fa82f681b Vladimir Oltean 2019-11-12  2302  	dev_info(priv->ds->dev,
2eea1fa82f681b Vladimir Oltean 2019-11-12  2303  		 "Reset switch and programmed static config. Reason: %s\n",
2eea1fa82f681b Vladimir Oltean 2019-11-12  2304  		 sja1105_reset_reasons[reason]);
2eea1fa82f681b Vladimir Oltean 2019-11-12  2305  
6666cebc5e306f Vladimir Oltean 2019-05-02  2306  	/* Configure the CGU (PLLs) for MII and RMII PHYs.
6666cebc5e306f Vladimir Oltean 2019-05-02  2307  	 * For these interfaces there is no dynamic configuration
6666cebc5e306f Vladimir Oltean 2019-05-02  2308  	 * needed, since PLLs have same settings at all speeds.
6666cebc5e306f Vladimir Oltean 2019-05-02  2309  	 */
cb5a82d2b9aaca Vladimir Oltean 2021-06-18  2310  	if (priv->info->clocking_setup) {
c50376783f23ff Vladimir Oltean 2021-05-24  2311  		rc = priv->info->clocking_setup(priv);
6666cebc5e306f Vladimir Oltean 2019-05-02  2312  		if (rc < 0)
6666cebc5e306f Vladimir Oltean 2019-05-02  2313  			goto out;
cb5a82d2b9aaca Vladimir Oltean 2021-06-18  2314  	}
6666cebc5e306f Vladimir Oltean 2019-05-02  2315  
542043e91df452 Vladimir Oltean 2021-05-24  2316  	for (i = 0; i < ds->num_ports; i++) {
3ad1d171548e85 Vladimir Oltean 2021-06-11  2317  		struct dw_xpcs *xpcs = priv->xpcs[i];
3ad1d171548e85 Vladimir Oltean 2021-06-11  2318  		unsigned int mode;
84db00f2c04338 Vladimir Oltean 2021-05-31  2319  
8400cff60b472c Vladimir Oltean 2019-06-08  2320  		rc = sja1105_adjust_port_config(priv, i, speed_mbps[i]);
6666cebc5e306f Vladimir Oltean 2019-05-02  2321  		if (rc < 0)
6666cebc5e306f Vladimir Oltean 2019-05-02  2322  			goto out;
ffe10e679cec9a Vladimir Oltean 2020-03-20  2323  
3ad1d171548e85 Vladimir Oltean 2021-06-11  2324  		if (!xpcs)
84db00f2c04338 Vladimir Oltean 2021-05-31  2325  			continue;
84db00f2c04338 Vladimir Oltean 2021-05-31  2326  
3ad1d171548e85 Vladimir Oltean 2021-06-11  2327  		if (bmcr[i] & BMCR_ANENABLE)
3ad1d171548e85 Vladimir Oltean 2021-06-11  2328  			mode = MLO_AN_INBAND;
3ad1d171548e85 Vladimir Oltean 2021-06-11  2329  		else if (priv->fixed_link[i])
3ad1d171548e85 Vladimir Oltean 2021-06-11  2330  			mode = MLO_AN_FIXED;
3ad1d171548e85 Vladimir Oltean 2021-06-11  2331  		else
3ad1d171548e85 Vladimir Oltean 2021-06-11  2332  			mode = MLO_AN_PHY;
ffe10e679cec9a Vladimir Oltean 2020-03-20  2333  
3ad1d171548e85 Vladimir Oltean 2021-06-11 @2334  		rc = xpcs_do_config(xpcs, priv->phy_mode[i], mode);
3ad1d171548e85 Vladimir Oltean 2021-06-11  2335  		if (rc < 0)
3ad1d171548e85 Vladimir Oltean 2021-06-11  2336  			goto out;
ffe10e679cec9a Vladimir Oltean 2020-03-20  2337  
3ad1d171548e85 Vladimir Oltean 2021-06-11  2338  		if (!phylink_autoneg_inband(mode)) {
ffe10e679cec9a Vladimir Oltean 2020-03-20  2339  			int speed = SPEED_UNKNOWN;
ffe10e679cec9a Vladimir Oltean 2020-03-20  2340  
56b63466333b25 Vladimir Oltean 2021-06-11  2341  			if (priv->phy_mode[i] == PHY_INTERFACE_MODE_2500BASEX)
56b63466333b25 Vladimir Oltean 2021-06-11  2342  				speed = SPEED_2500;
56b63466333b25 Vladimir Oltean 2021-06-11  2343  			else if (bmcr[i] & BMCR_SPEED1000)
ffe10e679cec9a Vladimir Oltean 2020-03-20  2344  				speed = SPEED_1000;
84db00f2c04338 Vladimir Oltean 2021-05-31  2345  			else if (bmcr[i] & BMCR_SPEED100)
ffe10e679cec9a Vladimir Oltean 2020-03-20  2346  				speed = SPEED_100;
053d8ad10d585a Vladimir Oltean 2021-03-04  2347  			else
ffe10e679cec9a Vladimir Oltean 2020-03-20  2348  				speed = SPEED_10;
ffe10e679cec9a Vladimir Oltean 2020-03-20  2349  
3ad1d171548e85 Vladimir Oltean 2021-06-11  2350  			xpcs_link_up(&xpcs->pcs, mode, priv->phy_mode[i],
3ad1d171548e85 Vladimir Oltean 2021-06-11  2351  				     speed, DUPLEX_FULL);
ffe10e679cec9a Vladimir Oltean 2020-03-20  2352  		}
ffe10e679cec9a Vladimir Oltean 2020-03-20  2353  	}
4d7525085a9ba8 Vladimir Oltean 2020-05-28  2354  
4d7525085a9ba8 Vladimir Oltean 2020-05-28  2355  	rc = sja1105_reload_cbs(priv);
4d7525085a9ba8 Vladimir Oltean 2020-05-28  2356  	if (rc < 0)
4d7525085a9ba8 Vladimir Oltean 2020-05-28  2357  		goto out;
6666cebc5e306f Vladimir Oltean 2019-05-02  2358  out:
af580ae2dcb250 Vladimir Oltean 2019-11-09  2359  	mutex_unlock(&priv->mgmt_lock);
af580ae2dcb250 Vladimir Oltean 2019-11-09  2360  
6666cebc5e306f Vladimir Oltean 2019-05-02  2361  	return rc;
6666cebc5e306f Vladimir Oltean 2019-05-02  2362  }
6666cebc5e306f Vladimir Oltean 2019-05-02  2363  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

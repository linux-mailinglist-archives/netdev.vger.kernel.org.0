Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7404F5771FC
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 00:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbiGPWkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 18:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbiGPWkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 18:40:14 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEBB1D32E;
        Sat, 16 Jul 2022 15:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658011212; x=1689547212;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=L+o3eg2+E4M8Qj3NZLIj89/rrkgitvDG9kkWJG9cbwo=;
  b=n1qPmwhC6rNx07aWDCf8x/lqXUGxitB1aAVwZZ1JxVgzFV8BtKMgvHFh
   147UCSdq2UcDpA57M8cunmO6ROoKY2/+SJpIQLvqQ8HqvzoBY1MIBOutW
   BMjZ3F/7egl4kIkWSnosMNKnX8RpFe2+F3UQL7iYuav+/x1DcSre30hOX
   FJo3ywxZdAfSALLI408P7/52B+n4Pi/py+kt+ALaxO5N/D3Zx1z50IqEV
   JOueRxsqOdAWJT1wDwISnTRU91aJ8/et+mwLG3f1/Q3WAce6lVCYe75Wc
   MzW5xogv9zMY0M20w+ewcHIyAjGuS22McWUz+eew6soRHF/lRATuhmlG3
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10410"; a="266418310"
X-IronPort-AV: E=Sophos;i="5.92,277,1650956400"; 
   d="scan'208";a="266418310"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2022 15:40:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,277,1650956400"; 
   d="scan'208";a="600848420"
Received: from lkp-server02.sh.intel.com (HELO ff137eb26ff1) ([10.239.97.151])
  by fmsmga007.fm.intel.com with ESMTP; 16 Jul 2022 15:40:07 -0700
Received: from kbuild by ff137eb26ff1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oCqS4-0002Fo-Ts;
        Sat, 16 Jul 2022 22:39:56 +0000
Date:   Sun, 17 Jul 2022 06:39:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-phy@lists.infradead.org
Subject: Re: [PATCH net-next v3 06/47] [RFT] phy: fsl: Add Lynx 10G SerDes
 driver
Message-ID: <202207170654.0sfLE3ua-lkp@intel.com>
References: <20220715215954.1449214-7-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715215954.1449214-7-sean.anderson@seco.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Sean-Anderson/net-dpaa-Convert-to-phylink/20220717-002036
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 2acd1022549e210edc4cfc9fc65b07b88751f0d9
config: i386-allyesconfig (https://download.01.org/0day-ci/archive/20220717/202207170654.0sfLE3ua-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/fbc22d79121541a0f957e0c209810c37570041b5
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Sean-Anderson/net-dpaa-Convert-to-phylink/20220717-002036
        git checkout fbc22d79121541a0f957e0c209810c37570041b5
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/phy/freescale/phy-fsl-lynx-10g-clk.c: In function 'lynx_pll_recalc_rate':
>> drivers/phy/freescale/phy-fsl-lynx-10g-clk.c:211:25: error: implicit declaration of function 'FIELD_GET' [-Werror=implicit-function-declaration]
     211 |         u32 frate_sel = FIELD_GET(PLLaCR0_FRATE_SEL, cr0);
         |                         ^~~~~~~~~
   drivers/phy/freescale/phy-fsl-lynx-10g-clk.c: In function 'lynx_pll_set_rate':
>> drivers/phy/freescale/phy-fsl-lynx-10g-clk.c:294:16: error: implicit declaration of function 'FIELD_PREP' [-Werror=implicit-function-declaration]
     294 |         cr0 |= FIELD_PREP(PLLaCR0_RFCLK_SEL, rfclk_sel);
         |                ^~~~~~~~~~
   drivers/phy/freescale/phy-fsl-lynx-10g-clk.c: In function 'lynx_clk_init':
>> drivers/phy/freescale/phy-fsl-lynx-10g-clk.c:404:9: error: implicit declaration of function 'kfree'; did you mean 'vfree'? [-Werror=implicit-function-declaration]
     404 |         kfree(ref_name);
         |         ^~~~~
         |         vfree
   cc1: some warnings being treated as errors


vim +/FIELD_GET +211 drivers/phy/freescale/phy-fsl-lynx-10g-clk.c

   205	
   206	static unsigned long lynx_pll_recalc_rate(struct clk_hw *hw,
   207						unsigned long parent_rate)
   208	{
   209		struct lynx_clk *clk = lynx_pll_to_clk(hw);
   210		u32 cr0 = lynx_read(clk, PLLaCR0(clk->idx));
 > 211		u32 frate_sel = FIELD_GET(PLLaCR0_FRATE_SEL, cr0);
   212		u32 rfclk_sel = FIELD_GET(PLLaCR0_RFCLK_SEL, cr0);
   213		unsigned long ret;
   214	
   215		dev_dbg(clk->dev, "%s(pll%d, %lu)\n", __func__,
   216			clk->idx, parent_rate);
   217	
   218		ret = mult_frac(parent_rate, lynx_pll_ratio(frate_sel, rfclk_sel),
   219				 HZ_PER_KHZ);
   220		return ret;
   221	}
   222	
   223	static long lynx_pll_round_rate(struct clk_hw *hw, unsigned long rate_khz,
   224				      unsigned long *parent_rate)
   225	{
   226		int frate_sel, rfclk_sel;
   227		struct lynx_clk *clk = lynx_pll_to_clk(hw);
   228		u32 ratio;
   229	
   230		dev_dbg(clk->dev, "%s(pll%d, %lu, %lu)\n", __func__,
   231			clk->idx, rate_khz, *parent_rate);
   232	
   233		frate_sel = lynx_frate_to_sel(rate_khz);
   234		if (frate_sel < 0)
   235			return frate_sel;
   236	
   237		rfclk_sel = lynx_rfclk_to_sel(*parent_rate);
   238		if (rfclk_sel >= 0) {
   239			ratio = lynx_pll_ratio(frate_sel, rfclk_sel);
   240			if (ratio)
   241				return mult_frac(*parent_rate, ratio, HZ_PER_KHZ);
   242		}
   243	
   244		for (rfclk_sel = 0;
   245		     rfclk_sel < ARRAY_SIZE(rfclk_sel_map);
   246		     rfclk_sel++) {
   247			ratio = lynx_pll_ratio(frate_sel, rfclk_sel);
   248			if (ratio) {
   249				*parent_rate = rfclk_sel_map[rfclk_sel];
   250				return mult_frac(*parent_rate, ratio, HZ_PER_KHZ);
   251			}
   252		}
   253	
   254		return -EINVAL;
   255	}
   256	
   257	static int lynx_pll_set_rate(struct clk_hw *hw, unsigned long rate_khz,
   258				   unsigned long parent_rate)
   259	{
   260		int frate_sel, rfclk_sel, ret;
   261		struct lynx_clk *clk = lynx_pll_to_clk(hw);
   262		u32 ratio, cr0 = lynx_read(clk, PLLaCR0(clk->idx));
   263	
   264		dev_dbg(clk->dev, "%s(pll%d, %lu, %lu)\n", __func__,
   265			clk->idx, rate_khz, parent_rate);
   266	
   267		frate_sel = lynx_frate_to_sel(rate_khz);
   268		if (frate_sel < 0)
   269			return frate_sel;
   270	
   271		/* First try the existing rate */
   272		rfclk_sel = lynx_rfclk_to_sel(parent_rate);
   273		if (rfclk_sel >= 0) {
   274			ratio = lynx_pll_ratio(frate_sel, rfclk_sel);
   275			if (ratio)
   276				goto got_rfclk;
   277		}
   278	
   279		for (rfclk_sel = 0;
   280		     rfclk_sel < ARRAY_SIZE(rfclk_sel_map);
   281		     rfclk_sel++) {
   282			ratio = lynx_pll_ratio(frate_sel, rfclk_sel);
   283			if (ratio) {
   284				ret = clk_set_rate(clk->ref, rfclk_sel_map[rfclk_sel]);
   285				if (!ret)
   286					goto got_rfclk;
   287			}
   288		}
   289	
   290		return ret;
   291	
   292	got_rfclk:
   293		cr0 &= ~(PLLaCR0_RFCLK_SEL | PLLaCR0_FRATE_SEL);
 > 294		cr0 |= FIELD_PREP(PLLaCR0_RFCLK_SEL, rfclk_sel);
   295		cr0 |= FIELD_PREP(PLLaCR0_FRATE_SEL, frate_sel);
   296		lynx_write(clk, cr0, PLLaCR0(clk->idx));
   297		return 0;
   298	}
   299	
   300	static const struct clk_ops lynx_pll_clk_ops = {
   301		.prepare = lynx_pll_prepare,
   302		.disable = lynx_pll_disable,
   303		.is_enabled = lynx_pll_is_enabled,
   304		.recalc_rate = lynx_pll_recalc_rate,
   305		.round_rate = lynx_pll_round_rate,
   306		.set_rate = lynx_pll_set_rate,
   307	};
   308	
   309	static void lynx_ex_dly_disable(struct clk_hw *hw)
   310	{
   311		struct lynx_clk *clk = lynx_ex_dly_to_clk(hw);
   312		u32 cr0 = lynx_read(clk, PLLaCR0(clk->idx));
   313	
   314		cr0 &= ~PLLaCR0_DLYDIV_SEL;
   315		lynx_write(clk, PLLaCR0(clk->idx), cr0);
   316	}
   317	
   318	static int lynx_ex_dly_enable(struct clk_hw *hw)
   319	{
   320		struct lynx_clk *clk = lynx_ex_dly_to_clk(hw);
   321		u32 cr0 = lynx_read(clk, PLLaCR0(clk->idx));
   322	
   323		cr0 &= ~PLLaCR0_DLYDIV_SEL;
   324		cr0 |= FIELD_PREP(PLLaCR0_DLYDIV_SEL, PLLaCR0_DLYDIV_SEL_16);
   325		lynx_write(clk, PLLaCR0(clk->idx), cr0);
   326		return 0;
   327	}
   328	
   329	static int lynx_ex_dly_is_enabled(struct clk_hw *hw)
   330	{
   331		struct lynx_clk *clk = lynx_ex_dly_to_clk(hw);
   332	
   333		return lynx_read(clk, PLLaCR0(clk->idx)) & PLLaCR0_DLYDIV_SEL;
   334	}
   335	
   336	static unsigned long lynx_ex_dly_recalc_rate(struct clk_hw *hw,
   337						     unsigned long parent_rate)
   338	{
   339		return parent_rate / 16;
   340	}
   341	
   342	static const struct clk_ops lynx_ex_dly_clk_ops = {
   343		.enable = lynx_ex_dly_enable,
   344		.disable = lynx_ex_dly_disable,
   345		.is_enabled = lynx_ex_dly_is_enabled,
   346		.recalc_rate = lynx_ex_dly_recalc_rate,
   347	};
   348	
   349	static int lynx_clk_init(struct lynx_clk *clk, struct device *dev,
   350				 struct regmap *regmap, unsigned int index)
   351	{
   352		const struct clk_hw *pll_parents, *ex_dly_parents;
   353		struct clk_init_data pll_init = {
   354			.ops = &lynx_pll_clk_ops,
   355			.parent_hws = &pll_parents,
   356			.num_parents = 1,
   357			.flags = CLK_SET_RATE_GATE | CLK_GET_RATE_NOCACHE |
   358				 CLK_SET_RATE_PARENT | CLK_OPS_PARENT_ENABLE,
   359		};
   360		struct clk_init_data ex_dly_init = {
   361			.ops = &lynx_ex_dly_clk_ops,
   362			.parent_hws = &ex_dly_parents,
   363			.num_parents = 1,
   364		};
   365		char *ref_name;
   366		int ret;
   367	
   368		clk->dev = dev;
   369		clk->regmap = regmap;
   370		clk->idx = index;
   371	
   372		ref_name = kasprintf(GFP_KERNEL, "ref%d", index);
   373		pll_init.name = kasprintf(GFP_KERNEL, "%s.pll%d", dev_name(dev), index);
   374		ex_dly_init.name = kasprintf(GFP_KERNEL, "%s_ex_dly", pll_init.name);
   375		if (!ref_name || !pll_init.name || !ex_dly_init.name) {
   376			ret = -ENOMEM;
   377			goto out;
   378		}
   379	
   380		clk->ref = devm_clk_get(dev, ref_name);
   381		if (IS_ERR(clk->ref)) {
   382			ret = PTR_ERR(clk->ref);
   383			dev_err_probe(dev, ret, "could not get %s\n", ref_name);
   384			goto out;
   385		}
   386	
   387		pll_parents = __clk_get_hw(clk->ref);
   388		clk->pll.init = &pll_init;
   389		ret = devm_clk_hw_register(dev, &clk->pll);
   390		if (ret) {
   391			dev_err_probe(dev, ret, "could not register %s\n",
   392				      pll_init.name);
   393			goto out;
   394		}
   395	
   396		ex_dly_parents = &clk->pll;
   397		clk->ex_dly.init = &ex_dly_init;
   398		ret = devm_clk_hw_register(dev, &clk->ex_dly);
   399		if (ret)
   400			dev_err_probe(dev, ret, "could not register %s\n",
   401				      ex_dly_init.name);
   402	
   403	out:
 > 404		kfree(ref_name);
   405		kfree(pll_init.name);
   406		kfree(ex_dly_init.name);
   407		return ret;
   408	}
   409	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

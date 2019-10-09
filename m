Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3CCD091D
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 10:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbfJIIGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 04:06:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:9156 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfJIIGG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 04:06:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 01:06:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="206827005"
Received: from shao2-debian.sh.intel.com (HELO [10.239.13.6]) ([10.239.13.6])
  by fmsmga001.fm.intel.com with ESMTP; 09 Oct 2019 01:06:03 -0700
Subject: Re: [kbuild-all] [PATCH] net: stmmac: socfpga: re-use the `interface`
 parameter from platform data
To:     "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>,
        "lkp@intel.com" <lkp@intel.com>
Cc:     "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "kbuild-all@01.org" <kbuild-all@01.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <20190906123054.5514-1-alexandru.ardelean@analog.com>
 <201909072036.v1rX0Vwh%lkp@intel.com>
 <a7dc54d6e1fad0dc464a30101c8740b8c11f2d8b.camel@analog.com>
From:   Rong Chen <rong.a.chen@intel.com>
Message-ID: <147dd25f-c474-c5f7-11fd-9feab327b4b4@intel.com>
Date:   Wed, 9 Oct 2019 16:05:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <a7dc54d6e1fad0dc464a30101c8740b8c11f2d8b.camel@analog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/9/19 4:53 PM, Ardelean, Alexandru wrote:
> On Sat, 2019-09-07 at 20:54 +0800, kbuild test robot wrote:
>> [External]
>>
>> Hi Alexandru,
>>
>> I love your patch! Yet something to improve:
>>
>> [auto build test ERROR on linus/master]
> Hmm, this error should be expectable I guess: I applied this on net-next/master.

Sorry for the inconvenience, we'll take a look. btw, 0day-CI introduced 
'--base' option to record base tree info in format-patch.
please see https://stackoverflow.com/a/37406982

Best Regards,
Rong Chen

>
> Alex
>
>> [cannot apply to v5.3-rc7 next-20190904]
>> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>>
>> url:
>> https://github.com/0day-ci/linux/commits/Alexandru-Ardelean/net-stmmac-socfpga-re-use-the-interface-parameter-from-platform-data/20190907-190627
>> config: sparc64-allmodconfig (attached as .config)
>> compiler: sparc64-linux-gcc (GCC) 7.4.0
>> reproduce:
>>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>>          chmod +x ~/bin/make.cross
>>          # save the attached .config to linux build tree
>>          GCC_VERSION=7.4.0 make.cross ARCH=sparc64
>>
>> If you fix the issue, kindly add following tag
>> Reported-by: kbuild test robot <lkp@intel.com>
>>
>> All errors (new ones prefixed by >>):
>>
>>     In file included from include/linux/dma-mapping.h:7:0,
>>                      from include/linux/skbuff.h:30,
>>                      from include/linux/if_ether.h:19,
>>                      from include/uapi/linux/ethtool.h:19,
>>                      from include/linux/ethtool.h:18,
>>                      from include/linux/phy.h:16,
>>                      from drivers/net//ethernet/stmicro/stmmac/dwmac-socfpga.c:11:
>>     drivers/net//ethernet/stmicro/stmmac/dwmac-socfpga.c: In function 'socfpga_gen5_set_phy_mode':
>>>> drivers/net//ethernet/stmicro/stmmac/dwmac-socfpga.c:264:44: error: 'phymode' undeclared (first use in this
>>>> function); did you mean 'phy_modes'?
>>        dev_err(dwmac->dev, "bad phy mode %d\n", phymode);
>>                                                 ^
>>     include/linux/device.h:1499:32: note: in definition of macro 'dev_err'
>>       _dev_err(dev, dev_fmt(fmt), ##__VA_ARGS__)
>>                                     ^~~~~~~~~~~
>>     drivers/net//ethernet/stmicro/stmmac/dwmac-socfpga.c:264:44: note: each undeclared identifier is reported only once
>> for each function it appears in
>>        dev_err(dwmac->dev, "bad phy mode %d\n", phymode);
>>                                                 ^
>>     include/linux/device.h:1499:32: note: in definition of macro 'dev_err'
>>       _dev_err(dev, dev_fmt(fmt), ##__VA_ARGS__)
>>                                     ^~~~~~~~~~~
>>     drivers/net//ethernet/stmicro/stmmac/dwmac-socfpga.c: In function 'socfpga_gen10_set_phy_mode':
>>     drivers/net//ethernet/stmicro/stmmac/dwmac-socfpga.c:340:6: error: 'phymode' undeclared (first use in this
>> function); did you mean 'phy_modes'?
>>           phymode == PHY_INTERFACE_MODE_MII ||
>>           ^~~~~~~
>>           phy_modes
>>
>> vim +264 drivers/net//ethernet/stmicro/stmmac/dwmac-socfpga.c
>>
>> 40ae25505fe834 Dinh Nguyen        2019-06-05  255
>> 40ae25505fe834 Dinh Nguyen        2019-06-05  256  static int socfpga_gen5_set_phy_mode(struct socfpga_dwmac *dwmac)
>> 40ae25505fe834 Dinh Nguyen        2019-06-05  257  {
>> 40ae25505fe834 Dinh Nguyen        2019-06-05  258  	struct regmap *sys_mgr_base_addr = dwmac->sys_mgr_base_addr;
>> 40ae25505fe834 Dinh Nguyen        2019-06-05  259  	u32 reg_offset = dwmac->reg_offset;
>> 40ae25505fe834 Dinh Nguyen        2019-06-05  260  	u32 reg_shift = dwmac->reg_shift;
>> 40ae25505fe834 Dinh Nguyen        2019-06-05  261  	u32 ctrl, val, module;
>> 40ae25505fe834 Dinh Nguyen        2019-06-05  262
>> 6169afbe4a340b Alexandru Ardelean 2019-09-06  263  	if (socfpga_set_phy_mode_common(dwmac, &val)) {
>> 801d233b7302ee Dinh Nguyen        2014-03-26 @264  		dev_err(dwmac->dev, "bad phy mode %d\n", phymode);
>> 801d233b7302ee Dinh Nguyen        2014-03-26  265  		return -EINVAL;
>> 801d233b7302ee Dinh Nguyen        2014-03-26  266  	}
>> 801d233b7302ee Dinh Nguyen        2014-03-26  267
>> b4834c86e11baf Ley Foon Tan       2014-08-20  268  	/* Overwrite val to GMII if splitter core is enabled. The
>> phymode here
>> b4834c86e11baf Ley Foon Tan       2014-08-20  269  	 * is the actual phy mode on phy hardware, but phy interface
>> from
>> b4834c86e11baf Ley Foon Tan       2014-08-20  270  	 * EMAC core is GMII.
>> b4834c86e11baf Ley Foon Tan       2014-08-20  271  	 */
>> b4834c86e11baf Ley Foon Tan       2014-08-20  272  	if (dwmac->splitter_base)
>> b4834c86e11baf Ley Foon Tan       2014-08-20  273  		val = SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_GMII_MII;
>> b4834c86e11baf Ley Foon Tan       2014-08-20  274
>> 70cb136f773083 Joachim Eastwood   2016-05-01  275  	/* Assert reset to the enet controller before changing the phy
>> mode */
>> bc8a2d9bcbf1ca Dinh Nguyen        2018-06-19  276  	reset_control_assert(dwmac->stmmac_ocp_rst);
>> 70cb136f773083 Joachim Eastwood   2016-05-01  277  	reset_control_assert(dwmac->stmmac_rst);
>> 70cb136f773083 Joachim Eastwood   2016-05-01  278
>> 801d233b7302ee Dinh Nguyen        2014-03-26  279  	regmap_read(sys_mgr_base_addr, reg_offset, &ctrl);
>> 801d233b7302ee Dinh Nguyen        2014-03-26  280  	ctrl &= ~(SYSMGR_EMACGRP_CTRL_PHYSEL_MASK << reg_shift);
>> 801d233b7302ee Dinh Nguyen        2014-03-26  281  	ctrl |= val << reg_shift;
>> 801d233b7302ee Dinh Nguyen        2014-03-26  282
>> 013dae5dbc07aa Stephan Gatzka     2017-08-22  283  	if (dwmac->f2h_ptp_ref_clk ||
>> 013dae5dbc07aa Stephan Gatzka     2017-08-22  284  	    phymode == PHY_INTERFACE_MODE_MII ||
>> 013dae5dbc07aa Stephan Gatzka     2017-08-22  285  	    phymode == PHY_INTERFACE_MODE_GMII ||
>> 013dae5dbc07aa Stephan Gatzka     2017-08-22  286  	    phymode == PHY_INTERFACE_MODE_SGMII) {
>> 43569814fa35b2 Phil Reid          2015-12-14  287  		ctrl |= SYSMGR_EMACGRP_CTRL_PTP_REF_CLK_MASK <<
>> (reg_shift / 2);
>> 734e00fa02eff5 Phil Reid          2016-04-07  288  		regmap_read(sys_mgr_base_addr,
>> SYSMGR_FPGAGRP_MODULE_REG,
>> 734e00fa02eff5 Phil Reid          2016-04-07  289  			    &module);
>> 734e00fa02eff5 Phil Reid          2016-04-07  290  		module |= (SYSMGR_FPGAGRP_MODULE_EMAC << (reg_shift /
>> 2));
>> 734e00fa02eff5 Phil Reid          2016-04-07  291  		regmap_write(sys_mgr_base_addr,
>> SYSMGR_FPGAGRP_MODULE_REG,
>> 734e00fa02eff5 Phil Reid          2016-04-07  292  			     module);
>> 734e00fa02eff5 Phil Reid          2016-04-07  293  	} else {
>> 43569814fa35b2 Phil Reid          2015-12-14  294  		ctrl &= ~(SYSMGR_EMACGRP_CTRL_PTP_REF_CLK_MASK <<
>> (reg_shift / 2));
>> 734e00fa02eff5 Phil Reid          2016-04-07  295  	}
>> 43569814fa35b2 Phil Reid          2015-12-14  296
>> 801d233b7302ee Dinh Nguyen        2014-03-26  297  	regmap_write(sys_mgr_base_addr, reg_offset, ctrl);
>> 734e00fa02eff5 Phil Reid          2016-04-07  298
>> 70cb136f773083 Joachim Eastwood   2016-05-01  299  	/* Deassert reset for the phy configuration to be sampled by
>> 70cb136f773083 Joachim Eastwood   2016-05-01  300  	 * the enet controller, and operation to start in requested mode
>> 70cb136f773083 Joachim Eastwood   2016-05-01  301  	 */
>> bc8a2d9bcbf1ca Dinh Nguyen        2018-06-19  302  	reset_control_deassert(dwmac->stmmac_ocp_rst);
>> 70cb136f773083 Joachim Eastwood   2016-05-01  303  	reset_control_deassert(dwmac->stmmac_rst);
>> fb3bbdb859891e Tien Hock Loh      2016-07-07  304  	if (phymode == PHY_INTERFACE_MODE_SGMII) {
>> fb3bbdb859891e Tien Hock Loh      2016-07-07  305  		if (tse_pcs_init(dwmac->pcs.tse_pcs_base, &dwmac->pcs)
>> != 0) {
>> fb3bbdb859891e Tien Hock Loh      2016-07-07  306  			dev_err(dwmac->dev, "Unable to initialize TSE
>> PCS");
>> fb3bbdb859891e Tien Hock Loh      2016-07-07  307  			return -EINVAL;
>> fb3bbdb859891e Tien Hock Loh      2016-07-07  308  		}
>> fb3bbdb859891e Tien Hock Loh      2016-07-07  309  	}
>> 70cb136f773083 Joachim Eastwood   2016-05-01  310
>> 801d233b7302ee Dinh Nguyen        2014-03-26  311  	return 0;
>> 801d233b7302ee Dinh Nguyen        2014-03-26  312  }
>> 801d233b7302ee Dinh Nguyen        2014-03-26  313
>>
>> :::::: The code at line 264 was first introduced by commit
>> :::::: 801d233b7302eeab94750427a623c10c044cb0ca net: stmmac: Add SOCFPGA glue driver
>>
>> :::::: TO: Dinh Nguyen <dinguyen@altera.com>
>> :::::: CC: David S. Miller <davem@davemloft.net>
>>
>> ---
>> 0-DAY kernel test infrastructure                Open Source Technology Center
>> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> _______________________________________________
> kbuild-all mailing list
> kbuild-all@lists.01.org
> https://lists.01.org/mailman/listinfo/kbuild-all


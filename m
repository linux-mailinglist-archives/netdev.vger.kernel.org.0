Return-Path: <netdev+bounces-2321-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B96237012F8
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 02:27:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B27471C212A9
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 00:27:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A799B7E8;
	Sat, 13 May 2023 00:27:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925247E1
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 00:27:06 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF4E2686;
	Fri, 12 May 2023 17:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683937624; x=1715473624;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hyUEy74We14AFulU3g1ahmvXwKYZNaHi/+WmwDhbsHI=;
  b=KV1keR3svbNA/ihlFvWqx8lF9QVJMh7A41s+ZypYd6N0bauXG6PgjbOC
   HYCsIpBjNXFgDk4tzRJtG2EXwkORRIikhKpjs8MxDmTPLMlma0wFLV7JA
   AytgCCUAALbPhIaHCX2RInI0DCBzR3KfHx2QUDyH/6JM9K8o+0C59d386
   cPkjOP0zoRXEf1sQ8tTTD5ActU+51KHt6m0ttew7Nk9s1FNg8MD/RPC+z
   p7vS8w6/r4G6CGDv6S0QiVHveyi5908Evj74JsgrCP8sO7sft/fyOeRAA
   afMRiPkfy5WLp3rucikpUhVvrrdliNZCfg5rjbTOpIwXW2ApAod7UFV5r
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="437245942"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="437245942"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 17:27:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="824529268"
X-IronPort-AV: E=Sophos;i="5.99,271,1677571200"; 
   d="scan'208";a="824529268"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 12 May 2023 17:27:00 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1pxd6B-0005CF-1L;
	Sat, 13 May 2023 00:26:59 +0000
Date: Sat, 13 May 2023 08:26:39 +0800
From: kernel test robot <lkp@intel.com>
To: Rohit Agarwal <quic_rohiagar@quicinc.com>, agross@kernel.org,
	andersson@kernel.org, konrad.dybcio@linaro.org,
	linus.walleij@linaro.org, robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, richardcochran@gmail.com,
	manivannan.sadhasivam@linaro.org, andy.shevchenko@gmail.com
Cc: oe-kbuild-all@lists.linux.dev, linux-arm-msm@vger.kernel.org,
	linux-gpio@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Rohit Agarwal <quic_rohiagar@quicinc.com>
Subject: Re: [PATCH 1/2] pinctrl: qcom: Remove the msm_function struct
Message-ID: <202305130813.9ypkiIW0-lkp@intel.com>
References: <1683892553-19882-2-git-send-email-quic_rohiagar@quicinc.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1683892553-19882-2-git-send-email-quic_rohiagar@quicinc.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Rohit,

kernel test robot noticed the following build errors:

[auto build test ERROR on linusw-pinctrl/devel]
[also build test ERROR on linusw-pinctrl/for-next linus/master v6.4-rc1 next-20230512]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Rohit-Agarwal/pinctrl-qcom-Remove-the-msm_function-struct/20230512-195910
base:   https://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git devel
patch link:    https://lore.kernel.org/r/1683892553-19882-2-git-send-email-quic_rohiagar%40quicinc.com
patch subject: [PATCH 1/2] pinctrl: qcom: Remove the msm_function struct
config: arm-allyesconfig (https://download.01.org/0day-ci/archive/20230513/202305130813.9ypkiIW0-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/3d2ada4f090f8ebd3b604ccb917394e8b30e23f8
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Rohit-Agarwal/pinctrl-qcom-Remove-the-msm_function-struct/20230512-195910
        git checkout 3d2ada4f090f8ebd3b604ccb917394e8b30e23f8
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305130813.9ypkiIW0-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/pinctrl/qcom/pinctrl-sm7150.c:969:34: error: array type has incomplete element type 'struct msm_function'
     969 | static const struct msm_function sm7150_functions[] = {
         |                                  ^~~~~~~~~~~~~~~~
   In file included from include/linux/container_of.h:5,
                    from include/linux/list.h:5,
                    from include/linux/module.h:12,
                    from drivers/pinctrl/qcom/pinctrl-sm7150.c:7:
   include/linux/build_bug.h:16:51: error: bit-field '<anonymous>' width not an integer constant
      16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
         |                                                   ^
   include/linux/compiler.h:232:33: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     232 | #define __must_be_array(a)      BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
         |                                 ^~~~~~~~~~~~~~~~~
   include/linux/kernel.h:56:59: note: in expansion of macro '__must_be_array'
      56 | #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
         |                                                           ^~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1236:23: note: in expansion of macro 'ARRAY_SIZE'
    1236 |         .nfunctions = ARRAY_SIZE(sm7150_functions),
         |                       ^~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:969:34: warning: 'sm7150_functions' defined but not used [-Wunused-variable]
     969 | static const struct msm_function sm7150_functions[] = {
         |                                  ^~~~~~~~~~~~~~~~


vim +969 drivers/pinctrl/qcom/pinctrl-sm7150.c

b915395c9e04361 Danila Tikhonov 2023-03-12   968  
b915395c9e04361 Danila Tikhonov 2023-03-12  @969  static const struct msm_function sm7150_functions[] = {
b915395c9e04361 Danila Tikhonov 2023-03-12   970  	FUNCTION(gpio),
b915395c9e04361 Danila Tikhonov 2023-03-12   971  	FUNCTION(adsp_ext),
b915395c9e04361 Danila Tikhonov 2023-03-12   972  	FUNCTION(agera_pll),
b915395c9e04361 Danila Tikhonov 2023-03-12   973  	FUNCTION(aoss_cti),
b915395c9e04361 Danila Tikhonov 2023-03-12   974  	FUNCTION(atest_char),
b915395c9e04361 Danila Tikhonov 2023-03-12   975  	FUNCTION(atest_tsens),
b915395c9e04361 Danila Tikhonov 2023-03-12   976  	FUNCTION(atest_tsens2),
b915395c9e04361 Danila Tikhonov 2023-03-12   977  	FUNCTION(atest_usb1),
b915395c9e04361 Danila Tikhonov 2023-03-12   978  	FUNCTION(atest_usb2),
b915395c9e04361 Danila Tikhonov 2023-03-12   979  	FUNCTION(cam_mclk),
b915395c9e04361 Danila Tikhonov 2023-03-12   980  	FUNCTION(cci_async),
b915395c9e04361 Danila Tikhonov 2023-03-12   981  	FUNCTION(cci_i2c),
b915395c9e04361 Danila Tikhonov 2023-03-12   982  	FUNCTION(cci_timer0),
b915395c9e04361 Danila Tikhonov 2023-03-12   983  	FUNCTION(cci_timer1),
b915395c9e04361 Danila Tikhonov 2023-03-12   984  	FUNCTION(cci_timer2),
b915395c9e04361 Danila Tikhonov 2023-03-12   985  	FUNCTION(cci_timer3),
b915395c9e04361 Danila Tikhonov 2023-03-12   986  	FUNCTION(cci_timer4),
b915395c9e04361 Danila Tikhonov 2023-03-12   987  	FUNCTION(dbg_out),
b915395c9e04361 Danila Tikhonov 2023-03-12   988  	FUNCTION(ddr_bist),
b915395c9e04361 Danila Tikhonov 2023-03-12   989  	FUNCTION(ddr_pxi0),
b915395c9e04361 Danila Tikhonov 2023-03-12   990  	FUNCTION(ddr_pxi1),
b915395c9e04361 Danila Tikhonov 2023-03-12   991  	FUNCTION(ddr_pxi2),
b915395c9e04361 Danila Tikhonov 2023-03-12   992  	FUNCTION(ddr_pxi3),
b915395c9e04361 Danila Tikhonov 2023-03-12   993  	FUNCTION(edp_hot),
b915395c9e04361 Danila Tikhonov 2023-03-12   994  	FUNCTION(edp_lcd),
b915395c9e04361 Danila Tikhonov 2023-03-12   995  	FUNCTION(gcc_gp1),
b915395c9e04361 Danila Tikhonov 2023-03-12   996  	FUNCTION(gcc_gp2),
b915395c9e04361 Danila Tikhonov 2023-03-12   997  	FUNCTION(gcc_gp3),
b915395c9e04361 Danila Tikhonov 2023-03-12   998  	FUNCTION(gp_pdm0),
b915395c9e04361 Danila Tikhonov 2023-03-12   999  	FUNCTION(gp_pdm1),
b915395c9e04361 Danila Tikhonov 2023-03-12  1000  	FUNCTION(gp_pdm2),
b915395c9e04361 Danila Tikhonov 2023-03-12  1001  	FUNCTION(gps_tx),
b915395c9e04361 Danila Tikhonov 2023-03-12  1002  	FUNCTION(jitter_bist),
b915395c9e04361 Danila Tikhonov 2023-03-12  1003  	FUNCTION(ldo_en),
b915395c9e04361 Danila Tikhonov 2023-03-12  1004  	FUNCTION(ldo_update),
b915395c9e04361 Danila Tikhonov 2023-03-12  1005  	FUNCTION(m_voc),
b915395c9e04361 Danila Tikhonov 2023-03-12  1006  	FUNCTION(mdp_vsync),
b915395c9e04361 Danila Tikhonov 2023-03-12  1007  	FUNCTION(mdp_vsync0),
b915395c9e04361 Danila Tikhonov 2023-03-12  1008  	FUNCTION(mdp_vsync1),
b915395c9e04361 Danila Tikhonov 2023-03-12  1009  	FUNCTION(mdp_vsync2),
b915395c9e04361 Danila Tikhonov 2023-03-12  1010  	FUNCTION(mdp_vsync3),
b915395c9e04361 Danila Tikhonov 2023-03-12  1011  	FUNCTION(mss_lte),
b915395c9e04361 Danila Tikhonov 2023-03-12  1012  	FUNCTION(nav_pps_in),
b915395c9e04361 Danila Tikhonov 2023-03-12  1013  	FUNCTION(nav_pps_out),
b915395c9e04361 Danila Tikhonov 2023-03-12  1014  	FUNCTION(pa_indicator),
b915395c9e04361 Danila Tikhonov 2023-03-12  1015  	FUNCTION(pci_e),
b915395c9e04361 Danila Tikhonov 2023-03-12  1016  	FUNCTION(phase_flag),
b915395c9e04361 Danila Tikhonov 2023-03-12  1017  	FUNCTION(pll_bist),
b915395c9e04361 Danila Tikhonov 2023-03-12  1018  	FUNCTION(pll_bypassnl),
b915395c9e04361 Danila Tikhonov 2023-03-12  1019  	FUNCTION(pll_reset),
b915395c9e04361 Danila Tikhonov 2023-03-12  1020  	FUNCTION(pri_mi2s),
b915395c9e04361 Danila Tikhonov 2023-03-12  1021  	FUNCTION(pri_mi2s_ws),
b915395c9e04361 Danila Tikhonov 2023-03-12  1022  	FUNCTION(prng_rosc),
b915395c9e04361 Danila Tikhonov 2023-03-12  1023  	FUNCTION(qdss_cti),
b915395c9e04361 Danila Tikhonov 2023-03-12  1024  	FUNCTION(qdss),
b915395c9e04361 Danila Tikhonov 2023-03-12  1025  	FUNCTION(qlink_enable),
b915395c9e04361 Danila Tikhonov 2023-03-12  1026  	FUNCTION(qlink_request),
b915395c9e04361 Danila Tikhonov 2023-03-12  1027  	FUNCTION(qua_mi2s),
b915395c9e04361 Danila Tikhonov 2023-03-12  1028  	FUNCTION(qup00),
b915395c9e04361 Danila Tikhonov 2023-03-12  1029  	FUNCTION(qup01),
b915395c9e04361 Danila Tikhonov 2023-03-12  1030  	FUNCTION(qup02),
b915395c9e04361 Danila Tikhonov 2023-03-12  1031  	FUNCTION(qup03),
b915395c9e04361 Danila Tikhonov 2023-03-12  1032  	FUNCTION(qup04),
b915395c9e04361 Danila Tikhonov 2023-03-12  1033  	FUNCTION(qup10),
b915395c9e04361 Danila Tikhonov 2023-03-12  1034  	FUNCTION(qup11),
b915395c9e04361 Danila Tikhonov 2023-03-12  1035  	FUNCTION(qup12),
b915395c9e04361 Danila Tikhonov 2023-03-12  1036  	FUNCTION(qup13),
b915395c9e04361 Danila Tikhonov 2023-03-12  1037  	FUNCTION(qup14),
b915395c9e04361 Danila Tikhonov 2023-03-12  1038  	FUNCTION(qup15),
b915395c9e04361 Danila Tikhonov 2023-03-12  1039  	FUNCTION(sd_write),
b915395c9e04361 Danila Tikhonov 2023-03-12  1040  	FUNCTION(sdc40),
b915395c9e04361 Danila Tikhonov 2023-03-12  1041  	FUNCTION(sdc41),
b915395c9e04361 Danila Tikhonov 2023-03-12  1042  	FUNCTION(sdc42),
b915395c9e04361 Danila Tikhonov 2023-03-12  1043  	FUNCTION(sdc43),
b915395c9e04361 Danila Tikhonov 2023-03-12  1044  	FUNCTION(sdc4_clk),
b915395c9e04361 Danila Tikhonov 2023-03-12  1045  	FUNCTION(sdc4_cmd),
b915395c9e04361 Danila Tikhonov 2023-03-12  1046  	FUNCTION(sec_mi2s),
b915395c9e04361 Danila Tikhonov 2023-03-12  1047  	FUNCTION(ter_mi2s),
b915395c9e04361 Danila Tikhonov 2023-03-12  1048  	FUNCTION(tgu_ch0),
b915395c9e04361 Danila Tikhonov 2023-03-12  1049  	FUNCTION(tgu_ch1),
b915395c9e04361 Danila Tikhonov 2023-03-12  1050  	FUNCTION(tgu_ch2),
b915395c9e04361 Danila Tikhonov 2023-03-12  1051  	FUNCTION(tgu_ch3),
b915395c9e04361 Danila Tikhonov 2023-03-12  1052  	FUNCTION(tsif1_clk),
b915395c9e04361 Danila Tikhonov 2023-03-12  1053  	FUNCTION(tsif1_data),
b915395c9e04361 Danila Tikhonov 2023-03-12  1054  	FUNCTION(tsif1_en),
b915395c9e04361 Danila Tikhonov 2023-03-12  1055  	FUNCTION(tsif1_error),
b915395c9e04361 Danila Tikhonov 2023-03-12  1056  	FUNCTION(tsif1_sync),
b915395c9e04361 Danila Tikhonov 2023-03-12  1057  	FUNCTION(tsif2_clk),
b915395c9e04361 Danila Tikhonov 2023-03-12  1058  	FUNCTION(tsif2_data),
b915395c9e04361 Danila Tikhonov 2023-03-12  1059  	FUNCTION(tsif2_en),
b915395c9e04361 Danila Tikhonov 2023-03-12  1060  	FUNCTION(tsif2_error),
b915395c9e04361 Danila Tikhonov 2023-03-12  1061  	FUNCTION(tsif2_sync),
b915395c9e04361 Danila Tikhonov 2023-03-12  1062  	FUNCTION(uim1_clk),
b915395c9e04361 Danila Tikhonov 2023-03-12  1063  	FUNCTION(uim1_data),
b915395c9e04361 Danila Tikhonov 2023-03-12  1064  	FUNCTION(uim1_present),
b915395c9e04361 Danila Tikhonov 2023-03-12  1065  	FUNCTION(uim1_reset),
b915395c9e04361 Danila Tikhonov 2023-03-12  1066  	FUNCTION(uim2_clk),
b915395c9e04361 Danila Tikhonov 2023-03-12  1067  	FUNCTION(uim2_data),
b915395c9e04361 Danila Tikhonov 2023-03-12  1068  	FUNCTION(uim2_present),
b915395c9e04361 Danila Tikhonov 2023-03-12  1069  	FUNCTION(uim2_reset),
b915395c9e04361 Danila Tikhonov 2023-03-12  1070  	FUNCTION(uim_batt),
b915395c9e04361 Danila Tikhonov 2023-03-12  1071  	FUNCTION(usb_phy),
b915395c9e04361 Danila Tikhonov 2023-03-12  1072  	FUNCTION(vfr_1),
b915395c9e04361 Danila Tikhonov 2023-03-12  1073  	FUNCTION(vsense_trigger),
b915395c9e04361 Danila Tikhonov 2023-03-12  1074  	FUNCTION(wlan1_adc0),
b915395c9e04361 Danila Tikhonov 2023-03-12  1075  	FUNCTION(wlan1_adc1),
b915395c9e04361 Danila Tikhonov 2023-03-12  1076  	FUNCTION(wlan2_adc0),
b915395c9e04361 Danila Tikhonov 2023-03-12  1077  	FUNCTION(wlan2_adc1),
b915395c9e04361 Danila Tikhonov 2023-03-12  1078  	FUNCTION(wsa_clk),
b915395c9e04361 Danila Tikhonov 2023-03-12  1079  	FUNCTION(wsa_data),
b915395c9e04361 Danila Tikhonov 2023-03-12  1080  };
b915395c9e04361 Danila Tikhonov 2023-03-12  1081  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests


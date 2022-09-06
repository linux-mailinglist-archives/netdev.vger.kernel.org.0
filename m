Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F35D5AE81A
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 14:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbiIFM3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 08:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240120AbiIFM2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 08:28:20 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652F8B2
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 05:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662467062; x=1694003062;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+4ytQKXb9wrXuriZ/KL3y9KZZR7sPj+DMW/Fh3kClS4=;
  b=YF8+sltPY3Qa6FrtcRx13aS93aylivT2rdajqCn22Mo9JIe3PVNyVBgM
   jv/QxP4TF33yWNoDQunbxHcIVl+mopCdZKnC1uB3LCjV5yQ0hDJyphid/
   Cucx2dZZIqKJwoHsrpWK4Lm4hkFfcpSRjIkfaxa+nQl4l4sE8i0220MQs
   24a8GgU13Zg4CqwP/dG6WpkwSTQcqKj0DshHXja4esItGt08RzspqwYwh
   AfUjnACO9SxXlpyGtN6E4LdrsNQLTZQ0o6++2cWbi2Z7G8q+36F7yXONp
   Lkvw6/2He9ztkL9KtEnKfijuqTw5mmn2KLLFTx738xAs9UOJx+V09T4bi
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10461"; a="296579016"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="296579016"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 05:23:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="647211590"
Received: from lkp-server02.sh.intel.com (HELO 95dfd251caa2) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 06 Sep 2022 05:23:21 -0700
Received: from kbuild by 95dfd251caa2 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oVXbs-00055t-1w;
        Tue, 06 Sep 2022 12:23:20 +0000
Date:   Tue, 6 Sep 2022 20:22:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        jiawenwu@net-swift.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: Re: [PATCH net-next 2] net: ngbe: sw init and hw init
Message-ID: <202209062015.jlZLOfpQ-lkp@intel.com>
References: <20220905125224.2279-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220905125224.2279-1-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mengyuan,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Mengyuan-Lou/net-ngbe-sw-init-and-hw-init/20220905-210027
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 6630edabd80823cc6f7c874d52a4cac6381b9051
config: arm64-allmodconfig (https://download.01.org/0day-ci/archive/20220906/202209062015.jlZLOfpQ-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project c55b41d5199d2394dd6cdb8f52180d8b81d809d4)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm64 cross compiling tool for clang build
        # apt-get install binutils-aarch64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/683e3287b25349b7844b53577086124b2bdf3cb6
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Mengyuan-Lou/net-ngbe-sw-init-and-hw-init/20220905-210027
        git checkout 683e3287b25349b7844b53577086124b2bdf3cb6
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash drivers/net/ethernet/ kernel/power/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/wangxun/ngbe/ngbe_main.c:107:30: warning: result of comparison of constant 16384 with expression of type 'u8' (aka 'unsigned char') is always false [-Wtautological-constant-out-of-range-compare]
           hw->wol_enabled = (wol_mask == NGBE_WOL_SUP) ? 1 : 0;
                              ~~~~~~~~ ^  ~~~~~~~~~~~~
   drivers/net/ethernet/wangxun/ngbe/ngbe_main.c:108:32: warning: result of comparison of constant 32768 with expression of type 'u8' (aka 'unsigned char') is always false [-Wtautological-constant-out-of-range-compare]
           hw->ncsi_enabled = (ncsi_mask == NGBE_NCSI_MASK ||
                               ~~~~~~~~~ ^  ~~~~~~~~~~~~~~
   2 warnings generated.


vim +107 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c

    59	
    60	/**
    61	 *  ngbe_init_type_code - Initialize the shared code
    62	 *  @hw: pointer to hardware structure
    63	 **/
    64	static void ngbe_init_type_code(struct ngbe_hw *hw)
    65	{
    66		u8 wol_mask = 0, ncsi_mask = 0;
    67		u16 type_mask = 0;
    68	
    69		type_mask = (u16)(hw->subsystem_device_id & NGBE_OEM_MASK);
    70		ncsi_mask = (u8)(hw->subsystem_device_id & NGBE_NCSI_MASK);
    71		wol_mask = (u8)(hw->subsystem_device_id & NGBE_WOL_MASK);
    72	
    73		switch (type_mask) {
    74		case NGBE_SUBID_M88E1512_SFP:
    75		case NGBE_SUBID_LY_M88E1512_SFP:
    76			hw->phy.type = ngbe_phy_m88e1512_sfi;
    77			break;
    78		case NGBE_SUBID_M88E1512_RJ45:
    79			hw->phy.type = ngbe_phy_m88e1512;
    80			break;
    81		case NGBE_SUBID_M88E1512_MIX:
    82			hw->phy.type = ngbe_phy_m88e1512_unknown;
    83			break;
    84		case NGBE_SUBID_YT8521S_SFP:
    85		case NGBE_SUBID_YT8521S_SFP_GPIO:
    86		case NGBE_SUBID_LY_YT8521S_SFP:
    87			hw->phy.type = ngbe_phy_yt8521s_sfi;
    88			break;
    89		case NGBE_SUBID_INTERNAL_YT8521S_SFP:
    90		case NGBE_SUBID_INTERNAL_YT8521S_SFP_GPIO:
    91			hw->phy.type = ngbe_phy_internal_yt8521s_sfi;
    92			break;
    93		case NGBE_SUBID_RGMII_FPGA:
    94		case NGBE_SUBID_OCP_CARD:
    95			fallthrough;
    96		default:
    97			hw->phy.type = ngbe_phy_internal;
    98			break;
    99		}
   100	
   101		if (hw->phy.type == ngbe_phy_internal ||
   102		    hw->phy.type == ngbe_phy_internal_yt8521s_sfi)
   103			hw->mac.type = ngbe_mac_type_mdi;
   104		else
   105			hw->mac.type = ngbe_mac_type_rgmii;
   106	
 > 107		hw->wol_enabled = (wol_mask == NGBE_WOL_SUP) ? 1 : 0;
   108		hw->ncsi_enabled = (ncsi_mask == NGBE_NCSI_MASK ||
   109				   type_mask == NGBE_SUBID_OCP_CARD) ? 1 : 0;
   110	
   111		switch (type_mask) {
   112		case NGBE_SUBID_LY_YT8521S_SFP:
   113		case NGBE_SUBID_LY_M88E1512_SFP:
   114		case NGBE_SUBID_YT8521S_SFP_GPIO:
   115		case NGBE_SUBID_INTERNAL_YT8521S_SFP_GPIO:
   116			hw->gpio_ctrl = 1;
   117			break;
   118		default:
   119			hw->gpio_ctrl = 0;
   120			break;
   121		}
   122	}
   123	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

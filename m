Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F466E4BCF
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 16:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjDQOr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 10:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjDQOr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 10:47:56 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83B95FE8;
        Mon, 17 Apr 2023 07:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681742875; x=1713278875;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IErMJSxlbjeVZMyODKXty2E2HhnlM8oazVPdgH+Zb2I=;
  b=LQA8sawsH+jldxdtCsze8HC3dFdRz37v5vv9eNm0MzDvFpqd9i0nrPdF
   GtS2LWQ7P+kvTOWqGRv77mtS7JatAUwVgy8IqUo+I5g8cBEr2u1WKgG5u
   IdXfX4gWktaI2k2VJxebfFwCvhmY2tFd7ZBgnvx8cATi9CPFjuVBeCFJa
   KpqoVl4Q4KzGbR6w38HZQc6KqP5Jv/XzX0c/4NU9iEjIhpakWCe3DvXen
   Rbbck7oWCmlXSWciugD19Q1hIgj9b/AxcIU284uvXur3U2lVLmVhcz2ni
   m0IAqQVCRU6AMovkV9tpj0fZturvErU4IoCJfywqYxPDaxVwXCMy2Jhcd
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="325251496"
X-IronPort-AV: E=Sophos;i="5.99,204,1677571200"; 
   d="scan'208";a="325251496"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 07:47:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="755337281"
X-IronPort-AV: E=Sophos;i="5.99,204,1677571200"; 
   d="scan'208";a="755337281"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 17 Apr 2023 07:47:51 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1poQ90-000cUd-2B;
        Mon, 17 Apr 2023 14:47:50 +0000
Date:   Mon, 17 Apr 2023 22:47:27 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
        linux@armlinux.org.uk
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: Re: [PATCH net-next v2 5/6] net: txgbe: Implement phylink pcs
Message-ID: <202304172223.PoHEDYCs-lkp@intel.com>
References: <20230411092725.104992-6-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411092725.104992-6-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiawen,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Jiawen-Wu/net-txgbe-Add-software-nodes-to-support-phylink/20230411-173314
patch link:    https://lore.kernel.org/r/20230411092725.104992-6-jiawenwu%40trustnetic.com
patch subject: [PATCH net-next v2 5/6] net: txgbe: Implement phylink pcs
config: riscv-randconfig-r042-20230417 (https://download.01.org/0day-ci/archive/20230417/202304172223.PoHEDYCs-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project 9638da200e00bd069e6dd63604e14cbafede9324)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/5903347a21d42b4f2d632e08e04890d7f638a947
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jiawen-Wu/net-txgbe-Add-software-nodes-to-support-phylink/20230411-173314
        git checkout 5903347a21d42b4f2d632e08e04890d7f638a947
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash drivers/net/ethernet/wangxun/txgbe/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304172223.PoHEDYCs-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c:269:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (interface == txgbe->interface)
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c:325:9: note: uninitialized use occurs here
           return ret;
                  ^~~
   drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c:269:2: note: remove the 'if' if its condition is always false
           if (interface == txgbe->interface)
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c:267:9: note: initialize the variable 'ret' to silence this warning
           int ret, val;
                  ^
                   = 0
   1 warning generated.


vim +269 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c

   259	
   260	static int txgbe_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
   261				    phy_interface_t interface,
   262				    const unsigned long *advertising,
   263				    bool permit_pause_to_mac)
   264	{
   265		struct txgbe *txgbe = container_of(pcs, struct txgbe, pcs);
   266		struct wx *wx = txgbe->wx;
   267		int ret, val;
   268	
 > 269		if (interface == txgbe->interface)
   270			goto out;
   271	
   272		/* Wait xpcs power-up good */
   273		ret = read_poll_timeout(pcs_read, val,
   274					(val & TXGBE_PCS_DIG_STS_PSEQ_ST) ==
   275					TXGBE_PCS_DIG_STS_PSEQ_ST_GOOD,
   276					10000, 1000000, false,
   277					txgbe, MDIO_MMD_PCS, TXGBE_PCS_DIG_STS);
   278		if (ret < 0) {
   279			wx_err(wx, "xpcs power-up timeout.\n");
   280			return ret;
   281		}
   282	
   283		/* Disable xpcs AN-73 */
   284		pcs_write(txgbe, MDIO_MMD_AN, MDIO_CTRL1, 0);
   285	
   286		/* Disable PHY MPLLA for eth mode change(after ECO) */
   287		txgbe_ephy_write(txgbe, TXGBE_SUP_DIG_MPLLA_OVRD_IN_0, 0x243A);
   288		WX_WRITE_FLUSH(wx);
   289		usleep_range(1000, 2000);
   290	
   291		/* Set the eth change_mode bit first in mis_rst register
   292		 * for corresponding LAN port
   293		 */
   294		wr32(wx, TXGBE_MIS_RST, TXGBE_MIS_RST_LAN_ETH_MODE(wx->bus.func));
   295	
   296		switch (interface) {
   297		case PHY_INTERFACE_MODE_10GBASER:
   298			txgbe_pma_config_10gbaser(txgbe);
   299			break;
   300		case PHY_INTERFACE_MODE_1000BASEX:
   301			txgbe_pma_config_1000basex(txgbe);
   302			break;
   303		default:
   304			break;
   305		}
   306	
   307		pcs_write(txgbe, MDIO_MMD_PCS, TXGBE_PCS_DIG_CTRL1,
   308			  TXGBE_PCS_DIG_CTRL1_VR_RST | TXGBE_PCS_DIG_CTRL1_EN_VSMMD1);
   309		/* wait phy initialization done */
   310		ret = read_poll_timeout(pcs_read, val,
   311					!(val & TXGBE_PCS_DIG_CTRL1_VR_RST),
   312					100000, 10000000, false,
   313					txgbe, MDIO_MMD_PCS, TXGBE_PCS_DIG_CTRL1);
   314		if (ret < 0)
   315			wx_err(wx, "PHY initialization timeout.\n");
   316	
   317		txgbe->interface = interface;
   318	
   319	out:
   320		if (interface == PHY_INTERFACE_MODE_1000BASEX) {
   321			txgbe_setup_adv(txgbe, interface, advertising);
   322			txgbe_set_an37_ability(txgbe);
   323		}
   324	
   325		return ret;
   326	}
   327	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

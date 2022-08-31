Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D253A5A73C6
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 04:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbiHaCFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 22:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiHaCFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 22:05:52 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1043758DF3;
        Tue, 30 Aug 2022 19:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661911551; x=1693447551;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cttn7y6UHHWNipIRdPvVFXvVg0LWj2i77s/Uz1a/IWk=;
  b=BzvEsG0Q2segwRAdRGwTq9/cHpkCtKs1Ql4N0PU/8pjyoGxx0z119UZZ
   38wLXwmjvAhpUyc2yvqhT0Vdm/azBJrcIhxg38XRHkttGE6LTZRrzLGGj
   DtZsiNslE6cyLeujEoaLBru5fT4yWxMBPQcbIjeFipDS76zfIwlaSmuQT
   kvpjjpgVYaX1khvIhWgfhep31r8cJUNva+3q4jhunlI41Efrne1ePuv1K
   4Mbvp3bKo4FjONm43gE+Be3L3WAEyUy4XSD8HZOVXgs+kc/Dh//W/RNse
   x10VgxlJ0a6w3jYs87Wl39sZpuhw03IFKtPSHpFVuLWgdO00Rd/vp938t
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="294092185"
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="294092185"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 19:05:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="787723001"
Received: from lkp-server02.sh.intel.com (HELO 77b6d4e16fc5) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 30 Aug 2022 19:05:46 -0700
Received: from kbuild by 77b6d4e16fc5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oTD6w-0000rn-0O;
        Wed, 31 Aug 2022 02:05:46 +0000
Date:   Wed, 31 Aug 2022 10:04:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, linux-doc@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-phy@lists.infradead.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: Re: [net-next PATCH v2] net: phy: Add 1000BASE-KX interface mode
Message-ID: <202208311035.zXZ42EG5-lkp@intel.com>
References: <20220830214241.596985-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830214241.596985-1-sean.anderson@seco.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Sean-Anderson/net-phy-Add-1000BASE-KX-interface-mode/20220831-054425
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 146ecbac1d327e7ed2153cfb3ef880166dc2b312
config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20220831/202208311035.zXZ42EG5-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/96d58b1eb1e74558860112250f067f5ff250e31f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Sean-Anderson/net-phy-Add-1000BASE-KX-interface-mode/20220831-054425
        git checkout 96d58b1eb1e74558860112250f067f5ff250e31f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh SHELL=/bin/bash drivers/net/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/phy/phy-core.c: In function 'phy_interface_num_ports':
>> drivers/net/phy/phy-core.c:86:9: warning: enumeration value 'PHY_INTERFACE_MODE_1000BASEKX' not handled in switch [-Wswitch]
      86 |         switch (interface) {
         |         ^~~~~~


vim +/PHY_INTERFACE_MODE_1000BASEKX +86 drivers/net/phy/phy-core.c

da4625ac2637e4 Russell King      2017-07-25   76  
c04ade27cb7b95 Maxime Chevallier 2022-08-17   77  /**
c04ade27cb7b95 Maxime Chevallier 2022-08-17   78   * phy_interface_num_ports - Return the number of links that can be carried by
c04ade27cb7b95 Maxime Chevallier 2022-08-17   79   *			     a given MAC-PHY physical link. Returns 0 if this is
c04ade27cb7b95 Maxime Chevallier 2022-08-17   80   *			     unknown, the number of links else.
c04ade27cb7b95 Maxime Chevallier 2022-08-17   81   *
c04ade27cb7b95 Maxime Chevallier 2022-08-17   82   * @interface: The interface mode we want to get the number of ports
c04ade27cb7b95 Maxime Chevallier 2022-08-17   83   */
c04ade27cb7b95 Maxime Chevallier 2022-08-17   84  int phy_interface_num_ports(phy_interface_t interface)
c04ade27cb7b95 Maxime Chevallier 2022-08-17   85  {
c04ade27cb7b95 Maxime Chevallier 2022-08-17  @86  	switch (interface) {
c04ade27cb7b95 Maxime Chevallier 2022-08-17   87  	case PHY_INTERFACE_MODE_NA:
c04ade27cb7b95 Maxime Chevallier 2022-08-17   88  		return 0;
c04ade27cb7b95 Maxime Chevallier 2022-08-17   89  	case PHY_INTERFACE_MODE_INTERNAL:
c04ade27cb7b95 Maxime Chevallier 2022-08-17   90  	case PHY_INTERFACE_MODE_MII:
c04ade27cb7b95 Maxime Chevallier 2022-08-17   91  	case PHY_INTERFACE_MODE_GMII:
c04ade27cb7b95 Maxime Chevallier 2022-08-17   92  	case PHY_INTERFACE_MODE_TBI:
c04ade27cb7b95 Maxime Chevallier 2022-08-17   93  	case PHY_INTERFACE_MODE_REVMII:
c04ade27cb7b95 Maxime Chevallier 2022-08-17   94  	case PHY_INTERFACE_MODE_RMII:
c04ade27cb7b95 Maxime Chevallier 2022-08-17   95  	case PHY_INTERFACE_MODE_REVRMII:
c04ade27cb7b95 Maxime Chevallier 2022-08-17   96  	case PHY_INTERFACE_MODE_RGMII:
c04ade27cb7b95 Maxime Chevallier 2022-08-17   97  	case PHY_INTERFACE_MODE_RGMII_ID:
c04ade27cb7b95 Maxime Chevallier 2022-08-17   98  	case PHY_INTERFACE_MODE_RGMII_RXID:
c04ade27cb7b95 Maxime Chevallier 2022-08-17   99  	case PHY_INTERFACE_MODE_RGMII_TXID:
c04ade27cb7b95 Maxime Chevallier 2022-08-17  100  	case PHY_INTERFACE_MODE_RTBI:
c04ade27cb7b95 Maxime Chevallier 2022-08-17  101  	case PHY_INTERFACE_MODE_XGMII:
c04ade27cb7b95 Maxime Chevallier 2022-08-17  102  	case PHY_INTERFACE_MODE_XLGMII:
c04ade27cb7b95 Maxime Chevallier 2022-08-17  103  	case PHY_INTERFACE_MODE_MOCA:
c04ade27cb7b95 Maxime Chevallier 2022-08-17  104  	case PHY_INTERFACE_MODE_TRGMII:
c04ade27cb7b95 Maxime Chevallier 2022-08-17  105  	case PHY_INTERFACE_MODE_USXGMII:
c04ade27cb7b95 Maxime Chevallier 2022-08-17  106  	case PHY_INTERFACE_MODE_SGMII:
c04ade27cb7b95 Maxime Chevallier 2022-08-17  107  	case PHY_INTERFACE_MODE_SMII:
c04ade27cb7b95 Maxime Chevallier 2022-08-17  108  	case PHY_INTERFACE_MODE_1000BASEX:
c04ade27cb7b95 Maxime Chevallier 2022-08-17  109  	case PHY_INTERFACE_MODE_2500BASEX:
c04ade27cb7b95 Maxime Chevallier 2022-08-17  110  	case PHY_INTERFACE_MODE_5GBASER:
c04ade27cb7b95 Maxime Chevallier 2022-08-17  111  	case PHY_INTERFACE_MODE_10GBASER:
c04ade27cb7b95 Maxime Chevallier 2022-08-17  112  	case PHY_INTERFACE_MODE_25GBASER:
c04ade27cb7b95 Maxime Chevallier 2022-08-17  113  	case PHY_INTERFACE_MODE_10GKR:
c04ade27cb7b95 Maxime Chevallier 2022-08-17  114  	case PHY_INTERFACE_MODE_100BASEX:
c04ade27cb7b95 Maxime Chevallier 2022-08-17  115  	case PHY_INTERFACE_MODE_RXAUI:
c04ade27cb7b95 Maxime Chevallier 2022-08-17  116  	case PHY_INTERFACE_MODE_XAUI:
c04ade27cb7b95 Maxime Chevallier 2022-08-17  117  		return 1;
c04ade27cb7b95 Maxime Chevallier 2022-08-17  118  	case PHY_INTERFACE_MODE_QSGMII:
c04ade27cb7b95 Maxime Chevallier 2022-08-17  119  	case PHY_INTERFACE_MODE_QUSGMII:
c04ade27cb7b95 Maxime Chevallier 2022-08-17  120  		return 4;
c04ade27cb7b95 Maxime Chevallier 2022-08-17  121  	case PHY_INTERFACE_MODE_MAX:
c04ade27cb7b95 Maxime Chevallier 2022-08-17  122  		WARN_ONCE(1, "PHY_INTERFACE_MODE_MAX isn't a valid interface mode");
c04ade27cb7b95 Maxime Chevallier 2022-08-17  123  		return 0;
c04ade27cb7b95 Maxime Chevallier 2022-08-17  124  	}
c04ade27cb7b95 Maxime Chevallier 2022-08-17  125  	return 0;
c04ade27cb7b95 Maxime Chevallier 2022-08-17  126  }
c04ade27cb7b95 Maxime Chevallier 2022-08-17  127  EXPORT_SYMBOL_GPL(phy_interface_num_ports);
c04ade27cb7b95 Maxime Chevallier 2022-08-17  128  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

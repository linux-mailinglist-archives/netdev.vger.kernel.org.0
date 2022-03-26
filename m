Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120944E7E85
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 03:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiCZCXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 22:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiCZCXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 22:23:51 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F5D148642;
        Fri, 25 Mar 2022 19:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648261335; x=1679797335;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=8JUqHs5t+dHXAq9hp5/Tp/GSsj948ANluTlXzjh6cbg=;
  b=MIAXVB71dJMCWXAb21neW5R14VIuXG7UOGZL4mNhm4o6t1ZbXIt6Qu2Z
   pQk8eVKfHpDLCS2L2jVMtj6LBMRohuhrxeQEyD7sGBiXViEC5HS6dXtn/
   PJwdNC4Kc3+tx481/oIgTsEdL6UgPgWhFCelB1huIeyzuuMGyeIfuIsuz
   g7BtHlhjBJAMXbuNOGU/fecHTaNL+rmC01mI8opZgIRecECmyaj48XxhQ
   54KYXa5pcAEl+RFtaTGHk4kRctbR1ENVz95tDGBnVaJuvCDTUD9ePyrFL
   sQ7PX1JKMn06Zk0G2ClRfreBtZ5d5zwCKYyBThHf3lmV2OaKi1tS6aOk8
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10297"; a="257580520"
X-IronPort-AV: E=Sophos;i="5.90,211,1643702400"; 
   d="scan'208";a="257580520"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2022 19:22:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,211,1643702400"; 
   d="scan'208";a="562051549"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 25 Mar 2022 19:22:11 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nXw4A-000Mti-87; Sat, 26 Mar 2022 02:22:10 +0000
Date:   Sat, 26 Mar 2022 10:21:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Allan Nielsen <allan.nielsen@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Subject: Re: [net-next 5/5] net: mdio: mscc-miim: use
 fwnode_mdiobus_register()
Message-ID: <202203261006.uZruvRKb-lkp@intel.com>
References: <20220325172234.1259667-6-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220325172234.1259667-6-clement.leger@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi "Clément,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Cl-ment-L-ger/net-mdio-fwnode-add-fwnode_mdiobus_register/20220326-040146
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 89695196f0ba78a17453f9616355f2ca6b293402
config: riscv-randconfig-r003-20220325 (https://download.01.org/0day-ci/archive/20220326/202203261006.uZruvRKb-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 0f6d9501cf49ce02937099350d08f20c4af86f3d)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/0day-ci/linux/commit/24673ffe7514a73903a3bc49585846bce1de8748
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Cl-ment-L-ger/net-mdio-fwnode-add-fwnode_mdiobus_register/20220326-040146
        git checkout 24673ffe7514a73903a3bc49585846bce1de8748
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash drivers/net/mdio/ fs/gfs2/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from drivers/net/mdio/mdio-mscc-miim.c:10:
>> include/linux/fwnode_mdio.h:27:5: warning: no previous prototype for function 'fwnode_mdiobus_phy_device_register' [-Wmissing-prototypes]
   int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
       ^
   include/linux/fwnode_mdio.h:27:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
   ^
   static 
   1 warning generated.


vim +/fwnode_mdiobus_phy_device_register +27 include/linux/fwnode_mdio.h

8ed21cbab4f71b Clément Léger  2022-03-25  26  
bc1bee3b87ee48 Calvin Johnson 2021-06-11 @27  int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
bc1bee3b87ee48 Calvin Johnson 2021-06-11  28  				       struct phy_device *phy,
bc1bee3b87ee48 Calvin Johnson 2021-06-11  29  				       struct fwnode_handle *child, u32 addr)
bc1bee3b87ee48 Calvin Johnson 2021-06-11  30  {
bc1bee3b87ee48 Calvin Johnson 2021-06-11  31  	return -EINVAL;
bc1bee3b87ee48 Calvin Johnson 2021-06-11  32  }
bc1bee3b87ee48 Calvin Johnson 2021-06-11  33  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

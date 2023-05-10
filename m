Return-Path: <netdev+bounces-1408-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99F056FDB1C
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:53:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31C15281370
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:53:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1D666D22;
	Wed, 10 May 2023 09:53:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDE220B41
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:53:31 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4E759C3;
	Wed, 10 May 2023 02:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683712408; x=1715248408;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vvkolml/HN19Sg1F836qmjywFOfBzb5v/yoO63FWOBE=;
  b=JDDdTlECIXzwa7WJF8Bg2sCKhdmDfszGbx4NrV29PRgjuU+CNfF7Ud84
   hKt5laqyNRaT9leCsXzbbjZZh8D8vCkcIkr2eVIg+zQR5QxNuo4l2rB3N
   k1I2lKwXYUA9r5fD7EYuQfhRfmRFudMSn7o1I6vLB7usNZ/J246838TvA
   w5XojvlUL/8rRoTE6Fk9fNYNEKyl/JlQljUf76xdgzGb31KYR/QzYcURI
   oAP2PYJRhHFQdgQafwkZ9gayi7jLq8kwd9WF6TmY14mh69t7fDvpjd7/t
   hST72Sr6g2K4paeK2mI3441Tro6FojlfOw32mOWlLRMmWcBOEW/g6stj5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="413469508"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="413469508"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 02:53:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="729884460"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="729884460"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 10 May 2023 02:53:25 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1pwgVg-00037S-0c;
	Wed, 10 May 2023 09:53:24 +0000
Date: Wed, 10 May 2023 17:52:45 +0800
From: kernel test robot <lkp@intel.com>
To: Yan Wang <rk.code@outlook.com>, andrew@lunn.ch, hkallweit1@gmail.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux@armlinux.org.uk
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Yan Wang <rk.code@outlook.com>
Subject: Re: [PATCH v3] net: mdiobus: Add a function to deassert reset
Message-ID: <202305101702.4xW6vT72-lkp@intel.com>
References: <KL1PR01MB5448A33A549CDAD7D68945B9E6779@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <KL1PR01MB5448A33A549CDAD7D68945B9E6779@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Yan,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]
[also build test ERROR on net/main linus/master v6.4-rc1 next-20230510]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yan-Wang/net-mdiobus-Add-a-function-to-deassert-reset/20230510-161736
base:   net-next/main
patch link:    https://lore.kernel.org/r/KL1PR01MB5448A33A549CDAD7D68945B9E6779%40KL1PR01MB5448.apcprd01.prod.exchangelabs.com
patch subject: [PATCH v3] net: mdiobus: Add a function to deassert reset
config: hexagon-randconfig-r045-20230509 (https://download.01.org/0day-ci/archive/20230510/202305101702.4xW6vT72-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project b0fb98227c90adf2536c9ad644a74d5e92961111)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/f7ded94d887d1020adb4813c2b1025142288e882
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yan-Wang/net-mdiobus-Add-a-function-to-deassert-reset/20230510-161736
        git checkout f7ded94d887d1020adb4813c2b1025142288e882
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/net/mdio/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305101702.4xW6vT72-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/net/mdio/fwnode_mdio.c:10:
   In file included from include/linux/fwnode_mdio.h:9:
   In file included from include/linux/phy.h:16:
   In file included from include/linux/ethtool.h:18:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
                                                     ^
   In file included from drivers/net/mdio/fwnode_mdio.c:10:
   In file included from include/linux/fwnode_mdio.h:9:
   In file included from include/linux/phy.h:16:
   In file included from include/linux/ethtool.h:18:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
                                                     ^
   In file included from drivers/net/mdio/fwnode_mdio.c:10:
   In file included from include/linux/fwnode_mdio.h:9:
   In file included from include/linux/phy.h:16:
   In file included from include/linux/ethtool.h:18:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
>> drivers/net/mdio/fwnode_mdio.c:64:10: error: call to undeclared function 'fwnode_gpiod_get_index'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           reset = fwnode_gpiod_get_index(fwnode, "reset", 0, GPIOD_OUT_HIGH, NULL);
                   ^
>> drivers/net/mdio/fwnode_mdio.c:64:53: error: use of undeclared identifier 'GPIOD_OUT_HIGH'
           reset = fwnode_gpiod_get_index(fwnode, "reset", 0, GPIOD_OUT_HIGH, NULL);
                                                              ^
>> drivers/net/mdio/fwnode_mdio.c:69:2: error: call to undeclared function 'gpiod_set_value_cansleep'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           gpiod_set_value_cansleep(reset, 0);
           ^
>> drivers/net/mdio/fwnode_mdio.c:71:2: error: call to undeclared function 'gpiod_put'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           gpiod_put(reset);
           ^
   6 warnings and 4 errors generated.


vim +/fwnode_gpiod_get_index +64 drivers/net/mdio/fwnode_mdio.c

    59	
    60	static void fwnode_mdiobus_pre_enable_phy(struct fwnode_handle *fwnode)
    61	{
    62		struct gpio_desc *reset;
    63	
  > 64		reset = fwnode_gpiod_get_index(fwnode, "reset", 0, GPIOD_OUT_HIGH, NULL);
    65		if (IS_ERR(reset) && PTR_ERR(reset) != -EPROBE_DEFER)
    66			return;
    67	
    68		usleep_range(100, 200);
  > 69		gpiod_set_value_cansleep(reset, 0);
    70		/*Release the reset pin,it needs to be registered with the PHY.*/
  > 71		gpiod_put(reset);
    72	}
    73	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests


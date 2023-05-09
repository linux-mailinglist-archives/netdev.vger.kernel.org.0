Return-Path: <netdev+bounces-1098-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 175116FC2B7
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:26:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 403A11C20919
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:25:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFEDEAD35;
	Tue,  9 May 2023 09:25:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8CE8839
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 09:25:57 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCC7199F;
	Tue,  9 May 2023 02:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683624355; x=1715160355;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZUjtGLtCp5bmDtgxpBnRsLLbwrRUEv9l+1hvqKxDfhM=;
  b=jiakkmrm8p3f5JO/BwMlC+DbsugIGTigoTy9/J5COLQ4bUBVWwxGATxq
   3jmvWItY249Dcw7AMSemyKKZ7OqI3z2XfntwOOpWHK+7Pr6T2vINVERF3
   TtTg4dATHIJ/q7UiFlefehblLjDw1gVBTu/FQdsiGt6pKXbiYyqWikkBc
   ffBBh9THl68oKEXbw6oZpb7d4OOoj7zRb1ZB+wIJH9Y85eSQcGvtXQtV4
   ioBJHcWjNqWTnFHdteje1wt325sWFekQjtwAStyDslj5cp5lyoG1LG5J8
   NnJNqdr1C18Gq+xCeltSk6dRyKJOote1g4cydeAH9nw4U5X13Yq4Sfiyt
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="352035491"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="352035491"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 02:25:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="729425778"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="729425778"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 09 May 2023 02:25:51 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1pwJbS-00020s-1V;
	Tue, 09 May 2023 09:25:50 +0000
Date: Tue, 9 May 2023 17:25:21 +0800
From: kernel test robot <lkp@intel.com>
To: Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Doug Berger <opendmb@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
	Peter Geis <pgwipeout@gmail.com>, Frank <Frank.Sae@motor-comm.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: phy: broadcom: Add support for
 Wake-on-LAN
Message-ID: <202305091725.uiFVrVZR-lkp@intel.com>
References: <20230508184309.1628108-3-f.fainelli@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508184309.1628108-3-f.fainelli@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Florian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Florian-Fainelli/net-phy-Let-drivers-check-Wake-on-LAN-status/20230509-024405
base:   net-next/main
patch link:    https://lore.kernel.org/r/20230508184309.1628108-3-f.fainelli%40gmail.com
patch subject: [PATCH net-next 2/3] net: phy: broadcom: Add support for Wake-on-LAN
config: s390-randconfig-r036-20230508 (https://download.01.org/0day-ci/archive/20230509/202305091725.uiFVrVZR-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project b0fb98227c90adf2536c9ad644a74d5e92961111)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/9bc5e73961748471e3dae79cb94f329382a6d490
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Florian-Fainelli/net-phy-Let-drivers-check-Wake-on-LAN-status/20230509-024405
        git checkout 9bc5e73961748471e3dae79cb94f329382a6d490
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash drivers/net/phy/ kernel/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305091725.uiFVrVZR-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/net/phy/broadcom.c:13:
   In file included from drivers/net/phy/bcm-phy-lib.h:9:
   In file included from include/linux/brcmphy.h:5:
   In file included from include/linux/phy.h:16:
   In file included from include/linux/ethtool.h:18:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:37:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
   #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
                                                        ^
   In file included from drivers/net/phy/broadcom.c:13:
   In file included from drivers/net/phy/bcm-phy-lib.h:9:
   In file included from include/linux/brcmphy.h:5:
   In file included from include/linux/phy.h:16:
   In file included from include/linux/ethtool.h:18:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:35:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   In file included from drivers/net/phy/broadcom.c:13:
   In file included from drivers/net/phy/bcm-phy-lib.h:9:
   In file included from include/linux/brcmphy.h:5:
   In file included from include/linux/phy.h:16:
   In file included from include/linux/ethtool.h:18:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:692:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsb(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:700:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsw(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:708:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsl(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:717:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesb(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:726:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesw(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:735:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesl(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
>> drivers/net/phy/broadcom.c:471:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
           if (priv->wake_irq_enabled != state) {
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/phy/broadcom.c:479:9: note: uninitialized use occurs here
           return ret;
                  ^~~
   drivers/net/phy/broadcom.c:471:2: note: remove the 'if' if its condition is always true
           if (priv->wake_irq_enabled != state) {
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/phy/broadcom.c:466:9: note: initialize the variable 'ret' to silence this warning
           int ret;
                  ^
                   = 0
   13 warnings generated.


vim +471 drivers/net/phy/broadcom.c

   462	
   463	static int bcm54xx_set_wakeup_irq(struct phy_device *phydev, bool state)
   464	{
   465		struct bcm54xx_phy_priv *priv = phydev->priv;
   466		int ret;
   467	
   468		if (!bcm54xx_phy_can_wakeup(phydev))
   469			return 0;
   470	
 > 471		if (priv->wake_irq_enabled != state) {
   472			if (state)
   473				ret = enable_irq_wake(priv->wake_irq);
   474			else
   475				ret = disable_irq_wake(priv->wake_irq);
   476			priv->wake_irq_enabled = state;
   477		}
   478	
   479		return ret;
   480	}
   481	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests


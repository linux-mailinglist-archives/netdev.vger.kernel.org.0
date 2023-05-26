Return-Path: <netdev+bounces-5655-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F381712583
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:31:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4C6B281727
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:31:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 095B1742F3;
	Fri, 26 May 2023 11:31:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCB7742D9
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 11:31:50 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC4B12F;
	Fri, 26 May 2023 04:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685100708; x=1716636708;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=lKFISDoOGT/vHV9uu2T/75vdvXK9iJgFX6rs9G33zhw=;
  b=XFEZ5CPmuNOL8on0NN3jFSq/X22BuZLz/MA3X3oHMzCE6Xk78YLC/Pac
   opjIMUqm24+q6s70UQ8rPFv2qMm/QsCH5IHEjrbk+F7wE1OUqdbDf2Xfb
   hi3s1wrMm2/d9cG2B/FCNTSUZwmZ4j5noCKL8oP/5S9q331wOfs7daKKQ
   UH3ZYRZsQqigBkWZy2yLaNFWla4jEWP2GK6T0MLTVS+BuWiYX/GIDOWxv
   HFzTbk1qhtD8Ufmp7HkS5Ct1xzRRTxp6PM9/TmNpquPdIni6YhuZy3kkD
   pP52L/PLwAAsw4yr0CGeAkxPAOH5VC2r8DKfLHBtPp8EtIRO2MBA2O128
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="440536170"
X-IronPort-AV: E=Sophos;i="6.00,194,1681196400"; 
   d="scan'208";a="440536170"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 04:31:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="738218505"
X-IronPort-AV: E=Sophos;i="6.00,194,1681196400"; 
   d="scan'208";a="738218505"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 26 May 2023 04:31:28 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q2VfL-000JIC-1U;
	Fri, 26 May 2023 11:31:27 +0000
Date: Fri, 26 May 2023 19:30:45 +0800
From: kernel test robot <lkp@intel.com>
To: Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
	jarkko.nikula@linux.intel.com, andriy.shevchenko@linux.intel.com,
	mika.westerberg@linux.intel.com, jsd@semihalf.com,
	Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
	linux@armlinux.org.uk
Cc: oe-kbuild-all@lists.linux.dev, linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Piotr Raczynski <piotr.raczynski@intel.com>
Subject: Re: [PATCH net-next v9 5/9] net: txgbe: Add SFP module identify
Message-ID: <202305261959.mnGUW17n-lkp@intel.com>
References: <20230524091722.522118-6-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230524091722.522118-6-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jiawen,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Jiawen-Wu/net-txgbe-Add-software-nodes-to-support-phylink/20230524-173221
base:   net-next/main
patch link:    https://lore.kernel.org/r/20230524091722.522118-6-jiawenwu%40trustnetic.com
patch subject: [PATCH net-next v9 5/9] net: txgbe: Add SFP module identify
config: csky-randconfig-r003-20230525 (https://download.01.org/0day-ci/archive/20230526/202305261959.mnGUW17n-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/c382745a6443e8ff9b3fab9b10c90b216b2ca59b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jiawen-Wu/net-txgbe-Add-software-nodes-to-support-phylink/20230524-173221
        git checkout c382745a6443e8ff9b3fab9b10c90b216b2ca59b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 ~/bin/make.cross W=1 O=build_dir ARCH=csky olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 ~/bin/make.cross W=1 O=build_dir ARCH=csky SHELL=/bin/bash drivers/net/phy/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202305261959.mnGUW17n-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/net/phy/sfp.c: In function 'sfp_i2c_read':
>> drivers/net/phy/sfp.c:609:23: error: implicit declaration of function 'i2c_transfer' [-Werror=implicit-function-declaration]
     609 |                 ret = i2c_transfer(sfp->i2c, msgs, ARRAY_SIZE(msgs));
         |                       ^~~~~~~~~~~~
   drivers/net/phy/sfp.c: In function 'sfp_i2c_configure':
>> drivers/net/phy/sfp.c:653:14: error: implicit declaration of function 'i2c_check_functionality' [-Werror=implicit-function-declaration]
     653 |         if (!i2c_check_functionality(i2c, I2C_FUNC_I2C))
         |              ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/phy/sfp.c: In function 'sfp_cleanup':
>> drivers/net/phy/sfp.c:2919:17: error: implicit declaration of function 'i2c_put_adapter' [-Werror=implicit-function-declaration]
    2919 |                 i2c_put_adapter(sfp->i2c);
         |                 ^~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for I2C_DESIGNWARE_PLATFORM
   Depends on [n]: I2C [=n] && HAS_IOMEM [=y] && (ACPI && COMMON_CLK [=y] || !ACPI)
   Selected by [y]:
   - TXGBE [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_WANGXUN [=y] && PCI [=y]
   WARNING: unmet direct dependencies detected for SFP
   Depends on [n]: NETDEVICES [=y] && PHYLIB [=y] && I2C [=n] && PHYLINK [=y] && (HWMON [=n] || HWMON [=n]=n)
   Selected by [y]:
   - TXGBE [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_WANGXUN [=y] && PCI [=y]


vim +/i2c_transfer +609 drivers/net/phy/sfp.c

73970055450eeb Russell King  2017-07-25  583  
3bb35261c74e39 Jon Nettleton 2018-02-27  584  static int sfp_i2c_read(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
3bb35261c74e39 Jon Nettleton 2018-02-27  585  			size_t len)
73970055450eeb Russell King  2017-07-25  586  {
73970055450eeb Russell King  2017-07-25  587  	struct i2c_msg msgs[2];
426c6cbc409cbd Pali Rohár    2021-01-25  588  	u8 bus_addr = a2 ? 0x51 : 0x50;
426c6cbc409cbd Pali Rohár    2021-01-25  589  	size_t block_size = sfp->i2c_block_size;
28e74a7cfd6403 Russell King  2019-06-02  590  	size_t this_len;
73970055450eeb Russell King  2017-07-25  591  	int ret;
73970055450eeb Russell King  2017-07-25  592  
73970055450eeb Russell King  2017-07-25  593  	msgs[0].addr = bus_addr;
73970055450eeb Russell King  2017-07-25  594  	msgs[0].flags = 0;
73970055450eeb Russell King  2017-07-25  595  	msgs[0].len = 1;
73970055450eeb Russell King  2017-07-25  596  	msgs[0].buf = &dev_addr;
73970055450eeb Russell King  2017-07-25  597  	msgs[1].addr = bus_addr;
73970055450eeb Russell King  2017-07-25  598  	msgs[1].flags = I2C_M_RD;
73970055450eeb Russell King  2017-07-25  599  	msgs[1].len = len;
73970055450eeb Russell King  2017-07-25  600  	msgs[1].buf = buf;
73970055450eeb Russell King  2017-07-25  601  
28e74a7cfd6403 Russell King  2019-06-02  602  	while (len) {
28e74a7cfd6403 Russell King  2019-06-02  603  		this_len = len;
0d035bed2a4a6c Russell King  2020-12-09  604  		if (this_len > block_size)
0d035bed2a4a6c Russell King  2020-12-09  605  			this_len = block_size;
28e74a7cfd6403 Russell King  2019-06-02  606  
28e74a7cfd6403 Russell King  2019-06-02  607  		msgs[1].len = this_len;
28e74a7cfd6403 Russell King  2019-06-02  608  
3bb35261c74e39 Jon Nettleton 2018-02-27 @609  		ret = i2c_transfer(sfp->i2c, msgs, ARRAY_SIZE(msgs));
73970055450eeb Russell King  2017-07-25  610  		if (ret < 0)
73970055450eeb Russell King  2017-07-25  611  			return ret;
73970055450eeb Russell King  2017-07-25  612  
28e74a7cfd6403 Russell King  2019-06-02  613  		if (ret != ARRAY_SIZE(msgs))
28e74a7cfd6403 Russell King  2019-06-02  614  			break;
28e74a7cfd6403 Russell King  2019-06-02  615  
28e74a7cfd6403 Russell King  2019-06-02  616  		msgs[1].buf += this_len;
28e74a7cfd6403 Russell King  2019-06-02  617  		dev_addr += this_len;
28e74a7cfd6403 Russell King  2019-06-02  618  		len -= this_len;
28e74a7cfd6403 Russell King  2019-06-02  619  	}
28e74a7cfd6403 Russell King  2019-06-02  620  
28e74a7cfd6403 Russell King  2019-06-02  621  	return msgs[1].buf - (u8 *)buf;
73970055450eeb Russell King  2017-07-25  622  }
73970055450eeb Russell King  2017-07-25  623  
3bb35261c74e39 Jon Nettleton 2018-02-27  624  static int sfp_i2c_write(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
73970055450eeb Russell King  2017-07-25  625  	size_t len)
73970055450eeb Russell King  2017-07-25  626  {
3bb35261c74e39 Jon Nettleton 2018-02-27  627  	struct i2c_msg msgs[1];
3bb35261c74e39 Jon Nettleton 2018-02-27  628  	u8 bus_addr = a2 ? 0x51 : 0x50;
3bb35261c74e39 Jon Nettleton 2018-02-27  629  	int ret;
3bb35261c74e39 Jon Nettleton 2018-02-27  630  
3bb35261c74e39 Jon Nettleton 2018-02-27  631  	msgs[0].addr = bus_addr;
3bb35261c74e39 Jon Nettleton 2018-02-27  632  	msgs[0].flags = 0;
3bb35261c74e39 Jon Nettleton 2018-02-27  633  	msgs[0].len = 1 + len;
3bb35261c74e39 Jon Nettleton 2018-02-27  634  	msgs[0].buf = kmalloc(1 + len, GFP_KERNEL);
3bb35261c74e39 Jon Nettleton 2018-02-27  635  	if (!msgs[0].buf)
3bb35261c74e39 Jon Nettleton 2018-02-27  636  		return -ENOMEM;
3bb35261c74e39 Jon Nettleton 2018-02-27  637  
3bb35261c74e39 Jon Nettleton 2018-02-27  638  	msgs[0].buf[0] = dev_addr;
3bb35261c74e39 Jon Nettleton 2018-02-27  639  	memcpy(&msgs[0].buf[1], buf, len);
3bb35261c74e39 Jon Nettleton 2018-02-27  640  
3bb35261c74e39 Jon Nettleton 2018-02-27  641  	ret = i2c_transfer(sfp->i2c, msgs, ARRAY_SIZE(msgs));
3bb35261c74e39 Jon Nettleton 2018-02-27  642  
3bb35261c74e39 Jon Nettleton 2018-02-27  643  	kfree(msgs[0].buf);
3bb35261c74e39 Jon Nettleton 2018-02-27  644  
3bb35261c74e39 Jon Nettleton 2018-02-27  645  	if (ret < 0)
3bb35261c74e39 Jon Nettleton 2018-02-27  646  		return ret;
3bb35261c74e39 Jon Nettleton 2018-02-27  647  
3bb35261c74e39 Jon Nettleton 2018-02-27  648  	return ret == ARRAY_SIZE(msgs) ? len : 0;
73970055450eeb Russell King  2017-07-25  649  }
73970055450eeb Russell King  2017-07-25  650  
73970055450eeb Russell King  2017-07-25  651  static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
73970055450eeb Russell King  2017-07-25  652  {
73970055450eeb Russell King  2017-07-25 @653  	if (!i2c_check_functionality(i2c, I2C_FUNC_I2C))
73970055450eeb Russell King  2017-07-25  654  		return -EINVAL;
73970055450eeb Russell King  2017-07-25  655  
73970055450eeb Russell King  2017-07-25  656  	sfp->i2c = i2c;
73970055450eeb Russell King  2017-07-25  657  	sfp->read = sfp_i2c_read;
3bb35261c74e39 Jon Nettleton 2018-02-27  658  	sfp->write = sfp_i2c_write;
73970055450eeb Russell King  2017-07-25  659  
e85b1347ace677 Marek Behún   2022-09-30  660  	return 0;
e85b1347ace677 Marek Behún   2022-09-30  661  }
e85b1347ace677 Marek Behún   2022-09-30  662  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


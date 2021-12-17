Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD6347832E
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 03:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhLQCbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 21:31:38 -0500
Received: from mga05.intel.com ([192.55.52.43]:43405 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229471AbhLQCbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 21:31:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639708298; x=1671244298;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SPypHMHAv9NaHp5G6efoBQHfOLQ9Dr8bZYaNjglAphk=;
  b=VpvpkhccMGCZZuQcLr28cJA15mEv9Cmjl4O1pb2eo5XUoWyGwYLDkMOw
   g/wM6Qy1I9P4lf4tfetkDH4Dv7S4xwaz3c8M/y41DRfVmdzvu1sIseesQ
   5G8U/M/tSvTucZc9QFNDbpFR1MPQLGpyKoldhjyvYBQxEGUQjviRDG8d1
   m2/F6oiKPBQmoSVNoNUxVuX/r/odEnOABuKeARlls5awYgxfD/rLoJR/0
   K7Z2imR6namleuRVdrEsgycrqyXcVxm3mwXKtTaHPPzJhJEXM3R5/HUXV
   quN/Im1o4mmayaTJWuYCyXxxYYOn2PBG1m1Odt9vpiS3JPJJxmLpEzLU+
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="325947193"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="325947193"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 18:31:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="615403609"
Received: from lkp-server02.sh.intel.com (HELO 9f38c0981d9f) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 16 Dec 2021 18:31:34 -0800
Received: from kbuild by 9f38c0981d9f with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1my31x-000477-Pm; Fri, 17 Dec 2021 02:31:33 +0000
Date:   Fri, 17 Dec 2021 10:31:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     luizluca@gmail.com, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: Re: [PATCH net-next 04/13] net: dsa: realtek: convert subdrivers
 into modules
Message-ID: <202112171017.KRgToQQ1-lkp@intel.com>
References: <20211216201342.25587-5-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216201342.25587-5-luizluca@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/luizluca-gmail-com/net-dsa-realtek-MDIO-interface-and-RTL8367S/20211217-041735
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 0f473bb6ed2d0b8533a079ee133f625f83de5315
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20211217/202112171017.KRgToQQ1-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/4bbfd185490b3b2fcc4e90a63d3137a812f03057
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review luizluca-gmail-com/net-dsa-realtek-MDIO-interface-and-RTL8367S/20211217-041735
        git checkout 4bbfd185490b3b2fcc4e90a63d3137a812f03057
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arc SHELL=/bin/bash drivers/net/dsa/realtek/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/dsa/realtek/realtek-smi.c:295:5: warning: no previous prototype for 'realtek_smi_write_reg_noack' [-Wmissing-prototypes]
     295 | int realtek_smi_write_reg_noack(struct realtek_priv *priv, u32 addr,
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/dsa/realtek/realtek-smi.c:344:5: warning: no previous prototype for 'realtek_smi_setup_mdio' [-Wmissing-prototypes]
     344 | int realtek_smi_setup_mdio(struct dsa_switch *ds)
         |     ^~~~~~~~~~~~~~~~~~~~~~


vim +/realtek_smi_write_reg_noack +295 drivers/net/dsa/realtek/realtek-smi.c

d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  290  
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  291  /* There is one single case when we need to use this accessor and that
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  292   * is when issueing soft reset. Since the device reset as soon as we write
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  293   * that bit, no ACK will come back for natural reasons.
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  294   */
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16 @295  int realtek_smi_write_reg_noack(struct realtek_priv *priv, u32 addr,
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  296  				u32 data)
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  297  {
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  298  	return realtek_smi_write_reg(priv, addr, data, false);
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  299  }
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  300  
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  301  /* Regmap accessors */
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  302  
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  303  static int realtek_smi_write(void *ctx, u32 reg, u32 val)
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  304  {
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  305  	struct realtek_priv *priv = ctx;
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  306  
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  307  	return realtek_smi_write_reg(priv, reg, val, true);
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  308  }
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  309  
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  310  static int realtek_smi_read(void *ctx, u32 reg, u32 *val)
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  311  {
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  312  	struct realtek_priv *priv = ctx;
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  313  
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  314  	return realtek_smi_read_reg(priv, reg, val);
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  315  }
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  316  
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  317  static const struct regmap_config realtek_smi_mdio_regmap_config = {
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  318  	.reg_bits = 10, /* A4..A0 R4..R0 */
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  319  	.val_bits = 16,
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  320  	.reg_stride = 1,
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  321  	/* PHY regs are at 0x8000 */
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  322  	.max_register = 0xffff,
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  323  	.reg_format_endian = REGMAP_ENDIAN_BIG,
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  324  	.reg_read = realtek_smi_read,
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  325  	.reg_write = realtek_smi_write,
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  326  	.cache_type = REGCACHE_NONE,
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  327  };
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  328  
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  329  static int realtek_smi_mdio_read(struct mii_bus *bus, int addr, int regnum)
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  330  {
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  331  	struct realtek_priv *priv = bus->priv;
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  332  
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  333  	return priv->ops->phy_read(priv, addr, regnum);
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  334  }
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  335  
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  336  static int realtek_smi_mdio_write(struct mii_bus *bus, int addr, int regnum,
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  337  				  u16 val)
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  338  {
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  339  	struct realtek_priv *priv = bus->priv;
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  340  
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  341  	return priv->ops->phy_write(priv, addr, regnum, val);
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  342  }
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  343  
4bbfd185490b3b drivers/net/dsa/realtek/realtek-smi.c      Luiz Angelo Daros de Luca 2021-12-16 @344  int realtek_smi_setup_mdio(struct dsa_switch *ds)
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  345  {
4bbfd185490b3b drivers/net/dsa/realtek/realtek-smi.c      Luiz Angelo Daros de Luca 2021-12-16  346  	struct realtek_priv *priv =  (struct realtek_priv *)ds->priv;
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  347  	struct device_node *mdio_np;
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  348  	int ret;
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  349  
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  350  	mdio_np = of_get_compatible_child(priv->dev->of_node, "realtek,smi-mdio");
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  351  	if (!mdio_np) {
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  352  		dev_err(priv->dev, "no MDIO bus node\n");
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  353  		return -ENODEV;
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  354  	}
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  355  
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  356  	priv->slave_mii_bus = devm_mdiobus_alloc(priv->dev);
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  357  	if (!priv->slave_mii_bus) {
3f1bb6abdf19cf drivers/net/dsa/realtek-smi.c              Johan Hovold              2019-01-16  358  		ret = -ENOMEM;
3f1bb6abdf19cf drivers/net/dsa/realtek-smi.c              Johan Hovold              2019-01-16  359  		goto err_put_node;
3f1bb6abdf19cf drivers/net/dsa/realtek-smi.c              Johan Hovold              2019-01-16  360  	}
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  361  	priv->slave_mii_bus->priv = priv;
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  362  	priv->slave_mii_bus->name = "SMI slave MII";
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  363  	priv->slave_mii_bus->read = realtek_smi_mdio_read;
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  364  	priv->slave_mii_bus->write = realtek_smi_mdio_write;
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  365  	snprintf(priv->slave_mii_bus->id, MII_BUS_ID_SIZE, "SMI-%d",
4bbfd185490b3b drivers/net/dsa/realtek/realtek-smi.c      Luiz Angelo Daros de Luca 2021-12-16  366  		 ds->index);
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  367  	priv->slave_mii_bus->dev.of_node = mdio_np;
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  368  	priv->slave_mii_bus->parent = priv->dev;
4bbfd185490b3b drivers/net/dsa/realtek/realtek-smi.c      Luiz Angelo Daros de Luca 2021-12-16  369  	ds->slave_mii_bus = priv->slave_mii_bus;
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  370  
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  371  	ret = devm_of_mdiobus_register(priv->dev, priv->slave_mii_bus, mdio_np);
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  372  	if (ret) {
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  373  		dev_err(priv->dev, "unable to register MDIO bus %s\n",
4b42215ee71c0f drivers/net/dsa/realtek/realtek-smi-core.c Luiz Angelo Daros de Luca 2021-12-16  374  			priv->slave_mii_bus->id);
3f1bb6abdf19cf drivers/net/dsa/realtek-smi.c              Johan Hovold              2019-01-16  375  		goto err_put_node;
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  376  	}
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  377  
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  378  	return 0;
3f1bb6abdf19cf drivers/net/dsa/realtek-smi.c              Johan Hovold              2019-01-16  379  
3f1bb6abdf19cf drivers/net/dsa/realtek-smi.c              Johan Hovold              2019-01-16  380  err_put_node:
3f1bb6abdf19cf drivers/net/dsa/realtek-smi.c              Johan Hovold              2019-01-16  381  	of_node_put(mdio_np);
3f1bb6abdf19cf drivers/net/dsa/realtek-smi.c              Johan Hovold              2019-01-16  382  
3f1bb6abdf19cf drivers/net/dsa/realtek-smi.c              Johan Hovold              2019-01-16  383  	return ret;
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  384  }
d8652956cf37c5 drivers/net/dsa/realtek-smi.c              Linus Walleij             2018-07-14  385  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

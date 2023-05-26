Return-Path: <netdev+bounces-5602-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D2BB7123C7
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:36:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7366A1C21214
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:36:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78AFF111B3;
	Fri, 26 May 2023 09:36:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64132111AF
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:36:32 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F75B3;
	Fri, 26 May 2023 02:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685093790; x=1716629790;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eY4Y6/5Fo9C2ovGrtIkx5qeGA6xJx9X69+28b/uUQx4=;
  b=CjItZQPR5gxPGziEtQcN2NFvLprARhAFwcfJdOSOw2cLMosT5fkZ0/zW
   XDQZuziFkt5TzF0nWmxjlznTQ04FFPWuvsiuXX7cJTmPQJ0e+1yavKx0q
   7NIQYz+vLuxAGBqOMBuSVJiHyrB3smbjWAQfz67SiC1T8EoMI4TSW5Je8
   e/+T9ni64T/ussMy7r8gFlPqdb6LSI9O3JM8kCyLjfkTheBsF7w5P4W1c
   btpH5TBqk4IoL7B93z7nzTyVFVe/k59G3pNz85889bx3Essmnf/c2Y2DF
   3zJe7rwRLG/+TOkSqWBIfmS7tuagXlgi7B9Ie+4qsy9XzRxaaqUUUjZYq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="338758767"
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="338758767"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 02:36:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="738199822"
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="738199822"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 26 May 2023 02:36:25 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q2Ts0-000JDx-2H;
	Fri, 26 May 2023 09:36:24 +0000
Date: Fri, 26 May 2023 17:35:38 +0800
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
Subject: Re: [PATCH net-next v9 4/9] net: txgbe: Register I2C platform device
Message-ID: <202305261703.MVtcjtyn-lkp@intel.com>
References: <20230524091722.522118-5-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524091722.522118-5-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jiawen,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Jiawen-Wu/net-txgbe-Add-software-nodes-to-support-phylink/20230524-173221
base:   net-next/main
patch link:    https://lore.kernel.org/r/20230524091722.522118-5-jiawenwu%40trustnetic.com
patch subject: [PATCH net-next v9 4/9] net: txgbe: Register I2C platform device
config: csky-randconfig-r003-20230525 (https://download.01.org/0day-ci/archive/20230526/202305261703.MVtcjtyn-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/c1ecc61d2d3c17aeaa4992b8f30a2ddca4eebe83
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jiawen-Wu/net-txgbe-Add-software-nodes-to-support-phylink/20230524-173221
        git checkout c1ecc61d2d3c17aeaa4992b8f30a2ddca4eebe83
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 ~/bin/make.cross W=1 O=build_dir ARCH=csky olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 ~/bin/make.cross W=1 O=build_dir ARCH=csky SHELL=/bin/bash drivers/i2c/busses/ drivers/net/phy/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202305261703.MVtcjtyn-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/i2c/busses/i2c-designware-platdrv.c: In function 'dw_i2c_plat_probe':
>> drivers/i2c/busses/i2c-designware-platdrv.c:310:9: error: implicit declaration of function 'i2c_parse_fw_timings' [-Werror=implicit-function-declaration]
     310 |         i2c_parse_fw_timings(&pdev->dev, t, false);
         |         ^~~~~~~~~~~~~~~~~~~~
   drivers/i2c/busses/i2c-designware-platdrv.c: In function 'dw_i2c_plat_remove':
>> drivers/i2c/busses/i2c-designware-platdrv.c:408:9: error: implicit declaration of function 'i2c_del_adapter'; did you mean 'i2c_verify_adapter'? [-Werror=implicit-function-declaration]
     408 |         i2c_del_adapter(&dev->adapter);
         |         ^~~~~~~~~~~~~~~
         |         i2c_verify_adapter
   cc1: some warnings being treated as errors

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for I2C_DESIGNWARE_PLATFORM
   Depends on [n]: I2C [=n] && HAS_IOMEM [=y] && (ACPI && COMMON_CLK [=y] || !ACPI)
   Selected by [y]:
   - TXGBE [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_WANGXUN [=y] && PCI [=y]


vim +/i2c_parse_fw_timings +310 drivers/i2c/busses/i2c-designware-platdrv.c

78d5e9e299e31b Jan Dabros         2022-02-08  275  
6ad6fde3970c98 Jarkko Nikula      2015-08-31  276  static int dw_i2c_plat_probe(struct platform_device *pdev)
2373f6b9744d53 Dirk Brandewie     2011-10-29  277  {
2373f6b9744d53 Dirk Brandewie     2011-10-29  278  	struct i2c_adapter *adap;
e393f674c5fedc Luis Oliveira      2017-06-14  279  	struct dw_i2c_dev *dev;
e3ea52b578be22 Andy Shevchenko    2018-07-25  280  	struct i2c_timings *t;
f9288fcc5c6154 Andy Shevchenko    2020-05-19  281  	int irq, ret;
2373f6b9744d53 Dirk Brandewie     2011-10-29  282  
2373f6b9744d53 Dirk Brandewie     2011-10-29  283  	irq = platform_get_irq(pdev, 0);
b20d386485e259 Alexey Brodkin     2015-03-09  284  	if (irq < 0)
b20d386485e259 Alexey Brodkin     2015-03-09  285  		return irq;
2373f6b9744d53 Dirk Brandewie     2011-10-29  286  
1cb715ca46946b Andy Shevchenko    2013-04-10  287  	dev = devm_kzalloc(&pdev->dev, sizeof(struct dw_i2c_dev), GFP_KERNEL);
1cb715ca46946b Andy Shevchenko    2013-04-10  288  	if (!dev)
1cb715ca46946b Andy Shevchenko    2013-04-10  289  		return -ENOMEM;
2373f6b9744d53 Dirk Brandewie     2011-10-29  290  
fac25d7aaa03c4 Serge Semin        2020-05-28  291  	dev->flags = (uintptr_t)device_get_match_data(&pdev->dev);
b91dbec563d413 Jiawen Wu          2023-05-24  292  	if (device_property_present(&pdev->dev, "wx,i2c-snps-model"))
b91dbec563d413 Jiawen Wu          2023-05-24  293  		dev->flags |= MODEL_WANGXUN_SP;
b91dbec563d413 Jiawen Wu          2023-05-24  294  
1cb715ca46946b Andy Shevchenko    2013-04-10  295  	dev->dev = &pdev->dev;
2373f6b9744d53 Dirk Brandewie     2011-10-29  296  	dev->irq = irq;
2373f6b9744d53 Dirk Brandewie     2011-10-29  297  	platform_set_drvdata(pdev, dev);
2373f6b9744d53 Dirk Brandewie     2011-10-29  298  
b7c3d0777808cd Serge Semin        2020-05-28  299  	ret = dw_i2c_plat_request_regs(dev);
b7c3d0777808cd Serge Semin        2020-05-28  300  	if (ret)
b7c3d0777808cd Serge Semin        2020-05-28  301  		return ret;
b7c3d0777808cd Serge Semin        2020-05-28  302  
ab809fd81fde3d Zhangfei Gao       2016-12-27  303  	dev->rst = devm_reset_control_get_optional_exclusive(&pdev->dev, NULL);
a6af48ec0712a0 Andy Shevchenko    2019-08-19  304  	if (IS_ERR(dev->rst))
a6af48ec0712a0 Andy Shevchenko    2019-08-19  305  		return PTR_ERR(dev->rst);
a6af48ec0712a0 Andy Shevchenko    2019-08-19  306  
ab809fd81fde3d Zhangfei Gao       2016-12-27  307  	reset_control_deassert(dev->rst);
ab809fd81fde3d Zhangfei Gao       2016-12-27  308  
e3ea52b578be22 Andy Shevchenko    2018-07-25  309  	t = &dev->timings;
e3ea52b578be22 Andy Shevchenko    2018-07-25 @310  	i2c_parse_fw_timings(&pdev->dev, t, false);
8e5f6b2a289c43 Romain Baeriswyl   2014-08-20  311  
852f71942ce71f Andy Shevchenko    2020-06-23  312  	i2c_dw_adjust_bus_speed(dev);
1732c22abca8f4 Alexandre Belloni  2018-08-31  313  
1bb39959623b43 Alexandre Belloni  2018-08-31  314  	if (pdev->dev.of_node)
1bb39959623b43 Alexandre Belloni  2018-08-31  315  		dw_i2c_of_configure(pdev);
1bb39959623b43 Alexandre Belloni  2018-08-31  316  
4c5301abbf81f4 Mika Westerberg    2015-11-30  317  	if (has_acpi_companion(&pdev->dev))
f9288fcc5c6154 Andy Shevchenko    2020-05-19  318  		i2c_dw_acpi_configure(&pdev->dev);
4c5301abbf81f4 Mika Westerberg    2015-11-30  319  
20ee1d9020c923 Andy Shevchenko    2020-05-19  320  	ret = i2c_dw_validate_speed(dev);
20ee1d9020c923 Andy Shevchenko    2020-05-19  321  	if (ret)
ab809fd81fde3d Zhangfei Gao       2016-12-27  322  		goto exit_reset;
9803f868944e87 Christian Ruppert  2013-06-26  323  
e393f674c5fedc Luis Oliveira      2017-06-14  324  	ret = i2c_dw_probe_lock_support(dev);
e393f674c5fedc Luis Oliveira      2017-06-14  325  	if (ret)
ab809fd81fde3d Zhangfei Gao       2016-12-27  326  		goto exit_reset;
894acb2f823b13 David Box          2015-01-15  327  
3ebe40ed1c3901 Andy Shevchenko    2020-04-25  328  	i2c_dw_configure(dev);
2fa8326b4b1e5f Dirk Brandewie     2011-10-06  329  
c62ebb3d5f0d0e Phil Edworthy      2019-02-28  330  	/* Optional interface clock */
c62ebb3d5f0d0e Phil Edworthy      2019-02-28  331  	dev->pclk = devm_clk_get_optional(&pdev->dev, "pclk");
71dc297ca9ab63 Andy Shevchenko    2019-08-19  332  	if (IS_ERR(dev->pclk)) {
71dc297ca9ab63 Andy Shevchenko    2019-08-19  333  		ret = PTR_ERR(dev->pclk);
71dc297ca9ab63 Andy Shevchenko    2019-08-19  334  		goto exit_reset;
71dc297ca9ab63 Andy Shevchenko    2019-08-19  335  	}
c62ebb3d5f0d0e Phil Edworthy      2019-02-28  336  
27071b5cbca59d Serge Semin        2022-06-10  337  	dev->clk = devm_clk_get_optional(&pdev->dev, NULL);
27071b5cbca59d Serge Semin        2022-06-10  338  	if (IS_ERR(dev->clk)) {
27071b5cbca59d Serge Semin        2022-06-10  339  		ret = PTR_ERR(dev->clk);
27071b5cbca59d Serge Semin        2022-06-10  340  		goto exit_reset;
27071b5cbca59d Serge Semin        2022-06-10  341  	}
27071b5cbca59d Serge Semin        2022-06-10  342  
27071b5cbca59d Serge Semin        2022-06-10  343  	ret = i2c_dw_prepare_clk(dev, true);
27071b5cbca59d Serge Semin        2022-06-10  344  	if (ret)
27071b5cbca59d Serge Semin        2022-06-10  345  		goto exit_reset;
27071b5cbca59d Serge Semin        2022-06-10  346  
27071b5cbca59d Serge Semin        2022-06-10  347  	if (dev->clk) {
e3ea52b578be22 Andy Shevchenko    2018-07-25  348  		u64 clk_khz;
e3ea52b578be22 Andy Shevchenko    2018-07-25  349  
925ddb240d6c76 Mika Westerberg    2014-09-30  350  		dev->get_clk_rate_khz = i2c_dw_get_clk_rate_khz;
e3ea52b578be22 Andy Shevchenko    2018-07-25  351  		clk_khz = dev->get_clk_rate_khz(dev);
925ddb240d6c76 Mika Westerberg    2014-09-30  352  
e3ea52b578be22 Andy Shevchenko    2018-07-25  353  		if (!dev->sda_hold_time && t->sda_hold_ns)
e3ea52b578be22 Andy Shevchenko    2018-07-25  354  			dev->sda_hold_time =
c045214a0f31dd Andy Shevchenko    2021-07-12  355  				DIV_S64_ROUND_CLOSEST(clk_khz * t->sda_hold_ns, MICRO);
925ddb240d6c76 Mika Westerberg    2014-09-30  356  	}
925ddb240d6c76 Mika Westerberg    2014-09-30  357  
2373f6b9744d53 Dirk Brandewie     2011-10-29  358  	adap = &dev->adapter;
2373f6b9744d53 Dirk Brandewie     2011-10-29  359  	adap->owner = THIS_MODULE;
db2a8b6f1df93d Ricardo Ribalda    2020-07-02  360  	adap->class = dmi_check_system(dw_i2c_hwmon_class_dmi) ?
db2a8b6f1df93d Ricardo Ribalda    2020-07-02  361  					I2C_CLASS_HWMON : I2C_CLASS_DEPRECATED;
8eb5c87a92c065 Dustin Byford      2015-10-23  362  	ACPI_COMPANION_SET(&adap->dev, ACPI_COMPANION(&pdev->dev));
af71100c7acf3c Rob Herring        2011-11-08  363  	adap->dev.of_node = pdev->dev.of_node;
77f3381a83c2f6 Hans de Goede      2019-03-12  364  	adap->nr = -1;
2373f6b9744d53 Dirk Brandewie     2011-10-29  365  
d79294d0de12dd Hans de Goede      2020-04-07  366  	if (dev->flags & ACCESS_NO_IRQ_SUSPEND) {
d79294d0de12dd Hans de Goede      2020-04-07  367  		dev_pm_set_driver_flags(&pdev->dev,
75507a319876ab Richard Fitzgerald 2022-12-19  368  					DPM_FLAG_SMART_PREPARE);
d79294d0de12dd Hans de Goede      2020-04-07  369  	} else {
02e45646d53bdb Rafael J. Wysocki  2018-01-03  370  		dev_pm_set_driver_flags(&pdev->dev,
02e45646d53bdb Rafael J. Wysocki  2018-01-03  371  					DPM_FLAG_SMART_PREPARE |
75507a319876ab Richard Fitzgerald 2022-12-19  372  					DPM_FLAG_SMART_SUSPEND);
d79294d0de12dd Hans de Goede      2020-04-07  373  	}
422cb781e0d0f8 Rafael J. Wysocki  2018-01-03  374  
7c5b3c158b38dc Rajat Jain         2021-10-25  375  	device_enable_async_suspend(&pdev->dev);
7c5b3c158b38dc Rajat Jain         2021-10-25  376  
126dbc6b49c867 Rafael J. Wysocki  2017-09-25  377  	/* The code below assumes runtime PM to be disabled. */
126dbc6b49c867 Rafael J. Wysocki  2017-09-25  378  	WARN_ON(pm_runtime_enabled(&pdev->dev));
126dbc6b49c867 Rafael J. Wysocki  2017-09-25  379  
43452335224bc0 Mika Westerberg    2013-04-10  380  	pm_runtime_set_autosuspend_delay(&pdev->dev, 1000);
43452335224bc0 Mika Westerberg    2013-04-10  381  	pm_runtime_use_autosuspend(&pdev->dev);
7272194ed391f9 Mika Westerberg    2013-01-17  382  	pm_runtime_set_active(&pdev->dev);
126dbc6b49c867 Rafael J. Wysocki  2017-09-25  383  
9cbeeca05049b1 Hans de Goede      2018-09-05  384  	if (dev->shared_with_punit)
126dbc6b49c867 Rafael J. Wysocki  2017-09-25  385  		pm_runtime_get_noresume(&pdev->dev);
126dbc6b49c867 Rafael J. Wysocki  2017-09-25  386  
7272194ed391f9 Mika Westerberg    2013-01-17  387  	pm_runtime_enable(&pdev->dev);
7272194ed391f9 Mika Westerberg    2013-01-17  388  
e393f674c5fedc Luis Oliveira      2017-06-14  389  	ret = i2c_dw_probe(dev);
e393f674c5fedc Luis Oliveira      2017-06-14  390  	if (ret)
ab809fd81fde3d Zhangfei Gao       2016-12-27  391  		goto exit_probe;
ab809fd81fde3d Zhangfei Gao       2016-12-27  392  
e393f674c5fedc Luis Oliveira      2017-06-14  393  	return ret;
36d48fb5766aee Wolfram Sang       2015-10-09  394  
ab809fd81fde3d Zhangfei Gao       2016-12-27  395  exit_probe:
126dbc6b49c867 Rafael J. Wysocki  2017-09-25  396  	dw_i2c_plat_pm_cleanup(dev);
ab809fd81fde3d Zhangfei Gao       2016-12-27  397  exit_reset:
ab809fd81fde3d Zhangfei Gao       2016-12-27  398  	reset_control_assert(dev->rst);
e393f674c5fedc Luis Oliveira      2017-06-14  399  	return ret;
2373f6b9744d53 Dirk Brandewie     2011-10-29  400  }
2373f6b9744d53 Dirk Brandewie     2011-10-29  401  
6ad6fde3970c98 Jarkko Nikula      2015-08-31  402  static int dw_i2c_plat_remove(struct platform_device *pdev)
2373f6b9744d53 Dirk Brandewie     2011-10-29  403  {
2373f6b9744d53 Dirk Brandewie     2011-10-29  404  	struct dw_i2c_dev *dev = platform_get_drvdata(pdev);
2373f6b9744d53 Dirk Brandewie     2011-10-29  405  
7272194ed391f9 Mika Westerberg    2013-01-17  406  	pm_runtime_get_sync(&pdev->dev);
7272194ed391f9 Mika Westerberg    2013-01-17  407  
2373f6b9744d53 Dirk Brandewie     2011-10-29 @408  	i2c_del_adapter(&dev->adapter);
2373f6b9744d53 Dirk Brandewie     2011-10-29  409  
90312351fd1e47 Luis Oliveira      2017-06-14  410  	dev->disable(dev);
2373f6b9744d53 Dirk Brandewie     2011-10-29  411  
edfc39012364a6 Mika Westerberg    2015-06-17  412  	pm_runtime_dont_use_autosuspend(&pdev->dev);
edfc39012364a6 Mika Westerberg    2015-06-17  413  	pm_runtime_put_sync(&pdev->dev);
126dbc6b49c867 Rafael J. Wysocki  2017-09-25  414  	dw_i2c_plat_pm_cleanup(dev);
126dbc6b49c867 Rafael J. Wysocki  2017-09-25  415  
78d5e9e299e31b Jan Dabros         2022-02-08  416  	i2c_dw_remove_lock_support(dev);
78d5e9e299e31b Jan Dabros         2022-02-08  417  
ab809fd81fde3d Zhangfei Gao       2016-12-27  418  	reset_control_assert(dev->rst);
7272194ed391f9 Mika Westerberg    2013-01-17  419  
2373f6b9744d53 Dirk Brandewie     2011-10-29  420  	return 0;
2373f6b9744d53 Dirk Brandewie     2011-10-29  421  }
2373f6b9744d53 Dirk Brandewie     2011-10-29  422  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


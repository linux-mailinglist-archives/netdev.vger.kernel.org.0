Return-Path: <netdev+bounces-7178-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0212271F042
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:06:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5879F1C2106C
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:06:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFC8442529;
	Thu,  1 Jun 2023 17:06:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD24113AC3
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:06:45 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4764619B;
	Thu,  1 Jun 2023 10:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685639201; x=1717175201;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=2g3NABw7sPaVA8hU02X3u+pb0FI4gw2xKGwIiz2Kajo=;
  b=VEHDD4lW3OVS4UdCBL+Yvk01VdOMjFG/dtyYZ9UIrp9GFBUOQ2oeN+me
   LzBTtRvprx4GlT83JeAxLynorY7w/wnkM6BrlrwhTA12c4BPF04swV9cy
   cKdNTDgezfyXJkRex2wwH4y/EpwzV4x8VBQFMn3gZpjyj9Qw5URl4ISsr
   etj+/46qJWhUogYx36ax8n/Z8v7kOluavJab0M3h+pdCkV10pM7S2jEAr
   TGFqfCa5E+UoRKLrxE2iWOnFOdFL0LcJIIWPuDCeiYTZmPFEpH4BNeJr5
   tD/EJ6pH+sEh9LqT/9REvw/xPJmus8uDDU2o+I4G07rsui0cukQ2HQQaU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="345183282"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="345183282"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 10:04:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="772500581"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="772500581"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga008.fm.intel.com with ESMTP; 01 Jun 2023 10:04:44 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1q4lj8-000Swq-0D;
	Thu, 01 Jun 2023 20:04:42 +0300
Date: Thu, 1 Jun 2023 20:04:41 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
	mika.westerberg@linux.intel.com, jsd@semihalf.com,
	Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
	linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com,
	Piotr Raczynski <piotr.raczynski@intel.com>
Subject: Re: [PATCH net-next v10 4/9] net: txgbe: Register I2C platform device
Message-ID: <ZHjPqZYmaERvIQKp@smile.fi.intel.com>
References: <20230601030140.687493-1-jiawenwu@trustnetic.com>
 <20230601030140.687493-5-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230601030140.687493-5-jiawenwu@trustnetic.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 11:01:35AM +0800, Jiawen Wu wrote:
> Register the platform device to use Designware I2C bus master driver.
> Use regmap to read/write I2C device region from given base offset.

LGTM from I²C device registration point of view,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
> ---
>  drivers/net/ethernet/wangxun/Kconfig          |  3 +
>  .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 70 +++++++++++++++++++
>  .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  4 ++
>  3 files changed, 77 insertions(+)
> 
> diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
> index 190d42a203b4..128cc1cb0605 100644
> --- a/drivers/net/ethernet/wangxun/Kconfig
> +++ b/drivers/net/ethernet/wangxun/Kconfig
> @@ -41,6 +41,9 @@ config TXGBE
>  	tristate "Wangxun(R) 10GbE PCI Express adapters support"
>  	depends on PCI
>  	depends on COMMON_CLK
> +	select REGMAP
> +	select I2C
> +	select I2C_DESIGNWARE_PLATFORM
>  	select LIBWX
>  	help
>  	  This driver supports Wangxun(R) 10GbE PCI Express family of
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
> index 06506cfb8d06..24a729150e08 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
> @@ -6,6 +6,8 @@
>  #include <linux/clkdev.h>
>  #include <linux/i2c.h>
>  #include <linux/pci.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
>  
>  #include "../libwx/wx_type.h"
>  #include "txgbe_type.h"
> @@ -98,6 +100,64 @@ static int txgbe_clock_register(struct txgbe *txgbe)
>  	return 0;
>  }
>  
> +static int txgbe_i2c_read(void *context, unsigned int reg, unsigned int *val)
> +{
> +	struct wx *wx = context;
> +
> +	*val = rd32(wx, reg + TXGBE_I2C_BASE);
> +
> +	return 0;
> +}
> +
> +static int txgbe_i2c_write(void *context, unsigned int reg, unsigned int val)
> +{
> +	struct wx *wx = context;
> +
> +	wr32(wx, reg + TXGBE_I2C_BASE, val);
> +
> +	return 0;
> +}
> +
> +static const struct regmap_config i2c_regmap_config = {
> +	.reg_bits = 32,
> +	.val_bits = 32,
> +	.reg_read = txgbe_i2c_read,
> +	.reg_write = txgbe_i2c_write,
> +	.fast_io = true,
> +};
> +
> +static int txgbe_i2c_register(struct txgbe *txgbe)
> +{
> +	struct platform_device_info info = {};
> +	struct platform_device *i2c_dev;
> +	struct regmap *i2c_regmap;
> +	struct pci_dev *pdev;
> +	struct wx *wx;
> +
> +	wx = txgbe->wx;
> +	pdev = wx->pdev;
> +	i2c_regmap = devm_regmap_init(&pdev->dev, NULL, wx, &i2c_regmap_config);
> +	if (IS_ERR(i2c_regmap)) {
> +		wx_err(wx, "failed to init I2C regmap\n");
> +		return PTR_ERR(i2c_regmap);
> +	}
> +
> +	info.parent = &pdev->dev;
> +	info.fwnode = software_node_fwnode(txgbe->nodes.group[SWNODE_I2C]);
> +	info.name = "i2c_designware";
> +	info.id = (pdev->bus->number << 8) | pdev->devfn;
> +
> +	info.res = &DEFINE_RES_IRQ(pdev->irq);
> +	info.num_res = 1;
> +	i2c_dev = platform_device_register_full(&info);
> +	if (IS_ERR(i2c_dev))
> +		return PTR_ERR(i2c_dev);
> +
> +	txgbe->i2c_dev = i2c_dev;
> +
> +	return 0;
> +}
> +
>  int txgbe_init_phy(struct txgbe *txgbe)
>  {
>  	int ret;
> @@ -114,8 +174,17 @@ int txgbe_init_phy(struct txgbe *txgbe)
>  		goto err_unregister_swnode;
>  	}
>  
> +	ret = txgbe_i2c_register(txgbe);
> +	if (ret) {
> +		wx_err(txgbe->wx, "failed to init i2c interface: %d\n", ret);
> +		goto err_unregister_clk;
> +	}
> +
>  	return 0;
>  
> +err_unregister_clk:
> +	clkdev_drop(txgbe->clock);
> +	clk_unregister(txgbe->clk);
>  err_unregister_swnode:
>  	software_node_unregister_node_group(txgbe->nodes.group);
>  
> @@ -124,6 +193,7 @@ int txgbe_init_phy(struct txgbe *txgbe)
>  
>  void txgbe_remove_phy(struct txgbe *txgbe)
>  {
> +	platform_device_unregister(txgbe->i2c_dev);
>  	clkdev_drop(txgbe->clock);
>  	clk_unregister(txgbe->clk);
>  	software_node_unregister_node_group(txgbe->nodes.group);
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
> index cdbc4b37f832..55979abf01f2 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
> @@ -55,6 +55,9 @@
>  #define TXGBE_TS_CTL                            0x10300
>  #define TXGBE_TS_CTL_EVAL_MD                    BIT(31)
>  
> +/* I2C registers */
> +#define TXGBE_I2C_BASE                          0x14900
> +
>  /* Part Number String Length */
>  #define TXGBE_PBANUM_LENGTH                     32
>  
> @@ -146,6 +149,7 @@ struct txgbe_nodes {
>  struct txgbe {
>  	struct wx *wx;
>  	struct txgbe_nodes nodes;
> +	struct platform_device *i2c_dev;
>  	struct clk_lookup *clock;
>  	struct clk *clk;
>  };
> -- 
> 2.27.0
> 

-- 
With Best Regards,
Andy Shevchenko




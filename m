Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246E83553FD
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344053AbhDFMe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:34:27 -0400
Received: from mga03.intel.com ([134.134.136.65]:43398 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344050AbhDFMeZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 08:34:25 -0400
IronPort-SDR: QXsjGTJ6z2/UzaechYyN4jGq4LDAUS/Znpd7fRhAO6BGLBUrUpYLOoNFGbqQQw4nwz98xH/A5M
 puxqy7DbDkBA==
X-IronPort-AV: E=McAfee;i="6000,8403,9946"; a="193095022"
X-IronPort-AV: E=Sophos;i="5.81,309,1610438400"; 
   d="scan'208";a="193095022"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 05:34:16 -0700
IronPort-SDR: LFu5Mitpm//InF7yS6omjqR+EmE8KVBTozwQVYSyM8bRI4ShGnLFyZEXMqcV+OC2Wo6Utn5xSf
 JPhLci5i5LvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,309,1610438400"; 
   d="scan'208";a="457871836"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga001.jf.intel.com with ESMTP; 06 Apr 2021 05:34:11 -0700
Received: from linux.intel.com (unknown [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id DCDDD5805A1;
        Tue,  6 Apr 2021 05:34:08 -0700 (PDT)
Date:   Tue, 6 Apr 2021 20:33:58 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH net-next v1 1/1] stmmac: intel: Drop duplicate ID in the
 list of PCI device IDs
Message-ID: <20210406123358.GA14588@linux.intel.com>
References: <20210406101306.59162-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406101306.59162-1-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 01:13:06PM +0300, Andy Shevchenko wrote:
> The PCI device IDs are defined with a prefix PCI_DEVICE_ID.
> There is no need to repeat the ID part at the end of each definition.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>

> ---
>  .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 60 +++++++++----------
>  1 file changed, 30 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> index 3d9a57043af2..7f0ce373a63d 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> @@ -1053,41 +1053,41 @@ static int __maybe_unused intel_eth_pci_resume(struct device *dev)
>  static SIMPLE_DEV_PM_OPS(intel_eth_pm_ops, intel_eth_pci_suspend,
>  			 intel_eth_pci_resume);
>  
> -#define PCI_DEVICE_ID_INTEL_QUARK_ID			0x0937
> -#define PCI_DEVICE_ID_INTEL_EHL_RGMII1G_ID		0x4b30
> -#define PCI_DEVICE_ID_INTEL_EHL_SGMII1G_ID		0x4b31
> -#define PCI_DEVICE_ID_INTEL_EHL_SGMII2G5_ID		0x4b32
> +#define PCI_DEVICE_ID_INTEL_QUARK		0x0937
> +#define PCI_DEVICE_ID_INTEL_EHL_RGMII1G		0x4b30
> +#define PCI_DEVICE_ID_INTEL_EHL_SGMII1G		0x4b31
> +#define PCI_DEVICE_ID_INTEL_EHL_SGMII2G5	0x4b32
>  /* Intel(R) Programmable Services Engine (Intel(R) PSE) consist of 2 MAC
>   * which are named PSE0 and PSE1
>   */
> -#define PCI_DEVICE_ID_INTEL_EHL_PSE0_RGMII1G_ID		0x4ba0
> -#define PCI_DEVICE_ID_INTEL_EHL_PSE0_SGMII1G_ID		0x4ba1
> -#define PCI_DEVICE_ID_INTEL_EHL_PSE0_SGMII2G5_ID	0x4ba2
> -#define PCI_DEVICE_ID_INTEL_EHL_PSE1_RGMII1G_ID		0x4bb0
> -#define PCI_DEVICE_ID_INTEL_EHL_PSE1_SGMII1G_ID		0x4bb1
> -#define PCI_DEVICE_ID_INTEL_EHL_PSE1_SGMII2G5_ID	0x4bb2
> -#define PCI_DEVICE_ID_INTEL_TGLH_SGMII1G_0_ID		0x43ac
> -#define PCI_DEVICE_ID_INTEL_TGLH_SGMII1G_1_ID		0x43a2
> -#define PCI_DEVICE_ID_INTEL_TGL_SGMII1G_ID		0xa0ac
> -#define PCI_DEVICE_ID_INTEL_ADLS_SGMII1G_0_ID		0x7aac
> -#define PCI_DEVICE_ID_INTEL_ADLS_SGMII1G_1_ID		0x7aad
> +#define PCI_DEVICE_ID_INTEL_EHL_PSE0_RGMII1G	0x4ba0
> +#define PCI_DEVICE_ID_INTEL_EHL_PSE0_SGMII1G	0x4ba1
> +#define PCI_DEVICE_ID_INTEL_EHL_PSE0_SGMII2G5	0x4ba2
> +#define PCI_DEVICE_ID_INTEL_EHL_PSE1_RGMII1G	0x4bb0
> +#define PCI_DEVICE_ID_INTEL_EHL_PSE1_SGMII1G	0x4bb1
> +#define PCI_DEVICE_ID_INTEL_EHL_PSE1_SGMII2G5	0x4bb2
> +#define PCI_DEVICE_ID_INTEL_TGLH_SGMII1G_0	0x43ac
> +#define PCI_DEVICE_ID_INTEL_TGLH_SGMII1G_1	0x43a2
> +#define PCI_DEVICE_ID_INTEL_TGL_SGMII1G		0xa0ac
> +#define PCI_DEVICE_ID_INTEL_ADLS_SGMII1G_0	0x7aac
> +#define PCI_DEVICE_ID_INTEL_ADLS_SGMII1G_1	0x7aad
>  
>  static const struct pci_device_id intel_eth_pci_id_table[] = {
> -	{ PCI_DEVICE_DATA(INTEL, QUARK_ID, &quark_info) },
> -	{ PCI_DEVICE_DATA(INTEL, EHL_RGMII1G_ID, &ehl_rgmii1g_info) },
> -	{ PCI_DEVICE_DATA(INTEL, EHL_SGMII1G_ID, &ehl_sgmii1g_info) },
> -	{ PCI_DEVICE_DATA(INTEL, EHL_SGMII2G5_ID, &ehl_sgmii1g_info) },
> -	{ PCI_DEVICE_DATA(INTEL, EHL_PSE0_RGMII1G_ID, &ehl_pse0_rgmii1g_info) },
> -	{ PCI_DEVICE_DATA(INTEL, EHL_PSE0_SGMII1G_ID, &ehl_pse0_sgmii1g_info) },
> -	{ PCI_DEVICE_DATA(INTEL, EHL_PSE0_SGMII2G5_ID, &ehl_pse0_sgmii1g_info) },
> -	{ PCI_DEVICE_DATA(INTEL, EHL_PSE1_RGMII1G_ID, &ehl_pse1_rgmii1g_info) },
> -	{ PCI_DEVICE_DATA(INTEL, EHL_PSE1_SGMII1G_ID, &ehl_pse1_sgmii1g_info) },
> -	{ PCI_DEVICE_DATA(INTEL, EHL_PSE1_SGMII2G5_ID, &ehl_pse1_sgmii1g_info) },
> -	{ PCI_DEVICE_DATA(INTEL, TGL_SGMII1G_ID, &tgl_sgmii1g_phy0_info) },
> -	{ PCI_DEVICE_DATA(INTEL, TGLH_SGMII1G_0_ID, &tgl_sgmii1g_phy0_info) },
> -	{ PCI_DEVICE_DATA(INTEL, TGLH_SGMII1G_1_ID, &tgl_sgmii1g_phy1_info) },
> -	{ PCI_DEVICE_DATA(INTEL, ADLS_SGMII1G_0_ID, &adls_sgmii1g_phy0_info) },
> -	{ PCI_DEVICE_DATA(INTEL, ADLS_SGMII1G_1_ID, &adls_sgmii1g_phy1_info) },
> +	{ PCI_DEVICE_DATA(INTEL, QUARK, &quark_info) },
> +	{ PCI_DEVICE_DATA(INTEL, EHL_RGMII1G, &ehl_rgmii1g_info) },
> +	{ PCI_DEVICE_DATA(INTEL, EHL_SGMII1G, &ehl_sgmii1g_info) },
> +	{ PCI_DEVICE_DATA(INTEL, EHL_SGMII2G5, &ehl_sgmii1g_info) },
> +	{ PCI_DEVICE_DATA(INTEL, EHL_PSE0_RGMII1G, &ehl_pse0_rgmii1g_info) },
> +	{ PCI_DEVICE_DATA(INTEL, EHL_PSE0_SGMII1G, &ehl_pse0_sgmii1g_info) },
> +	{ PCI_DEVICE_DATA(INTEL, EHL_PSE0_SGMII2G5, &ehl_pse0_sgmii1g_info) },
> +	{ PCI_DEVICE_DATA(INTEL, EHL_PSE1_RGMII1G, &ehl_pse1_rgmii1g_info) },
> +	{ PCI_DEVICE_DATA(INTEL, EHL_PSE1_SGMII1G, &ehl_pse1_sgmii1g_info) },
> +	{ PCI_DEVICE_DATA(INTEL, EHL_PSE1_SGMII2G5, &ehl_pse1_sgmii1g_info) },
> +	{ PCI_DEVICE_DATA(INTEL, TGL_SGMII1G, &tgl_sgmii1g_phy0_info) },
> +	{ PCI_DEVICE_DATA(INTEL, TGLH_SGMII1G_0, &tgl_sgmii1g_phy0_info) },
> +	{ PCI_DEVICE_DATA(INTEL, TGLH_SGMII1G_1, &tgl_sgmii1g_phy1_info) },
> +	{ PCI_DEVICE_DATA(INTEL, ADLS_SGMII1G_0, &adls_sgmii1g_phy0_info) },
> +	{ PCI_DEVICE_DATA(INTEL, ADLS_SGMII1G_1, &adls_sgmii1g_phy1_info) },
>  	{}
>  };
>  MODULE_DEVICE_TABLE(pci, intel_eth_pci_id_table);
> -- 
> 2.30.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

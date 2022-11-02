Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54DF06169FD
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 18:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiKBRHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 13:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbiKBRH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 13:07:27 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454C71275A;
        Wed,  2 Nov 2022 10:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667408847; x=1698944847;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=T+TGu5fyZMwsB1bNV8M5ZhUO/Mv6ZJpYkYI2sMe6tBU=;
  b=Wo1lwrNavGPj36brrWbSfBVXl/iumMPS2gaDw7hhcfC9VXrgI8TlKXcw
   ero3OEJxdnIgz19E+4ZPkiuI1QlMPrDpOfTKeKwHV6cyZZhNuf3mXLjjQ
   OBGAtVOstTbDGfsyADXsCP6fYGsAXWZqI3Q3j7AUoear/w7k7aIlmTmNh
   /WlqoFNNtaqfRFGidRwflmM9Q3s/K/6xQuh+UlaYvvpm/FbuqxMYVq4ZX
   thh9YTNGJTXSTyqSWyanCe5oMbkMZZisAkF6wi17t/+SU65idX5Dp2afz
   HYX68m4z1ofW06+zS/wVKfbIIlqgxWoxU3e+9CB1ZC/M1+sIPOTeoIzV+
   g==;
X-IronPort-AV: E=Sophos;i="5.95,234,1661842800"; 
   d="scan'208";a="187332013"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Nov 2022 10:07:26 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 2 Nov 2022 10:07:24 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Wed, 2 Nov 2022 10:07:24 -0700
Date:   Wed, 2 Nov 2022 18:12:07 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <pabeni@redhat.com>, <edumazet@google.com>, <olteanv@gmail.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net-next V6 1/2] net: lan743x: Remove unused argument in
 lan743x_common_regs( )
Message-ID: <20221102171207.omyob44532fu4bvm@soft-dev3-1>
References: <20221102104834.5555-1-Raju.Lakkaraju@microchip.com>
 <20221102104834.5555-2-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221102104834.5555-2-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/02/2022 16:18, Raju Lakkaraju wrote:

Hi Raju,

> Remove the unused argument (i.e. struct ethtool_regs *regs) in
> lan743x_common_regs( ) function arguments.
> 
> Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
> ---
>  drivers/net/ethernet/microchip/lan743x_ethtool.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
> index 88f9484cc2a7..fd59708ac4b5 100644
> --- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
> +++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
> @@ -1190,15 +1190,11 @@ static int lan743x_ethtool_set_wol(struct net_device *netdev,
>  }
>  #endif /* CONFIG_PM */
>  
> -static void lan743x_common_regs(struct net_device *dev,
> -				struct ethtool_regs *regs, void *p)
> -
> +static void lan743x_common_regs(struct net_device *dev, void *p)
>  {
>  	struct lan743x_adapter *adapter = netdev_priv(dev);
>  	u32 *rb = p;
>  
> -	memset(p, 0, (MAX_LAN743X_ETH_REGS * sizeof(u32)));
> -

It seems that you do more here than what you said.
You remove the unused argument but you also remove the memset. And it
is a problem because p is not initialized anymore.

>  	rb[ETH_PRIV_FLAGS] = adapter->flags;
>  	rb[ETH_ID_REV]     = lan743x_csr_read(adapter, ID_REV);
>  	rb[ETH_FPGA_REV]   = lan743x_csr_read(adapter, FPGA_REV);
> @@ -1230,7 +1226,7 @@ static void lan743x_get_regs(struct net_device *dev,
>  {
>  	regs->version = LAN743X_ETH_REG_VERSION;
>  
> -	lan743x_common_regs(dev, regs, p);
> +	lan743x_common_regs(dev, p);
>  }
>  
>  static void lan743x_get_pauseparam(struct net_device *dev,
> -- 
> 2.25.1
> 

-- 
/Horatiu

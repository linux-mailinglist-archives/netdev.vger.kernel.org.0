Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4792E6E46D4
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 13:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjDQLwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 07:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjDQLv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 07:51:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7599510D3;
        Mon, 17 Apr 2023 04:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681732265; x=1713268265;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=W5TQ3wd/xW5hpZCXv0bBA8AsymSy3tuwpq12Dh6k4+w=;
  b=TUSDiGLQ7zy7sqBrEpRXRU9vuymgJBAyFuz3Hs82mHnbmWNHazlQ5uUV
   Kdd7rju9MfCI80GC0s0lai2WuQKTslee2C51Qoi5tCFDvcv6TmH0NAbVC
   hO9k8OvaeR9sHgG0zO/GzdeUjdsE97+O8s+5exCkY4KQL/9Cigs4e5t2f
   WoI1Ob8tNefWKBdx63Xabf67n+Yf2/fk5DatXX4jt454jH64xw8uzhshs
   iUWvm0ys0w2ah/X/RfZsmN97SV0LIX/vbEnMUnVNucXy8mQGVs+BfnFoQ
   u7huyDCGk/oAYWs/xAjJUz2BikjQkdxEyBWorUlqLZlMoJyimQyxeLI1e
   g==;
X-IronPort-AV: E=Sophos;i="5.99,204,1677567600"; 
   d="scan'208";a="210758879"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Apr 2023 04:12:58 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 17 Apr 2023 04:12:58 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 17 Apr 2023 04:12:58 -0700
Date:   Mon, 17 Apr 2023 13:12:57 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Alain Volmat <avolmat@me.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <patrice.chotard@foss.st.com>, <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: ethernet: stmmac: dwmac-sti: remove
 stih415/stih416/stid127
Message-ID: <20230417111257.ilmlp5y3xp47edzv@soft-dev3-1>
References: <20230416195523.61075-1-avolmat@me.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230416195523.61075-1-avolmat@me.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/16/2023 21:55, Alain Volmat wrote:
> 
> Remove no more supported platforms (stih415/stih416 and stid127)

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> Signed-off-by: Alain Volmat <avolmat@me.com>
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> ---
> Patch sent previously as part of serie: https://lore.kernel.org/all/20230209091659.1409-8-avolmat@me.com/
> 
>  .../net/ethernet/stmicro/stmmac/dwmac-sti.c   | 60 +------------------
>  1 file changed, 1 insertion(+), 59 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
> index be3b1ebc06ab..465ce66ef9c1 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
> @@ -35,7 +35,7 @@
>  #define IS_PHY_IF_MODE_GBIT(iface)     (IS_PHY_IF_MODE_RGMII(iface) || \
>                                          iface == PHY_INTERFACE_MODE_GMII)
> 
> -/* STiH4xx register definitions (STiH415/STiH416/STiH407/STiH410 families)
> +/* STiH4xx register definitions (STiH407/STiH410 families)
>   *
>   * Below table summarizes the clock requirement and clock sources for
>   * supported phy interface modes with link speeds.
> @@ -75,27 +75,6 @@
>  #define STIH4XX_ETH_SEL_INTERNAL_NOTEXT_PHYCLK BIT(7)
>  #define STIH4XX_ETH_SEL_TXCLK_NOT_CLK125       BIT(6)
> 
> -/* STiD127 register definitions
> - *-----------------------
> - * src  |BIT(6)| BIT(7)|
> - *-----------------------
> - * MII   |  1  |   n/a |
> - *-----------------------
> - * RMII  |  n/a        |   1   |
> - * clkgen|     |       |
> - *-----------------------
> - * RMII  |  n/a        |   0   |
> - * phyclk|     |       |
> - *-----------------------
> - * RGMII |  1  |  n/a  |
> - * clkgen|     |       |
> - *-----------------------
> - */
> -
> -#define STID127_RETIME_SRC_MASK                        GENMASK(7, 6)
> -#define STID127_ETH_SEL_INTERNAL_NOTEXT_PHYCLK BIT(7)
> -#define STID127_ETH_SEL_INTERNAL_NOTEXT_TXCLK  BIT(6)
> -
>  #define ENMII_MASK     GENMASK(5, 5)
>  #define ENMII          BIT(5)
>  #define EN_MASK                GENMASK(1, 1)
> @@ -194,36 +173,6 @@ static void stih4xx_fix_retime_src(void *priv, u32 spd)
>                            stih4xx_tx_retime_val[src]);
>  }
> 
> -static void stid127_fix_retime_src(void *priv, u32 spd)
> -{
> -       struct sti_dwmac *dwmac = priv;
> -       u32 reg = dwmac->ctrl_reg;
> -       u32 freq = 0;
> -       u32 val = 0;
> -
> -       if (dwmac->interface == PHY_INTERFACE_MODE_MII) {
> -               val = STID127_ETH_SEL_INTERNAL_NOTEXT_TXCLK;
> -       } else if (dwmac->interface == PHY_INTERFACE_MODE_RMII) {
> -               if (!dwmac->ext_phyclk) {
> -                       val = STID127_ETH_SEL_INTERNAL_NOTEXT_PHYCLK;
> -                       freq = DWMAC_50MHZ;
> -               }
> -       } else if (IS_PHY_IF_MODE_RGMII(dwmac->interface)) {
> -               val = STID127_ETH_SEL_INTERNAL_NOTEXT_TXCLK;
> -               if (spd == SPEED_1000)
> -                       freq = DWMAC_125MHZ;
> -               else if (spd == SPEED_100)
> -                       freq = DWMAC_25MHZ;
> -               else if (spd == SPEED_10)
> -                       freq = DWMAC_2_5MHZ;
> -       }
> -
> -       if (freq)
> -               clk_set_rate(dwmac->clk, freq);
> -
> -       regmap_update_bits(dwmac->regmap, reg, STID127_RETIME_SRC_MASK, val);
> -}
> -
>  static int sti_dwmac_set_mode(struct sti_dwmac *dwmac)
>  {
>         struct regmap *regmap = dwmac->regmap;
> @@ -408,14 +357,7 @@ static const struct sti_dwmac_of_data stih4xx_dwmac_data = {
>         .fix_retime_src = stih4xx_fix_retime_src,
>  };
> 
> -static const struct sti_dwmac_of_data stid127_dwmac_data = {
> -       .fix_retime_src = stid127_fix_retime_src,
> -};
> -
>  static const struct of_device_id sti_dwmac_match[] = {
> -       { .compatible = "st,stih415-dwmac", .data = &stih4xx_dwmac_data},
> -       { .compatible = "st,stih416-dwmac", .data = &stih4xx_dwmac_data},
> -       { .compatible = "st,stid127-dwmac", .data = &stid127_dwmac_data},
>         { .compatible = "st,stih407-dwmac", .data = &stih4xx_dwmac_data},
>         { }
>  };
> --
> 2.34.1
> 

-- 
/Horatiu

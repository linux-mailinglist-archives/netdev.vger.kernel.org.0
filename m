Return-Path: <netdev+bounces-1123-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 173646FC463
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:59:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5DEB2811E7
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:59:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3DCB1094D;
	Tue,  9 May 2023 10:59:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F9A7C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 10:59:20 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8647A106D5;
	Tue,  9 May 2023 03:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1683629934; x=1715165934;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oepJVOVH68CBYtXIJCDRmO6N5dpmZ6x7a1EFLw/yItU=;
  b=KQN7zJHdh1Z0wPzGdpwLS4IvwBhnBhfvEDunkbN01dOGbVWmFaR/doQA
   KkaBwgUtlELbD36pQsT0SVNNjab/CBrgtpN0LZqTIVyOqkrgmVQ88Z+EQ
   wgpe8yRrF0kFfcNrQXHFv3ubKaqotfQXapDFd0S19ViA6a+tzZnE8sgY2
   XbuaVRUxII475Uaeu0CYdPO9vCczV9dHSt6F/MbAUBOk6oeaOcyHMeLaW
   3+86adcZk7autCOJ+btfHwXPanxhrgc8pzl2vKufumCpsg7GKJMi4T7Wc
   RcCVYEd33T+tKS8s6cG4AliLUtqEPtjaHN6iymR8ut863P1nJOQzr2LRb
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,261,1677567600"; 
   d="scan'208";a="213074737"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 May 2023 03:58:49 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 9 May 2023 03:58:48 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 9 May 2023 03:58:47 -0700
Date: Tue, 9 May 2023 12:58:47 +0200
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: wuych <yunchuan@nfschina.com>
CC: <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
	<andrew@lunn.ch>, <michael@walle.cc>, <zhaoxiao@uniontech.com>,
	<andrew@aj.id.au>, <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH net-next] freescale:Remove unnecessary (void*) conversions
Message-ID: <20230509105847.qow6jmmfub3ynfzs@soft-dev3-1>
References: <20230509102501.41685-1-yunchuan@nfschina.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230509102501.41685-1-yunchuan@nfschina.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The 05/09/2023 18:25, wuych wrote:

Hi wuych,

> 
> Pointer variables of void * type do not require type cast.
> 
> Signed-off-by: wuych <yunchuan@nfschina.com>
> ---
>  drivers/net/ethernet/freescale/xgmac_mdio.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
> index a13b4ba4d6e1..167a7fe04853 100644
> --- a/drivers/net/ethernet/freescale/xgmac_mdio.c
> +++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
> @@ -131,7 +131,7 @@ static int xgmac_wait_until_done(struct device *dev,
>  static int xgmac_mdio_write_c22(struct mii_bus *bus, int phy_id, int regnum,
>                                 u16 value)
>  {
> -       struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
> +       struct mdio_fsl_priv *priv = bus->priv;

Don't forget to use the reverse x-mas notation.
The longer lines should be at top.
The same applies to the other changes that you have done in this patch.

>         struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
>         bool endian = priv->is_little_endian;
>         u16 dev_addr = regnum & 0x1f;
> @@ -163,7 +163,7 @@ static int xgmac_mdio_write_c22(struct mii_bus *bus, int phy_id, int regnum,
>  static int xgmac_mdio_write_c45(struct mii_bus *bus, int phy_id, int dev_addr,
>                                 int regnum, u16 value)
>  {
> -       struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
> +       struct mdio_fsl_priv *priv = bus->priv;
>         struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
>         bool endian = priv->is_little_endian;
>         u32 mdio_ctl, mdio_stat;
> @@ -205,7 +205,7 @@ static int xgmac_mdio_write_c45(struct mii_bus *bus, int phy_id, int dev_addr,
>   */
>  static int xgmac_mdio_read_c22(struct mii_bus *bus, int phy_id, int regnum)
>  {
> -       struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
> +       struct mdio_fsl_priv *priv = bus->priv;
>         struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
>         bool endian = priv->is_little_endian;
>         u16 dev_addr = regnum & 0x1f;
> @@ -265,7 +265,7 @@ static int xgmac_mdio_read_c22(struct mii_bus *bus, int phy_id, int regnum)
>  static int xgmac_mdio_read_c45(struct mii_bus *bus, int phy_id, int dev_addr,
>                                int regnum)
>  {
> -       struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
> +       struct mdio_fsl_priv *priv = bus->priv;
>         struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
>         bool endian = priv->is_little_endian;
>         u32 mdio_stat, mdio_ctl;
> @@ -326,7 +326,7 @@ static int xgmac_mdio_read_c45(struct mii_bus *bus, int phy_id, int dev_addr,
> 
>  static int xgmac_mdio_set_mdc_freq(struct mii_bus *bus)
>  {
> -       struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
> +       struct mdio_fsl_priv *priv = bus->priv;
>         struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
>         struct device *dev = bus->parent;
>         u32 mdio_stat, div;
> @@ -355,7 +355,7 @@ static int xgmac_mdio_set_mdc_freq(struct mii_bus *bus)
> 
>  static void xgmac_mdio_set_suppress_preamble(struct mii_bus *bus)
>  {
> -       struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
> +       struct mdio_fsl_priv *priv = bus->priv;
>         struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
>         struct device *dev = bus->parent;
>         u32 mdio_stat;
> --
> 2.30.2
> 
> 

-- 
/Horatiu


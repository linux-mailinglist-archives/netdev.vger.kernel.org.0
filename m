Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D195B30FC25
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 20:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239530AbhBDTB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 14:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239240AbhBDTAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 14:00:51 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C22C06178B
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 11:00:10 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id o18so3177134qtp.10
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 11:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qhWrtHfC3h5fD+Z43tuRkr9jxg9Ml0HNZ58mahnXO+U=;
        b=oW1T6SUI/Yd8V2yCeF3crn2J7h1mlcKyGjlmx5JXScibQCxhqqvhe4SHEVQmz8nMu7
         hvPVO6mpE6HtsGk6XNCrpYOlep8FJTo8tmWIj7YJnobuiHNgL5fn1rSe3Pbyh1a0cMhb
         7C8Bn99r8JV+U1BGMQ6ffe+0hphH5BI4rDZMJZe35CMd2V1+rfzRNu6XiuqrjCjYP3Rq
         z4gLOtUSra/Ja6gmZEp+2Wk3Zbf1u7GXsM0iMmaWzRAfBrjtsvWro6HyRzMU9fPCrukH
         hTO5F0rabDe/JBvhWkN0OIpqd0ziYKXm6DujZPlDNv6pfwjJK5u6gAJkvtlgJ0Tl9SJX
         RHyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qhWrtHfC3h5fD+Z43tuRkr9jxg9Ml0HNZ58mahnXO+U=;
        b=Yw9iXAcQwnZMynUmjqj/KTqNv4XogwHMxHCsoEznxvbO0za1FfB7VsaFe8Twwrk31V
         VfgLajALJ6GtwDyBf6u4kXIz0x7o0uEDvfC8YYCItCEeu7WirJ99v538WGEICgpt3nH4
         Ebc4xQOFweTlw2ur07JVMVgjPIersX8X/KUJHYgmjXo9y+5BPWKv5YepAfleFjiT3Qyp
         5BvCa8VACGGENIHR6mYc800OwJwY+OuUS5a74VXg8rnqgN4SVELoW2dPTi1+TNiSf/YU
         xMrZX2Dinar8H3bX9x+wj03pkmcifvSUTnto7VE72ZWcCqpGmFGzn2Kui3KMCYx0usAV
         RrSg==
X-Gm-Message-State: AOAM531N8eE6GEb9sLhTvTQs0JJXT4hUasdwL4KVDz41lynjZuyuuaRo
        ne1RY60HuktBRPOFNP2ZAZJmZPSghv9uOYfSX1XQCw==
X-Google-Smtp-Source: ABdhPJylO/sdZFdZaOD3k0k0X9Hlyx8N4htPDQsb8egg2r1URr5JOudm8rvXauTeaboBzT339jBkPhwVOu7/ZxFguCc=
X-Received: by 2002:ac8:5c41:: with SMTP id j1mr1018705qtj.306.1612465209050;
 Thu, 04 Feb 2021 11:00:09 -0800 (PST)
MIME-Version: 1.0
References: <1612253821-1148-1-git-send-email-stefanc@marvell.com> <1612253821-1148-5-git-send-email-stefanc@marvell.com>
In-Reply-To: <1612253821-1148-5-git-send-email-stefanc@marvell.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 4 Feb 2021 19:59:58 +0100
Message-ID: <CAPv3WKcGq71P4UuUX94Z8BTosddybUpQdS1B3D1BknZsEmFkKQ@mail.gmail.com>
Subject: Re: [PATCH v7 net-next 04/15] net: mvpp2: add PPv23 version definition
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, nadavh@marvell.com,
        Yan Markman <ymarkman@marvell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>, atenart@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

wt., 2 lut 2021 o 09:17 <stefanc@marvell.com> napisa=C5=82(a):
>
> From: Stefan Chulski <stefanc@marvell.com>
>
> This patch add PPv23 version definition.
> PPv23 is new packet processor in CP115.
> Everything that supported by PPv22, also supported by PPv23.
> No functional changes in this stage.
>
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 24 ++++++++++++-------=
-
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 17 +++++++++-----
>  2 files changed, 25 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/eth=
ernet/marvell/mvpp2/mvpp2.h
> index aec9179..89b3ede 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> @@ -60,6 +60,9 @@
>  /* Top Registers */
>  #define MVPP2_MH_REG(port)                     (0x5040 + 4 * (port))
>  #define MVPP2_DSA_EXTENDED                     BIT(5)
> +#define MVPP2_VER_ID_REG                       0x50b0
> +#define MVPP2_VER_PP22                         0x10
> +#define MVPP2_VER_PP23                         0x11
>
>  /* Parser Registers */
>  #define MVPP2_PRS_INIT_LOOKUP_REG              0x1000
> @@ -469,7 +472,7 @@
>  #define     MVPP22_GMAC_INT_SUM_MASK_LINK_STAT BIT(1)
>  #define            MVPP22_GMAC_INT_SUM_MASK_PTP        BIT(2)
>
> -/* Per-port XGMAC registers. PPv2.2 only, only for GOP port 0,
> +/* Per-port XGMAC registers. PPv2.2 and PPv2.3, only for GOP port 0,
>   * relative to port->base.
>   */
>  #define MVPP22_XLG_CTRL0_REG                   0x100
> @@ -506,7 +509,7 @@
>  #define     MVPP22_XLG_CTRL4_MACMODSELECT_GMAC BIT(12)
>  #define     MVPP22_XLG_CTRL4_EN_IDLE_CHECK     BIT(14)
>
> -/* SMI registers. PPv2.2 only, relative to priv->iface_base. */
> +/* SMI registers. PPv2.2 and PPv2.3, relative to priv->iface_base. */
>  #define MVPP22_SMI_MISC_CFG_REG                        0x1204
>  #define     MVPP22_SMI_POLLING_EN              BIT(10)
>
> @@ -582,7 +585,7 @@
>  #define MVPP2_QUEUE_NEXT_DESC(q, index) \
>         (((index) < (q)->last_desc) ? ((index) + 1) : 0)
>
> -/* XPCS registers. PPv2.2 only */
> +/* XPCS registers.PPv2.2 and PPv2.3 */
>  #define MVPP22_MPCS_BASE(port)                 (0x7000 + (port) * 0x1000=
)
>  #define MVPP22_MPCS_CTRL                       0x14
>  #define     MVPP22_MPCS_CTRL_FWD_ERR_CONN      BIT(10)
> @@ -593,7 +596,7 @@
>  #define     MVPP22_MPCS_CLK_RESET_DIV_RATIO(n) ((n) << 4)
>  #define     MVPP22_MPCS_CLK_RESET_DIV_SET      BIT(11)
>
> -/* XPCS registers. PPv2.2 only */
> +/* XPCS registers. PPv2.2 and PPv2.3 */
>  #define MVPP22_XPCS_BASE(port)                 (0x7400 + (port) * 0x1000=
)
>  #define MVPP22_XPCS_CFG0                       0x0
>  #define     MVPP22_XPCS_CFG0_RESET_DIS         BIT(0)
> @@ -930,15 +933,16 @@ struct mvpp2 {
>         void __iomem *iface_base;
>         void __iomem *cm3_base;
>
> -       /* On PPv2.2, each "software thread" can access the base
> +       /* On PPv2.2 and PPv2.3, each "software thread" can access the ba=
se
>          * register through a separate address space, each 64 KB apart
>          * from each other. Typically, such address spaces will be
>          * used per CPU.
>          */
>         void __iomem *swth_base[MVPP2_MAX_THREADS];
>
> -       /* On PPv2.2, some port control registers are located into the sy=
stem
> -        * controller space. These registers are accessible through a reg=
map.
> +       /* On PPv2.2 and PPv2.3, some port control registers are located =
into
> +        * the system controller space. These registers are accessible
> +        * through a regmap.
>          */
>         struct regmap *sysctrl_base;
>
> @@ -980,7 +984,7 @@ struct mvpp2 {
>         u32 tclk;
>
>         /* HW version */
> -       enum { MVPP21, MVPP22 } hw_version;
> +       enum { MVPP21, MVPP22, MVPP23 } hw_version;
>
>         /* Maximum number of RXQs per port */
>         unsigned int max_port_rxqs;
> @@ -1227,7 +1231,7 @@ struct mvpp21_rx_desc {
>         __le32 reserved8;
>  };
>
> -/* HW TX descriptor for PPv2.2 */
> +/* HW TX descriptor for PPv2.2 and PPv2.3 */
>  struct mvpp22_tx_desc {
>         __le32 command;
>         u8  packet_offset;
> @@ -1239,7 +1243,7 @@ struct mvpp22_tx_desc {
>         __le64 buf_cookie_misc;
>  };
>
> -/* HW RX descriptor for PPv2.2 */
> +/* HW RX descriptor for PPv2.2 and PPv2.3 */
>  struct mvpp22_rx_desc {
>         __le32 status;
>         __le16 reserved1;
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/ne=
t/ethernet/marvell/mvpp2/mvpp2_main.c
> index 307f9fd..11c56d2 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -385,7 +385,7 @@ static int mvpp2_bm_pool_create(struct device *dev, s=
truct mvpp2 *priv,
>         if (!IS_ALIGNED(size, 16))
>                 return -EINVAL;
>
> -       /* PPv2.1 needs 8 bytes per buffer pointer, PPv2.2 needs 16
> +       /* PPv2.1 needs 8 bytes per buffer pointer, PPv2.2 and PPv2.3 nee=
ds 16

s/needs 16/need 16/

>          * bytes per buffer pointer
>          */
>         if (priv->hw_version =3D=3D MVPP21)
> @@ -1173,7 +1173,7 @@ static void mvpp2_interrupts_unmask(void *arg)
>         u32 val;
>         int i;
>
> -       if (port->priv->hw_version !=3D MVPP22)
> +       if (port->priv->hw_version =3D=3D MVPP21)
>                 return;

This change should go to "net: mvpp2: always compare hw-version vs
MVPP21" patch. Please also swap order of those 2 commits - the
preparation patch should go before MVPP23 addition.

Thanks,
Marcin

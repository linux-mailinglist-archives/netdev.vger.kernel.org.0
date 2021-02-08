Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452B3312C41
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 09:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhBHIuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 03:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbhBHIrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 03:47:51 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D8EC06178B
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 00:47:11 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id p12so1694773qvv.5
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 00:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xV1p38CxkIVydrmrIeBsHFFOrTaFyXrKNcrX5Rxf+CA=;
        b=jAVwJd5TV7v0XygTlDgr8i80lGZaojREOV0OWhQM8vO8EwHcPyue9rNXBTOfjU2C0W
         edNa5u5kvDdXS3iCvPfiKn+YaODD7OdHZclO+xI6q2hFYCW7FQLjT9vDcZ7mEtfSQd15
         gTC8ZEXjGfDVBHCDI0aQm6mNl3wASzut1MTv+vMmDJlilQO8/LEiub/TQGnSazNkaOYd
         HQqAA+NotpTj4ZvbR8GVUIR1fzAVplSllZAgp5hO0YF6FI3njNRoSM8uSprztY1MCoLt
         L0sFq9fJCYDhNvifRmMlfeJMO8KxXWNc6Y0b4wGyzsLmDh1E5h2cG/MzQNSS341LFLXN
         mBaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xV1p38CxkIVydrmrIeBsHFFOrTaFyXrKNcrX5Rxf+CA=;
        b=KeS5lK1cq+eG9QjCsO05xiAozr75khDdfPPQK9x2MwMXEhlhiyhEmr3uvNOR8U79e2
         BQ2arLQsCuv1kkIBD78DT7kMZhzMj4vu3YpeJK1lVfsij6G4A7WMgw92+6We2nznv2gz
         /l6g5eBGcKxE+V1vlzrBGq/VljD1lFFNH2FqK5kgTXZjdJfjhTbZ1ncJPH711LP5I1VN
         zaj9YrF5d7LHlOSv60V/FFz7Ct5KanPIkLpC4njXkQlKYtSguLoYyQZZX13YMeogJUt2
         ejyhuX0GxvPI+8JQD7+nVDfEvMm7H6Zh4PszUkK8/2UPgtbU/Z2hL2rHsFmxWuim/D2j
         cmlQ==
X-Gm-Message-State: AOAM533G0PSwLg6Hq4ada7Va1l4KSKXY9pTs/jiu/GmlC5rjQSm5B4hC
        CW5Oel1T7KPMwqANRuIKTR2KWKRkYOBIwxXSt/gX6w==
X-Google-Smtp-Source: ABdhPJxffJg6zkK7/jgcbmmmwAD2ytDzCLJVAyIQzxFQnsuVT+hc7i9LIdyMtAGz7cNH26iJBtyucBzcfz9RU8El7Tc=
X-Received: by 2002:a0c:c509:: with SMTP id x9mr14911433qvi.59.1612774029639;
 Mon, 08 Feb 2021 00:47:09 -0800 (PST)
MIME-Version: 1.0
References: <1612773167-22490-1-git-send-email-stefanc@marvell.com> <1612773167-22490-6-git-send-email-stefanc@marvell.com>
In-Reply-To: <1612773167-22490-6-git-send-email-stefanc@marvell.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Mon, 8 Feb 2021 09:46:59 +0100
Message-ID: <CAPv3WKczH5YgDiCuwmdLp7njF7YTfXmQmUNo3U8v=Rto2RUrbA@mail.gmail.com>
Subject: Re: [PATCH v10 net-next 05/15] net: mvpp2: add PPv23 version definition
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, nadavh@marvell.com,
        Yan Markman <ymarkman@marvell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>, atenart@kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        =?UTF-8?Q?Gr=C3=A9gory_Clement?= <gregory.clement@bootlin.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

pon., 8 lut 2021 o 09:33 <stefanc@marvell.com> napisa=C5=82(a):
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
> index 56e90ab..ce08086 100644
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
> @@ -927,15 +930,16 @@ struct mvpp2 {
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
> @@ -977,7 +981,7 @@ struct mvpp2 {
>         u32 tclk;
>
>         /* HW version */
> -       enum { MVPP21, MVPP22 } hw_version;
> +       enum { MVPP21, MVPP22, MVPP23 } hw_version;
>
>         /* Maximum number of RXQs per port */
>         unsigned int max_port_rxqs;
> @@ -1221,7 +1225,7 @@ struct mvpp21_rx_desc {
>         __le32 reserved8;
>  };
>
> -/* HW TX descriptor for PPv2.2 */
> +/* HW TX descriptor for PPv2.2 and PPv2.3 */
>  struct mvpp22_tx_desc {
>         __le32 command;
>         u8  packet_offset;
> @@ -1233,7 +1237,7 @@ struct mvpp22_tx_desc {
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
> index e9c5916..5730900 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -384,7 +384,7 @@ static int mvpp2_bm_pool_create(struct device *dev, s=
truct mvpp2 *priv,
>         if (!IS_ALIGNED(size, 16))
>                 return -EINVAL;
>
> -       /* PPv2.1 needs 8 bytes per buffer pointer, PPv2.2 needs 16
> +       /* PPv2.1 needs 8 bytes per buffer pointer, PPv2.2 and PPv2.3 nee=
ds 16
>          * bytes per buffer pointer
>          */
>         if (priv->hw_version =3D=3D MVPP21)
> @@ -1172,7 +1172,7 @@ static void mvpp2_interrupts_unmask(void *arg)
>         u32 val;
>         int i;
>
> -       if (port->priv->hw_version !=3D MVPP22)
> +       if (port->priv->hw_version =3D=3D MVPP21)
>                 return;

As requested previously, please move above check to 'net: mvpp2:
always compare hw-version vs MVPP21' patch.

Thanks,
Marcin

>
>         if (mask)
> @@ -5456,7 +5456,7 @@ static void mvpp2_rx_irqs_setup(struct mvpp2_port *=
port)
>                 return;
>         }
>
> -       /* Handle the more complicated PPv2.2 case */
> +       /* Handle the more complicated PPv2.2 and PPv2.3 case */
>         for (i =3D 0; i < port->nqvecs; i++) {
>                 struct mvpp2_queue_vector *qv =3D port->qvecs + i;
>
> @@ -5633,7 +5633,7 @@ static bool mvpp22_port_has_legacy_tx_irqs(struct d=
evice_node *port_node,
>
>  /* Checks if the port dt description has the required Tx interrupts:
>   * - PPv2.1: there are no such interrupts.
> - * - PPv2.2:
> + * - PPv2.2 and PPv2.3:
>   *   - The old DTs have: "rx-shared", "tx-cpuX" with X in [0...3]
>   *   - The new ones have: "hifX" with X in [0..8]
>   *
> @@ -6621,7 +6621,7 @@ static void mvpp22_rx_fifo_set_hw(struct mvpp2 *pri=
v, int port, int data_size)
>         mvpp2_write(priv, MVPP2_RX_ATTR_FIFO_SIZE_REG(port), attr_size);
>  }
>
> -/* Initialize TX FIFO's: the total FIFO size is 48kB on PPv2.2.
> +/* Initialize TX FIFO's: the total FIFO size is 48kB on PPv2.2 and PPv2.=
3.
>   * 4kB fixed space must be assigned for the loopback port.
>   * Redistribute remaining avialable 44kB space among all active ports.
>   * Guarantee minimum 32kB for 10G port and 8kB for port 1, capable of 2.=
5G
> @@ -6678,7 +6678,7 @@ static void mvpp22_tx_fifo_set_hw(struct mvpp2 *pri=
v, int port, int size)
>         mvpp2_write(priv, MVPP22_TX_FIFO_THRESH_REG(port), threshold);
>  }
>
> -/* Initialize TX FIFO's: the total FIFO size is 19kB on PPv2.2.
> +/* Initialize TX FIFO's: the total FIFO size is 19kB on PPv2.2 and PPv2.=
3.
>   * 3kB fixed space must be assigned for the loopback port.
>   * Redistribute remaining avialable 16kB space among all active ports.
>   * The 10G interface should use 10kB (which is maximum possible size
> @@ -7049,6 +7049,11 @@ static int mvpp2_probe(struct platform_device *pde=
v)
>                         priv->port_map |=3D BIT(i);
>         }
>
> +       if (priv->hw_version !=3D MVPP21) {
> +               if (mvpp2_read(priv, MVPP2_VER_ID_REG) =3D=3D MVPP2_VER_P=
P23)
> +                       priv->hw_version =3D MVPP23;
> +       }
> +
>         /* Initialize network controller */
>         err =3D mvpp2_init(pdev, priv);
>         if (err < 0) {
> --
> 1.9.1
>

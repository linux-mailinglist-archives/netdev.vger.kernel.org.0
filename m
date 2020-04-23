Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45EBF1B5B64
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 14:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgDWM1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 08:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726105AbgDWM1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 08:27:51 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8B8C08E859;
        Thu, 23 Apr 2020 05:27:50 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id t12so4192583edw.3;
        Thu, 23 Apr 2020 05:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3YODsxHKh3+gYik4nxqvD1Fs/lq1MAv8RtUoSUQEtQ0=;
        b=quR0lZjJMJ76yrAFa03h3aKM/vVQyQ01lr2A8i0ktFJ4AgwbXxrJSeDPGXUZYXHNV3
         tczIuArHrKUqsWmqma2TlKaZp3ArO1dFwfsNfgmJB/H7O8GLPtDKaDGykUVVO2xIOupm
         +/5OZayOQBsGgw5oqeUeNrDF75V8PKiIve3iSjOVAN1BcDyE7vk5YV5ZvKMzcliI3IcP
         AE1fb+LF4P0bJcTpQzu8SxAhEnvQVgE2LwNDzFQVYHgs9Tf/fvk4365eYwOJJpTNQ+Ki
         4x00m4vOW1kOr4L53qz9N8Ju1qGGYP3PPGCt0XpOYPHMC5DIgC55flwg+1u14Yz1x328
         RpHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3YODsxHKh3+gYik4nxqvD1Fs/lq1MAv8RtUoSUQEtQ0=;
        b=OhK2E2GvffXIz1blGjdZNOxWiauIY1DZzOtirNfkeB9h4tZA66775Rw/BkJ4eGpI2A
         3wuxEFjrOEmwKrJU+mHHaC97LM2SoXsLKyrOOWCcT07RwSrQh8DozrUAJMe/SlAw3fWG
         ucr6NpXwHA8LPUjc6OSF4dsBUAZ5VCawWMJNVOiFTE5ADA6rmhFoOpWiEYfn/BXNKkvj
         qpjRRS6zuiBd/g/e8u3WE7lPr5ynJnHK0Dx/qMW0O7C94b7VNhTTVdKmdZy1FWW9Ku/I
         Ypk8hollzLsMbCA+62rsh5cKTxRb4lwmxzYHZTCqhT3Czp9j22ibhWNBWXLPf8Dim35m
         4nbg==
X-Gm-Message-State: AGi0PuYdsJWv6JCBnU66EUwmqhdecBK6ZlAAoZbPnWMMYi0VoF3kmD8S
        vvA4J1dPuUizAaTDZHm19WOYaCAHYocpbV3iHoE=
X-Google-Smtp-Source: APiQypKKiCmIvPP3hDfQ1tDIv8YbGVkm6z5WzLXKuGfV/VtSBQdgzeb6EdpEXHKL9RFD33VT85N0wH3zsk6exq3Jx8U=
X-Received: by 2002:a50:f288:: with SMTP id f8mr2477116edm.337.1587644869194;
 Thu, 23 Apr 2020 05:27:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200420232624.9127-1-michael@walle.cc> <20200420232624.9127-3-michael@walle.cc>
In-Reply-To: <20200420232624.9127-3-michael@walle.cc>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 23 Apr 2020 15:27:38 +0300
Message-ID: <CA+h21hrLf+L1Aa8mY-qCfPWY3bVLVMFCCLx_Af66EhRRX5f6Fg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 3/3] net: phy: mscc: use phy_package_shared
To:     Michael Walle <michael@walle.cc>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Tue, 21 Apr 2020 at 02:28, Michael Walle <michael@walle.cc> wrote:
>
> Use the new phy_package_shared common storage to ease the package
> initialization and to access the global registers.
>
> This was only compile-time tested!
>
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---

I happen to have a board with a VSC8514 PHY. For this driver, only the "Fast
Link Failure Indication" feature seems to be configured via
phy_base_write/__phy_package_write. Functionally I can't test it, because the
GPIO9 pin is not wired on my board. But I could at least check that the value
that should be written can be read back from all PHYs in the package:

Microsemi GE VSC8514 SyncE 0000:00:00.3:10: reading 0x400f from
MSCC_PHY_MAC_CFG_FASTLINK
swp0: PHY [0000:00:00.3:10] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
Microsemi GE VSC8514 SyncE 0000:00:00.3:11: reading 0x400f from
MSCC_PHY_MAC_CFG_FASTLINK
0000:00:00.5 swp1: PHY [0000:00:00.3:11] driver [Microsemi GE VSC8514
SyncE] (irq=POLL)
Microsemi GE VSC8514 SyncE 0000:00:00.3:12: reading 0x400f from
MSCC_PHY_MAC_CFG_FASTLINK
0000:00:00.5 swp2: PHY [0000:00:00.3:12] driver [Microsemi GE VSC8514
SyncE] (irq=POLL)
Microsemi GE VSC8514 SyncE 0000:00:00.3:13: reading 0x400f from
MSCC_PHY_MAC_CFG_FASTLINK
0000:00:00.5 swp3: PHY [0000:00:00.3:13] driver [Microsemi GE VSC8514
SyncE] (irq=POLL)

So assuming that the feature worked before, it looks like there is no
regression. Of course, the PHY still passes traffic just fine.

So you can add my:

Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  drivers/net/phy/mscc/mscc.h      |  1 -
>  drivers/net/phy/mscc/mscc_main.c | 99 ++++++++++----------------------
>  2 files changed, 29 insertions(+), 71 deletions(-)
>
> diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
> index 030bf8b600df..acdd8ee61a39 100644
> --- a/drivers/net/phy/mscc/mscc.h
> +++ b/drivers/net/phy/mscc/mscc.h
> @@ -353,7 +353,6 @@ struct vsc8531_private {
>         const struct vsc85xx_hw_stat *hw_stats;
>         u64 *stats;
>         int nstats;
> -       bool pkg_init;
>         /* For multiple port PHYs; the MDIO address of the base PHY in the
>          * package.
>          */
> diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
> index 5391acdece05..382b56064de9 100644
> --- a/drivers/net/phy/mscc/mscc_main.c
> +++ b/drivers/net/phy/mscc/mscc_main.c
> @@ -691,27 +691,23 @@ static int vsc85xx_eee_init_seq_set(struct phy_device *phydev)
>  /* phydev->bus->mdio_lock should be locked when using this function */
>  static int phy_base_write(struct phy_device *phydev, u32 regnum, u16 val)
>  {
> -       struct vsc8531_private *priv = phydev->priv;
> -
>         if (unlikely(!mutex_is_locked(&phydev->mdio.bus->mdio_lock))) {
>                 dev_err(&phydev->mdio.dev, "MDIO bus lock not held!\n");
>                 dump_stack();
>         }
>
> -       return __mdiobus_write(phydev->mdio.bus, priv->base_addr, regnum, val);
> +       return __phy_package_write(phydev, regnum, val);
>  }
>
>  /* phydev->bus->mdio_lock should be locked when using this function */
>  static int phy_base_read(struct phy_device *phydev, u32 regnum)
>  {
> -       struct vsc8531_private *priv = phydev->priv;
> -
>         if (unlikely(!mutex_is_locked(&phydev->mdio.bus->mdio_lock))) {
>                 dev_err(&phydev->mdio.dev, "MDIO bus lock not held!\n");
>                 dump_stack();
>         }
>
> -       return __mdiobus_read(phydev->mdio.bus, priv->base_addr, regnum);
> +       return __phy_package_read(phydev, regnum);
>  }
>
>  /* bus->mdio_lock should be locked when using this function */
> @@ -1287,65 +1283,36 @@ static int vsc8584_config_pre_init(struct phy_device *phydev)
>         return ret;
>  }
>
> -/* Check if one PHY has already done the init of the parts common to all PHYs
> - * in the Quad PHY package.
> - */
> -static bool vsc8584_is_pkg_init(struct phy_device *phydev, bool reversed)
> +static void vsc8584_get_base_addr(struct phy_device *phydev)
>  {
> -       struct mii_bus *bus = phydev->mdio.bus;
> -       struct vsc8531_private *vsc8531;
> -       struct phy_device *phy;
> -       int i, addr;
> -
> -       /* VSC8584 is a Quad PHY */
> -       for (i = 0; i < 4; i++) {
> -               vsc8531 = phydev->priv;
> -
> -               if (reversed)
> -                       addr = vsc8531->base_addr - i;
> -               else
> -                       addr = vsc8531->base_addr + i;
> -
> -               phy = mdiobus_get_phy(bus, addr);
> -               if (!phy)
> -                       continue;
> +       struct vsc8531_private *vsc8531 = phydev->priv;
> +       u16 val, addr;
>
> -               if ((phy->phy_id & phydev->drv->phy_id_mask) !=
> -                   (phydev->drv->phy_id & phydev->drv->phy_id_mask))
> -                       continue;
> +       mutex_lock(&phydev->mdio.bus->mdio_lock);
> +       __phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_EXTENDED);
>
> -               vsc8531 = phy->priv;
> +       addr = __phy_read(phydev, MSCC_PHY_EXT_PHY_CNTL_4);
> +       addr >>= PHY_CNTL_4_ADDR_POS;
>
> -               if (vsc8531 && vsc8531->pkg_init)
> -                       return true;
> -       }
> +       val = __phy_read(phydev, MSCC_PHY_ACTIPHY_CNTL);
>
> -       return false;
> +       if (val & PHY_ADDR_REVERSED)
> +               vsc8531->base_addr = phydev->mdio.addr + addr;
> +       else
> +               vsc8531->base_addr = phydev->mdio.addr - addr;
> +       mutex_unlock(&phydev->mdio.bus->mdio_lock);
>  }
>
>  static int vsc8584_config_init(struct phy_device *phydev)
>  {
>         struct vsc8531_private *vsc8531 = phydev->priv;
> -       u16 addr, val;
>         int ret, i;
> +       u16 val;
>
>         phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
>
>         mutex_lock(&phydev->mdio.bus->mdio_lock);
>
> -       __mdiobus_write(phydev->mdio.bus, phydev->mdio.addr,
> -                       MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_EXTENDED);
> -       addr = __mdiobus_read(phydev->mdio.bus, phydev->mdio.addr,
> -                             MSCC_PHY_EXT_PHY_CNTL_4);
> -       addr >>= PHY_CNTL_4_ADDR_POS;
> -
> -       val = __mdiobus_read(phydev->mdio.bus, phydev->mdio.addr,
> -                            MSCC_PHY_ACTIPHY_CNTL);
> -       if (val & PHY_ADDR_REVERSED)
> -               vsc8531->base_addr = phydev->mdio.addr + addr;
> -       else
> -               vsc8531->base_addr = phydev->mdio.addr - addr;
> -
>         /* Some parts of the init sequence are identical for every PHY in the
>          * package. Some parts are modifying the GPIO register bank which is a
>          * set of registers that are affecting all PHYs, a few resetting the
> @@ -1359,7 +1326,7 @@ static int vsc8584_config_init(struct phy_device *phydev)
>          * do the correct init sequence for all PHYs that are package-critical
>          * in this pre-init function.
>          */
> -       if (!vsc8584_is_pkg_init(phydev, val & PHY_ADDR_REVERSED ? 1 : 0)) {
> +       if (phy_package_init_once(phydev)) {
>                 /* The following switch statement assumes that the lowest
>                  * nibble of the phy_id_mask is always 0. This works because
>                  * the lowest nibble of the PHY_ID's below are also 0.
> @@ -1388,8 +1355,6 @@ static int vsc8584_config_init(struct phy_device *phydev)
>                         goto err;
>         }
>
> -       vsc8531->pkg_init = true;
> -
>         phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
>                        MSCC_PHY_PAGE_EXTENDED_GPIO);
>
> @@ -1427,7 +1392,8 @@ static int vsc8584_config_init(struct phy_device *phydev)
>
>         /* Disable SerDes for 100Base-FX */
>         ret = vsc8584_cmd(phydev, PROC_CMD_FIBER_MEDIA_CONF |
> -                         PROC_CMD_FIBER_PORT(addr) | PROC_CMD_FIBER_DISABLE |
> +                         PROC_CMD_FIBER_PORT(vsc8531->base_addr) |
> +                         PROC_CMD_FIBER_DISABLE |
>                           PROC_CMD_READ_MOD_WRITE_PORT |
>                           PROC_CMD_RST_CONF_PORT | PROC_CMD_FIBER_100BASE_FX);
>         if (ret)
> @@ -1435,7 +1401,8 @@ static int vsc8584_config_init(struct phy_device *phydev)
>
>         /* Disable SerDes for 1000Base-X */
>         ret = vsc8584_cmd(phydev, PROC_CMD_FIBER_MEDIA_CONF |
> -                         PROC_CMD_FIBER_PORT(addr) | PROC_CMD_FIBER_DISABLE |
> +                         PROC_CMD_FIBER_PORT(vsc8531->base_addr) |
> +                         PROC_CMD_FIBER_DISABLE |
>                           PROC_CMD_READ_MOD_WRITE_PORT |
>                           PROC_CMD_RST_CONF_PORT | PROC_CMD_FIBER_1000BASE_X);
>         if (ret)
> @@ -1750,26 +1717,14 @@ static int vsc8514_config_init(struct phy_device *phydev)
>  {
>         struct vsc8531_private *vsc8531 = phydev->priv;
>         unsigned long deadline;
> -       u16 val, addr;
>         int ret, i;
> +       u16 val;
>         u32 reg;
>
>         phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
>
>         mutex_lock(&phydev->mdio.bus->mdio_lock);
>
> -       __phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_EXTENDED);
> -
> -       addr = __phy_read(phydev, MSCC_PHY_EXT_PHY_CNTL_4);
> -       addr >>= PHY_CNTL_4_ADDR_POS;
> -
> -       val = __phy_read(phydev, MSCC_PHY_ACTIPHY_CNTL);
> -
> -       if (val & PHY_ADDR_REVERSED)
> -               vsc8531->base_addr = phydev->mdio.addr + addr;
> -       else
> -               vsc8531->base_addr = phydev->mdio.addr - addr;
> -
>         /* Some parts of the init sequence are identical for every PHY in the
>          * package. Some parts are modifying the GPIO register bank which is a
>          * set of registers that are affecting all PHYs, a few resetting the
> @@ -1781,11 +1736,9 @@ static int vsc8514_config_init(struct phy_device *phydev)
>          * do the correct init sequence for all PHYs that are package-critical
>          * in this pre-init function.
>          */
> -       if (!vsc8584_is_pkg_init(phydev, val & PHY_ADDR_REVERSED ? 1 : 0))
> +       if (phy_package_init_once(phydev))
>                 vsc8514_config_pre_init(phydev);
>
> -       vsc8531->pkg_init = true;
> -
>         phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
>                        MSCC_PHY_PAGE_EXTENDED_GPIO);
>
> @@ -1991,6 +1944,9 @@ static int vsc8514_probe(struct phy_device *phydev)
>
>         phydev->priv = vsc8531;
>
> +       vsc8584_get_base_addr(phydev);
> +       devm_phy_package_join(&phydev->mdio.dev, phydev, vsc8531->base_addr);
> +
>         vsc8531->nleds = 4;
>         vsc8531->supp_led_modes = VSC85XX_SUPP_LED_MODES;
>         vsc8531->hw_stats = vsc85xx_hw_stats;
> @@ -2046,6 +2002,9 @@ static int vsc8584_probe(struct phy_device *phydev)
>
>         phydev->priv = vsc8531;
>
> +       vsc8584_get_base_addr(phydev);
> +       devm_phy_package_join(&phydev->mdio.dev, phydev, vsc8531->base_addr);
> +
>         vsc8531->nleds = 4;
>         vsc8531->supp_led_modes = VSC8584_SUPP_LED_MODES;
>         vsc8531->hw_stats = vsc8584_hw_stats;
> --
> 2.20.1
>

Thanks,
-Vladimir

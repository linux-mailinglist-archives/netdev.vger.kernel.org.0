Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CC74FAC27
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 07:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbiDJFOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 01:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiDJFOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 01:14:43 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5D258807;
        Sat,  9 Apr 2022 22:12:33 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-e2afb80550so2008360fac.1;
        Sat, 09 Apr 2022 22:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HG7xcfqBGlzKRwp4NEEFV3WOMPmg/bdlcrlck/Cc0aY=;
        b=N4NLii1dj1S2luA1gdk1+G1KMWMcoe1Gki/EIzfb6PQAvAdEmMRTGQBVqCJY4xnUG/
         KDNdf+XLEVBNsAlZrVLXvyndufCVMW7jQ0ONAC4xfnfHca5NxjB/5o2KFPpsVqYb7MpS
         e8FBeSpgjNRsmCE8Tw+rFihD6QpiYFEMLSakFDrhp7oB/kfNtJzpMvCVRFAGbisEU1X+
         7JOOqexVMXuLVp+7FRmTFvjvj1QUqmQAfiSmwnmImDJKBa9eZQGpUgHF1Zjj++OwFq46
         mYoR/7ZXOLvgN5sJPeEnqUeuUGV5SUv92YOkgLvr6Fjs/r5kxe3b2cFp4u432JEkjG36
         ymCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HG7xcfqBGlzKRwp4NEEFV3WOMPmg/bdlcrlck/Cc0aY=;
        b=PfANTymffOoiEqfkBahrjos8h/msn3BvmJ72xdGYN5taJ6FqRBgHCtO8NbVcNNeOjP
         iU0Di/QGzOEFg9HHvGPnxDJsxstoJf+X/VllBDNNCuiTpK3TPKcTCLmxKu+KaPOVUAim
         FEyha7pY/b1MoJel1cTyY20IbitKdza91z8nryy6roWSCFqmurforv4R/1Zo5Tflo+Ne
         J0DYB4dmI1SdL3jS0qi5xCXM24DRD9rfzqk6Kb10uq3JcyG7AEJmJT3KmyELtcRzGGh8
         ypJ1gDTFGPdB3iSkpny+nwUWIy8TKA/BxgRbDCwKbR21E/PwrduQhKFIdScqYLhCobqd
         ueuw==
X-Gm-Message-State: AOAM532rYM4cu1uIUhLWEbXHnOcLkIRRsmQ5f+LwnYLEwoHxyO8mRBOp
        r9cdHWUFPnoELoLoQ/jw/6LZvuH0/D+3cbr9jmU=
X-Google-Smtp-Source: ABdhPJw6wZRHfpQKrvIGryczhYLHnDY6PIygXpCv+Wlvds9rTlxJbmB/DA/yfdDQp1qiTMdEW5mf7sy5fXnXIDx1GMk=
X-Received: by 2002:a05:6870:5493:b0:e1:eb7a:2283 with SMTP id
 f19-20020a056870549300b000e1eb7a2283mr11814757oan.138.1649567553209; Sat, 09
 Apr 2022 22:12:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220324112620.46963-1-alexandru.tachici@analog.com>
 <20220324112620.46963-6-alexandru.tachici@analog.com> <CAGi-RUJLmT-jfjtaYvPjaNHX-QCohhkZ3rkXaHHbmOHk56jTaA@mail.gmail.com>
In-Reply-To: <CAGi-RUJLmT-jfjtaYvPjaNHX-QCohhkZ3rkXaHHbmOHk56jTaA@mail.gmail.com>
From:   Ramon Fried <rfried.dev@gmail.com>
Date:   Sun, 10 Apr 2022 08:12:22 +0300
Message-ID: <CAGi-RULmscYaKvRXPQSwJg5hZe0kuysxuijEZKo54Aya2=jHRw@mail.gmail.com>
Subject: Re: [PATCH v5 5/7] net: phy: adin1100: Add initial support for
 ADIN1100 industrial PHY
To:     alexandru.tachici@analog.com
Cc:     andrew@lunn.ch, o.rempel@pengutronix.de, davem@davemloft.net,
        devicetree@vger.kernel.org, hkallweit1@gmail.com, kuba@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux@armlinux.org.uk,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 10, 2022 at 8:11 AM Ramon Fried <rfried.dev@gmail.com> wrote:
>
> On Fri, Mar 25, 2022 at 8:53 PM <alexandru.tachici@analog.com> wrote:
> >
> > From: Alexandru Ardelean <alexandru.ardelean@analog.com>
> >
> > The ADIN1100 is a low power single port 10BASE-T1L transceiver designed for
> > industrial Ethernet applications and is compliant with the IEEE 802.3cg
> > Ethernet standard for long reach 10 Mb/s Single Pair Ethernet.
> >
> > Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> > Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> > ---
> >  drivers/net/phy/Kconfig    |   7 ++
> >  drivers/net/phy/Makefile   |   1 +
> >  drivers/net/phy/adin1100.c | 247 +++++++++++++++++++++++++++++++++++++
> >  3 files changed, 255 insertions(+)
> >  create mode 100644 drivers/net/phy/adin1100.c
> >
> > diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> > index ea7571a2b39b..bbbf6c07ea53 100644
> > --- a/drivers/net/phy/Kconfig
> > +++ b/drivers/net/phy/Kconfig
> > @@ -83,6 +83,13 @@ config ADIN_PHY
> >           - ADIN1300 - Robust,Industrial, Low Latency 10/100/1000 Gigabit
> >             Ethernet PHY
> >
> > +config ADIN1100_PHY
> > +       tristate "Analog Devices Industrial Ethernet T1L PHYs"
> > +       help
> > +         Adds support for the Analog Devices Industrial T1L Ethernet PHYs.
> > +         Currently supports the:
> > +         - ADIN1100 - Robust,Industrial, Low Power 10BASE-T1L Ethernet PHY
> > +
> >  config AQUANTIA_PHY
> >         tristate "Aquantia PHYs"
> >         help
> > diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> > index b2728d00fc9a..b82651b57043 100644
> > --- a/drivers/net/phy/Makefile
> > +++ b/drivers/net/phy/Makefile
> > @@ -31,6 +31,7 @@ sfp-obj-$(CONFIG_SFP)         += sfp-bus.o
> >  obj-y                          += $(sfp-obj-y) $(sfp-obj-m)
> >
> >  obj-$(CONFIG_ADIN_PHY)         += adin.o
> > +obj-$(CONFIG_ADIN1100_PHY)     += adin1100.o
> >  obj-$(CONFIG_AMD_PHY)          += amd.o
> >  aquantia-objs                  += aquantia_main.o
> >  ifdef CONFIG_HWMON
> > diff --git a/drivers/net/phy/adin1100.c b/drivers/net/phy/adin1100.c
> > new file mode 100644
> > index 000000000000..23d1ae61e0ef
> > --- /dev/null
> > +++ b/drivers/net/phy/adin1100.c
> > @@ -0,0 +1,247 @@
> > +// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
> > +/*
> > + *  Driver for Analog Devices Industrial Ethernet T1L PHYs
> > + *
> > + * Copyright 2020 Analog Devices Inc.
> > + */
> > +#include <linux/kernel.h>
> > +#include <linux/bitfield.h>
> > +#include <linux/delay.h>
> > +#include <linux/errno.h>
> > +#include <linux/init.h>
> > +#include <linux/module.h>
> > +#include <linux/mii.h>
> > +#include <linux/phy.h>
> > +#include <linux/property.h>
> > +
> > +#define PHY_ID_ADIN1100                                0x0283bc81
> > +
> > +#define ADIN_FORCED_MODE                       0x8000
> > +#define   ADIN_FORCED_MODE_EN                  BIT(0)
> > +
> > +#define ADIN_CRSM_SFT_RST                      0x8810
> > +#define   ADIN_CRSM_SFT_RST_EN                 BIT(0)
> > +
> > +#define ADIN_CRSM_SFT_PD_CNTRL                 0x8812
> > +#define   ADIN_CRSM_SFT_PD_CNTRL_EN            BIT(0)
> > +
> > +#define ADIN_AN_PHY_INST_STATUS                        0x8030
> > +#define   ADIN_IS_CFG_SLV                      BIT(2)
> > +#define   ADIN_IS_CFG_MST                      BIT(3)
> > +
> > +#define ADIN_CRSM_STAT                         0x8818
> > +#define   ADIN_CRSM_SFT_PD_RDY                 BIT(1)
> > +#define   ADIN_CRSM_SYS_RDY                    BIT(0)
> > +
> > +/**
> > + * struct adin_priv - ADIN PHY driver private data
> > + * @tx_level_2v4_able:         set if the PHY supports 2.4V TX levels (10BASE-T1L)
> > + * @tx_level_2v4:              set if the PHY requests 2.4V TX levels (10BASE-T1L)
> > + * @tx_level_prop_present:     set if the TX level is specified in DT
> > + */
> > +struct adin_priv {
> > +       unsigned int            tx_level_2v4_able:1;
> > +       unsigned int            tx_level_2v4:1;
> > +       unsigned int            tx_level_prop_present:1;
> > +};
> > +
> > +static int adin_read_status(struct phy_device *phydev)
> > +{
> > +       int ret;
> > +
> > +       ret = genphy_c45_read_status(phydev);
> > +       if (ret)
> > +               return ret;
> > +
> > +       ret = phy_read_mmd(phydev, MDIO_MMD_AN, ADIN_AN_PHY_INST_STATUS);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       if (ret & ADIN_IS_CFG_SLV)
> > +               phydev->master_slave_state = MASTER_SLAVE_STATE_SLAVE;
> > +
> > +       if (ret & ADIN_IS_CFG_MST)
> > +               phydev->master_slave_state = MASTER_SLAVE_STATE_MASTER;
> > +
> > +       return 0;
> > +}
> > +
> > +static int adin_config_aneg(struct phy_device *phydev)
> > +{
> > +       struct adin_priv *priv = phydev->priv;
> > +       int ret;
> > +
> > +       if (phydev->autoneg == AUTONEG_DISABLE) {
> > +               ret = genphy_c45_pma_setup_forced(phydev);
> > +               if (ret < 0)
> > +                       return ret;
> > +
> > +               if (priv->tx_level_prop_present && priv->tx_level_2v4) {
> > +                       ret = phy_set_bits_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_B10L_PMA_CTRL,
> > +                                              MDIO_PMA_10T1L_CTRL_2V4_EN);
> > +                       if (ret < 0)
> > +                               return ret;
> > +               } else {
> > +                       ret = phy_clear_bits_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_B10L_PMA_CTRL,
> > +                                                MDIO_PMA_10T1L_CTRL_2V4_EN);
> > +                       if (ret < 0)
> > +                               return ret;
> > +               }
> > +
> > +               /* Force PHY to use above configurations */
> > +               return phy_set_bits_mmd(phydev, MDIO_MMD_AN, ADIN_FORCED_MODE, ADIN_FORCED_MODE_EN);
> > +       }
> > +
> > +       ret = phy_clear_bits_mmd(phydev, MDIO_MMD_AN, ADIN_FORCED_MODE, ADIN_FORCED_MODE_EN);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       /* Request increased transmit level from LP. */
> > +       if (priv->tx_level_prop_present && priv->tx_level_2v4) {
> > +               ret = phy_set_bits_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_H,
> > +                                      MDIO_AN_T1_ADV_H_10L_TX_HI |
> > +                                      MDIO_AN_T1_ADV_H_10L_TX_HI_REQ);
> > +               if (ret < 0)
> > +                       return ret;
> > +       }
> > +
> > +       /* Disable 2.4 Vpp transmit level. */
> > +       if ((priv->tx_level_prop_present && !priv->tx_level_2v4) || !priv->tx_level_2v4_able) {
> > +               ret = phy_clear_bits_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_H,
> > +                                        MDIO_AN_T1_ADV_H_10L_TX_HI |
> > +                                        MDIO_AN_T1_ADV_H_10L_TX_HI_REQ);
> > +               if (ret < 0)
> > +                       return ret;
> > +       }
> > +
> > +       return genphy_c45_config_aneg(phydev);
> > +}
> > +
> > +static int adin_set_powerdown_mode(struct phy_device *phydev, bool en)
> > +{
> > +       int ret;
> > +       int val;
> > +
> > +       if (en)
> > +               val = ADIN_CRSM_SFT_PD_CNTRL_EN;
> > +       else
> > +               val = 0;
> > +
> > +       ret = phy_write_mmd(phydev, MDIO_MMD_VEND1,
> > +                           ADIN_CRSM_SFT_PD_CNTRL, val);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       return phy_read_mmd_poll_timeout(phydev, MDIO_MMD_VEND1, ADIN_CRSM_STAT, ret,
> > +                                        (ret & ADIN_CRSM_SFT_PD_RDY) == val,
> > +                                        1000, 30000, true);
> > +}
> > +
> > +static int adin_suspend(struct phy_device *phydev)
> > +{
> > +       return adin_set_powerdown_mode(phydev, true);
> > +}
> > +
> > +static int adin_resume(struct phy_device *phydev)
> > +{
> > +       return adin_set_powerdown_mode(phydev, false);
> > +}
> > +
> > +static int adin_set_loopback(struct phy_device *phydev, bool enable)
> > +{
> > +       if (enable)
> > +               return phy_set_bits_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_10T1L_CTRL,
> > +                                       BMCR_LOOPBACK);
> > +
> > +       /* PCS loopback (according to 10BASE-T1L spec) */
> > +       return phy_clear_bits_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_10T1L_CTRL,
> > +                                BMCR_LOOPBACK);
> > +}
> > +
> > +static int adin_soft_reset(struct phy_device *phydev)
> > +{
> > +       int ret;
> > +
> > +       ret = phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, ADIN_CRSM_SFT_RST, ADIN_CRSM_SFT_RST_EN);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       return phy_read_mmd_poll_timeout(phydev, MDIO_MMD_VEND1, ADIN_CRSM_STAT, ret,
> > +                                        (ret & ADIN_CRSM_SYS_RDY),
> > +                                        10000, 30000, true);
> > +}
> > +
> > +static int adin_get_features(struct phy_device *phydev)
> > +{
> > +       struct adin_priv *priv = phydev->priv;
> > +       struct device *dev = &phydev->mdio.dev;
> > +       int ret;
> > +       u8 val;
> > +
> > +       ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_10T1L_STAT);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       /* This depends on the voltage level from the power source */
> > +       priv->tx_level_2v4_able = !!(ret & MDIO_PMA_10T1L_STAT_2V4_ABLE);
> > +
> > +       phydev_dbg(phydev, "PHY supports 2.4V TX level: %s\n",
> > +                  priv->tx_level_2v4_able ? "yes" : "no");
> > +
> > +       priv->tx_level_prop_present = device_property_present(dev, "phy-10base-t1l-2.4vpp");
> > +       if (priv->tx_level_prop_present) {
> > +               ret = device_property_read_u8(dev, "phy-10base-t1l-2.4vpp", &val);
> > +               if (ret < 0)
> > +                       return ret;
> > +
> > +               priv->tx_level_2v4 = val;
> > +               if (!priv->tx_level_2v4 && priv->tx_level_2v4_able)
> > +                       phydev_info(phydev,
> > +                                   "PHY supports 2.4V TX level, but disabled via config\n");
> > +       }
> > +
> > +       linkmode_set_bit_array(phy_basic_ports_array, ARRAY_SIZE(phy_basic_ports_array),
> > +                              phydev->supported);
> > +
> > +       return genphy_c45_pma_read_abilities(phydev);
> > +}
> > +
> > +static int adin_probe(struct phy_device *phydev)
> > +{
> > +       struct device *dev = &phydev->mdio.dev;
> > +       struct adin_priv *priv;
> > +
> > +       priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> > +       if (!priv)
> > +               return -ENOMEM;
> > +
> > +       phydev->priv = priv;
> > +
> > +       return 0;
> > +}
> > +
> > +static struct phy_driver adin_driver[] = {
> > +       {
> > +               PHY_ID_MATCH_MODEL(PHY_ID_ADIN1100),
> > +               .name                   = "ADIN1100",
> > +               .get_features           = adin_get_features,
> > +               .soft_reset             = adin_soft_reset,
> > +               .probe                  = adin_probe,
> > +               .config_aneg            = adin_config_aneg,
> > +               .read_status            = adin_read_status,
> > +               .set_loopback           = adin_set_loopback,
> > +               .suspend                = adin_suspend,
> > +               .resume                 = adin_resume,
> > +       },
> > +};
> > +
> > +module_phy_driver(adin_driver);
> > +
> > +static struct mdio_device_id __maybe_unused adin_tbl[] = {
> > +       { PHY_ID_MATCH_MODEL(PHY_ID_ADIN1100) },
> > +       { }
> > +};
> > +
> > +MODULE_DEVICE_TABLE(mdio, adin_tbl);
> > +MODULE_DESCRIPTION("Analog Devices Industrial Ethernet T1L PHY driver");
> > +MODULE_LICENSE("Dual BSD/GPL");
> > --
> > 2.25.1
> >
> Hi.
> Got two submissions for both drivers in parallel.
> https://patchwork.ozlabs.org/project/uboot/patch/20220408162814.227120-1-nate.d@variscite.com/
> are you aware of each other ?
Ignore last mail. I should go to sleep....

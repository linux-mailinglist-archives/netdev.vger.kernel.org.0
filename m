Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A634A2C179F
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 22:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729803AbgKWVXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 16:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgKWVXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 16:23:08 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D213C0613CF;
        Mon, 23 Nov 2020 13:23:08 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id q206so21263342oif.13;
        Mon, 23 Nov 2020 13:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3C2xhshQJyHb7JkCpa57kCrrta51vRTCFz1yuD+sjLY=;
        b=C6ia7Kv8wg7ggwMpudS7YPognDf9iBNFaqINo2mAG4NWCgB8JJl10ZEK+3LVDNB+xq
         Ll20ZKzyrF5xYDATb/o63ZNBvluaRxlNsl/npvSkyqWmL8L4moqeQ3kJh76sj5ytepUe
         dB/HjejQUsCrBecXM6kH54AtWRgEKGn1KJxUc1r2fnebb9FHwZWX8FMOw36sPF3gnHD/
         gPMrewEjN9MRXho3IIOqpObcWit7XNFeoeQdG7sVrB3p900jvU9Su4gmeBr/cZ2Ykrcp
         fXkkQu8xeVPLlQElWLBWiuFxUN7YTrxevlxZ6eA9De15vr6605IWpEX39M0+tpvybUE1
         sm4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3C2xhshQJyHb7JkCpa57kCrrta51vRTCFz1yuD+sjLY=;
        b=DbKxTIBTrsLuseohVQKg1jrH/RiMnXkA36E6NpFW2bWhV+P8rjU1ht8PxCU9/4T/mi
         fnLK9dVKGrN9C0/+wf33BxaN7bIzqZAWUyChaSaDwQVV6rp4ndfA52L7wLeLSbP7qcj6
         cUs5afnmx6WcokI/827RCRGb1O8+m4VcoLW25llPS4GH35L1dlzreAjFYDUgpd/0cZ0r
         ZnI/MrSfMC5LexaUw6pBgLh5M+vLQ7zF/WmAaaUrlXuv9DH9Wb4VmhQ0uqAbJaFW5U5r
         l5WodX3DBo1fWgzKOopF2CvzBnTkcmq8IP6lVq1Q2J30Zwfpbc5OC2iv71zukXrO5GfS
         N3RA==
X-Gm-Message-State: AOAM533jmkXURIMTgYdSsZnt+iHo8mSR3tiBsqa87PEO7iaRSzm6g9nU
        5KfXMqRvYMUFHLuuTR5riU5YEVrhFkcekCb0FQ==
X-Google-Smtp-Source: ABdhPJwcY+8P/EJQefWL6Mj8+Qs/5d8dvH9W/mmHS4PKdmjQvfG9H6DNoZ+jwFW+XswnwBPG9WLmYgqWBYCjjDJMcYI=
X-Received: by 2002:a54:4603:: with SMTP id p3mr621424oip.127.1606166587487;
 Mon, 23 Nov 2020 13:23:07 -0800 (PST)
MIME-Version: 1.0
References: <20201120181627.21382-1-george.mccollister@gmail.com>
 <20201120181627.21382-3-george.mccollister@gmail.com> <20201122233940.annzfjtaza2z4lub@skbuf>
In-Reply-To: <20201122233940.annzfjtaza2z4lub@skbuf>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 23 Nov 2020 15:22:54 -0600
Message-ID: <CAFSKS=Nuv0zt5Xg0ET8dHjuZGqT1wF-xdpq_ssWkBapoNnk5VQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: dsa: add Arrow SpeedChips XRS700x driver
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 22, 2020 at 5:39 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi George,
>
> On Fri, Nov 20, 2020 at 12:16:26PM -0600, George McCollister wrote:
> > Add a driver with initial support for the Arrow SpeedChips XRS7000
> > series of gigabit Ethernet switch chips which are typically used in
> > critical networking applications.
> >
> > The switches have up to three RGMII ports and one RMII port.
> > Management to the switches can be performed over i2c or mdio.
> >
> > Support for advanced features such as PTP and
> > HSR/PRP (IEC 62439-3 Clause 5 & 4) is not included in this patch and
> > may be added at a later date.
> >
> > Signed-off-by: George McCollister <george.mccollister@gmail.com>
> > ---
> >  drivers/net/dsa/Kconfig        |  26 ++
> >  drivers/net/dsa/Makefile       |   3 +
> >  drivers/net/dsa/xrs700x.c      | 529 +++++++++++++++++++++++++++++++++++++++++
> >  drivers/net/dsa/xrs700x.h      |  27 +++
> >  drivers/net/dsa/xrs700x_i2c.c  | 148 ++++++++++++
> >  drivers/net/dsa/xrs700x_mdio.c | 160 +++++++++++++
> >  drivers/net/dsa/xrs700x_reg.h  | 205 ++++++++++++++++
>
> How much code do you plan to add to this driver? If it's going to
> include IEEE 1588 and HSR/PRP offloading, would it make sense to put its
> source code in a new folder now, to avoid doing that later?

I'll probably do that now. HSR/PRP offloading is planned but I foresee
that taking a while (hopefully there aren't too many major
roadblocks). IEEE 1588 is a maybe.

>
> >  7 files changed, 1098 insertions(+)
> >  create mode 100644 drivers/net/dsa/xrs700x.c
> >  create mode 100644 drivers/net/dsa/xrs700x.h
> >  create mode 100644 drivers/net/dsa/xrs700x_i2c.c
> >  create mode 100644 drivers/net/dsa/xrs700x_mdio.c
> >  create mode 100644 drivers/net/dsa/xrs700x_reg.h
> >
> > diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
> > index f6a0488589fc..e5ec3c602bcb 100644
> > --- a/drivers/net/dsa/Kconfig
> > +++ b/drivers/net/dsa/Kconfig
> > @@ -134,4 +134,30 @@ config NET_DSA_VITESSE_VSC73XX_PLATFORM
> >         This enables support for the Vitesse VSC7385, VSC7388, VSC7395
> >         and VSC7398 SparX integrated ethernet switches, connected over
> >         a CPU-attached address bus and work in memory-mapped I/O mode.
> > +
> > +config NET_DSA_XRS700X
> > +     tristate
> > +     depends on NET_DSA
> > +     select NET_DSA_TAG_XRS700X
> > +     select REGMAP
> > +     help
> > +       This enables support for Arrow SpeedChips XRS7003/7004 gigabit
> > +       Ethernet switches.
> > +
> > +config NET_DSA_XRS700X_I2C
> > +     tristate "Arrow XRS7000X series switch in I2C mode"
> > +     depends on NET_DSA && I2C
> > +     select NET_DSA_XRS700X
> > +     select REGMAP_I2C
> > +     help
> > +       Enable I2C support for Arrow SpeedChips XRS7003/7004 gigabit Ethernet
> > +       switches.
> > +
> > +config NET_DSA_XRS700X_MDIO
> > +     tristate "Arrow XRS7000X series switch in MDIO mode"
> > +     depends on NET_DSA
> > +     select NET_DSA_XRS700X
> > +     help
> > +       Enable MDIO support for Arrow SpeedChips XRS7003/7004 gigabit Ethernet
> > +       switches.
> >  endmenu
> > diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
> > index a84adb140a04..4528d6b57fc8 100644
> > --- a/drivers/net/dsa/Makefile
> > +++ b/drivers/net/dsa/Makefile
> > @@ -17,6 +17,9 @@ obj-$(CONFIG_NET_DSA_SMSC_LAN9303_MDIO) += lan9303_mdio.o
> >  obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX) += vitesse-vsc73xx-core.o
> >  obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX_PLATFORM) += vitesse-vsc73xx-platform.o
> >  obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX_SPI) += vitesse-vsc73xx-spi.o
> > +obj-$(CONFIG_NET_DSA_XRS700X) += xrs700x.o
> > +obj-$(CONFIG_NET_DSA_XRS700X_I2C) += xrs700x_i2c.o
> > +obj-$(CONFIG_NET_DSA_XRS700X_MDIO) += xrs700x_mdio.o
> >  obj-y                                += b53/
> >  obj-y                                += hirschmann/
> >  obj-y                                += microchip/
> > diff --git a/drivers/net/dsa/xrs700x.c b/drivers/net/dsa/xrs700x.c
> > new file mode 100644
> > index 000000000000..6cef3b534d5d
> > --- /dev/null
> > +++ b/drivers/net/dsa/xrs700x.c
> > @@ -0,0 +1,529 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) 2020 NovaTech LLC
> > + * George McCollister <george.mccollister@gmail.com>
> > + */
> > +
> > +#include <net/dsa.h>
> > +#include <linux/if_bridge.h>
> > +#include "xrs700x.h"
> > +#include "xrs700x_reg.h"
> > +
> > +#define XRS700X_MIB_INTERVAL msecs_to_jiffies(30000)
> > +
> > +#define XRS7003E_ID  0x100
> > +#define XRS7003F_ID  0x101
> > +#define XRS7004E_ID  0x200
> > +#define XRS7004F_ID  0x201
> > +
> > +struct xrs700x_model {
> > +     unsigned int id;
> > +     const char *name;
> > +     size_t num_ports;
> > +};
> > +
> > +static const struct xrs700x_model xrs700x_models[] = {
> > +     {XRS7003E_ID, "XRS7003E", 3},
> > +     {XRS7003F_ID, "XRS7003F", 3},
> > +     {XRS7004E_ID, "XRS7004E", 4},
> > +     {XRS7004F_ID, "XRS7004F", 4},
> > +};
> > +
> > +struct xrs700x_mib {
> > +     unsigned int offset;
> > +     const char *name;
> > +};
> > +
> > +static const struct xrs700x_mib xrs700x_mibs[] = {
> > +     {XRS_RX_GOOD_OCTETS_L(0), "rx_good_octets"},
> > +     {XRS_RX_BAD_OCTETS_L(0), "rx_bad_octets"},
> > +     {XRS_RX_UNICAST_L(0), "rx_unicast"},
> > +     {XRS_RX_BROADCAST_L(0), "rx_broadcast"},
> > +     {XRS_RX_MULTICAST_L(0), "rx_multicast"},
> > +     {XRS_RX_UNDERSIZE_L(0), "rx_undersize"},
> > +     {XRS_RX_FRAGMENTS_L(0), "rx_fragments"},
> > +     {XRS_RX_OVERSIZE_L(0), "rx_oversize"},
> > +     {XRS_RX_JABBER_L(0), "rx_jabber"},
> > +     {XRS_RX_ERR_L(0), "rx_err"},
> > +     {XRS_RX_CRC_L(0), "rx_crc"},
> > +     {XRS_RX_64_L(0), "rx_64"},
> > +     {XRS_RX_65_127_L(0), "rx_65_127"},
> > +     {XRS_RX_128_255_L(0), "rx_128_255"},
> > +     {XRS_RX_256_511_L(0), "rx_256_511"},
> > +     {XRS_RX_512_1023_L(0), "rx_512_1023"},
> > +     {XRS_RX_1024_1536_L(0), "rx_1024_1536"},
>
> Uh-oh, Jakub might not like these RMON counters being exposed to
> ethtool. See:
> https://patchwork.kernel.org/project/netdevbpf/patch/20201115073533.1366-1-o.rempel@pengutronix.de/

Great. So none of the DSA drivers do it the way he wants? Are there
plans to switch the existing drivers to what is discussed in that
thread? Can that even be done or will it "break userspace"? If someone
has an example for me to follow I can change this but this still seems
a bit up in the air.

>
> > +     {XRS_RX_HSR_PRP_L(0), "rx_hsr_prp"},
> > +     {XRS_RX_WRONGLAN_L(0), "rx_wronglan"},
> > +     {XRS_RX_DUPLICATE_L(0), "rx_duplicate"},
> > +     {XRS_TX_OCTETS_L(0), "tx_octets"},
> > +     {XRS_TX_UNICAST_L(0), "tx_unicast"},
> > +     {XRS_TX_BROADCAST_L(0), "tx_broadcast"},
> > +     {XRS_TX_MULTICAST_L(0), "tx_multicast"},
> > +     {XRS_TX_HSR_PRP_L(0), "tx_hsr_prp"},
> > +     {XRS_PRIQ_DROP_L(0), "priq_drop"},
> > +     {XRS_EARLY_DROP_L(0), "early_drop"},
> > +};
> > +
> > +static void xrs700x_get_strings(struct dsa_switch *ds, int port,
> > +                             u32 stringset, uint8_t *data)
> > +{
> > +     int i;
> > +
> > +     if (stringset != ETH_SS_STATS)
> > +             return;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(xrs700x_mibs); i++) {
> > +             strlcpy(data, xrs700x_mibs[i].name, ETH_GSTRING_LEN);
> > +             data += ETH_GSTRING_LEN;
> > +     }
> > +}
> > +
> > +static int xrs700x_get_sset_count(struct dsa_switch *ds, int port, int sset)
> > +{
> > +     if (sset != ETH_SS_STATS)
> > +             return -EOPNOTSUPP;
> > +
> > +     return ARRAY_SIZE(xrs700x_mibs);
> > +}
> > +
> > +static void xrs700x_read_port_counters(struct xrs700x *priv, int port)
> > +{
> > +     int i;
> > +     struct xrs700x_port *p = &priv->ports[port];
> > +
> > +     mutex_lock(&p->mib_mutex);
> > +
> > +     /* Capture counter values */
> > +     regmap_write(priv->regmap, XRS_CNT_CTRL(port), 1);
> > +
> > +     for (i = 0; i < ARRAY_SIZE(xrs700x_mibs); i++) {
> > +             unsigned int high = 0, low = 0, reg;
> > +
> > +             reg = xrs700x_mibs[i].offset + XRS_PORT_OFFSET * port;
> > +             regmap_read(priv->regmap, reg, &low);
> > +             regmap_read(priv->regmap, reg + 2, &high);
> > +
> > +             p->mib_data[i] += (high << 16) | low;
> > +     }
> > +
> > +     mutex_unlock(&p->mib_mutex);
> > +}
> > +
> > +static void xrs700x_mib_work(struct work_struct *work)
> > +{
> > +     struct xrs700x *priv = container_of(work, struct xrs700x,
> > +                                         mib_work.work);
> > +     int i;
> > +
> > +     for (i = 0; i < priv->ds->num_ports; i++)
> > +             xrs700x_read_port_counters(priv, i);
> > +
> > +     schedule_delayed_work(&priv->mib_work, XRS700X_MIB_INTERVAL);
> > +}
> > +
> > +static void xrs700x_get_ethtool_stats(struct dsa_switch *ds, int port,
> > +                                   uint64_t *data)
> > +{
> > +     struct xrs700x *priv = ds->priv;
> > +     struct xrs700x_port *p = &priv->ports[port];
> > +
> > +     xrs700x_read_port_counters(priv, port);
> > +
> > +     mutex_lock(&p->mib_mutex);
> > +     memcpy(data, p->mib_data, sizeof(*data) * ARRAY_SIZE(xrs700x_mibs));
> > +     mutex_unlock(&p->mib_mutex);
> > +}
> > +
> > +static int xrs700x_setup_regmap_range(struct xrs700x *priv)
> > +{
> > +     struct reg_field ps_forward = REG_FIELD_ID(XRS_PORT_STATE(0), 0, 1,
> > +                                                priv->ds->num_ports,
> > +                                                XRS_PORT_OFFSET);
>
> Oh, hey, another REG_FIELD_ID user!

I actually implemented this macro with a different name but someone
else upstreamed it before I could get to it.

>
> > +     struct reg_field ps_management = REG_FIELD_ID(XRS_PORT_STATE(0), 2, 3,
> > +                                                   priv->ds->num_ports,
> > +                                                   XRS_PORT_OFFSET);
> > +     struct reg_field ps_sel_speed = REG_FIELD_ID(XRS_PORT_STATE(0), 4, 9,
> > +                                                  priv->ds->num_ports,
> > +                                                  XRS_PORT_OFFSET);
> > +     struct reg_field ps_cur_speed = REG_FIELD_ID(XRS_PORT_STATE(0), 10, 11,
> > +                                                  priv->ds->num_ports,
> > +                                                  XRS_PORT_OFFSET);
> > +
> > +     priv->ps_forward = devm_regmap_field_alloc(priv->dev, priv->regmap,
> > +                                                ps_forward);
> > +     if (IS_ERR(priv->ps_forward))
> > +             return PTR_ERR(priv->ps_forward);
> > +
> > +     priv->ps_management = devm_regmap_field_alloc(priv->dev, priv->regmap,
> > +                                                   ps_management);
> > +     if (IS_ERR(priv->ps_management))
> > +             return PTR_ERR(priv->ps_management);
> > +
> > +     priv->ps_sel_speed = devm_regmap_field_alloc(priv->dev, priv->regmap,
> > +                                                  ps_sel_speed);
> > +     if (IS_ERR(priv->ps_sel_speed))
> > +             return PTR_ERR(priv->ps_sel_speed);
> > +
> > +     priv->ps_cur_speed = devm_regmap_field_alloc(priv->dev, priv->regmap,
> > +                                                  ps_cur_speed);
> > +     if (IS_ERR(priv->ps_cur_speed))
> > +             return PTR_ERR(priv->ps_cur_speed);
>
> Should you try to automate allocating these? You might get tired of
> adding and adding and adding to this function really quick. You might
> get some inspiration from ocelot_regfields_init() and that driver's use
> of regmap in general.

I'll look at it.

>
> > +
> > +     return 0;
> > +}
> > +
> > +static enum dsa_tag_protocol xrs700x_get_tag_protocol(struct dsa_switch *ds,
> > +                                                   int port,
> > +                                                   enum dsa_tag_protocol m)
> > +{
> > +     return DSA_TAG_PROTO_XRS700X;
> > +}
> > +
> > +static int xrs700x_reset(struct dsa_switch *ds)
> > +{
> > +     struct xrs700x *priv = ds->priv;
> > +     int ret;
> > +     unsigned int val;
> > +
> > +     ret = regmap_write(priv->regmap, XRS_GENERAL, XRS_GENERAL_RESET);
> > +     if (ret)
> > +             goto error;
> > +
> > +     ret = regmap_read_poll_timeout(priv->regmap, XRS_GENERAL,
> > +                                    val, !(val & XRS_GENERAL_RESET),
> > +                                    10, 1000);
> > +error:
> > +     if (ret) {
> > +             dev_err_ratelimited(priv->dev, "error resetting switch: %d\n",
> > +                                 ret);
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +static void xrs700x_port_stp_state_set(struct dsa_switch *ds, int port,
> > +                                    u8 state)
> > +{
> > +     struct xrs700x *priv = ds->priv;
> > +     unsigned int val;
> > +
> > +     switch (state) {
> > +     case BR_STATE_DISABLED:
> > +             val = XRS_PORT_DISABLED;
> > +             break;
> > +     case BR_STATE_LISTENING:
> > +             val = XRS_PORT_DISABLED;
> > +             break;
> > +     case BR_STATE_LEARNING:
> > +             val = XRS_PORT_LEARNING;
> > +             break;
> > +     case BR_STATE_FORWARDING:
> > +             val = XRS_PORT_FORWARDING;
> > +             break;
> > +     case BR_STATE_BLOCKING:
> > +             val = XRS_PORT_DISABLED;
>
> Why not just put BR_STATE_DISABLED and BR_STATE_BLOCKING one under the
> other?

This is all messed up anyway, see my last email.

>
>         case BR_STATE_BLOCKING:
>         case BR_STATE_DISABLED:
>                 val = XRS_PORT_DISABLED;
>
> > +             break;
> > +     default:
> > +             dev_err(ds->dev, "invalid STP state: %d\n", state);
> > +             return;
> > +     }
> > +
> > +     regmap_fields_write(priv->ps_forward, port, val);
> > +
> > +     dev_dbg_ratelimited(priv->dev, "%s - port: %d, state: %u, val: 0x%x\n",
> > +                         __func__, port, state, val);
> > +}
> > +
> > +static int xrs700x_port_setup(struct dsa_switch *ds, int port)
> > +{
> > +     struct xrs700x *priv = ds->priv;
> > +     bool cpu_port = dsa_is_cpu_port(ds, port);
>
> Reverse Christmas tree notation please.

yeah, I already have updated this. It'll be in v2.

>
> > +     unsigned int val;
>
> Ugh, you couldn't have initialized this with zero here? It looks ugly
> putting that in the for loop.

I never do that and disagree but if you want me to change it anyway,
it's not a battle worth fighting.

>
> > +     int ret, i;
> > +
> > +     xrs700x_port_stp_state_set(ds, port, BR_STATE_DISABLED);
> > +
> > +     /* Disable forwarding to non-CPU ports */
> > +     for (val = 0, i = 0; i < ds->num_ports; i++) {
> > +             if (!dsa_is_cpu_port(ds, i))
> > +                     val |= BIT(i);
> > +     }
> > +
> > +     ret = regmap_write(priv->regmap, XRS_PORT_FWD_MASK(port), val);
> > +     if (ret)
> > +             return ret;
> > +
> > +     val = cpu_port ? XRS_PORT_MODE_MANAGEMENT : XRS_PORT_MODE_NORMAL;
> > +     ret = regmap_fields_write(priv->ps_management, port, val);
> > +     if (ret)
> > +             return ret;
> > +
> > +     return 0;
> > +}
> > +
> > +static int xrs700x_setup(struct dsa_switch *ds)
> > +{
> > +     struct xrs700x *priv = ds->priv;
> > +     int ret, i;
> > +
> > +     ret = xrs700x_reset(ds);
> > +     if (ret)
> > +             return ret;
> > +
> > +     for (i = 0; i < ds->num_ports; i++) {
> > +             ret = xrs700x_port_setup(ds, i);
> > +             if (ret)
> > +                     return ret;
> > +     }
> > +
> > +     schedule_delayed_work(&priv->mib_work, XRS700X_MIB_INTERVAL);
> > +
> > +     return 0;
> > +}
> > +
> > +static void xrs700x_phylink_validate(struct dsa_switch *ds, int port,
> > +                                  unsigned long *supported,
> > +                                  struct phylink_link_state *state)
> > +{
> > +     __ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> > +
> > +     switch (port) {
> > +     case 0:
> > +             break;
> > +     case 1:
> > +     case 2:
> > +     case 3:
> > +             phylink_set(mask, 1000baseT_Full);
> > +             break;
> > +     default:
> > +             bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> > +             dev_err(ds->dev, "Unsupported port: %i\n", port);
> > +             return;
> > +     }
> > +
> > +     phylink_set_port_modes(mask);
> > +
> > +     /* The switch only supports full duplex. */
> > +     phylink_set(mask, 10baseT_Full);
> > +     phylink_set(mask, 100baseT_Full);
> > +
> > +     bitmap_and(supported, supported, mask,
> > +                __ETHTOOL_LINK_MODE_MASK_NBITS);
> > +     bitmap_and(state->advertising, state->advertising, mask,
> > +                __ETHTOOL_LINK_MODE_MASK_NBITS);
> > +}
> > +
> > +static void xrs700x_phylink_mac_config(struct dsa_switch *ds, int port,
> > +                                    unsigned int mode,
> > +                                    const struct phylink_link_state *state)
>
> As far as I understand phylink, you should be programming the link speed
> of the RGMII/RMII MAC from the .mac_link_up callback.

It's working as is but I'll try moving it to .mac_link_up.

>
> > +{
> > +     struct xrs700x *priv = ds->priv;
> > +     unsigned int val;
> > +
> > +     switch (state->speed) {
> > +     case SPEED_1000:
> > +             val = XRS_PORT_SPEED_1000;
> > +             break;
> > +     case SPEED_100:
> > +             val = XRS_PORT_SPEED_100;
> > +             break;
> > +     case SPEED_10:
> > +             val = XRS_PORT_SPEED_10;
> > +             break;
> > +     default:
> > +             return;
> > +     }
> > +
> > +     regmap_fields_write(priv->ps_sel_speed, port, val);
> > +
> > +     dev_dbg_ratelimited(priv->dev, "%s: port: %d mode: %u speed: %u\n",
> > +                         __func__, port, mode, state->speed);
> > +}
> > +
> > +static int xrs700x_bridge_join(struct dsa_switch *ds, int port,
> > +                            struct net_device *bridge)
> > +{
> > +     struct xrs700x *priv = ds->priv;
> > +     unsigned int i, ret, mask = 0;
> > +
> > +     for (i = 0; i < ds->num_ports; i++) {
> > +             if (dsa_to_port(ds, i)->bridge_dev == bridge ||
> > +                 dsa_is_cpu_port(ds, i))
> > +                     continue;
> > +
> > +             mask |= BIT(i);
> > +     }
> > +
> > +     dev_dbg(priv->dev, "%s: port: %d mask: 0x%x\n", __func__,
> > +             port, mask);
> > +
> > +     for (i = 0; i < ds->num_ports; i++) {
> > +             if (dsa_to_port(ds, i)->bridge_dev != bridge)
> > +                     continue;
> > +
> > +             ret = regmap_write(priv->regmap, XRS_PORT_FWD_MASK(i), mask);
> > +             if (ret)
> > +                     return ret;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static void xrs700x_bridge_leave(struct dsa_switch *ds, int port,
> > +                              struct net_device *bridge)
>
> Don't be lazy, you can avoid copy-pasting the implementation for this
> one...

Okay I'll write a common function for join and leave to use.

>
> > +{
> > +     struct xrs700x *priv = ds->priv;
> > +     unsigned int i, cpu_mask = 0, mask = 0;
> > +
> > +     for (i = 0; i < ds->num_ports; i++) {
> > +             if (dsa_is_cpu_port(ds, i))
> > +                     continue;
> > +
> > +             cpu_mask |= BIT(i);
> > +
> > +             if (dsa_to_port(ds, i)->bridge_dev == bridge)
> > +                     continue;
> > +
> > +             mask |= BIT(i);
> > +     }
> > +
> > +     dev_dbg(priv->dev, "%s: port: %d mask: 0x%x\n", __func__,
> > +             port, mask);
> > +
> > +     for (i = 0; i < ds->num_ports; i++) {
> > +             if (dsa_to_port(ds, i)->bridge_dev != bridge)
> > +                     continue;
> > +
> > +             regmap_write(priv->regmap, XRS_PORT_FWD_MASK(i), mask);
> > +     }
> > +
> > +     regmap_write(priv->regmap, XRS_PORT_FWD_MASK(port), cpu_mask);
> > +}
> > +
> > +static const struct dsa_switch_ops xrs700x_ops = {
> > +     .get_tag_protocol       = xrs700x_get_tag_protocol,
> > +     .setup                  = xrs700x_setup,
> > +     .port_stp_state_set     = xrs700x_port_stp_state_set,
> > +     .phylink_validate       = xrs700x_phylink_validate,
> > +     .phylink_mac_config     = xrs700x_phylink_mac_config,
> > +     .get_strings            = xrs700x_get_strings,
> > +     .get_sset_count         = xrs700x_get_sset_count,
> > +     .get_ethtool_stats      = xrs700x_get_ethtool_stats,
> > +     .port_bridge_join       = xrs700x_bridge_join,
> > +     .port_bridge_leave      = xrs700x_bridge_leave,
> > +};
> > +
> > +static int xrs700x_detect(struct xrs700x *dev)
> > +{
> > +     int i, ret;
> > +     unsigned int id;
> > +
> > +     ret = regmap_read(dev->regmap, XRS_DEV_ID0, &id);
> > +     if (ret) {
> > +             dev_err(dev->dev, "error %d while reading switch id.\n",
> > +                     ret);
> > +             return ret;
> > +     }
> > +
> > +     for (i = 0; i < ARRAY_SIZE(xrs700x_models); i++) {
> > +             if (xrs700x_models[i].id == id) {
> > +                     dev->ds->num_ports = xrs700x_models[i].num_ports;
> > +                     dev_info(dev->dev, "%s detected.\n",
> > +                              xrs700x_models[i].name);
> > +                     return 0;
> > +             }
> > +     }
> > +
> > +     dev_err(dev->dev, "unknown switch id 0x%x.\n", id);
> > +
> > +     return -ENODEV;
> > +}
> > +
> > +struct xrs700x *xrs700x_switch_alloc(struct device *base, void *priv)
> > +{
> > +     struct dsa_switch *ds;
> > +     struct xrs700x *dev;
> > +
> > +     ds = devm_kzalloc(base, sizeof(*ds), GFP_KERNEL);
> > +     if (!ds)
> > +             return NULL;
> > +
> > +     ds->dev = base;
> > +     ds->num_ports = DSA_MAX_PORTS;
>
> Why so many?

I've removed ds->num_ports = DSA_MAX_PORTS; for v2.

>
> > +
> > +     dev = devm_kzalloc(base, sizeof(*dev), GFP_KERNEL);
> > +     if (!dev)
> > +             return NULL;
> > +
> > +     INIT_DELAYED_WORK(&dev->mib_work, xrs700x_mib_work);
> > +
> > +     ds->ops = &xrs700x_ops;
> > +     ds->priv = dev;
> > +     dev->dev = base;
> > +
> > +     dev->ds = ds;
> > +     dev->priv = priv;
> > +
> > +     return dev;
> > +}
> > +EXPORT_SYMBOL(xrs700x_switch_alloc);
> > +
> > +static int xrs700x_alloc_port_mib(struct xrs700x *dev, int port)
> > +{
> > +     struct xrs700x_port *p = &dev->ports[port];
> > +     size_t mib_size = sizeof(*p->mib_data) * ARRAY_SIZE(xrs700x_mibs);
> > +
> > +     p->mib_data = devm_kzalloc(dev->dev, mib_size, GFP_KERNEL);
> > +     if (!p->mib_data)
> > +             return -ENOMEM;
> > +
> > +     mutex_init(&p->mib_mutex);
> > +
> > +     return 0;
> > +}
> > +
> > +int xrs700x_switch_register(struct xrs700x *dev)
> > +{
> > +     int ret;
> > +     int i;
> > +
> > +     ret = xrs700x_detect(dev);
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret = xrs700x_setup_regmap_range(dev);
> > +     if (ret)
> > +             return ret;
> > +
> > +     dev->ports = devm_kzalloc(dev->dev,
> > +                               sizeof(*dev->ports) * dev->ds->num_ports,
> > +                               GFP_KERNEL);
> > +     if (!dev->ports)
> > +             return -ENOMEM;
> > +
> > +     for (i = 0; i < dev->ds->num_ports; i++) {
> > +             ret = xrs700x_alloc_port_mib(dev, i);
> > +             if (ret)
> > +                     return ret;
> > +     }
> > +
> > +     ret = dsa_register_switch(dev->ds);
> > +
> > +     if (ret)
> > +             cancel_delayed_work_sync(&dev->mib_work);
> > +
> > +     return ret;
> > +}
> > +EXPORT_SYMBOL(xrs700x_switch_register);
> > +
> > +void xrs700x_switch_remove(struct xrs700x *dev)
> > +{
> > +     cancel_delayed_work_sync(&dev->mib_work);
> > +
> > +     dsa_unregister_switch(dev->ds);
> > +}
> > +EXPORT_SYMBOL(xrs700x_switch_remove);
> > +
> > +MODULE_AUTHOR("George McCollister <george.mccollister@gmail.com>");
> > +MODULE_DESCRIPTION("Arrow SpeedChips XRS700x DSA driver");
> > +MODULE_LICENSE("GPL v2");
> > diff --git a/drivers/net/dsa/xrs700x.h b/drivers/net/dsa/xrs700x.h
> > new file mode 100644
> > index 000000000000..53acf4359477
> > --- /dev/null
> > +++ b/drivers/net/dsa/xrs700x.h
> > @@ -0,0 +1,27 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#include <linux/device.h>
> > +#include <linux/mutex.h>
> > +#include <linux/regmap.h>
> > +#include <linux/workqueue.h>
> > +
> > +struct xrs700x_port {
> > +     struct mutex mib_mutex; /* protects mib_data */
> > +     uint64_t *mib_data;
> > +};
> > +
> > +struct xrs700x {
> > +     struct dsa_switch *ds;
> > +     struct device *dev;
> > +     void *priv;
> > +     struct regmap *regmap;
> > +     struct regmap_field *ps_forward;
> > +     struct regmap_field *ps_management;
> > +     struct regmap_field *ps_sel_speed;
> > +     struct regmap_field *ps_cur_speed;
> > +     struct delayed_work mib_work;
> > +     struct xrs700x_port *ports;
> > +};
> > +
> > +struct xrs700x *xrs700x_switch_alloc(struct device *base, void *priv);
> > +int xrs700x_switch_register(struct xrs700x *dev);
> > +void xrs700x_switch_remove(struct xrs700x *dev);
> > diff --git a/drivers/net/dsa/xrs700x_i2c.c b/drivers/net/dsa/xrs700x_i2c.c
> > new file mode 100644
> > index 000000000000..30f6c5ce825b
> > --- /dev/null
> > +++ b/drivers/net/dsa/xrs700x_i2c.c
> > @@ -0,0 +1,148 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) 2020 NovaTech LLC
> > + * George McCollister <george.mccollister@gmail.com>
> > + */
> > +
> > +#include <linux/bits.h>
> > +#include <linux/i2c.h>
> > +#include <linux/module.h>
> > +#include "xrs700x.h"
> > +#include "xrs700x_reg.h"
> > +
> > +static int xrs700x_i2c_reg_read(void *context, unsigned int reg,
> > +                             unsigned int *val)
> > +{
> > +     int ret;
> > +     unsigned char buf[4];
> > +     struct device *dev = context;
> > +     struct i2c_client *i2c = to_i2c_client(dev);
>
> Please sort variable declaration in the order of decreasing line length.

I have that done for v2. However in this case dev will still be before
i2c since the i2c line depends on it.

>
> > +
> > +     buf[0] = reg >> 23 & 0xff;
> > +     buf[1] = reg >> 15 & 0xff;
> > +     buf[2] = reg >> 7 & 0xff;
> > +     buf[3] = (reg & 0x7f) << 1;
> > +
> > +     ret = i2c_master_send(i2c, buf, sizeof(buf));
> > +     if (ret < 0) {
> > +             dev_err(dev, "xrs i2c_master_send returned %d\n", ret);
> > +             return ret;
> > +     }
> > +
> > +     ret = i2c_master_recv(i2c, buf, 2);
> > +     if (ret < 0) {
> > +             dev_err(dev, "xrs i2c_master_recv returned %d\n", ret);
> > +             return ret;
> > +     }
> > +
> > +     *val = buf[0] << 8 | buf[1];
> > +
> > +     return 0;
> > +}

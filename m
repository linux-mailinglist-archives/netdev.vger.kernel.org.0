Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCA167C4E4
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbjAZHat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbjAZH3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:29:10 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1F8611D1
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:28:47 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id h24so1766379lfv.6
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=so9p6d/6DvwvQuxJkDI/Q49HgfZm9liS89fwd5ePGrQ=;
        b=f85MKKLnxsVAdy8qsBqGkE1aRLeva2He3ynreiX34ak0UdODCV9RNPEliWSv0i6Yl0
         r6szerrmvsQSiIYfDwPCz5L9jyYxoLs7ngGzrZjgTFLLFqlpzeVrMIgAOYVmsGBGTww5
         oGHXMPQhyMTL7p3IuoQR6pcpAKkgVF5hgTtEMQwyhUEVqD5esWTjuDnuYUag2qGYRTxp
         sTfj0bou2Ava4eRhhFgYKheoaowRSy3KFo8k2DsPEyqja3oDEAV7NqxxZrekEhRrhWyF
         5C57QDzVLv7d8VcErXIoRHUNPrBYf5eUck69EnAyZQzkuArW6OGG2D79f3844boBCSJ0
         ADBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=so9p6d/6DvwvQuxJkDI/Q49HgfZm9liS89fwd5ePGrQ=;
        b=4R8akRC/OZZA4l37HgvdnzgRyns8i8jFRGK652YsWlgCv0ZvEoRem5O+crb9VD7NKh
         P/TrkuzEWQ4gBykCMMjo4nWD+/Idjdym0jJPcowrQY6of0r9CELqaSbt02Vr/b7sqCzq
         CjaaoiE8kbDHyirCKYsk2eREQoehehajEgPvIn+6gdxI8IKEzj7tF+d0i0nPG+/Waduf
         SCa2JV4mKg3V/f2uqyByVK5DR/0kjK1j2fcKJaj75EOxkDZDWWUJkjacl916uHegg1XI
         h0/ZMvF85Q0dH8tI+iS/y7wLDavPi/7e/OlwEvcMyt51YFE/soKHh/dBDT+35I2TnyFx
         QNXw==
X-Gm-Message-State: AFqh2kr3k/hrnOfJ623C6KdOqakJQ+hTVo+unWuYfJWYSU6Xd2gh9Ueq
        vksi1PYdrTD29+G5vYoPHHr1e9aWoIsv2O4NLKY=
X-Google-Smtp-Source: AMrXdXufE8d70SaFjal2Yjk34mMk6Po5aakU1UqIKIgm3+XIBixdsvijjnmAhk0ZQlB6iFxVkt6JTr8WV8LL2+6JtCw=
X-Received: by 2002:ac2:5596:0:b0:4cb:334f:85ef with SMTP id
 v22-20020ac25596000000b004cb334f85efmr1555688lfg.67.1674718125849; Wed, 25
 Jan 2023 23:28:45 -0800 (PST)
MIME-Version: 1.0
References: <20230120170025.20178-1-luizluca@gmail.com> <20230121120744.4krs4esfab56pvdz@bang-olufsen.dk>
In-Reply-To: <20230121120744.4krs4esfab56pvdz@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Thu, 26 Jan 2023 04:28:33 -0300
Message-ID: <CAJq09z61eH8NXu9DJpLLadGXu0vDt7FC_vr3uZJFemYKmcfheA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: rtl8365mb: add change_mtu
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Fri, Jan 20, 2023 at 02:00:26PM -0300, Luiz Angelo Daros de Luca wrote:
> > rtl8365mb was using a fixed MTU size of 1536, probably inspired by
> > rtl8366rb initial packet size. Different from that family, rtl8365mb
> > family can specify the max packet size in bytes and not in fixed steps.
> > Now it defaults to VLAN_ETH_HLEN+ETH_DATA_LEN+ETH_FCS_LEN (1522 bytes).
> >
> > DSA calls change_mtu for the CPU port once the max mtu value among the
> > ports changes. As the max packet size is defined globally, the switch
> > is configured only when the call affects the CPU port.
> >
> > The available specs do not directly define the max supported packet
> > size, but it mentions a 16k limit. However, the switch sets the max
> > packet size to 16368 bytes (0x3FF0) after it resets. That value was
> > assumed as the maximum supported packet size.
> >
> > MTU was tested up to 2018 (with 802.1Q) as that is as far as mt7620
> > (where rtl8367s is stacked) can go.
> >
> > There is a jumbo register, enabled by default at 6k packet size.
> > However, the jumbo settings does not seem to limit nor expand the
> > maximum tested MTU (2018), even when jumbo is disabled. More tests are
> > needed with a device that can handle larger frames.
> >
> > Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> > ---
> >  drivers/net/dsa/realtek/rtl8365mb.c | 63 +++++++++++++++++++++++++++--
> >  1 file changed, 59 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
> > index da31d8b839ac..da9e5f16c8cc 100644
> > --- a/drivers/net/dsa/realtek/rtl8365mb.c
> > +++ b/drivers/net/dsa/realtek/rtl8365mb.c
> > @@ -98,6 +98,7 @@
> >  #include <linux/of_irq.h>
> >  #include <linux/regmap.h>
> >  #include <linux/if_bridge.h>
> > +#include <linux/if_vlan.h>
> >
> >  #include "realtek.h"
> >
> > @@ -267,6 +268,12 @@
> >  /* Maximum packet length register */
> >  #define RTL8365MB_CFG0_MAX_LEN_REG   0x088C
> >  #define   RTL8365MB_CFG0_MAX_LEN_MASK        0x3FFF
> > +/* Not sure but it is the default value after reset */
> > +#define RTL8365MB_CFG0_MAX_LEN_MAX   0x3FF0
>
> The max length is 0x3FFF as seen in the mask defined right above.

The mask does allow up to 0x3FFF but, as I said in the commit message,
I assumed the value that register has after reset as the max one
(16368 / 0x3ff0).
It is, at least, a value that the switch can handle and only 15 bytes
smaller than 0x3fff. Should I use 0x3FFF instead? They might have a
reason for using that value;

> > +
> > +#define RTL8365MB_FLOWCTRL_JUMBO_SIZE_REG    0x123B
> > +#define  RTL8365MB_FLOWCTRL_JUMBO_SIZE_MASK  GENMASK(1,0)
> > +#define  RTL8365MB_FLOWCTRL_JUMBO_ENABLE_MASK        GENMASK(2,2)
>
> You were unable to test this so please drop it from the patch.

I'll drop all the jumbo code. My hope was that someone with better
hardware could test it.
Up to 2k, all those settings do nothing.

> >
> >  /* Port learning limit registers */
> >  #define RTL8365MB_LUT_PORT_LEARN_LIMIT_BASE          0x0A20
> > @@ -309,6 +316,14 @@
> >   */
> >  #define RTL8365MB_STATS_INTERVAL_JIFFIES     (3 * HZ)
> >
> > +/* FIXME: is k in {3,4,6,9}k 1000 or 1024 */
> > +enum rtl8365mb_jumbo_size {
> > +     RTL8365MB_JUMBO_SIZE_3K = 0,
> > +     RTL8365MB_JUMBO_SIZE_4K,
> > +     RTL8365MB_JUMBO_SIZE_6K,
> > +     RTL8365MB_JUMBO_SIZE_9K
> > +};
> > +
> >  enum rtl8365mb_mib_counter_index {
> >       RTL8365MB_MIB_ifInOctets,
> >       RTL8365MB_MIB_dot3StatsFCSErrors,
> > @@ -1135,6 +1150,44 @@ static void rtl8365mb_phylink_mac_link_up(struct dsa_switch *ds, int port,
> >       }
> >  }
> >
> > +static int rtl8365mb_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
> > +{
> > +     struct realtek_priv *priv = ds->priv;
> > +
> > +     /* When a new MTU is set, DSA always set the CPU port's MTU to the
>
> s/always set/always sets/

It is actually a copied typo:

drivers/net/dsa/qca/qca8k-common.c:      * DSA always set the CPU
port's MTU to the largest MTU of the slave
drivers/net/dsa/mt7530.c:       /* When a new MTU is set, DSA always
set the CPU port's MTU to the

> > +      * largest MTU of the slave ports. Because the switch only has a global
> > +      * RX length register, only allowing CPU port here is enough.
> > +      */
> > +     if (!dsa_is_cpu_port(ds, port))
> > +             return 0;
> > +
> > +     new_mtu += VLAN_ETH_HLEN + ETH_FCS_LEN;
>
> Why VLAN_ETH_HLEN rather than ETH_HLEN?

That is an interesting point to discuss. MTU is a L3 property, the
size of the ethernet payload. The switch, however, works with L2
values. When you set RTL8365MB_CFG0_MAX_LEN_REG, you are actually
setting the frame size (maybe I should have used a new variable name
frame_size instead of summing extra bytes to the new_mtu).

The issue is that you cannot tell the exact frame size a priori
because it could include the optional 802.1Q tag (or even the double
QinQ). If you use ETH_HLEN, all vlan-tagged packets with payload size
between 1997-1500 bytes will be dropped. I got to this empirically but
after I saw that other drivers are also doing something similar.

drivers/net/dsa/hirschmann/hellcreek.c:         u32 max_sdu =
schedule->max_sdu[tc] + VLAN_ETH_HLEN - ETH_FCS_LEN;
drivers/net/dsa/microchip/ksz8795.c:    frame_size = mtu +
VLAN_ETH_HLEN + ETH_FCS_LEN;
drivers/net/dsa/microchip/ksz9477.c:    frame_size = mtu +
VLAN_ETH_HLEN + ETH_FCS_LEN;
drivers/net/dsa/microchip/ksz_common.c:         return
KSZ8795_HUGE_PACKET_SIZE - VLAN_ETH_HLEN - ETH_FCS_LEN;
drivers/net/dsa/microchip/ksz_common.c:         return
KSZ8863_HUGE_PACKET_SIZE - VLAN_ETH_HLEN - ETH_FCS_LEN;
drivers/net/dsa/microchip/ksz_common.c:         return
KSZ9477_MAX_FRAME_SIZE - VLAN_ETH_HLEN - ETH_FCS_LEN;
drivers/net/dsa/microchip/lan937x_main.c:       new_mtu +=
VLAN_ETH_HLEN + ETH_FCS_LEN;
drivers/net/dsa/mv88e6xxx/chip.c:               return 10240 -
VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
drivers/net/dsa/mv88e6xxx/chip.c:               return 1632 -
VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
drivers/net/dsa/mv88e6xxx/chip.c:       return 1522 - VLAN_ETH_HLEN -
EDSA_HLEN - ETH_FCS_LEN;
drivers/net/dsa/mv88e6xxx/port.c:       size += VLAN_ETH_HLEN + ETH_FCS_LEN;
drivers/net/dsa/sja1105/sja1105_main.c: new_mtu += VLAN_ETH_HLEN + ETH_FCS_LEN;
drivers/net/dsa/sja1105/sja1105_main.c: return 2043 - VLAN_ETH_HLEN -
ETH_FCS_LEN;
drivers/net/dsa/lantiq_gswip.c: return GSWIP_MAX_PACKET_LENGTH -
VLAN_ETH_HLEN - ETH_FCS_LEN;
drivers/net/dsa/lantiq_gswip.c:         gswip_switch_w(priv,
VLAN_ETH_HLEN + new_mtu + ETH_FCS_LEN,

Optimally, if the DSA tree could calculate the frame size, we could
change the change_mtu signature to include that value as well. As
other drivers show, it  is a common problem. We will still accept
untagged packets up to 1504 but the receiver OS should be able to
handle that.

However, what really bugs me is if all these are really necessary. Are
there any drawbacks to accepting a larger frame? If not, why not
simply set it to max_mtu at setup and return 0 in change_mtu?

> > +
> > +     /* FIXME: We might need to adjust the jumbo size as well. However, the
> > +      * device seems to forward at least up to mtu=2018 (test device limit)
> > +      * even with jumbo frames disabled.
> > +      */
> > +     /* This is the switch state after reset */
> > +     /*enum rtl8365mb_jumbo_size jumbo_size = RTL8365MB_JUMBO_SIZE_6K;
> > +
> > +     regmap_update_bits(priv->map, RTL8365MB_FLOWCTRL_JUMBO_SIZE_REG,
> > +                        RTL8365MB_FLOWCTRL_JUMBO_ENABLE_MASK |
> > +                        RTL8365MB_FLOWCTRL_JUMBO_SIZE_MASK,
> > +                        FIELD_PREP(RTL8365MB_FLOWCTRL_JUMBO_ENABLE_MASK,1) |
> > +                        FIELD_PREP(RTL8365MB_FLOWCTRL_JUMBO_SIZE_MASK,
> > +                                   jumbo_size));
> > +     */
>
> No commented out code can be accepted into the driver, please drop it
> from the patch if it is not able to be used.

OK

>
> > +
> > +     return regmap_update_bits(priv->map, RTL8365MB_CFG0_MAX_LEN_REG,
> > +                              RTL8365MB_CFG0_MAX_LEN_MASK,
> > +                              FIELD_PREP(RTL8365MB_CFG0_MAX_LEN_MASK, new_mtu));
>
> 80 columns + looks like arguments aren't aligned with the (

Sorry, I missed that.

>
> > +}
> > +
> > +static int rtl8365mb_max_mtu(struct dsa_switch *ds, int port)
> > +{
> > +     return RTL8365MB_CFG0_MAX_LEN_MAX - VLAN_ETH_HLEN - ETH_FCS_LEN;
> > +}
> > +
> >  static void rtl8365mb_port_stp_state_set(struct dsa_switch *ds, int port,
> >                                        u8 state)
> >  {
> > @@ -1980,10 +2033,8 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
> >               p->index = i;
> >       }
> >
> > -     /* Set maximum packet length to 1536 bytes */
> > -     ret = regmap_update_bits(priv->map, RTL8365MB_CFG0_MAX_LEN_REG,
> > -                              RTL8365MB_CFG0_MAX_LEN_MASK,
> > -                              FIELD_PREP(RTL8365MB_CFG0_MAX_LEN_MASK, 1536));
> > +     /* Set packet length from 16368 to 1500+14+4+4=1522 */
> > +     ret = rtl8365mb_change_mtu(ds, cpu->trap_port, ETH_DATA_LEN);
>
> I think DSA sets the MTU automatically, cf. dsa_slave_create(). This can
> probably be dropped now that the dsa_switch_ops are implemented.

During my tests, it does not emit a change_mtu for the CPU port (the
one I care about) nor any other ports.
The side-effect is that reg 0x088c is kept untouched, with value 0x3ff0.

> >       if (ret)
> >               goto out_teardown_irq;
> >
> > @@ -2103,6 +2154,8 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
> >       .get_eth_mac_stats = rtl8365mb_get_mac_stats,
> >       .get_eth_ctrl_stats = rtl8365mb_get_ctrl_stats,
> >       .get_stats64 = rtl8365mb_get_stats64,
> > +     .port_change_mtu = rtl8365mb_change_mtu,
> > +     .port_max_mtu = rtl8365mb_max_mtu,
>
> Please name the functions according to the dsa_switch_ops name:
>
> rtl8365mb_change_mtu -> rtl8365mb_port_change_mtu
> rtl8365mb_max_mtu -> rtl8365mb_port_max_mtu
>

OK

> >  };
> >
> >  static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
> > @@ -2124,6 +2177,8 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
> >       .get_eth_mac_stats = rtl8365mb_get_mac_stats,
> >       .get_eth_ctrl_stats = rtl8365mb_get_ctrl_stats,
> >       .get_stats64 = rtl8365mb_get_stats64,
> > +     .port_change_mtu = rtl8365mb_change_mtu,
> > +     .port_max_mtu = rtl8365mb_max_mtu,
> >  };
> >
> >  static const struct realtek_ops rtl8365mb_ops = {
> > --
> > 2.39.0
> >
>
> Kind regards,
> Alvin

Thanks Alvin,

Regards,

Luiz

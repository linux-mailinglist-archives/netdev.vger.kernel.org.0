Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F05BD46ED4E
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 17:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240288AbhLIQot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 11:44:49 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:62703 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236862AbhLIQos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 11:44:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639068075; x=1670604075;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FwiOhEeGHC1RvvGkRHmInv3jtJwheJz7q/Qb66rXDm4=;
  b=MEXIEjk72BOALfBYfhOodeFQ27DplxS52kpUg8O5rRP2PLRrjeYh6BdD
   hcRGrtP2a78d8Q1YOUv97FjTLfWprLawqjz84uyRzRJXFyV0mo92nedlP
   CwpbcDeGym6ECahbyaAk5WUg3iUP9r3JVHoIqWC8g2hGggcNbdViO1UDM
   UaBTRIz+77Ikle2iXTZgUwmvwEomedT0TB1rP7MfVb/MCQcXmOib9NHgL
   MSKOJAUp6IhHasKESfK3onFV9/eA5HLIlySCLIiVmR7SSFSyT2uIAFT0O
   kZ48Eo/eFyjYMbbm4t8x4bXGWjvGfAlV0HZUwzo6VHYkBsd+6N790j25e
   w==;
IronPort-SDR: Kc4MME9G1+FGj24XJSqDOyRvMXqZ57wtRkmG0CNZPv0d5zWcyX4AAUyig7Bs+whbDCI9ZyyLNN
 TgvjA4BDMrwCfB7qq70/iXBXpMUeKr4Fbo7X4GRGO4tNwj1t49xz984jHPM83Z4s3ZuLKBO/F1
 X7baqwlPUCknttTHeWsvs+gFCH8qwIy46YTEfdFo/FdN/ewrST6Iwus1RYbGchuosO6rcKTUY0
 QWeqgAHGngKibqBllNSTpyLo+g9CEG6Kes8qfxpuEOUC5eKQBupzJ/hGIVmnDhrgNLHc4fct0Q
 oO1k0d70P6Rz9REl8J2XpU28
X-IronPort-AV: E=Sophos;i="5.88,193,1635231600"; 
   d="scan'208";a="146690287"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2021 09:41:13 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 9 Dec 2021 09:41:13 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 9 Dec 2021 09:41:12 -0700
Date:   Thu, 9 Dec 2021 17:43:11 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 6/6] net: lan966x: Add switchdev support
Message-ID: <20211209164311.agnofh275znn5t5c@soft-dev3-1.localhost>
References: <20211209094615.329379-1-horatiu.vultur@microchip.com>
 <20211209094615.329379-7-horatiu.vultur@microchip.com>
 <20211209133616.2kii2xfz5rioii4o@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20211209133616.2kii2xfz5rioii4o@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/09/2021 13:36, Vladimir Oltean wrote:
> 
> On Thu, Dec 09, 2021 at 10:46:15AM +0100, Horatiu Vultur wrote:
> > This adds support for switchdev in lan966x.
> > It offloads to the HW basic forwarding and vlan filtering. To be able to
> > offload this to the HW, it is required to disable promisc mode for ports
> > that are part of the bridge.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
> >  .../ethernet/microchip/lan966x/lan966x_main.c |  41 +-
> >  .../ethernet/microchip/lan966x/lan966x_main.h |  18 +
> >  .../microchip/lan966x/lan966x_switchdev.c     | 548 ++++++++++++++++++
> >  .../ethernet/microchip/lan966x/lan966x_vlan.c |  12 +-
> >  5 files changed, 610 insertions(+), 12 deletions(-)
> >  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> >
> > diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
> > index f7e6068a91cb..d82e896c2e53 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/Makefile
> > +++ b/drivers/net/ethernet/microchip/lan966x/Makefile
> > @@ -6,4 +6,5 @@
> >  obj-$(CONFIG_LAN966X_SWITCH) += lan966x-switch.o
> >
> >  lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
> > -                     lan966x_mac.o lan966x_ethtool.o lan966x_vlan.o
> > +                     lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o \
> > +                     lan966x_vlan.o
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> > index 1b4c7e6b4f85..aee36c1cfa17 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> > @@ -306,7 +306,7 @@ static int lan966x_port_xmit(struct sk_buff *skb, struct net_device *dev)
> >       return lan966x_port_ifh_xmit(skb, ifh, dev);
> >  }
> >
> > -static void lan966x_set_promisc(struct lan966x_port *port, bool enable)
> > +void lan966x_set_promisc(struct lan966x_port *port, bool enable)
> >  {
> >       struct lan966x *lan966x = port->lan966x;
> >
> 
> My documentation of CPU_SRC_COPY_ENA says:
> 
> If set, all frames received on this port are
> copied to the CPU extraction queue given by
> CPUQ_CFG.CPUQ_SRC_COPY.
> 
> I think it was established a while ago that this isn't what promiscuous
> mode is about? Instead it is about accepting packets on a port
> regardless of whether the MAC DA is in their RX filter or not.

Yes, I am aware that this change interprets the things differently and I
am totally OK to drop this promisc if it is needed.

> 
> Hence the oddity of your change. I understand what it intends to do:
> if this is a standalone port you support IFF_UNICAST_FLT, so you drop
> frames with unknown MAC DA. But if IFF_PROMISC is set, then why do you
> copy all frames to the CPU? Why don't you just put the CPU in the
> unknown flooding mask?

Because I don't want the CPU to be in the unknown flooding mask. I want
to send frames to the CPU only if it is required.

> There's a difference between "force a packet to
> get copied to the CPU" and "copy it to the CPU only if it may have
> business there". Then this change would be compatible with bridge mode.
> You want the bridge to receive unknown traffic too, it may need to
> forward it in software.

I don't want to bridge to receive unknown traffic if I know it would
just drop it.

> 
> > @@ -318,14 +318,18 @@ static void lan966x_set_promisc(struct lan966x_port *port, bool enable)
> >  static void lan966x_port_change_rx_flags(struct net_device *dev, int flags)
> >  {
> >       struct lan966x_port *port = netdev_priv(dev);
> > +     bool enable;
> >
> >       if (!(flags & IFF_PROMISC))
> >               return;
> >
> > -     if (dev->flags & IFF_PROMISC)
> > -             lan966x_set_promisc(port, true);
> > -     else
> > -             lan966x_set_promisc(port, false);
> > +     enable = dev->flags & IFF_PROMISC ? true : false;
> > +     port->promisc = enable;
> > +
> > +     if (port->bridge)
> > +             return;
> > +
> > +     lan966x_set_promisc(port, enable);
> >  }
> >
> >  static int lan966x_port_change_mtu(struct net_device *dev, int new_mtu)
> > @@ -340,7 +344,7 @@ static int lan966x_port_change_mtu(struct net_device *dev, int new_mtu)
> >       return 0;
> >  }
> >
> > -static int lan966x_mc_unsync(struct net_device *dev, const unsigned char *addr)
> > +int lan966x_mc_unsync(struct net_device *dev, const unsigned char *addr)
> >  {
> >       struct lan966x_port *port = netdev_priv(dev);
> >       struct lan966x *lan966x = port->lan966x;
> > @@ -348,7 +352,7 @@ static int lan966x_mc_unsync(struct net_device *dev, const unsigned char *addr)
> >       return lan966x_mac_forget(lan966x, addr, port->pvid, ENTRYTYPE_LOCKED);
> >  }
> >
> > -static int lan966x_mc_sync(struct net_device *dev, const unsigned char *addr)
> > +int lan966x_mc_sync(struct net_device *dev, const unsigned char *addr)
> >  {
> >       struct lan966x_port *port = netdev_priv(dev);
> >       struct lan966x *lan966x = port->lan966x;
> > @@ -401,6 +405,11 @@ static const struct net_device_ops lan966x_port_netdev_ops = {
> >       .ndo_vlan_rx_kill_vid           = lan966x_vlan_rx_kill_vid,
> >  };
> >
> > +bool lan966x_netdevice_check(const struct net_device *dev)
> > +{
> > +     return dev && (dev->netdev_ops == &lan966x_port_netdev_ops);
> 
> Can "dev" ever be NULL?

It doesn't look like that. I will remove it.

> 
> > +}
> > +
> >  static int lan966x_port_xtr_status(struct lan966x *lan966x, u8 grp)
> >  {
> >       return lan_rd(lan966x, QS_XTR_RD(grp));
> > @@ -537,6 +546,11 @@ static irqreturn_t lan966x_xtr_irq_handler(int irq, void *args)
> >
> >               skb->protocol = eth_type_trans(skb, dev);
> >
> > +#ifdef CONFIG_NET_SWITCHDEV
> > +             if (lan966x->ports[src_port]->bridge)
> > +                     skb->offload_fwd_mark = 1;
> > +#endif
> > +
> >               netif_rx_ni(skb);
> >               dev->stats.rx_bytes += len;
> >               dev->stats.rx_packets++;
> > @@ -619,13 +633,16 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
> >
> >       dev->netdev_ops = &lan966x_port_netdev_ops;
> >       dev->ethtool_ops = &lan966x_ethtool_ops;
> > +     dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER |
> > +                         NETIF_F_RXFCS;
> > +     dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
> > +                      NETIF_F_HW_VLAN_CTAG_TX |
> > +                      NETIF_F_HW_VLAN_STAG_TX;
> > +     dev->priv_flags |= IFF_UNICAST_FLT;
> 
> Too many changes in one patch. IFF_UNICAST_FLT and the handling of
> promiscuous mode have nothing to do with switchdev.

Well, in this case (because it is a bug in the promisc) it has. Because
the bridge will increase the promiscuity of the interfaces, so then all
the ports will copy the frames to the CPU. Which breaks the entire
purpose of the bridge.

> Neither VLAN filtering via dev->features (should have been part of the previous
> patch), or RXFCS.

I agree, the VLAN filtering should be part of the previous patch and
RXFCS should be totally separate change.

> It seems that each one of these changes was previously
> missed and is now snuck in without the explanation it deserves.
> 
> >       dev->needed_headroom = IFH_LEN * sizeof(u32);
> >
> >       eth_hw_addr_gen(dev, lan966x->base_mac, p + 1);
> >
> > -     lan966x_mac_learn(lan966x, PGID_CPU, dev->dev_addr, port->pvid,
> > -                       ENTRYTYPE_LOCKED);
> > -
> 
> Why is this deleted? If the port uses IFF_UNICAST_FLT and isn't
> promiscuous, how does it get the unicast traffic it needs?
> I may be not realizing something because the changes aren't properly
> split.

The functionality is moved inside function 'lan966x_port_add_addr'.

> 
> >       port->phylink_config.dev = &port->dev->dev;
> >       port->phylink_config.type = PHYLINK_NETDEV;
> >       port->phylink_pcs.poll = true;
> > @@ -949,6 +966,8 @@ static int lan966x_probe(struct platform_device *pdev)
> >               lan966x_port_init(lan966x->ports[p]);
> >       }
> >
> > +     lan966x_register_notifier_blocks(lan966x);
> > +
> >       return 0;
> >
> >  cleanup_ports:
> > @@ -967,6 +986,8 @@ static int lan966x_remove(struct platform_device *pdev)
> >  {
> >       struct lan966x *lan966x = platform_get_drvdata(pdev);
> >
> > +     lan966x_unregister_notifier_blocks(lan966x);
> > +
> >       lan966x_cleanup_ports(lan966x);
> >
> >       cancel_delayed_work_sync(&lan966x->stats_work);
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > index ec3eccf634b3..4a0988087167 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > @@ -80,6 +80,11 @@ struct lan966x {
> >       struct list_head mac_entries;
> >       spinlock_t mac_lock; /* lock for mac_entries list */
> >
> > +     /* Notifiers */
> > +     struct notifier_block netdevice_nb;
> > +     struct notifier_block switchdev_nb;
> > +     struct notifier_block switchdev_blocking_nb;
> > +
> >       u16 vlan_mask[VLAN_N_VID];
> >       DECLARE_BITMAP(cpu_vlan_mask, VLAN_N_VID);
> >
> > @@ -112,6 +117,10 @@ struct lan966x_port {
> >       struct net_device *dev;
> >       struct lan966x *lan966x;
> >
> > +     struct net_device *bridge;
> > +     u8 stp_state;
> > +     u8 promisc;
> > +
> >       u8 chip_port;
> >       u16 pvid;
> >       u16 vid;
> > @@ -129,6 +138,14 @@ extern const struct phylink_mac_ops lan966x_phylink_mac_ops;
> >  extern const struct phylink_pcs_ops lan966x_phylink_pcs_ops;
> >  extern const struct ethtool_ops lan966x_ethtool_ops;
> >
> > +int lan966x_mc_unsync(struct net_device *dev, const unsigned char *addr);
> > +int lan966x_mc_sync(struct net_device *dev, const unsigned char *addr);
> > +
> > +bool lan966x_netdevice_check(const struct net_device *dev);
> > +
> > +int lan966x_register_notifier_blocks(struct lan966x *lan966x);
> > +void lan966x_unregister_notifier_blocks(struct lan966x *lan966x);
> > +
> >  void lan966x_stats_get(struct net_device *dev,
> >                      struct rtnl_link_stats64 *stats);
> >  int lan966x_stats_init(struct lan966x *lan966x);
> > @@ -139,6 +156,7 @@ void lan966x_port_status_get(struct lan966x_port *port,
> >                            struct phylink_link_state *state);
> >  int lan966x_port_pcs_set(struct lan966x_port *port,
> >                        struct lan966x_port_config *config);
> > +void lan966x_set_promisc(struct lan966x_port *port, bool enable);
> >  void lan966x_port_init(struct lan966x_port *port);
> >
> >  int lan966x_mac_learn(struct lan966x *lan966x, int port,
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> > new file mode 100644
> > index 000000000000..ed6ec78d2d9a
> > --- /dev/null
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> > @@ -0,0 +1,548 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +
> > +#include <linux/if_bridge.h>
> > +#include <net/switchdev.h>
> > +
> > +#include "lan966x_main.h"
> > +
> > +static struct workqueue_struct *lan966x_owq;
> > +
> > +struct lan966x_fdb_event_work {
> > +     struct work_struct work;
> > +     struct switchdev_notifier_fdb_info fdb_info;
> > +     struct net_device *dev;
> > +     struct lan966x *lan966x;
> > +     unsigned long event;
> > +};
> > +
> > +static void lan966x_port_attr_bridge_flags(struct lan966x_port *port,
> > +                                        struct switchdev_brport_flags flags)
> > +{
> > +     u32 val = lan_rd(port->lan966x, ANA_PGID(PGID_MC));
> > +
> > +     val = ANA_PGID_PGID_GET(val);
> > +
> > +     if (flags.mask & BR_MCAST_FLOOD) {
> > +             if (flags.val & BR_MCAST_FLOOD)
> > +                     val |= BIT(port->chip_port);
> > +             else
> > +                     val &= ~BIT(port->chip_port);
> > +     }
> > +
> > +     lan_rmw(ANA_PGID_PGID_SET(val),
> > +             ANA_PGID_PGID,
> > +             port->lan966x, ANA_PGID(PGID_MC));
> > +}
> > +
> > +static u32 lan966x_get_fwd_mask(struct lan966x_port *port)
> > +{
> > +     struct net_device *bridge = port->bridge;
> > +     struct lan966x *lan966x = port->lan966x;
> > +     u8 ingress_src = port->chip_port;
> > +     u32 mask = 0;
> > +     int p;
> > +
> > +     if (port->stp_state != BR_STATE_FORWARDING)
> > +             goto skip_forwarding;
> > +
> > +     for (p = 0; p < lan966x->num_phys_ports; p++) {
> > +             port = lan966x->ports[p];
> > +
> > +             if (!port)
> > +                     continue;
> > +
> > +             if (port->stp_state == BR_STATE_FORWARDING &&
> > +                 port->bridge == bridge)
> > +                     mask |= BIT(p);
> > +     }
> > +
> > +skip_forwarding:
> > +     mask &= ~BIT(ingress_src);
> > +
> > +     return mask;
> > +}
> > +
> > +static void lan966x_update_fwd_mask(struct lan966x *lan966x)
> > +{
> > +     int p;
> > +
> > +     for (p = 0; p < lan966x->num_phys_ports; p++) {
> > +             struct lan966x_port *port = lan966x->ports[p];
> > +             unsigned long mask = 0;
> > +
> > +             if (port->bridge)
> > +                     mask = lan966x_get_fwd_mask(port);
> > +
> > +             mask |= BIT(CPU_PORT);
> > +
> > +             lan_wr(ANA_PGID_PGID_SET(mask),
> > +                    lan966x, ANA_PGID(PGID_SRC + p));
> > +     }
> > +}
> > +
> > +static void lan966x_attr_stp_state_set(struct lan966x_port *port,
> > +                                    u8 state)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +     bool learn_ena = 0;
> > +
> > +     port->stp_state = state;
> > +
> > +     if (state == BR_STATE_FORWARDING || state == BR_STATE_LEARNING)
> > +             learn_ena = 1;
> 
> Please use true/false for bool types.

Will do that.

> 
> > +
> > +     lan_rmw(ANA_PORT_CFG_LEARN_ENA_SET(learn_ena),
> > +             ANA_PORT_CFG_LEARN_ENA,
> > +             lan966x, ANA_PORT_CFG(port->chip_port));
> > +
> > +     lan966x_update_fwd_mask(lan966x);
> > +}
> > +
> > +static void lan966x_port_attr_ageing_set(struct lan966x_port *port,
> > +                                      unsigned long ageing_clock_t)
> > +{
> > +     unsigned long ageing_jiffies = clock_t_to_jiffies(ageing_clock_t);
> > +     u32 ageing_time = jiffies_to_msecs(ageing_jiffies) / 1000;
> > +
> > +     lan966x_mac_set_ageing(port->lan966x, ageing_time);
> > +}
> > +
> > +static int lan966x_port_attr_set(struct net_device *dev, const void *ctx,
> > +                              const struct switchdev_attr *attr,
> > +                              struct netlink_ext_ack *extack)
> > +{
> > +     struct lan966x_port *port = netdev_priv(dev);
> > +
> > +     switch (attr->id) {
> > +     case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
> > +             lan966x_port_attr_bridge_flags(port, attr->u.brport_flags);
> > +             break;
> 
> no SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS? I think it doesn't even work
> if you don't handle that?
> 
> br_switchdev_set_port_flag():
> 
>         attr.id = SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS;
>         attr.u.brport_flags.val = flags;
>         attr.u.brport_flags.mask = mask;
> 
>         /* We run from atomic context here */
>         err = call_switchdev_notifiers(SWITCHDEV_PORT_ATTR_SET, p->dev,
>                                        &info.info, extack);
>         err = notifier_to_errno(err);
>         if (err == -EOPNOTSUPP)
>                 return 0;
> 
> Anyway, a big blob of "switchdev support" is hard to follow and review.
> If you add bridge port flags you could as well add more comprehensive
> support for them, but in a separate change please. Forwarding domain is
> one thing, FDB/MDB is another, VLAN is another.

Good catch. I will try to split it as you suggested.

> 
> > +     case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
> > +             lan966x_attr_stp_state_set(port, attr->u.stp_state);
> > +             break;
> > +     case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
> > +             lan966x_port_attr_ageing_set(port, attr->u.ageing_time);
> > +             break;
> > +     case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
> > +             lan966x_vlan_port_set_vlan_aware(port, attr->u.vlan_filtering);
> > +             lan966x_vlan_port_apply(port);
> > +             lan966x_vlan_cpu_set_vlan_aware(port);
> > +             break;
> > +     default:
> > +             return -EOPNOTSUPP;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static int lan966x_port_bridge_join(struct lan966x_port *port,
> > +                                 struct net_device *bridge,
> > +                                 struct netlink_ext_ack *extack)
> > +{
> > +     struct net_device *dev = port->dev;
> > +     int err;
> > +
> > +     err = switchdev_bridge_port_offload(dev, dev, NULL, NULL, NULL,
> > +                                         false, extack);
> > +     if (err)
> > +             return err;
> > +
> > +     port->bridge = bridge;
> > +
> > +     /* Port enters in bridge mode therefor don't need to copy to CPU
> > +      * frames for multicast in case the bridge is not requesting them
> > +      */
> > +     __dev_mc_unsync(dev, lan966x_mc_unsync);
> 
> Why is there a need to unsync the addresses, though? A driver that
> supports proper MAC table isolation between standalone ports and
> VLAN-unaware bridge ports should use separate pvids for the two modes of
> operation (if it doesn't support other isolation mechanisms apart from VLAN,
> which it looks like lan966x does not). I see that your driver even does
> this in lan966x_vlan_port_get_pvid(). So the non-bridge multicast
> addresses could sit there even when the port is in a bridge.

Really good observation.
Initially I had the same PVID for standalone and vlan-unaware bridge
ports. So then I have added all these but now that they use different
PVID I can remove this.

> 
> > +
> > +     /* make sure that the promisc is disabled when entering under the bridge
> > +      * because we don't want all the frames to come to CPU
> > +      */
> > +     lan966x_set_promisc(port, false);
> 
> What's the story here? Why don't other switchdev drivers handle promisc
> in this way (copy all frames to the CPU)?

I can't say about other switchdev drivers, but in our case we really
don't want all the frames to the CPU. The function lan966x_set_promisc
was setting the port to copy all the frames to the CPU, which we don't
want when the port is part of the bridge.

> 
> > +
> > +     return 0;
> > +}
> > +
> > +static void lan966x_port_bridge_leave(struct lan966x_port *port,
> > +                                   struct net_device *bridge)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +
> > +     switchdev_bridge_port_unoffload(port->dev, NULL, NULL, NULL);
> 
> The bridge offers a facility to sync and unsync the host addresses on
> joins and leaves. For this to work, the switchdev_bridge_port_unoffload
> call should be during the NETDEV_PRECHANGEUPPER notifier event.
> 
> > +     port->bridge = NULL;
> > +
> > +     /* Set the port back to host mode */
> > +     lan966x_vlan_port_set_vlan_aware(port, 0);
> 
> s/0/false/
> 
> > +     lan966x_vlan_port_set_vid(port, HOST_PVID, false, false);
> > +     lan966x_vlan_port_apply(port);
> > +
> > +     lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, HOST_PVID);
> > +
> > +     /* Port enters in host more therefore restore mc list */
> > +     __dev_mc_sync(port->dev, lan966x_mc_sync, lan966x_mc_unsync);
> > +
> > +     /* Restore back the promisc as it was before the interfaces was added to
> > +      * the bridge
> > +      */
> > +     lan966x_set_promisc(port, port->promisc);
> > +}
> > +
> > +static int lan966x_port_changeupper(struct net_device *dev,
> > +                                 struct netdev_notifier_changeupper_info *info)
> > +{
> > +     struct lan966x_port *port = netdev_priv(dev);
> > +     struct netlink_ext_ack *extack;
> > +     int err = 0;
> > +
> > +     extack = netdev_notifier_info_to_extack(&info->info);
> > +
> > +     if (netif_is_bridge_master(info->upper_dev)) {
> > +             if (info->linking)
> > +                     err = lan966x_port_bridge_join(port, info->upper_dev,
> > +                                                    extack);
> > +             else
> > +                     lan966x_port_bridge_leave(port, info->upper_dev);
> > +     }
> > +
> > +     return err;
> > +}
> > +
> > +static int lan966x_port_add_addr(struct net_device *dev, bool up)
> > +{
> > +     struct lan966x_port *port = netdev_priv(dev);
> > +     struct lan966x *lan966x = port->lan966x;
> > +     u16 vid;
> > +
> > +     vid = lan966x_vlan_port_get_pvid(port);
> > +
> > +     if (up)
> > +             lan966x_mac_cpu_learn(lan966x, dev->dev_addr, vid);
> > +     else
> > +             lan966x_mac_cpu_forget(lan966x, dev->dev_addr, vid);
> 
> For which uppers is this intended? The bridge? Because the bridge
> notifies you of all the entries it needs, if you also consider the
> replayed events and provide non-NULL pointers to
> switchdev_bridge_port_offload.

No, this up just means if the port is up or down. Doesn't have anything
to do with the bridge. This code replace the code from
lan966x_probe_port.

> 
> > +
> > +     return 0;
> > +}
> > +
> > +static int lan966x_netdevice_port_event(struct net_device *dev,
> > +                                     struct notifier_block *nb,
> > +                                     unsigned long event, void *ptr)
> > +{
> > +     int err = 0;
> > +
> > +     if (!lan966x_netdevice_check(dev))
> > +             return 0;
> > +
> > +     switch (event) {
> > +     case NETDEV_CHANGEUPPER:
> > +             err = lan966x_port_changeupper(dev, ptr);
> > +             break;
> > +     case NETDEV_PRE_UP:
> > +             err = lan966x_port_add_addr(dev, true);
> > +             break;
> > +     case NETDEV_DOWN:
> > +             err = lan966x_port_add_addr(dev, false);
> > +             break;
> > +     }
> > +
> > +     return err;
> > +}
> > +
> > +static int lan966x_netdevice_event(struct notifier_block *nb,
> > +                                unsigned long event, void *ptr)
> > +{
> > +     struct net_device *dev = netdev_notifier_info_to_dev(ptr);
> > +     int ret;
> > +
> > +     ret = lan966x_netdevice_port_event(dev, nb, event, ptr);
> > +
> > +     return notifier_from_errno(ret);
> > +}
> > +
> > +static void lan966x_fdb_event_work(struct work_struct *work)
> > +{
> > +     struct lan966x_fdb_event_work *fdb_work =
> > +             container_of(work, struct lan966x_fdb_event_work, work);
> > +     struct switchdev_notifier_fdb_info *fdb_info;
> > +     struct net_device *dev = fdb_work->dev;
> > +     struct lan966x_port *port;
> > +     struct lan966x *lan966x;
> > +
> > +     rtnl_lock();
> 
> rtnl_lock() shouldn't be needed.
> 
> > +
> > +     fdb_info = &fdb_work->fdb_info;
> > +     lan966x = fdb_work->lan966x;
> > +
> > +     if (lan966x_netdevice_check(dev)) {
> > +             port = netdev_priv(dev);
> > +
> > +             switch (fdb_work->event) {
> > +             case SWITCHDEV_FDB_ADD_TO_DEVICE:
> > +                     if (!fdb_info->added_by_user)
> > +                             break;
> 
> If you get notified of a MAC address dynamically learned by the software
> bridge on a lan966x port, you will have allocated memory for the work
> item, and scheduled it, for nothing. Please try to exit unnecessary work
> early.

Yes, I will add an early check.

> 
> > +                     lan966x_mac_add_entry(lan966x, port, fdb_info->addr,
> > +                                           fdb_info->vid);
> > +                     break;
> > +             case SWITCHDEV_FDB_DEL_TO_DEVICE:
> > +                     if (!fdb_info->added_by_user)
> > +                             break;
> > +                     lan966x_mac_del_entry(lan966x, fdb_info->addr, fdb_info->vid);
> > +                     break;
> > +             }
> > +     } else {
> > +             if (!netif_is_bridge_master(dev))
> > +                     goto out;
> > +
> > +             /* If the CPU is not part of the vlan then there is no point
> > +              * to copy the frames to the CPU because they will be dropped
> > +              */
> > +             if (!lan966x_vlan_cpu_member_vlan_mask(lan966x, fdb_info->vid))
> > +                     goto out;
> 
> It isn't part of the VLAN now, but what about later? I don't see that
> you keep these FDB entries anywhere and restore them when a port joins
> that VLAN.

Actually I do that. It is inside lan966x_vlan_port_add_vlan. There I
check if the CPU is part of the VLAN then add that entry.

> 
> > +
> > +             /* In case the bridge is called */
> > +             switch (fdb_work->event) {
> > +             case SWITCHDEV_FDB_ADD_TO_DEVICE:
> > +                     /* If there is no front port in this vlan, there is no
> > +                      * point to copy the frame to CPU because it would be
> > +                      * just dropped at later point. So add it only if
> > +                      * there is a port
> > +                      */
> > +                     if (!lan966x_vlan_port_any_vlan_mask(lan966x, fdb_info->vid))
> > +                             break;
> > +
> > +                     lan966x_mac_cpu_learn(lan966x, fdb_info->addr, fdb_info->vid);
> 
> Does the lan966x_mac_cpu_learn() operation trigger interrupts, or only
> the dynamic learning process?

Only dynamic learning process.

> How do you handle migration of an FDB entry pointing towards the CPU,
> towards one pointing towards a port?

Shouldn't I get 2 calls that the entry is removed from CPU and then
added to a port?

> 
> > +                     break;
> > +             case SWITCHDEV_FDB_DEL_TO_DEVICE:
> > +                     /* It is OK to always forget the entry it */
> 
> Forget the entry it?

It was a typo. I will remove the 'it'.

> 
> > +                     lan966x_mac_cpu_forget(lan966x, fdb_info->addr, fdb_info->vid);
> > +                     break;
> > +             }
> > +     }
> > +
> > +out:
> > +     rtnl_unlock();
> > +     kfree(fdb_work->fdb_info.addr);
> > +     kfree(fdb_work);
> > +     dev_put(dev);
> > +}
> > +
> > +static int lan966x_switchdev_event(struct notifier_block *nb,
> > +                                unsigned long event, void *ptr)
> > +{
> > +     struct lan966x *lan966x = container_of(nb, struct lan966x, switchdev_nb);
> > +     struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
> > +     struct switchdev_notifier_fdb_info *fdb_info;
> > +     struct switchdev_notifier_info *info = ptr;
> > +     struct lan966x_fdb_event_work *fdb_work;
> > +     int err;
> > +
> > +     switch (event) {
> > +     case SWITCHDEV_PORT_ATTR_SET:
> > +             err = switchdev_handle_port_attr_set(dev, ptr,
> > +                                                  lan966x_netdevice_check,
> > +                                                  lan966x_port_attr_set);
> > +             return notifier_from_errno(err);
> > +     case SWITCHDEV_FDB_ADD_TO_DEVICE:
> > +             fallthrough;
> 
> "fallthrough;" not needed here.
> 
> > +     case SWITCHDEV_FDB_DEL_TO_DEVICE:
> > +             fdb_work = kzalloc(sizeof(*fdb_work), GFP_ATOMIC);
> > +             if (!fdb_work)
> > +                     return NOTIFY_BAD;
> > +
> > +             fdb_info = container_of(info,
> > +                                     struct switchdev_notifier_fdb_info,
> > +                                     info);
> > +
> > +             fdb_work->dev = dev;
> > +             fdb_work->lan966x = lan966x;
> > +             fdb_work->event = event;
> > +             INIT_WORK(&fdb_work->work, lan966x_fdb_event_work);
> > +             memcpy(&fdb_work->fdb_info, ptr, sizeof(fdb_work->fdb_info));
> > +             fdb_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
> > +             if (!fdb_work->fdb_info.addr)
> > +                     goto err_addr_alloc;
> > +
> > +             ether_addr_copy((u8 *)fdb_work->fdb_info.addr, fdb_info->addr);
> > +             dev_hold(dev);
> > +
> > +             queue_work(lan966x_owq, &fdb_work->work);
> > +             break;
> > +     }
> > +
> > +     return NOTIFY_DONE;
> > +err_addr_alloc:
> > +     kfree(fdb_work);
> > +     return NOTIFY_BAD;
> > +}
> > +
> > +static int lan966x_handle_port_vlan_add(struct net_device *dev,
> > +                                     struct notifier_block *nb,
> > +                                     const struct switchdev_obj_port_vlan *v)
> > +{
> > +     struct lan966x_port *port;
> > +     struct lan966x *lan966x;
> > +
> > +     /* When adding a port to a vlan, we get a callback for the port but
> > +      * also for the bridge. When get the callback for the bridge just bail
> > +      * out. Then when the bridge is added to the vlan, then we get a
> > +      * callback here but in this case the flags has set:
> > +      * BRIDGE_VLAN_INFO_BRENTRY. In this case it means that the CPU
> > +      * port is added to the vlan, so the broadcast frames and unicast frames
> > +      * with dmac of the bridge should be foward to CPU.
> > +      */
> > +     if (netif_is_bridge_master(dev) &&
> > +         !(v->flags & BRIDGE_VLAN_INFO_BRENTRY))
> > +             return 0;
> > +
> > +     lan966x = container_of(nb, struct lan966x, switchdev_blocking_nb);
> > +
> > +     /* In case the port gets called */
> > +     if (!(netif_is_bridge_master(dev))) {
> > +             if (!lan966x_netdevice_check(dev))
> > +                     return -EOPNOTSUPP;
> > +
> > +             port = netdev_priv(dev);
> > +             return lan966x_vlan_port_add_vlan(port, v->vid,
> > +                                               v->flags & BRIDGE_VLAN_INFO_PVID,
> > +                                               v->flags & BRIDGE_VLAN_INFO_UNTAGGED);
> > +     }
> > +
> > +     /* In case the bridge gets called */
> > +     if (netif_is_bridge_master(dev))
> > +             return lan966x_vlan_cpu_add_vlan(lan966x, dev, v->vid);
> > +
> > +     return 0;
> > +}
> > +
> > +static int lan966x_handle_port_obj_add(struct net_device *dev,
> > +                                    struct notifier_block *nb,
> > +                                    struct switchdev_notifier_port_obj_info *info)
> > +{
> > +     const struct switchdev_obj *obj = info->obj;
> > +     int err;
> > +
> > +     switch (obj->id) {
> > +     case SWITCHDEV_OBJ_ID_PORT_VLAN:
> > +             err = lan966x_handle_port_vlan_add(dev, nb,
> > +                                                SWITCHDEV_OBJ_PORT_VLAN(obj));
> > +             break;
> > +     default:
> > +             err = -EOPNOTSUPP;
> > +             break;
> > +     }
> > +
> > +     info->handled = true;
> > +     return err;
> > +}
> > +
> > +static int lan966x_handle_port_vlan_del(struct net_device *dev,
> > +                                     struct notifier_block *nb,
> > +                                     const struct switchdev_obj_port_vlan *v)
> > +{
> > +     struct lan966x_port *port;
> > +     struct lan966x *lan966x;
> > +
> > +     lan966x = container_of(nb, struct lan966x, switchdev_blocking_nb);
> > +
> > +     /* In case the physical port gets called */
> > +     if (!netif_is_bridge_master(dev)) {
> > +             if (!lan966x_netdevice_check(dev))
> > +                     return -EOPNOTSUPP;
> > +
> > +             port = netdev_priv(dev);
> > +             return lan966x_vlan_port_del_vlan(port, v->vid);
> > +     }
> > +
> > +     /* In case the bridge gets called */
> > +     if (netif_is_bridge_master(dev))
> > +             return lan966x_vlan_cpu_del_vlan(lan966x, dev, v->vid);
> > +
> > +     return 0;
> > +}
> > +
> > +static int lan966x_handle_port_obj_del(struct net_device *dev,
> > +                                    struct notifier_block *nb,
> > +                                    struct switchdev_notifier_port_obj_info *info)
> > +{
> > +     const struct switchdev_obj *obj = info->obj;
> > +     int err;
> > +
> > +     switch (obj->id) {
> > +     case SWITCHDEV_OBJ_ID_PORT_VLAN:
> > +             err = lan966x_handle_port_vlan_del(dev, nb,
> > +                                                SWITCHDEV_OBJ_PORT_VLAN(obj));
> > +             break;
> > +     default:
> > +             err = -EOPNOTSUPP;
> > +             break;
> > +     }
> > +
> > +     info->handled = true;
> > +     return err;
> > +}
> > +
> > +static int lan966x_switchdev_blocking_event(struct notifier_block *nb,
> > +                                         unsigned long event,
> > +                                         void *ptr)
> > +{
> > +     struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
> > +     int err;
> > +
> > +     switch (event) {
> > +     case SWITCHDEV_PORT_OBJ_ADD:
> > +             err = lan966x_handle_port_obj_add(dev, nb, ptr);
> > +             return notifier_from_errno(err);
> > +     case SWITCHDEV_PORT_OBJ_DEL:
> > +             err = lan966x_handle_port_obj_del(dev, nb, ptr);
> > +             return notifier_from_errno(err);
> > +     case SWITCHDEV_PORT_ATTR_SET:
> > +             err = switchdev_handle_port_attr_set(dev, ptr,
> > +                                                  lan966x_netdevice_check,
> > +                                                  lan966x_port_attr_set);
> > +             return notifier_from_errno(err);
> > +     }
> > +
> > +     return NOTIFY_DONE;
> > +}
> > +
> > +int lan966x_register_notifier_blocks(struct lan966x *lan966x)
> > +{
> > +     int err;
> > +
> > +     lan966x->netdevice_nb.notifier_call = lan966x_netdevice_event;
> > +     err = register_netdevice_notifier(&lan966x->netdevice_nb);
> > +     if (err)
> > +             return err;
> > +
> > +     lan966x->switchdev_nb.notifier_call = lan966x_switchdev_event;
> > +     err = register_switchdev_notifier(&lan966x->switchdev_nb);
> > +     if (err)
> > +             goto err_switchdev_nb;
> > +
> > +     lan966x->switchdev_blocking_nb.notifier_call = lan966x_switchdev_blocking_event;
> > +     err = register_switchdev_blocking_notifier(&lan966x->switchdev_blocking_nb);
> > +     if (err)
> > +             goto err_switchdev_blocking_nb;
> > +
> > +     lan966x_owq = alloc_ordered_workqueue("lan966x_order", 0);
> > +     if (!lan966x_owq) {
> > +             err = -ENOMEM;
> > +             goto err_switchdev_blocking_nb;
> > +     }
> 
> These should be singleton objects, otherwise things get problematic if
> you have more than one switch device instantiated in the system.

Yes, I will update this.

> 
> > +
> > +     return 0;
> > +
> > +err_switchdev_blocking_nb:
> > +     unregister_switchdev_notifier(&lan966x->switchdev_nb);
> > +err_switchdev_nb:
> > +     unregister_netdevice_notifier(&lan966x->netdevice_nb);
> > +
> > +     return err;
> > +}
> > +
> > +void lan966x_unregister_notifier_blocks(struct lan966x *lan966x)
> > +{
> > +     destroy_workqueue(lan966x_owq);
> > +
> > +     unregister_switchdev_blocking_notifier(&lan966x->switchdev_blocking_nb);
> > +     unregister_switchdev_notifier(&lan966x->switchdev_nb);
> > +     unregister_netdevice_notifier(&lan966x->netdevice_nb);
> > +}
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
> > index e47552775d06..26644503b4e6 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
> > @@ -155,6 +155,9 @@ static bool lan966x_vlan_cpu_member_cpu_vlan_mask(struct lan966x *lan966x, u16 v
> >
> >  u16 lan966x_vlan_port_get_pvid(struct lan966x_port *port)
> >  {
> > +     if (!port->bridge)
> > +             return HOST_PVID;
> > +
> >       return port->vlan_aware ? port->pvid : UNAWARE_PVID;
> >  }
> >
> > @@ -210,6 +213,8 @@ void lan966x_vlan_cpu_set_vlan_aware(struct lan966x_port *port)
> >                * table for the front port and the CPU
> >                */
> >               lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, UNAWARE_PVID);
> > +             lan966x_mac_cpu_learn(lan966x, port->bridge->dev_addr,
> > +                                   UNAWARE_PVID);
> >
> >               lan966x_vlan_port_add_vlan_mask(port, UNAWARE_PVID);
> >               lan966x_vlan_port_apply(port);
> > @@ -218,6 +223,8 @@ void lan966x_vlan_cpu_set_vlan_aware(struct lan966x_port *port)
> >                * to vlan unaware
> >                */
> >               lan966x_mac_cpu_forget(lan966x, port->dev->dev_addr, UNAWARE_PVID);
> > +             lan966x_mac_cpu_forget(lan966x, port->bridge->dev_addr,
> > +                                    UNAWARE_PVID);
> >
> >               lan966x_vlan_port_del_vlan_mask(port, UNAWARE_PVID);
> >               lan966x_vlan_port_apply(port);
> > @@ -293,6 +300,7 @@ int lan966x_vlan_port_add_vlan(struct lan966x_port *port,
> >        */
> >       if (lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x, vid)) {
> >               lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, vid);
> > +             lan966x_mac_cpu_learn(lan966x, port->bridge->dev_addr, vid);
> >               lan966x_vlan_cpu_add_vlan_mask(lan966x, vid);
> >       }
> >
> > @@ -322,8 +330,10 @@ int lan966x_vlan_port_del_vlan(struct lan966x_port *port,
> >        * that vlan but still keep it in the mask because it may be needed
> >        * again then another port gets added in tha vlan
> >        */
> > -     if (!lan966x_vlan_port_any_vlan_mask(lan966x, vid))
> > +     if (!lan966x_vlan_port_any_vlan_mask(lan966x, vid)) {
> > +             lan966x_mac_cpu_forget(lan966x, port->bridge->dev_addr, vid);
> >               lan966x_vlan_cpu_del_vlan_mask(lan966x, vid);
> > +     }
> >
> >       return 0;
> >  }
> > --
> > 2.33.0
> >

-- 
/Horatiu

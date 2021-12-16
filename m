Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BBB4774B3
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 15:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238038AbhLPOc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 09:32:29 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:34942 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237880AbhLPOc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 09:32:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639665148; x=1671201148;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2X1L0+TOW2vOdRgWGk/1EQ+BdVOTmAyvicaHRLA0lMg=;
  b=P6GvnLHtt+bFpfAyiAB8KUdD7AJASWGbCr3WQ52dZkyQ9r26iet8hpPV
   Xd2yWx5UD53UtfadjfT62Wc8jkWRqcxQG4XXE97qf2J+YPJvUBRgd3dE5
   mK8CpyhXckt3DgI69HNNwmeRKaeM8LOIKLjC009BSYtmlwZjcurLOlk2Q
   cZQCo25zKuqrsVD+9fvOd1QFYXschSRWGgcM01XuZWsDAt5r7JwjLc8Uj
   v06X8E/c0uOYYaCzucp2rCdXYJqRJJzDnY4aN4XeWZO4dZq/MEMlN3JGc
   ZYMZNkcpUOa9PMCoBhvv5/zmCT5KTum12BA+EaNiaUjfU6hmBS/HuNlX5
   w==;
IronPort-SDR: PbxAp8J31z5CQGPr+Ds2IDPNXISogOO3MgWBVWNwsuRpLGfNtOnMJKXGQY7pDIWTdGMlUNrnHQ
 ly1dKAOLQs4DUqDH03y4+OdlmOtSP8JgJ9P07jdaP5DD90qjYm/5fewmDlYCLJEKwv2Qt6k1YL
 oJVfFtbQuiz69cWcoXuN5JdugyOA9CVtyBW5ka5uDvJ7w5m4U7nlty0w9MlZZy+MobhiYNwqRI
 BRbYlkKYHNP9GDUfzCbjlgYNupkP6t3FHIQFgsykNRrpkfsIxNwzATG9lcLEnva8sgcstAdmaU
 lIdQ6zMLYo7f81D8gYUnokr4
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="142640584"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Dec 2021 07:32:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 16 Dec 2021 07:32:27 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 16 Dec 2021 07:32:26 -0700
Date:   Thu, 16 Dec 2021 15:34:30 +0100
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
Subject: Re: [PATCH net-next v5 6/9] net: lan966x: Add support to offload the
 forwarding.
Message-ID: <20211216143430.os2p4avu6634rqzm@soft-dev3-1.localhost>
References: <20211215121309.3669119-1-horatiu.vultur@microchip.com>
 <20211215121309.3669119-7-horatiu.vultur@microchip.com>
 <20211215235040.2hfkk5nireum6cr5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20211215235040.2hfkk5nireum6cr5@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/15/2021 23:50, Vladimir Oltean wrote:
> 
> On Wed, Dec 15, 2021 at 01:13:06PM +0100, Horatiu Vultur wrote:
> > This patch adds basic support to offload in the HW the forwarding of the
> > frames. The driver registers to the switchdev callbacks and implements
> > the callbacks for attributes SWITCHDEV_ATTR_ID_PORT_STP_STATE and
> > SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME.
> > It is not allowed to add a lan966x port to a bridge that contains a
> > different interface than lan966x.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  .../net/ethernet/microchip/lan966x/Kconfig    |   1 +
> >  .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
> >  .../ethernet/microchip/lan966x/lan966x_main.c |  16 +-
> >  .../ethernet/microchip/lan966x/lan966x_main.h |  11 +
> >  .../microchip/lan966x/lan966x_switchdev.c     | 393 ++++++++++++++++++
> >  5 files changed, 419 insertions(+), 4 deletions(-)
> >  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> >
> > diff --git a/drivers/net/ethernet/microchip/lan966x/Kconfig b/drivers/net/ethernet/microchip/lan966x/Kconfig
> > index 2860a8c9923d..ac273f84b69e 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/Kconfig
> > +++ b/drivers/net/ethernet/microchip/lan966x/Kconfig
> > @@ -2,6 +2,7 @@ config LAN966X_SWITCH
> >       tristate "Lan966x switch driver"
> >       depends on HAS_IOMEM
> >       depends on OF
> > +     depends on NET_SWITCHDEV
> >       select PHYLINK
> >       select PACKING
> >       help
> > diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
> > index 2989ba528236..974229c51f55 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/Makefile
> > +++ b/drivers/net/ethernet/microchip/lan966x/Makefile
> > @@ -6,4 +6,4 @@
> >  obj-$(CONFIG_LAN966X_SWITCH) += lan966x-switch.o
> >
> >  lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
> > -                     lan966x_mac.o lan966x_ethtool.o
> > +                     lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> > index dc40ac2eb246..ee453967da71 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> > @@ -355,6 +355,11 @@ static const struct net_device_ops lan966x_port_netdev_ops = {
> >       .ndo_get_port_parent_id         = lan966x_port_get_parent_id,
> >  };
> >
> > +bool lan966x_netdevice_check(const struct net_device *dev)
> > +{
> > +     return dev->netdev_ops == &lan966x_port_netdev_ops;
> > +}
> > +
> >  static int lan966x_port_xtr_status(struct lan966x *lan966x, u8 grp)
> >  {
> >       return lan_rd(lan966x, QS_XTR_RD(grp));
> > @@ -491,6 +496,9 @@ static irqreturn_t lan966x_xtr_irq_handler(int irq, void *args)
> >
> >               skb->protocol = eth_type_trans(skb, dev);
> >
> > +             if (lan966x->bridge_mask & BIT(src_port))
> > +                     skb->offload_fwd_mark = 1;
> > +
> >               netif_rx_ni(skb);
> >               dev->stats.rx_bytes += len;
> >               dev->stats.rx_packets++;
> > @@ -578,9 +586,6 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
> >
> >       eth_hw_addr_gen(dev, lan966x->base_mac, p + 1);
> >
> > -     lan966x_mac_learn(lan966x, PGID_CPU, dev->dev_addr, port->pvid,
> > -                       ENTRYTYPE_LOCKED);
> > -
> >       port->phylink_config.dev = &port->dev->dev;
> >       port->phylink_config.type = PHYLINK_NETDEV;
> >       port->phylink_pcs.poll = true;
> > @@ -897,6 +902,8 @@ static int lan966x_probe(struct platform_device *pdev)
> >               lan966x_port_init(lan966x->ports[p]);
> >       }
> >
> > +     lan966x_register_notifier_blocks(lan966x);
> 
> To be clear, "singleton" would mean that irrespective of the number of
> driver instances, this function would be called once. So calling it from
> lan966x_probe() isn't exactly a good choice, since every instance of the
> driver "probes".

Ah.. yes. I will update it in the next version.

> 
> int dsa_slave_register_notifier(void)
> {
>         struct notifier_block *nb;
>         int err;
> 
>         err = register_netdevice_notifier(&dsa_slave_nb);
>         if (err)
>                 return err;
> 
>         err = register_switchdev_notifier(&dsa_slave_switchdev_notifier);
>         if (err)
>                 goto err_switchdev_nb;
> 
>         nb = &dsa_slave_switchdev_blocking_notifier;
>         err = register_switchdev_blocking_notifier(nb);
>         if (err)
>                 goto err_switchdev_blocking_nb;
> }
> 
> static int __init dsa_init_module(void)
> {
>         rc = dsa_slave_register_notifier();
> }
> module_init(dsa_init_module);
> 
> > +
> >       return 0;
> >
> >  cleanup_ports:
> > @@ -915,6 +922,8 @@ static int lan966x_remove(struct platform_device *pdev)
> >  {
> >       struct lan966x *lan966x = platform_get_drvdata(pdev);
> >
> > +     lan966x_unregister_notifier_blocks(lan966x);
> > +
> >       lan966x_cleanup_ports(lan966x);
> >
> >       cancel_delayed_work_sync(&lan966x->stats_work);
> > @@ -922,6 +931,7 @@ static int lan966x_remove(struct platform_device *pdev)
> >       mutex_destroy(&lan966x->stats_lock);
> >
> >       lan966x_mac_purge_entries(lan966x);
> > +     lan966x_ext_purge_entries();
> 
> Broken with multiple lan966x driver instances - you'd erase all other
> drivers' tabs keps on bridges in the system as soon as one single switch
> is unbound from its driver.

This will not be needed anymore in next version.

> 
> >
> >       return 0;
> >  }
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > index fcd5d09a070c..3d228c9c0521 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > @@ -75,6 +75,10 @@ struct lan966x {
> >
> >       u8 base_mac[ETH_ALEN];
> >
> > +     struct net_device *bridge;
> > +     u16 bridge_mask;
> > +     u16 bridge_fwd_mask;
> > +
> >       struct list_head mac_entries;
> >       spinlock_t mac_lock; /* lock for mac_entries list */
> >
> > @@ -122,6 +126,11 @@ extern const struct phylink_mac_ops lan966x_phylink_mac_ops;
> >  extern const struct phylink_pcs_ops lan966x_phylink_pcs_ops;
> >  extern const struct ethtool_ops lan966x_ethtool_ops;
> >
> > +bool lan966x_netdevice_check(const struct net_device *dev);
> > +
> > +void lan966x_register_notifier_blocks(struct lan966x *lan966x);
> > +void lan966x_unregister_notifier_blocks(struct lan966x *lan966x);
> > +
> >  void lan966x_stats_get(struct net_device *dev,
> >                      struct rtnl_link_stats64 *stats);
> >  int lan966x_stats_init(struct lan966x *lan966x);
> > @@ -157,6 +166,8 @@ int lan966x_mac_add_entry(struct lan966x *lan966x,
> >  void lan966x_mac_purge_entries(struct lan966x *lan966x);
> >  irqreturn_t lan966x_mac_irq_handler(struct lan966x *lan966x);
> >
> > +void lan966x_ext_purge_entries(void);
> > +
> >  static inline void __iomem *lan_addr(void __iomem *base[],
> >                                    int id, int tinst, int tcnt,
> >                                    int gbase, int ginst,
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> > new file mode 100644
> > index 000000000000..722ce7cb61b3
> > --- /dev/null
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> > @@ -0,0 +1,393 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +
> > +#include <linux/if_bridge.h>
> > +#include <net/switchdev.h>
> > +
> > +#include "lan966x_main.h"
> > +
> > +static struct notifier_block lan966x_netdevice_nb __read_mostly;
> > +static struct notifier_block lan966x_switchdev_nb __read_mostly;
> > +static struct notifier_block lan966x_switchdev_blocking_nb __read_mostly;
> > +
> > +static LIST_HEAD(ext_entries);
> > +
> > +struct lan966x_ext_entry {
> > +     struct list_head list;
> > +     struct net_device *dev;
> > +     u32 ports;
> > +     struct lan966x *lan966x;
> > +};
> > +
> > +static void lan966x_update_fwd_mask(struct lan966x *lan966x)
> > +{
> > +     int i;
> > +
> > +     for (i = 0; i < lan966x->num_phys_ports; i++) {
> > +             struct lan966x_port *port = lan966x->ports[i];
> > +             unsigned long mask = 0;
> > +
> > +             if (port && lan966x->bridge_fwd_mask & BIT(i))
> > +                     mask = lan966x->bridge_fwd_mask & ~BIT(i);
> > +
> > +             mask |= BIT(CPU_PORT);
> > +
> > +             lan_wr(ANA_PGID_PGID_SET(mask),
> > +                    lan966x, ANA_PGID(PGID_SRC + i));
> > +     }
> 
> I vaguely remember this was implemented better in previous versions of
> the patch set, and the restriction to not allow multiple bridges
> spanning the same switch wasn't there. Why do you keep disallowing
> multiple bridges for all the Microchip hardware? There are very real use
> cases that need them.

I think there are some cases where this is required. I am not 100% but just
to be in sync with the other Microchip devices, I have implemented the
same.

> 
> > +}
> > +
> > +static void lan966x_port_stp_state_set(struct lan966x_port *port, u8 state)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +     bool learn_ena = false;
> > +
> > +     if (state == BR_STATE_FORWARDING || state == BR_STATE_LEARNING)
> > +             learn_ena = true;
> > +
> > +     if (state == BR_STATE_FORWARDING)
> > +             lan966x->bridge_fwd_mask |= BIT(port->chip_port);
> > +     else
> > +             lan966x->bridge_fwd_mask &= ~BIT(port->chip_port);
> > +
> > +     lan_rmw(ANA_PORT_CFG_LEARN_ENA_SET(learn_ena),
> > +             ANA_PORT_CFG_LEARN_ENA,
> > +             lan966x, ANA_PORT_CFG(port->chip_port));
> > +
> > +     lan966x_update_fwd_mask(lan966x);
> > +}
> > +
> > +static void lan966x_port_ageing_set(struct lan966x_port *port,
> > +                                 unsigned long ageing_clock_t)
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
> > +     int err = 0;
> > +
> > +     if (ctx && ctx != port)
> > +             return 0;
> > +
> > +     switch (attr->id) {
> > +     case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
> > +             lan966x_port_stp_state_set(port, attr->u.stp_state);
> > +             break;
> > +     case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
> > +             lan966x_port_ageing_set(port, attr->u.ageing_time);
> > +             break;
> > +     default:
> > +             err = -EOPNOTSUPP;
> > +             break;
> > +     }
> > +
> > +     return err;
> > +}
> > +
> > +static int lan966x_port_bridge_join(struct lan966x_port *port,
> > +                                 struct net_device *bridge,
> > +                                 struct netlink_ext_ack *extack)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +     struct net_device *dev = port->dev;
> > +     int err;
> > +
> > +     if (!lan966x->bridge_mask) {
> > +             lan966x->bridge = bridge;
> > +     } else {
> > +             if (lan966x->bridge != bridge)
> 
> NL_SET_ERR_MSG_MOD(extack, "<excuse>");
> 
> > +                     return -ENODEV;
> > +     }
> > +
> > +     err = switchdev_bridge_port_offload(dev, dev, port,
> > +                                         &lan966x_switchdev_nb,
> > +                                         &lan966x_switchdev_blocking_nb,
> > +                                         false, extack);
> > +     if (err)
> > +             return err;
> > +
> > +     lan966x->bridge_mask |= BIT(port->chip_port);
> > +
> > +     return 0;
> > +}
> > +
> > +static void lan966x_port_bridge_leave(struct lan966x_port *port,
> > +                                   struct net_device *bridge)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +
> > +     lan966x->bridge_mask &= ~BIT(port->chip_port);
> > +
> > +     if (!lan966x->bridge_mask)
> > +             lan966x->bridge = NULL;
> > +
> > +     lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, PORT_PVID);
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
> > +static int lan966x_port_prechangeupper(struct net_device *dev,
> > +                                    struct netdev_notifier_changeupper_info *info)
> > +{
> > +     struct lan966x_port *port = netdev_priv(dev);
> > +
> > +     if (netif_is_bridge_master(info->upper_dev) && !info->linking)
> > +             switchdev_bridge_port_unoffload(port->dev, port,
> > +                                             &lan966x_switchdev_nb,
> > +                                             &lan966x_switchdev_blocking_nb);
> > +
> > +     return NOTIFY_DONE;
> > +}
> > +
> > +static int lan966x_port_add_addr(struct net_device *dev, bool up)
> > +{
> > +     struct lan966x_port *port = netdev_priv(dev);
> > +     struct lan966x *lan966x = port->lan966x;
> > +     u16 vid;
> > +
> > +     vid = port->pvid;
> > +
> > +     if (up)
> > +             lan966x_mac_cpu_learn(lan966x, dev->dev_addr, vid);
> > +     else
> > +             lan966x_mac_cpu_forget(lan966x, dev->dev_addr, vid);
> > +
> > +     return 0;
> > +}
> > +
> > +static struct lan966x_ext_entry *lan966x_ext_find_entry(struct net_device *dev)
> > +{
> > +     struct lan966x_ext_entry *ext_entry;
> > +
> > +     list_for_each_entry(ext_entry, &ext_entries, list) {
> > +             if (ext_entry->dev == dev)
> > +                     return ext_entry;
> > +     }
> > +
> > +     return NULL;
> > +}
> > +
> > +static bool lan966x_ext_add_entry(struct net_device *dev, void *lan966x)
> > +{
> > +     struct lan966x_ext_entry *ext_entry;
> > +
> > +     ext_entry = lan966x_ext_find_entry(dev);
> > +     if (ext_entry) {
> > +             if (ext_entry->lan966x)
> > +                     return false;
> > +
> > +             ext_entry->ports++;
> > +             return true;
> > +     }
> > +
> > +     ext_entry = kzalloc(sizeof(*ext_entry), GFP_KERNEL);
> > +     if (!ext_entry)
> > +             return false;
> > +
> > +     ext_entry->dev = dev;
> > +     ext_entry->ports = 1;
> > +     ext_entry->lan966x = lan966x;
> > +     list_add_tail(&ext_entry->list, &ext_entries);
> > +     return true;
> > +}
> > +
> > +static void lan966x_ext_remove_entry(struct net_device *dev)
> > +{
> > +     struct lan966x_ext_entry *ext_entry;
> > +
> > +     ext_entry = lan966x_ext_find_entry(dev);
> > +     if (!ext_entry)
> > +             return;
> > +
> > +     ext_entry->ports--;
> > +     if (!ext_entry->ports) {
> > +             list_del(&ext_entry->list);
> > +             kfree(ext_entry);
> > +     }
> > +}
> > +
> > +void lan966x_ext_purge_entries(void)
> > +{
> > +     struct lan966x_ext_entry *ext_entry, *tmp;
> > +
> > +     list_for_each_entry_safe(ext_entry, tmp, &ext_entries, list) {
> > +             list_del(&ext_entry->list);
> > +             kfree(ext_entry);
> > +     }
> > +}
> > +
> > +static int lan966x_ext_check_entry(struct net_device *dev,
> > +                                unsigned long event,
> > +                                void *ptr)
> > +{
> > +     struct netdev_notifier_changeupper_info *info;
> > +
> > +     if (event != NETDEV_PRECHANGEUPPER)
> > +             return 0;
> > +
> > +     info = ptr;
> > +     if (!netif_is_bridge_master(info->upper_dev))
> > +             return 0;
> > +
> > +     if (info->linking) {
> > +             if (!lan966x_ext_add_entry(info->upper_dev, NULL))
> > +                     return -EOPNOTSUPP;
> > +     } else {
> > +             lan966x_ext_remove_entry(info->upper_dev);
> > +     }
> > +
> > +     return NOTIFY_DONE;
> > +}
> > +
> > +static bool lan966x_port_ext_check_entry(struct net_device *dev,
> > +                                      struct netdev_notifier_changeupper_info *info)
> > +{
> > +     struct lan966x_port *port = netdev_priv(dev);
> > +     struct lan966x *lan966x = port->lan966x;
> > +     struct lan966x_ext_entry *entry;
> > +
> > +     if (!netif_is_bridge_master(info->upper_dev))
> > +             return true;
> > +
> > +     entry = lan966x_ext_find_entry(info->upper_dev);
> 
> "entry" is unused in the "else" block below, so logically speaking it
> could be moved inside the "if" block.
> 
> Anyway, this piece of code is objectively speaking very obscure: convoluted
> (lan966x_port_ext_check_entry calls lan966x_ext_find_entry _twice_, once
> here and once in lan966x_ext_add_entry ?!), no comments and poorly named
> (a lan966x_ext_entry represents a _bridge_ ?! what does "ext_entry"
> stand for?). Plus, with your design where the "ext_entries" list is
> global, and there are two instances of the driver, each driver would do
> this work twice and allocate memory twice. Although, I didn't really
> understand why you need to allocate memory to keep a tab on every bridge
> in the system in the first place.
> 
> If you move your check from NETDEV_PRECHANGEUPPER to NETDEV_CHANGEUPPER,
> you allow the upper/lower adjacency list relationship to have formed
> (allowing the use of netdev_for_each_lower_dev, and the newly joining
> interface will be a lower of the bridge). But you can still reject the
> bridge join.
> 
> So you can do something like this, and it should produce an equivalent
> effect (not compiled, not tested, written straight in the email body):
> 
> static int lan966x_foreign_bridging_check(struct net_device *bridge,
>                                           struct netlink_ext_ack *extack)
> {
>         struct lan966x *lan966x = NULL;
>         bool has_foreign = false;
>         struct net_device *dev;
>         struct list_head *iter;
> 
>         netdev_for_each_lower_dev(bridge, dev, iter) {
>                 if (lan966x_netdevice_check(dev)) {
>                         struct lan966x_port *port = netdev_priv(dev);
> 
>                         if (lan996x) {
>                                 /* Bridge already has at least one port
>                                  * of a lan966x switch inside it, check
>                                  * that it's the same instance of the
>                                  * driver.
>                                  */
>                                 if (port->lan966x != lan996x) {
>                                         NL_SET_ERR_MSG_MOD(extack, "Bridging between multiple lan966x switches disallowed");
>                                         return -EINVAL;
>                                 }
>                         } else {
>                                 /* This is the first lan966x port inside
>                                  * this bridge
>                                  */
>                                 lan966x = port->lan966x;
>                         }
>                 } else {
>                         has_foreign = true;
>                 }
> 
>                 if (lan966x && has_foreign) {
>                         NL_SET_ERR_MSG_MOD(extack, "Bridging lan966x ports with foreign interfaces disallowed");
>                         return -EINVAL;
>                 }
>         }
> 
>         return 0;
> }
> 
> and call this from two distinct call paths: from the NETDEV_CHANGEUPPER
> of foreign interfaces, and from the NETDEV_CHANGEUPPER of lan966x interfaces.
> 
> Is it just me, or does this look more obvious and straightforward?

Thanks for the code, it looks much more better and it is not to required
to keep the list of other bridges.

> 
> > +     if (info->linking) {
> > +             if (!entry)
> > +                     return lan966x_ext_add_entry(info->upper_dev, lan966x);
> > +
> > +             if (entry->lan966x == lan966x) {
> > +                     entry->ports++;
> > +                     return true;
> > +             }
> > +     } else {
> > +             lan966x_ext_remove_entry(info->upper_dev);
> > +             return true;
> > +     }
> > +
> > +     return false;
> > +}
> > +
> > +static int lan966x_netdevice_port_event(struct net_device *dev,
> > +                                     struct notifier_block *nb,
> > +                                     unsigned long event, void *ptr)
> > +{
> > +     int err = 0;
> > +
> > +     if (!lan966x_netdevice_check(dev))
> > +             return lan966x_ext_check_entry(dev, event, ptr);
> > +
> > +     switch (event) {
> > +     case NETDEV_PRECHANGEUPPER:
> > +             if (!lan966x_port_ext_check_entry(dev, ptr))
> > +                     return -EOPNOTSUPP;
> > +
> > +             err = lan966x_port_prechangeupper(dev, ptr);
> > +             break;
> > +     case NETDEV_CHANGEUPPER:
> > +             err = lan966x_port_changeupper(dev, ptr);
> > +             break;
> > +     case NETDEV_PRE_UP:
> > +             err = lan966x_port_add_addr(dev, true);
> > +             break;
> > +     case NETDEV_DOWN:
> > +             err = lan966x_port_add_addr(dev, false);
> 
> Any reason why you track your own NETDEV_PRE_UP/NETDEV_DOWN and don't do
> this directly in ->ndo_open/->ndo_close? Also, I don't think that the
> "lan966x_port_add_addr" brings much value over "lan966x_mac_cpu_learn"
> and "lan966x_mac_cpu_forget" called directly (especially if moved to
> lan966x_port_open and lan966x_port_stop). And I don't see the relevance
> of this change with respect to the commit title "add support to offload
> the forwarding". CPU learned entries are for termination.

OK, I will drop this for now. I will add this or in a different patch of
this series or will be another patch by itself.

> 
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
> > +static int lan966x_switchdev_event(struct notifier_block *nb,
> > +                                unsigned long event, void *ptr)
> > +{
> > +     struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
> > +     int err;
> > +
> > +     switch (event) {
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
> > +static int lan966x_switchdev_blocking_event(struct notifier_block *nb,
> > +                                         unsigned long event,
> > +                                         void *ptr)
> > +{
> > +     struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
> > +     int err;
> > +
> > +     switch (event) {
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
> > +static struct notifier_block lan966x_netdevice_nb __read_mostly = {
> > +     .notifier_call = lan966x_netdevice_event,
> > +};
> > +
> > +static struct notifier_block lan966x_switchdev_nb __read_mostly = {
> > +     .notifier_call = lan966x_switchdev_event,
> > +};
> > +
> > +static struct notifier_block lan966x_switchdev_blocking_nb __read_mostly = {
> > +     .notifier_call = lan966x_switchdev_blocking_event,
> > +};
> > +
> > +void lan966x_register_notifier_blocks(struct lan966x *lan966x)
> > +{
> > +     register_netdevice_notifier(&lan966x_netdevice_nb);
> > +     register_switchdev_notifier(&lan966x_switchdev_nb);
> > +     register_switchdev_blocking_notifier(&lan966x_switchdev_blocking_nb);
> > +}
> > +
> > +void lan966x_unregister_notifier_blocks(struct lan966x *lan966x)
> > +{
> > +     unregister_switchdev_blocking_notifier(&lan966x_switchdev_blocking_nb);
> > +     unregister_switchdev_notifier(&lan966x_switchdev_nb);
> > +     unregister_netdevice_notifier(&lan966x_netdevice_nb);
> > +}
> > --
> > 2.33.0
> >

-- 
/Horatiu

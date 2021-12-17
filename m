Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34281478A17
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 12:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhLQLgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 06:36:20 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:29972 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbhLQLgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 06:36:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639740981; x=1671276981;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=79TSEVjnwevcK4jh2KO0ur4lc9LFBPjJChrc2VBiCms=;
  b=lQrun2DPMTStMhW/T39ouNRJi+kpNTqm12ZFuKcB/WfkKTalizljW3Tf
   w4JeT5/7A16U8P8gZbd8rK/XGNGb+6z3YGa8f5pYAUiA4l0Tp3kSSFTxU
   GK+90LFH62VvrBtje3vAJcN6IPUm81vUFqh1tUP0vw9YHUED2BQ7ARVDX
   Kr68Wc7Nc4JPbL14Z0KE5jAZJUPOFaYXJUsq7w1c1Wr1Y+zB/pR1loBgP
   ctLoXfie89ZGJlkZkI6c/K5GPVrRuMxcHR8IDbkNeB1uFLdWGZiOOaX/7
   6afZH96NZ03OpJOjlZN/XtzIx7E5vaZXAublu0C8CX3avDbcGLDkO6Jh8
   A==;
IronPort-SDR: JBM8MgTTkjwyt1G4W2ke3uXJM4tEzdCXqgKudWK/gsGXMZVcIGhsrDfecHiBI3erWNuUpUU3nQ
 q6Az0bf8kMp1QIGklzcPOSzo0dkQBI2qFHsdu1AHnZ4xLDAujWeb2mvM6mnGFT7H7hCHdI67u3
 k0LMeD8GAYpSdO/hODHfj1ziTCQtbanqhBV+OpERjOAdmqtdIK5kSVj5qpYMmUfEnhkuWHgSH8
 PC1VOlH+OeoDOJoOQn53lkgFCFgnRgVJzo6zdw5Y5zv0Hudm3qN3h4cFdnjQljo4iMgK26iJxQ
 4cJLa0J/XC1+XhXmbjAEqdAl
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="147010775"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Dec 2021 04:36:19 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 17 Dec 2021 04:36:18 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Fri, 17 Dec 2021 04:36:17 -0700
Date:   Fri, 17 Dec 2021 12:38:21 +0100
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
Subject: Re: [PATCH net-next v5 7/9] net: lan966x: Add vlan support.
Message-ID: <20211217113821.4s2zz7ifgdtxue7q@soft-dev3-1.localhost>
References: <20211215121309.3669119-1-horatiu.vultur@microchip.com>
 <20211215121309.3669119-8-horatiu.vultur@microchip.com>
 <20211216004415.zfypa3b35vgmlgk5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20211216004415.zfypa3b35vgmlgk5@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/16/2021 00:44, Vladimir Oltean wrote:
> 
> On Wed, Dec 15, 2021 at 01:13:07PM +0100, Horatiu Vultur wrote:
> > Extend the driver to support vlan filtering  by implementing the
> > switchdev calls SWITCHDEV_OBJ_ID_PORT_VLAN and
> > SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING.
> 
> And the VLAN RX filtering net device ops.
> 
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
> >  .../ethernet/microchip/lan966x/lan966x_main.c |  39 +-
> >  .../ethernet/microchip/lan966x/lan966x_main.h |  40 +-
> >  .../microchip/lan966x/lan966x_switchdev.c     | 113 ++++-
> >  .../ethernet/microchip/lan966x/lan966x_vlan.c | 444 ++++++++++++++++++
> >  5 files changed, 632 insertions(+), 7 deletions(-)
> >  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
> >
> > diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
> > index 974229c51f55..d82e896c2e53 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/Makefile
> > +++ b/drivers/net/ethernet/microchip/lan966x/Makefile
> > @@ -6,4 +6,5 @@
> >  obj-$(CONFIG_LAN966X_SWITCH) += lan966x-switch.o
> >
> >  lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
> > -                     lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o
> > +                     lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o \
> > +                     lan966x_vlan.o
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> > index ee453967da71..881c1678f3e9 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> > @@ -103,17 +103,18 @@ static int lan966x_create_targets(struct platform_device *pdev,
> >  static int lan966x_port_set_mac_address(struct net_device *dev, void *p)
> >  {
> >       struct lan966x_port *port = netdev_priv(dev);
> > +     u16 pvid = lan966x_vlan_port_get_pvid(port);
> >       struct lan966x *lan966x = port->lan966x;
> >       const struct sockaddr *addr = p;
> >       int ret;
> >
> >       /* Learn the new net device MAC address in the mac table. */
> > -     ret = lan966x_mac_cpu_learn(lan966x, addr->sa_data, port->pvid);
> > +     ret = lan966x_mac_cpu_learn(lan966x, addr->sa_data, pvid);
> 
> Logically speaking, there is a divide of responsibility. The bridge
> emits switchdev FDB events for local MAC addresses, with a VID of 0
> (corresponding to VLAN-unaware bridging) as well as for each installed
> VLAN. Bridge VLAN 0 is equivalent to your UNAWARE_PVID macro. And the
> driver is solely responsible for the MAC address in the HOST_PVID VLAN.
> When the ndo_set_mac_address is called, you should just update the entry
> learned in the HOST_PVID. The bridge will get an NETDEV_CHANGEADDR event
> and update its local MAC addresses too, in the VLANs it handles.
> Otherwise, if you just learn in the pvid that the port is currently in,
> then RX filtering will be broken if you change your MAC address while
> you're under a bridge, then you leave that bridge and become standalone.
> So you need to re-learn the dev_addr in lan966x_port_bridge_leave, which
> makes the implementation a bit more complicated than it needs to be
> (unless I'm missing something about CPU-learned MAC addresses in VLANs
> that aren't currently active, you seem to be avoiding that even though
> it makes the driver keep a lot more state).

Yes, you are right. Thanks for the explanation.

> 
> >       if (ret)
> >               return ret;
> >
> >       /* Then forget the previous one. */
> > -     ret = lan966x_mac_cpu_forget(lan966x, dev->dev_addr, port->pvid);
> > +     ret = lan966x_mac_cpu_forget(lan966x, dev->dev_addr, pvid);
> >       if (ret)
> >               return ret;
> >
> > @@ -283,6 +284,12 @@ static void lan966x_ifh_set_ipv(void *ifh, u64 bypass)
> >               IFH_POS_IPV, IFH_LEN * 4, PACK, 0);
> >  }
> >
> > +static void lan966x_ifh_set_vid(void *ifh, u64 vid)
> > +{
> > +     packing(ifh, &vid, IFH_POS_TCI + IFH_WID_TCI - 1,
> > +             IFH_POS_TCI, IFH_LEN * 4, PACK, 0);
> > +}
> > +
> >  static int lan966x_port_xmit(struct sk_buff *skb, struct net_device *dev)
> >  {
> >       struct lan966x_port *port = netdev_priv(dev);
> > @@ -294,6 +301,7 @@ static int lan966x_port_xmit(struct sk_buff *skb, struct net_device *dev)
> >       lan966x_ifh_set_port(ifh, BIT_ULL(port->chip_port));
> >       lan966x_ifh_set_qos_class(ifh, skb->priority >= 7 ? 0x7 : skb->priority);
> >       lan966x_ifh_set_ipv(ifh, skb->priority >= 7 ? 0x7 : skb->priority);
> > +     lan966x_ifh_set_vid(ifh, skb_vlan_tag_get(skb));
> >
> >       return lan966x_port_ifh_xmit(skb, ifh, dev);
> >  }
> > @@ -343,6 +351,18 @@ static int lan966x_port_get_parent_id(struct net_device *dev,
> >       return 0;
> >  }
> >
> > +static int lan966x_port_set_features(struct net_device *dev,
> > +                                  netdev_features_t features)
> > +{
> > +     struct lan966x_port *port = netdev_priv(dev);
> > +     netdev_features_t changed = dev->features ^ features;
> > +
> > +     if (changed & NETIF_F_HW_VLAN_CTAG_FILTER)
> > +             lan966x_vlan_mode(port, features);
> > +
> > +     return 0;
> > +}
> > +
> >  static const struct net_device_ops lan966x_port_netdev_ops = {
> >       .ndo_open                       = lan966x_port_open,
> >       .ndo_stop                       = lan966x_port_stop,
> > @@ -353,6 +373,9 @@ static const struct net_device_ops lan966x_port_netdev_ops = {
> >       .ndo_get_stats64                = lan966x_stats_get,
> >       .ndo_set_mac_address            = lan966x_port_set_mac_address,
> >       .ndo_get_port_parent_id         = lan966x_port_get_parent_id,
> > +     .ndo_set_features               = lan966x_port_set_features,
> > +     .ndo_vlan_rx_add_vid            = lan966x_vlan_rx_add_vid,
> > +     .ndo_vlan_rx_kill_vid           = lan966x_vlan_rx_kill_vid,
> 
> Do you have any particular use case for NETIF_F_HW_VLAN_CTAG_FILTER on
> non-bridged ports?

Not from what I am aware of, so for now I can remove this.

> I find the fact that you implement these very strange
> and likely bogus: you set port->vlan_aware = false when a port leaves a
> bridge, yet you install VLANs to its RX filter as if those VLANs were to
> actually match on any VLAN-tagged packet... which they won't because
> lan966x_vlan_port_apply() clears ANA_VLAN_CFG_VLAN_AWARE_ENA_SET(1) when
> port->vlan_aware isn't set. So you end up being "filtering" but not "aware"
> - all packets get classified to the same VLAN, which isn't dropped.
> 
> >  };
> >
> >  bool lan966x_netdevice_check(const struct net_device *dev)
> > @@ -575,13 +598,16 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
> >       port->dev = dev;
> >       port->lan966x = lan966x;
> >       port->chip_port = p;
> > -     port->pvid = PORT_PVID;
> >       lan966x->ports[p] = port;
> >
> >       dev->max_mtu = ETH_MAX_MTU;
> >
> >       dev->netdev_ops = &lan966x_port_netdev_ops;
> >       dev->ethtool_ops = &lan966x_ethtool_ops;
> > +     dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
> > +     dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
> > +                      NETIF_F_HW_VLAN_CTAG_TX |
> > +                      NETIF_F_HW_VLAN_STAG_TX;
> >       dev->needed_headroom = IFH_LEN * sizeof(u32);
> >
> >       eth_hw_addr_gen(dev, lan966x->base_mac, p + 1);
> > @@ -625,6 +651,10 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
> >               return err;
> >       }
> >
> > +     lan966x_vlan_port_set_vlan_aware(port, 0);
> > +     lan966x_vlan_port_set_vid(port, HOST_PVID, false, false);
> > +     lan966x_vlan_port_apply(port);
> > +
> >       return 0;
> >  }
> >
> > @@ -635,6 +665,9 @@ static void lan966x_init(struct lan966x *lan966x)
> >       /* MAC table initialization */
> >       lan966x_mac_init(lan966x);
> >
> > +     /* Vlan initialization */
> > +     lan966x_vlan_init(lan966x);
> 
> Curious how the lan966x_ext_entry stuff doesn't have any comment and
> lan966x_vlan_init has such a trivial one?!
> 
> > +
> >       /* Flush queues */
> >       lan_wr(lan_rd(lan966x, QS_XTR_FLUSH) |
> >              GENMASK(1, 0),
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > index 3d228c9c0521..6d0d922617ae 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > @@ -4,6 +4,7 @@
> >  #define __LAN966X_MAIN_H__
> >
> >  #include <linux/etherdevice.h>
> > +#include <linux/if_vlan.h>
> >  #include <linux/jiffies.h>
> >  #include <linux/phy.h>
> >  #include <linux/phylink.h>
> > @@ -22,7 +23,8 @@
> >  #define PGID_SRC                     80
> >  #define PGID_ENTRIES                 89
> >
> > -#define PORT_PVID                    0
> > +#define UNAWARE_PVID                 0
> > +#define HOST_PVID                    4095
> >
> >  /* Reserved amount for (SRC, PRIO) at index 8*SRC + PRIO */
> >  #define QSYS_Q_RSRV                  95
> > @@ -82,6 +84,9 @@ struct lan966x {
> >       struct list_head mac_entries;
> >       spinlock_t mac_lock; /* lock for mac_entries list */
> >
> > +     u16 vlan_mask[VLAN_N_VID];
> > +     DECLARE_BITMAP(cpu_vlan_mask, VLAN_N_VID);
> > +
> >       /* stats */
> >       const struct lan966x_stat_layout *stats_layout;
> >       u32 num_stats;
> > @@ -113,6 +118,8 @@ struct lan966x_port {
> >
> >       u8 chip_port;
> >       u16 pvid;
> > +     u16 vid;
> > +     u8 vlan_aware;
> 
> bool
> 
> >
> >       struct phylink_config phylink_config;
> >       struct phylink_pcs phylink_pcs;
> > @@ -168,6 +175,37 @@ irqreturn_t lan966x_mac_irq_handler(struct lan966x *lan966x);
> >
> >  void lan966x_ext_purge_entries(void);
> >
> > +void lan966x_vlan_init(struct lan966x *lan966x);
> > +void lan966x_vlan_port_apply(struct lan966x_port *port);
> > +
> > +int lan966x_vlan_rx_add_vid(struct net_device *dev, __be16 proto, u16 vid);
> > +int lan966x_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid);
> > +
> > +void lan966x_vlan_mode(struct lan966x_port *port, netdev_features_t features);
> > +u16 lan966x_vlan_port_get_pvid(struct lan966x_port *port);
> > +
> > +bool lan966x_vlan_cpu_member_cpu_vlan_mask(struct lan966x *lan966x, u16 vid);
> > +void lan966x_vlan_cpu_add_cpu_vlan_mask(struct lan966x *lan966x, u16 vid);
> > +bool lan966x_vlan_port_any_vlan_mask(struct lan966x *lan966x, u16 vid);
> > +
> > +void lan966x_vlan_cpu_set_vlan_aware(struct lan966x_port *port);
> > +void lan966x_vlan_port_set_vlan_aware(struct lan966x_port *port,
> > +                                   bool vlan_aware);
> > +int lan966x_vlan_port_set_vid(struct lan966x_port *port, u16 vid,
> > +                           bool pvid, bool untagged);
> > +int lan966x_vlan_port_add_vlan(struct lan966x_port *port,
> > +                            u16 vid,
> > +                            bool pvid,
> > +                            bool untagged);
> > +int lan966x_vlan_port_del_vlan(struct lan966x_port *port,
> > +                            u16 vid);
> > +int lan966x_vlan_cpu_add_vlan(struct lan966x *lan966x,
> > +                           struct net_device *dev,
> > +                           u16 vid);
> > +int lan966x_vlan_cpu_del_vlan(struct lan966x *lan966x,
> > +                           struct net_device *dev,
> > +                           u16 vid);
> > +
> >  static inline void __iomem *lan_addr(void __iomem *base[],
> >                                    int id, int tinst, int tcnt,
> >                                    int gbase, int ginst,
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> > index 722ce7cb61b3..61f9e906cf80 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> > @@ -82,6 +82,11 @@ static int lan966x_port_attr_set(struct net_device *dev, const void *ctx,
> >       case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
> >               lan966x_port_ageing_set(port, attr->u.ageing_time);
> >               break;
> > +     case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
> > +             lan966x_vlan_port_set_vlan_aware(port, attr->u.vlan_filtering);
> > +             lan966x_vlan_port_apply(port);
> > +             lan966x_vlan_cpu_set_vlan_aware(port);
> > +             break;
> >       default:
> >               err = -EOPNOTSUPP;
> >               break;
> > @@ -127,7 +132,12 @@ static void lan966x_port_bridge_leave(struct lan966x_port *port,
> >       if (!lan966x->bridge_mask)
> >               lan966x->bridge = NULL;
> >
> > -     lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, PORT_PVID);
> > +     /* Set the port back to host mode */
> > +     lan966x_vlan_port_set_vlan_aware(port, false);
> > +     lan966x_vlan_port_set_vid(port, HOST_PVID, false, false);
> > +     lan966x_vlan_port_apply(port);
> > +
> > +     lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, HOST_PVID);
> >  }
> >
> >  static int lan966x_port_changeupper(struct net_device *dev,
> > @@ -169,7 +179,7 @@ static int lan966x_port_add_addr(struct net_device *dev, bool up)
> >       struct lan966x *lan966x = port->lan966x;
> >       u16 vid;
> >
> > -     vid = port->pvid;
> > +     vid = lan966x_vlan_port_get_pvid(port);
> >
> >       if (up)
> >               lan966x_mac_cpu_learn(lan966x, dev->dev_addr, vid);
> > @@ -348,6 +358,95 @@ static int lan966x_switchdev_event(struct notifier_block *nb,
> >       return NOTIFY_DONE;
> >  }
> >
> > +static int lan966x_handle_port_vlan_add(struct lan966x_port *port,
> > +                                     const struct switchdev_obj *obj)
> > +{
> > +     const struct switchdev_obj_port_vlan *v = SWITCHDEV_OBJ_PORT_VLAN(obj);
> > +     struct lan966x *lan966x = port->lan966x;
> > +
> > +     /* When adding a port to a vlan, we get a callback for the port but
> > +      * also for the bridge. When get the callback for the bridge just bail
> > +      * out. Then when the bridge is added to the vlan, then we get a
> > +      * callback here but in this case the flags has set:
> > +      * BRIDGE_VLAN_INFO_BRENTRY. In this case it means that the CPU
> > +      * port is added to the vlan, so the broadcast frames and unicast frames
> > +      * with dmac of the bridge should be foward to CPU.
> > +      */
> > +     if (netif_is_bridge_master(obj->orig_dev) &&
> > +         !(v->flags & BRIDGE_VLAN_INFO_BRENTRY))
> > +             return 0;
> > +
> > +     if (!netif_is_bridge_master(obj->orig_dev))
> > +             return lan966x_vlan_port_add_vlan(port, v->vid,
> > +                                               v->flags & BRIDGE_VLAN_INFO_PVID,
> > +                                               v->flags & BRIDGE_VLAN_INFO_UNTAGGED);
> > +
> > +     if (netif_is_bridge_master(obj->orig_dev))
> 
> "else" will suffice.
> 
> > +             return lan966x_vlan_cpu_add_vlan(lan966x, obj->orig_dev, v->vid);
> > +
> > +     return 0;
> > +}
> > +
> > +static int lan966x_handle_port_obj_add(struct net_device *dev, const void *ctx,
> > +                                    const struct switchdev_obj *obj,
> > +                                    struct netlink_ext_ack *extack)
> > +{
> > +     struct lan966x_port *port = netdev_priv(dev);
> > +     int err;
> > +
> > +     if (ctx && ctx != port)
> > +             return 0;
> > +
> > +     switch (obj->id) {
> > +     case SWITCHDEV_OBJ_ID_PORT_VLAN:
> > +             err = lan966x_handle_port_vlan_add(port, obj);
> > +             break;
> > +     default:
> > +             err = -EOPNOTSUPP;
> > +             break;
> > +     }
> > +
> > +     return err;
> > +}
> > +
> > +static int lan966x_handle_port_vlan_del(struct lan966x_port *port,
> > +                                     const struct switchdev_obj *obj)
> > +{
> > +     const struct switchdev_obj_port_vlan *v = SWITCHDEV_OBJ_PORT_VLAN(obj);
> > +     struct lan966x *lan966x = port->lan966x;
> > +
> > +     /* In case the physical port gets called */
> > +     if (!netif_is_bridge_master(obj->orig_dev))
> > +             return lan966x_vlan_port_del_vlan(port, v->vid);
> > +
> > +     /* In case the bridge gets called */
> > +     if (netif_is_bridge_master(obj->orig_dev))
> 
> likewise.
> 
> > +             return lan966x_vlan_cpu_del_vlan(lan966x, obj->orig_dev, v->vid);
> > +
> > +     return 0;
> > +}
> > +
> > +static int lan966x_handle_port_obj_del(struct net_device *dev, const void *ctx,
> > +                                    const struct switchdev_obj *obj)
> > +{
> > +     struct lan966x_port *port = netdev_priv(dev);
> > +     int err;
> > +
> > +     if (ctx && ctx != port)
> > +             return 0;
> > +
> > +     switch (obj->id) {
> > +     case SWITCHDEV_OBJ_ID_PORT_VLAN:
> > +             err = lan966x_handle_port_vlan_del(port, obj);
> > +             break;
> > +     default:
> > +             err = -EOPNOTSUPP;
> > +             break;
> > +     }
> > +
> > +     return err;
> > +}
> > +
> >  static int lan966x_switchdev_blocking_event(struct notifier_block *nb,
> >                                           unsigned long event,
> >                                           void *ptr)
> > @@ -356,6 +455,16 @@ static int lan966x_switchdev_blocking_event(struct notifier_block *nb,
> >       int err;
> >
> >       switch (event) {
> > +     case SWITCHDEV_PORT_OBJ_ADD:
> > +             err = switchdev_handle_port_obj_add(dev, ptr,
> > +                                                 lan966x_netdevice_check,
> > +                                                 lan966x_handle_port_obj_add);
> > +             return notifier_from_errno(err);
> > +     case SWITCHDEV_PORT_OBJ_DEL:
> > +             err = switchdev_handle_port_obj_del(dev, ptr,
> > +                                                 lan966x_netdevice_check,
> > +                                                 lan966x_handle_port_obj_del);
> > +             return notifier_from_errno(err);
> >       case SWITCHDEV_PORT_ATTR_SET:
> >               err = switchdev_handle_port_attr_set(dev, ptr,
> >                                                    lan966x_netdevice_check,
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
> > new file mode 100644
> > index 000000000000..e8ff95bb65fa
> > --- /dev/null
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
> > @@ -0,0 +1,444 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +
> > +#include "lan966x_main.h"
> > +
> > +#define VLANACCESS_CMD_IDLE          0
> > +#define VLANACCESS_CMD_READ          1
> > +#define VLANACCESS_CMD_WRITE         2
> > +#define VLANACCESS_CMD_INIT          3
> > +
> > +static int lan966x_vlan_get_status(struct lan966x *lan966x)
> > +{
> > +     return lan_rd(lan966x, ANA_VLANACCESS);
> > +}
> > +
> > +static int lan966x_vlan_wait_for_completion(struct lan966x *lan966x)
> > +{
> > +     u32 val;
> > +
> > +     return readx_poll_timeout(lan966x_vlan_get_status,
> > +             lan966x, val,
> > +             (val & ANA_VLANACCESS_VLAN_TBL_CMD) ==
> > +             VLANACCESS_CMD_IDLE,
> > +             TABLE_UPDATE_SLEEP_US, TABLE_UPDATE_TIMEOUT_US);
> > +}
> > +
> > +static int lan966x_vlan_set_mask(struct lan966x *lan966x, u16 vid)
> > +{
> > +     u16 mask = lan966x->vlan_mask[vid];
> > +     bool cpu_dis;
> > +
> > +     cpu_dis = !(mask & BIT(CPU_PORT));
> > +
> > +     /* Set flags and the VID to configure */
> > +     lan_rmw(ANA_VLANTIDX_VLAN_PGID_CPU_DIS_SET(cpu_dis) |
> > +             ANA_VLANTIDX_V_INDEX_SET(vid),
> > +             ANA_VLANTIDX_VLAN_PGID_CPU_DIS |
> > +             ANA_VLANTIDX_V_INDEX,
> > +             lan966x, ANA_VLANTIDX);
> > +
> > +     /* Set the vlan port members mask */
> > +     lan_rmw(ANA_VLAN_PORT_MASK_VLAN_PORT_MASK_SET(mask),
> > +             ANA_VLAN_PORT_MASK_VLAN_PORT_MASK,
> > +             lan966x, ANA_VLAN_PORT_MASK);
> > +
> > +     /* Issue a write command */
> > +     lan_rmw(ANA_VLANACCESS_VLAN_TBL_CMD_SET(VLANACCESS_CMD_WRITE),
> > +             ANA_VLANACCESS_VLAN_TBL_CMD,
> > +             lan966x, ANA_VLANACCESS);
> > +
> > +     return lan966x_vlan_wait_for_completion(lan966x);
> 
> If you're not going to propagate the return code anywhere, at least
> return void and print an error here. Otherwise it's totally silent.

Yes, I will return void and print an error.

> 
> > +}
> > +
> > +void lan966x_vlan_init(struct lan966x *lan966x)
> > +{
> > +     u16 port, vid;
> > +
> > +     /* Clear VLAN table, by default all ports are members of all VLANS */
> > +     lan_rmw(ANA_VLANACCESS_VLAN_TBL_CMD_SET(VLANACCESS_CMD_INIT),
> > +             ANA_VLANACCESS_VLAN_TBL_CMD,
> > +             lan966x, ANA_VLANACCESS);
> > +     lan966x_vlan_wait_for_completion(lan966x);
> 
> Again no error checking.
> 
> > +
> > +     for (vid = 1; vid < VLAN_N_VID; vid++) {
> > +             lan966x->vlan_mask[vid] = 0;
> > +             lan966x_vlan_set_mask(lan966x, vid);
> > +     }
> > +
> > +     /* Set all the ports + cpu to be part of HOST_PVID and UNAWARE_PVID */
> > +     lan966x->vlan_mask[HOST_PVID] =
> > +             GENMASK(lan966x->num_phys_ports - 1, 0) | BIT(CPU_PORT);
> > +     lan966x_vlan_set_mask(lan966x, HOST_PVID);
> > +
> > +     lan966x->vlan_mask[UNAWARE_PVID] =
> > +             GENMASK(lan966x->num_phys_ports - 1, 0) | BIT(CPU_PORT);
> > +     lan966x_vlan_set_mask(lan966x, UNAWARE_PVID);
> > +
> > +     lan966x_vlan_cpu_add_cpu_vlan_mask(lan966x, UNAWARE_PVID);
> > +
> > +     /* Configure the CPU port to be vlan aware */
> > +     lan_wr(ANA_VLAN_CFG_VLAN_VID_SET(0) |
> > +            ANA_VLAN_CFG_VLAN_AWARE_ENA_SET(1) |
> > +            ANA_VLAN_CFG_VLAN_POP_CNT_SET(1),
> > +            lan966x, ANA_VLAN_CFG(CPU_PORT));
> > +
> > +     /* Set vlan ingress filter mask to all ports */
> > +     lan_wr(GENMASK(lan966x->num_phys_ports, 0),
> > +            lan966x, ANA_VLANMASK);
> > +
> > +     for (port = 0; port < lan966x->num_phys_ports; port++) {
> > +             lan_wr(0, lan966x, REW_PORT_VLAN_CFG(port));
> > +             lan_wr(0, lan966x, REW_TAG_CFG(port));
> > +     }
> > +}
> > +
> > +static int lan966x_vlan_port_add_vlan_mask(struct lan966x_port *port, u16 vid)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +     u8 p = port->chip_port;
> > +
> > +     lan966x->vlan_mask[vid] |= BIT(p);
> > +     return lan966x_vlan_set_mask(lan966x, vid);
> > +}
> > +
> > +static int lan966x_vlan_port_del_vlan_mask(struct lan966x_port *port, u16 vid)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +     u8 p = port->chip_port;
> > +
> > +     lan966x->vlan_mask[vid] &= ~BIT(p);
> > +     return lan966x_vlan_set_mask(lan966x, vid);
> > +}
> > +
> > +static bool lan966x_vlan_port_member_vlan_mask(struct lan966x_port *port, u16 vid)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +     u8 p = port->chip_port;
> > +
> > +     return lan966x->vlan_mask[vid] & BIT(p);
> > +}
> > +
> > +bool lan966x_vlan_port_any_vlan_mask(struct lan966x *lan966x, u16 vid)
> > +{
> > +     return !!(lan966x->vlan_mask[vid] & ~BIT(CPU_PORT));
> > +}
> > +
> > +static int lan966x_vlan_cpu_add_vlan_mask(struct lan966x *lan966x, u16 vid)
> > +{
> > +     lan966x->vlan_mask[vid] |= BIT(CPU_PORT);
> > +     return lan966x_vlan_set_mask(lan966x, vid);
> > +}
> > +
> > +static int lan966x_vlan_cpu_del_vlan_mask(struct lan966x *lan966x, u16 vid)
> > +{
> > +     lan966x->vlan_mask[vid] &= ~BIT(CPU_PORT);
> > +     return lan966x_vlan_set_mask(lan966x, vid);
> > +}
> > +
> > +void lan966x_vlan_cpu_add_cpu_vlan_mask(struct lan966x *lan966x, u16 vid)
> > +{
> > +     set_bit(vid, lan966x->cpu_vlan_mask);
> 
> Since these are all serialized by the rtnl_mutex, I think it's safe to
> replace with __set_bit which is non-atomic and thus cheaper.
> 
> > +}
> > +
> > +static void lan966x_vlan_cpu_del_cpu_vlan_mask(struct lan966x *lan966x, u16 vid)
> > +{
> > +     clear_bit(vid, lan966x->cpu_vlan_mask);
> > +}
> > +
> > +bool lan966x_vlan_cpu_member_cpu_vlan_mask(struct lan966x *lan966x, u16 vid)
> > +{
> > +     return test_bit(vid, lan966x->cpu_vlan_mask);
> > +}
> > +
> > +u16 lan966x_vlan_port_get_pvid(struct lan966x_port *port)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +
> > +     if (!(lan966x->bridge_mask & BIT(port->chip_port)))
> > +             return HOST_PVID;
> > +
> > +     return port->vlan_aware ? port->pvid : UNAWARE_PVID;
> > +}
> > +
> > +int lan966x_vlan_port_set_vid(struct lan966x_port *port, u16 vid,
> > +                           bool pvid, bool untagged)
> 
> If you were to summarize what this function does, what would that be?

This will set the port pvid and vid based on the parameters pvid and
untagged.

> 
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +
> > +     /* Egress vlan classification */
> > +     if (untagged && port->vid != vid) {
> > +             if (port->vid) {
> > +                     dev_err(lan966x->dev,
> > +                             "Port already has a native VLAN: %d\n",
> > +                             port->vid);
> > +                     return -EBUSY;
> > +             }
> > +             port->vid = vid;
> > +     }
> > +
> > +     /* Default ingress vlan classification */
> > +     if (pvid)
> > +             port->pvid = vid;
> > +
> > +     return 0;
> > +}
> > +
> > +static int lan966x_vlan_port_remove_vid(struct lan966x_port *port, u16 vid)
> > +{
> > +     if (port->pvid == vid)
> > +             port->pvid = 0;
> > +
> > +     if (port->vid == vid)
> > +             port->vid = 0;
> > +
> > +     return 0;
> > +}
> > +
> > +void lan966x_vlan_port_set_vlan_aware(struct lan966x_port *port,
> > +                                   bool vlan_aware)
> > +{
> > +     port->vlan_aware = vlan_aware;
> > +}
> > +
> > +void lan966x_vlan_cpu_set_vlan_aware(struct lan966x_port *port)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +
> > +     if (!port->vlan_aware) {
> > +             /* In case of vlan unaware, all the ports will be set in
> > +              * UNAWARE_PVID and have their PVID set to this PVID
> > +              * The CPU doesn't need to be added because it is always part of
> > +              * that vlan, it is required just to add entries in the MAC
> > +              * table for the front port and the CPU
> > +              */
> > +             lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, UNAWARE_PVID);
> > +             lan966x_mac_cpu_learn(lan966x, lan966x->bridge->dev_addr,
> > +                                   UNAWARE_PVID);
> > +
> > +             lan966x_vlan_port_add_vlan_mask(port, UNAWARE_PVID);
> > +             lan966x_vlan_port_apply(port);
> > +     } else {
> > +             /* In case of vlan aware, just clear what happened when changed
> > +              * to vlan unaware
> > +              */
> > +             lan966x_mac_cpu_forget(lan966x, port->dev->dev_addr, UNAWARE_PVID);
> > +             lan966x_mac_cpu_forget(lan966x, lan966x->bridge->dev_addr,
> > +                                    UNAWARE_PVID);
> > +
> > +             lan966x_vlan_port_del_vlan_mask(port, UNAWARE_PVID);
> > +             lan966x_vlan_port_apply(port);
> > +     }
> > +}
> > +
> > +void lan966x_vlan_port_apply(struct lan966x_port *port)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +     u16 pvid;
> > +     u32 val;
> > +
> > +     pvid = lan966x_vlan_port_get_pvid(port);
> > +
> > +     /* Ingress clasification (ANA_PORT_VLAN_CFG) */
> > +     /* Default vlan to casify for untagged frames (may be zero) */
> 
> classify
> 
> > +     val = ANA_VLAN_CFG_VLAN_VID_SET(pvid);
> > +     if (port->vlan_aware)
> > +             val |= ANA_VLAN_CFG_VLAN_AWARE_ENA_SET(1) |
> > +                    ANA_VLAN_CFG_VLAN_POP_CNT_SET(1);
> > +
> > +     lan_rmw(val,
> > +             ANA_VLAN_CFG_VLAN_VID | ANA_VLAN_CFG_VLAN_AWARE_ENA |
> > +             ANA_VLAN_CFG_VLAN_POP_CNT,
> > +             lan966x, ANA_VLAN_CFG(port->chip_port));
> > +
> > +     /* Drop frames with multicast source address */
> > +     val = ANA_DROP_CFG_DROP_MC_SMAC_ENA_SET(1);
> > +     if (port->vlan_aware && !pvid)
> > +             /* If port is vlan-aware and tagged, drop untagged and priority
> > +              * tagged frames.
> > +              */
> > +             val |= ANA_DROP_CFG_DROP_UNTAGGED_ENA_SET(1) |
> > +                    ANA_DROP_CFG_DROP_PRIO_S_TAGGED_ENA_SET(1) |
> > +                    ANA_DROP_CFG_DROP_PRIO_C_TAGGED_ENA_SET(1);
> > +
> > +     lan_wr(val, lan966x, ANA_DROP_CFG(port->chip_port));
> > +
> > +     /* Egress configuration (REW_TAG_CFG): VLAN tag type to 8021Q */
> > +     val = REW_TAG_CFG_TAG_TPID_CFG_SET(0);
> > +     if (port->vlan_aware) {
> > +             if (port->vid)
> > +                     /* Tag all frames except when VID == DEFAULT_VLAN */
> > +                     val |= REW_TAG_CFG_TAG_CFG_SET(1);
> > +             else
> > +                     val |= REW_TAG_CFG_TAG_CFG_SET(3);
> > +     }
> > +
> > +     /* Update only some bits in the register */
> > +     lan_rmw(val,
> > +             REW_TAG_CFG_TAG_TPID_CFG | REW_TAG_CFG_TAG_CFG,
> > +             lan966x, REW_TAG_CFG(port->chip_port));
> > +
> > +     /* Set default VLAN and tag type to 8021Q */
> > +     lan_rmw(REW_PORT_VLAN_CFG_PORT_TPID_SET(ETH_P_8021Q) |
> > +             REW_PORT_VLAN_CFG_PORT_VID_SET(port->vid),
> > +             REW_PORT_VLAN_CFG_PORT_TPID |
> > +             REW_PORT_VLAN_CFG_PORT_VID,
> > +             lan966x, REW_PORT_VLAN_CFG(port->chip_port));
> > +}
> > +
> > +int lan966x_vlan_port_add_vlan(struct lan966x_port *port,
> > +                            u16 vid,
> > +                            bool pvid,
> > +                            bool untagged)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +
> > +     /* If the CPU(br) is already part of the vlan then add the MAC
> > +      * address of the device in MAC table to copy the frames to the
> > +      * CPU(br). If the CPU(br) is not part of the vlan then it would
> > +      * just drop the frames.
> > +      */
> > +     if (lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x, vid)) {
> > +             lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, vid);
> > +             lan966x_mac_cpu_learn(lan966x, lan966x->bridge->dev_addr, vid);
> 
> Doesn't the bridge notify you of all the addresses you need to learn on
> the CPU port?

Yes it does so I don't need these lan966x_mac_cpu_learn/forget here and
in the other places in this file.

> What is the benefit of the added complexity of only
> learning the addresses when the CPU joins the VLAN? 

If we add an entry MAC table regardless if the CPU is in that vlan, then if
there are any trunk ports then, we need to add an entry in MAC table for each
vlan. That is the reason why to add the entries in MAC table only if the
CPU is in the vlan.

> Doesn't the CPU_DIS bit work if an entry is present in the MAC table?

Yes it works.

> 
> > +             lan966x_vlan_cpu_add_vlan_mask(lan966x, vid);
> > +     }
> > +
> > +     lan966x_vlan_port_set_vid(port, vid, pvid, untagged);
> > +     lan966x_vlan_port_add_vlan_mask(port, vid);
> > +     lan966x_vlan_port_apply(port);
> > +
> > +     return 0;
> > +}
> > +
> > +int lan966x_vlan_port_del_vlan(struct lan966x_port *port,
> > +                            u16 vid)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +
> > +     /* In case the CPU(br) is part of the vlan then remove the MAC entry
> > +      * because frame doesn't need to reach to CPU
> > +      */
> > +     if (lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x, vid))
> > +             lan966x_mac_cpu_forget(lan966x, port->dev->dev_addr, vid);
> > +
> > +     lan966x_vlan_port_remove_vid(port, vid);
> > +     lan966x_vlan_port_del_vlan_mask(port, vid);
> > +     lan966x_vlan_port_apply(port);
> > +
> > +     /* In case there are no other ports in vlan then remove the CPU from
> > +      * that vlan but still keep it in the mask because it may be needed
> > +      * again then another port gets added in tha vlan
> 
> s/tha/that/
> 
> > +      */
> > +     if (!lan966x_vlan_port_any_vlan_mask(lan966x, vid)) {
> > +             lan966x_mac_cpu_forget(lan966x, lan966x->bridge->dev_addr, vid);
> > +             lan966x_vlan_cpu_del_vlan_mask(lan966x, vid);
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +int lan966x_vlan_cpu_add_vlan(struct lan966x *lan966x,
> > +                           struct net_device *dev,
> > +                           u16 vid)
> > +{
> > +     int p;
> > +
> > +     /* Iterate over the ports and see which ones are part of the
> > +      * vlan and for those ports add entry in the MAC table to
> > +      * copy the frames to the CPU
> > +      */
> > +     for (p = 0; p < lan966x->num_phys_ports; p++) {
> > +             struct lan966x_port *port = lan966x->ports[p];
> > +
> > +             if (!port ||
> > +                 !lan966x_vlan_port_member_vlan_mask(port, vid))
> > +                     continue;
> > +
> > +             lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, vid);
> > +     }
> > +
> > +     /* Add an entry in the MAC table for the CPU
> > +      * Add the CPU part of the vlan only if there is another port in that
> > +      * vlan otherwise all the broadcast frames in that vlan will go to CPU
> > +      * even if none of the ports are in the vlan and then the CPU will just
> > +      * need to discard these frames. It is required to store this
> > +      * information so when a front port is added then it would add also the
> > +      * CPU port.
> > +      */
> > +     if (lan966x_vlan_port_any_vlan_mask(lan966x, vid)) {
> > +             lan966x_mac_cpu_learn(lan966x, dev->dev_addr, vid);
> > +             lan966x_vlan_cpu_add_vlan_mask(lan966x, vid);
> > +     }
> > +
> > +     lan966x_vlan_cpu_add_cpu_vlan_mask(lan966x, vid);
> > +
> > +     return 0;
> > +}
> > +
> > +int lan966x_vlan_cpu_del_vlan(struct lan966x *lan966x,
> > +                           struct net_device *dev,
> > +                           u16 vid)
> > +{
> > +     int p;
> > +
> > +     /* Iterate over the ports and see which ones are part of the
> > +      * vlan and for those ports remove entry in the MAC table to
> > +      * copy the frames to the CPU
> > +      */
> > +     for (p = 0; p < lan966x->num_phys_ports; p++) {
> > +             struct lan966x_port *port = lan966x->ports[p];
> > +
> > +             if (!port ||
> > +                 !lan966x_vlan_port_member_vlan_mask(port, vid))
> > +                     continue;
> > +
> > +             lan966x_mac_cpu_forget(lan966x, port->dev->dev_addr, vid);
> > +     }
> > +
> > +     /* Remove an entry in the MAC table for the CPU */
> > +     lan966x_mac_cpu_forget(lan966x, dev->dev_addr, vid);
> > +
> > +     /* Remove the CPU part of the vlan */
> > +     lan966x_vlan_cpu_del_cpu_vlan_mask(lan966x, vid);
> > +     lan966x_vlan_cpu_del_vlan_mask(lan966x, vid);
> > +
> > +     return 0;
> > +}
> > +
> > +int lan966x_vlan_rx_add_vid(struct net_device *dev, __be16 proto, u16 vid)
> > +{
> > +     struct lan966x_port *port = netdev_priv(dev);
> > +
> > +     lan966x_vlan_port_set_vid(port, vid, false, false);
> > +     lan966x_vlan_port_add_vlan_mask(port, vid);
> > +     lan966x_vlan_port_apply(port);
> > +
> > +     return 0;
> > +}
> > +
> > +int lan966x_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
> > +                          u16 vid)
> > +{
> > +     struct lan966x_port *port = netdev_priv(dev);
> > +
> > +     lan966x_vlan_port_remove_vid(port, vid);
> > +     lan966x_vlan_port_del_vlan_mask(port, vid);
> > +     lan966x_vlan_port_apply(port);
> > +
> > +     return 0;
> > +}
> > +
> > +void lan966x_vlan_mode(struct lan966x_port *port,
> > +                    netdev_features_t features)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +     u32 val;
> > +
> > +     /* Filtering */
> > +     val = lan_rd(lan966x, ANA_VLANMASK);
> > +     if (features & NETIF_F_HW_VLAN_CTAG_FILTER)
> > +             val |= BIT(port->chip_port);
> > +     else
> > +             val &= ~BIT(port->chip_port);
> > +     lan_wr(val, lan966x, ANA_VLANMASK);
> > +}
> > --
> > 2.33.0
> >

-- 
/Horatiu

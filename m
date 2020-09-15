Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3301426A29F
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 12:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgIOKBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 06:01:52 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:27523 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIOKBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 06:01:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1600164108; x=1631700108;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=s5bZRjPzdlzTq6DB3HuyGw96oDsYWdYDydWdR7TC0Qo=;
  b=x+mxXWSkOjX4wK/ncEapaTVvUzMbVRWTX/j9VH/iIlxrCT4Zjpa+sAM/
   H22K3iHp7w8VA+0gF3cWCbEaoouM1syd53XxNEIlhBehWSZj/pVqxwjBE
   37zIumUaEYGqnSZ/kBdrQ+hZbgM7ygtonhEwhwP+hWFNdrxKg1lahJwFs
   ARV9AFCXyLPUcvnJMcQMbhJDQoTnjn3xy8/4mpUVzedyrYyivzOvm+AMZ
   5jn3gBf6gM1tZ23FEp/6AYCJ3IomDToD4+LOmmeGmu3i1yEkQieZLq56b
   VCsBPmvubU1datgP5IJjsPPbeCzP/zrIEQ6YRlwM3VqSCk4g4acK7ExWF
   A==;
IronPort-SDR: B99CJSOQxAJWY1nVFk8QlWavyoa8/8we6oZrYndyMh4N01MF78nizj+m5eesTDt0CrIapeUuxH
 VFbJJYAWL0NR3sam4J+7Dk15Pa6ntTJ5Cbr0at8AbSg4hJkzqTdUCBBS1h0XoLSI3D/NEBPSAQ
 SrqDT372O9T3Dh5SGoSabRTExP6/qU3oyoLX49qGsyF8rYl3Ax2aYnSh9n8AgYGLB9cKS8doGv
 osCKEO8EUd8SlH/akAAvgSI8TfRJu8U1JVJzAhacEV+VtFM4p/xiuKR7urQDW2O+LtE/37y4VI
 nXI=
X-IronPort-AV: E=Sophos;i="5.76,429,1592895600"; 
   d="scan'208";a="89124144"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Sep 2020 03:01:48 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Sep 2020 03:01:46 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 15 Sep 2020 03:01:46 -0700
Date:   Tue, 15 Sep 2020 09:59:11 +0000
From:   "henrik.bjoernlund@microchip.com" <henrik.bjoernlund@microchip.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [PATCH RFC 6/7] bridge: cfm: Netlink Notifications.
Message-ID: <20200915095911.yq47xtboc5bn2b3i@soft-test08>
References: <20200904091527.669109-1-henrik.bjoernlund@microchip.com>
 <20200904091527.669109-7-henrik.bjoernlund@microchip.com>
 <cbb516e37457ef1875f99001ec72624c49ab51ed.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <cbb516e37457ef1875f99001ec72624c49ab51ed.camel@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the review. Comments below.

The 09/08/2020 13:54, Nikolay Aleksandrov wrote:
> 
> On Fri, 2020-09-04 at 09:15 +0000, Henrik Bjoernlund wrote:
> > This is the implementation of Netlink notifications out of CFM.
> >
> > Notifications are initiated whenever a state change happens in CFM.
> >
> [snip]
> > @@ -445,6 +458,7 @@ static int br_cfm_frame_rx(struct net_bridge_port *port, struct sk_buff *skb)
> >                       peer_mep->cc_status.ccm_defect = false;
> >
> >                       /* Change in CCM defect status - notify */
> > +                     br_cfm_notify(RTM_NEWLINK, port);
> >
> >                       /* Start CCM RX timer */
> >                       ccm_rx_timer_start(peer_mep);
> > @@ -874,6 +888,35 @@ int br_cfm_cc_counters_clear(struct net_bridge *br, const u32 instance,
> >       return 0;
> >  }
> >
> > +int br_cfm_mep_count(struct net_bridge *br, u32 *count)
> > +{
> > +     struct br_cfm_mep *mep;
> 
> Leave a blank line between local variable definitions and code.
> 
I will change that as suggested.

> > +     *count = 0;
> > +
> > +     rcu_read_lock();
> > +     list_for_each_entry_rcu(mep, &br->mep_list, head)
> > +             * count += 1;
> 
> please remove the extra space
> 
I will change that as suggested.

> > +     rcu_read_unlock();
> > +
> > +     return 0;
> > +}
> > +
> > +int br_cfm_peer_mep_count(struct net_bridge *br, u32 *count)
> > +{
> > +     struct br_cfm_peer_mep *peer_mep;
> > +     struct br_cfm_mep *mep;
> 
> Leave a blank line between local variable definitions and code.
> 
I will change that as suggested.

> > +     *count = 0;
> > +
> > +     rcu_read_lock();
> > +     list_for_each_entry_rcu(mep, &br->mep_list, head) {
> > +             list_for_each_entry_rcu(peer_mep, &mep->peer_mep_list, head)
> > +                     * count += 1;
> 
> please remove the extra space
> 
I will change that as suggested.

> > +     }
> > +     rcu_read_unlock();
> > +
> > +     return 0;
> > +}
> > +
> >  bool br_cfm_created(struct net_bridge *br)
> >  {
> >       return !list_empty(&br->mep_list);
> > diff --git a/net/bridge/br_cfm_netlink.c b/net/bridge/br_cfm_netlink.c
> > index 4e39aab1cd0b..13664ac8608a 100644
> > --- a/net/bridge/br_cfm_netlink.c
> > +++ b/net/bridge/br_cfm_netlink.c
> > @@ -582,7 +582,9 @@ int br_cfm_config_fill_info(struct sk_buff *skb, struct net_bridge *br)
> >       return -EMSGSIZE;
> >  }
> >
> > -int br_cfm_status_fill_info(struct sk_buff *skb, struct net_bridge *br)
> > +int br_cfm_status_fill_info(struct sk_buff *skb,
> > +                         struct net_bridge *br,
> > +                         bool getlink)
> >  {
> >       struct nlattr *tb, *cfm_tb;
> >       struct br_cfm_mep *mep;
> > @@ -613,10 +615,12 @@ int br_cfm_status_fill_info(struct sk_buff *skb, struct net_bridge *br)
> >                               mep->status.rx_level_low_seen))
> >                       goto nla_put_failure;
> >
> > -             /* Clear all 'seen' indications */
> > -             mep->status.opcode_unexp_seen = false;
> > -             mep->status.version_unexp_seen = false;
> > -             mep->status.rx_level_low_seen = false;
> > +             if (getlink) { /* Only clear if this is a GETLINK */
> > +                     /* Clear all 'seen' indications */
> > +                     mep->status.opcode_unexp_seen = false;
> > +                     mep->status.version_unexp_seen = false;
> > +                     mep->status.rx_level_low_seen = false;
> > +             }
> >
> >               nla_nest_end(skb, tb);
> >
> > @@ -662,10 +666,12 @@ int br_cfm_status_fill_info(struct sk_buff *skb, struct net_bridge *br)
> >                                       peer_mep->cc_status.seq_unexp_seen))
> >                               goto nla_put_failure;
> >
> > -                     /* Clear all 'seen' indications */
> > -                     peer_mep->cc_status.seen = false;
> > -                     peer_mep->cc_status.tlv_seen = false;
> > -                     peer_mep->cc_status.seq_unexp_seen = false;
> > +                     if (getlink) { /* Only clear if this is a GETLINK */
> > +                             /* Clear all 'seen' indications */
> > +                             peer_mep->cc_status.seen = false;
> > +                             peer_mep->cc_status.tlv_seen = false;
> > +                             peer_mep->cc_status.seq_unexp_seen = false;
> 
> Why clear these on GETLINK? This sounds like it should be a set op.
> 
The idea is that when getting the CFM status any '_seen' indications are
cleared so that they are giving information about what was seen since
last get.
I assume this is a get/clear atomic operations as rcu is held.
If you think this must be changed to a seperate clear_set operation I
will ofc do it.

> > +                     }
> >
> >                       nla_nest_end(skb, tb);
> >               }
> > diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> > index 6de5cb1295f6..f2e885521f4f 100644
> > --- a/net/bridge/br_netlink.c
> > +++ b/net/bridge/br_netlink.c
> > @@ -94,9 +94,11 @@ static size_t br_get_link_af_size_filtered(const struct net_device *dev,
> >  {
> >       struct net_bridge_vlan_group *vg = NULL;
> >       struct net_bridge_port *p = NULL;
> > -     struct net_bridge *br;
> > -     int num_vlan_infos;
> > +     struct net_bridge *br = NULL;
> > +     u32 num_cfm_peer_mep_infos;
> > +     u32 num_cfm_mep_infos;
> >       size_t vinfo_sz = 0;
> > +     int num_vlan_infos;
> >
> >       rcu_read_lock();
> >       if (netif_is_bridge_port(dev)) {
> > @@ -115,6 +117,52 @@ static size_t br_get_link_af_size_filtered(const struct net_device *dev,
> >       /* Each VLAN is returned in bridge_vlan_info along with flags */
> >       vinfo_sz += num_vlan_infos * nla_total_size(sizeof(struct bridge_vlan_info));
> >
> > +     if (!(filter_mask & RTEXT_FILTER_CFM_STATUS))
> > +             return vinfo_sz;
> > +
> > +     if (!br)
> > +             return vinfo_sz;
> > +
> > +     /* CFM status info must be added */
> > +     if (br_cfm_mep_count(br, &num_cfm_mep_infos))
> > +             return vinfo_sz;
> > +
> > +     if (br_cfm_peer_mep_count(br, &num_cfm_peer_mep_infos))
> > +             return vinfo_sz;
> > +
> 
> Can these return non-0 at all?
> 
I have removed check of return value.

> > +     vinfo_sz += nla_total_size(0);  /* IFLA_BRIDGE_CFM */
> > +     /* For each status struct the MEP instance (u32) is added */
> > +     /* MEP instance (u32) + br_cfm_mep_status */
> > +     vinfo_sz += num_cfm_mep_infos *
> > +                  /*IFLA_BRIDGE_CFM_MEP_STATUS_INSTANCE */
> > +                 (nla_total_size(sizeof(u32))
> > +                  /* IFLA_BRIDGE_CFM_MEP_STATUS_OPCODE_UNEXP_SEEN */
> > +                  + nla_total_size(sizeof(u32))
> > +                  /* IFLA_BRIDGE_CFM_MEP_STATUS_VERSION_UNEXP_SEEN */
> > +                  + nla_total_size(sizeof(u32))
> > +                  /* IFLA_BRIDGE_CFM_MEP_STATUS_RX_LEVEL_LOW_SEEN */
> > +                  + nla_total_size(sizeof(u32)));
> > +     /* MEP instance (u32) + br_cfm_cc_peer_status */
> > +     vinfo_sz += num_cfm_peer_mep_infos *
> > +                  /* IFLA_BRIDGE_CFM_CC_PEER_STATUS_INSTANCE */
> > +                 (nla_total_size(sizeof(u32))
> > +                  /* IFLA_BRIDGE_CFM_CC_PEER_STATUS_PEER_MEPID */
> > +                  + nla_total_size(sizeof(u32))
> > +                  /* IFLA_BRIDGE_CFM_CC_PEER_STATUS_CCM_DEFECT */
> > +                  + nla_total_size(sizeof(u32))
> > +                  /* IFLA_BRIDGE_CFM_CC_PEER_STATUS_RDI */
> > +                  + nla_total_size(sizeof(u32))
> > +                  /* IFLA_BRIDGE_CFM_CC_PEER_STATUS_PORT_TLV_VALUE */
> > +                  + nla_total_size(sizeof(u8))
> > +                  /* IFLA_BRIDGE_CFM_CC_PEER_STATUS_IF_TLV_VALUE */
> > +                  + nla_total_size(sizeof(u8))
> > +                  /* IFLA_BRIDGE_CFM_CC_PEER_STATUS_SEEN */
> > +                  + nla_total_size(sizeof(u32))
> > +                  /* IFLA_BRIDGE_CFM_CC_PEER_STATUS_TLV_SEEN */
> > +                  + nla_total_size(sizeof(u32))
> > +                  /* IFLA_BRIDGE_CFM_CC_PEER_STATUS_SEQ_UNEXP_SEEN */
> > +                  + nla_total_size(sizeof(u32)));
> > +
> >       return vinfo_sz;
> >  }
> >
> > @@ -378,7 +426,8 @@ static int br_fill_ifvlaninfo(struct sk_buff *skb,
> >  static int br_fill_ifinfo(struct sk_buff *skb,
> >                         const struct net_bridge_port *port,
> >                         u32 pid, u32 seq, int event, unsigned int flags,
> > -                       u32 filter_mask, const struct net_device *dev)
> > +                       u32 filter_mask, const struct net_device *dev,
> > +                       bool getlink)
> >  {
> >       u8 operstate = netif_running(dev) ? dev->operstate : IF_OPER_DOWN;
> >       struct net_bridge *br;
> > @@ -515,7 +564,7 @@ static int br_fill_ifinfo(struct sk_buff *skb,
> >                       goto nla_put_failure;
> >
> >               rcu_read_lock();
> > -             err = br_cfm_status_fill_info(skb, br);
> > +             err = br_cfm_status_fill_info(skb, br, getlink);
> >               rcu_read_unlock();
> >
> >               if (err)
> > @@ -533,11 +582,9 @@ static int br_fill_ifinfo(struct sk_buff *skb,
> >       return -EMSGSIZE;
> >  }
> >
> > -/* Notify listeners of a change in bridge or port information */
> > -void br_ifinfo_notify(int event, const struct net_bridge *br,
> > -                   const struct net_bridge_port *port)
> > +void br_info_notify(int event, const struct net_bridge *br,
> > +                 const struct net_bridge_port *port, u32 filter)
> >  {
> > -     u32 filter = RTEXT_FILTER_BRVLAN_COMPRESSED;
> >       struct net_device *dev;
> >       struct sk_buff *skb;
> >       int err = -ENOBUFS;
> > @@ -562,7 +609,7 @@ void br_ifinfo_notify(int event, const struct net_bridge *br,
> >       if (skb == NULL)
> >               goto errout;
> >
> > -     err = br_fill_ifinfo(skb, port, 0, 0, event, 0, filter, dev);
> > +     err = br_fill_ifinfo(skb, port, 0, 0, event, 0, filter, dev, false);
> >       if (err < 0) {
> >               /* -EMSGSIZE implies BUG in br_nlmsg_size() */
> >               WARN_ON(err == -EMSGSIZE);
> > @@ -575,6 +622,15 @@ void br_ifinfo_notify(int event, const struct net_bridge *br,
> >       rtnl_set_sk_err(net, RTNLGRP_LINK, err);
> >  }
> >
> > +/* Notify listeners of a change in bridge or port information */
> > +void br_ifinfo_notify(int event, const struct net_bridge *br,
> > +                   const struct net_bridge_port *port)
> > +{
> > +     u32 filter = RTEXT_FILTER_BRVLAN_COMPRESSED;
> > +
> > +     return br_info_notify(event, br, port, filter);
> > +}
> > +
> >  /*
> >   * Dump information about all ports, in response to GETLINK
> >   */
> > @@ -591,7 +647,7 @@ int br_getlink(struct sk_buff *skb, u32 pid, u32 seq,
> >               return 0;
> >
> >       return br_fill_ifinfo(skb, port, pid, seq, RTM_NEWLINK, nlflags,
> > -                           filter_mask, dev);
> > +                           filter_mask, dev, true);
> >  }
> >
> >  static int br_vlan_info(struct net_bridge *br, struct net_bridge_port *p,
> > diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> > index fe36592f7525..53bcbdd21f34 100644
> > --- a/net/bridge/br_private.h
> > +++ b/net/bridge/br_private.h
> > @@ -1370,7 +1370,11 @@ int br_cfm_parse(struct net_bridge *br, struct net_bridge_port *p,
> >  int br_cfm_rx_frame_process(struct net_bridge_port *p, struct sk_buff *skb);
> >  bool br_cfm_created(struct net_bridge *br);
> >  int br_cfm_config_fill_info(struct sk_buff *skb, struct net_bridge *br);
> > -int br_cfm_status_fill_info(struct sk_buff *skb, struct net_bridge *br);
> > +int br_cfm_status_fill_info(struct sk_buff *skb,
> > +                         struct net_bridge *br,
> > +                         bool getlink);
> > +int br_cfm_mep_count(struct net_bridge *br, u32 *count);
> > +int br_cfm_peer_mep_count(struct net_bridge *br, u32 *count);
> >  #else
> >  static inline int br_cfm_parse(struct net_bridge *br, struct net_bridge_port *p,
> >                              struct nlattr *attr, int cmd,
> > @@ -1394,7 +1398,19 @@ static inline int br_cfm_config_fill_info(struct sk_buff *skb, struct net_bridge
> >       return -EOPNOTSUPP;
> >  }
> >
> > -static inline int br_cfm_status_fill_info(struct sk_buff *skb, struct net_bridge *br)
> > +static inline int br_cfm_status_fill_info(struct sk_buff *skb,
> > +                                       struct net_bridge *br,
> > +                                       bool getlink)
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> > +
> > +static inline int br_cfm_mep_count(struct net_bridge *br, u32 *count)
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> > +
> > +static inline int br_cfm_peer_mep_count(struct net_bridge *br, u32 *count)
> >  {
> >       return -EOPNOTSUPP;
> >  }
> > @@ -1406,6 +1422,8 @@ int br_netlink_init(void);
> >  void br_netlink_fini(void);
> >  void br_ifinfo_notify(int event, const struct net_bridge *br,
> >                     const struct net_bridge_port *port);
> > +void br_info_notify(int event, const struct net_bridge *br,
> > +                 const struct net_bridge_port *port, u32 filter);
> >  int br_setlink(struct net_device *dev, struct nlmsghdr *nlmsg, u16 flags,
> >              struct netlink_ext_ack *extack);
> >  int br_dellink(struct net_device *dev, struct nlmsghdr *nlmsg, u16 flags);
> 

-- 
/Henrik

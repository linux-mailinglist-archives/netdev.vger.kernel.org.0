Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218C91E7C39
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 13:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgE2Lrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 07:47:35 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:60315 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbgE2Lrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 07:47:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1590752854; x=1622288854;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=r0LsLIe3f2cpj18gV8W+yu6tvgZ5rEPFEFqWzmvLmbw=;
  b=ANlGprWElVPnJGfXukYQxS4Ue4tRaaVItdm93ejT3cbOlg2+H9izbisl
   jD7wZKATvvpke1wT9hBNfRAmwnF3GNv1kG2y8Z0YRySVdoMijTPsUHTgP
   JOrai7nw2Hfguf8wN7Hs6mLSv795tji6HuyX6VCIDxx2UfS1pkcJggNWn
   p2fW05eTEZvx3AbFryiAC1pUClbowLx57roqsIbyIuDgbrImE9E/YrzOP
   SM7dKW8EiLeFeAtkRe5dzQYHpJ3y9YdJWNV6ZMSa8BptGspKYpNqtFrqT
   RtGcA3DSt7fQDC6LtRbJljZ2puYeL4mqy6xXMErZPQ2n8SRCWgFKXQBkD
   g==;
IronPort-SDR: nnx5ftn4eJeRPJUpRzrRfyUoXBFl+4hodo2iZqxNdsZdzo9QxsEXKsJ45C81surIZXsv3Wb6nV
 jkebu2++bYfexAKEawErCa6hxk0FMXr3mtDcpWFMkNe71ln2IoUPGPXb4jhBYuYea2yba0eErs
 eyhIhJMWzbM51pG+sEIw0CiaOhuNlOWXIVTZNJtmwJKl98xoI+p+eYQg9048o4qScHC2YSEk2W
 tRx5ADLvuqz76P3tFbOaSCOi7UgwW8qN2eRQ3szKsNv+9DzMgZ1voRf4WzGOby3+zGwZ8igQ9S
 Gpo=
X-IronPort-AV: E=Sophos;i="5.73,448,1583218800"; 
   d="scan'208";a="76749262"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 May 2020 04:47:34 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 29 May 2020 04:47:33 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Fri, 29 May 2020 04:47:24 -0700
Date:   Fri, 29 May 2020 13:47:12 +0000
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
CC:     <roopa@cumulusnetworks.com>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 1/2] bridge: mrp: Set the priority of MRP
 instance
Message-ID: <20200529134712.qtua2ys4mxw7h77i@soft-dev3.localdomain>
References: <20200529100514.920537-1-horatiu.vultur@microchip.com>
 <20200529100514.920537-2-horatiu.vultur@microchip.com>
 <fc47aca8-a188-5e57-fe76-8e57c2910920@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <fc47aca8-a188-5e57-fe76-8e57c2910920@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 05/29/2020 11:12, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On 29/05/2020 13:05, Horatiu Vultur wrote:
> > Each MRP instance has a priority, a lower value means a higher priority.
> > The priority of MRP instance is stored in MRP_Test frame in this way
> > all the MRP nodes in the ring can see other nodes priority.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  include/net/switchdev.h        | 1 +
> >  include/uapi/linux/if_bridge.h | 2 ++
> >  net/bridge/br_mrp.c            | 3 ++-
> >  net/bridge/br_mrp_netlink.c    | 5 +++++
> >  net/bridge/br_mrp_switchdev.c  | 1 +
> >  net/bridge/br_private_mrp.h    | 1 +
> >  6 files changed, 12 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/net/switchdev.h b/include/net/switchdev.h
> > index db519957e134b..f82ef4c45f5ed 100644
> > --- a/include/net/switchdev.h
> > +++ b/include/net/switchdev.h
> > @@ -116,6 +116,7 @@ struct switchdev_obj_mrp {
> >       struct net_device *p_port;
> >       struct net_device *s_port;
> >       u32 ring_id;
> > +     u16 prio;
> >  };
> >
> >  #define SWITCHDEV_OBJ_MRP(OBJ) \
> > diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
> > index 5a43eb86c93bf..0162c1370ecb6 100644
> > --- a/include/uapi/linux/if_bridge.h
> > +++ b/include/uapi/linux/if_bridge.h
> > @@ -176,6 +176,7 @@ enum {
> >       IFLA_BRIDGE_MRP_INSTANCE_RING_ID,
> >       IFLA_BRIDGE_MRP_INSTANCE_P_IFINDEX,
> >       IFLA_BRIDGE_MRP_INSTANCE_S_IFINDEX,
> > +     IFLA_BRIDGE_MRP_INSTANCE_PRIO,
> >       __IFLA_BRIDGE_MRP_INSTANCE_MAX,
> >  };
> >
> > @@ -230,6 +231,7 @@ struct br_mrp_instance {
> >       __u32 ring_id;
> >       __u32 p_ifindex;
> >       __u32 s_ifindex;
> > +     __u16 prio;
> >  };
> >
> >  struct br_mrp_ring_state {
> > diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
> > index 8ea59504ef47a..f8fd037219fe9 100644
> > --- a/net/bridge/br_mrp.c
> > +++ b/net/bridge/br_mrp.c
> > @@ -147,7 +147,7 @@ static struct sk_buff *br_mrp_alloc_test_skb(struct br_mrp *mrp,
> >       br_mrp_skb_tlv(skb, BR_MRP_TLV_HEADER_RING_TEST, sizeof(*hdr));
> >       hdr = skb_put(skb, sizeof(*hdr));
> >
> > -     hdr->prio = cpu_to_be16(MRP_DEFAULT_PRIO);
> > +     hdr->prio = cpu_to_be16(mrp->prio);
> >       ether_addr_copy(hdr->sa, p->br->dev->dev_addr);
> >       hdr->port_role = cpu_to_be16(port_role);
> >       hdr->state = cpu_to_be16(mrp->ring_state);
> > @@ -290,6 +290,7 @@ int br_mrp_add(struct net_bridge *br, struct br_mrp_instance *instance)
> >               return -ENOMEM;
> >
> >       mrp->ring_id = instance->ring_id;
> > +     mrp->prio = instance->prio;
> >
> >       p = br_mrp_get_port(br, instance->p_ifindex);
> >       spin_lock_bh(&br->lock);
> > diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
> > index d9de780d2ce06..332d9894a9485 100644
> > --- a/net/bridge/br_mrp_netlink.c
> > +++ b/net/bridge/br_mrp_netlink.c
> > @@ -22,6 +22,7 @@ br_mrp_instance_policy[IFLA_BRIDGE_MRP_INSTANCE_MAX + 1] = {
> >       [IFLA_BRIDGE_MRP_INSTANCE_RING_ID]      = { .type = NLA_U32 },
> >       [IFLA_BRIDGE_MRP_INSTANCE_P_IFINDEX]    = { .type = NLA_U32 },
> >       [IFLA_BRIDGE_MRP_INSTANCE_S_IFINDEX]    = { .type = NLA_U32 },
> > +     [IFLA_BRIDGE_MRP_INSTANCE_PRIO]         = { .type = NLA_U16 },
> >  };
> >
> >  static int br_mrp_instance_parse(struct net_bridge *br, struct nlattr *attr,
> > @@ -49,6 +50,10 @@ static int br_mrp_instance_parse(struct net_bridge *br, struct nlattr *attr,
> >       inst.ring_id = nla_get_u32(tb[IFLA_BRIDGE_MRP_INSTANCE_RING_ID]);
> >       inst.p_ifindex = nla_get_u32(tb[IFLA_BRIDGE_MRP_INSTANCE_P_IFINDEX]);
> >       inst.s_ifindex = nla_get_u32(tb[IFLA_BRIDGE_MRP_INSTANCE_S_IFINDEX]);
> > +     inst.prio = MRP_DEFAULT_PRIO;
> > +
> > +     if (tb[IFLA_BRIDGE_MRP_INSTANCE_PRIO])
> > +             inst.prio = nla_get_u32(tb[IFLA_BRIDGE_MRP_INSTANCE_PRIO]);
> 
>         [IFLA_BRIDGE_MRP_INSTANCE_PRIO]         = { .type = NLA_U16 },
> 
> it seems you should be using nla_get_u16 above

Good catch, I will update this in the next version.

> 
> >
> >       if (cmd == RTM_SETLINK)
> >               return br_mrp_add(br, &inst);
> > diff --git a/net/bridge/br_mrp_switchdev.c b/net/bridge/br_mrp_switchdev.c
> > index 51cb1d5a24b4f..3a776043bf80d 100644
> > --- a/net/bridge/br_mrp_switchdev.c
> > +++ b/net/bridge/br_mrp_switchdev.c
> > @@ -12,6 +12,7 @@ int br_mrp_switchdev_add(struct net_bridge *br, struct br_mrp *mrp)
> >               .p_port = rtnl_dereference(mrp->p_port)->dev,
> >               .s_port = rtnl_dereference(mrp->s_port)->dev,
> >               .ring_id = mrp->ring_id,
> > +             .prio = mrp->prio,
> >       };
> >       int err;
> >
> > diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
> > index a0f53cc3ab85c..558941ce23669 100644
> > --- a/net/bridge/br_private_mrp.h
> > +++ b/net/bridge/br_private_mrp.h
> > @@ -14,6 +14,7 @@ struct br_mrp {
> >       struct net_bridge_port __rcu    *s_port;
> >
> >       u32                             ring_id;
> > +     u16                             prio;
> >
> >       enum br_mrp_ring_role_type      ring_role;
> >       u8                              ring_role_offloaded;
> >
> 

-- 
/Horatiu

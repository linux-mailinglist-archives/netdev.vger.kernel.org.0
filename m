Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18B3F19C2ED
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 15:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731738AbgDBNq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 09:46:29 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:63914 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729213AbgDBNq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 09:46:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1585835189; x=1617371189;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DS6bxUN2ImDjhH5wRzTupKct7H43XvDw4TXp4H9sGcA=;
  b=PQYB6b0OMNyXTKUbIsL5uOLbeUDA5awB0CTwVPu0prRq+lNvmYjsc5Ec
   8P6iT/MSF7QJfBDMSw39VWU8pF9wI03fufrueQhD4dRPXfuBoDCmOt2yq
   0vDAjJ8Q/ZJu7pr8ahbiqiI2/IZwARePThy6iHWAkChPwhFEZrqMh87dV
   YEXKjvvgXI/mBNwgs2WG3MMkdr4OV98kuXJLBMlsW8OJj0l21hnnMAoAh
   j7JqhWrWSv4QfwS3aBoUKQeyAdJxCJHUEkgwe7Pf868Xx67Lt1yy/Hbuk
   IYWnOUn+OjGu9UiAqyElncWFKIiLQPkXQW+xxlYSSk5pUyIXyCrRtp05I
   A==;
IronPort-SDR: yairDGlYyJEj1Cn3VzBUHjEAc5RO5tfa6v79kIUwFMzNLaKfBVkB3yC41QBi+ixK3xh8YVaqf3
 bi5aul/nhlTNISz+VXUvhw9zSCrzO7twzvvsE1NW4XUxTSVu+EOE1WUgCuGtPhafhhrEtHBQ4v
 jDVR8i4d7+EtljR2RfX5B1+VLYWcPsNfRbUUtk6vYDZ/4I5Lr3mo4HlXaD7K3xVmRLKNBe1FLT
 bsjHU7VimR69/pVwl9nXIYJxHEfRYck6oQpI5DyjHCAizR6qVzQHUrU4/iYQr2mUUzzBfFJ1PC
 lug=
X-IronPort-AV: E=Sophos;i="5.72,335,1580799600"; 
   d="scan'208";a="69189997"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Apr 2020 06:46:28 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 2 Apr 2020 06:46:34 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 2 Apr 2020 06:46:27 -0700
Date:   Thu, 2 Apr 2020 15:46:27 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
CC:     <davem@davemloft.net>, <jiri@resnulli.us>, <ivecera@redhat.com>,
        <kuba@kernel.org>, <roopa@cumulusnetworks.com>,
        <olteanv@gmail.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
Subject: Re: [RFC net-next v4 8/9] bridge: mrp: Integrate MRP into the bridge
Message-ID: <20200402134627.pnypnxzazqbpjcd3@soft-dev3.microsemi.net>
References: <20200327092126.15407-1-horatiu.vultur@microchip.com>
 <20200327092126.15407-9-horatiu.vultur@microchip.com>
 <17d9fb2a-cb48-7bb6-cb79-3876ca3a74b2@cumulusnetworks.com>
 <20200401161021.3s2sqvma7r7wpo7h@soft-dev3.microsemi.net>
 <d35f44a6-a70f-bc29-afa6-0dd04e331981@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <d35f44a6-a70f-bc29-afa6-0dd04e331981@cumulusnetworks.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/01/2020 19:33, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On 01/04/2020 19:10, Horatiu Vultur wrote:
> > Hi Nik,
> >
> > The 03/30/2020 19:16, Nikolay Aleksandrov wrote:
> >> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> >>
> >> On 27/03/2020 11:21, Horatiu Vultur wrote:
> >>> To integrate MRP into the bridge, the bridge needs to do the following:
> >>> - add new flag(BR_MPP_AWARE) to the net bridge ports, this bit will be set when
> >>>   the port is added to an MRP instance. In this way it knows if the frame was
> >>>   received on MRP ring port
> >>> - detect if the MRP frame was received on MRP ring port in that case it would be
> >>>   processed otherwise just forward it as usual.
> >>> - enable parsing of MRP
> >>> - before whenever the bridge was set up, it would set all the ports in
> >>>   forwarding state. Add an extra check to not set ports in forwarding state if
> >>>   the port is an MRP ring port. The reason of this change is that if the MRP
> >>>   instance initially sets the port in blocked state by setting the bridge up it
> >>>   would overwrite this setting.
> >>>
> >>> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> >>> ---
> >>>  include/linux/if_bridge.h |  1 +
> >>>  net/bridge/br_device.c    |  3 +++
> >>>  net/bridge/br_input.c     |  3 +++
> >>>  net/bridge/br_netlink.c   |  5 +++++
> >>>  net/bridge/br_private.h   | 22 ++++++++++++++++++++++
> >>>  net/bridge/br_stp.c       |  6 ++++++
> >>>  6 files changed, 40 insertions(+)
> >>>
> >>> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> >>> index 9e57c4411734..10baa9efdae8 100644
> >>> --- a/include/linux/if_bridge.h
> >>> +++ b/include/linux/if_bridge.h
> >>> @@ -47,6 +47,7 @@ struct br_ip_list {
> >>>  #define BR_BCAST_FLOOD               BIT(14)
> >>>  #define BR_NEIGH_SUPPRESS    BIT(15)
> >>>  #define BR_ISOLATED          BIT(16)
> >>> +#define BR_MRP_AWARE         BIT(17)
> >>>
> >>>  #define BR_DEFAULT_AGEING_TIME       (300 * HZ)
> >>>
> >>> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
> >>> index 0e3dbc5f3c34..8ec1362588af 100644
> >>> --- a/net/bridge/br_device.c
> >>> +++ b/net/bridge/br_device.c
> >>> @@ -463,6 +463,9 @@ void br_dev_setup(struct net_device *dev)
> >>>       spin_lock_init(&br->lock);
> >>>       INIT_LIST_HEAD(&br->port_list);
> >>>       INIT_HLIST_HEAD(&br->fdb_list);
> >>> +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> >>> +     INIT_LIST_HEAD(&br->mrp_list);
> >>> +#endif
> >>>       spin_lock_init(&br->hash_lock);
> >>>
> >>>       br->bridge_id.prio[0] = 0x80;
> >>> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> >>> index fcc260840028..d5c34f36f0f4 100644
> >>> --- a/net/bridge/br_input.c
> >>> +++ b/net/bridge/br_input.c
> >>> @@ -342,6 +342,9 @@ rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
> >>>               }
> >>>       }
> >>>
> >>> +     if (unlikely(br_mrp_process(p, skb)))
> >>> +             return RX_HANDLER_PASS;
> >>> +
> >>>  forward:
> >>>       switch (p->state) {
> >>>       case BR_STATE_FORWARDING:
> >>> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> >>> index 43dab4066f91..77bc96745be6 100644
> >>> --- a/net/bridge/br_netlink.c
> >>> +++ b/net/bridge/br_netlink.c
> >>> @@ -669,6 +669,11 @@ static int br_afspec(struct net_bridge *br,
> >>>                       if (err)
> >>>                               return err;
> >>>                       break;
> >>> +             case IFLA_BRIDGE_MRP:
> >>> +                     err = br_mrp_parse(br, p, attr, cmd);
> >>> +                     if (err)
> >>> +                             return err;
> >>> +                     break;
> >>>               }
> >>>       }
> >>>
> >>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> >>> index 1f97703a52ff..38894f2cf98f 100644
> >>> --- a/net/bridge/br_private.h
> >>> +++ b/net/bridge/br_private.h
> >>> @@ -428,6 +428,10 @@ struct net_bridge {
> >>>       int offload_fwd_mark;
> >>>  #endif
> >>>       struct hlist_head               fdb_list;
> >>> +
> >>> +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> >>> +     struct list_head                __rcu mrp_list;
> >>> +#endif
> >>>  };
> >>>
> >>>  struct br_input_skb_cb {
> >>> @@ -1304,6 +1308,24 @@ unsigned long br_timer_value(const struct timer_list *timer);
> >>>  extern int (*br_fdb_test_addr_hook)(struct net_device *dev, unsigned char *addr);
> >>>  #endif
> >>>
> >>> +/* br_mrp.c */
> >>> +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> >>> +int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
> >>> +              struct nlattr *attr, int cmd);
> >>> +int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb);
> >>> +#else
> >>> +static inline int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
> >>> +                            struct nlattr *attr, int cmd)
> >>> +{
> >>> +     return -1;
> >>
> >> You should return proper error here.
> >
> > It will return -EOPNOTSUPP.
> >
> >>
> >>> +}
> >>> +
> >>> +static inline int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb)
> >>> +{
> >>> +     return -1;
> >>
> >> The bridge can't possibly work with MRP disabled with this.
> >
> > Good catch, it will return 0.
> >
> >>
> >>> +}
> >>> +#endif
> >>> +
> >>>  /* br_netlink.c */
> >>>  extern struct rtnl_link_ops br_link_ops;
> >>>  int br_netlink_init(void);
> >>> diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
> >>> index 1f14b8455345..3e88be7aa269 100644
> >>> --- a/net/bridge/br_stp.c
> >>> +++ b/net/bridge/br_stp.c
> >>> @@ -36,6 +36,12 @@ void br_set_state(struct net_bridge_port *p, unsigned int state)
> >>>       };
> >>>       int err;
> >>>
> >>> +     /* Don't change the state of the ports if they are driven by a different
> >>> +      * protocol.
> >>> +      */
> >>> +     if (p->flags & BR_MRP_AWARE)
> >>> +             return;
> >>> +
> >>
> >> Maybe disallow STP type (kernel/user-space/no-stp) changing as well, force it to no-stp.
> >
> > I am not sure that I understand completely here, do you want me to
> > disable STP if MRP is started?
> >
> 
> I think it should be one of the two since they can step on each other's toes. If MRP is
> enabled then STP must be already disabled and should not be possible to enable while MRP
> is active and vice-versa.

I will update this in the next patch series.

> 
> >>
> >>>       p->state = state;
> >>>       err = switchdev_port_attr_set(p->dev, &attr);
> >>>       if (err && err != -EOPNOTSUPP)
> >>>
> >>
> >
> 

-- 
/Horatiu

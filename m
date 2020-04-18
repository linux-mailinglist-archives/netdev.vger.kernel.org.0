Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00B41AF0BE
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 16:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbgDROwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 10:52:04 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:63416 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728179AbgDROwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 10:52:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587221521; x=1618757521;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=C3YP8yE4p3sUrpu20KaBy3TdZyCFMvkjb9hsbrcNjhI=;
  b=2DoVcbq6URRWX1uv52bCzZQlggV+t+VDixnSaP2DLdDpVPVWnnTj+l//
   88RTgKPWlaIPwht+Lskk5+5+vucEeN88aHEel4f9iKZrawbAdaJw+5dos
   if06/VjQGMrTDJu13z7FZQUxds7VWZx/IEX9jej0DK/b9l0Wo6JoLksZ6
   Ukp4CTN/pPfP+hWX/0F167FgTkdidW7Tix6VzKxBo/yJ6ZPHT46nRxPKS
   uakfwHqCDWsYa8zZ8VNLG+rRlQtCdcbsiWMgyrfuSxmMmNs1T1dFwYsy5
   vtQ+xe6XJOYceG2w32tj78hagVqu0HIj4Xa9uGytOkcuJEpBrKnkFYuS1
   A==;
IronPort-SDR: 05UYHcW6O85MPOiK9FjJllqWxK4fcLAoutWwPwraEyWZGXL2QjuQ9uzj3uzxXEezXyUJd3lXIc
 Zk4MX3hGHGtH5y48LpYXZkefWG6yBT7nQ70l4dPbCw+GvIhkft3JIvHlj3eN5/HBjYWUb8+Fk8
 ByIVl0pIMzbLvOUx9Zls5AO829/hOy21Wb7fAxaXcYfgjxPqp3nwliA/RCW6LFAw7QDpjsc+dl
 Qx/9MBMYC4d6OkuzzJ3Qyphk4BURPuvojmnwgLyXd/rPfRaZNyQMPraBwSLZUhZKuvfyxzoNxY
 OKQ=
X-IronPort-AV: E=Sophos;i="5.72,399,1580799600"; 
   d="scan'208";a="72972580"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Apr 2020 07:52:00 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 18 Apr 2020 07:52:00 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Sat, 18 Apr 2020 07:52:00 -0700
Date:   Sat, 18 Apr 2020 16:51:59 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
CC:     <davem@davemloft.net>, <jiri@resnulli.us>, <ivecera@redhat.com>,
        <kuba@kernel.org>, <roopa@cumulusnetworks.com>,
        <olteanv@gmail.com>, <andrew@lunn.ch>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next v5 8/9] bridge: mrp: Implement netlink interface
 to configure MRP
Message-ID: <20200418145159.ovt6ey7m6nlq4k2q@soft-dev3.microsemi.net>
References: <20200414112618.3644-1-horatiu.vultur@microchip.com>
 <20200414112618.3644-9-horatiu.vultur@microchip.com>
 <c6666b49-a00f-2edf-8cb6-8d649a2eaedb@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <c6666b49-a00f-2edf-8cb6-8d649a2eaedb@cumulusnetworks.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/18/2020 11:34, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On 14/04/2020 14:26, Horatiu Vultur wrote:
> > Implement netlink interface to configure MRP. The implementation
> > will do sanity checks over the attributes and then eventually call the MRP
> > interface.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  net/bridge/br_mrp_netlink.c | 164 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 164 insertions(+)
> >  create mode 100644 net/bridge/br_mrp_netlink.c
> >
> > diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
> > new file mode 100644
> > index 000000000000..0d8253311595
> > --- /dev/null
> > +++ b/net/bridge/br_mrp_netlink.c
> > @@ -0,0 +1,164 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +
> > +#include <net/genetlink.h>
> > +
> > +#include <uapi/linux/mrp_bridge.h>
> > +#include "br_private.h"
> > +#include "br_private_mrp.h"
> > +
> > +static const struct nla_policy br_mrp_policy[IFLA_BRIDGE_MRP_MAX + 1] = {
> > +     [IFLA_BRIDGE_MRP_UNSPEC]        = { .type = NLA_REJECT },
> > +     [IFLA_BRIDGE_MRP_INSTANCE]      = { .type = NLA_EXACT_LEN,
> > +                                         .len = sizeof(struct br_mrp_instance)},
> > +     [IFLA_BRIDGE_MRP_PORT_STATE]    = { .type = NLA_U32 },
> > +     [IFLA_BRIDGE_MRP_PORT_ROLE]     = { .type = NLA_EXACT_LEN,
> > +                                         .len = sizeof(struct br_mrp_port_role)},
> > +     [IFLA_BRIDGE_MRP_RING_STATE]    = { .type = NLA_EXACT_LEN,
> > +                                         .len = sizeof(struct br_mrp_ring_state)},
> > +     [IFLA_BRIDGE_MRP_RING_ROLE]     = { .type = NLA_EXACT_LEN,
> > +                                         .len = sizeof(struct br_mrp_ring_role)},
> > +     [IFLA_BRIDGE_MRP_START_TEST]    = { .type = NLA_EXACT_LEN,
> > +                                         .len = sizeof(struct br_mrp_start_test)},
> > +};
> > +
> > +int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
> > +              struct nlattr *attr, int cmd, struct netlink_ext_ack *extack)
> > +{
> > +     struct nlattr *tb[IFLA_BRIDGE_MRP_MAX + 1];
> > +     int err;
> > +
> > +     if (br->stp_enabled != BR_NO_STP) {
> > +             br_warn(br, "MRP can't be enabled if STP is already enabled\n");
> > +             return -EINVAL;
> > +     }
> > +
> > +     err = nla_parse_nested(tb, IFLA_BRIDGE_MRP_MAX, attr,
> > +                            NULL, extack);
> > +     if (err)
> > +             return err;
> > +
> > +     if (tb[IFLA_BRIDGE_MRP_INSTANCE]) {
> > +             struct br_mrp_instance *instance =
> > +                     nla_data(tb[IFLA_BRIDGE_MRP_INSTANCE]);
> > +
> > +             if (cmd == RTM_SETLINK)
> > +                     err = br_mrp_add(br, instance);
> > +             else
> > +                     err = br_mrp_del(br, instance);
> > +             if (err)
> > +                     return err;
> > +     }
> > +
> > +     if (tb[IFLA_BRIDGE_MRP_PORT_STATE]) {
> > +             enum br_mrp_port_state_type state =
> > +                     nla_get_u32(tb[IFLA_BRIDGE_MRP_PORT_STATE]);
> > +
> > +             err = br_mrp_set_port_state(p, state);
> 
> This can be executed for any port, just noting it.

Yes, maybe I should add an extra check in the function
br_mrp_set_port_state, similar to the function br_mrp_set_port_role, to
allow to be executed only on MRP_AWARE ports.

> 
> > +             if (err)
> > +                     return err;
> > +     }
> > +
> > +     if (tb[IFLA_BRIDGE_MRP_PORT_ROLE]) {
> > +             struct br_mrp_port_role *role =
> > +                     nla_data(tb[IFLA_BRIDGE_MRP_PORT_ROLE]);
> > +
> > +             err = br_mrp_set_port_role(p, role);
> 
> This can be executed for any port also, shouldn't it be available only for MRP_AWARE ports?

Yes, it can be executed for any port, but it would return an error if
the port is not MRP_AWARE. Because the function br_mrp_set_port_role
will check if the port is part of a ring and if it not then return
-EINVAL.

> 
> > +             if (err)
> > +                     return err;
> > +     }
> > +
> > +     if (tb[IFLA_BRIDGE_MRP_RING_STATE]) {
> > +             struct br_mrp_ring_state *state =
> > +                     nla_data(tb[IFLA_BRIDGE_MRP_RING_STATE]);
> > +
> > +             err = br_mrp_set_ring_state(br, state);
> > +             if (err)
> > +                     return err;
> > +     }
> > +
> > +     if (tb[IFLA_BRIDGE_MRP_RING_ROLE]) {
> > +             struct br_mrp_ring_role *role =
> > +                     nla_data(tb[IFLA_BRIDGE_MRP_RING_ROLE]);
> > +
> > +             err = br_mrp_set_ring_role(br, role);
> > +             if (err)
> > +                     return err;
> > +     }
> > +
> > +     if (tb[IFLA_BRIDGE_MRP_START_TEST]) {
> > +             struct br_mrp_start_test *test =
> > +                     nla_data(tb[IFLA_BRIDGE_MRP_START_TEST]);
> > +
> > +             err = br_mrp_start_test(br, test);
> > +             if (err)
> > +                     return err;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static inline size_t br_mrp_nlmsg_size(void)
> > +{
> > +     return NLMSG_ALIGN(sizeof(struct ifinfomsg))
> > +             + nla_total_size(4); /* IFLA_BRIDGE_MRP_RING_OPEN */
> > +}
> > +
> > +int br_mrp_port_open(struct net_device *dev, u8 loc)
> > +{
> > +     struct nlattr *af, *mrp;
> > +     struct ifinfomsg *hdr;
> > +     struct nlmsghdr *nlh;
> > +     struct sk_buff *skb;
> > +     int err = -ENOBUFS;
> > +     struct net *net;
> > +
> > +     net = dev_net(dev);
> > +
> > +     skb = nlmsg_new(br_mrp_nlmsg_size(), GFP_ATOMIC);
> > +     if (!skb)
> > +             goto errout;
> > +
> > +     nlh = nlmsg_put(skb, 0, 0, RTM_NEWLINK, sizeof(*hdr), 0);
> > +     if (!nlh)
> > +             goto errout;
> > +
> > +     hdr = nlmsg_data(nlh);
> > +     hdr->ifi_family = AF_BRIDGE;
> > +     hdr->__ifi_pad = 0;
> > +     hdr->ifi_type = dev->type;
> > +     hdr->ifi_index = dev->ifindex;
> > +     hdr->ifi_flags = dev_get_flags(dev);
> > +     hdr->ifi_change = 0;
> > +
> > +     af = nla_nest_start_noflag(skb, IFLA_AF_SPEC);
> > +     if (!af) {
> > +             err = -EMSGSIZE;
> > +             goto nla_put_failure;
> > +     }
> > +
> > +     mrp = nla_nest_start_noflag(skb, IFLA_BRIDGE_MRP);
> > +     if (!mrp) {
> > +             err = -EMSGSIZE;
> > +             goto nla_put_failure;
> > +     }
> > +
> > +     err = nla_put_u32(skb, IFLA_BRIDGE_MRP_RING_OPEN, loc);
> > +     if (err)
> > +             goto nla_put_failure;
> > +
> > +     nla_nest_end(skb, mrp);
> > +     nla_nest_end(skb, af);
> > +     nlmsg_end(skb, nlh);
> > +
> > +     rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL, GFP_ATOMIC);
> > +     return 0;
> > +
> > +nla_put_failure:
> > +     nlmsg_cancel(skb, nlh);
> > +     kfree_skb(skb);
> > +
> > +errout:
> > +     rtnl_set_sk_err(net, RTNLGRP_LINK, err);
> > +     return err;
> > +}
> > +EXPORT_SYMBOL(br_mrp_port_open);
> >
> 

-- 
/Horatiu

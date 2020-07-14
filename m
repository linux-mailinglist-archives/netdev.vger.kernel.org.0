Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEF621F5D0
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 17:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgGNPHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 11:07:48 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:7943 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbgGNPHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 11:07:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594739267; x=1626275267;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=r4E3DoO/243oOPim9W7seyYjqcxT6G/IVb7gOQ45Lro=;
  b=Unde2c2H4RzcmdcUM7YRZdV4sWorooEnnEm+QKlTwoxd5COaX7NneoYe
   4K3JRmjJw/WLYJ1Ecm1ndYV4UkW2FDkFaqqS1Euty2ZdOKVTYzRcQqR6j
   YKP5rZ9/oRip+bM2npaibp0i4odQo8v8PU6CmfUZdOzhLGXI4Nxw7UBgn
   8mQz6twKxqWebfOoOUIUM36pAlvNWeDR87NQGVHooBin+WhNTSkiZBWeD
   Jrh3feZYk67zjzR8XSvmVHHMLapBfsTz9EM9PNrT1cvaSbSIfm7ItFhfN
   PR8gpEa3c9+FgFT9jnuShsiLokQmd+0YAuqiDGNnhJCglIJ6t1qmkshNw
   Q==;
IronPort-SDR: xDQSwPuhqU7Ybp5HXbBfTw7cq+gRPc6CJJmlk9FcqnzuBAMlCMPHO4oL+j9RO1j+qZonhl9nQj
 ipIqKBX5v7ZnmdwN6YOdaytNUgEhfZPVoyNncEWAd5S+XdxGVDHzN1sIqxuIYYfCyC1/4JX3SC
 6BudxW5pHXORtW29hNKBlT+DLq5GE0J9+bluOqhVuNzsxceWDnKlkYoyNclz1AaNMasSh5gqla
 h2o7ousKExjo3i97YlWwdwkyVbrI+N681OYJSq4zLih25GXhxc/UiT9lhTOTUMINVP4BQNDaM8
 ws4=
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="81800580"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2020 08:07:47 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 14 Jul 2020 08:07:46 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 14 Jul 2020 08:07:14 -0700
Date:   Tue, 14 Jul 2020 17:07:40 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
CC:     <roopa@cumulusnetworks.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <jiri@resnulli.us>, <ivecera@redhat.com>,
        <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next v4 12/12] net: bridge: Add port attribute
 IFLA_BRPORT_MRP_IN_OPEN
Message-ID: <20200714150740.3ji3qhtvikhrizfn@soft-dev3.localdomain>
References: <20200714073458.1939574-1-horatiu.vultur@microchip.com>
 <20200714073458.1939574-13-horatiu.vultur@microchip.com>
 <9eeb89c5-865f-2b21-c7c6-7f4479bf4175@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <9eeb89c5-865f-2b21-c7c6-7f4479bf4175@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 07/14/2020 16:29, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On 14/07/2020 10:34, Horatiu Vultur wrote:
> > This patch adds a new port attribute, IFLA_BRPORT_MRP_IN_OPEN, which
> > allows to notify the userspace when the node lost the contiuity of
> > MRP_InTest frames.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  include/uapi/linux/if_link.h       | 1 +
> >  net/bridge/br_netlink.c            | 3 +++
> >  tools/include/uapi/linux/if_link.h | 1 +
> >  3 files changed, 5 insertions(+)
> >

Hi Nik,

> 
> It's kind of late by now, but I'd wish these were contained in a nested MRP attribute. :)
> Horatiu, do you expect to have many more MRP attributes outside of MRP netlink code?

I don't expect to add any other MRP attributes outside of MRP netlink
code.

> 
> Perhaps we should at least dump them only for MRP-aware ports, that should be easy.
> They make no sense outside of MRP anyway, but increase the size of the dump for all
> right now.

You are right. Then should I first send a fix on the net for this and
after that I will fix these patches or just fix this in the next patch
series?

> 
> Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> 
> > diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> > index cc185a007ade8..26842ffd0501d 100644
> > --- a/include/uapi/linux/if_link.h
> > +++ b/include/uapi/linux/if_link.h
> > @@ -344,6 +344,7 @@ enum {
> >       IFLA_BRPORT_ISOLATED,
> >       IFLA_BRPORT_BACKUP_PORT,
> >       IFLA_BRPORT_MRP_RING_OPEN,
> > +     IFLA_BRPORT_MRP_IN_OPEN,
> >       __IFLA_BRPORT_MAX
> >  };
> >  #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
> > diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> > index c532fa65c9834..147d52596e174 100644
> > --- a/net/bridge/br_netlink.c
> > +++ b/net/bridge/br_netlink.c
> > @@ -152,6 +152,7 @@ static inline size_t br_port_info_size(void)
> >  #endif
> >               + nla_total_size(sizeof(u16))   /* IFLA_BRPORT_GROUP_FWD_MASK */
> >               + nla_total_size(sizeof(u8))    /* IFLA_BRPORT_MRP_RING_OPEN */
> > +             + nla_total_size(sizeof(u8))    /* IFLA_BRPORT_MRP_IN_OPEN */
> >               + 0;
> >  }
> >
> > @@ -216,6 +217,8 @@ static int br_port_fill_attrs(struct sk_buff *skb,
> >                      !!(p->flags & BR_NEIGH_SUPPRESS)) ||
> >           nla_put_u8(skb, IFLA_BRPORT_MRP_RING_OPEN, !!(p->flags &
> >                                                         BR_MRP_LOST_CONT)) ||
> > +         nla_put_u8(skb, IFLA_BRPORT_MRP_IN_OPEN,
> > +                    !!(p->flags & BR_MRP_LOST_IN_CONT)) ||
> >           nla_put_u8(skb, IFLA_BRPORT_ISOLATED, !!(p->flags & BR_ISOLATED)))
> >               return -EMSGSIZE;
> >
> > diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
> > index cafedbbfefbe9..781e482dc499f 100644
> > --- a/tools/include/uapi/linux/if_link.h
> > +++ b/tools/include/uapi/linux/if_link.h
> > @@ -344,6 +344,7 @@ enum {
> >       IFLA_BRPORT_ISOLATED,
> >       IFLA_BRPORT_BACKUP_PORT,
> >       IFLA_BRPORT_MRP_RING_OPEN,
> > +     IFLA_BRPORT_MRP_IN_OPEN,
> >       __IFLA_BRPORT_MAX
> >  };
> >  #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
> >
> 

-- 
/Horatiu

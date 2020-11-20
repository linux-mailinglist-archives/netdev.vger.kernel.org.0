Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157662BB652
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 21:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbgKTUOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 15:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728360AbgKTUOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 15:14:42 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9CDC0613CF;
        Fri, 20 Nov 2020 12:14:42 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id k26so11846323oiw.0;
        Fri, 20 Nov 2020 12:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=59eXPq4HCfABXYJ19/5fTiyQpTH2/agQQ+DqMrLIzNw=;
        b=rt456jnne/Fo+Ei4a0FzL6u41Nva2fLcKPumaDM/v3wao7gaULNPtAtDhPm4j89tJ4
         Vjme829sueFpVn4XJ/1AiMOYTwh3xVxkL8kX6/ucNafC4ueeOisXPiNPH3kxSX04i3Fu
         qu6rSem7kIvFxjnjYzHUvG3/T+kiQKCyGdvFMmmb+YgAGO9xhzCC44dCaEY1+tMdD2b1
         wMgzxJo+baPo5Dov+o5k8C40+sXRRhkh2AdRkuMoTD4IR+lJWflWmbwyyOZ60rT1DQTl
         rtPhWdjX5e5deBdMVwL7NJKeLVmFMbXHiVMckFGHq6FM7yPIegz+paKRx2ru5Xroez+5
         6a0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=59eXPq4HCfABXYJ19/5fTiyQpTH2/agQQ+DqMrLIzNw=;
        b=jVHoq7SV+eISmEvKXRnN1UdWjLxmrwZELE2Sd1w+h1JDVeBHfhXyv7ypk8w8Df8gMZ
         2zrrMrgh2XnJNkeLQNwmzlFQrdLa8lfMuip7VRrWRKSrCmTtoqJgY9tnlccH/tPK2wJG
         JYz7Fs4KACycx/skpNJpIpPcZ2HF7PGuvBKIbJEpCWi6+bK/EH2Pxhb4D5yGLvHupf6W
         fSC0aNh9j5LhoazYEWP5qt7Fm4UY21IxgR97PCCHTZ9cjg2m+SL4XStAzK/4+HyoUK0p
         ZbaBCvZuP4a2S36XI3DUUfLFwoY89gYd3XbPwZGBSXB0zxkBicuCFvkPaxB5SZOjLyNj
         Vxew==
X-Gm-Message-State: AOAM530SJmFSLI0+R054wYmbXWOK6G1N993Cdg8qewACJCjvHe79GdJC
        D6YvD2YjbeL+oO8vX9JjGw/n6/Wa8D3J0ubkpg==
X-Google-Smtp-Source: ABdhPJzaYosWnxQG4b/bVNa7++EvAY8gYP6ZTXKnYFItyQykZ6rTEp0mBSv/SLQg0qARRHSIR5zS+r9EALMssiE7c4k=
X-Received: by 2002:aca:c506:: with SMTP id v6mr1796936oif.122.1605903281383;
 Fri, 20 Nov 2020 12:14:41 -0800 (PST)
MIME-Version: 1.0
References: <20201120181627.21382-1-george.mccollister@gmail.com>
 <20201120181627.21382-2-george.mccollister@gmail.com> <20201120185853.GO1853236@lunn.ch>
In-Reply-To: <20201120185853.GO1853236@lunn.ch>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Fri, 20 Nov 2020 14:14:29 -0600
Message-ID: <CAFSKS=PW1Cjm3-7mTWnniy5uUpLcPd9vkqUAh37r-pcA0RU3nA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] dsa: add support for Arrow XRS700x tag trailer
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 12:58 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Fri, Nov 20, 2020 at 12:16:25PM -0600, George McCollister wrote:
> > Add support for Arrow SpeedChips XRS700x single byte tag trailer. This
> > is modeled on tag_trailer.c which works in a similar way.
> >
> > Signed-off-by: George McCollister <george.mccollister@gmail.com>
> > ---
> >  include/net/dsa.h     |  2 ++
> >  net/dsa/Kconfig       |  6 ++++
> >  net/dsa/Makefile      |  1 +
> >  net/dsa/tag_xrs700x.c | 91 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 100 insertions(+)
> >  create mode 100644 net/dsa/tag_xrs700x.c
> >
> > diff --git a/include/net/dsa.h b/include/net/dsa.h
> > index 2e64e8de4631..eb46ecdcf165 100644
> > --- a/include/net/dsa.h
> > +++ b/include/net/dsa.h
> > @@ -46,6 +46,7 @@ struct phylink_link_state;
> >  #define DSA_TAG_PROTO_AR9331_VALUE           16
> >  #define DSA_TAG_PROTO_RTL4_A_VALUE           17
> >  #define DSA_TAG_PROTO_HELLCREEK_VALUE                18
> > +#define DSA_TAG_PROTO_XRS700X_VALUE          19
> >
> >  enum dsa_tag_protocol {
> >       DSA_TAG_PROTO_NONE              = DSA_TAG_PROTO_NONE_VALUE,
> > @@ -67,6 +68,7 @@ enum dsa_tag_protocol {
> >       DSA_TAG_PROTO_AR9331            = DSA_TAG_PROTO_AR9331_VALUE,
> >       DSA_TAG_PROTO_RTL4_A            = DSA_TAG_PROTO_RTL4_A_VALUE,
> >       DSA_TAG_PROTO_HELLCREEK         = DSA_TAG_PROTO_HELLCREEK_VALUE,
> > +     DSA_TAG_PROTO_XRS700X           = DSA_TAG_PROTO_XRS700X_VALUE,
> >  };
> >
> >  struct packet_type;
> > diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> > index dfecd7b22fd7..2d226a5c085f 100644
> > --- a/net/dsa/Kconfig
> > +++ b/net/dsa/Kconfig
> > @@ -139,4 +139,10 @@ config NET_DSA_TAG_TRAILER
> >         Say Y or M if you want to enable support for tagging frames at
> >         with a trailed. e.g. Marvell 88E6060.
> >
> > +config NET_DSA_TAG_XRS700X
> > +     tristate "Tag driver for XRS700x switches"
> > +     help
> > +       Say Y or M if you want to enable support for tagging frames for
> > +       Arrow SpeedChips XRS700x switches that use a single byte tag trailer.
> > +
> >  endif
> > diff --git a/net/dsa/Makefile b/net/dsa/Makefile
> > index 0fb2b75a7ae3..92cea2132241 100644
> > --- a/net/dsa/Makefile
> > +++ b/net/dsa/Makefile
> > @@ -18,3 +18,4 @@ obj-$(CONFIG_NET_DSA_TAG_OCELOT) += tag_ocelot.o
> >  obj-$(CONFIG_NET_DSA_TAG_QCA) += tag_qca.o
> >  obj-$(CONFIG_NET_DSA_TAG_SJA1105) += tag_sja1105.o
> >  obj-$(CONFIG_NET_DSA_TAG_TRAILER) += tag_trailer.o
> > +obj-$(CONFIG_NET_DSA_TAG_XRS700X) += tag_xrs700x.o
> > diff --git a/net/dsa/tag_xrs700x.c b/net/dsa/tag_xrs700x.c
> > new file mode 100644
> > index 000000000000..2eda57a4a474
> > --- /dev/null
> > +++ b/net/dsa/tag_xrs700x.c
> > @@ -0,0 +1,91 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +/*
> > + * XRS700x tag format handling
> > + * Copyright (c) 2008-2009 Marvell Semiconductor
> > + * Copyright (c) 2020 NovaTech LLC
> > + */
> > +
> > +#include <linux/etherdevice.h>
> > +#include <linux/list.h>
> > +#include <linux/slab.h>
> > +#include <linux/bitops.h>
> > +
> > +#include "dsa_priv.h"
> > +
> > +static struct sk_buff *xrs700x_xmit(struct sk_buff *skb, struct net_device *dev)
> > +{
> > +     struct dsa_port *dp = dsa_slave_to_port(dev);
> > +     struct sk_buff *nskb;
> > +     int padlen;
> > +     u8 *trailer;
> > +
> > +     /* We have to make sure that the trailer ends up as the very
> > +      * last byte of the packet.  This means that we have to pad
> > +      * the packet to the minimum ethernet frame size, if necessary,
> > +      * before adding the trailer.
> > +      */
> > +     padlen = 0;
> > +     if (skb->len < 63)
> > +             padlen = 63 - skb->len;
> > +
> > +     nskb = alloc_skb(NET_IP_ALIGN + skb->len + padlen + 1, GFP_ATOMIC);
> > +     if (!nskb)
> > +             return NULL;
> > +     skb_reserve(nskb, NET_IP_ALIGN);
>
> Hi George
>
> This needs updating to take into account:
>
> commit a3b0b6479700a5b0af2c631cb2ec0fb7a0d978f2
> Author: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date:   Sun Nov 1 21:16:09 2020 +0200
>
>     net: dsa: implement a central TX reallocation procedure
>
> which i think will handle the padding for you.

Done and tested. Thanks

>
>       Andrew

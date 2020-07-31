Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF402348DB
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 18:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbgGaQDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 12:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728227AbgGaQDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 12:03:05 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B91C061574;
        Fri, 31 Jul 2020 09:03:05 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mt12so7643854pjb.4;
        Fri, 31 Jul 2020 09:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iYvGYTkdQgoVTh/dtVt2dvyzxryEKrw2EXoP7UGiVxk=;
        b=nOax9z++BMJIjjgIJINW9jTGuDEAQNZsS5GMlcdXqwg6jVlmB01Zzj84pVjhDeqaIw
         wLsE98143QeDLquFDkNNBj8kyQg/kug2sBhOPTwcXjJVhajn5RskcHkGBWJ3zOR7rYXZ
         sautvUR3RDJQlP3fNIGlMAPhvGK4n0dNXzZYk272nXjpYITLlhkp3TnMSSDayUysG0Oc
         xkass4Q+hIEQeif3uNqKu3vPnuOyPYiVyU8ePU15GRRNjQCUAHqreC2Lts3tHMLdqiah
         eaJfrVxBFPG0uoorKHNbKXORtokNQYIyXFhGdqPpqvddbzfCC5T+ZE47mUiRy0ijXgWP
         /O5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iYvGYTkdQgoVTh/dtVt2dvyzxryEKrw2EXoP7UGiVxk=;
        b=LjnRVbGTwpLYPDP+4BnlkiuBQGpsPwz2poZ0sGwF3AAF7MWH19Ob4sQz1vLtkkFote
         VbKBVNH1le0pIrbFypUsuPgBAoHncJR3yDNtbnBeOCV6EuRnJ2vA7YN1nH/ueQaJVBIc
         98trAGd3PxYM49jfwwxegHSOpL7Cw98c00fCvSWlUOGCZTEuPlqFGoCwYG0YnLngIxsb
         SSkMq02LgUVAKdFGnMn65js/wt+fre5ctIwS+80F8RXMlOtWLtwkg4Nw5DZTNu0gVHpD
         1c08DYisgjlRGnshX7zTVdOCxai6GREuE/Gqn2GnDhq6cjPmINAuPGjbKn+jNOl8Z/VW
         ej8g==
X-Gm-Message-State: AOAM533qqmtsTx4i9t6HztmfGtdBTu9vxr0/VahgQLQ/2dY/YmaEvm75
        pQIkbGkDoifzO9O8QC9vF9H6IZQQKKmWXr/ohSU=
X-Google-Smtp-Source: ABdhPJzZaNwaUAO4vP2YkFvg0hEjBxU8yJCZOGD1ok8Y50UEr23X0ROaPprgVfD+9v77va7XSyopab0N+G7y6EikuDc=
X-Received: by 2002:a17:90a:390f:: with SMTP id y15mr4619690pjb.181.1596211385078;
 Fri, 31 Jul 2020 09:03:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200727122242.32337-1-vadym.kochan@plvision.eu>
 <20200727122242.32337-2-vadym.kochan@plvision.eu> <CAHp75Ve-MyFg5QqHjywGk6X+v_F77HkRBuQsJ0Cx3WLJ5ZV43w@mail.gmail.com>
 <20200731152201.GB10391@plvision.eu>
In-Reply-To: <20200731152201.GB10391@plvision.eu>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 31 Jul 2020 19:02:47 +0300
Message-ID: <CAHp75VcS4fEak3z0exODErs5FbDwf+Di1RJmf7JfMgnD8xgXOA@mail.gmail.com>
Subject: Re: [net-next v4 1/6] net: marvell: prestera: Add driver for Prestera
 family ASIC devices
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 6:22 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
> On Mon, Jul 27, 2020 at 03:59:13PM +0300, Andy Shevchenko wrote:
> > On Mon, Jul 27, 2020 at 3:23 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:

...

> > > Signed-off-by: Andrii Savka <andrii.savka@plvision.eu>
> > > Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> > > Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
> > > Signed-off-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
> > > Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
> > > Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
> > > Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> >
> > This needs more work. You have to really understand the role of each
> > person in the above list.
> > I highly recommend (re-)read sections 11-13 of Submitting Patches.
> >
> At least looks like I need to add these persons as Co-author's.

I don't know, you are!
And I think you meant Co-developer's

...

> > > +#include <linux/string.h>
> > > +#include <linux/bitops.h>
> > > +#include <linux/bitfield.h>
> > > +#include <linux/errno.h>
> >
> > Perhaps ordered?
> >
> alphabetical ?

Yes.

...

> > > +       struct prestera_msg_event_port *hw_evt;
> > > +
> > > +       hw_evt = (struct prestera_msg_event_port *)msg;
> >
> > Can be one line I suppose.
> >
> Yes, but I am trying to avoid line-breaking because of 80 chars
> limitation.

We have 100, but okay.

...

> > > +       if (evt->id == PRESTERA_PORT_EVENT_STATE_CHANGED)
> > > +               evt->port_evt.data.oper_state = hw_evt->param.oper_state;
> > > +       else
> > > +               return -EINVAL;
> > > +
> > > +       return 0;
> >
> > Perhaps traditional pattern, i.e.
> >
> >   if (...)
> >     return -EINVAL;
> >   ...
> >   return 0;
> >
> I am not sure if it is applicable here, because the error state here
> is if 'evt->id' did not matched after all checks. Actually this is
> simply a 'switch', but I use 'if' to have shorter code.

Then do it a switch-case. I can see that other reviewers/contributors
may stumble over this.

...

> > > +       /* Only 0xFF mac addrs are supported */
> > > +       if (port->fp_id >= 0xFF)
> > > +               goto err_port_init;
> >
> > You meant 255, right?
> > Otherwise you have to mentioned is it byte limitation or what?
> >
> > ...
> Yes, 255 is a limitation because of max byte value.

But 255 itself is some kind of error value? Perhaps it deserves a definition.

...

> > > +       np = of_find_compatible_node(NULL, NULL, "marvell,prestera");
> > > +       if (np) {
> > > +               base_mac_np = of_parse_phandle(np, "base-mac-provider", 0);
> > > +               if (base_mac_np) {
> > > +                       const char *base_mac;
> > > +
> > > +                       base_mac = of_get_mac_address(base_mac_np);
> > > +                       of_node_put(base_mac_np);
> > > +                       if (!IS_ERR(base_mac))
> > > +                               ether_addr_copy(sw->base_mac, base_mac);
> > > +               }
> > > +       }
> > > +
> > > +       if (!is_valid_ether_addr(sw->base_mac)) {
> > > +               eth_random_addr(sw->base_mac);
> > > +               dev_info(sw->dev->dev, "using random base mac address\n");
> > > +       }
> >
> > Isn't it device_get_mac_address() reimplementation?
> >
> device_get_mac_address() just tries to get mac via fwnode.

Yes, and how is it different from here? (consider
fwnode_get_mac_address() if it suits better).

...

> > > +       new_skb = alloc_skb(len, GFP_ATOMIC | GFP_DMA);
> >
> > Atomic? Why?
> >
> TX path might be called from net_tx_action which is softirq.

Okay, but GFP_DMA is quite a limitation to the memory region. Can't  be 32-bit?

...

> > > +       int tx_retry_num = 10 * tx_ring->max_burst;
> >
> > Magic!
> You mean the code is magic ? Yes, I am trying to relax the
> calling of SDMA engine.

Usually when reviewers tell you about magic it assumes magic numbers
whose meaning is not clear.
(Requires either to be defined or commented)

-- 
With Best Regards,
Andy Shevchenko

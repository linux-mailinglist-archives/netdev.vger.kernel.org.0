Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C9231460D
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 03:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhBICGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 21:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbhBICGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 21:06:51 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27A4C061786
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 18:06:10 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id a22so4631706ljp.10
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 18:06:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nfXd2mulWBs1LljfvvnW5kYLVafMCXcQ5E6FUoFwv4A=;
        b=pTY5szFS18Zm4S8wAuqUNZCahymj7ICHGNNynvuAvCkBCatKuV15Y9jRBcQCHGKAIQ
         78w595Rm0faRyQoEHuM6gXfjOO5uGqjeU2ycWX+tk2fnXMvW+3u2j009KqTU89qLYLhA
         iJGsu0HoGZxMmjKRh9iPKfRb0rj367TLzK3kpAesTKnBZGt+98QyT1pUjr8+uh4jXrUi
         hbvdw0532O+glo1OMVE2t4QVk8ZpSczmLnPaGUQN2yKdo4zOP+Bi0/8E3LCgt5gLGWvT
         SChHi68dBy8HTEwN7WzMIks4kw8HXB1PDNHu9BhL+T+wFQvguQgEPMMS23x0CcsTzdQ9
         FLhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nfXd2mulWBs1LljfvvnW5kYLVafMCXcQ5E6FUoFwv4A=;
        b=OaD7TLIlyiGa+2Pf/YN/O6Zpkoane6bjAb29faRnVZWyX9NsZpLepkuY5bWZ6HSFbr
         GRy1QbCNLVNe/DxfUQocfavngqk6a5xYMdNdGMGf5RYuWDntD5++smsDcJMwjyR6VRux
         CrpMMKHPqv0UXMdLVXSy9QYkXsQ/ROrpLDryWpYQuxLgQ5/nYFkNNIQ1BuSXsMG7sVTz
         xULFHm6Ch0S5dVkDvwbfoA/PmplKwO5qd/wUWwQYQMzOtn55YBKmpEjZ/btcVRnphCkw
         0KXvp6iADmYxroImGVUMCRlhYaparlVKkB7g+qgsQPpVY1PLHZ7cu119pyBN40GeICf1
         CJRg==
X-Gm-Message-State: AOAM532DIe6UV83tP6saGr4e0VMKY2hIIuFUq6zh+szdMgJaPvpuQpK8
        WHVdIXqvwMt+c3tcwMK9X6KiZ6UXqIZWl1RBQMRqjyltXwM=
X-Google-Smtp-Source: ABdhPJxdHF/AuUvN8VZPkIn1OfvCIKsMaaxSuYJLgKjB/RsaEnhFhbGUh2NSg8sJNciJkM50U6BlUSb/lOARSHr477M=
X-Received: by 2002:a2e:b803:: with SMTP id u3mr5698994ljo.481.1612836369237;
 Mon, 08 Feb 2021 18:06:09 -0800 (PST)
MIME-Version: 1.0
References: <20210208175820.5690-1-ap420073@gmail.com> <8633a76b-84c1-44c1-f532-ce66c1502b5c@gmail.com>
In-Reply-To: <8633a76b-84c1-44c1-f532-ce66c1502b5c@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Tue, 9 Feb 2021 11:05:58 +0900
Message-ID: <CAMArcTVdhDZ-4yETx1mGnULfKU5uGdAKsLbXKSBi-ZmVMHbvfQ@mail.gmail.com>
Subject: Re: [PATCH net-next 7/8] mld: convert ip6_sf_socklist to list macros
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>, dsahern@kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Feb 2021 at 03:31, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>

Hi Eric,
Thank you for the review!

>
>
> On 2/8/21 6:58 PM, Taehee Yoo wrote:
> > Currently, struct ip6_sf_socklist doesn't use list API so that code
> > shape is a little bit different from others.
> > So it converts ip6_sf_socklist to use list API so it would
> > improve readability.
> >
> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> > ---
> >  include/net/if_inet6.h  |  19 +-
> >  include/uapi/linux/in.h |   4 +-
> >  net/ipv6/mcast.c        | 387 +++++++++++++++++++++++++---------------
> >  3 files changed, 256 insertions(+), 154 deletions(-)
> >
> > diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
> > index babf19c27b29..6885ab8ec2e9 100644
> > --- a/include/net/if_inet6.h
> > +++ b/include/net/if_inet6.h
> > @@ -13,6 +13,7 @@
> >  #include <net/snmp.h>
> >  #include <linux/ipv6.h>
> >  #include <linux/refcount.h>
> > +#include <linux/types.h>
> >
> >  /* inet6_dev.if_flags */
> >
> > @@ -76,23 +77,19 @@ struct inet6_ifaddr {
> >  };
> >
> >  struct ip6_sf_socklist {
> > -     unsigned int            sl_max;
> > -     unsigned int            sl_count;
> > -     struct in6_addr         sl_addr[];
> > +     struct list_head        list;
> > +     struct in6_addr         sl_addr;
> > +     struct rcu_head         rcu;
> >  };
> >
>
> I dunno about readability, but :
>
> Your patches adds/delete more than 1000 lines, who is really going to review this ?
>

Sorry for that, I think I was so hasty.

> You replace dense arrays by lists, so the performance will likely be hurt,
> as cpu caches will be poorly used.
>

Thanks, I understand why the arrays have been using.
I will send a v2 patch, which contains only the necessary changes.

Thanks a lot,
Taehee Yoo

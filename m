Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A32314C6B
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 11:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbhBIKDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 05:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbhBIKBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 05:01:25 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB28BC06178B
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 02:00:44 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id h26so1128830lfm.1
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 02:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uphZOEKoQUN5nIPEigaxViL9Cf8/hVG3zAzeLPZ76J4=;
        b=EB7fQv+qnEvWhnWgWLmaZ7xqHmCzX+TPNsNeoPMkZY8IoDRkXb3SwWeoayMV84Ssi1
         lU6LItH+g0pl1SLVMLdq/Rkb+YdO10qF+Vv2vfs9dFPFJbNc+MePYP2AVIeD23aVXfx4
         gcRlXUn3SQq2zSb0XShbsVjPC3d5BdsI/X12TlJT/N/cJPNoYDhrQ2MVo061h4ZTOPUq
         eDXs83kM02sOfBUxfv0oRuTMcKEIHnb4txZTDaY4TI+Q9ZLyz0alFxHOlBknYbDuEU+m
         gc48V0H+QslZRBZQl/YchCUPp5KnGEQpA/J18c+zwR7lzlpJeXB1kzh2Tj52zlyMGAb+
         dYqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uphZOEKoQUN5nIPEigaxViL9Cf8/hVG3zAzeLPZ76J4=;
        b=KNug9HikDxYsxp0I3+XmprX3lbrFALzYlmg3HDYJN/2YNGBRcu/Rd6Nhdc+lWM4ieH
         SLqDDyNsNMyLu4kVTQe2byM+lCtIiFB416NOm8l0FxDvAu1WBsk+NWmArQYJgvbhL2Yv
         t/NwRcozEHX3SAomDdjfuxfXrvWkkafw7e5wejYCcZb3y5DrvvBGjIDUJX3Y6U/Oj5MX
         UyXm50imXFjqm8JEJf4srDLMIZHjTIGViHj5KaXlyJIWJvheiIJbaEVyffl63z3OFIQj
         g0rkHqphQ12HlmFJ7zWhtF1S15s/t2eCjJHHtzCsGh05OyJkh1U7hWhUASa7BBQCFtWy
         MTyA==
X-Gm-Message-State: AOAM531ZK+69T73iq+m2Vf3Xi6ay/LipvHBQ0W1uEpi+C4WSjbXF3Npw
        cQN/ry7444nIW0mkt20FK6j1aZWahM9aremfH8U=
X-Google-Smtp-Source: ABdhPJxGNhYodpJ8m4h91aAaQ0bs9mxb8pUDYwkvDeOyKaUPYwIu9VqzEHe9ReAktvzPrT1xU49v5kGd4kuNieBoLtU=
X-Received: by 2002:ac2:5f04:: with SMTP id 4mr12632595lfq.357.1612864843412;
 Tue, 09 Feb 2021 02:00:43 -0800 (PST)
MIME-Version: 1.0
References: <20210208175952.5880-1-ap420073@gmail.com> <ed1965e9-f35b-ec9b-f3ae-20a7adba956d@linux.ibm.com>
In-Reply-To: <ed1965e9-f35b-ec9b-f3ae-20a7adba956d@linux.ibm.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Tue, 9 Feb 2021 19:00:31 +0900
Message-ID: <CAMArcTVZ1+iTxaxdMtUbz3VRdeUXLJBvzS+REmucR-eDC_5cZw@mail.gmail.com>
Subject: Re: [PATCH net-next 8/8] mld: change context of mld module
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>, dsahern@kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        Sven Eckelmann <sven@narfation.org>, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Feb 2021 at 17:26, Julian Wiedmann <jwi@linux.ibm.com> wrote:
>

Hi Julian,
Thank you for the review!

> On 08.02.21 18:59, Taehee Yoo wrote:
> > MLD module's context is atomic although most logic is called from
> > control-path, not data path. Only a few functions are called from
> > datapath, most of the functions are called from the control-path.
> > Furthermore, MLD's response is not processed immediately because
> > MLD protocol is using delayed response.
> > It means that If a query is received, the node should have a delay
> > in response At this point, it could change the context.
> > It means most of the functions can be implemented as the sleepable
> > context so that mld functions can use sleepable functions.
> >
> > Most resources are protected by spinlock and rwlock so the context
> > of mld functions is atomic. So, in order to change context, locking
> > scenario should be changed.
> > It switches from spinlock/rwlock to mutex and rcu.
> >
> > Some locks are deleted and added.
> > 1. ipv6->mc_socklist->sflock is deleted
> > This is rwlock and it is unnecessary.
> > Because it protects ipv6_mc_socklist-sflist but it is now protected
> > by rtnl_lock().
> >
> > 2. ifmcaddr6->mca_work_lock is added.
> > This lock protects ifmcaddr6->mca_work.
> > This workqueue can be used by both control-path and data-path.
> > It means mutex can't be used.
> > So mca_work_lock(spinlock) is added.
> >
> > 3. inet6_dev->mc_tomb_lock is deleted
> > This lock protects inet6_dev->mc_bom_list.
> > But it is protected by rtnl_lock().
> >
> > 4. inet6_dev->lock is used for protecting workqueues.
> > inet6_dev has its own workqueues(mc_gq_work, mc_ifc_work, mc_delrec_work)
> > and it can be started and stop by both control-path and data-path.
> > So, mutex can't be used.
> >
> > Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> > ---
> >  drivers/s390/net/qeth_l3_main.c |   6 +-
> >  include/net/if_inet6.h          |  29 +-
> >  net/batman-adv/multicast.c      |   4 +-
> >  net/ipv6/addrconf.c             |   4 +-
> >  net/ipv6/mcast.c                | 785 ++++++++++++++++----------------
> >  5 files changed, 411 insertions(+), 417 deletions(-)
> >
> > diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
> > index e49abdeff69c..085afb24482e 100644
> > --- a/drivers/s390/net/qeth_l3_main.c
> > +++ b/drivers/s390/net/qeth_l3_main.c
> > @@ -1098,8 +1098,8 @@ static int qeth_l3_add_mcast_rtnl(struct net_device *dev, int vid, void *arg)
> >       tmp.disp_flag = QETH_DISP_ADDR_ADD;
> >       tmp.is_multicast = 1;
> >
> > -     read_lock_bh(&in6_dev->lock);
> > -     list_for_each_entry(im6, in6_dev->mc_list, list) {
> > +     rcu_read_lock();
> > +     list_for_each_entry_rcu(im6, in6_dev->mc_list, list) {
>
> No need for the rcu_read_lock(), we're called under rtnl.
> So if there's a v2, please just make this
>

Thanks! I missed checking for the RTNL :)

In the next patch, mc_list will not be changed to use list macro.
So I will just remove read_{lock | unlock}_bh() in here.

>         list_for_each_entry_rcu(im6, in6_dev->mc_list, list,
>                                 lockdep_rtnl_is_held())
>
> >               tmp.u.a6.addr = im6->mca_addr;
> >
> >               ipm = qeth_l3_find_addr_by_ip(card, &tmp);
> > @@ -1117,7 +1117,7 @@ static int qeth_l3_add_mcast_rtnl(struct net_device *dev, int vid, void *arg)
> >                        qeth_l3_ipaddr_hash(ipm));
> >
> >       }
> > -     read_unlock_bh(&in6_dev->lock);
> > +     rcu_read_unlock();
> >
> >  out:
> >       return 0;
>

Thanks a lot!
Taehee Yoo

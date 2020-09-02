Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C01425B0AB
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 18:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbgIBQGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 12:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgIBQGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 12:06:11 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8161C061244;
        Wed,  2 Sep 2020 09:06:10 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id z9so5118409wmk.1;
        Wed, 02 Sep 2020 09:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0O4dQf9ijqc3DJHTRqGfgFX/txsOCHtKdPYLLD83pqA=;
        b=hviSWVzBIYj8FNGXfXWECTBNPGc00bdNjjr2aNz5Ks38vUJmN1Xf2Ktai2CSbcmP2S
         VvVfkEJVTeeT8V5676PV1cEYtiupuQd2cmCPoDWsb8O45qWpgYCDj5hmBmTUf+yaYQj2
         ho0JukZbw5l6AthWRtrRgKEaUdei8Yvv8JGta1uPTbu0y4mNdP58YOjK0zHReNBkYfUw
         cyHjeulLy9QARdE0qADfPB4+xI7aklJAj5ZTPNJWR9gvncijU+56BV9RF7pOkf4q1h+x
         N9xBb3+Y5ci4a1WR9dBxtbUOf37eGOdWZXhCXrFZjHssMLzFh6A1MoB+6BxbazbPY/bB
         CjGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0O4dQf9ijqc3DJHTRqGfgFX/txsOCHtKdPYLLD83pqA=;
        b=O0uVaBHiNzTi1y0+w/GxKZvLY5RbBWGG6MxloAis5Nty0NPSKdvoCT1B+MXCReBj+9
         ncmNeICb4rgqEHkhjoKPUmXZhw+E6aNNY9jfWJyXEFtl9/ApUCKEEhyDNjILgKh3q3/0
         ZAw+L6G4sm4ee5aYr/+WflFa+K9PFq8h6uEI0dxePwHqVFaCbe6w+Q0H4QCPuTVmbSC/
         APuutOUZmi4ItZlPKi9vUeTit8XHZFyGBup1Fb28LYRxvTq9oQLObmGJaQVK/PtW6Flj
         JF9J2Od5Vd9N14jEFTt9lkZkPCMmub7+/mHcLMCCN0CeqDSUHZhhQByF9ixYrPkCX/7e
         Rsgg==
X-Gm-Message-State: AOAM53171q7ZybyUnqTg7XG7Zg6/qzXmYFF4ORsdukJ7ztydx8ghUmWI
        kFOKkwATvQuDGGRIj+QLZ2h8c/3yaijD3GG6KIY=
X-Google-Smtp-Source: ABdhPJxdfC3mgIvbt6wua8mzM+KmTyM8048m+AYjGnIYLBeF9SqkT0az/f0O5TPKGpss8BXufe9V77wBncKPW7hIYZ4=
X-Received: by 2002:a1c:f605:: with SMTP id w5mr1358007wmc.26.1599062769544;
 Wed, 02 Sep 2020 09:06:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200707171515.110818-1-izabela.bakollari@gmail.com>
 <20200804160908.46193-1-izabela.bakollari@gmail.com> <e971a990-4c92-9d64-8bc6-61516d874370@redhat.com>
In-Reply-To: <e971a990-4c92-9d64-8bc6-61516d874370@redhat.com>
From:   Izabela Bakollari <izabela.bakollari@gmail.com>
Date:   Wed, 2 Sep 2020 18:05:58 +0200
Message-ID: <CAC8tkWD03qhxqB2G06f4e_-xiuXBYc4GsrKftx30MnUuFtNnJg@mail.gmail.com>
Subject: Re: [PATCHv2 net-next] dropwatch: Support monitoring of dropped frames
To:     Michal Schmidt <mschmidt@redhat.com>
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for your review. I am working on a patch v3 and will apply
your suggestions where possible.

Best,
Izabela

On Mon, Aug 31, 2020 at 3:18 PM Michal Schmidt <mschmidt@redhat.com> wrote:
>
> Dne 04. 08. 20 v 18:09 izabela.bakollari@gmail.com napsala:
> > From: Izabela Bakollari <izabela.bakollari@gmail.com>
> >
> > Dropwatch is a utility that monitors dropped frames by having userspace
> > record them over the dropwatch protocol over a file. This augument
> > allows live monitoring of dropped frames using tools like tcpdump.
> >
> > With this feature, dropwatch allows two additional commands (start and
> > stop interface) which allows the assignment of a net_device to the
> > dropwatch protocol. When assinged, dropwatch will clone dropped frames,
> > and receive them on the assigned interface, allowing tools like tcpdump
> > to monitor for them.
> >
> > With this feature, create a dummy ethernet interface (ip link add dev
> > dummy0 type dummy), assign it to the dropwatch kernel subsystem, by using
> > these new commands, and then monitor dropped frames in real time by
> > running tcpdump -i dummy0.
> >
> > Signed-off-by: Izabela Bakollari <izabela.bakollari@gmail.com>
> > ---
> > Changes in v2:
> > - protect the dummy ethernet interface from being changed by another
> > thread/cpu
> > ---
> >   include/uapi/linux/net_dropmon.h |  3 ++
> >   net/core/drop_monitor.c          | 84 ++++++++++++++++++++++++++++++++
> >   2 files changed, 87 insertions(+)
> [...]
> > @@ -255,6 +259,21 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
> >
> >   out:
> >       spin_unlock_irqrestore(&data->lock, flags);
> > +     spin_lock_irqsave(&interface_lock, flags);
> > +     if (interface && interface != skb->dev) {
> > +             skb = skb_clone(skb, GFP_ATOMIC);
>
> I suggest naming the cloned skb "nskb". Less potential for confusion
> that way.
>
> > +             if (skb) {
> > +                     skb->dev = interface;
> > +                     spin_unlock_irqrestore(&interface_lock, flags);
> > +                     netif_receive_skb(skb);
> > +             } else {
> > +                     spin_unlock_irqrestore(&interface_lock, flags);
> > +                     pr_err("dropwatch: Not enough memory to clone dropped skb\n");
>
> Maybe avoid logging the error here. In NET_DM_ALERT_MODE_PACKET mode,
> drop monitor does not log about the skb_clone() failure either.
> We don't want to open the possibility to flood the logs in case this
> somehow gets triggered by every packet.
>
> A coding style suggestion - can you rearrange it so that the error path
> code is spelled out first? Then the regular path does not have to be
> indented further:
>
>        nskb = skb_clone(skb, GFP_ATOMIC);
>        if (!nskb) {
>                spin_unlock_irqrestore(&interface_lock, flags);
>                return;
>        }
>
>        /* ... implicit else ... Proceed normally ... */
>
> > +                     return;
> > +             }
> > +     } else {
> > +             spin_unlock_irqrestore(&interface_lock, flags);
> > +     }
> >   }
> >
> >   static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb, void *location)
> > @@ -1315,6 +1334,53 @@ static int net_dm_cmd_trace(struct sk_buff *skb,
> >       return -EOPNOTSUPP;
> >   }
> >
> > +static int net_dm_interface_start(struct net *net, const char *ifname)
> > +{
> > +     struct net_device *nd = dev_get_by_name(net, ifname);
> > +
> > +     if (nd)
> > +             interface = nd;
> > +     else
> > +             return -ENODEV;
> > +
> > +     return 0;
>
> Similarly here, consider:
>
>    if (!nd)
>            return -ENODEV;
>
>    interface = nd;
>    return 0;
>
> But maybe I'm nitpicking ...
>
> > +}
> > +
> > +static int net_dm_interface_stop(struct net *net, const char *ifname)
> > +{
> > +     dev_put(interface);
> > +     interface = NULL;
> > +
> > +     return 0;
> > +}
> > +
> > +static int net_dm_cmd_ifc_trace(struct sk_buff *skb, struct genl_info *info)
> > +{
> > +     struct net *net = sock_net(skb->sk);
> > +     char ifname[IFNAMSIZ];
> > +
> > +     if (net_dm_is_monitoring())
> > +             return -EBUSY;
> > +
> > +     memset(ifname, 0, IFNAMSIZ);
> > +     nla_strlcpy(ifname, info->attrs[NET_DM_ATTR_IFNAME], IFNAMSIZ - 1);
> > +
> > +     switch (info->genlhdr->cmd) {
> > +     case NET_DM_CMD_START_IFC:
> > +             if (!interface)
> > +                     return net_dm_interface_start(net, ifname);
> > +             else
> > +                     return -EBUSY;
> > +     case NET_DM_CMD_STOP_IFC:
> > +             if (interface)
> > +                     return net_dm_interface_stop(net, interface->name);
> > +             else
> > +                     return -ENODEV;
>
> ... and here too.
>
> Best regards,
> Michal
>

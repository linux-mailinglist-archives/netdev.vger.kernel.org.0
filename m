Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9DC2189CE
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 16:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729634AbgGHOG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 10:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729493AbgGHOG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 10:06:58 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA15C061A0B;
        Wed,  8 Jul 2020 07:06:58 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id o11so49199748wrv.9;
        Wed, 08 Jul 2020 07:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c0RpjaCUMUz6o0HkW/J+nFuyyVve1i61JY9VJVht368=;
        b=lqW4PIqWfQiWwKnz+W2eTaeQPRyW1yJbvTZi9pJ0M3CEC6b8DhDd4ue1MyrIy0Cs/l
         MnGklkRXGkKz3LU3+Cv662jtLDcfKROCrMFS4F+UFBwEUzjYKt7IMK+CUZeC08C0KVp6
         H2MXZR8CwFQPSRealaknGKIQKxnO//Ttu3XlaZfrnE8bWa2/UkzBrkVz5Ado1JA1zn9p
         0vLwaRWf0PaKnZ7eOjmwcTa/rIrydyFJQpJ1JuMCU/etujF87ccZzRLYmv5SFRwFTX/t
         QaIbmsuy5Y+ixWPx3kY6JozgDWVxuvhEzJr/5ifzIadgu4ssoZmrerZ5N+fuWiJJeCyp
         gPeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c0RpjaCUMUz6o0HkW/J+nFuyyVve1i61JY9VJVht368=;
        b=mLU08oI6zFUpfzs0X42roqVel+8esZ25IOnwKOOJrR4iUGut+k9OOP10A8n+cqaCQY
         OWo1KjatjLmW7ho+7zAl/Nc5JaNJX/k7hQjS3zAT3nPpczlJUytNkEIFzYwyNKrJiTCT
         eHc+PfZJzwgrpVEzms1weWAruA9YIJeRUBh9yqInj63AiKCDZzwlMtKCXWowJAYcZlsZ
         pl2luQEiJCgdLu9jTcAHKZf8QWwSK4OTrgERrKDq58A1TtVS4bqFEpAIOPpcccsO8MO6
         fLzTOxTCtDIEK1HCjyK8IvxuIJLbtWs4H4OELh2XakueLLSOyaREkhyPoRj/26Eyfz2p
         800w==
X-Gm-Message-State: AOAM5320Fa5JQc1KOsiwCImhOxPXsKZ7HJ0V9+t59QmtEK4rjZ69Tk4m
        DnuW/NCZsLS3sp3yRoAl4CTw3ybSZga+zlUHzHGe79BEtNcm2w==
X-Google-Smtp-Source: ABdhPJyc/7gbJobUWolD4EV3jhsiVwVBD24Com3m40psFxhlOMB0QKUDUK1y7dIK52QfjrIU3gQSC3DH6f5AtBte8Y8=
X-Received: by 2002:a5d:6846:: with SMTP id o6mr59235183wrw.370.1594217216838;
 Wed, 08 Jul 2020 07:06:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200707171515.110818-1-izabela.bakollari@gmail.com> <647a37da-cd95-b84b-bc76-036a813c00e2@gmail.com>
In-Reply-To: <647a37da-cd95-b84b-bc76-036a813c00e2@gmail.com>
From:   Izabela Bakollari <izabela.bakollari@gmail.com>
Date:   Wed, 8 Jul 2020 16:06:45 +0200
Message-ID: <CAC8tkWAESmBmwYpj7qT0Wc5gD9Lw-2LMHBp2-QGtsJ_eGk7Kdg@mail.gmail.com>
Subject: Re: [PATCH net-next] dropwatch: Support monitoring of dropped frames
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

Thank you for reviewing my patch. I understand your comments
and will be working on correcting what you pointed out.

Best,
Izabela


On Tue, Jul 7, 2020 at 7:52 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 7/7/20 10:15 AM, izabela.bakollari@gmail.com wrote:
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
> >  include/uapi/linux/net_dropmon.h |  3 ++
> >  net/core/drop_monitor.c          | 79 +++++++++++++++++++++++++++++++-
> >  2 files changed, 80 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
> > index 67e31f329190..e8e861e03a8a 100644
> > --- a/include/uapi/linux/net_dropmon.h
> > +++ b/include/uapi/linux/net_dropmon.h
> > @@ -58,6 +58,8 @@ enum {
> >       NET_DM_CMD_CONFIG_NEW,
> >       NET_DM_CMD_STATS_GET,
> >       NET_DM_CMD_STATS_NEW,
> > +     NET_DM_CMD_START_IFC,
> > +     NET_DM_CMD_STOP_IFC,
> >       _NET_DM_CMD_MAX,
> >  };
> >
> > @@ -93,6 +95,7 @@ enum net_dm_attr {
> >       NET_DM_ATTR_SW_DROPS,                   /* flag */
> >       NET_DM_ATTR_HW_DROPS,                   /* flag */
> >       NET_DM_ATTR_FLOW_ACTION_COOKIE,         /* binary */
> > +     NET_DM_ATTR_IFNAME,                     /* string */
> >
> >       __NET_DM_ATTR_MAX,
> >       NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
> > diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
> > index 8e33cec9fc4e..8049bff05abd 100644
> > --- a/net/core/drop_monitor.c
> > +++ b/net/core/drop_monitor.c
> > @@ -30,6 +30,7 @@
> >  #include <net/genetlink.h>
> >  #include <net/netevent.h>
> >  #include <net/flow_offload.h>
> > +#include <net/sock.h>
> >
> >  #include <trace/events/skb.h>
> >  #include <trace/events/napi.h>
> > @@ -46,6 +47,7 @@
> >   */
> >  static int trace_state = TRACE_OFF;
> >  static bool monitor_hw;
> > +struct net_device *interface;
> >
> >  /* net_dm_mutex
> >   *
> > @@ -220,9 +222,8 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
> >       struct per_cpu_dm_data *data;
> >       unsigned long flags;
> >
> > -     local_irq_save(flags);
> > +     spin_lock_irqsave(&data->lock, flags);
> >       data = this_cpu_ptr(&dm_cpu_data);
> > -     spin_lock(&data->lock);
> >       dskb = data->skb;
> >
> >       if (!dskb)
> > @@ -255,6 +256,12 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
> >
> >  out:
> >       spin_unlock_irqrestore(&data->lock, flags);
> > +
>
> What protects interface from being changed under us by another thread/cpu ?
>
> > +     if (interface && interface != skb->dev) {
> > +             skb = skb_clone(skb, GFP_ATOMIC);
> > +             skb->dev = interface;
> > +             netif_receive_skb(skb);
> > +     }
> >  }
> >
> >  static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb, void *location)
> > @@ -1315,6 +1322,63 @@ static int net_dm_cmd_trace(struct sk_buff *skb,
> >       return -EOPNOTSUPP;
> >  }
> >
> > +static int net_dm_interface_start(struct net *net, const char *ifname)
> > +{
> > +     struct net_device *nd;
> > +
> > +     nd = dev_get_by_name(net, ifname);
> > +
> > +     if (nd) {
> > +             interface = nd;
>
> If interface was already set, you forgot to dev_put() it.
>
> > +             dev_hold(interface);
>
> Note that dev_get_by_name() already did a dev_hold()
>
> > +     } else {
> > +             return -ENODEV;
> > +     }
> > +     return 0;
> > +}
> > +
> > +static int net_dm_interface_stop(struct net *net, const char *ifname)
> > +{
> > +     struct net_device *nd;
> > +
> > +     nd = dev_get_by_name(net, ifname);
> > +
> > +     if (nd) {
>
>
>
> > +             interface = nd;
>
>
> You probably meant : interface = NULL; ?
>
> > +             dev_put(interface);
>
>                 and dev_put(nd);
>
>
> > +     } else {
> > +             return -ENODEV;
> > +     }
> > +     return 0;
> > +}
> > +
> > +static int net_dm_cmd_ifc_trace(struct sk_buff *skb, struct genl_info *info)
> > +{
> > +     struct net *net = sock_net(skb->sk);
> > +     char ifname[IFNAMSIZ];
> > +     int rc;
> > +
> > +     memset(ifname, 0, IFNAMSIZ);
> > +     nla_strlcpy(ifname, info->attrs[NET_DM_ATTR_IFNAME], IFNAMSIZ - 1);
> > +
> > +     switch (info->genlhdr->cmd) {
> > +     case NET_DM_CMD_START_IFC:
> > +             rc = net_dm_interface_start(net, ifname);
> > +             if (rc)
> > +                     return rc;
> > +             break;
> > +     case NET_DM_CMD_STOP_IFC:
> > +             if (interface) {
> > +                     rc = net_dm_interface_stop(net, interface->ifname);
> > +                     return rc;
> > +             } else {
> > +                     return -ENODEV;
> > +             }
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> >  static int net_dm_config_fill(struct sk_buff *msg, struct genl_info *info)
> >  {
> >       void *hdr;
> > @@ -1543,6 +1607,7 @@ static const struct nla_policy net_dm_nl_policy[NET_DM_ATTR_MAX + 1] = {
> >       [NET_DM_ATTR_QUEUE_LEN] = { .type = NLA_U32 },
> >       [NET_DM_ATTR_SW_DROPS]  = {. type = NLA_FLAG },
> >       [NET_DM_ATTR_HW_DROPS]  = {. type = NLA_FLAG },
> > +     [NET_DM_ATTR_IFNAME] = {. type = NLA_STRING, .len = IFNAMSIZ },
> >  };
> >
> >  static const struct genl_ops dropmon_ops[] = {
> > @@ -1570,6 +1635,16 @@ static const struct genl_ops dropmon_ops[] = {
> >               .cmd = NET_DM_CMD_STATS_GET,
> >               .doit = net_dm_cmd_stats_get,
> >       },
> > +     {
> > +             .cmd = NET_DM_CMD_START_IFC,
> > +             .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> > +             .doit = net_dm_cmd_ifc_trace,
> > +     },
> > +     {
> > +             .cmd = NET_DM_CMD_STOP_IFC,
> > +             .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> > +             .doit = net_dm_cmd_ifc_trace,
> > +     },
> >  };
> >
> >  static int net_dm_nl_pre_doit(const struct genl_ops *ops,
> >

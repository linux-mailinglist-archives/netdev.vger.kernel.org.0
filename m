Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FB523BDC0
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 18:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbgHDQIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 12:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729393AbgHDQIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 12:08:23 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B4DC06174A;
        Tue,  4 Aug 2020 09:08:23 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id p14so3193539wmg.1;
        Tue, 04 Aug 2020 09:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Plp9SEbll8B5kf9ZSWu+JZA+j7gPcEgF/3YNJKs7vzw=;
        b=JDdVjs7Y6aQIHnfcE0zzeKFhkmA+TxtZus6DU6Vw/dysjz99ut43vtYg5pGmRB9HL/
         T30+31G18EYw2nHKRgQyZ04/6iKFfe1105FzI8gq1hqfV00dRbk3SeKm2BoFDh5D0WSF
         fVxeE71nU5kCpi/R8Cb4wpjWdrBnnITB9i8zyTt3wpzZX3EXeHualaOW9KsQEBKCf2Xh
         qR5oVaCYQEWnAEamEQPkS1IQ1WSHYzuk3CbaTEpvvLk513eUw7rwrymGFYqswr72cAmK
         uGwsccCaYLr8y0u+Bc4CJiY62dD9V+TihGXfZ6yQcuv9B5yvurrEi1fBAV1JNzz9rGIS
         Yp6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Plp9SEbll8B5kf9ZSWu+JZA+j7gPcEgF/3YNJKs7vzw=;
        b=GhJuSNgmdX+HC82EScVwGTPhoMAXLbwCysnd6+GRFcrplF3il2KCE/qUQfP2A8uD8I
         rKq0obEdF2Y0fO/PSIClkrlmSKuhdmZDdZwVWt7U0ae5t40EeuVFKNQAZxUY/eJ8GlTS
         zftFkWCAsr7V9Q0HHYh0F1d6GsKPKYteQWvaV4tI3nU6KcJ0bHPanGP0296C1HG1FxMm
         EizB1dN4gm9G5/RzDkci0MDzNevgD+rcyRSl4YlqEjDsyhizBzKU68QP5VtHqqE02r1g
         Hn4QMqRj5onA3rxRj4MVPUVzaYA7RlKlLA+KaTnHgHAnAQV5xnWsWsQm0jX7RbdFjenp
         ttlA==
X-Gm-Message-State: AOAM532lLhzY8DNOtV4g/8XAs5LHboXBP3ec5vbb2k91YJccIg3DL2Yr
        jPk1cyxo6QmRut+VnSIoWf8iFOfw/gV9MkIBHww=
X-Google-Smtp-Source: ABdhPJxTl5+tAptmK2vPwh46+wHAhs5AjYdwuLLYnCvO6YhTsTVlKpXmoKSqOUYuET2slrVb8DTtzsVdWQiCjfv4ZaA=
X-Received: by 2002:a1c:678b:: with SMTP id b133mr5128351wmc.117.1596557302155;
 Tue, 04 Aug 2020 09:08:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200804154851.44141-1-izabela.bakollari@gmail.com>
In-Reply-To: <20200804154851.44141-1-izabela.bakollari@gmail.com>
From:   Izabela Bakollari <izabela.bakollari@gmail.com>
Date:   Tue, 4 Aug 2020 18:08:10 +0200
Message-ID: <CAC8tkWCABURFg5fk76Wwz5ZYsVsQRu8LjUSgzu3efKEFwY8mVg@mail.gmail.com>
Subject: Re: [PATCHv2 net-next--in-reply-to=<20200707171515.110818-1-izabela.bakollari@gmail.com>]
 dropwatch: Support monitoring of dropped frames
To:     nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am reverting my last patch because of the malformatted subject.

Thanks,
Izabela

On Tue, Aug 4, 2020 at 5:48 PM <izabela.bakollari@gmail.com> wrote:
>
> From: Izabela Bakollari <izabela.bakollari@gmail.com>
>
> Dropwatch is a utility that monitors dropped frames by having userspace
> record them over the dropwatch protocol over a file. This augument
> allows live monitoring of dropped frames using tools like tcpdump.
>
> With this feature, dropwatch allows two additional commands (start and
> stop interface) which allows the assignment of a net_device to the
> dropwatch protocol. When assinged, dropwatch will clone dropped frames,
> and receive them on the assigned interface, allowing tools like tcpdump
> to monitor for them.
>
> With this feature, create a dummy ethernet interface (ip link add dev
> dummy0 type dummy), assign it to the dropwatch kernel subsystem, by using
> these new commands, and then monitor dropped frames in real time by
> running tcpdump -i dummy0.
>
> Signed-off-by: Izabela Bakollari <izabela.bakollari@gmail.com>
> ---
> Changes in v2:
> - protect the dummy ethernet interface from being changed by another
> thread/cpu
> ---
>  include/uapi/linux/net_dropmon.h |  3 ++
>  net/core/drop_monitor.c          | 84 ++++++++++++++++++++++++++++++++
>  2 files changed, 87 insertions(+)
>
> diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
> index 67e31f329190..e8e861e03a8a 100644
> --- a/include/uapi/linux/net_dropmon.h
> +++ b/include/uapi/linux/net_dropmon.h
> @@ -58,6 +58,8 @@ enum {
>         NET_DM_CMD_CONFIG_NEW,
>         NET_DM_CMD_STATS_GET,
>         NET_DM_CMD_STATS_NEW,
> +       NET_DM_CMD_START_IFC,
> +       NET_DM_CMD_STOP_IFC,
>         _NET_DM_CMD_MAX,
>  };
>
> @@ -93,6 +95,7 @@ enum net_dm_attr {
>         NET_DM_ATTR_SW_DROPS,                   /* flag */
>         NET_DM_ATTR_HW_DROPS,                   /* flag */
>         NET_DM_ATTR_FLOW_ACTION_COOKIE,         /* binary */
> +       NET_DM_ATTR_IFNAME,                     /* string */
>
>         __NET_DM_ATTR_MAX,
>         NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
> diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
> index 8e33cec9fc4e..781e69876d2f 100644
> --- a/net/core/drop_monitor.c
> +++ b/net/core/drop_monitor.c
> @@ -30,6 +30,7 @@
>  #include <net/genetlink.h>
>  #include <net/netevent.h>
>  #include <net/flow_offload.h>
> +#include <net/sock.h>
>
>  #include <trace/events/skb.h>
>  #include <trace/events/napi.h>
> @@ -46,6 +47,7 @@
>   */
>  static int trace_state = TRACE_OFF;
>  static bool monitor_hw;
> +struct net_device *interface;
>
>  /* net_dm_mutex
>   *
> @@ -54,6 +56,8 @@ static bool monitor_hw;
>   */
>  static DEFINE_MUTEX(net_dm_mutex);
>
> +static DEFINE_SPINLOCK(interface_lock);
> +
>  struct net_dm_stats {
>         u64 dropped;
>         struct u64_stats_sync syncp;
> @@ -255,6 +259,21 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
>
>  out:
>         spin_unlock_irqrestore(&data->lock, flags);
> +       spin_lock_irqsave(&interface_lock, flags);
> +       if (interface && interface != skb->dev) {
> +               skb = skb_clone(skb, GFP_ATOMIC);
> +               if (skb) {
> +                       skb->dev = interface;
> +                       spin_unlock_irqrestore(&interface_lock, flags);
> +                       netif_receive_skb(skb);
> +               } else {
> +                       spin_unlock_irqrestore(&interface_lock, flags);
> +                       pr_err("dropwatch: Not enough memory to clone dropped skb\n");
> +                       return;
> +               }
> +       } else {
> +               spin_unlock_irqrestore(&interface_lock, flags);
> +       }
>  }
>
>  static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb, void *location)
> @@ -1315,6 +1334,53 @@ static int net_dm_cmd_trace(struct sk_buff *skb,
>         return -EOPNOTSUPP;
>  }
>
> +static int net_dm_interface_start(struct net *net, const char *ifname)
> +{
> +       struct net_device *nd = dev_get_by_name(net, ifname);
> +
> +       if (nd)
> +               interface = nd;
> +       else
> +               return -ENODEV;
> +
> +       return 0;
> +}
> +
> +static int net_dm_interface_stop(struct net *net, const char *ifname)
> +{
> +       dev_put(interface);
> +       interface = NULL;
> +
> +       return 0;
> +}
> +
> +static int net_dm_cmd_ifc_trace(struct sk_buff *skb, struct genl_info *info)
> +{
> +       struct net *net = sock_net(skb->sk);
> +       char ifname[IFNAMSIZ];
> +
> +       if (net_dm_is_monitoring())
> +               return -EBUSY;
> +
> +       memset(ifname, 0, IFNAMSIZ);
> +       nla_strlcpy(ifname, info->attrs[NET_DM_ATTR_IFNAME], IFNAMSIZ - 1);
> +
> +       switch (info->genlhdr->cmd) {
> +       case NET_DM_CMD_START_IFC:
> +               if (!interface)
> +                       return net_dm_interface_start(net, ifname);
> +               else
> +                       return -EBUSY;
> +       case NET_DM_CMD_STOP_IFC:
> +               if (interface)
> +                       return net_dm_interface_stop(net, interface->name);
> +               else
> +                       return -ENODEV;
> +       }
> +
> +       return 0;
> +}
> +
>  static int net_dm_config_fill(struct sk_buff *msg, struct genl_info *info)
>  {
>         void *hdr;
> @@ -1503,6 +1569,7 @@ static int dropmon_net_event(struct notifier_block *ev_block,
>         struct net_device *dev = netdev_notifier_info_to_dev(ptr);
>         struct dm_hw_stat_delta *new_stat = NULL;
>         struct dm_hw_stat_delta *tmp;
> +       unsigned long flags;
>
>         switch (event) {
>         case NETDEV_REGISTER:
> @@ -1529,6 +1596,12 @@ static int dropmon_net_event(struct notifier_block *ev_block,
>                                 }
>                         }
>                 }
> +               spin_lock_irqsave(&interface_lock, flags);
> +               if (interface && interface == dev) {
> +                       dev_put(interface);
> +                       interface = NULL;
> +               }
> +               spin_unlock_irqrestore(&interface_lock, flags);
>                 mutex_unlock(&net_dm_mutex);
>                 break;
>         }
> @@ -1543,6 +1616,7 @@ static const struct nla_policy net_dm_nl_policy[NET_DM_ATTR_MAX + 1] = {
>         [NET_DM_ATTR_QUEUE_LEN] = { .type = NLA_U32 },
>         [NET_DM_ATTR_SW_DROPS]  = {. type = NLA_FLAG },
>         [NET_DM_ATTR_HW_DROPS]  = {. type = NLA_FLAG },
> +       [NET_DM_ATTR_IFNAME] = {. type = NLA_STRING, .len = IFNAMSIZ },
>  };
>
>  static const struct genl_ops dropmon_ops[] = {
> @@ -1570,6 +1644,16 @@ static const struct genl_ops dropmon_ops[] = {
>                 .cmd = NET_DM_CMD_STATS_GET,
>                 .doit = net_dm_cmd_stats_get,
>         },
> +       {
> +               .cmd = NET_DM_CMD_START_IFC,
> +               .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> +               .doit = net_dm_cmd_ifc_trace,
> +       },
> +       {
> +               .cmd = NET_DM_CMD_STOP_IFC,
> +               .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> +               .doit = net_dm_cmd_ifc_trace,
> +       },
>  };
>
>  static int net_dm_nl_pre_doit(const struct genl_ops *ops,
> --
> 2.18.4
>

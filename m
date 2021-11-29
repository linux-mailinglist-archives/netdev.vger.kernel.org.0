Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7BA460E42
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 06:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhK2FDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 00:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbhK2FBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 00:01:42 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD788C06175D
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 20:58:25 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id y13so66306553edd.13
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 20:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i6qj48g3hWlAT+PE0Bq+Pz+MZqvHl1s8iEv3kTvxvmI=;
        b=f5bmLFfeoKpmMyfLoPGk9i/BNB/Tf1l18R3EVlw24nkxN7jbRV43CX1sx2G5tZJuL/
         sCUcanzHKJnEyfhqRvSRWLzYgFkFY9w9kWZll9vUePA87HF4Eszl9I8hhTVRmwFTY09N
         /ytwl5o8tRRxVVYFemjlNthogcqptiLCGUciuye2TcjottLvfozc3Go5Tpb5RtxQB/3L
         5ZnC6ADUSvrG59j4f0E8wySV8dqqFsrOURiqtyAAebn7Pr+K/Un+vx9iXqH5uKF5gKfB
         OLGcnFdxhojTDp/Eo2HSn48UuvScQc1nS2kDx9timaf/n4aOy3M+NoGd1+YXz4ZtvfRE
         l7eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i6qj48g3hWlAT+PE0Bq+Pz+MZqvHl1s8iEv3kTvxvmI=;
        b=TbH14uQWHDzo9CN+Br9Nz4Qe/D+zmuatsseTNggXZ0iY1Z58kegyawaoEyqdkie7Bs
         LP/psMZsupjKumyLaowsZvYhWchujWFREo+v3TD3KNAjxafy7nAn1Vyzg5JBJiUALsYl
         V890YAMQ8QVJ8wPZSyMWLdQZGX8MkoPR3lgJursExfbCzxnyzmn1t/7t5QxAqv8LEGRP
         Or0kaMJ7nycJJ/Ijb5GAl7WJoUBNKdktpyuQZyam0SE2o00YabOu6jAUZq23ygdvjM/N
         fucOpU5qt2mZ5AoJZCCPsZPPVvDOlhDm2QZJkUXeMOAR3JNIpiB+K6bYngh5vsqgRt8U
         vu4Q==
X-Gm-Message-State: AOAM533ilRrixo0hLi8Laj6Q0L3mgukd0W1AeyAsjpg7dhDpfUMqK32m
        LWTmc+Z/UIXbwvgjWxswQbLiCFcdQkVUTczpEDRNBO98a8zlsA==
X-Google-Smtp-Source: ABdhPJwC81XJskp5B/WxH/kRQAJy8iyufMdUqIu/Wv04V/Y1dWsGQdc25GLhaYKNDfP1es+zdWmkMh5Yqx02CIvZS08=
X-Received: by 2002:a17:906:d54d:: with SMTP id cr13mr13953567ejc.409.1638161904314;
 Sun, 28 Nov 2021 20:58:24 -0800 (PST)
MIME-Version: 1.0
References: <20211126032305.13571-1-xiangxia.m.yue@gmail.com> <20211126134254.45bd82c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211126134254.45bd82c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 29 Nov 2021 12:57:48 +0800
Message-ID: <CAMDZJNVYnPHCNa3+6qHgEV3D0LGvRS0ov5bv2=zy+mwgC3oyDg@mail.gmail.com>
Subject: Re: [net-next v2] net: ifb: support ethtools stats
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 27, 2021 at 5:42 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 26 Nov 2021 11:23:05 +0800 xiangxia.m.yue@gmail.com wrote:
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > With this feature, we can use the ethtools to get tx/rx
> > queues stats. This patch, introduce the ifb_update_q_stats
> > helper to update the queues stats, and ifb_q_stats to simplify
> > the codes. In future, we can add more metrics in ifb_q_stats.
> >
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> >  static netdev_tx_t ifb_xmit(struct sk_buff *skb, struct net_device *dev);
> >  static int ifb_open(struct net_device *dev);
> >  static int ifb_close(struct net_device *dev);
> >
> > +static inline void ifb_update_q_stats(struct ifb_q_stats *stats, int len)
>
> Please remove the "inline" keywords, we prefer to leave the choice to
> the compiler (plus it hides "unused function" warnings if the caller
> is ever removed).
>
> > +static void ifb_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
> > +{
> > +     u8 *p = buf;
> > +     int i, j;
> > +
> > +     switch(stringset) {
> > +     case ETH_SS_STATS:
> > +             for (i = 0; i < dev->real_num_rx_queues; i++)
> > +                     for (j = 0; j < IFB_Q_STATS_LEN; j++)
> > +                             ethtool_sprintf(&p, "rx_queue_%u_%.18s",
> > +                                             i, ifb_q_stats_desc[j].desc);
> > +
> > +             for (i = 0; i < dev->real_num_tx_queues; i++)
> > +                     for (j = 0; j < IFB_Q_STATS_LEN; j++)
> > +                             ethtool_sprintf(&p, "tx_queue_%u_%.18s",
> > +                                             i, ifb_q_stats_desc[j].desc);
> > +
> > +             break;
> > +     }
> > +}
> > +
> > +static int ifb_get_sset_count(struct net_device *dev, int sset)
> > +{
> > +     switch (sset) {
> > +     case ETH_SS_STATS:
> > +             return IFB_Q_STATS_LEN * (dev->real_num_rx_queues +
> > +                    dev->real_num_tx_queues);
>
> Needs to align under opening bracket, try checkpatch --strict.
>
> > +     default:
> > +             return -EOPNOTSUPP;
> > +     }
> > +}
> > +
> > +static inline void ifb_fill_stats_data(u64 **data,
> > +                                    struct ifb_q_stats *q_stats)
>
> another inline
Thanks, Jakub
v3 is sent, https://patchwork.kernel.org/project/netdevbpf/patch/20211128014631.43627-1-xiangxia.m.yue@gmail.com/

> The logic itself LGTM.




--
Best regards, Tonghao

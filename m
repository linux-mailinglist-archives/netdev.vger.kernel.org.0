Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AED625DD8D
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 06:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfGCEqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 00:46:06 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51928 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfGCEqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 00:46:06 -0400
Received: by mail-wm1-f66.google.com with SMTP id 207so707646wma.1
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 21:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wYhh1FZzURTT7jH4X0+BMDoH/6wRanTlqxHaq9ZAeIo=;
        b=dQRSzZmUe1oWkQbqMVhHq7Z3a+ParxHjVuN4zzmMeN7jWd7RuDzM1G94+XusklGZRy
         0JKGxw/gkYiH/09tv5hefVtrawoo77R3FEAormbcWaJFmx3cm1zSd8/S19kYiItWER7t
         0LHQSv/BBFagOdYumbEf4hJUNIKYH5pz8CtlsuaUYveabhGr9qbVl8ixKBiqvjv5g610
         TG/hvXsgFVUo9nrW9Ue0BxoaHLuZfYoNNxnyP2A9u0lwdA56n4aJX4mqCqy8E7/+hKeW
         Q8T28gH8ChWgDJPL2up3LqflSLbF9sgnxiHRkoe/0n0MisFBWYHBdyN1hUgC6oSsOBX2
         4Vyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wYhh1FZzURTT7jH4X0+BMDoH/6wRanTlqxHaq9ZAeIo=;
        b=ldGFtYdiz2Wl4PwIJULcGeLIGAOZRlHFOPK4ilgImxEmfq99DXMk0l0VVpggVKlXYP
         6Q5QTFpyZq9FhPxj4WDcGdla2Ow5KwJEyl5jLhD3Pk9NhnPkhXDEsb6lQkuuk/QtHtk7
         XtD/rUoVlfDKJg8KtcGAISRmSAYfrJpV5ogC3lkYPmw6rWbndxQZlY67llNVmr5g/BDR
         nM6wi9HPMQbrQdoUKiYFgt9MbqAzqb78OgHZb1AfkD3uAeVOLXao40BAoKaJ/y6Mxor7
         L80pKIuqN2FSxOhxatsx8abx/3BvV53ytKcG7jmg4eGWzcaGhCdLgq9FXjZcumSPRc9y
         DfOA==
X-Gm-Message-State: APjAAAU1EBZ6Ni4lnMSguzdWJIx5xxGBBJyDT791Qm4dbWERKwJC6VzE
        /D3eI6z4lK4Un5+pCAVSMttZPCmo0qujiRU1MKlFNQ==
X-Google-Smtp-Source: APXvYqypB8Gwxv/tNWr1/m7SPPHay5N8t9sQgm11whZDoZ0H119QZPeC/ixVqENlUCif7avjYDOVoJVygfC0VJYk2Rg=
X-Received: by 2002:a1c:6a06:: with SMTP id f6mr5759985wmc.159.1562129162963;
 Tue, 02 Jul 2019 21:46:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190701213849.102759-1-maheshb@google.com> <alpine.DEB.2.21.1907021450320.5764@ramsan.of.borg>
In-Reply-To: <alpine.DEB.2.21.1907021450320.5764@ramsan.of.borg>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Tue, 2 Jul 2019 21:45:46 -0700
Message-ID: <CAF2d9jhikNn94WD7mefMDpiZK-baCwsPJRXti_WSFE6_v+Ci-w@mail.gmail.com>
Subject: Re: suspicious RCU usage (was: Re: [PATCHv3 next 1/3] loopback:
 create blackhole net device similar to loopack.)
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Daniel Axtens <dja@axtens.net>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 5:54 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
>         Hi Mahesh,
>
> On Mon, 1 Jul 2019, Mahesh Bandewar wrote:
> > Create a blackhole net device that can be used for "dead"
> > dst entries instead of loopback device. This blackhole device differs
> > from loopback in few aspects: (a) It's not per-ns. (b)  MTU on this
> > device is ETH_MIN_MTU (c) The xmit function is essentially kfree_skb().
> > and (d) since it's not registered it won't have ifindex.
> >
> > Lower MTU effectively make the device not pass the MTU check during
> > the route check when a dst associated with the skb is dead.
> >
> > Signed-off-by: Mahesh Bandewar <maheshb@google.com>
>
> This is now commit 4de83b88c66a1e4d ("loopback: create blackhole net
> device similar to loopack.") in net-next, and causes the following
> warning on arm64:
>
>      WARNING: suspicious RCU usage
>      5.2.0-rc6-arm64-renesas-01699-g4de83b88c66a1e4d #263 Not tainted
>      -----------------------------
>      include/linux/rtnetlink.h:85 suspicious rcu_dereference_protected() usage!
>
>      other info that might help us debug this:
>
>
>      rcu_scheduler_active = 2, debug_locks = 1
>      no locks held by swapper/0/1.
>
thanks for the report. Let me take a look at this.

>      stack backtrace:
>      CPU: 2 PID: 1 Comm: swapper/0 Not tainted 5.2.0-rc6-arm64-renesas-01699-g4de83b88c66a1e4d #263
>      Hardware name: Renesas Salvator-X 2nd version board based on r8a7795 ES2.0+ (DT)
>      Call trace:
>       dump_backtrace+0x0/0x148
>       show_stack+0x14/0x20
>       dump_stack+0xd4/0x11c
>       lockdep_rcu_suspicious+0xcc/0x110
>       dev_init_scheduler+0x114/0x150
>       blackhole_netdev_init+0x40/0x80
>       do_one_initcall+0x178/0x37c
>       kernel_init_freeable+0x490/0x530
>       kernel_init+0x10/0x100
>       ret_from_fork+0x10/0x1c
>
>
> > ---
> > v1->v2->v3
> >  no change
> >
> > drivers/net/loopback.c    | 76 ++++++++++++++++++++++++++++++++++-----
> > include/linux/netdevice.h |  2 ++
> > 2 files changed, 69 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
> > index 87d361666cdd..3b39def5471e 100644
> > --- a/drivers/net/loopback.c
> > +++ b/drivers/net/loopback.c
> > @@ -55,6 +55,13 @@
> > #include <net/net_namespace.h>
> > #include <linux/u64_stats_sync.h>
> >
> > +/* blackhole_netdev - a device used for dsts that are marked expired!
> > + * This is global device (instead of per-net-ns) since it's not needed
> > + * to be per-ns and gets initialized at boot time.
> > + */
> > +struct net_device *blackhole_netdev;
> > +EXPORT_SYMBOL(blackhole_netdev);
> > +
> > /* The higher levels take care of making this non-reentrant (it's
> >  * called with bh's disabled).
> >  */
> > @@ -150,12 +157,14 @@ static const struct net_device_ops loopback_ops = {
> >       .ndo_set_mac_address = eth_mac_addr,
> > };
> >
> > -/* The loopback device is special. There is only one instance
> > - * per network namespace.
> > - */
> > -static void loopback_setup(struct net_device *dev)
> > +static void gen_lo_setup(struct net_device *dev,
> > +                      unsigned int mtu,
> > +                      const struct ethtool_ops *eth_ops,
> > +                      const struct header_ops *hdr_ops,
> > +                      const struct net_device_ops *dev_ops,
> > +                      void (*dev_destructor)(struct net_device *dev))
> > {
> > -     dev->mtu                = 64 * 1024;
> > +     dev->mtu                = mtu;
> >       dev->hard_header_len    = ETH_HLEN;     /* 14   */
> >       dev->min_header_len     = ETH_HLEN;     /* 14   */
> >       dev->addr_len           = ETH_ALEN;     /* 6    */
> > @@ -174,11 +183,20 @@ static void loopback_setup(struct net_device *dev)
> >               | NETIF_F_NETNS_LOCAL
> >               | NETIF_F_VLAN_CHALLENGED
> >               | NETIF_F_LOOPBACK;
> > -     dev->ethtool_ops        = &loopback_ethtool_ops;
> > -     dev->header_ops         = &eth_header_ops;
> > -     dev->netdev_ops         = &loopback_ops;
> > +     dev->ethtool_ops        = eth_ops;
> > +     dev->header_ops         = hdr_ops;
> > +     dev->netdev_ops         = dev_ops;
> >       dev->needs_free_netdev  = true;
> > -     dev->priv_destructor    = loopback_dev_free;
> > +     dev->priv_destructor    = dev_destructor;
> > +}
> > +
> > +/* The loopback device is special. There is only one instance
> > + * per network namespace.
> > + */
> > +static void loopback_setup(struct net_device *dev)
> > +{
> > +     gen_lo_setup(dev, (64 * 1024), &loopback_ethtool_ops, &eth_header_ops,
> > +                  &loopback_ops, loopback_dev_free);
> > }
> >
> > /* Setup and register the loopback device. */
> > @@ -213,3 +231,43 @@ static __net_init int loopback_net_init(struct net *net)
> > struct pernet_operations __net_initdata loopback_net_ops = {
> >       .init = loopback_net_init,
> > };
> > +
> > +/* blackhole netdevice */
> > +static netdev_tx_t blackhole_netdev_xmit(struct sk_buff *skb,
> > +                                      struct net_device *dev)
> > +{
> > +     kfree_skb(skb);
> > +     net_warn_ratelimited("%s(): Dropping skb.\n", __func__);
> > +     return NETDEV_TX_OK;
> > +}
> > +
> > +static const struct net_device_ops blackhole_netdev_ops = {
> > +     .ndo_start_xmit = blackhole_netdev_xmit,
> > +};
> > +
> > +/* This is a dst-dummy device used specifically for invalidated
> > + * DSTs and unlike loopback, this is not per-ns.
> > + */
> > +static void blackhole_netdev_setup(struct net_device *dev)
> > +{
> > +     gen_lo_setup(dev, ETH_MIN_MTU, NULL, NULL, &blackhole_netdev_ops, NULL);
> > +}
> > +
> > +/* Setup and register the blackhole_netdev. */
> > +static int __init blackhole_netdev_init(void)
> > +{
> > +     blackhole_netdev = alloc_netdev(0, "blackhole_dev", NET_NAME_UNKNOWN,
> > +                                     blackhole_netdev_setup);
> > +     if (!blackhole_netdev)
> > +             return -ENOMEM;
> > +
> > +     dev_init_scheduler(blackhole_netdev);
> > +     dev_activate(blackhole_netdev);
> > +
> > +     blackhole_netdev->flags |= IFF_UP | IFF_RUNNING;
> > +     dev_net_set(blackhole_netdev, &init_net);
> > +
> > +     return 0;
> > +}
> > +
> > +device_initcall(blackhole_netdev_init);
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index eeacebd7debb..88292953aa6f 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -4870,4 +4870,6 @@ do {                                                            \
> > #define PTYPE_HASH_SIZE       (16)
> > #define PTYPE_HASH_MASK       (PTYPE_HASH_SIZE - 1)
> >
> > +extern struct net_device *blackhole_netdev;
> > +
> > #endif        /* _LINUX_NETDEVICE_H */
> >
> Gr{oetje,eeting}s,
>
>                                                 Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                                             -- Linus Torvalds
>

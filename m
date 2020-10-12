Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB4028B177
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 11:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbgJLJYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 05:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgJLJYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 05:24:38 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3FCC0613CE
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 02:24:37 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id u8so22263189ejg.1
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 02:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fu0PSy2Z1gVPhwGaBv6ckpIJw9tmz1tQHvR3iVcBB0Q=;
        b=A80XE3ZXbYucOOpvVKTmr3q4tTTAkKCeISSB2P+TtJj8qjAE9ehcyF/vEknmF+3S0i
         izxjK0BnzjTvGPG72QEZQXSEw2QfHYIn48aK91kJfxrHIL/gi5Q2A74iWTs4GjQzhbd0
         7h6qMlSfDXNRWipFNICUv3kVESFsUZU2hRQ6xs43gdB5vxQ9otfqnpP1npgPN/X+8XL+
         Sd3frs/41UKo8nrOqUWLQeE3+fFs3BSNkbVj2k80zTG1bIbzmhTVIhdSRlQjvaY5bNb+
         U5hd6OoRM2hGWc9FX23U2h77GXo6+xhLd6MkSdMO5yE+W7j3YKntrI5Jf4LrTrbyB2iM
         hhSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fu0PSy2Z1gVPhwGaBv6ckpIJw9tmz1tQHvR3iVcBB0Q=;
        b=cICRnteJaeEAyvOENuvt+W3/OwzzEr0DP3iwPXHcP7cUAdUyKpZ3JK8Z+jIRA8mgSA
         IQ8KkGP4ud7LBoxQVwcBLLiL7OEu0Smlky9ONMt+fxxvKdz9ICEcy9sr3hW/W+Y1PwhQ
         jgU7ixo/o/+xAlqBz3Yg0YE1PRUBba206VWT4LCOr29TvabeMASE1SCfhMxgPG4RpDt3
         1dhpVGRYAiwjZomts6vezx0ldaUd3fqOMGyeIY43LnM/M386iQ/JhHxKUrDm8wCXX2bX
         Hkr4/mZkHP+s2WjYvXHz+oP6KAxP3WnkHx96ds46p6c+2l4/iszOs/tnoqxCx8q+stwQ
         A1Vg==
X-Gm-Message-State: AOAM530tf0DecljVw9HUAmLWN43ZioyRlsps/E27w9H/4ZoWDYO+cbns
        Fr3wDNM1jX7ruO7oDDNqrccWVaIUc1uufxKeuSu4oA==
X-Google-Smtp-Source: ABdhPJygvawRcBQ+4JMlfaN42oGGSqBP4c2Y27cp+3WQn9dYwdVfW42PjgWMBjFfDu7q0Eo2rTRmoNtVJMUjP3uCe0c=
X-Received: by 2002:a17:906:fb86:: with SMTP id lr6mr26914950ejb.510.1602494676244;
 Mon, 12 Oct 2020 02:24:36 -0700 (PDT)
MIME-Version: 1.0
References: <1602275611-7440-1-git-send-email-loic.poulain@linaro.org> <20201011115932.3d67ba52@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201011115932.3d67ba52@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Mon, 12 Oct 2020 11:30:08 +0200
Message-ID: <CAMZdPi_RDSi-STO3EduoG0=s_75RZYWm3CmfWwhsmg6y1bk_hQ@mail.gmail.com>
Subject: Re: [PATCH] net: Add mhi-net driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, Hemant Kumar <hemantk@codeaurora.org>,
        netdev@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, and thanks for your review.

On Sun, 11 Oct 2020 at 20:59, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri,  9 Oct 2020 22:33:31 +0200 Loic Poulain wrote:
> > This patch adds a new network driver implementing MHI transport for
> > network packets. Packets can be in any format, though QMAP (rmnet)
> > is the usual protocol (flow control + PDN mux).
> >
> > It support two MHI devices, IP_HW0 which is, the path to the IPA
> > (IP accelerator) on qcom modem, And IP_SW0 which is the software
> > driven IP path (to modem CPU).
> >
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
>
> > +static int mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
> > +{
> > +     struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
> > +     struct mhi_device *mdev = mhi_netdev->mdev;
> > +     int err;
> > +
> > +     /* Only support for single buffer transfer for now */
> > +     err = skb_linearize(skb);
>
> Since you don't advertise NETIF_F_SG you shouldn't have to call this,
> no?

Right, good to know.

>
> > +     if (unlikely(err)) {
> > +             kfree_skb(skb);
> > +             mhi_netdev->stats.tx_dropped++;
> > +             return NETDEV_TX_OK;
> > +     }
> > +
> > +     skb_tx_timestamp(skb);
> > +
> > +     /* mhi_queue_skb is not thread-safe, but xmit is serialized by the
> > +      * network core. Once MHI core will be thread save, migrate to
> > +      * NETIF_F_LLTX support.
> > +      */
> > +     err = mhi_queue_skb(mdev, DMA_TO_DEVICE, skb, skb->len, MHI_EOT);
> > +     if (err) {
> > +             netdev_err(ndev, "mhi_queue_skb err %d\n", err);
>
> This needs to be at least rate limited.

Yes, I've missed removing that message, going to keep rate-limited version
for non-busy error case.

>
> > +             netif_stop_queue(ndev);
>
> What's going to start the queue if it's a transient errors and not
> NETDEV_TX_BUSY?
>
> > +             return (err == -ENOMEM) ? NETDEV_TX_BUSY : err;
>
> You should drop the packet if it's not NETDEV_TX_BUSY, and return
> NETDEV_TX_OK. Don't return negative errors from ndo_xmit.

Ok, going to determine which error it is and act accordingly.

>
> > +     }
> > +
> > +     return NETDEV_TX_OK;
> > +}
> > +
> > +static void mhi_ndo_get_stats64(struct net_device *ndev,
> > +                             struct rtnl_link_stats64 *stats)
> > +{
> > +     struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
> > +
> > +     stats->rx_packets = mhi_netdev->stats.rx_packets;
> > +     stats->rx_bytes = mhi_netdev->stats.rx_bytes;
> > +     stats->rx_errors = mhi_netdev->stats.rx_errors;
> > +     stats->rx_dropped = mhi_netdev->stats.rx_dropped;
> > +     stats->tx_packets = mhi_netdev->stats.tx_packets;
> > +     stats->tx_bytes = mhi_netdev->stats.tx_bytes;
> > +     stats->tx_errors = mhi_netdev->stats.tx_errors;
> > +     stats->tx_dropped = mhi_netdev->stats.tx_dropped;
> > +}
>
> Can you use

?

>
> > +static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
> > +                             struct mhi_result *mhi_res)
> > +{
> > +     struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
> > +     struct sk_buff *skb = mhi_res->buf_addr;
> > +
> > +     atomic_dec(&mhi_netdev->stats.rx_queued);
> > +
> > +     if (mhi_res->transaction_status) {
> > +             mhi_netdev->stats.rx_errors++;
> > +             kfree_skb(skb);
> > +     } else {
> > +             mhi_netdev->stats.rx_packets++;
> > +             mhi_netdev->stats.rx_bytes += mhi_res->bytes_xferd;
> > +
> > +             skb->protocol = htons(ETH_P_MAP);
> > +             skb_put(skb, mhi_res->bytes_xferd);
> > +             netif_rx(skb);
> > +     }
> > +
> > +     schedule_delayed_work(&mhi_netdev->rx_refill, 0);
>
> Scheduling a work to replace every single RX buffer looks quite
> inefficient. Any chance you can do batching? I assume mhi_queue_skb()
> has to be able to sleep?

There is already some kind of batching, the hardware can perform interrupt
coalescing (called interrupt mitigation in case of MHI), which, in high traffic
case will cause the dl_callback to be called in row for multiple packets, and
so the work to be scheduled only once. mhi_queue_skb does not sleep.

However we could implement some additional mitigation by e.g. only scheduling
the work if the current rx-queue fall under a certain limit (e.g.
queue size / 2), like it is
done in virtio-net. What do you think?

>
> > +static void mhi_net_rx_refill_work(struct work_struct *work)
> > +{
> > +     struct mhi_net_dev *mhi_netdev = container_of(work, struct mhi_net_dev,
> > +                                                   rx_refill.work);
> > +     struct net_device *ndev = mhi_netdev->ndev;
> > +     struct mhi_device *mdev = mhi_netdev->mdev;
> > +     struct sk_buff *skb;
> > +     int err;
> > +
> > +     if (!netif_running(ndev))
> > +             return;
>
> How can this happen? You cancel the work from ndo_stop.

Right, If the work is executed while we are currently canceling it, I wanted
to prevent the work to fully run and reschedule. But yes it's not strictly
necessary since cancel_work_sync will 1. wait for the job to exit and
2. dequeue the work. Will remove that.

>
> > +     do {
> > +             skb = netdev_alloc_skb(ndev, READ_ONCE(ndev->mtu));
> > +             if (unlikely(!skb)) {
> > +                     /* If we are starved of RX buffers, retry later */
> > +                     if (!atomic_read(&mhi_netdev->stats.rx_queued))
> > +                             schedule_delayed_work(&mhi_netdev->rx_refill, HZ / 2);
> > +                     break;
> > +             }
> > +
> > +             err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb, ndev->mtu,
> > +                                 MHI_EOT);
> > +             if (err) {
> > +                     atomic_dec(&mhi_netdev->stats.rx_queued);
>
> This can never fail with an empty ring? No need to potentially
> reschedule the work here?

Well, it can fail because IO/transient error, so yes, I need to check that
case and reschedule if necessary.

>
> > +                     kfree_skb(skb);
> > +                     break;
> > +             }
> > +
> > +             atomic_inc(&mhi_netdev->stats.rx_queued);
> > +
> > +     } while (1);
> > +}
> > +
> > +static int mhi_net_probe(struct mhi_device *mhi_dev,
> > +                      const struct mhi_device_id *id)
> > +{
> > +     const char *netname = (char *)id->driver_data;
> > +     struct mhi_net_dev *mhi_netdev;
> > +     struct net_device *ndev;
> > +     struct device *dev = &mhi_dev->dev;
> > +     int err;
> > +
> > +     ndev = alloc_netdev(sizeof(*mhi_netdev), netname, NET_NAME_PREDICTABLE,
> > +                         mhi_net_setup);
> > +     if (!ndev) {
> > +             err = -ENOMEM;
> > +             return err;
>
> return -ENOMEM;
>
> > +     }
> > +
> > +     mhi_netdev = netdev_priv(ndev);
> > +     dev_set_drvdata(dev, mhi_netdev);
> > +     mhi_netdev->ndev = ndev;
> > +     mhi_netdev->mdev = mhi_dev;
>
> SET_NETDEV_DEV() ?

Ok.

>
> > +     INIT_DELAYED_WORK(&mhi_netdev->rx_refill, mhi_net_rx_refill_work);
> > +
> > +     /* Start MHI channels */
> > +     err = mhi_prepare_for_transfer(mhi_dev, 0);
> > +     if (err) {
> > +             free_netdev(ndev);
> > +             return err;
> > +     }
> > +
> > +     err = register_netdev(ndev);
> > +     if (err) {
> > +             dev_err(dev, "mhi_net: registering device failed\n");
> > +             free_netdev(ndev);
> > +             return -EINVAL;
>
> Why not propagate the error?

Will do.

>
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static void mhi_net_remove(struct mhi_device *mhi_dev)
> > +{
> > +     struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
> > +
> > +     mhi_unprepare_from_transfer(mhi_netdev->mdev);
> > +     unregister_netdev(mhi_netdev->ndev);
>
> Isn't this the wrong way around?
>
> Should you not unregister the netdev before you stop transfers?

That can be done that way, but wanted to be sure that no transfer callback
is called after netdev has been released (freed in unregister), though the MHI
core takes care of that in its remove procedure.

>
> > +     /* netdev released from unregister */
>
> > +}

Thanks,
Loic

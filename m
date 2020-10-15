Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C572E28F31D
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 15:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbgJONX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 09:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728521AbgJONX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 09:23:56 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F93C061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 06:23:56 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id o18so3087449edq.4
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 06:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mBbJjr/w6dV0hBxLxDNDRdI4SJ/0WyuAlSGKKh4XkGw=;
        b=wf0GqoSRgmwnq57TmIvmEsiPfmvFoWrTkKxnwW3HTYwVYPAAzc1e7WNss6Br0zjCe2
         7tSNab13ShbMcYyxq0WZgzpi45LnvZzWlC3Y+Gmtk1jwkCdyy4nbYuKiysYlRZzlvb0K
         gZKb5qYGJtmFSh3lQDGasmJVsqkn9Rjf1/rU5vRZRvhIe+ikS9kjuDzz0HrdY7eK0kuv
         HugvSGNwNCFJqNJ0isbP49/E2Bs/lSufpn3M876hZhjdFRHr5OFfynegTFe0i8lWdp93
         3NFU28qdQzSwPhERGzU+NhUo+5sgBiWQ/PaXMmJiLcZQdUjQfaRxgwkgRLtlsVM9Wi53
         7Dkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mBbJjr/w6dV0hBxLxDNDRdI4SJ/0WyuAlSGKKh4XkGw=;
        b=l8CH7BNu/1bmswMbSutYkCVv4lGn0hjXK09HIusMPXbo9U7pOeodSXjVQz1MBpqu8L
         1OiqIwTHKvZHGIYT2Fn7l9kBZVgQ8TDZh0XLvLsi7e0Ia8IwaixBP2+AVJdlEvYr4bdd
         AJLw7HcF7NtfNjAaJU7M+WCkvFEtZg+Y+e2gn7ngjaP2NgD38MXSfCEI7KujMdYk43wL
         IGMTQ/N1dW1VPt//fbBjvAJqJ+kwny1i3W8EM5epUth6q4U1eexJjUiLRgbtjMN3ePDR
         D7Pz4KVer6q3DSxWK8M84cKW0tUjPXmYS8ul+3dGo1t5d1grwqWTKZSXa6JI9dqgfPaG
         dSjw==
X-Gm-Message-State: AOAM5306jz7ARF2iYJdzRMh2r/warBllwkJ0LjjwxWpySZZeHcua6WIT
        Ddvcz4SX5gd5zAgngOJLGLjj4bH7d7SdBYzKo4UwYQ==
X-Google-Smtp-Source: ABdhPJy/zOU6SusIzeYXstSGW7dzX7dyrQcaIhvPkZgmQzp3RsX8yUarNaWljbwomnmrg3aKPJBKEjWGLA6IJpQGUkw=
X-Received: by 2002:aa7:dac4:: with SMTP id x4mr4285140eds.165.1602768235170;
 Thu, 15 Oct 2020 06:23:55 -0700 (PDT)
MIME-Version: 1.0
References: <1602757888-3507-1-git-send-email-loic.poulain@linaro.org> <ec2a1d76-d51f-7ec5-e2c1-5ed0eaf9a537@gmail.com>
In-Reply-To: <ec2a1d76-d51f-7ec5-e2c1-5ed0eaf9a537@gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 15 Oct 2020 15:29:24 +0200
Message-ID: <CAMZdPi93Ma4dGMNr_2JHqYJqDE6VSx6vEpRR3_Y2wbpT1QAvTA@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] net: Add mhi-net driver
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, Hemant Kumar <hemantk@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 at 14:41, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 10/15/20 12:31 PM, Loic Poulain wrote:
> > This patch adds a new network driver implementing MHI transport for
> > network packets. Packets can be in any format, though QMAP (rmnet)
> > is the usual protocol (flow control + PDN mux).
> >
> > It support two MHI devices, IP_HW0 which is, the path to the IPA
> > (IP accelerator) on qcom modem, And IP_SW0 which is the software
> > driven IP path (to modem CPU).
> >
> >
> > +static int mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
> > +{
> > +     struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
> > +     struct mhi_device *mdev = mhi_netdev->mdev;
> > +     int err;
> > +
> > +     skb_tx_timestamp(skb);
> > +
> > +     /* mhi_queue_skb is not thread-safe, but xmit is serialized by the
> > +      * network core. Once MHI core will be thread save, migrate to
> > +      * NETIF_F_LLTX support.
> > +      */
> > +     err = mhi_queue_skb(mdev, DMA_TO_DEVICE, skb, skb->len, MHI_EOT);
> > +     if (err == -ENOMEM) {
> > +             netif_stop_queue(ndev);
>
> If you return NETDEV_TX_BUSY, this means this skb will be requeues,
> then sent again right away, and this will potentially loop forever.

The TX queue is stopped in that case, so the net core will not loop, right?

>
> Also skb_tx_timestamp() would be called multiple times.

OK so I'm going to remove that, maybe the MHI layer should mark
timestamp instead.

>
> I suggest you drop the packet instead.
>
> > +             return NETDEV_TX_BUSY;
> > +     } else if (unlikely(err)) {
> > +             net_err_ratelimited("%s: Failed to queue TX buf (%d)\n",
> > +                                 ndev->name, err);
> > +             mhi_netdev->stats.tx_dropped++;
> > +             kfree_skb(skb);
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
> This code is not correct on a 32bit kernel, since u64 values
> can not be safely be read without extra care.
>
>

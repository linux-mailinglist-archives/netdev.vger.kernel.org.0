Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5232E13A75B
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 11:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbgANK0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 05:26:37 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46950 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgANK0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 05:26:37 -0500
Received: by mail-wr1-f68.google.com with SMTP id z7so11534672wrl.13
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 02:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ekb82sPv/e+oWaCqSE+6RseswRme/6GXQAFq4A4l+0s=;
        b=OxUBEAWiiI64Wvudt3efayAmoC0V/VhbgqD9KCY7W2/b69QZeMPNxVXh1QH/xUqgtA
         Jlf5vWxNBPy683Ta6ntPf0vcAw8INpKsXb94ORwEBklmVzKcY8e0ZRc5N5xdrWbDbB3A
         KhP9zRKsGqQ/MnirWv1kBf5vu/yKitkKc3fJFwHrjlR0EvYPXC8op+62FdTrmf2qCHr6
         EjnOowxukOJNjMkpy1EOic2Y67o6UwrqPLZMB5sPkkY+Qg8SHCqVM2di6OSc24EbN4wG
         U2+7m+sxrOHUXl/jYKSCn6szSJM+aWxUdU5E5YvW8uOMkIViYpmoihjzrk2x7mdaeZTS
         LCHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ekb82sPv/e+oWaCqSE+6RseswRme/6GXQAFq4A4l+0s=;
        b=HqzEQtvPeE3G5QN344acUY0vm/bUATzipbLopYapR5buxIKdrVfMO4wKzmFtQC5W6/
         hc4zAuFnIYSBTPpwetxcKQ4zfjEJypn0Vb/iPmuF7htc4yDiK1wFz+NpZEix0o6cLQNp
         2mXlp8JC09fBljOW1nkFc0XGKVI0RAdsnf8Eg8WsBTBf15JjH8wvAM2f1mHZEIHwL3t2
         /ktUdybABEpRndJ5Q9V6HhU+ddXCgjMETZjEC+1SK8K1aQAOJ6B+E5hmDvLu3uS46xhI
         eW+6/M6GDnckWeWbeKHba6wOdKkYK9M0AGQhq/Md+ztF9j66ZvHVC1H6leC2wZPsT+Gx
         daAw==
X-Gm-Message-State: APjAAAWSgXYXVnlBRvLeXxYg0JCHNbGEJ/aObmspSzGrzh4J05WoYpFj
        32VSXuWlGF3gPMcV1YgNN3lU8V3Uvq5R4RM3fZk=
X-Google-Smtp-Source: APXvYqwZGUYLMg9/AbItGU7IO8FJQtO6B7jnnTYGaXEO019Iw7EUkLTfFo3tcete41ozSt2/jcUzyMpxd0Bk+OOgtgQ=
X-Received: by 2002:a5d:4a8c:: with SMTP id o12mr24101651wrq.43.1578997595230;
 Tue, 14 Jan 2020 02:26:35 -0800 (PST)
MIME-Version: 1.0
References: <1578985340-28775-1-git-send-email-sunil.kovvuri@gmail.com>
 <1578985340-28775-15-git-send-email-sunil.kovvuri@gmail.com> <20200114100812.GA22304@unicorn.suse.cz>
In-Reply-To: <20200114100812.GA22304@unicorn.suse.cz>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Tue, 14 Jan 2020 15:56:23 +0530
Message-ID: <CA+sq2Cc+8bgT8FsvFMOic0TiStgrOGsrA5b0nt84hVS3CVZ7TQ@mail.gmail.com>
Subject: Re: [PATCH v2 14/17] octeontx2-pf: Add basic ethtool support
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kubakici@wp.pl>,
        Christina Jacob <cjacob@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 3:38 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Tue, Jan 14, 2020 at 12:32:17PM +0530, sunil.kovvuri@gmail.com wrote:
> > From: Christina Jacob <cjacob@marvell.com>
> >
> > This patch adds ethtool support for
> >  - Driver stats, Tx/Rx perqueue and CGX LMAC stats
> >  - Set/show Rx/Tx queue count
> >  - Set/show Rx/Tx ring sizes
> >  - Set/show IRQ coalescing parameters
> >
> > Signed-off-by: Christina Jacob <cjacob@marvell.com>
> > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> > ---
> [...]
> > +static void otx2_dev_open(struct net_device *netdev)
> > +{
> > +     otx2_open(netdev);
> > +}
> > +
> > +static void otx2_dev_stop(struct net_device *netdev)
> > +{
> > +     otx2_stop(netdev);
> > +}
>
> Why don't you call these directly?

Will submit VF driver as a follow up, which will result in calling
either otx2_stop or otx2vf_stop.

>
> [...]
> > +/* Get no of queues device supports and current queue count */
> > +static void otx2_get_channels(struct net_device *dev,
> > +                           struct ethtool_channels *channel)
> > +{
> > +     struct otx2_nic *pfvf = netdev_priv(dev);
> > +
> > +     memset(channel, 0, sizeof(*channel));
>
> The structure is already zero initialized in ethtool_get_channels()
> (except for cmd).

Will fix.

>
> > +     channel->max_rx = pfvf->hw.max_queues;
> > +     channel->max_tx = pfvf->hw.max_queues;
> > +
> > +     channel->rx_count = pfvf->hw.rx_queues;
> > +     channel->tx_count = pfvf->hw.tx_queues;
> > +}
> > +
> > +/* Set no of Tx, Rx queues to be used */
> > +static int otx2_set_channels(struct net_device *dev,
> > +                          struct ethtool_channels *channel)
> > +{
> > +     struct otx2_nic *pfvf = netdev_priv(dev);
> > +     bool if_up = netif_running(dev);
> > +     int err = 0;
> > +
> > +     if (!channel->rx_count || !channel->tx_count)
> > +             return -EINVAL;
> > +     if (channel->rx_count > pfvf->hw.max_queues)
> > +             return -EINVAL;
> > +     if (channel->tx_count > pfvf->hw.max_queues)
> > +             return -EINVAL;
>
> The upper bounds are checked in ethtool_set_channels() so that you don't
> get here if requested counts are too high.
>

Will fix.

> > +
> > +     if (if_up)
> > +             otx2_dev_stop(dev);
> > +
> > +     pfvf->hw.rx_queues = channel->rx_count;
> > +     pfvf->hw.tx_queues = channel->tx_count;
> > +     err = otx2_set_real_num_queues(dev, pfvf->hw.tx_queues,
> > +                                    pfvf->hw.rx_queues);
> > +     pfvf->qset.cq_cnt = pfvf->hw.tx_queues +  pfvf->hw.rx_queues;
> > +     if (err)
> > +             return err;
> > +
> > +     if (if_up)
> > +             otx2_dev_open(dev);
>
> Is it intentional that you leave the device down when the change fails?
>
> > +     netdev_info(dev, "Setting num Tx rings to %d, Rx rings to %d success\n",
> > +                 pfvf->hw.tx_queues, pfvf->hw.rx_queues);
> > +
> > +     return err;
> > +}
> > +
> > +static void otx2_get_ringparam(struct net_device *netdev,
> > +                            struct ethtool_ringparam *ring)
> > +{
> > +     struct otx2_nic *pfvf = netdev_priv(netdev);
> > +     struct otx2_qset *qs = &pfvf->qset;
> > +
> > +     ring->rx_max_pending = Q_COUNT(Q_SIZE_MAX);
> > +     ring->rx_pending = qs->rqe_cnt ? qs->rqe_cnt : Q_COUNT(Q_SIZE_256);
> > +     ring->tx_max_pending = Q_COUNT(Q_SIZE_MAX);
> > +     ring->tx_pending = qs->sqe_cnt ? qs->sqe_cnt : Q_COUNT(Q_SIZE_4K);
> > +}
> > +
> > +static int otx2_set_ringparam(struct net_device *netdev,
> > +                           struct ethtool_ringparam *ring)
> > +{
> > +     struct otx2_nic *pfvf = netdev_priv(netdev);
> > +     bool if_up = netif_running(netdev);
> > +     struct otx2_qset *qs = &pfvf->qset;
> > +     u32 rx_count, tx_count;
> > +
> > +     if (ring->rx_mini_pending || ring->rx_jumbo_pending)
> > +             return -EINVAL;
> > +
> > +     /* Permitted lengths are 16 64 256 1K 4K 16K 64K 256K 1M  */
> > +     rx_count = clamp_t(u32, ring->rx_pending,
> > +                        Q_COUNT(Q_SIZE_MIN), Q_COUNT(Q_SIZE_MAX));
>
> The upper bound is checked in ethtool_set_ringparam().
>
> Michal Kubecek
>

Will fix.
Thanks for the feedback.

Sunil.

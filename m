Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E43453C30
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 23:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhKPWTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 17:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbhKPWTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 17:19:33 -0500
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBD2C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 14:16:36 -0800 (PST)
Received: by mail-vk1-xa29.google.com with SMTP id 84so429205vkc.6
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 14:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jf4SRC/tkbDE6DmGdAFfxlKC6TUYlRx3cOWXoYe493c=;
        b=T+DkSYwntzzfNJYE1yhh43stBrIxeaA3aGn5FWco6FdVDV364xMUJvzUALTYYky+Qw
         Oi2LgvDuAxlbGdPscWXw++hLoaUcEXHz8dsQ8vEdwjaJSU/7uRC3J6P4r1cxIHtlJUhQ
         X/1eft99kUdBUYq7RU2vn48ZH6fC3JopoHp3xb8rpg0aEloTsaSlqWXHxGXgXdpdIzLA
         70d3hqF9DMG60gNdeZVovpcit332RoP75d00UnkJ5dI43OOa3MiMZG4WRcvrza1UeCce
         ShzHtMElkVeaioKVtI6X0lo6DfiV/1PPMCMDiwtzzZxiBDGqHHs6GlYAtv0lUMF7qEZI
         5oqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jf4SRC/tkbDE6DmGdAFfxlKC6TUYlRx3cOWXoYe493c=;
        b=hlbv/vm8BdT9kytMaURYkxajsCRaDetf6EiD69ua4oRsRSbfYVBrZm87gQNDGdZOql
         DPilJ6OdElHahiKYLwk5CMOOyrICdPuBnYIhe1v4SZOiJoWno0LUp4s+5BdcrgDIG88E
         vfIh8ZPnJo7B6E1a0OsUpuqOSSGdmgbNuYvPB28QiOlFncaqLgABXH5QdMf4M+1ISkPO
         ASHa9oC9J4Wm/sdWhX0z1fxX5Ajzfbg7PPq/JWOrnJLdBw0tGSiO5uN1KLjiWz6xNNjq
         ugsXjjfCM/Tgi/tYN2bYuxM66q7AwhtcC9eFhjSngq33TeActPPFSUSc4ixg4GIhiUCM
         QoZw==
X-Gm-Message-State: AOAM53204r3CjRvuvgWvrbab+rubyVm+3KmUcRaLNZkp3db8aoE26HVd
        CKZUCczEUxNLMwrYX99gISHsYe4UL7BveiSW/dFQC+CpVUdoNQk02+M=
X-Google-Smtp-Source: ABdhPJzcrJJ0Wi88sJKb05XeSSXFHf2kpeach2bLIiZ6VdNhMtfYHhmrzYT2yMqgjlx3BiWi9XulxDHSGUC8pqHAQxM=
X-Received: by 2002:a05:6122:7d4:: with SMTP id l20mr27322710vkr.9.1637100994947;
 Tue, 16 Nov 2021 14:16:34 -0800 (PST)
MIME-Version: 1.0
References: <20211115205005.6132-1-gerhard@engleder-embedded.com>
 <20211115205005.6132-4-gerhard@engleder-embedded.com> <YZLnhOUg7A66AL5p@lunn.ch>
In-Reply-To: <YZLnhOUg7A66AL5p@lunn.ch>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Tue, 16 Nov 2021 23:16:23 +0100
Message-ID: <CANr-f5y339dz5Q2Qazw_6-q81dXma=fEPQMm2Qfk78AjvhG=7Q@mail.gmail.com>
Subject: Re: [PATCH net-next v5 3/3] tsnep: Add TSN endpoint Ethernet MAC driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static int tsnep_ethtool_get_regs_len(struct net_device *netdev)
> > +{
> > +     struct tsnep_adapter *adapter = netdev_priv(netdev);
> > +     int len;
> > +     int num_queues;
> > +
> > +     len = TSNEP_MAC_SIZE;
> > +     num_queues = max(adapter->num_tx_queues, adapter->num_rx_queues);
> > +     len += TSNEP_QUEUE_SIZE * (num_queues - 1);
>
> Why the num_queues - 1 ? A comment here might be good explaining it.

First queue is within TSNEP_MAC_SIZE. I will add a comment.

>
> > +
> > +     return len;
> > +}
> > +
> > +static void tsnep_ethtool_get_regs(struct net_device *netdev,
> > +                                struct ethtool_regs *regs,
> > +                                void *p)
> > +{
> > +     struct tsnep_adapter *adapter = netdev_priv(netdev);
> > +
> > +     regs->version = 1;
> > +
> > +     memcpy_fromio(p, adapter->addr, regs->len);
> > +}
>
> So the registers and the queues are contiguous?

Yes, unused addresses in between are defined to be readable (zero).

>
> > +static int tsnep_ethtool_get_ts_info(struct net_device *dev,
> > +                                  struct ethtool_ts_info *info)
> > +{
> > +     struct tsnep_adapter *adapter = netdev_priv(dev);
> > +
> > +     info->so_timestamping = SOF_TIMESTAMPING_TX_SOFTWARE |
> > +                             SOF_TIMESTAMPING_RX_SOFTWARE |
> > +                             SOF_TIMESTAMPING_SOFTWARE |
> > +                             SOF_TIMESTAMPING_TX_HARDWARE |
> > +                             SOF_TIMESTAMPING_RX_HARDWARE |
> > +                             SOF_TIMESTAMPING_RAW_HARDWARE;
> > +
> > +     if (adapter->ptp_clock)
> > +             info->phc_index = ptp_clock_index(adapter->ptp_clock);
> > +     else
> > +             info->phc_index = -1;
> > +
> > +     info->tx_types = BIT(HWTSTAMP_TX_OFF) |er is 484kb with test c
> > +                      BIT(HWTSTAMP_TX_ON);
> > +     info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
> > +                        BIT(HWTSTAMP_FILTER_ALL);
> > +
> > +     return 0;
> > +}
>
> You should Cc: Richard Cochran <richardcochran@gmail.com> for the PTP
> parts.

Thanks for the hint. I will add him.

>
> > +static int tsnep_mdio_init(struct tsnep_adapter *adapter)
> > +{
> > +     struct device_node *np = adapter->pdev->dev.of_node;
> > +     int retval;
> > +
> > +     if (np) {
> > +             np = of_get_child_by_name(np, "mdio");
> > +             if (!np)
> > +                     return 0;
> > +
> > +             adapter->suppress_preamble =
> > +                     of_property_read_bool(np, "suppress-preamble");
> > +     }
> > +
> > +     adapter->mdiobus = devm_mdiobus_alloc(&adapter->pdev->dev);
> > +     if (!adapter->mdiobus) {
> > +             retval = -ENOMEM;
> > +
> > +             goto out;
> > +     }
> > +
> > +     adapter->mdiobus->priv = (void *)adapter;
> > +     adapter->mdiobus->parent = &adapter->pdev->dev;
> > +     adapter->mdiobus->read = tsnep_mdiobus_read;
> > +     adapter->mdiobus->write = tsnep_mdiobus_write;
> > +     adapter->mdiobus->name = TSNEP "-mdiobus";
> > +     snprintf(adapter->mdiobus->id, MII_BUS_ID_SIZE, "%s",
> > +              adapter->pdev->name);
> > +
> > +     if (np) {
> > +             retval = of_mdiobus_register(adapter->mdiobus, np);
> > +
> > +             of_node_put(np);
> > +     } else {
> > +             /* do not scan broadcast address */
> > +             adapter->mdiobus->phy_mask = 0x0000001;
> > +
> > +             retval = mdiobus_register(adapter->mdiobus);
>
> You can probably simply this. of_mdiobus_register() is happy to take a
> NULL pointer for np, and will fall back to mdiobus_register().

I will think about it. Driver is also in use with v4.9 and this fallback
does not exist there.

> > diff --git a/drivers/net/ethernet/engleder/tsnep_test.c b/drivers/net/ethernet/engleder/tsnep_test.c
>
> You have quite a lot of code in this file. Could it either be
>
> 1) A loadable module which extends the base driver?
> 2) A build time configuration option?
>
> What percentage of the overall driver binary does this test code take
> up?

Driver is 484kB with test code and 396kB without. So test code is roughly
20% currently. In my opinion a configuration option makes more sense,
because a loadable module would require exported symbols. Shall I add a
build time configuration option?

> Apart from the minor comments above, ethtool, mdio, phy all looks
> good.

Thanks!

Gerhard

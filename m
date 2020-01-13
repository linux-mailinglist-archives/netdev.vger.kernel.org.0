Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E10DB13900B
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 12:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgAML1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 06:27:19 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41974 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgAML1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 06:27:19 -0500
Received: by mail-wr1-f65.google.com with SMTP id c9so8150485wrw.8
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 03:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hv7WalCUQbzbA3pi5aBe19DfUwpwwtqRi1L3/cTZpV8=;
        b=UfpIgxFvikOw0QXiJN2s2mqitwfz9W9a9QZR8WXRLsipMErwiV/fRbrLP9gdjGwavM
         QOsndAxmFf59+AxRNuTNfhvZ2axBV+X5l5DZjWkqrgROckljezXn4q8qLCt2dc1t7yY4
         wVN+/AFJ4K2f9yGAYWAzpcRmQVbtIc1gr5yVKgfBWcivB04D+U9OvaVOcHOnoxPeLcKr
         vAsgLLfGJQwpvEoLcUBDZs9FEHuY2jjeqpB0r4YJAzSPkYNuuYuCKuSsMk7xHB56AhSI
         XeWNFVHYzw1OQzL9+gj71JcpFu31Xujd3IhlI3xCqv9mHFL9tP4aVP19/Us5G2MrQQjM
         TSOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hv7WalCUQbzbA3pi5aBe19DfUwpwwtqRi1L3/cTZpV8=;
        b=jSDXwhmON/eqdYoSOrCBK3LkYxOnYRelC6UGFmOvDNngn8Yqj9g0pD8Pl9NPqxMt5X
         S0eXEIEfBG+A7cwn9QnhpgwPtLR6co4CuClQaOnOfFmLD4gpjM+yLpWoJ5S5MXLp31WX
         RIadqeLGiq4B85lgCgV5KLMFpp/XV/dxLoN36A629V9fDc6ysZqzWj+2GxNfmUI068OI
         MFXyyU5tsYoWMWSRXhFW2HC8W0aGVi/YKq1y5N+mFaymeKplRSILOW9zRM9Eq7b5ZGuS
         J0XhP1zfT4lnR/JY+99faCOip76dT0Mp3yRUdt7HC5WY7kJKHdeesX4C50SIV5gfWA4c
         kGfg==
X-Gm-Message-State: APjAAAWvf06KRFlE2Men4jeBIqGwFhbMhPjIZCb6t4gd9SlmBndPWKwB
        JUNTWqqovM58XW/7+whrZkuWH/L+zERojp7T/fTUm0xr
X-Google-Smtp-Source: APXvYqxdBAaDlpuUIpKZcugWYJjGLp9r2YD0t9P5YoePQ6OFo7BDgI6ks4kHlS8oQpU/4Xw2cc17JQhh5O/OOpbJpwM=
X-Received: by 2002:a5d:4a8c:: with SMTP id o12mr17885651wrq.43.1578914837781;
 Mon, 13 Jan 2020 03:27:17 -0800 (PST)
MIME-Version: 1.0
References: <1578656521-14189-1-git-send-email-sunil.kovvuri@gmail.com>
 <1578656521-14189-15-git-send-email-sunil.kovvuri@gmail.com>
 <20200110112808.4970c92e@cakuba.netronome.com> <CA+sq2Ccr5jB1cBN62Y56C=19L-P7hgYPrD9o7EJN71Kroou9Ew@mail.gmail.com>
 <20200111052724.768f5e25@cakuba.netronome.com>
In-Reply-To: <20200111052724.768f5e25@cakuba.netronome.com>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Mon, 13 Jan 2020 16:57:06 +0530
Message-ID: <CA+sq2CcCSX4NuoyZZ020xH75s1+ii5Xc6XM5jAovUTpQtaZXfQ@mail.gmail.com>
Subject: Re: [PATCH 14/17] octeontx2-pf: Add basic ethtool support
To:     Jakub Kicinski <kubakici@wp.pl>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Christina Jacob <cjacob@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 11, 2020 at 6:57 PM Jakub Kicinski <kubakici@wp.pl> wrote:
>
> On Sat, 11 Jan 2020 14:17:45 +0530, Sunil Kovvuri wrote:
> > On Sat, Jan 11, 2020 at 12:58 AM Jakub Kicinski wrote:
> > > On Fri, 10 Jan 2020 17:11:58 +0530, sunil.kovvuri@gmail.com wrote:
> > > > +static const struct otx2_stat otx2_dev_stats[] = {
> > > > +     OTX2_DEV_STAT(rx_bytes),
> > > > +     OTX2_DEV_STAT(rx_frames),
> > > > +     OTX2_DEV_STAT(rx_ucast_frames),
> > > > +     OTX2_DEV_STAT(rx_bcast_frames),
> > > > +     OTX2_DEV_STAT(rx_mcast_frames),
> > > > +     OTX2_DEV_STAT(rx_drops),
> > > > +
> > > > +     OTX2_DEV_STAT(tx_bytes),
> > > > +     OTX2_DEV_STAT(tx_frames),
> > > > +     OTX2_DEV_STAT(tx_ucast_frames),
> > > > +     OTX2_DEV_STAT(tx_bcast_frames),
> > > > +     OTX2_DEV_STAT(tx_mcast_frames),
> > > > +     OTX2_DEV_STAT(tx_drops),
> > > > +};
> > >
> > > Please don't duplicate the same exact stats which are exposed via
> > > ndo_get_stats64 via ethtool.
> >
> > ndo_stats64 doesn't have separate stats for ucast, mcast and bcast on Rx and
> > Tx sides, they are combined ones. Hence added separate stats here.
> > The ones repeated here are bytes, frames and drops which are added to have
> > full set of stats at one place which could help anyone debugging pkt
> > drop etc issues.
>
> Same exact as in bytes, frames, and drops are exactly the same rather
> than e.g. one being counted by hardware and the other by software.
>
> No objection to reporting the *cast stats broken out via ethtool.

I am not getting what your objection here is, what's reported via stats64 and
ethtool both are counted by hardware. I have checked other NIC drivers and they
also do report overall pkts, bytes, drop counters via ethtool.

Is there any harm in reporting this way ?

Thanks,
Sunil.

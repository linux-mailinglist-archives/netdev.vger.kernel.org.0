Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2143F5C5F2
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 01:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfGAXhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 19:37:53 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40266 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfGAXhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 19:37:53 -0400
Received: by mail-lf1-f65.google.com with SMTP id a9so9978544lff.7
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 16:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TBZqhIlIwucJVNZiOvR5Y4usnX+cgp8LLY3+Sts9iIQ=;
        b=sBZYA9LdCeYShxcEagT6sfC4bqVMjcAjLCuISb/myuIEHHK3+k1VjzkSWKapcQ2o0j
         0Ff9zFLjD6WflQ0Q6I4AqDf23Q0owrSmVj+D8f7ZShOkvczVEjesPiQrlckgCUzkvRdk
         Vo6uEpuSIdumoSHT+C8sJXCVQMP4Hi834wmn4bwVAyxTSOzkgiZbR+2R6t/KfIXhv/CE
         QtoOZDxDKCvGUcd40yEAFUSJv1AYu046P+8NdZPj8PSak7bkMwH/I7JAt1cTY6aRGZoO
         LOe+lgWdnMDRNiwU0tXohtihd4H26VtHMwy3NkSHjxuUBlZDXdepqrMMZwx0rIp3o17T
         Yvtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TBZqhIlIwucJVNZiOvR5Y4usnX+cgp8LLY3+Sts9iIQ=;
        b=TrRnEYjUYEftEou2ytDjfpo5+4F7KrhnR0/snRh+r9uLH/rgNHvC0DLbxGbponFnVD
         XRvATo1T0Z2NLAoXzhhRLS9bIIOE1f0bD1urxtFZb1plHB5u/jAYr3WaKVUlR+9Heqzy
         XaAuz97fVzNGHb+sRl263/Q8jFPAXPnILeZ65GkhwzAKmflE2RH0AHpPpmPK5Ox0xJZJ
         /JvEqNbtCelHZM10zzwPVbKHvZCWoOtl43joeZ1glMMAP2f3HmJrP1dN5SB9phFHRYmP
         xienYc56bzrz+ysd8kBbGD8NF3mWAqYOEhVlMfGyVntSTR2bES3Ubp5CgZl9/IG0Rxrw
         5ZYw==
X-Gm-Message-State: APjAAAVmdKc8xdacW1jcQkQkupAlcEa5xbu5GEdX6F+Qk6QHYNGhRgoH
        6GIF5EZFFoNJgALJ/cBMAjD1VSramkQ+J/2Ktk5mtwmutOo=
X-Google-Smtp-Source: APXvYqwmjnCUkAoiADKbdmHNdYLh9rQ6F71IWN3TCHT10Dyq15EReh7P/vsnNPLvqO3bQh9H0rs0MfyfbpdSwPZhBBs=
X-Received: by 2002:ac2:546a:: with SMTP id e10mr13173789lfn.75.1562024270904;
 Mon, 01 Jul 2019 16:37:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190626185251.205687-1-csully@google.com> <20190626185251.205687-5-csully@google.com>
 <efa71935-3ec3-0df9-2d9c-25cb9e134a40@gmail.com>
In-Reply-To: <efa71935-3ec3-0df9-2d9c-25cb9e134a40@gmail.com>
From:   Catherine Sullivan <csully@google.com>
Date:   Mon, 1 Jul 2019 16:37:38 -0700
Message-ID: <CAH_-1qyTJXNOABbwMa6tftNnLZTkMwv6shAdLVDZQiBjBuMUpg@mail.gmail.com>
Subject: Re: [net-next 4/4] gve: Add ethtool support
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 7:44 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 6/26/2019 11:52 AM, Catherine Sullivan wrote:
>
> [snip]
>
> > +static void
> > +gve_get_ethtool_stats(struct net_device *netdev,
> > +                   struct ethtool_stats *stats, u64 *data)
> > +{
> > +     struct gve_priv *priv = netdev_priv(netdev);
> > +     u64 rx_pkts, rx_bytes, tx_pkts, tx_bytes;
> > +     int ring;
> > +     int i;
> > +
> > +     ASSERT_RTNL();
> > +
> > +     if (!netif_carrier_ok(netdev))
> > +             return;
> > +
> > +     for (rx_pkts = 0, rx_bytes = 0, ring = 0;
> > +          ring < priv->rx_cfg.num_queues; ring++) {
> > +             rx_pkts += priv->rx[ring].rpackets;
> > +             rx_bytes += priv->rx[ring].rbytes;
> > +     }
> > +     for (tx_pkts = 0, tx_bytes = 0, ring = 0;
> > +          ring < priv->tx_cfg.num_queues; ring++) {
> > +             tx_pkts += priv->tx[ring].pkt_done;
> > +             tx_bytes += priv->tx[ring].bytes_done;
> > +     }
>
> Maybe you do not need to support 32-bit guests with that driver, but you
> might as well be correct and use the include/linux/u64_stats_sync.h
> primitives to help return consistent 64-bit stats on 32-bit machines.

Done in v4, thanks.

>
> [snip]
>
> > +int gve_adjust_queues(struct gve_priv *priv,
> > +                   struct gve_queue_config new_rx_config,
> > +                   struct gve_queue_config new_tx_config)
> > +{
> > +     int err;
> > +
> > +     if (netif_carrier_ok(priv->dev)) {
>
> Should not that be netif_running()?
> --
> Florian

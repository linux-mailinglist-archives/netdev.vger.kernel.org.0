Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCF1CFE91
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 18:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbfJHQK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 12:10:29 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:40056 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbfJHQK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 12:10:29 -0400
Received: by mail-yb1-f194.google.com with SMTP id s7so2485275ybq.7
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 09:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y2n+BzTATXcFbTW9QF3jAn79Pd21PLX0/vC10EYpkM8=;
        b=tUTTtll8j0Hh+dmuhNpzxcNiDcGHJE7UekqpF2t8FlbeGIs6l3q31rvmbDvgblZRmD
         /uNypT6z0upV4jwyDEsxBQkljvbS2tJO1IZd/o3z6PtYODz9GYUtMxuSeaW1qyrsVWz2
         OISwAnpU4oMKodoFjFGEbW86qLJmBCIqa41JxGMi9wQ0r7ukgZLQhw+vl/DhzK/CdDi4
         651UrkwHO8O1zffF71nIeHDQFR/X0DsvC65G/hFtO/7SS2tMt2LH6KhNitHMhykgbxRL
         bMnvExTkFF64Y/IRiyQHH+6eiwnCfyl+VAfoDehOtCVtPLEqPXkHy7Yx7Uurgc5iYO4Q
         ASbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y2n+BzTATXcFbTW9QF3jAn79Pd21PLX0/vC10EYpkM8=;
        b=AHH+CeHZFLaUiwwCJC2nHjDfI1GFLCWvtKPKBH49UEfDZTyPpGvtvE8sflZG8HMcxK
         GDIZkUr4nmnz6W4fO5Lv+OY0dGyEadiX1CV519HldXheUNsKHKra9Q0BAccxp9M+FyRI
         /6nfxDWD3lFgFpdND2OAtmbsmNmuN1nVjfArbMR48lJbCI+AcmpprsIU2emqx6MGahMW
         RqdWOJ4EtKdt5Cp+L1kWz2xcRAJ5rcFRtw1wCOMRckunxmB8IzF6ZfzDtWNa2KF6R9ub
         p9RBvO/mc1CLsRqlpYjd4subRiGElLNeb2W0AMfWjwh26BKR2MoHCUA2DOpe8gVnv/nF
         jBWQ==
X-Gm-Message-State: APjAAAV12uM7oHSyFUcT/3VGfBKDXe3+30z/mM2aOcEgh9iBYqzlOJIb
        luh3qXak4AQO92lAc+oqJyCkmpVr
X-Google-Smtp-Source: APXvYqyacQQ3X/YsfjSpHgUx8tAPpgubGcRGMf72DprWM1SRUnsM+wIskQw67tz79Qsf/63R2Uk7Lw==
X-Received: by 2002:a25:d213:: with SMTP id j19mr388914ybg.471.1570551027079;
        Tue, 08 Oct 2019 09:10:27 -0700 (PDT)
Received: from mail-yw1-f51.google.com (mail-yw1-f51.google.com. [209.85.161.51])
        by smtp.gmail.com with ESMTPSA id m62sm4602214ywf.70.2019.10.08.09.10.25
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2019 09:10:25 -0700 (PDT)
Received: by mail-yw1-f51.google.com with SMTP id s6so6621989ywe.5
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 09:10:25 -0700 (PDT)
X-Received: by 2002:a81:3182:: with SMTP id x124mr23114565ywx.411.1570551025109;
 Tue, 08 Oct 2019 09:10:25 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570455278.git.martinvarghesenokia@gmail.com> <1da8fb9d3af8dcee1948903ae816438578365e51.1570455278.git.martinvarghesenokia@gmail.com>
In-Reply-To: <1da8fb9d3af8dcee1948903ae816438578365e51.1570455278.git.martinvarghesenokia@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 8 Oct 2019 12:09:49 -0400
X-Gmail-Original-Message-ID: <CA+FuTSc_L_2sGSvSOtF2t6rKFenNp+L-0YBjqhTT6_NZBS9XJQ@mail.gmail.com>
Message-ID: <CA+FuTSc_L_2sGSvSOtF2t6rKFenNp+L-0YBjqhTT6_NZBS9XJQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] Special handling for IP & MPLS.
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 8, 2019 at 5:52 AM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> From: Martin <martin.varghese@nokia.com>
>

This commit would need a commit message.

> Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>
>
> Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>
> ---
>  Documentation/networking/bareudp.txt | 18 ++++++++
>  drivers/net/bareudp.c                | 82 +++++++++++++++++++++++++++++++++---
>  include/net/bareudp.h                |  1 +
>  include/uapi/linux/if_link.h         |  1 +
>  4 files changed, 95 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/networking/bareudp.txt b/Documentation/networking/bareudp.txt
> index d2530e2..4de1022 100644
> --- a/Documentation/networking/bareudp.txt
> +++ b/Documentation/networking/bareudp.txt
> @@ -9,6 +9,15 @@ The Bareudp tunnel module provides a generic L3 encapsulation tunnelling
>  support for tunnelling different L3 protocols like MPLS, IP, NSH etc. inside
>  a UDP tunnel.
>
> +Special Handling
> +----------------
> +The bareudp device supports special handling for MPLS & IP as they can have
> +multiple ethertypes.

Special in what way?

> +MPLS procotcol can have ethertypes 0x8847 (unicast) & 0x8847 (multicast).

0x8848. Use ETH_P_MPLS_UC and ETH_P_MPLS_MC instead of hard coding constants.

> +IP proctocol can have ethertypes 0x0800 (v4) & 0x866 (v6).
> +This special handling can be enabled only for ethertype 0x0800 & 0x88847 with a

Again typo.

> +flag called extended mode.
> +
>  Usage
>  ------
>
> @@ -21,3 +30,12 @@ This creates a bareudp tunnel device which tunnels L3 traffic with ethertype
>  The device will listen on UDP port 6635 to receive traffic.
>
>  b. ip link delete bareudp0
> +
> +2. Device creation with extended mode enabled
> +
> +There are two ways to create a bareudp device for MPLS & IP with extended mode
> +enabled
> +
> +a. ip link add dev  bareudp0 type bareudp dstport 6635 ethertype 0x8847 extmode 1
> +
> +b. ip link add dev  bareudp0 type bareudp dstport 6635 ethertype mpls
> diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
> index 7e6813a..2a688da 100644
> --- a/drivers/net/bareudp.c
> +++ b/drivers/net/bareudp.c
> @@ -48,6 +48,7 @@ struct bareudp_dev {
>         struct net_device  *dev;        /* netdev for bareudp tunnel */
>         __be16             ethertype;
>         u16                sport_min;
> +       bool               ext_mode;
>         struct bareudp_conf conf;
>         struct bareudp_sock __rcu *sock4; /* IPv4 socket for bareudp tunnel */
>  #if IS_ENABLED(CONFIG_IPV6)
> @@ -82,15 +83,64 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
>                 goto drop;
>
>         bareudp = bs->bareudp;
> -       proto = bareudp->ethertype;
> +       if (!bareudp)
> +               goto drop;
> +
> +       if (bareudp->ethertype == htons(ETH_P_IP)) {
> +               struct iphdr *iphdr;
> +
> +               iphdr = (struct iphdr *)(skb->data + BAREUDP_BASE_HLEN);
> +               if (iphdr->version == 4) {
> +                       proto = bareudp->ethertype;
> +               } else if (bareudp->ext_mode && (iphdr->version == 6)) {
> +                       proto = htons(ETH_P_IPV6);

Verified packet length before reading at offset? Why does v6 needs
extended mode, while v4 does not?

For any packet encapsulated in UDP, the inner packet type will be
unknown, so needs to be configured on the device. That is not a
special feature. FOU gives an example. My main concern is that this
introduces a lot of code that nearly duplicates existing tunneling
support. It is not clear to me that existing logic cannot be
reused/extended.

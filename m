Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168AA380B4F
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 16:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbhENOPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 10:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbhENOPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 10:15:51 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA37C061574;
        Fri, 14 May 2021 07:14:39 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id l7so38984772ybf.8;
        Fri, 14 May 2021 07:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nttpRZs1g+ECIwTlOlKEVgc7K4EvlGQDJ8iK+5sNCik=;
        b=kcCKtQO1X5QpY9ffYMYFxFLZ0g9MnaVd9kYBpNpvbYaGJ0uTg59WF6nlEaxuZzd9hU
         3zzv1z5FAVOjcKUpF5qrRD4Zz9k+v87ZNv/eM7LPcjTB+ycux/SAmHMTVfREd99Rr+jF
         2FtrTE9ynDWoQoVIg2itwrA3Rpl0LZwnfgrWQC8Xe/bzLMBAWIF8bVpM4i6Ah4UFx1V6
         Tw90gW6ijsTPEl4WQNwUHLZA+9uji3Z3znbDi3mnaLp5YutGptBnZCSHtZarjmdh8YPN
         GAHc9zi13f2A7LSgFgm5P9G+IIr5WmQsUIy707kYBQamN7ivUsCdO2WBd7H8cGZTvyGk
         NNgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nttpRZs1g+ECIwTlOlKEVgc7K4EvlGQDJ8iK+5sNCik=;
        b=fu+BkS6/hSnyZF2FJvkbhuftp3uYFmuGbvA49i7YALR3LhZu0DLb1z6/d95tTUoa/Q
         Ohu+12zDJZXQVUvzpy7o4ByYYpd6MswtUljhc+6yJ6fx5dssMQzf9/5n9v7frmfMGlh9
         Ersp3SZwjr45hxNzpuyTAA9NrLjVzxOmepiEQ0bv/0MA/NqQBdn2SkqV64xLWow1wBGa
         cYezuZNht0ClOyh06h+7MAeh7OKZpFgc6SXM4Ka3w7Z/zwzY9LR+PwIxx+PNJ9+cHn2/
         eW4ZEslRx51O80bcSgRqr0Jd5kwEkdWTHDHllJKGPNwKDfafLdstnE4F9F35k8kpTqZE
         gLZQ==
X-Gm-Message-State: AOAM533vvVimSgdJjpQHt22xHMXqBuexMbDmIUT8J08XYFKYq541n7Rl
        ldD8JfSUvs7RTUQXLm4eSqKsPqK6TbbW4SobVgA=
X-Google-Smtp-Source: ABdhPJzi3HRVqzFQJgeSHMexWxFS1Qng1v69CknCeldIP8G2COuQM0zsJD/5JbMl1mLIPs0Mmo2s/ImzTJn6iPEw14M=
X-Received: by 2002:a25:4241:: with SMTP id p62mr52757613yba.141.1621001679203;
 Fri, 14 May 2021 07:14:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210514115826.3025223-1-pgwipeout@gmail.com> <YJ56G23e930pg4Iv@lunn.ch>
In-Reply-To: <YJ56G23e930pg4Iv@lunn.ch>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Fri, 14 May 2021 10:14:27 -0400
Message-ID: <CAMdYzYrSB0G7jfG9fo85X0DxVG_r-qaWUyVAa5paAW0ugLvoxw@mail.gmail.com>
Subject: Re: [PATCH v3] net: phy: add driver for Motorcomm yt8511 phy
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 9:24 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Fri, May 14, 2021 at 07:58:26AM -0400, Peter Geis wrote:
> > Add a driver for the Motorcomm yt8511 phy that will be used in the
> > production Pine64 rk3566-quartz64 development board.
> > It supports gigabit transfer speeds, rgmii, and 125mhz clk output.
>
> Thanks for adding RGMII support.
>
> > +#define PHY_ID_YT8511                0x0000010a
>
> No OUI in the PHY ID?
>
> Humm, the datasheet says it defaults to zero. That is not very
> good. This could be a source of problems in the future, if some other
> manufacture also does not use an OUI.
>
> > +/* RX Delay enabled = 1.8ns 1000T, 8ns 10/100T */
> > +#define YT8511_DELAY_RX              BIT(0)
> > +
> > +/* TX Delay is bits 7:4, default 0x5
> > + * Delay = 150ps * N - 250ps, Default = 500ps
> > + */
> > +#define YT8511_DELAY_TX              (0x5 << 4)
>
> > +
> > +     switch (phydev->interface) {
> > +     case PHY_INTERFACE_MODE_RGMII:
> > +             val &= ~(YT8511_DELAY_RX | YT8511_DELAY_TX);
> > +             break;
>
> This is not correct. YT8511_DELAY_TX will only mask the 2 bits in 0x5,
> not all the bits in 7:4. And since the formula is
>
> Delay = 150ps * N - 250ps
>
> setting N to 0 is not what you want. You probably want N=2, so you end up with 50ps

The manufacturer's driver set this to <0> to disable, but I agree the
datasheet disagrees with this.

>
> > +     case PHY_INTERFACE_MODE_RGMII_ID:
> > +             val |= YT8511_DELAY_RX | YT8511_DELAY_TX;
> > +             break;
> > +     case PHY_INTERFACE_MODE_RGMII_RXID:
> > +             val &= ~(YT8511_DELAY_TX);
> > +             val |= YT8511_DELAY_RX;
>
> The delay should be around 2ns. For RX you only have 1.8ns, which is
> probably good enough. But for TX you have more flexibility. You are
> setting it to the default of 500ps which is too small. I would suggest
> 1.85ns, N=14, so it is the same as RX.

Makes sense, these are the insights I was hoping for!

>
> I also wonder about bits 15:12 of PHY EXT ODH: Delay and driver
> strength CFG register.

The default value *works*, and from an emi perspective we want the
lowest strength single that is reliable.
Unfortunately I don't have the equipment to *test* the actual output
strengths and the datasheet isn't explicitly clear about them either.
This is one of the values I was considering having defined in the devicetree.

>
>          Andrew

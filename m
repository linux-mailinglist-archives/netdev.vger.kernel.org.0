Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6843380B25
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 16:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbhENOKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 10:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234177AbhENOKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 10:10:43 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD455C06174A;
        Fri, 14 May 2021 07:09:30 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id m9so39057392ybm.3;
        Fri, 14 May 2021 07:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Otk7mMiSc5A5v5B8dOYgVn2Dr/WcLxHSnAJOb5ykiJo=;
        b=o4vcd6YLzAV5hIR888IZxIQTBfO7VGvGH0dFK+chAvKgiX1CnalEE45VV3VFSfsMyD
         ivwRRQVHidAtYS3702n6ZEzdgSTldrjE0GcpZ6/PBqzPt38dIrZHfOLvkH6OSiKRvWkh
         Kx1XKRvUIyP1lk+koKPKdnhKi44jj0oZ9HecrsdlatSlAPpVEvnvxaquhr3tSDQcw40C
         0Y/0dlCQFVRV4+Sk0Fdsrk0OrZ96uF6Pz5uU2T+eNhIF3xDtbyOJIQ7VWtQ0SMdj96i6
         mfOpX7EqqWjAR+RHRThg7qr5CP5HOwk+pOl4qMX0fm/BxXwJL0/WiVBxRLM9jJvQ2TBO
         xxxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Otk7mMiSc5A5v5B8dOYgVn2Dr/WcLxHSnAJOb5ykiJo=;
        b=AkE3yJtVQVWY3IYbrms3GOvkx7Iu45cPkMqHJdONkCMujvmw9ekcleOhgl/s/BPn3C
         WT0oFKIod2Y5MV++9LmYBYmwjJpb5exVsTnd9cR/xHB4ijR9NcmJAa5OZKwEcQ1IaEmY
         f4aFXlyFzGS01LAdwIKpBnlItgegLuzRPW4u4vygmrEIWWRoNXfoYIxa7glPCl/AIe1p
         aeVm4IiPQJn3gs6RYA4BRJsIZ0C0ZVj3nJp1pz1g1ktDmqrwqb8LXTFmFXVoPVRdNHf0
         MT2OIKiy6BBz3JHnJ4h4Q8gJS72AHN0S++QoOg7jrDFw42JKc884kOmq55BzAIViVjC0
         vpCA==
X-Gm-Message-State: AOAM5311F3VPVYSwn86w7ScUSb8F6QNOm/eUzU33T9+8XOKDi5QnNl//
        3stUdRYpD15mZqkACdtDoY4FQDBLnUAlsu4ufA4=
X-Google-Smtp-Source: ABdhPJzDd/2DcOIs+kq2kBBNEw4Yh0u/Eq93ffNmw8V2bV3zYPrRg2hFsFr6eQcNA5Mwh2OWwfVYTaHftdfjVboC698=
X-Received: by 2002:a25:4d56:: with SMTP id a83mr57107356ybb.437.1621001370174;
 Fri, 14 May 2021 07:09:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210514115826.3025223-1-pgwipeout@gmail.com> <20210514130908.GD12395@shell.armlinux.org.uk>
In-Reply-To: <20210514130908.GD12395@shell.armlinux.org.uk>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Fri, 14 May 2021 10:09:18 -0400
Message-ID: <CAMdYzYqQ4gaFRD8wbdm9PRpT-ZeiL6WVj_eHKnF_uF=mKx3A4g@mail.gmail.com>
Subject: Re: [PATCH v3] net: phy: add driver for Motorcomm yt8511 phy
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 9:09 AM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> Hi!
>
> On Fri, May 14, 2021 at 07:58:26AM -0400, Peter Geis wrote:
> > +     /* set rgmii delay mode */
> > +     val = __phy_read(phydev, YT8511_PAGE);
> > +
> > +     switch (phydev->interface) {
> > +     case PHY_INTERFACE_MODE_RGMII:
> > +             val &= ~(YT8511_DELAY_RX | YT8511_DELAY_TX);
> > +             break;
> > +     case PHY_INTERFACE_MODE_RGMII_ID:
> > +             val |= YT8511_DELAY_RX | YT8511_DELAY_TX;
> > +             break;
> > +     case PHY_INTERFACE_MODE_RGMII_RXID:
> > +             val &= ~(YT8511_DELAY_TX);
> > +             val |= YT8511_DELAY_RX;
> > +             break;
> > +     case PHY_INTERFACE_MODE_RGMII_TXID:
> > +             val &= ~(YT8511_DELAY_RX);
> > +             val |= YT8511_DELAY_TX;
> > +             break;
> > +     default: /* leave everything alone in other modes */
> > +             break;
> > +     }
> > +
> > +     ret = __phy_write(phydev, YT8511_PAGE, val);
> > +     if (ret < 0)
> > +             goto err_restore_page;
>
> Another way of writing the above is to set "val" to be the value of the
> YT8511_DELAY_RX and YT8511_DELAY_TX bits, and then do:
>
>         ret = __phy_modify(phydev, YT8511_PAGE,
>                            (YT8511_DELAY_RX | YT8511_DELAY_TX), val);
>         if (ret < 0)
>                 goto err_restore_page;
>
> which moves the read-modify-write out of the driver into core code and
> makes the driver code smaller. It also handles your missing error check
> on __phy_read() above - would you want the above code to attempt to
> write a -ve error number back to this register? I suspect not!

That makes sense, thanks!
I was thinking about how to use __phy_modify with a functional mask,
but it didn't click until I had already sent it in.
Also thanks for catching handling that ret on the read!

>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

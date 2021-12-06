Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B3E4690D7
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 08:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbhLFHhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 02:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhLFHhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 02:37:11 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2132AC0613F8;
        Sun,  5 Dec 2021 23:33:43 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id t19so19954178oij.1;
        Sun, 05 Dec 2021 23:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qbQOEnp7jKLZani9Wx1QX+x+WkgHU+tLTxDI3J7bzuI=;
        b=ROribbjD5fxJf1MFXwniwLkjwmwC8+ub60xi/nyvrN3OKldETxJSC0F4nY/4JvklD2
         aWhYXWCVI3XcmHFQv+ZDgHwIS0Tsjf5/gIaMg5OvT/xCV46Dm3eaxXNPf/OoC91KXjLY
         EnpoIjKDTEZByQJ5ABmbmmAHSIiy4K5bOYoRdBL5TkutMAnYJt98yniWRBAclrjksvC3
         vbG19YmwqW+3vdRMOoOIr2X/DCS6D4ie+/vynZzTS9R9UjD5BWY5swYHkQhwm0WKFo6g
         OBY0Heo5U3Hs2xibGKCE1bFFsuk1+f87HbTE+pGADV/+kI3KgMQGOo2YEIqpORX4yw/J
         AjVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qbQOEnp7jKLZani9Wx1QX+x+WkgHU+tLTxDI3J7bzuI=;
        b=T9fA52xjMecFtRpx9jyb9tk/kRmzqsyg1ABxlogNbOEBwyEnRUTIxqFDM32ujrkAUa
         a8EhmeWuQYvPKADsUhDvSF4ACIInHvH4PyIRKR2CLJDS0mm+nrpOsr0V8Z07Q28YM9Dr
         xAGnUuz5yPNgs+dhOuDdegcPXheSL1kHbn33TjCCHJ2dNbli6vPtMn7mA0MD0H7889Bk
         idUdce88rRSxqqKgfZMn+ZtJOI2iW2lOHo8xVMRTs3IcOLzM0ESjF1SpyKwDz2uOd604
         M8a+kYVdld13B6l3KL2tHiDWA9ecGhQWczdYRoSY7jTFGN8I06kIOJHN4ZRRPIFNjye+
         C2pw==
X-Gm-Message-State: AOAM531oYA038K+w/DwgV3R9gYgNWNLDn25bhk6eztdYWbtTAFkWs9+v
        Hhr+fopjTSMbl5tVVvh0U+UcFmMuHoY1IXYx0rUqr8xzfYo2/wsRvKTAvA==
X-Google-Smtp-Source: ABdhPJxI5DBy/Fy+Kke48ATG6vvyfO3nqVb4GfutvgIYoPR8fdG4jQw00z+tQLnbp+/vLfFZniat+S2seT1yyaPpnlc=
X-Received: by 2002:a05:6808:1709:: with SMTP id bc9mr22375987oib.130.1638776022420;
 Sun, 05 Dec 2021 23:33:42 -0800 (PST)
MIME-Version: 1.0
References: <YazChnNvaEMHzCQG@shell.armlinux.org.uk> <431bf51d-9ed5-a235-99e1-99dee50f7925@gmail.com>
In-Reply-To: <431bf51d-9ed5-a235-99e1-99dee50f7925@gmail.com>
From:   yanteng si <siyanteng01@gmail.com>
Date:   Mon, 6 Dec 2021 15:33:31 +0800
Message-ID: <CAEensMxA=-wWV_38SyKH07SREKPwpEHRkEmbqZ64+iTXn+S=ug@mail.gmail.com>
Subject: Re: [PATCH] net: phy: Remove unnecessary indentation in the comments
 of phy_device
To:     Akira Yokosawa <akiyks@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        netdev@vger.kernel.org, Yanteng Si <siyanteng@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Akira Yokosawa <akiyks@gmail.com> =E4=BA=8E2021=E5=B9=B412=E6=9C=885=E6=97=
=A5=E5=91=A8=E6=97=A5 23:33=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi,
> On Sun, 5 Dec 2021 13:45:42 +0000, Russell King wrote:
> > On Sun, Dec 05, 2021 at 09:21:41PM +0800, Yanteng Si wrote:
> >> Fix warning as:
> >>
> >> linux-next/Documentation/networking/kapi:122: ./include/linux/phy.h:54=
3: WARNING: Unexpected indentation.
> >> linux-next/Documentation/networking/kapi:122: ./include/linux/phy.h:54=
4: WARNING: Block quote ends without a blank line; unexpected unindent.
> >> linux-next/Documentation/networking/kapi:122: ./include/linux/phy.h:54=
6: WARNING: Unexpected indentation.
> >
> > This seems to be at odds with the documentation in
> > Documentation/doc-guide/kernel-doc.rst.
> >
> > The warning refers to lines 543, 544 and 546.
> >
> > 543: *              Bits [23:16] are currently reserved for future use.
> > 544: *              Bits [31:24] are reserved for defining generic
> > 545: *                           PHY driver behavior.
> > 546: * @irq: IRQ number of the PHY's interrupt (-1 if none)
> >
> > This doesn't look quite right with the warning messages above, because
> > 544 doesn't unindent, and I've checked net-next, net, and mainline
> > trees, and they're all the same.
> >
> > So, I think we first need to establish exactly which lines you are
> > seeing this warning for before anyone can make a suggestion.
>
> Just a hint of kernel-doc comment format, which is not fully covered
> in Documentation/doc-guide/kernel-doc.rst.
>
> I think the diff below is what you'd like:
Yeah! Thank you very much!
>
> ----8<-----
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 96e43fbb2dd8..1e180f3186d5 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -538,11 +538,12 @@ struct macsec_ops;
>   * @mac_managed_pm: Set true if MAC driver takes of suspending/resuming =
PHY
>   * @state: State of the PHY for management purposes
>   * @dev_flags: Device-specific flags used by the PHY driver.
> - *             Bits [15:0] are free to use by the PHY driver to communic=
ate
> - *                         driver specific behavior.
> - *             Bits [23:16] are currently reserved for future use.
> - *             Bits [31:24] are reserved for defining generic
> - *                          PHY driver behavior.
> + *
> + *      - Bits [15:0] are free to use by the PHY driver to communicate
> + *        driver specific behavior.
> + *      - Bits [23:16] are currently reserved for future use.
> + *      - Bits [31:24] are reserved for defining generic
> + *        PHY driver behavior.
>   * @irq: IRQ number of the PHY's interrupt (-1 if none)
>   * @phy_timer: The timer for handling the state machine
>   * @phylink: Pointer to phylink instance for this PHY
>
> base-commit: 065db2d90c6b8384c9072fe55f01c3eeda16c3c0
> ----8<-----
>
> Using bullet lists for bit fields is a reasonable approach,
> I guess.
>
> For bullet lists in ReST, which kernel-doc is based on, see
> https://docutils.sourceforge.io/docs/ref/rst/restructuredtext.html#bullet=
-lists
I think I can fix the following two warnings:

Documentation/networking/kapi:147: ./drivers/net/phy/phylink.c:1657:
WARNING: Unexpected indentation.
Documentation/networking/kapi:147: ./drivers/net/phy/phylink.c:1658:
WARNING: Block quote ends without a blank line; unexpected unindent.

I will send-email it  together in v2, Thank you very much!

Thanks,
Yanteng
>
> Just my 2c.
>
> BR, Akira
>
> >
> > --
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

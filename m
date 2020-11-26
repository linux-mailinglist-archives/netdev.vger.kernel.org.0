Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6422C4D72
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 03:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733286AbgKZCZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 21:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732854AbgKZCZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 21:25:23 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71ACC0613D4;
        Wed, 25 Nov 2020 18:25:23 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id k26so682606oiw.0;
        Wed, 25 Nov 2020 18:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gx1G1lLR+pPXdSgFNskx8ipDNb9yshYOT7LcC3URWxA=;
        b=diZ4I7aa9SFuy+vBDELkkt+tnv0PVBvvf0Lrs/ImXnxDL7+BS2eznFBuPMftX56LsP
         fpwnFptrb9Jls1oAMJfnNIbuxWFOibDlGz50+6V4sJtN1nxALe/XJflQUaGmRgTynl99
         CmwXgox9rteh7mW8AJ7e5XyD7klESH2iOxTn9ezlvLQpBv0jI4hzDsXHrDFW7qvIKMbJ
         V5bsOzy8LEO8U71Tl0ViCznFLWzu2V2ifxbXPe5Y18S6OJmrXReBraC2jkyXIDSHr8bP
         E6vYjU/z1gd3lOkBgvATZxM/7OWMe+7CCk5aje7kgVwkhSxw7TkCCIUA5IMcmU561Uuh
         V44Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gx1G1lLR+pPXdSgFNskx8ipDNb9yshYOT7LcC3URWxA=;
        b=cC1jIzG/Px7PIMgP4dE/teVympYxPHRfUvIsrOg90fnLnDMIapiNS+J0xQrte2O4l9
         IpbhnjcHBtL08wUDj/0FfSZVSa8JLoMwKDuMcFIGssin0TDnIdyzFYyi3ec/C5TS5H2G
         k3uOnGV67Y3VOKnJ/T5iuX/aQ2t3eH24K/bJRY4O1i3Ztwu9t9YJbIBwDgzC5hXoEYo7
         fKUxl2qxW/8/LpsIFdqTDdzjSzIwp5Xrp/r8fe0JREzOnXJ93pzG8C18cgwqBdDZdttl
         zLiwbEUASQzK+o/N2tehOsJGIntIThjylauO4+zjPrbTClhst1kTpewOmSNX0AqE6bQU
         npUQ==
X-Gm-Message-State: AOAM530gDxh1AX/Psf41wqEk4rIBSoit58vVOMCJly55uil5ryst5Iyo
        AhLlXEIvJVOKF3KQ4BRJqa8ly6X0n9sYTP5pEA==
X-Google-Smtp-Source: ABdhPJx8nyBUeX1zqh6a5ObpbhQDSpnaAwA2vFivIVZQiu+2Eebpp/+0Y5L82FTjXiQq/vzxJa7DskXfXiEgd4DBUcA=
X-Received: by 2002:aca:b145:: with SMTP id a66mr752270oif.92.1606357523117;
 Wed, 25 Nov 2020 18:25:23 -0800 (PST)
MIME-Version: 1.0
References: <20201125193740.36825-1-george.mccollister@gmail.com>
 <20201125193740.36825-3-george.mccollister@gmail.com> <20201125174214.0c9dd5a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201125174214.0c9dd5a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Wed, 25 Nov 2020 20:25:11 -0600
Message-ID: <CAFSKS=OY_-Agd6JPoFgm3MS5HE6soexHnDHfq8g9WVrCc82_sA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 7:42 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 25 Nov 2020 13:37:39 -0600 George McCollister wrote:
> > Add a driver with initial support for the Arrow SpeedChips XRS7000
> > series of gigabit Ethernet switch chips which are typically used in
> > critical networking applications.
> >
> > The switches have up to three RGMII ports and one RMII port.
> > Management to the switches can be performed over i2c or mdio.
> >
> > Support for advanced features such as PTP and
> > HSR/PRP (IEC 62439-3 Clause 5 & 4) is not included in this patch and
> > may be added at a later date.
> >
> > Signed-off-by: George McCollister <george.mccollister@gmail.com>
>
> You need to add symbol exports otherwise this won't build with
> allmodconfig:
>
> ERROR: modpost: "xrs7004f_info"
> [drivers/net/dsa/xrs700x/xrs700x_mdio.ko] undefined! ERROR: modpost:
> "xrs7004e_info" [drivers/net/dsa/xrs700x/xrs700x_mdio.ko] undefined!
> ERROR: modpost: "xrs7003f_info"
> [drivers/net/dsa/xrs700x/xrs700x_mdio.ko] undefined! ERROR: modpost:
> "xrs7003e_info" [drivers/net/dsa/xrs700x/xrs700x_mdio.ko] undefined!
> ERROR: modpost: "xrs7004f_info"
> [drivers/net/dsa/xrs700x/xrs700x_i2c.ko] undefined! ERROR: modpost:
> "xrs7004e_info" [drivers/net/dsa/xrs700x/xrs700x_i2c.ko] undefined!
> ERROR: modpost: "xrs7003f_info"
> [drivers/net/dsa/xrs700x/xrs700x_i2c.ko] undefined! ERROR: modpost:
> "xrs7003e_info" [drivers/net/dsa/xrs700x/xrs700x_i2c.ko] undefined!

I was wondering if I possibly needed to do that but wasn't getting any
errors the way I was building.

>
> > +     {XRS_RX_UNDERSIZE_L, "rx_undersize"},
> > +     {XRS_RX_FRAGMENTS_L, "rx_fragments"},
> > +     {XRS_RX_OVERSIZE_L, "rx_oversize"},
> > +     {XRS_RX_JABBER_L, "rx_jabber"},
> > +     {XRS_RX_ERR_L, "rx_err"},
> > +     {XRS_RX_CRC_L, "rx_crc"},
>
> As Vladimir already mentioned to you the statistics which have
> corresponding entries in struct rtnl_link_stats64 should be reported
> the standard way. The infra for DSA may not be in place yet, so best
> if you just drop those for now.

Okay, that clears it up a bit. Just drop these 6? I'll read through
that thread again and try to make sense of it.

Thanks

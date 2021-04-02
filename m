Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C734C352DD3
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 18:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235304AbhDBQhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 12:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234821AbhDBQhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 12:37:07 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540FBC0613E6
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 09:37:04 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id j20-20020a4ad6d40000b02901b66fe8acd6so1398612oot.7
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 09:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GaS/xH1jTtSYc4JA/VW/x0pB4TPC9YHU96s7oLAaNR8=;
        b=drRSrkaGis7Ez84TfCvuVUmJOFZehF+1vkGUkaB13qBZHgtUcAvrDEYKXIwT6hU7kd
         pztaxukgoWHpeHx1el3t7YI3QT0JRHl2xebO59pHdCxSPc+R07j7CnLarP/A1eheVdLG
         C19hFRA12GhBP04BZ/v3d/kxQeVIDcKRKBOqTGGs5C59K5oIJik/Myx6ZZo5odhV4Djp
         U2DZlFmOSjquP6AtCFEqsmJAz8RBV25LhcfJOomxPFxYJOekMyodJxpJdihUi30CE/T2
         7SSVG1edJDUA6lTPGsB6gsvE36lqH0NOisaj7U23Wps72Fr7HlxKm6WhQ6fvj4Z6vrcF
         f0mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GaS/xH1jTtSYc4JA/VW/x0pB4TPC9YHU96s7oLAaNR8=;
        b=YT3g9etLlW8uDYmBQ1QEJcQTgx2pNCcOY3xV8mQSzzXwkENcTjnk9ZuAMxXgLFLeOO
         dBC8HkarM7DpP4+zu8ri1cUhl0lyD9dS83zywn3SK1MIfxspqV/3p3W95a2NES/9iIRw
         Fnf2avE84iIp/yArH/AH7sFYPuob++/RqMtuTFfsyXL5lzEaVAU0dnM3QcRsbNeThEGB
         E/JiEJyLdrD27q+X6rxOx77p6EsA9dgYBxy4lvF6WEQZDam7cr9ny0nGvYpdvp6QInxP
         fG1aWqNp2S0l9rc1EGhONAVrdUwROX5zeWvQ945DvmFMMlNerAZJ9ZY6QNL0AEivwChQ
         ZbBA==
X-Gm-Message-State: AOAM531xiLzbvaJjSP4yC8r/AjyoXXC3nbNn86GPbGZSFaLRtmtgYrUj
        rfQqRGssELBqN6BLDtcxnrQAb+KQbV558aZGUkN3ge1qJw==
X-Google-Smtp-Source: ABdhPJyOIB9/ZDcQ+IFuEkP/sC80k0HYweNoQus5UPXTpfBaFeIc49EqtA/EQqmDSFprj8w5RzaA7d/XDLSHBWaYMlQ=
X-Received: by 2002:a4a:d0ce:: with SMTP id u14mr12320171oor.36.1617381423655;
 Fri, 02 Apr 2021 09:37:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAFSKS=O+BCZeLD92ZT5SvkWCgCLsQ2rN9gPmVY_35PCVBqyZuA@mail.gmail.com>
 <20210401223355.GA1463@shell.armlinux.org.uk>
In-Reply-To: <20210401223355.GA1463@shell.armlinux.org.uk>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Fri, 2 Apr 2021 11:36:51 -0500
Message-ID: <CAFSKS=MKVDB7pBmNtzWCTxBOPxgZYyXsB+noaD=ECb6_Y24CEw@mail.gmail.com>
Subject: Re: net: phylink: phylink_helper_basex_speed issues with 1000base-x
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 1, 2021 at 5:33 PM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> Hi,
>
> I hadn't responded earlier because I wanted to think about it more,
> but then forgot about this email.
>
> On Thu, Mar 25, 2021 at 11:36:26AM -0500, George McCollister wrote:
> > When I set port 9 on an mv88e6390, a cpu facing port to use 1000base-x
> > (it also supports 2500base-x) in device-tree I find that
> > phylink_helper_basex_speed() changes interface to
> > PHY_INTERFACE_MODE_2500BASEX.
>
> If both 2500base-X and 1000base-X are reported as being advertised,
> then yes, it will. This is to support SFPs that can operate in either
> mode. The key thing here is that both speeds are being advertised
> and we're in either 2500base-X or 1000base-X mode.
>
> This gives userspace a way to switch between those two supported modes
> on the SFP.
>
> > The Ethernet adapter connecting to this
> > switch port doesn't support 2500BASEX so it never establishes a link.
>
> You mean the remote side only supports 1000base-X?

Yes, the Ethernet controller on the board that connects to port 9 on
the mv88e6390 doesn't support 2500base-X.

>
> > If I hack up the code to force PHY_INTERFACE_MODE_1000BASEX it works
> > fine.
> >
> > state->an_enabled is true when phylink_helper_basex_speed() is called
> > even when configured with fixed-link. This causes it to change the
> > interface to PHY_INTERFACE_MODE_2500BASEX if 2500BaseX_Full is in
> > state->advertising which it always is on the first call because
> > phylink_create calls bitmap_fill(pl->supported,
> > __ETHTOOL_LINK_MODE_MASK_NBITS) beforehand. Should state->an_enabled
> > be true with MLO_AN_FIXED?
>
> Historically, it has been (by the original fixed-phy implementation)
> and I don't wish to change that as that would be a user-visible
> change. Turning off state->an_enabled will make the interface depend
> on state->speed instead.
>
> > I've also noticed that phylink_validate (which ends up calling
> > phylink_helper_basex_speed) is called before phylink_parse_mode in
> > phylink_create. If phylink_helper_basex_speed changes the interface
> > mode this influences whether phylink_parse_mode (for MLO_AN_INBAND)
> > sets 1000baseX_Full or 2500baseX_Full in pl->supported (which is then
> > copied to pl->advertising). phylink_helper_basex_speed is then called
> > again (via phylink_validate) which uses advertising to decide how to
> > set interface. This seems like circular logic.
>
> I'm wondering if we should postpone the initial call to
> phylink_validate() to just before the "pl->cur_link_an_mode =
> pl->cfg_link_an_mode;" in there, and only if we're still in MLO_AN_PHY
> mode - it will already have been called via the other methods. Would
> that help to solve the problem?

I had wondered if precisely this would fix it. I tested it and it
does. The question I can't answer is will it break anything else?
Should I send a patch?

>
> > To make matters even more confusing I see that
> > mv88e6xxx_serdes_dcs_get_state uses state->interface to decide whether
> > to set state->speed to SPEED_1000 or SPEED_2500.
>
> There is no real report from the hardware to indicate the speed -
> 2500base-X looks like 1000base-X except for the different interface
> mode.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

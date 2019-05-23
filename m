Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 637D728CD5
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 00:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388423AbfEWWEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 18:04:14 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:33134 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388293AbfEWWEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 18:04:14 -0400
Received: by mail-ed1-f68.google.com with SMTP id n17so11354771edb.0
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 15:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0ZOGMkQATVa6hySgn7e8PmVEwWcR3u+Mz/cQOb/DRkA=;
        b=Et/9IGf9JPPgnIarl8rwxL6y9jKOfsCgMA2M59GgnFg/C9v/G+zu2QXmrdr4b1XfuN
         I+o9bIxpCosDiigq++OZqibZOj2dNIDLaVLbc7hkqXQBdMpGhMeKpPjGBl4I0ifTI5K/
         jm6QIrQBFz5/90d2a3XGpf1L59SLTPgiBC2AOZX4diP3gvOkmpZnlschf2+fblFzBOwW
         6hSb6C1ZmKc/9Y6DhA3GP/U86PGL8JD6ehE1Q9YgqsNFrDNqSDysHsqjVB8tbzG7v3jF
         dVx48vCHf2fBIo5T/OTgg8ry8hUoUSDzKdeOKnf9LpiYBj3fG+kVECbQm3UBghjzLy1+
         W55w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0ZOGMkQATVa6hySgn7e8PmVEwWcR3u+Mz/cQOb/DRkA=;
        b=GezTLa7mgS9g6wvePLzrDOuE/O+mFDil2G5MwTW9pQtf8MkHAq5yXHlMU0jSKGu1PO
         v82mAjdAOByAkuHAPLKovIrVkkwN3wIDYful1k6qoybBTy19KDfZ4MM64q3elOrGcvSq
         XmB89yd8W6iwAvfSluXDnxSIhZkawQZe3HbAlv0XCjvsUJea9+jKWCli6J0mgxQ3/y6T
         jRE3PXPu8Fbdr8NDiQzP2Q9AhffqTgYfPY6C7QYPql2cqTLoFeEdo160iG4dMTRvnjvz
         ms6vjJcCVKokn/7eemQowGPFNCxbYaAPAsOOIa+KmRDxxTe1CwNKPW4xaRdSnt1ChA4y
         k3qQ==
X-Gm-Message-State: APjAAAURjCGQsNDo2ZZXT0HZM0ssofwan4gev8suon4o64cYBX3pPyjc
        /4JO7gZ+x04IhmUp0Mc9LpDBGL2G8WfWbu6HlcsKUzJpbZ4=
X-Google-Smtp-Source: APXvYqz1Lk78/B7Smjk+kOoueQMsLbiNbdPpB+w2QzZSmQCSibVlnPiCS4WR8TJaLCQU80gSMKWGNMtiyEf2oQaKURs=
X-Received: by 2002:a50:92c9:: with SMTP id l9mr100036604eda.75.1558649052334;
 Thu, 23 May 2019 15:04:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190523011958.14944-1-ioana.ciornei@nxp.com> <20190523011958.14944-6-ioana.ciornei@nxp.com>
 <20190523215522.gnz6l342zhzpi2ld@shell.armlinux.org.uk>
In-Reply-To: <20190523215522.gnz6l342zhzpi2ld@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 24 May 2019 01:04:01 +0300
Message-ID: <CA+h21hpU7-kcsX9Z4DA116qcMz2DjE3G2Fwj03=JDRyE7sAcwQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 5/9] net: phylink: Add phylink_create_raw
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 May 2019 at 00:55, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Thu, May 23, 2019 at 01:20:40AM +0000, Ioana Ciornei wrote:
> > +     if (pl->ops) {
> > +             pl->ops->mac_link_up(ndev, pl->link_an_mode,
> >                            pl->phy_state.interface,
> >                            pl->phydev);
> >
> > +             netif_carrier_on(ndev);
> >
> > +             netdev_info(ndev,
> > +                         "Link is Up - %s/%s - flow control %s\n",
> > +                         phy_speed_to_str(link_state.speed),
> > +                         phy_duplex_to_str(link_state.duplex),
> > +                         phylink_pause_to_str(link_state.pause));
> > +     } else {
> > +             blocking_notifier_call_chain(&pl->notifier_chain,
> > +                                          PHYLINK_MAC_LINK_UP, &info);
> > +             phydev_info(pl->phydev,
> > +                         "Link is Up - %s/%s - flow control %s\n",
> > +                         phy_speed_to_str(link_state.speed),
> > +                         phy_duplex_to_str(link_state.duplex),
> > +                         phylink_pause_to_str(link_state.pause));
> > +     }
>
> So if we don't have pl->ops, what happens when we call phydev_info()
> with a NULL phydev, which is a very real possibility: one of phylink's
> whole points is to support dynamic presence of a PHY.
>
> What will happen in that case is this will oops, due to dereferencing
> an offset NULL pointer via:
>
> #define phydev_info(_phydev, format, args...)   \
>         dev_info(&_phydev->mdio.dev, format, ##args)
>
> You can't just decide that if there's no netdev, we will be guaranteed
> a phy.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

True, however it does not crash:

[    2.539949] (NULL device *): Link is Up - 1Gbps/Full - flow control off

I agree that a better printing system has to be established though.

-Vladimir

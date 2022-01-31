Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDC34A52B9
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 23:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbiAaW6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 17:58:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbiAaW6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 17:58:10 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB426C061714;
        Mon, 31 Jan 2022 14:58:09 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id h21so28353386wrb.8;
        Mon, 31 Jan 2022 14:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lU1G9+dkgu85ynTOI5duAG/YVK2yiYMVuxleih31VWQ=;
        b=WykjLdPIQhu+boQyH2Ffsyq0If/EgomKYiHHiYUPdWSri2xlCbIhZCTrhykLd3S12g
         BLg56tIPmi0jPGqPQlZDq7qdmJEnWg7IAm7dbjZCVFOYP4UfF9qTPkehSAP5Bq/Gm29K
         HdgI5jreR2lfrdHTsAo2r1Bk1Ed2qtRZ3hhJLBbEEgVBFC+GvhxxmlyhGhC03HdEp1ta
         RfA5X1NRgndyc7DQyoUrCT0892+XUUiz4spgpIWwIaRDd5P7DSaLIrVXbBDRvxUUQfB7
         FH7D4NwaYbmInlflNJV52Kfblhlse6Ox4MIn0tBR3ZF1u2f6L0sEdtJvuFZ1Dtoyfjh4
         slVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lU1G9+dkgu85ynTOI5duAG/YVK2yiYMVuxleih31VWQ=;
        b=8PWDt+WOjs8O1sT13yjrS6lSXJ4g9+B8ZMYcj173EkTMz2yTXEG3+wrNViU0Po/VG6
         MnbWGRd8W2u+sQAT6HZrag85oLww62juist5KbE/dEzApjXXPb+cL4iNQ7rcoXVPLCTr
         fa3cbQExEGw0ihX2NQ6AgtJkF47PY9fH1CIn6PE90ckt3IKqksPtJhPJQ1d4zak+MWgZ
         yvl2kGlIrxrk0duK65iGt4zmw0fDVYnCFcsRMhipR8K9bKcUHZ0/iJpZvuADk2NcI8wE
         qWunRuB3CFEnK/AE9MSp8WMQTON8lSBOubQLdV6Ks5BIhENTfZ+nLwXkQQuw78xUaBF1
         idrg==
X-Gm-Message-State: AOAM532NUk2fpVe5tCcEZK3ISVAy2/Ya3dlrP+7o43hPI+dCPp49ZnXH
        1kMQ6VdcN9oVmVnPpJ1mE1yvQ5/4za5cA0T+UZvVsLwtga4=
X-Google-Smtp-Source: ABdhPJyD2fM3BtNInKv4oMf21T2wHQTDvfV7IYnED6scoOKURuDGAnDosQBESke9fj3fkXJAT8VE8vi2sXjcIegvvq4=
X-Received: by 2002:a5d:6f10:: with SMTP id ay16mr19726478wrb.205.1643669888313;
 Mon, 31 Jan 2022 14:58:08 -0800 (PST)
MIME-Version: 1.0
References: <20220128112002.1121320-1-miquel.raynal@bootlin.com>
 <20220128112002.1121320-2-miquel.raynal@bootlin.com> <CAB_54W45Hht8OVLDhKTKkfORYUJ30oWBz2psxX2m8OB4foK=0Q@mail.gmail.com>
 <20220131144617.3c762cfb@xps13>
In-Reply-To: <20220131144617.3c762cfb@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 31 Jan 2022 17:57:57 -0500
Message-ID: <CAB_54W7WTpJ+G2VMzL9d49aKejj9P4=f=BS4ryLHrpX1hnfxZw@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 1/2] net: ieee802154: Move the IEEE 802.15.4
 Kconfig main entries
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Jan 31, 2022 at 8:46 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Sun, 30 Jan 2022 16:07:53 -0500:
>
> > Hi,
> >
> > I will do this review again because I messed up with other series.
> >
> > On Fri, Jan 28, 2022 at 6:20 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > From: David Girault <david.girault@qorvo.com>
> > >
> > > It makes certainly more sense to have all the low-range wireless
> > > protocols such as Bluetooth, IEEE 802.11 (WiFi) and IEEE 802.15.4
> > > together, so let's move the main IEEE 802.15.4 stack Kconfig entry at a
> > > better location.
> > >
> > > As the softMAC layer has no meaning outside of the IEEE 802.15.4 stack
> > > and cannot be used without it, also move the mac802154 menu inside
> > > ieee802154/.
> > >
> >
> > That's why there is a "depends on".
> >
> > > Signed-off-by: David Girault <david.girault@qorvo.com>
> > > [miquel.raynal@bootlin.com: Isolate this change from a bigger commit and
> > > rewrite the commit message.]
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >  net/Kconfig            | 3 +--
> > >  net/ieee802154/Kconfig | 1 +
> > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/Kconfig b/net/Kconfig
> > > index 8a1f9d0287de..a5e31078fd14 100644
> > > --- a/net/Kconfig
> > > +++ b/net/Kconfig
> > > @@ -228,8 +228,6 @@ source "net/x25/Kconfig"
> > >  source "net/lapb/Kconfig"
> > >  source "net/phonet/Kconfig"
> > >  source "net/6lowpan/Kconfig"
> > > -source "net/ieee802154/Kconfig"
> >
> > I would argue here that IEEE 802.15.4 is no "network option". However
> > I was talking once about moving it, but people don't like to move
> > things there around.
> > In my opinion there is no formal place to "have all the low-range
> > wireless such as Bluetooth, IEEE 802.11 (WiFi) and IEEE 802.15.4
> > together". If you bring all subsystems together and put them into an
> > own menuentry this would look different.
> >
> > If nobody else complains about moving Kconfig entries here around it
> > looks okay for me.
> >
> > > -source "net/mac802154/Kconfig"
> > >  source "net/sched/Kconfig"
> > >  source "net/dcb/Kconfig"
> > >  source "net/dns_resolver/Kconfig"
> > > @@ -380,6 +378,7 @@ source "net/mac80211/Kconfig"
> > >
> > >  endif # WIRELESS
> > >
> > > +source "net/ieee802154/Kconfig"
> > >  source "net/rfkill/Kconfig"
> > >  source "net/9p/Kconfig"
> > >  source "net/caif/Kconfig"
> > > diff --git a/net/ieee802154/Kconfig b/net/ieee802154/Kconfig
> > > index 31aed75fe62d..7e4b1d49d445 100644
> > > --- a/net/ieee802154/Kconfig
> > > +++ b/net/ieee802154/Kconfig
> > > @@ -36,6 +36,7 @@ config IEEE802154_SOCKET
> > >           for 802.15.4 dataframes. Also RAW socket interface to build MAC
> > >           header from userspace.
> > >
> > > +source "net/mac802154/Kconfig"
> >
> > The next person in a year will probably argue "but wireless do source
> > of wireless/mac80211 in net/Kconfig... so this is wrong".
> > To avoid this issue maybe we should take out the menuentry here and do
> > whatever wireless is doing without questioning it?
>
> Without discussing the cleanliness of the wireless subsystem, I don't
> feel bad proposing alternatives :)
>
> I'm fine adapting to your preferred solution either way, so could you
> clarify what should I do:
> - Drop that commit entirely.
> - Move things into their own submenu (we can discuss the naming,
>   "Low range wireless Networks" might be a good start).
> - Keep it like it is.

I think we should move things around to end in a situation like
wireless has it in net/Kconfig. This will avoid other movements
whoever declares what's wrong and right of handling Kconfig entries.

Sure you can do follow up patches which introduce "Low range wireless
Networks" and ask for acks for doing such change.

- A;ex

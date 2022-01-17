Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A15491268
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 00:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243810AbiAQXij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 18:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235399AbiAQXii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 18:38:38 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5AAC061574;
        Mon, 17 Jan 2022 15:38:38 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id j5-20020a05600c1c0500b0034d2e956aadso316709wms.4;
        Mon, 17 Jan 2022 15:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rir6D4bC1vy6fxjVv28+U7V5WMV0XwnStejaVpn+Cf4=;
        b=iUirfg7pU+YdYe12vJhlzSOWF1Yb+YUjhuTqQmsGgGqnU6fueNFIuHSepHksy5/3PO
         jlEtFYDkWORwrHlPA8dyquTK0fUBP8ifkSoA6PfNJLZnKZMxKq1VDaHb24W+Kz/UhBQ+
         t7/5gbp6MZEcuVnvhmTW569Wrl54tRxU6QV4tTpc0p9O/CvpLv4yVnCKcZCGJ5A6Ybjr
         w3qmmwSo77wxTUbFmd/o6WPKYVgdsZv/s1lpqRPA6lPcsFq42aVuGWoenxXlqgz9NRbW
         DtJtIbRnEDbWUIsLgVGvsz6bDH74a2RdKQuUwrAVLrHdF/ecHHNzl8ZBKGfev2q/lkK0
         LCMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rir6D4bC1vy6fxjVv28+U7V5WMV0XwnStejaVpn+Cf4=;
        b=IaSTt2V3UAOQHr4kQc1HBovHfBLMPtSpGR5K50VtmFMyQ6o4Oa81vJM92wjlou7PDq
         L9gmyyxrsa9s3WDgwLA1dekqc+wb8L4ppoautGh47OKnXWZxRLZDH2QpzQRxjUewBCXM
         MEP6En1pVplszBigb5zcIyFa75cLdlCWzvJA016GU1ddKdT3wci/psK6gJbS5eOVoIxe
         ObQkCF5YtBaWsnsEgDuWLpbpN0BMuDUJnUTRNGJBaxzOyBULUzfIyJUFVfzyqLkepZd2
         9rxN8/qLxrbUOs3FxMgZsnHzovzxk4+aOkyrQjgsX6giU/bX1HzZl9PFRN3H0HIoQPnR
         GUJA==
X-Gm-Message-State: AOAM530OXhI5usoGcZp5j7je8x+bxA/LaVXMpoTWV7NBWbI3egBhWSpb
        AK8sMJRrjGwUnOBrqW3+iYDH34wGJyaiedgBSlpLztN5OA4=
X-Google-Smtp-Source: ABdhPJxFTnQyfifTiPVfX2XE10pwGNSu96gEqXlMnGzccNeL3PO1zjkzzyDa/UQsrwZkzN5tbf9ZI/s9EpE9/Rg6dUk=
X-Received: by 2002:adf:ec92:: with SMTP id z18mr15862712wrn.207.1642462716709;
 Mon, 17 Jan 2022 15:38:36 -0800 (PST)
MIME-Version: 1.0
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
 <20220112173312.764660-9-miquel.raynal@bootlin.com> <CAB_54W5QU5JCtQYwvTKREd6ZeQWmC19LF4mj853U0Gz-mCObVQ@mail.gmail.com>
 <20220113121645.434a6ef6@xps13> <CAB_54W5_x88zVgSJep=yK5WVjPvcWMy8dmyOJWcjy=5o0jCy0w@mail.gmail.com>
 <20220114112113.63661251@xps13> <CAB_54W77d_PjX_ZfKJdO4D4hHsAWjw0jWgRA7L0ewNnqApQhcQ@mail.gmail.com>
 <20220117101245.1946e474@xps13>
In-Reply-To: <20220117101245.1946e474@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 17 Jan 2022 18:38:25 -0500
Message-ID: <CAB_54W4rqXxSrTY=fqbt6o41a2SAEY_suqyqZ3hymheCgzRqTQ@mail.gmail.com>
Subject: Re: [wpan-next v2 08/27] net: ieee802154: Drop symbol duration
 settings when the core does it already
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 17 Jan 2022 at 04:12, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Sun, 16 Jan 2022 18:21:16 -0500:
>
> > Hi,
> >
> > On Fri, 14 Jan 2022 at 05:21, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > Hi Alexander,
> > >
> > > alex.aring@gmail.com wrote on Thu, 13 Jan 2022 18:34:00 -0500:
> > >
> > > > Hi,
> > > >
> > > > On Thu, 13 Jan 2022 at 06:16, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > >
> > > > > Hi Alexander,
> > > > >
> > > > > alex.aring@gmail.com wrote on Wed, 12 Jan 2022 17:26:14 -0500:
> > > > >
> > > > > > Hi,
> > > > > >
> > > > > > On Wed, 12 Jan 2022 at 12:33, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > > > >
> > > > > > > The core now knows how to set the symbol duration in a few cases, when
> > > > > > > drivers correctly advertise the protocols used on each channel. For
> > > > > > > these drivers, there is no more need to bother with symbol duration, so
> > > > > > > just drop the duplicated code.
> > > > > > >
> > > > > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > > > > ---
> > > > > > >  drivers/net/ieee802154/ca8210.c | 1 -
> > > > > > >  drivers/net/ieee802154/mcr20a.c | 2 --
> > > > > > >  2 files changed, 3 deletions(-)
> > > > > > >
> > > > > > > diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
> > > > > > > index 82b2a173bdbd..d3a9e4fe05f4 100644
> > > > > > > --- a/drivers/net/ieee802154/ca8210.c
> > > > > > > +++ b/drivers/net/ieee802154/ca8210.c
> > > > > > > @@ -2977,7 +2977,6 @@ static void ca8210_hw_setup(struct ieee802154_hw *ca8210_hw)
> > > > > > >         ca8210_hw->phy->cca.mode = NL802154_CCA_ENERGY_CARRIER;
> > > > > > >         ca8210_hw->phy->cca.opt = NL802154_CCA_OPT_ENERGY_CARRIER_AND;
> > > > > > >         ca8210_hw->phy->cca_ed_level = -9800;
> > > > > > > -       ca8210_hw->phy->symbol_duration = 16 * 1000;
> > > > > > >         ca8210_hw->phy->lifs_period = 40;
> > > > > > >         ca8210_hw->phy->sifs_period = 12;
> > > > > > >         ca8210_hw->flags =
> > > > > > > diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
> > > > > > > index 8aa87e9bf92e..da2ab19cb5ee 100644
> > > > > > > --- a/drivers/net/ieee802154/mcr20a.c
> > > > > > > +++ b/drivers/net/ieee802154/mcr20a.c
> > > > > > > @@ -975,7 +975,6 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
> > > > > > >
> > > > > > >         dev_dbg(printdev(lp), "%s\n", __func__);
> > > > > > >
> > > > > > > -       phy->symbol_duration = 16 * 1000;
> > > > > > >         phy->lifs_period = 40;
> > > > > > >         phy->sifs_period = 12;
> > > > > > >
> > > > > > > @@ -1010,7 +1009,6 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
> > > > > > >         phy->current_page = 0;
> > > > > > >         /* MCR20A default reset value */
> > > > > > >         phy->current_channel = 20;
> > > > > > > -       phy->symbol_duration = 16 * 1000;
> > > > > > >         phy->supported.tx_powers = mcr20a_powers;
> > > > > > >         phy->supported.tx_powers_size = ARRAY_SIZE(mcr20a_powers);
> > > > > > >         phy->cca_ed_level = phy->supported.cca_ed_levels[75];
> > > > > >
> > > > > > What's about the atrf86230 driver?
> > > > >
> > > > > I couldn't find reliable information about what this meant:
> > > > >
> > > > >         /* SUB:0 and BPSK:0 -> BPSK-20 */
> > > > >         /* SUB:1 and BPSK:0 -> BPSK-40 */
> > > > >         /* SUB:0 and BPSK:1 -> OQPSK-100/200/400 */
> > > > >         /* SUB:1 and BPSK:1 -> OQPSK-250/500/1000 */
> > > > >
> > > > > None of these comments match the spec so I don't know what to put
> > > > > there. If you know what these protocols are, I will immediately
> > > > > provide this information into the driver and ensure the core handles
> > > > > these durations properly before dropping the symbol_durations settings
> > > > > from the code.
> > > >
> > > > I think those are from the transceiver datasheets (which are free to
> > > > access). Can you not simply merge them or is there a conflict?
> > >
> > > Actually I misread the driver, it supports several kind of chips with
> > > different channel settings and this disturbed me. I downloaded the
> > > datasheet and figured that the number after the protocol is the bit
> > > rate. This helped me to make the connection with what I already know,
> > > so both atusb and atrf86230 drivers have been converted too.
> >
> > and what is about hwsim? I think the table gets too large then...
>
> I'm sorry but I don't follow you here, what do you mean by "the table
> gets too large"?
>

The switch/case statements getting large to support the channels which
hwsim supports.

> > that's why I was thinking of moving that somehow to the regdb, however
> > this is another project as I said and this way is fine. Maybe we use a
> > kind of fallback then? The hwsim phy isn't really any 802.15.4 PHY,
> > it's just memcpy() but it would be nice to be able to test scan with
> > it. So far I understand it is already possible to make something with
> > hwsim here but what about the zero symbol rate and the "waiting
> > period" is zero?
>
> Before this series: many drivers would not set the symbol duration
> properly. In this case the scan will likely not work because wait
> periods will be too short. But that's how it is, we miss some
> information.
>

This is the case because not every transceiver was using lifs/sifs handling.

> But for hwsim, I've handled a lot of situations so yes, there are
> still channels that won't have a proper symbol duration because I just
> don't know them, but for most of them (several pages) it will work like
> a charm.
>
> >
> > btw:
> > Also for testing with hwsim and the missing features which currently
> > exist. Can we implement some user space test program which replies
> > (active scan) or sends periodically something out via AF_PACKET raw
> > and a monitor interface that should work to test if it is working?
>
> We already have all this handled, no need for extra software. You can
> test active and passive scans between two hwsim devices already:
>
> # iwpan dev wpan0 beacons send interval 15
> # iwpan dev wpan1 scan type active duration 1
> # iwpan dev wpan0 beacons stop
>
> or
>
> # iwpan dev wpan0 beacons send interval 1
> # iwpan dev wpan1 scan type passive duration 2
> # iwpan dev wpan0 beacons stop
>
> > Ideally we could do that very easily with scapy (not sure about their
> > _upstream_ 802.15.4 support). I hope I got that right that there is
> > still something missing but we could fake it in such a way (just for
> > hwsim testing).
>
> I hope the above will match your expectations.
>

I need to think and read more about... in my mind is currently the
following question: are not coordinators broadcasting that information
only? Means, isn't that a job for a coordinator?

Thanks.

- Alex

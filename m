Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2B14A5286
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 23:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbiAaWn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 17:43:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiAaWnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 17:43:24 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16CBC061714;
        Mon, 31 Jan 2022 14:43:23 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id m26so5083939wms.0;
        Mon, 31 Jan 2022 14:43:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NCwXXEISw85eLQ5WN8GqXilX4aizid6sIFdpr0dFW3E=;
        b=QLqI3NTvKVGsk/lEFH9Uh56wHH5TQvt00y0y5lwhIE/eTxXNGJpCtjD90UoW97MhQp
         VKjPJ26zGkFO5tm8Ec9IQ1iPP5P/HqM3/PHAizcW27MWe2jcT1rfNEaBNWpcW4ebGTHS
         6LaxCcKOwiTI0gXRJm66u3Obl6o25DTa/e2xSMt1B6i7OdQ2lPymKgK9aUVcJDY24I2B
         76MlHZUz9Hr0il3OEQRXukzYDyInyUOJmhLi/S2fI4OkSXDUyL+qlTDB+9ZbBq0cleiH
         RwkfH0PXJWUG79VY4yhdg0K3l+hwqZIobGGKR+ILSv5sA3X/l+SGx/92wvbA3MTknl1H
         O6+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NCwXXEISw85eLQ5WN8GqXilX4aizid6sIFdpr0dFW3E=;
        b=UGJ92po+wNyzGiqONmkpzZC7FPsXdJkKG2BYBcWgJx8J8pRvBe8NiyjaX/MFz0jq8O
         l4ULQWWLbKbczww8WNVj3n6ofIDURBX891pFObmt44oBX/MfF6lg6fG8TuEyfAx9sBFW
         YkHHZLoZhxBDz+3gTQR+qjrHX3U8371uC7zA6OuncDiWoBh9Wm72cun8hfaaIOkBtJ8A
         tmOEDUEwirSdAW/uglOsXOn7drx4jTA7j1dcbl8rCK6X1B3kVpRmd4yodLenq2ON5moQ
         k6m9IfP+Xw8Kk6jr+gVuNXB/joyXm0bHzXes1i5EUFeu1inYCS6i6nQX0BwRE0TJ8NPx
         hU/w==
X-Gm-Message-State: AOAM5304826ipKql5OPBzYs+bx34cOGH9G6BKOiM5ScpAse4HzIfEfrU
        DlB/36uauOaijy0yWC+My4qOVQujfulWprp/h78=
X-Google-Smtp-Source: ABdhPJyveY/clVWteA7CuKLR/g4i6cHKBIN4bLTYCihxRV9dlGW/6MswVCuKJL4lUUE9qD5bB+7QEiCB47/UHaVbS8w=
X-Received: by 2002:a7b:c455:: with SMTP id l21mr10825991wmi.91.1643669002065;
 Mon, 31 Jan 2022 14:43:22 -0800 (PST)
MIME-Version: 1.0
References: <20220128112002.1121320-1-miquel.raynal@bootlin.com>
 <20220128112002.1121320-3-miquel.raynal@bootlin.com> <CAB_54W7KOjBys4aY5Ky3N3zmSGHnW2cvfag2cubD4cMvrkHY3A@mail.gmail.com>
 <20220131114645.341d61e9@xps13> <20220131150927.5264399c@xps13>
In-Reply-To: <20220131150927.5264399c@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 31 Jan 2022 17:43:11 -0500
Message-ID: <CAB_54W7V27AMDiHABCfx3veL3FLDuXVeALFcWT1F-CbuqwT+xw@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 2/2] net: ieee802154: Move the address
 structure earlier and provide a kdoc
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

On Mon, Jan 31, 2022 at 9:09 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Miquel,
>
> miquel.raynal@bootlin.com wrote on Mon, 31 Jan 2022 11:46:45 +0100:
>
> > Hi Alexander,
> >
> > alex.aring@gmail.com wrote on Sun, 30 Jan 2022 16:09:00 -0500:
> >
> > > Hi,
> > >
> > > On Fri, Jan 28, 2022 at 6:20 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > >
> > > > From: David Girault <david.girault@qorvo.com>
> > > >
> > > > Move the address structure earlier in the cfg802154.h header in order to
> > > > use it in subsequent additions. Give this structure a header to better
> > > > explain its content.
> > > >
> > > > Signed-off-by: David Girault <david.girault@qorvo.com>
> > > > [miquel.raynal@bootlin.com: Isolate this change from a bigger commit and
> > > >                             reword the comment]
> > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > ---
> > > >  include/net/cfg802154.h | 28 +++++++++++++++++++---------
> > > >  1 file changed, 19 insertions(+), 9 deletions(-)
> > > >
> > > > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > > > index 4491e2724ff2..0b8b1812cea1 100644
> > > > --- a/include/net/cfg802154.h
> > > > +++ b/include/net/cfg802154.h
> > > > @@ -29,6 +29,25 @@ struct ieee802154_llsec_key_id;
> > > >  struct ieee802154_llsec_key;
> > > >  #endif /* CONFIG_IEEE802154_NL802154_EXPERIMENTAL */
> > > >
> > > > +/**
> > > > + * struct ieee802154_addr - IEEE802.15.4 device address
> > > > + * @mode: Address mode from frame header. Can be one of:
> > > > + *        - @IEEE802154_ADDR_NONE
> > > > + *        - @IEEE802154_ADDR_SHORT
> > > > + *        - @IEEE802154_ADDR_LONG
> > > > + * @pan_id: The PAN ID this address belongs to
> > > > + * @short_addr: address if @mode is @IEEE802154_ADDR_SHORT
> > > > + * @extended_addr: address if @mode is @IEEE802154_ADDR_LONG
> > > > + */
> > > > +struct ieee802154_addr {
> > > > +       u8 mode;
> > > > +       __le16 pan_id;
> > > > +       union {
> > > > +               __le16 short_addr;
> > > > +               __le64 extended_addr;
> > > > +       };
> > > > +};
> > > > +
> > > >  struct cfg802154_ops {
> > > >         struct net_device * (*add_virtual_intf_deprecated)(struct wpan_phy *wpan_phy,
> > > >                                                            const char *name,
> > > > @@ -277,15 +296,6 @@ static inline void wpan_phy_net_set(struct wpan_phy *wpan_phy, struct net *net)
> > > >         write_pnet(&wpan_phy->_net, net);
> > > >  }
> > > >
> > > > -struct ieee802154_addr {
> > > > -       u8 mode;
> > > > -       __le16 pan_id;
> > > > -       union {
> > > > -               __le16 short_addr;
> > > > -               __le64 extended_addr;
> > > > -       };
> > > > -};
> > > > -
> > >
> > > I don't see the sense of moving this around? Is there a compilation
> > > warning/error?
> >
> > Not yet but we will need to move this structure around soon. This
> > commit is like a 'preparation' step for the changes coming later.
> >
> > I can move this later if you prefer.
>
> Actually there is not actual need for moving this structure anymore.
> The number of changes applied on top of the original series have turned
> that move unnecessary. I still believe however that structures should,
> as far as possible, be defined at the top of headers files, instead of
> be defined right before where they will be immediately used when
> introduced. I'll cancel the move but I'll keep the addition of the kdoc
> which I think is useful.
>
ok.

- Alex

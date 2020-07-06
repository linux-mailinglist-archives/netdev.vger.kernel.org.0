Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF33A2161D6
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 01:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgGFXFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 19:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbgGFXFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 19:05:02 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D0CC061755;
        Mon,  6 Jul 2020 16:05:02 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id x9so34425428ila.3;
        Mon, 06 Jul 2020 16:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zwvSRzBV5C3IE502UBXn+gfuwgJFq0fNK7XpsiBlD8s=;
        b=WzaHXK1l7TYOc9cDqHVz5wusSgSV3aGBLLbf+jhU4PvIF/NGvXoe8U2GtAf91GHxQA
         HlRUf24MOUWi23HaIhJUBXnoa9rFrjNECWA6tmeYXdK/YT7DYVV3O2sTedBfKvJm5aZ/
         TPT8cLo0Wvy5BLxTAg1dG8cyagz61B1VENl53gHA2zan5D6vaFbGxJAFn+LaLanJ8tL3
         I+1k4A6tvrjQR13B96md8ieI0n6oiz9ece0tj9E8sZEp+cWOlHd7DkEGKOf5yg7ubker
         BgfVuoN+nHwyEJTw8j5EN0qHyRFNWjM24Vuhwqt0N/pC01mx2AhaQGbWVtbao8v7BjHC
         5Dig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zwvSRzBV5C3IE502UBXn+gfuwgJFq0fNK7XpsiBlD8s=;
        b=O54mxq+SyjKBH1h8EUaMPXAhxzvcxw+q1MB+GPQ0TtUpswZUkQvpFo7hhTS4+suErx
         9ey1WL8E71+qTXLjmtOug5bvhJssppY84QzF0wDpozMbPp3BACJ1RJQf+hHabXFJDt8y
         sF78TowUcAY1ZU3autuFZTtKflmOO7dBqWY1nq7YhGKkKVu7VDgLeh7rICFBqPX/Wvqp
         041LGpYRlgWtJMaH2dlsn5DE11EudDSL4HDlmvgetigodCCbqqo4wxiaiLEPer7KmlXi
         iInuXr+UVqmCBATWPSbsdftHIMaK/CksPnt4l0AuVHyq1zJd5PAV4pfzGtDwCERHNzF5
         wPYw==
X-Gm-Message-State: AOAM530CWhDAMdKZ5FYp6QCUTxX0RWxpUYBWDcZwxTmsX7z9Lcc+BMdj
        4UpSxughWYJxmEg15yh/C6F4jF3LPziMqkopdJ9/V0YO0og=
X-Google-Smtp-Source: ABdhPJxNN6YdqMBlPCZsMNOMJ3TUsgz7mlzkmaYjpD5UWbqxgobmTLkxZFZKefUFHTXPnGQKahglFIjQEpYGDlMlMZ0=
X-Received: by 2002:a92:aa92:: with SMTP id p18mr32591747ill.199.1594076701537;
 Mon, 06 Jul 2020 16:05:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAFXsbZp5A7FHoXPA6Rg8XqZPD9NXmSeZZb-RsEGXnktbo04GOw@mail.gmail.com>
 <20200706204224.GW1551@shell.armlinux.org.uk>
In-Reply-To: <20200706204224.GW1551@shell.armlinux.org.uk>
From:   Chris Healy <cphealy@gmail.com>
Date:   Mon, 6 Jul 2020 16:04:50 -0700
Message-ID: <CAFXsbZptqExMHK0BcDqO-Fdu6qs6hD2toWgNprfAeq6YXWSmLA@mail.gmail.com>
Subject: Re: [PATCH] net: sfp: Unique GPIO interrupt names
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 6, 2020 at 1:42 PM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Mon, Jul 06, 2020 at 12:38:37PM -0700, Chris Healy wrote:
> > Dynamically generate a unique GPIO interrupt name, based on the
> > device name and the GPIO name.  For example:
> >
> > 103:          0   sx1503q  12 Edge      sff2-los
> > 104:          0   sx1503q  13 Edge      sff3-los
> >
> > The sffX indicates the SFP the loss of signal GPIO is associated with.
> >
> > Signed-off-by: Chris Healy <cphealy@gmail.com>
>
> This doesn't work in all cases.
>
> > ---
> >  drivers/net/phy/sfp.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> > index 73c2969f11a4..9b03c7229320 100644
> > --- a/drivers/net/phy/sfp.c
> > +++ b/drivers/net/phy/sfp.c
> > @@ -220,6 +220,7 @@ struct sfp {
> >      struct phy_device *mod_phy;
> >      const struct sff_data *type;
> >      u32 max_power_mW;
> > +    char sfp_irq_name[32];
> >
> >      unsigned int (*get_state)(struct sfp *);
> >      void (*set_state)(struct sfp *, unsigned int);
> > @@ -2349,12 +2350,15 @@ static int sfp_probe(struct platform_device *pdev)
> >              continue;
> >          }
> >
> > +        snprintf(sfp->sfp_irq_name, sizeof(sfp->sfp_irq_name),
> > +             "%s-%s", dev_name(sfp->dev), gpio_of_names[i]);
>
> sfp_irq_name will be overwritten for each GPIO IRQ claimed, which means
> all IRQs for a particular cage will end up with the same name.
> sfp_irq_name[] therefore needs to be an array of names, one per input.

Good point.  I'll add the necessary support to deal with this case and
test on my side with a hacked up devicetree file providing some
additional GPIOs and include this in the next version of the patch.

>
> Thanks.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

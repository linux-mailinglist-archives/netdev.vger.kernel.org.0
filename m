Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6106628C7C
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 23:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388059AbfEWVhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 17:37:34 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36423 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387709AbfEWVhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 17:37:34 -0400
Received: by mail-ed1-f67.google.com with SMTP id a8so11237719edx.3
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 14:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CjeLPVQUdb2YrgOLFR+owyppinGBKhQmpADhM8cREX4=;
        b=NlO0htqWzqOst36h9VdMhNClxRiF3FxH7cFHHaeLB/0JTNeEGzGe9ai2gKvi/02QRM
         UpAdtr3NIlGL1VKedvd19R2IQPwIc/aYEY4lwsDQQlQQRI80pC7NRdFSlUqvV3YiWzPI
         nNgmVGx20QhtPn5G0b5UAhvhGezJaAgaPPS9IdhLcWEnNGDn/92Gx7yVbtzVANnCHBRr
         mWcONYZdg0c2TejXX5k1suH+0BXMwfV139vgf57a9YiE5H32Hf5c4/lwwkegrgbmD+Fd
         AvQ5dnHupn0Lo5Z2nL74OqXeIhwTFVsf+cmgjzyIx8yAa4B9jifrq0THKXgTUB1VIHS8
         0s8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CjeLPVQUdb2YrgOLFR+owyppinGBKhQmpADhM8cREX4=;
        b=cbobzPQcEgJOq3DROkppSiynmc+kMGlBoMVztWaJcijCHdtaafAZgQurQFytWgsJ4q
         ZvV1dMWRaeKLt0w8JZawwaH1lFGkCu5m+lS3Fhf3lr2dthbUw1g4x7++A471xBlSRUFI
         67mfGiqykekb0MI71TlD1GvxjqkiXBhFrWA/ykHXDAd5LkDj+W1O7JPZ0cAuxqOpVI5Y
         W9yi+9xvrjab4tMnSOO6sZ+9DIxN9mrV5LVgXHMdUxIOtzuOXT7CA9ysqGb3JLHHwhEI
         dAOEEFrw4JGIZHp1garAC2S/DkFpt40SeZWLa1a4jd07ARhh+PBKZh5z2xreRLd2WzT1
         PTaQ==
X-Gm-Message-State: APjAAAXuuSoKxlKVaBFCWyIOBzJj8ut7MpovhPoTcLs5Nz+NYTSmUtm9
        45lR0dvmC/LMVq4+rh/XWfpC7iCczq/RS9jMV8I=
X-Google-Smtp-Source: APXvYqyp3vpDX/PWsaH/de3mFeddEaOJqYyF8GId5wRN8NlyhUSkyQw2cbKhxn7h5tZuqGdM7mWLItUG5hBYDD6ety8=
X-Received: by 2002:a50:ad98:: with SMTP id a24mr99806579edd.235.1558647452293;
 Thu, 23 May 2019 14:37:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190523011958.14944-1-ioana.ciornei@nxp.com> <20190523011958.14944-6-ioana.ciornei@nxp.com>
 <20190523212756.4b25giji4vkxdl5q@shell.armlinux.org.uk>
In-Reply-To: <20190523212756.4b25giji4vkxdl5q@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 24 May 2019 00:37:21 +0300
Message-ID: <CA+h21hpYWHrVu7t49dSPM7O7SoVwM+svcm+hO+Ox2fWwkDonkQ@mail.gmail.com>
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

On Fri, 24 May 2019 at 00:28, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Thu, May 23, 2019 at 01:20:40AM +0000, Ioana Ciornei wrote:
> > @@ -111,7 +114,16 @@ static const char *phylink_an_mode_str(unsigned int mode)
> >  static int phylink_validate(struct phylink *pl, unsigned long *supported,
> >                           struct phylink_link_state *state)
> >  {
> > -     pl->ops->validate(pl->netdev, supported, state);
> > +     struct phylink_notifier_info info = {
> > +             .supported = supported,
> > +             .state = state,
> > +     };
> > +
> > +     if (pl->ops)
> > +             pl->ops->validate(pl->netdev, supported, state);
> > +     else
> > +             blocking_notifier_call_chain(&pl->notifier_chain,
> > +                                          PHYLINK_VALIDATE, &info);
>
> I don't like this use of notifiers for several reasons:
>
> 1. It becomes harder to grep for users of this.
> 2. We lose documentation about what is passed for each method.
> 3. We lose const-ness for parameters, which then allows users to
>    modify phylink-internal data structures inappropriately from
>    these notifier calls.
>
> Please find another way.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

Hi Russell,

Items 2 and 3 can be addressed by creating an union of structures in
struct phylink_notifier_info, just like switchdev does.
For 1 (grep), you mean that the notifiers are upper-case and the
regular callbacks are lower-case?

-Vladimir

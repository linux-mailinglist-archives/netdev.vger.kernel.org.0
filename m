Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 043F6F90D2
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 14:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfKLNks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 08:40:48 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38498 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbfKLNks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 08:40:48 -0500
Received: by mail-ed1-f67.google.com with SMTP id s10so14940950edi.5
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 05:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ch71/YowF7JQ2VkonRdn067RVMIX98UklrBCO1JHGCI=;
        b=M+yARMg9mTRP/vC+5Nrn/Y+ABa5bRgUPd6DxSbrxy5ThIcFtpwEYHvnoogPQ0lGi04
         +i891rWQn/YPcxuXOfW/eUH7TE6x+ngIXeNA9lHIUUUIzUQ7JSDXECEO1JQbQ5lW2YIw
         L+RHkxHYtBjkItf2pVKgNT1EEgc3MUJ8EZEULbYfsppDKJ1LVwnbK+VHdAJRSfNO0pLJ
         GjpuGM7zZrzlc2WV0fB5g0T2r/se63Wo03YGlI0r9DMfe2QdqydXU/8AHWwaLLmBo0QZ
         Ny1R0PGDCtpta5fIDwNKRFmaOtfZNH0ZLdmTsg5ulJEGXXr6psfXAq0PX8Phz34W0Wjx
         eG4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ch71/YowF7JQ2VkonRdn067RVMIX98UklrBCO1JHGCI=;
        b=UXl7z9s9FhOx7TnF6iV+MNIlO6VkSlkxzXRRQ6c/u5QOC1nafFl8xzjcaG7i4UAASg
         Djf3M3PTGMiI0OVZBrYrsX8QzRDe5Bri/uQfc9sMdTGKywwiW3ugh2B/EV89oLamFVlc
         sKZS5p+qYkdzA0qDG5K0/LoPeFU0ljK82nCuEWLAwsIxjfCqryTuNacNNWq5jvezcofL
         97SeOXCdYsGGb3ddYGK+0vF1cDG2fITatDYu4+/kM1NgTSKkRHXpAKVUdW7NTMBEOwc3
         bCZn+s8PJb9KaVCMxez5C3RquPJL9UKsOX0LzKSE591Il+MYBX0ShOXGL+qPwDEfwZ0C
         vqBQ==
X-Gm-Message-State: APjAAAU/ZEFF3cBEYxHOHOHiuU3QSaaJmzoTTHWXWsFV51LWd5KICdyG
        BRb3RMKKTBpfbU9Qkq3bwYLgAN3HK2xx3t3eSVA=
X-Google-Smtp-Source: APXvYqwwvw4ICy8NSDdBrv9QLbKAJHILV7xQkK8ZM6h0WJoLJwRAVtJMZiD/GZNYRyrpdiIGeMJcPzSxtvu6d6NKi34=
X-Received: by 2002:aa7:c3d0:: with SMTP id l16mr33021243edr.18.1573566046538;
 Tue, 12 Nov 2019 05:40:46 -0800 (PST)
MIME-Version: 1.0
References: <20191112124420.6225-1-olteanv@gmail.com> <20191112124420.6225-11-olteanv@gmail.com>
 <20191112130947.GE3572@piout.net>
In-Reply-To: <20191112130947.GE3572@piout.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 12 Nov 2019 15:40:35 +0200
Message-ID: <CA+h21hqYynoGwfd=g3rZFgYSKNxsv8PXstD+6btopykweEi1dw@mail.gmail.com>
Subject: Re: [PATCH net-next 10/12] net: dsa: vitesse: move vsc73xx driver to
 a separate folder
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Nov 2019 at 15:09, Alexandre Belloni
<alexandre.belloni@bootlin.com> wrote:
>
> Hi,
>
> On 12/11/2019 14:44:18+0200, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > The vitesse/ folder will contain drivers for switching chips derived
> > from legacy Vitesse IPs (VSC family), including those produced by
> > Microsemi and Microchip (acquirers of Vitesse).
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  drivers/net/dsa/Kconfig                       | 31 +------------------
> >  drivers/net/dsa/Makefile                      |  4 +--
> >  drivers/net/dsa/vitesse/Kconfig               | 31 +++++++++++++++++++
> >  drivers/net/dsa/vitesse/Makefile              |  3 ++
> >  .../vsc73xx-core.c}                           |  2 +-
> >  .../vsc73xx-platform.c}                       |  2 +-
> >  .../vsc73xx-spi.c}                            |  2 +-
> >  .../{vitesse-vsc73xx.h => vitesse/vsc73xx.h}  |  0
> >  8 files changed, 39 insertions(+), 36 deletions(-)
> >  create mode 100644 drivers/net/dsa/vitesse/Kconfig
> >  create mode 100644 drivers/net/dsa/vitesse/Makefile
> >  rename drivers/net/dsa/{vitesse-vsc73xx-core.c => vitesse/vsc73xx-core.c} (99%)
> >  rename drivers/net/dsa/{vitesse-vsc73xx-platform.c => vitesse/vsc73xx-platform.c} (99%)
> >  rename drivers/net/dsa/{vitesse-vsc73xx-spi.c => vitesse/vsc73xx-spi.c} (99%)
> >  rename drivers/net/dsa/{vitesse-vsc73xx.h => vitesse/vsc73xx.h} (100%)
> >
>
> As there are no commonalities between the vsc73xx and felix drivers,
> shouldn't you simply leave that one out and have felix in the existing
> microchip folder?
>

I don't have a strong preference, although where I come from, all new
NXP networking drivers are still labeled as "freescale" even though
there is no code reuse. There are even less commonalities with
Microchip (ex-Micrel, if I am not mistaken) KSZ switches than with the
old vsc73xx. I'll let the ex-Vitesse people decide.


> --
> Alexandre Belloni, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1884915A2E3
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 09:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgBLIIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 03:08:04 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:34811 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728386AbgBLIIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 03:08:04 -0500
Received: by mail-oi1-f195.google.com with SMTP id l136so1222464oig.1;
        Wed, 12 Feb 2020 00:08:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gxq+7Sc2rUn1eaXQOPvDb63UOLOu7jeHo0xijtFEwKY=;
        b=XrXoIvtnkGbjIpNA2YfM41QoHSp86bK7CdqIxO59ezTrYyYTKL675TR6Utok2Gr3Fc
         /tsUNg7tCOFLnD6mWDn/YxaTIO+mtax/SSmyMXZ+Kn1hZZto9gK4otkrx3++5lP5idg3
         4/1XRWK1VnCjS7+QsWrCv4NZ1yFkep1d2UhpaLFMeKph50+OKMHqtizhcFgqruTIIvRy
         +DX4LLbDkJob3InGuIKB0SerEmq9AzZnw+ScCmfm+qZaLaUIxC8h8tmOA1inRSTiH5Uk
         V1MRpMsF9uFiq5vGtX72Zb1r+0TqnbCmmxaPhaZGtbNx7GGIqIsouABB/en+qfBrL6JL
         7zeQ==
X-Gm-Message-State: APjAAAWbA2myywO0EYjaKwaymqC1PDIVpQas6nfonupUaAt7vxn1KYI9
        E4xFlWhk6UT7CVrG9/MZ+GcHcMp8tMIlD0chMPA=
X-Google-Smtp-Source: APXvYqwuciUD6vwdUq4CPbVsyvYm1qjVrqqXMQjb87WUGx79yOvkcjnbAhitCFpK3ey7L0Tzueo+r4X+s+cf+LPG7uM=
X-Received: by 2002:aca:48cd:: with SMTP id v196mr5626851oia.102.1581494883264;
 Wed, 12 Feb 2020 00:08:03 -0800 (PST)
MIME-Version: 1.0
References: <cover.1581457290.git.hns@goldelico.com> <4e11dd4183da55012198824ca7b8933b1eb57e4a.1581457290.git.hns@goldelico.com>
 <20200211222506.GP19213@lunn.ch>
In-Reply-To: <20200211222506.GP19213@lunn.ch>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 12 Feb 2020 09:07:52 +0100
Message-ID: <CAMuHMdX6f+aGZjQSQqVjT=npojq5xH2k2Js8qxG5=n26Z4uFBw@mail.gmail.com>
Subject: Re: [PATCH 03/14] net: davicom: dm9000: allow to pass MAC address
 through mac_addr module parameter
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "H. Nikolaus Schaller" <hns@goldelico.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Paul Boddie <paul@boddie.org.uk>,
        Alex Smith <alex.smith@imgtec.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        James Hogan <jhogan@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andi Kleen <ak@linux.intel.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        =?UTF-8?Q?Petr_=C5=A0tetiar?= <ynezz@true.cz>,
        Richard Fontana <rfontana@redhat.com>,
        Allison Randal <allison@lohutok.net>,
        Stephen Boyd <swboyd@chromium.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-mips@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        letux-kernel@openphoenux.org, kernel@pyra-handheld.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 11, 2020 at 11:25 PM Andrew Lunn <andrew@lunn.ch> wrote:
> On Tue, Feb 11, 2020 at 10:41:20PM +0100, H. Nikolaus Schaller wrote:
> > This is needed to give the MIPS Ingenic CI20 board a stable MAC address
> > which can be optionally provided by vendor U-Boot.
> >
> > For get_mac_addr() we use an adapted copy of from ksz884x.c which
> > has very similar functionality.
> >
> > Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>
> Hi Nikolaus
>
> Please split these patches by subsystem. So this one patch needs to go
> via netdev.
>
> > +static char *mac_addr = ":";
> > +module_param(mac_addr, charp, 0);
> > +MODULE_PARM_DESC(mac_addr, "MAC address");
>
> Module parameters are not liked.
>
> Can it be passed via device tree? The driver already has code to get
> it out of the device tree.

Yep, typically U-Boot adds an appropriate "local-mac-address" property to the
network device's device node, based on the "ethernet0" alias.

However, the real clue here may be "vendor U-Boot", i.e. no support for the
above?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

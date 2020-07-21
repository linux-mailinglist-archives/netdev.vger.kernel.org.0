Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BFC227609
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 04:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgGUCvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 22:51:46 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:44828 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgGUCvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 22:51:45 -0400
Received: by mail-il1-f194.google.com with SMTP id h16so15137225ilj.11;
        Mon, 20 Jul 2020 19:51:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b5HYOcAL/kTYc/31bVrkUy6w36nDMzuxOcRjMb++zYg=;
        b=EyZIAbUsViqW1pBw/gOKwaZUA2XwEVdnLwkSCvi82tigKxH43s3U3RpavdrKJ57OWm
         MhLRQBq2u7WbPwW/S7/e9+sadaVEn3KYsX0xCRUm/jbPL4Ajfr4RrR+CB8TKdUf4/cZI
         Z6ZMZIKzj/Bnefdzv9AxXcyYn8EPlP4YEdTTt92RZZbhrEOpc/lQ0EVijpadBaUOIbAs
         ulByf5g1RMnNgE7BQdXUU5dafcnJLHPE+5pgg+GwfgHi5lef5YMPWsEAJg0FOEfjPDE3
         ZtP3gP1pxhIRHbi3+E+Y4ADahXCPl55N3r2mMJjZ33VQdTTDkumtXZQOnCaPcBaP0wGu
         J+NA==
X-Gm-Message-State: AOAM530ywp6SrtlkKSWixA4+k/L0q4q1bNo4KqYerZn0EABxayTMLowD
        gY7lXC44qTnCOBX8aQ8KoQ==
X-Google-Smtp-Source: ABdhPJw8ZofKbNgmXn/bcFLFn12C8Rhc4UzLzaGjyYsYXz2O7cZUjO6oX1l5zVEiRvmjO9wrvttQPQ==
X-Received: by 2002:a92:b655:: with SMTP id s82mr27245507ili.268.1595299903896;
        Mon, 20 Jul 2020 19:51:43 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id p12sm9735169ilj.16.2020.07.20.19.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 19:51:42 -0700 (PDT)
Received: (nullmailer pid 3446124 invoked by uid 1000);
        Tue, 21 Jul 2020 02:51:40 -0000
Date:   Mon, 20 Jul 2020 20:51:40 -0600
From:   Rob Herring <robh@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Niklas <niklas.soderlund@ragnatech.se>,
        Zhang Rui <rui.zhang@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Magnus Damm <magnus.damm@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-can@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH 14/20] dt-bindings: spi: renesas,sh-msiof: Add r8a774e1
 support
Message-ID: <20200721025140.GA3436698@bogus>
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-15-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20200717115915.GD4316@sirena.org.uk>
 <CA+V-a8sxtan=8NCpEryT9NzOqkPRyQBa-ozYNHvi8goaOJQ24w@mail.gmail.com>
 <20200717122209.GF4316@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717122209.GF4316@sirena.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 01:22:09PM +0100, Mark Brown wrote:
> On Fri, Jul 17, 2020 at 01:15:13PM +0100, Lad, Prabhakar wrote:
> > On Fri, Jul 17, 2020 at 12:59 PM Mark Brown <broonie@kernel.org> wrote:
> 
> > > On Wed, Jul 15, 2020 at 12:09:04PM +0100, Lad Prabhakar wrote:
> > > > Document RZ/G2H (R8A774E1) SoC bindings.
> 
> > > Please in future could you split things like this up into per subsystem
> > > serieses?  That's a more normal approach and avoids the huge threads and
> > > CC lists.
> 
> > Sorry for doing this, In future I shall keep that in mind. (Wanted to
> > get in most patches for RZ/G2H in V5.9 window)
> 
> If anything sending things as a big series touching lots of subsystems
> can slow things down as people figure out dependencies and who's going
> to actually apply things.

I'd be fine with one patch adding all the compatibles for a new SoC 
where there are no other changes and take that via the soc or DT tree, 
but the Renesas folks need to figure out any cross tree dependencies 
with other Renesas changes. That's a bit harder right now with schema 
conversions though.

Rob

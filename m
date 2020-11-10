Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1059F2AE3BB
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 23:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732538AbgKJWxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 17:53:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47184 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730254AbgKJWxr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 17:53:47 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kccW6-006MY8-H1; Tue, 10 Nov 2020 23:53:34 +0100
Date:   Tue, 10 Nov 2020 23:53:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Frederic LAMBERT <frdrc66@gmail.com>,
        Gabor Juhos <juhosg@openwrt.org>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        linux-spi <linux-spi@vger.kernel.org>
Subject: Re: [PATCH net v2] net: phy: spi_ks8995: Do not overwrite SPI mode
 flags
Message-ID: <20201110225334.GN1456319@lunn.ch>
References: <20201110142032.24071-1-TheSven73@gmail.com>
 <CAHp75Ve7jZyshwLuNKvuk7uvj43SpcZT_=csOYXVFUqhtmFo3A@mail.gmail.com>
 <CAGngYiV6i=fsySH35UgL2fKiNp1VAfdkJ=hrZ8nmMn_1fkaa-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGngYiV6i=fsySH35UgL2fKiNp1VAfdkJ=hrZ8nmMn_1fkaa-Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 12:06:37PM -0500, Sven Van Asbroeck wrote:
> PING Jakub
> 
> On Tue, Nov 10, 2020 at 11:30 AM Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> >
> > I see that this is a fix for backporing, but maybe you can send a
> > patches on top of this to:
> >   1) introduce
> >  #define SPI_MODE_MASK  (SPI_CPHA | SPI_CPOL)
> >        spi->mode &= ~SPI_MODE_MASK;
> > > +       spi->mode |= SPI_MODE_0;
> >
> Jakub,
> 
> Is it possible to merge Andy's suggestion into net?
> Or should this go into net-next?

I would keep with the minimal fix for the moment, it keeps the
dependencies simple.

When you add a helper, it should really be somewhere in the SPI code,
not the net code. So we need both the SPI and the net maintainers to
cooperate to get the helper merged, and then this driver using the
helper.

	Andrew

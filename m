Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4CB936FA48
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 14:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbhD3Mc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 08:32:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47662 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231984AbhD3McZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 08:32:25 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lcSIt-001oJw-J3; Fri, 30 Apr 2021 14:31:31 +0200
Date:   Fri, 30 Apr 2021 14:31:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH net-next v3 3/6] net: add generic selftest support
Message-ID: <YIv4owS5VxkadjoL@lunn.ch>
References: <20210419130106.6707-1-o.rempel@pengutronix.de>
 <20210419130106.6707-4-o.rempel@pengutronix.de>
 <CAMuHMdW+cX=vsZg2MyBOM+6Akp-nRQ0QrU=2XSiegFhHNA+jVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdW+cX=vsZg2MyBOM+6Akp-nRQ0QrU=2XSiegFhHNA+jVg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Thanks for your patch, which is now commit 3e1e58d64c3d0a67 ("net: add
> generic selftest support") upstream.
> 
> > --- a/net/Kconfig
> > +++ b/net/Kconfig
> > @@ -429,6 +429,10 @@ config GRO_CELLS
> >  config SOCK_VALIDATE_XMIT
> >         bool
> >
> > +config NET_SELFTESTS
> > +       def_tristate PHYLIB
> 
> Why does this default to enabled if PHYLIB=y?
> Usually we allow the user to make selftests modular, independent of the
> feature under test, but I may misunderstand the purpose of this test.

Maybe there is a misunderstanding here with 'selftest'. The name page
for ethtool(1) says:

       -t --test
              Executes adapter selftest on the specified network device.  Pos‐
              sible test modes are:

           offline
                  Perform  full set of tests, possibly interrupting normal op‐
                  eration during the tests,

           online Perform limited set of tests, not interrupting normal opera‐
                  tion,

           external_lb
                  Perform  full set of tests, as for offline, and additionally
                  an external-loopback test.

This feature has nothing to do with tools/testing/selftests. It
predates that by decades.

     Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75AD92B2A0B
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 01:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgKNAkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 19:40:07 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54690 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgKNAkH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 19:40:07 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kdjbm-006x9O-72; Sat, 14 Nov 2020 01:40:02 +0100
Date:   Sat, 14 Nov 2020 01:40:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Jernej =?utf-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steve McIntyre <steve@einval.com>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: Re: realtek PHY commit bbc4d71d63549 causes regression
Message-ID: <20201114004002.GV1480543@lunn.ch>
References: <20201029143934.GO878328@lunn.ch>
 <20201029144644.GA70799@apalos.home>
 <2697795.ZkNf1YqPoC@kista>
 <CAK8P3a2hBpQAsRekNyauUF1MgdO8CON=77MNSd0E-U1TWNT-gA@mail.gmail.com>
 <20201113144401.GM1456319@lunn.ch>
 <CAK8P3a2iwwneb+FPuUQRm1JD8Pk54HCPnux4935Ok43WDPRaYQ@mail.gmail.com>
 <20201113165625.GN1456319@lunn.ch>
 <CAK8P3a3ABKRYg_wyjz_zUPd+gE1=f3PsVs5Ac-y1jpa0+Kt1fA@mail.gmail.com>
 <20201113224301.GU1480543@lunn.ch>
 <CAMj1kXGnfsX1pH8m1eO-B1nAqL=vMeuw6fpYdeA1RqMpSrg66Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGnfsX1pH8m1eO-B1nAqL=vMeuw6fpYdeA1RqMpSrg66Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> One question that still has not been answered is how many actual
> platforms were fixed by backporting Realtek's follow up fix to
> -stable. My suspicion is none. That by itself should be enough
> justification to revert the backport of that change.
 
I think i've already said that would be a good idea. It makes the
problem less critical. But the problem is still there, we are just
kicking the can down the road. I've not seen much activity actually
fixing the broken DT. So i suspect when we catch up with the can, we
will mostly still be in the same place. Actually, maybe worse, because
broken DTs have been copy/pasted for new boards?

	Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE33D2B24F5
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 20:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgKMTy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 14:54:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:42350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbgKMTy3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 14:54:29 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B14A022245;
        Fri, 13 Nov 2020 19:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605297268;
        bh=FvZCzZux1JORm8mOiWoyNrChOKx4NI1KMe1ztchfQU0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2CYwt0+UXBugI/2IWsGMerb1q2cz1fj+YtxbaXkIbqdiUy1X9JjxCKuPBrWSMMS1u
         8DJf22xARS0aLCESABM4tfN+DsYjU7P2j8D8/bbXBduqPSz27Aigkz2RJeZpJZR1CN
         smuotcJSysVry3wEAHZWJ248jJi+X2hie0zJAA+E=
Date:   Fri, 13 Nov 2020 11:54:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Andre Edich <andre.edich@microchip.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Marek Vasut <marex@denx.de>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Nisar Sayed <Nisar.Sayed@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Robert Hancock <robert.hancock@calian.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Subject: Re: [PATCH net-next 00/18] net: phy: add support for shared
 interrupts (part 2)
Message-ID: <20201113115426.33794b5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201113081659.kkifu6dwxq3gxtpm@skbuf>
References: <20201112155513.411604-1-ciorneiioana@gmail.com>
        <20201112181910.6e23c0fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201113081659.kkifu6dwxq3gxtpm@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 08:17:00 +0000 Ioana Ciornei wrote:
> On Thu, Nov 12, 2020 at 06:19:10PM -0800, Jakub Kicinski wrote:
> > On Thu, 12 Nov 2020 17:54:55 +0200 Ioana Ciornei wrote: =20
> > > From: Ioana Ciornei <ioana.ciornei@nxp.com>
> > >=20
> > > This patch set aims to actually add support for shared interrupts in
> > > phylib and not only for multi-PHY devices. While we are at it,
> > > streamline the interrupt handling in phylib. =20
> >=20
> > Ioana, would you mind resending? Looks like the kernel.org patchwork
> > instance is way less reliable at piecing series together :( =20
>=20
> No problem, I'll resend.
>=20
> So from now on we'll be using the kernel.org patchwork only, right?  I
> am asking this because from what I can tell the ozlabs patchwork was not
> updated in the last days.

Yup, that's the plan. We're keeping ozlabs going for a bit just in case
kernel.org is acting up (like if the need to repost stuff persists),
but the plan is to stop the patchwork entry for netdev on ozlabs once
things settle.

=46rom where I live ozlabs takes 1s to respond to a request while
kernel.org instance takes 0.2s.

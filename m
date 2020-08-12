Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FBC242B4C
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 16:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgHLOUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 10:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbgHLOUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 10:20:34 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8DFC061383
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 07:20:33 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id 322701409F0;
        Wed, 12 Aug 2020 16:20:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1597242031; bh=xtK2/F36kR0tv8Pcbv6KlDNMgh6XysZV97w2MDP38z8=;
        h=Date:From:To;
        b=ExXPOGg3ZLHcI52YnZQgDz34wemNuI+nKrg36Ui95xrBV67mx24PzBkF+6o812VO7
         /xJaOl/If3W+SODrKP6phDIpIM81BEJoHRHsaeM2m/3gYPZ/Gn5+suf4eTkcC4bWLL
         uh0lq/LoCHsKVveXpZ8U0ufUPCThLhIvbyxAjmTE=
Date:   Wed, 12 Aug 2020 16:20:30 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 0/4] Support for RollBall 10G copper
 SFP modules
Message-ID: <20200812162030.2a6aa543@dellmb.labs.office.nic.cz>
In-Reply-To: <20200811150808.GL1551@shell.armlinux.org.uk>
References: <20200810220645.19326-1-marek.behun@nic.cz>
        <20200811150808.GL1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Aug 2020 16:08:09 +0100
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Tue, Aug 11, 2020 at 12:06:41AM +0200, Marek Beh=FAn wrote:
> > Hi Russell,
> >=20
> > this series should apply on linux-arm git repository, on branch
> > clearfog.
> >=20
> > Some internet providers are already starting to offer 2.5G copper
> > connectivity to their users. On Turris Omnia the SFP port is capable
> > of 2.5G speed, so we tested some copper SFP modules.
> >=20
> > This adds support to the SFP subsystem for 10G RollBall copper
> > modules which contain a Marvell 88X3310 PHY. By default these
> > modules are configured in 10GKR only mode on the host interface,
> > and also contain some bad information in EEPROM (the extended_cc
> > byte). =20
>=20
> Are you sure they are 10GBASE-KR, and not 10GBASE-R ?  Please send me
> the contents of MMD 31 register 0xf001.  Also knowing MMD 1 registers
> 2 and 3 would be useful to confirm exactly which version of the PHY
> has been used.
>=20
> Thanks.
>=20

Russell, sorry, I meant 10gbase-r mode, this was a typo. I don't know if
the PHY supports 10gbase-kr.

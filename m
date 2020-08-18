Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9E9248ABC
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 17:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgHRP4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 11:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbgHRPr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 11:47:27 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086CFC061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 08:47:26 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:8982:ed8c:62b1:c0c8])
        by mail.nic.cz (Postfix) with ESMTPSA id DA9A114094D;
        Tue, 18 Aug 2020 17:47:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1597765645; bh=qByIl7tqIzCZ98J2Kz97RNYdQhthXAMMV7MrzBe+e0c=;
        h=Date:From:To;
        b=EjggrPzarv8z+ue+qBRDeeHtnBB0coXmMYa+vuveZznshY11SMRVCiFPIYTmSFpRJ
         /XTGu7JUFnpXR7FshHHYidAQmOD1ouDQymXpymiO7w+OiUqYJgnZduA4fhkQqbq3R4
         fFrRa+RYt0Dl5CUOsU/YQcDe91ojSe6fqCQda5yI=
Date:   Tue, 18 Aug 2020 17:47:24 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 0/4] Support for RollBall 10G copper
 SFP modules
Message-ID: <20200818174724.02ea4ab8@dellmb.labs.office.nic.cz>
In-Reply-To: <20200818153649.GD1551@shell.armlinux.org.uk>
References: <20200810220645.19326-1-marek.behun@nic.cz>
        <20200817134909.GY1551@shell.armlinux.org.uk>
        <20200818154305.2b7e191c@dellmb.labs.office.nic.cz>
        <20200818150834.GC1551@shell.armlinux.org.uk>
        <20200818173055.01e4bf01@dellmb.labs.office.nic.cz>
        <20200818153649.GD1551@shell.armlinux.org.uk>
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

On Tue, 18 Aug 2020 16:36:49 +0100
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Tue, Aug 18, 2020 at 05:30:55PM +0200, Marek Beh=FAn wrote:
> > On Tue, 18 Aug 2020 16:08:35 +0100
> > Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> >  =20
> > > > Otherwise it looks nice. I will test this. On what branch does
> > > > this apply?   =20
> > >=20
> > > My unpublished tip of the universe development.  Here's a version
> > > on the clearfog branch: =20
> >=20
> > Russell, it seems you do not have commit
> >=20
> > e11703330a5d ("net: phy: marvell10g: support XFI rate matching
> > mode")
> >=20
> > in that branch. =20
>=20
> I don't.  That commit is in 5.9-rc1, I'm based on 5.8 at the moment.
>=20

I am reworking it so that it applies on top of master together with
your other commits from clearfog branch.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37682F42B1
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 04:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbhAMD5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 22:57:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:48118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbhAMD5k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 22:57:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D7292311B;
        Wed, 13 Jan 2021 03:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610510219;
        bh=l3gJ3iTpEpGMUXfp1QrQLFiHvKSJEFnECEI0QL8WO+A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ScXPzktFC/A4y1ziDrtowPJ2672UPbSFMDh7okqzChpvdTy0dxAtm479UKmswurAl
         tNN3XqcQql12lds/q0rk3ORbFHWTJIDxb0w94frsY8b6vcOYmYojsud5UMRxHkvh3W
         iITdxtLiBZfXr73YPDzPy0a0/WZDCM3W9SWU3k7Ve2nnDPvPwJtCW6xv8LguE/yZly
         +pUhEJkO49AaPRIR2qQSZ+FyAWTFSTFfWF3WPe+i1iriYYL97sqNUStab5GDzGG9Ec
         cOiZd8hhqn66awNzZIObVR0aWxmw/oIE+42AbtuZnivRQn3F5WqlaE+JGB+RYiK+6V
         u+C9MEfvnrGRQ==
Date:   Wed, 13 Jan 2021 04:56:53 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        lkp@intel.com, davem@davemloft.net, ashkan.boldaji@digi.com,
        andrew@lunn.ch, Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: Re: [PATCH net-next v14 5/6] net: dsa: mv88e6xxx: Add support for
 mv88e6393x family of Marvell
Message-ID: <20210113045653.2f1d797d@kernel.org>
In-Reply-To: <20210112215824.zosvizu4w3mqmjsr@skbuf>
References: <20210111012156.27799-1-kabel@kernel.org>
        <20210111012156.27799-6-kabel@kernel.org>
        <20210112111139.hp56x5nzgadqlthw@skbuf>
        <20210112170226.3f2009bd@kernel.org>
        <20210112162909.GD1551@shell.armlinux.org.uk>
        <20210112190629.5a118385@kernel.org>
        <20210112215824.zosvizu4w3mqmjsr@skbuf>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 23:58:24 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> On Tue, Jan 12, 2021 at 07:06:29PM +0100, Marek Beh=C3=BAn wrote:
> > On Tue, 12 Jan 2021 16:29:09 +0000
> > Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> >  =20
> > > I'm seriously thinking about changing the phylink_validate() interface
> > > such that the question of which link _modes_ are supported no longer
> > > comes up with MAC drivers, but instead MAC drivers say what interface
> > > modes, speeds for each interface mode, duplexes for each speed are
> > > supported. =20
> >=20
> > BTW this would also solve the situation where DSA needs to know which
> > interface modes are supported on a particular port to know which modes
> > we can try on SFP connected to a DSA port. =20
>=20
> What do you mean here? What makes this specific to DSA?

https://www.spinics.net/lists/netdev/msg675899.html

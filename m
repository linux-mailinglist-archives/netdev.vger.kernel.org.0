Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B214347EE9
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 18:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237083AbhCXRKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 13:10:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237254AbhCXRJP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 13:09:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBCDF619D5;
        Wed, 24 Mar 2021 17:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616605755;
        bh=5i69XZMMGmrVXuaS54HIRTYMHZV9BH4S/AutHbWZWaY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M6dGY4lV2cOo10XQFf82VAbb9n5lTz7KAc3UGwqlJbNlfVUw3dVb1Gp/JMg0Ix9eO
         lQb2g3mBbpz918f0YgGHDgtVUiVwiy9vj34jvL3XikjuBH7kqOgiYBjbJsnL+q6mMZ
         j5K+uSz4Owr8+NGYcFm+HOi5RUzjVRqfucKQtUe13t+2yA2FxV9gfuim0zPfvwiVDv
         0p7nEsHCy3LhuRgDa6ZgrPG7EF7xzzTcYFruYiGTTx1yfLNzaYEtgyht0m/7you34O
         NvBItWifYB+fycfBGMRzmKE8h1mLgRh6h3o9XV578S7Y/y8a9K3gmsEbrXwKJt2bfW
         rABtukxqQXD2A==
Date:   Wed, 24 Mar 2021 18:09:09 +0000
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org
Subject: Re: [PATCH net-next 4/7] net: phy: marvell10g: add MACTYPE
 definitions for 88X3310/88X3310P
Message-ID: <20210324180909.13df1a48@thinkpad>
In-Reply-To: <20210324165836.GF1463@shell.armlinux.org.uk>
References: <20210324165023.32352-1-kabel@kernel.org>
        <20210324165023.32352-5-kabel@kernel.org>
        <20210324165836.GF1463@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Mar 2021 16:58:36 +0000
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Wed, Mar 24, 2021 at 05:50:20PM +0100, Marek Beh=C3=BAn wrote:
> > Add all MACTYPE definitions for 88X3310/88X3310P.
> >=20
> > In order to have consistent naming, rename
> > MV_V2_PORT_CTRL_MACTYPE_RATE_MATCH to
> > MV_V2_PORT_CTRL_MACTYPE_10GR_RATE_MATCH. =20
>=20
> We probably ought to note that the 88x3310 and 88x3340 will be detected
> by this driver, but have different MACTYPE definitions.

Is 88X3340 supported? The drivers structure only defines for
 .phy_id =3D MARVELL_PHY_ID_88X3310
Do 88X3310 and 3340 have the same PHY_ID ?

Also these registers are different for 88E2110, and the register
which contains MACTYPE has a different address. Yes, I want to do this,
but in another series, because I don't have the board with 88E2210 now.

Marek

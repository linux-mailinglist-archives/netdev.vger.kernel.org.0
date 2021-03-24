Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A740347EFA
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 18:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbhCXRM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 13:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237316AbhCXRMN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 13:12:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39F7761A19;
        Wed, 24 Mar 2021 17:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616605933;
        bh=Xk69GGH+aG4GJUf5lrJ6BkNxigu88kw67+wAzWDNGBU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cqg3hfQzlx0NVjGUpYG0ZZV9FU3mxy0WwJLRd8NThUGJtDf7QYvONSLAF1Z2XQtHB
         jlS5p1EW3CUWJuCSG2I8LHiuCHXoZesSd9D7PRLPU+TZ8cp6yZM3WrVYruhZ+MU7xY
         zLNaGU8+DVA3e/x3R35H/wEJgKOamDxWqfL49By0HrckzA6RXumoDT1u6Kij/qoI0l
         x19KyLXYehOp78R/btRQC1Y2M6vfcZfOWkpQJuhwr4AqsQJb7deNbhdKeUKz29HZ/L
         Kcin/kwsbNWa1m7buxu5is2c9O123pX/8ogBHPwWM5U6R1y1XP7LdtVyD2soSvfvnD
         1ce86viyvEZ0A==
Date:   Wed, 24 Mar 2021 18:12:08 +0000
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org
Subject: Re: [PATCH net-next 5/7] net: phy: marvell10g: save MACTYPE instead
 of rate_matching boolean
Message-ID: <20210324181208.43345704@thinkpad>
In-Reply-To: <20210324165946.GG1463@shell.armlinux.org.uk>
References: <20210324165023.32352-1-kabel@kernel.org>
        <20210324165023.32352-6-kabel@kernel.org>
        <20210324165946.GG1463@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Mar 2021 16:59:46 +0000
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Wed, Mar 24, 2021 at 05:50:21PM +0100, Marek Beh=C3=BAn wrote:
> > Save MACTYPE instead of rate_matching boolean. We will need this for
> > other configurations. =20
>=20
> This could lead us to having to test for multiple different mactype
> values depending on the PHY type in mv3310_update_interface() which
> is something I wanted to avoid.
>=20

This is currently done in patches 6/7 and 7/7...

Either we do this this way, or we save both members
  bool rate_matching;
  phy_interface_t interface10g;
in order not to do this always in mv3310_update_interface().

I guess I am going to change it.

Marek

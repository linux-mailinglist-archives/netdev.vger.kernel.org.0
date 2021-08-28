Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081B23FA236
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 02:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbhH1Ab0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 20:31:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232503AbhH1Ab0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 20:31:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59FAA60EE5;
        Sat, 28 Aug 2021 00:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630110636;
        bh=IE6fE60I4wqU0WZzJB2/nvNBGTSxgP4C2DTHPO6NW9o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oFSomHYqlIHTvJOvqkROmIgh/S+PoJQHZ5CFV0rh/ACgcT3dfYpa0ft/0oo2bLKXa
         /EneaTl73WFvzTHjvaqi6IAdx40vcgvHOxcnn0oQm+0awSOTnuTYIpA5IKqDqRJKPO
         4o9QDkUufJDi7uuGPUZpPXBRJjSlnvZ07AuGzh+AHK/pDhK82BwfF2TuAOV/euEl2o
         rHHf6Rt1xlO9HgsqDooaA4otOasINNYedWwGjnGmnAW/aKFKx8UOFfMLA7Cudnlw9Y
         L2eTPHTiaUQMcBah9P0bSoYg0gjnQJ2ZhF7xpBpLU0Eo87jXgN2R/APo4H4suqNSep
         JYcoSlu3KMiWw==
Date:   Fri, 27 Aug 2021 17:30:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net v2] net: phy: marvell10g: fix broken PHY interrupts
 for anyone after us in the driver probe list
Message-ID: <20210827173035.283f2e12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YSj1o8hrcsPHDrVX@lunn.ch>
References: <20210827132541.28953-1-kabel@kernel.org>
        <YSj1o8hrcsPHDrVX@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Aug 2021 16:24:35 +0200 Andrew Lunn wrote:
> > Fixes: a5de4be0aaaa ("net: phy: marvell10g: fix differentiation of 88X3=
310 from 88X3340")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Tested-by: Marek Beh=C3=BAn <kabel@kernel.org>
> > Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org> =20
>=20
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks everyone.

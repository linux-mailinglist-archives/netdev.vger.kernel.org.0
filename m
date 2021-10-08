Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7849742745B
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 01:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243843AbhJHXts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 19:49:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243797AbhJHXtr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 19:49:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8085360F94;
        Fri,  8 Oct 2021 23:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633736871;
        bh=UqtllO3PxHSjbiuQa9yuulVNPNzvIsSMdDgdTG8gkGQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g1j6luM6R0PQyiO9VJxu4/A1I01RsA7HOnJSFULsfITmDyartYOQMmBM2hW0Yjb1F
         KFst/cjv/8TQj13vbJr5CkE+eqDcn/H+iNn9NwMMxbpGW6CHDjsrxVvN05nRo9Hw8P
         WeWxj4fdJi0D6PJSiWpVD2YMpcGQut3i910kOTSRwxpFT3844ENfyZ2fAjL13GdlBb
         MPRFM0ID2m7LmSJeOi8c7eC4UeC7U9V3K+Q0eVuSBVmarUPRmzw1CqSjrATsv8Ajqt
         9879MtweL4oR42Ikzllje+Oh3r1G+Pjkkv3XP8cT1Wq/1DcjYlWPWU4AD/Ha4w0EBt
         EfN9nMg3B9/gQ==
Date:   Fri, 8 Oct 2021 16:47:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net PATCH 1/2] drivers: net: phy: at803x: fix resume for
 QCA8327 phy
Message-ID: <20211008164750.4007f2d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211008233426.1088-1-ansuelsmth@gmail.com>
References: <20211008233426.1088-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  9 Oct 2021 01:34:25 +0200 Ansuel Smith wrote:
> From Documentation phy resume triggers phy reset and restart
> auto-negotiation. Add a dedicated function to wait reset to finish as
> it was notice a regression where port sometime are not reliable after a
> suspend/resume session. The reset wait logic is copied from phy_poll_reset.
> Add dedicated suspend function to use genphy_suspend only with QCA8337
> phy and set only additional debug settings for QCA8327. With more test
> it was reported that QCA8327 doesn't proprely support this mode and
> using this cause the unreliability of the switch ports, especially the
> malfunction of the port0.
> 
> Fixes: 15b9df4ece17 ("net: phy: at803x: add resume/suspend function to qca83xx phy")

Hm, there's some confusion here. This commit does not exist in net,
and neither does the one from patch 2.

We should be fine with these going into net-next, right Andrew?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255162EE95B
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 23:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbhAGW4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 17:56:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:47786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbhAGW4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 17:56:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18CDE235FA;
        Thu,  7 Jan 2021 22:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610060139;
        bh=FjLZ/L1kR61Ie7LnVeU2vGM2evpxWXE0XtWtaUHvx3M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XxaR0wXnUdetYMOfzdlKBGY45qHeh/qoeUeK30/+3p0sSeWF5yVBML9s+3y5OK/95
         SpsJobnSSDvvSmGDNZYqhKhbml2BCnEibwFzHAm3ccgrYs+h0l4lpyt7mTHmsVsjzz
         9lakR0oTxSLyTAFKbNdy3jhl+7tbe9nerFprBeGFrj58QGV6JiwgHH0zOwr9DgWvi+
         XYtFs+AG+Zq+S5boSOtB8tT5/CwWcrnA9LcPYm14W0WF3bK9irUL2ZqwmV1KDKc3XG
         PatoOMP4bQrZJV1Ctu5Vw5zZcH06s8LGOhF9lho/Ns81wUqSmWAqaoLLMHDTRKQLz3
         5l5NTaLriyIAA==
Date:   Thu, 7 Jan 2021 14:55:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: replace mutex_is_locked with
 lockdep_assert_held in phylib
Message-ID: <20210107145533.17ea01bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <X/d52l7Xv7i4WtBK@lunn.ch>
References: <ccc40b9d-8ee0-43a1-5009-2cc95ca79c85@gmail.com>
        <X/d52l7Xv7i4WtBK@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jan 2021 22:15:06 +0100 Andrew Lunn wrote:
> On Wed, Jan 06, 2021 at 02:03:40PM +0100, Heiner Kallweit wrote:
> > Switch to lockdep_assert_held(_once), similar to what is being done
> > in other subsystems. One advantage is that there's zero runtime
> > overhead if lockdep support isn't enabled.
> > 
> > Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!

If I was willing to let my pedantic flag fly I'd ask for the lockdep
header to be included explicitly, but I guess in practice the chances
of it not being pulled into sources which use locking is 0.

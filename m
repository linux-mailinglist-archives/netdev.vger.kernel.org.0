Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3BF2F41FE
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 03:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbhAMCqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 21:46:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:41544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728202AbhAMCqV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 21:46:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EE88207C8;
        Wed, 13 Jan 2021 02:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610505940;
        bh=InbeshzR2jcMCogkG5+IbdbQ+lHeQ/A9xCz37F0BmpA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UHtQAzfbuOodUR8KMyedmxVlZFWrHPfC144cRBLgemngLaIhiJvgnTJvhDQlYin1S
         oW+nh9i8LfXRzQJvH950xNXxoeiB+IEbC08fWQHRM27r0zyFjad43ac6QCgyTCJ1Or
         mXyBkigsPOvUI4Yp1nJYR2o+OlC+q6tnWXmXkCJ8nFaA01waHFA/zro4sWm4PuQeNo
         EadHaie2ev8LmppHzxBVNLxgP2OtT4Jk3vi6FPHQC4k9I4iYYFP7V5vQ7l8OCMlUgc
         X3XUsjk2tBmj+IxO0X7oEYfobkIUE/GqdqtF/bnMhZFxE85ZnyBIZf+s9UqYB6NLtK
         Cz6Ylnp3lus7g==
Date:   Tue, 12 Jan 2021 18:45:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>, Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH net-next] net: ks8851: Select PHYLIB and MICREL_PHY in
 Kconfig
Message-ID: <20210112184539.6aa005d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <X/xlfe5oxi4zwOeo@lunn.ch>
References: <20210111125046.36326-1-marex@denx.de>
        <X/xlfe5oxi4zwOeo@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jan 2021 15:49:33 +0100 Andrew Lunn wrote:
> On Mon, Jan 11, 2021 at 01:50:46PM +0100, Marek Vasut wrote:
> > The PHYLIB must be selected to provide mdiobus_*() functions, and the
> > MICREL_PHY is necessary too, as that is the only possible PHY attached
> > to the KS8851 (it is the internal PHY).
> > 
> > Fixes: ef3631220d2b ("net: ks8851: Register MDIO bus and the internal PHY")
> > Signed-off-by: Marek Vasut <marex@denx.de>
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: Heiner Kallweit <hkallweit1@gmail.com>
> > Cc: Lukas Wunner <lukas@wunner.de>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!

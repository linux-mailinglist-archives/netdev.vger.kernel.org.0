Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A57B2F41E4
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 03:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbhAMCkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 21:40:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:40528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbhAMCkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 21:40:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 492B02311B;
        Wed, 13 Jan 2021 02:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610505608;
        bh=M6cZSkXVDkdGz/MiguWw/mBuJmE8+oCoCas/T11qQmo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vMEZSkdOxQfpK/BRgKG3cEX6D42gZ5nNyRRCL/5A3JQ5YHqHRdzf09YoHFdbJaQKb
         aVlXe3zB20Ks7R5zirtU3Va4pabhOOtEBF0QWzLLIgDBA/fL6WYMrZgG09Y+FGI3wM
         M63koJcYqU0a7Om7oUEftiie8MgXL0miLQF06hnepRdQVXR+iOtkAmncUbHoPJDdM4
         6ZKSUsfOgTFRxKJtZLCVXYZiGUSypRr+QHM3h3uruh1tjxMFQ35rzsX0DDhvGQCFoD
         mwtS5Agw4b+CDA2HuTLSbasoXlGrIbpX+pJecTMCkqPLRCzgRwEQvJN6+oqWga1VEL
         AGVS+7SEj7/Fw==
Date:   Tue, 12 Jan 2021 18:40:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Marco Felsch <m.felsch@pengutronix.de>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] net: phy: smsc: fix clk error handling
Message-ID: <20210112184007.09f6fedf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <X/xd4T7G99KNv/Vz@lunn.ch>
References: <20210111085932.28680-1-m.felsch@pengutronix.de>
        <X/xd4T7G99KNv/Vz@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jan 2021 15:17:05 +0100 Andrew Lunn wrote:
> On Mon, Jan 11, 2021 at 09:59:32AM +0100, Marco Felsch wrote:
> > Commit bedd8d78aba3 ("net: phy: smsc: LAN8710/20: add phy refclk in
> > support") added the phy clk support. The commit already checks if
> > clk_get_optional() throw an error but instead of returning the error it
> > ignores it.
> > 
> > Fixes: bedd8d78aba3 ("net: phy: smsc: LAN8710/20: add phy refclk in support")
> > Suggested-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!

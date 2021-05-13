Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CC237F7D2
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 14:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233692AbhEMMZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 08:25:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38600 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230097AbhEMMZB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 08:25:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3RfX3ZTxasf3qaleCTBm0QOY9AWrA3aOMELJWashnxs=; b=itpRKvxPi7HM3zOo8sasRb8H5g
        GGJ9WkLPsdcVkcTWFKClkPItOT/VDnDPcRdjLF/V9xXD7vBbUtkd8hFDWejq0V6wzzfZxb8YVeqDx
        GbM8oRZ9HgqfMva6SaTP2SMYYZUm84Cnn6Pj8kaqj6xCqEdxs9cG1eJ38J25u8bfLHF8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lhANW-0043f6-Mn; Thu, 13 May 2021 14:23:46 +0200
Date:   Thu, 13 May 2021 14:23:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, david.daney@cavium.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH V2] net: mdio: thunder: Fix a double free issue in the
 .remove function
Message-ID: <YJ0aUoUNn7/aIPaC@lunn.ch>
References: <f8ad9a9e6d7df4cb02731a71a418acca18353380.1620890611.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8ad9a9e6d7df4cb02731a71a418acca18353380.1620890611.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 09:44:49AM +0200, Christophe JAILLET wrote:
> 'bus->mii_bus' have been allocated with 'devm_mdiobus_alloc_size()' in the
> probe function. So it must not be freed explicitly or there will be a
> double free.
> 
> Remove the incorrect 'mdiobus_free' in the remove function.
> 
> Fixes: 379d7ac7ca31 ("phy: mdio-thunder: Add driver for Cavium Thunder SoC MDIO buses.")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

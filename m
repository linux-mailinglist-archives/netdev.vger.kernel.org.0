Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058F42F23FD
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 01:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbhALAbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:31:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:42262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728045AbhALAbV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 19:31:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A58322CB8;
        Tue, 12 Jan 2021 00:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610411465;
        bh=vZLdTkMoOu2F4nasG0f0KXIUGYxkW5UO6asGtPQPAz0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C0gx2yFE5AgAd/WT16thHDJM2+CEkESES6I+WtrRRmqkd7yveXoyRV8is4xXUow0d
         DQTvADmmze8y7noL2NIbtjtjnLz6vXC3sDEMVe9gdi9O1MuzmN253jxtEXA4flM7JO
         xdhhrlnRWCfE8llVK8bs+i2TBWyxMhVg0pDKKq5fi8M1NxOV1s+rx2NWeVHkvdT2tb
         iBE4SWPbvuclN60K2XnblufTlS86NcO1pz5sJfyTjrB4Z/s0idj6f0ZjZzioP9eb9q
         KJ35aQZvN6qshy+/GWlWN3wCjsOxH5EvORnBVPzoYm0e0+rcANTHsVRjQrJXezq6Ke
         oNWPtORx4b6LQ==
Date:   Mon, 11 Jan 2021 16:31:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: at803x: use phy_modify_mmd()
Message-ID: <20210111163104.603c8f21@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <X/swkuuuZcwgH+sM@lunn.ch>
References: <E1kyc72-0008Pq-1x@rmk-PC.armlinux.org.uk>
        <X/swkuuuZcwgH+sM@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Jan 2021 17:51:30 +0100 Andrew Lunn wrote:
> On Sun, Jan 10, 2021 at 02:54:36PM +0000, Russell King wrote:
> > Convert at803x_clk_out_config() to use phy_modify_mmd().
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470CA2F0878
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 17:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbhAJQwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 11:52:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59936 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbhAJQwM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 11:52:12 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kydwA-00HL33-2s; Sun, 10 Jan 2021 17:51:30 +0100
Date:   Sun, 10 Jan 2021 17:51:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: at803x: use phy_modify_mmd()
Message-ID: <X/swkuuuZcwgH+sM@lunn.ch>
References: <E1kyc72-0008Pq-1x@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1kyc72-0008Pq-1x@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 02:54:36PM +0000, Russell King wrote:
> Convert at803x_clk_out_config() to use phy_modify_mmd().
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

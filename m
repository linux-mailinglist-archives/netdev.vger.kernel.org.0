Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A67015FFEF
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 20:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgBOTAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 14:00:30 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47938 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbgBOTAa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 14:00:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TtPJ+qE+Eg6lpy2DJzJV/azNBZSNkn0sauiYHXoHjn0=; b=gdUXVhYrHCTfED8xFjE8Ajv+Ns
        q8hnY/D3xrqrpxiON5160AzjKU/FIaYGutlSmJJR3nIAGp1452Q4Ea05RmJP7JyUR2Y35x36pAD68
        VrPzrYtlsoyFXzl2BvK01ui2BneQLtjolqwXHIhFLOJ5oexG82eCmrERx/aaFf6IOk/8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j32fy-0005BL-5T; Sat, 15 Feb 2020 20:00:26 +0100
Date:   Sat, 15 Feb 2020 20:00:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 05/10] net: phylink: ensure manual flow control
 is selected appropriately
Message-ID: <20200215190026.GV31084@lunn.ch>
References: <20200215154839.GR25745@shell.armlinux.org.uk>
 <E1j2zhP-0003Xf-2o@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j2zhP-0003Xf-2o@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 15, 2020 at 03:49:43PM +0000, Russell King wrote:
> Split the application of manually controlled flow control modes from
> phylink_resolve_flow(), so that we can use alternative providers of
> flow control resolution.
> 
> We also want to clear the MLO_PAUSE_AN flag when autoneg is disabled,
> since flow control can't be negotiated in this circumstance.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

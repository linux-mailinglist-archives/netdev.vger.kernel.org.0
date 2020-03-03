Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07B2A178260
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730965AbgCCSXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 13:23:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44224 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731254AbgCCSXN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 13:23:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1fl0+3/sWjeztZruVxHuVV8uyTP+lorC1gsQwT6cQaw=; b=VoPHRZfNwHXUBU8hVqWQgBghHr
        GmXVYTc9B4dWGrP9aILzuaUSziDwC2H8hhxP2U4qb+GzCI8/QYW4x0+FfU0gwWEKFCXGDh8XGsbEZ
        DaWh7vniSSzNw1AGfO1z15JmYz86os3PqVdP42djoQo+3255ovCHRNhBCPbhlWQAZT3E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j9CCB-0008SA-2I; Tue, 03 Mar 2020 19:23:07 +0100
Date:   Tue, 3 Mar 2020 19:23:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/3] net: phy: marvell10g: add energy detect
 power down tunable
Message-ID: <20200303182307.GA31580@lunn.ch>
References: <20200303180747.GT25745@shell.armlinux.org.uk>
 <E1j9ByC-0003pI-2h@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j9ByC-0003pI-2h@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 06:08:40PM +0000, Russell King wrote:
> Add support for the energy detect power down tunable, which saves
> around 600mW when the link is down. The 88x3310 supports off, rx-only
> and NLP every second. Enable EDPD by default for 88x3310.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

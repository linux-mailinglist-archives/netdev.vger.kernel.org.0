Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E32F3118E89
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbfLJRGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:06:15 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45248 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727525AbfLJRGO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 12:06:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=64vBQreRYGGQCTi+wf/flYIUuREIxjjkqLmOXdaeMQw=; b=cNxoyrNKyoJDBy3/XYsCP2ItFj
        eRcXi2gh3506miHFnx1TIRfDVJdm51o5OfhbvJSqE5brLPa71vp4ECc8gHMZ+De/GUqf3ycwH4tNL
        WkN/5CMhmuThwIEnPh4pt5an/DIopsG8+OxqQcXhsc9SLmnJb+Pb7+24blMpUD85a53M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ieixf-0005Zf-SM; Tue, 10 Dec 2019 18:06:11 +0100
Date:   Tue, 10 Dec 2019 18:06:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 07/14] net: phylink: re-split
 __phylink_connect_phy()
Message-ID: <20191210170611.GM27714@lunn.ch>
References: <20191209151553.GP25745@shell.armlinux.org.uk>
 <E1ieKoP-0004vF-8F@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ieKoP-0004vF-8F@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 03:19:01PM +0000, Russell King wrote:
> In order to support Clause 45 PHYs on SFP+ modules, which have an
> indeterminant phy interface mode, we need to be able to call
> phylink_bringup_phy() with a different interface mode to that used when
> binding the PHY. Reduce __phylink_connect_phy() to an attach operation,
> and move the call to phylink_bringup_phy() to its call sites.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

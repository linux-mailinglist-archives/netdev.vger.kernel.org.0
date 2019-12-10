Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64FA2118E86
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfLJRFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:05:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45236 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727482AbfLJRFk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 12:05:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cZ6Ae0ycScSl+++rS4gmmAa0BDu++Ldv5A2nYLHg/f8=; b=5nfrEx0F6z4ftqcuoInCf4P89A
        lM55xiuGoqBsDMI+UunIAQn4vYQLeaxFLPhLwcrjcEox9CcWFnE2mgSAnWk28ErxRnK3/e9JyW6uE
        Levf/dudZU5DuImRd4mcYsq9BgiP6WGz9eiXtKXJQELYJ9ne7Q2OG08NqGeNzR9lsuNY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ieix6-0005Z3-Bb; Tue, 10 Dec 2019 18:05:36 +0100
Date:   Tue, 10 Dec 2019 18:05:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 06/14] net: mdio-i2c: add support for Clause
 45 accesses
Message-ID: <20191210170536.GL27714@lunn.ch>
References: <20191209151553.GP25745@shell.armlinux.org.uk>
 <E1ieKoJ-0004v8-T1@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ieKoJ-0004v8-T1@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 03:18:55PM +0000, Russell King wrote:
> Some SFP+ modules have PHYs on them just like SFP modules do, except
> they are Clause 45 PHYs.  The I2C protocol used to access them is
> modified slightly in order to send the device address and 16-bit
> register index.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

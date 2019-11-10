Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF4CF6A8E
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 18:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfKJRXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 12:23:09 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59212 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbfKJRXI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 12:23:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pHGzEAbAQBO65sBr1hTCtxyX9Mn9hTaXOKEkQC2DqNk=; b=I0qvzbnUwGl8mMoIAYaFjlublW
        SfJITYSC9k+IK3GOO57pjTYyQRP6XzI9ORS6IGu4C/482XmoR+DFed8ffXggfFtQqwaa/hCJqIoQ3
        UW/0au/qnuslXmhcxB2qCcosNzNyFaxeu/KIV1NuIs7Yx91ditQjFW9Hg+JTFX2iTN4A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTqvZ-00075i-UU; Sun, 10 Nov 2019 18:23:05 +0100
Date:   Sun, 10 Nov 2019 18:23:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: sfp: fix sfp_bus_put() kernel documentation
Message-ID: <20191110172305.GK25889@lunn.ch>
References: <E1iTnp5-0004rn-Ah@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iTnp5-0004rn-Ah@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 02:04:11PM +0000, Russell King wrote:
> The kbuild test robot found a problem with htmldocs with the recent
> change to the SFP interfaces.  Fix the kernel documentation for
> sfp_bus_put() which was missing an '@' before the argument name
> description.
> 
> Fixes: 727b3668b730 ("net: sfp: rework upstream interface")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

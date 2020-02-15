Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE6515FF2D
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 17:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgBOQM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 11:12:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47836 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgBOQM1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 11:12:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=C3E+BEractzzZASP0CPsgh1gq974KllkdqYRKPCm5g8=; b=Xl3k0OTo6MjUMwZd6/akmdl2M8
        XcQOqmrO9c9clz6QGp+vOitkEOrF+Sp9Grr9ThUFVAkEghVCxFVOnyRRTSIZgxp9Ew6dO9Lx2bog7
        +T1EkhUEuQNH3TuKAkcgDBFgnd5xqWH1GFUDSvNcUczMlvED7ajmqU3RS2Z2/Riojen0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j303L-0004lq-U4; Sat, 15 Feb 2020 17:12:23 +0100
Date:   Sat, 15 Feb 2020 17:12:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] net: phy: broadcom: Allow BCM54810 to use
 bcm54xx_adjust_rxrefclk()
Message-ID: <20200215161223.GC8924@lunn.ch>
References: <20200214233853.27217-1-f.fainelli@gmail.com>
 <20200214233853.27217-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214233853.27217-2-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 03:38:51PM -0800, Florian Fainelli wrote:
> The function bcm54xx_adjust_rxrefclk() works correctly on the BCM54810
> PHY, allow this device ID to proceed through.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

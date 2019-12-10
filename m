Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E56E2118E63
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 17:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbfLJQ7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 11:59:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45204 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727562AbfLJQ7X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 11:59:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XCnrvfK/6ZSwWtUa4WnRzsawMPuUS+/ZEAOjeYKVcR0=; b=O/hAO5hyNVYYkbZIrFj71Q0agz
        0h95UxPKyiYVAssw4hFPOYfFhP6hVrga3KIAw/q0Ro4uqG40jMo6qGo55gmNl6XIU32cEfXyYwWYN
        EA65GtC5Tvr9M7atPedyeStBSK+/TofX7ng98+s0fGv/0AknFsrtc+ttQW/5y9xxv5Eo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ieir1-0005Vr-69; Tue, 10 Dec 2019 17:59:19 +0100
Date:   Tue, 10 Dec 2019 17:59:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 04/14] net: sfp: add module start/stop
 upstream notifications
Message-ID: <20191210165919.GJ27714@lunn.ch>
References: <20191209151553.GP25745@shell.armlinux.org.uk>
 <E1ieKo8-0004uu-Uh@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ieKo8-0004uu-Uh@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 03:18:44PM +0000, Russell King wrote:
> When dealing with some copper modules, we can't positively know the
> module capabilities are until we have probed the PHY. Without the full
> capabilities, we may end up failing a module that we could otherwise
> drive with a restricted set of capabilities.
> 
> An example of this would be a module with a NBASE-T PHY plugged into
> a host that supports phy interface modes 2500BASE-X and SGMII. The
> PHY supports 10GBASE-R, 5000BASE-X, 2500BASE-X, SGMII interface modes,
> which means a subset of the capabilities are compatible with the host.
> 
> However, reading the module EEPROM leads us to believe that the module
> only supports ethtool link mode 10GBASE-T, which is incompatible with
> the host - and thus results in the module being rejected.
> 
> This patch adds an extra notification which are triggered after the
> SFP module's PHY probe, and a corresponding notification just before
> the PHY is removed.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew


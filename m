Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB989118EB6
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbfLJROr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:14:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45308 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727494AbfLJROr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 12:14:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WdGeeHnryWLJKNuvAFnjd8R7XCOPBtDA/zUUd0OuFTg=; b=ZQKx9+hdl6aluwDo8Xq5UIQYTs
        iNUe10g8Lv/T4K13RD0tv2bo3RzYmK2icCMV+T9GrQTxA+8mzy9JfgdTfVMyTtz/2mD13CMMVF/Yi
        yflpXiMBE1gHeGeIPF9zrzcSvtvczJ5/P/Xo4uIu2Uf8iebVfahhEiy/y3c81T5gnBIg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iej5v-0005fc-VZ; Tue, 10 Dec 2019 18:14:43 +0100
Date:   Tue, 10 Dec 2019 18:14:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 11/14] net: phylink: delay MAC configuration
 for copper SFP modules
Message-ID: <20191210171443.GQ27714@lunn.ch>
References: <20191209151553.GP25745@shell.armlinux.org.uk>
 <E1ieKok-0004vi-MD@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ieKok-0004vi-MD@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 03:19:22PM +0000, Russell King wrote:
> Knowing whether we need to delay the MAC configuration because a module
> may have a PHY is useful to phylink to allow NBASE-T modules to work on
> systems supporting no more than 2.5G speeds.
> 
> This commit allows us to delay such configuration until after the PHY
> has been probed by recording the parsed capabilities, and if the module
> may have a PHY, doing no more until the module_start() notification is
> called.  At that point, we either have a PHY, or we don't.
> 
> We move the PHY-based setup a little later, and use the PHYs support
> capabilities rather than the EEPROM parsed capabilities to determine
> whether we can support the PHY.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew


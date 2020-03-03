Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95134177CDA
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 18:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729766AbgCCRKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 12:10:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44052 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729556AbgCCRJ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 12:09:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KZ/NRYydjCoJHAOqNH38P7Q8kb+/1Wc8n47Xy3QVEtg=; b=2pQE6SFOwL8I9xY016ajNEtveF
        stqp7FeaTXtLS03WUdqAVqAQqWK0iNLlUY9q4lnj9gQDIDO1bPN/HZrklxmSU8FfYCJB9n3X9WJDg
        0si/EwSSTWNo+vlrQYX4n1KWebfGY+8ayDzrCJm14Oz3NccG76ijYn+htKODiZEBzo6E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j9B3M-0007v7-Dg; Tue, 03 Mar 2020 18:09:56 +0100
Date:   Tue, 3 Mar 2020 18:09:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/3] net: phy: marvell10g: place in powersave
 mode at probe
Message-ID: <20200303170956.GL24912@lunn.ch>
References: <20200303155347.GS25745@shell.armlinux.org.uk>
 <E1j99sC-00011f-22@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j99sC-00011f-22@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 03:54:20PM +0000, Russell King wrote:
> Place the 88x3310 into powersaving mode when probing, which saves 600mW
> per PHY. For both PHYs on the Macchiatobin double-shot, this saves
> about 10% of the board idle power.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

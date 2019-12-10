Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4CBC118E68
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbfLJRAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:00:05 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45214 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727594AbfLJRAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 12:00:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=y9MUQSMlJD9E0ei8BcYBFlHuBSFbTOb7jF9KH1FIE4k=; b=bV/9BFCWR+Rek7WMjXEx2DVeyD
        vutL/5kn0r7xZEWvodcOHbxXOPGiup0Erj7nfvHyJnvjP51jwmxOZI9HrfChXzbJlZIpjD9OnUMCB
        /oXLKKOupxAzyFywzdeU/e603ctWhkrfwSlQtNd53V1gQWBoINTOx6nQiwpGP5mj2e1E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ieirh-0005WR-NQ; Tue, 10 Dec 2019 18:00:01 +0100
Date:   Tue, 10 Dec 2019 18:00:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 05/14] net: sfp: move phy_start()/phy_stop()
 to phylink
Message-ID: <20191210170001.GK27714@lunn.ch>
References: <20191209151553.GP25745@shell.armlinux.org.uk>
 <E1ieKoE-0004v1-Af@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ieKoE-0004v1-Af@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 03:18:50PM +0000, Russell King wrote:
> Move phy_start() and phy_stop() into the module_start and module_stop
> notifications in phylink, rather than having them in the SFP code.
> This gives phylink responsibility for controlling the PHY, rather
> than having SFP start and stop the PHY state machine.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

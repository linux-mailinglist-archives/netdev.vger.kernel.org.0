Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 778CA18581E
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbgCOByk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:54:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36040 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727668AbgCOByj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Mar 2020 21:54:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ky87XwC6u3YLxUt+rdtAcAcKm2EwReGDdlr9fCIQii8=; b=rHonxrLMHCDxJo/n7kLXOJtLYL
        wyTNnOoGeYWMKn0nMgH9M35jrhVtmQpGDCsZFDxhHugIGRHkeOXxJwzbhn4Bvi+w6n6P9x2N+QnTw
        aqTY8JvlCj+w1gsphixiifsJoXis+mlmyTYTZNSItZEGL3AuUYRvEiLTF9BshEa6KfRo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jDBdP-0001bf-MQ; Sat, 14 Mar 2020 19:35:43 +0100
Date:   Sat, 14 Mar 2020 19:35:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 2/8] net: dsa: mv88e6xxx: use BMCR definitions
 for serdes control register
Message-ID: <20200314183543.GF5388@lunn.ch>
References: <20200314101431.GF25745@shell.armlinux.org.uk>
 <E1jD3pN-0006DM-AA@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jD3pN-0006DM-AA@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 14, 2020 at 10:15:33AM +0000, Russell King wrote:
> The SGMII/1000base-X serdes register set is a clause 22 register set
> offset at 0x2000 in the PHYXS device. Rather than inventing our own
> defintions, use those that already exist, and name the register
> MV88E6390_SGMII_BMCR.  Also remove the unused MV88E6390_SGMII_STATUS
> definitions.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

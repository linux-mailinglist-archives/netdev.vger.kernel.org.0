Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D71BDF9098
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 14:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbfKLN0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 08:26:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35718 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727047AbfKLN0Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 08:26:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dE/Jgw28Vq2IjFxagqxspxlNAFnz5xX9TXfS+8o5LEE=; b=aYJgtF/zKLKDV+Nomvw8mU79il
        8ozZWs9CspV4nyWLfLyWwHlGuMmodwNaAJmEnUPVSuunech+jAl1yg7ZmmLDlyMnWTR+cN/ly1uew
        ioIzMDq+OtTdbdbjPaNdCza6xtO8fZbv3MGGunlpUKQ2Sql7Y1d3nwR8fS/TETBSW3+E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUWBT-0001VY-Af; Tue, 12 Nov 2019 14:26:15 +0100
Date:   Tue, 12 Nov 2019 14:26:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH net-next] net: sfp: fix sfp_bus_add_upstream() warning
Message-ID: <20191112132615.GB5090@lunn.ch>
References: <E1iUURo-0003A9-KA@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iUURo-0003A9-KA@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 11:35:00AM +0000, Russell King wrote:
> When building with SFP disabled, the stub for sfp_bus_add_upstream()
> missed "inline".  Add it.
> 
> Fixes: 727b3668b730 ("net: sfp: rework upstream interface")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

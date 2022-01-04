Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A28484626
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 17:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbiADQpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 11:45:55 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51240 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230369AbiADQpz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 11:45:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9s3nFY3LX9thHW7sytmCeyLIIqlCbrCXcuaSSXogKPs=; b=Bt00kz8igCnND/VMKvvlpNb+DN
        5s6E0JblhgoFJXt2p+Y8Iml4CoCpNulp26W0KJMauL3M4Yuxe728RZH8PYr/sFwXb1WIPrso2Z0lC
        UcMOqN4OFLWROUvnmn0j3EA7+dLfcBtAsps3dv69MyhLjUpsLTWZnfJWzy9HELP2yazU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n4mwZ-000U9I-Ta; Tue, 04 Jan 2022 17:45:51 +0100
Date:   Tue, 4 Jan 2022 17:45:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: phy: marvell: configure RGMII delays
 for 88E1118
Message-ID: <YdR5v0itgRDCN1iA@lunn.ch>
References: <YdR3wYFkm4eJApwb@shell.armlinux.org.uk>
 <E1n4mpH-002PKK-37@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1n4mpH-002PKK-37@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 04:38:19PM +0000, Russell King (Oracle) wrote:
> Corentin Labbe reports that the SSI 1328 does not work when allowing
> the PHY to operate at gigabit speeds, but does work with the generic
> PHY driver.
> 
> This appears to be because m88e1118_config_init() writes a fixed value
> to the MSCR register, claiming that this is to enable 1G speeds.
> However, this always sets bits 4 and 5, enabling RGMII transmit and
> receive delays. The suspicion is that the original board this was
> added for required the delays to make 1G speeds work.
> 
> Add the necessary configuration for RGMII delays for the 88E1118 to
> bring this into line with the requirements for RGMII support, and thus
> make the SSI 1328 work.
> 
> Corentin Labbe has tested this on gemini-ssi1328 and gemini-ns2502.
> 
> Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

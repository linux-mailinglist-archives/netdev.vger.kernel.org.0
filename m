Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C413117315
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfLIRrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 12:47:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42822 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726502AbfLIRrr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 12:47:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=iUBWFcQR3dwW8p3hoT+3tnKrFTVwMb/vRUvHUFDJhiU=; b=etZvBj1rK0ltD8lGoI0QT5VoiN
        5OJnNyWnB6JYs1nETpV+8/f0sfoGac2byI8/fHMF0RxaCnEM8DLCbcgBOidrTs8qKq9Nka90aU9dG
        vufxVy8mfwpHFal8nZ5csRgxYrsDpCMX3fvqkTK5yaLIJrYHLCwEhu7pTbknEQbLwWic=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ieN8K-0006uF-1x; Mon, 09 Dec 2019 18:47:44 +0100
Date:   Mon, 9 Dec 2019 18:47:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: sfp: re-attempt probing for phy
Message-ID: <20191209174744.GJ9099@lunn.ch>
References: <20191209141525.GK25745@shell.armlinux.org.uk>
 <E1ieJpb-0004Uo-73@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ieJpb-0004Uo-73@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 02:16:11PM +0000, Russell King wrote:
> Some 1000BASE-T PHY modules take a while for the PHY to wake up.
> Retry the probe a number of times before deciding that the module has
> no PHY.
> 
> Tested with:
>  Sourcephotonics SPGBTXCNFC - PHY takes less than 50ms to respond.
>  Champion One 1000SFPT - PHY takes about 200ms to respond.
>  Mikrotik S-RJ01 - no PHY
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

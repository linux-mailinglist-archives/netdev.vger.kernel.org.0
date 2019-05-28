Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6CB2C8F6
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 16:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfE1Olk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 10:41:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35556 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbfE1Olj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 10:41:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ucgdIeNHZxwmIiMOriYM4fiYn0jFrfHMJ60m3KZIxbg=; b=c2CEsM9cTVCBZ3qURz06Wfv14q
        yq+IIm+SO+Q127sJxkeRaZ5SGNiPGc2/MRIhzV5mA20fp9AsB8pYaM6rFwXHAD/WaA4CzUcdWnvTb
        bJ8mYX35DXIV7K1Mv1WQfv7v4asgrm7BvXD6zVVExxKWpUpo74WneBKZ6HIG3OopeWA8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hVdIA-0007T0-U9; Tue, 28 May 2019 16:41:30 +0200
Date:   Tue, 28 May 2019 16:41:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell10g: report if the PHY fails to boot
 firmware
Message-ID: <20190528144130.GI18059@lunn.ch>
References: <E1hVYVG-0005D8-8w@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1hVYVG-0005D8-8w@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 10:34:42AM +0100, Russell King wrote:
> Some boards do not have the PHY firmware programmed in the 3310's flash,
> which leads to the PHY not working as expected.  Warn the user when the
> PHY fails to boot the firmware and refuse to initialise.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Fixes: 20b2af32ff3f ("net: phy: add Marvell Alaska X 88X3310 10Gigabit PHY support")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

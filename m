Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D01B1E25CE
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgEZPne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:43:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49854 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727898AbgEZPne (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 11:43:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=T0ePco9bS8ijwIRr1MySMZuVMfVVvC60IggVOTHnYQg=; b=Y/aJG4Y8W4oDDqouWWLmgP0dQl
        DhLKSCIUOP0yopIisym6WYPmzyHL5Wf9PJpd7RNFT4+1S5AoTP/XuHnU0lJX/SzDleQMkDZLy7rp7
        mRJj2cqAgw+ZNbmzSV/rThPer1tIsvGUNanBpDXstM1zA2A7xPiHN5oJN/2PTlIfaqzw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdbji-003IU1-9L; Tue, 26 May 2020 17:43:26 +0200
Date:   Tue, 26 May 2020 17:43:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jeremy Linton <jeremy.linton@arm.com>
Subject: Re: [PATCH net-next] net: mdiobus: add clause 45 mdiobus accessors
Message-ID: <20200526154326.GB782807@lunn.ch>
References: <E1jdbWK-00083w-Ot@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jdbWK-00083w-Ot@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 04:29:36PM +0100, Russell King wrote:
> There is a recurring pattern throughout some of the PHY code converting
> a devad and regnum to our packed clause 45 representation. Rather than
> having this scattered around the code, let's put a common translation
> function in mdio.h, and provide some register accessors.
> 
> Convert the phylib core, phylink, bcm87xx and cortina to use these.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

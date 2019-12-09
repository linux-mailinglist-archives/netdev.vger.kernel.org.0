Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9684117305
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfLIRnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 12:43:52 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42772 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbfLIRnv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 12:43:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SjbJnSN4VrNdSki263vd7NGEa99Afo65nFx+lbbW5U8=; b=NMz2G9mFh9f2f/dr8gDHrlvsGd
        tUJcEz7E4NuGGuDWEahNWZQBLZS85BqAoRJdh/qnOgsgpdBhNhRzDVzmsIWYbEayYI2foi6bcB7jC
        TLzKBaO0cBGBp2P6LbYTd9K7bBwL6AcbibmIZARYykE8B5mVYnV0IRM4AEFdTlNJDub8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ieN4W-0006qG-5k; Mon, 09 Dec 2019 18:43:48 +0100
Date:   Mon, 9 Dec 2019 18:43:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] net: sfp: use a definition for the fault
 recovery attempts
Message-ID: <20191209174348.GG9099@lunn.ch>
References: <20191209141525.GK25745@shell.armlinux.org.uk>
 <E1ieJpL-0004UQ-L7@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ieJpL-0004UQ-L7@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 02:15:55PM +0000, Russell King wrote:
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

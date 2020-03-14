Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73B47185823
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgCOByn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:54:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36040 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727674AbgCOBym (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Mar 2020 21:54:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oMamTWHXGG0ied2IFib7/pfEFx82mnqAvUZh0LdzAoQ=; b=2PENIvhSvFBN2YDNZuZlfwK4NR
        UdAWOoOfK0Cu+5ponLGsgg/GIvR4OYVA/nMFLEstrihl69I2FKdNSWOaFkSX0B9N6kWyihMrQNBOE
        vUpIWCcvSyekKczJatejKhYZMEOj5ZM35XU+JasSJ585YT0+xGdfZBdhxaemQuAe6NVY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jDBc2-0001b0-Kz; Sat, 14 Mar 2020 19:34:18 +0100
Date:   Sat, 14 Mar 2020 19:34:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 1/8] net: dsa: warn if phylink_mac_link_state
 returns error
Message-ID: <20200314183418.GE5388@lunn.ch>
References: <20200314101431.GF25745@shell.armlinux.org.uk>
 <E1jD3pI-0006DE-6T@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jD3pI-0006DE-6T@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 14, 2020 at 10:15:28AM +0000, Russell King wrote:
> Issue a warning to the kernel log if phylink_mac_link_state() returns
> an error. This should not occur, but let's make it visible.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

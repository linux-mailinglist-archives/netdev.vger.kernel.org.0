Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 391C1F6AB9
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 19:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbfKJSTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 13:19:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59330 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726684AbfKJSTr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 13:19:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bUNh01Emfi6h124v+a0B5g8+8uuBEOeNkKNUnbSVWoE=; b=02Mz1cUUnv9ByASYWP63ht4fMy
        IS7vJXIfwh9HQZCmfLtHq8/3ujA0kFgkrI/v+Y2sbRfxtg+VNYascXNQDcH5ktkmPaWRlnBObGd9A
        79i9Ih4rY937APY2fdLb/FXQh25GgKY5LVQm6+tihARm38zbIdlZQQaWrFpo7xmga6Ww=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTroN-0007IS-0U; Sun, 10 Nov 2019 19:19:43 +0100
Date:   Sun, 10 Nov 2019 19:19:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 09/17] net: sfp: split the PHY probe from
 sfp_sm_mod_init()
Message-ID: <20191110181942.GU25889@lunn.ch>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
 <E1iTnri-0005Aq-CV@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iTnri-0005Aq-CV@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 02:06:54PM +0000, Russell King wrote:
> Move the PHY probe into a separate function, splitting it from
> sfp_sm_mod_init().  This will allow us to eliminate the 50ms mdelay()
> inside the state machine.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>


Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47217F6AB4
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 19:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfKJSOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 13:14:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59318 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726684AbfKJSON (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 13:14:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IZyd4ebOO8ngbIxSVDRy9jekIDiLqEywP45C4ewmtc4=; b=5WhbG3ZNlk+eDBdKEgTYUR0UX+
        oAr2a7VC49YnfRKrmgyf5683rlk968ezrNojrGihRWfNkJXMJsaERpt/44U3f8tm2LhjZXPnRWqJk
        oM0RuHyu1Yp6N83xSsmFYC7kOrlUyBIq9L6Btg6EeH/zDJjc/GkJgRWicGCuf4+Z3F9Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTrj0-0007H8-Dy; Sun, 10 Nov 2019 19:14:10 +0100
Date:   Sun, 10 Nov 2019 19:14:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 08/17] net: sfp: control TX_DISABLE and phy only
 from main state machine
Message-ID: <20191110181410.GT25889@lunn.ch>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
 <E1iTnrd-0005Ad-9B@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iTnrd-0005Ad-9B@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 02:06:49PM +0000, Russell King wrote:
> We initialise TX_DISABLE when the sfp cage is probed, and then
> maintain its state in the main state machine.  However, the module
> state machine:
> - negates it when detecting a newly inserted module when it's already
>   guaranteed to be negated.
> - negates it when the module is removed, but the main state machine
>   will do this anyway.
> 
> Make TX_DISABLE entirely controlled by the main state machine.
> 
> The main state machine also probes the module for a PHY, and removes
> the PHY when the the module is removed.  Hence, removing the PHY in
> sfp_sm_module_remove() is also redundant, and is a left-over from
> when we tried to probe for the PHY from the module state machine.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

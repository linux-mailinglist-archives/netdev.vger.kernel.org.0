Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6215CF6A9F
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 18:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfKJR4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 12:56:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59246 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbfKJR4M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 12:56:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kY4AViDfQXQhIPiW5LKXb9RuvaDVE3Lg64XiUb8kABA=; b=djg4C6PsJvDT5krSygu/wOxg9m
        H4HDwT7q1mIka5ptNxEzXTqO1dcU3Q2C9S6hzyuR7eFQuElpzicSpop0zxXBR2bzNx2XHc8I1tZ/a
        yCUnbgoV+MAIMoL6ObgK69GXPoC1xp00fiqIMBgEO1pMtzUJsD0MsnGf2q0n462DZSvY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTrRY-0007BX-Kz; Sun, 10 Nov 2019 18:56:08 +0100
Date:   Sun, 10 Nov 2019 18:56:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 01/17] net: sfp: move sfp sub-state machines
 into separate functions
Message-ID: <20191110175608.GM25889@lunn.ch>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
 <E1iTnr3-00059H-CF@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iTnr3-00059H-CF@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 02:06:13PM +0000, Russell King wrote:
> Move the SFP sub-state machines out of the main state machine function,
> in preparation for it doing a bit more with the device state.  By doing
> so, we ensure that our debug after the main state machine is always
> printed.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

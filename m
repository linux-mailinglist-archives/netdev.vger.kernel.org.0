Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4F871886EC
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 15:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgCQOJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 10:09:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40852 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgCQOJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 10:09:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Buvp6BsL3qsIBxmfC9LRrxK78WBfNMvFSO0saeMQUUM=; b=fqov4ZjxddSq6N79FOz5jdmu+T
        E1xS8AvM0grCuqvh2aTRdXkvjbiUXcPM2EzB004zUXr4sBR8520InrhvR0tLc6r7Jk0qPB9h3nHuL
        VxadaNq0dedMXmz/ZrYLtTXP0eMA81OL/CX3wrmKEJGwmH1HZvTlOTlIxkV9+wehdINU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jECtw-0006nb-Av; Tue, 17 Mar 2020 15:09:00 +0100
Date:   Tue, 17 Mar 2020 15:09:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: mdiobus: add APIs for modifying a MDIO
 device register
Message-ID: <20200317140900.GS24270@lunn.ch>
References: <20200314103102.GJ25745@shell.armlinux.org.uk>
 <E1jD44i-0006Mj-9J@rmk-PC.armlinux.org.uk>
 <20200314215728.GG8622@lunn.ch>
 <20200316091207.GM25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316091207.GM25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi Russell
> > 
> > There seems to be growing push back on using BUG_ON and its
> > variants. If should only be used if the system is so badly messed up,
> > going further would only cause more damage. What really happens here
> > if it is called in interrupt context? The mutex lock probably won't
> > work, and we might corrupt the state of the PCS. That is not the end
> > of the world. So i would suggest a WARN_ON here.
> 
> Do we even need these checks? (phylib has them scattered throughout
> on the bus accessors.)  Aren't the might_sleep() checks that are
> already in the locking functions already sufficient?

Hi Russell

I agree, the might_sleep() should be sufficient.

  Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45B78F6AB2
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 19:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfKJSMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 13:12:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59308 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726684AbfKJSMr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 13:12:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=avz5o7e+rlAjrAR6DL8MIfkEnANHswpYr+Jc5snnXcU=; b=B6GSpEaMGRKBeb/IJm8jy0bY/k
        kraIa7+KzaeZJJ+vmf94CUyDfhhMPv5J4msFkCVBePLU68OFOZsiAp+r0/M2aCALjPtUBNg/gmJTg
        1cWIlaI3NUz1SbeRSmmlOuT9jwu1r8p3Mo6LQ+0cHtpw4RrcVHj2r9S5sKxto68WoHy0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTrhb-0007GY-I8; Sun, 10 Nov 2019 19:12:43 +0100
Date:   Sun, 10 Nov 2019 19:12:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 07/17] net: sfp: avoid power switch on
 address-change modules
Message-ID: <20191110181243.GS25889@lunn.ch>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
 <E1iTnrY-0005AQ-5o@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iTnrY-0005AQ-5o@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 02:06:44PM +0000, Russell King wrote:
> If the module indicates that it requires an address change sequence to
> switch between address 0x50 and 0x51, which we don't support, we can't
> write to the register that controls the power mode to switch to high
> power mode.  Warn the user that the module may not be functional in
> this case, and don't try to change the power mode.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew


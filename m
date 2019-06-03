Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4448F3394B
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 21:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbfFCTwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 15:52:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52102 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbfFCTwy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 15:52:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RsUg87dAobfAiplMu0/0jwwgrBPCdJebNZeo5hRL40k=; b=W4+FGBY/S7rki270opj8y+RsWG
        7xertR3XOA6oMReh5Gv4m0FVQYHi7cFNZpW4Vs5rw+H+MGmNIcyPMHDcGXvXhQBvNyCwq98mZ6xYd
        EQ3DBClccK3eY+WzgjMq6mZ9P/X4E9rMqJj6Q/a6dfIYmYitPnLP+fIIb56tXt4nyCcE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hXt0h-0007ie-Ax; Mon, 03 Jun 2019 21:52:47 +0200
Date:   Mon, 3 Jun 2019 21:52:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: sfp: read eeprom in maximum 16 byte increments
Message-ID: <20190603195247.GM19627@lunn.ch>
References: <E1hXREK-0005KT-1e@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1hXREK-0005KT-1e@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 02, 2019 at 03:13:00PM +0100, Russell King wrote:
> Some SFP modules do not like reads longer than 16 bytes, so read the
> EEPROM in chunks of 16 bytes at a time.  This behaviour is not specified
> in the SFP MSAs, which specifies:
> 
>  "The serial interface uses the 2-wire serial CMOS E2PROM protocol
>   defined for the ATMEL AT24C01A/02/04 family of components."
> 
> and
> 
>  "As long as the SFP+ receives an acknowledge, it shall serially clock
>   out sequential data words. The sequence is terminated when the host
>   responds with a NACK and a STOP instead of an acknowledge."
> 
> We must avoid breaking a read across a 16-bit quantity in the diagnostic
> page, thankfully all 16-bit quantities in that page are naturally
> aligned.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

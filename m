Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7101F6AAE
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 19:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfKJSIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 13:08:38 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59288 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726684AbfKJSIh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 13:08:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HBjgcAY3AMdZe+aQfU8ZFqYI5zzXrtvOzEQqCABSAyU=; b=SrRSSJZwYd4bu886b64E75KMa6
        w6/3FfPEIAFIKSHfxphWHNeCeKOrQXn1rDZJsNLgszaUtTCdUXzr/31oESkueYv3h6NIrP9UV0zDM
        ohnvrP5GHoxskkxFpDtkWi+dk+kyFUdnReuHb3x+psY0yDVIUz0vhUK6qhdPV6ffrkCc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTrda-0007EY-UQ; Sun, 10 Nov 2019 19:08:34 +0100
Date:   Sun, 10 Nov 2019 19:08:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 05/17] net: sfp: rename T_PROBE_WAIT to T_SERIAL
Message-ID: <20191110180834.GQ25889@lunn.ch>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
 <E1iTnrN-0005A5-U9@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iTnrN-0005A5-U9@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 02:06:33PM +0000, Russell King wrote:
> SFF-8472 rev 12.2 defines the time for the serial bus to become ready
> using t_serial.  Use this as our identifier for this timeout to make
> it clear what we are referring to.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0B6E185809
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbgCOByE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:54:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36040 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727239AbgCOByE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Mar 2020 21:54:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dm9TXpV999UCK6JwKwJthV7fTE5ChnuktmiJLUPOVXo=; b=yc196s/+1jwclfqTk4oW9ch15S
        EAlX+OOpo8ANp8F2kOG++gAh6/zA44yGfov1fl5PG0BHlgaiC6OaSwu0b6hI2zITPN1KPlvBSSF9d
        Q+dKYygyWiteCrhTX/1ChfXgjyfyEKCTOW3zkT1w4zCxu8JfBqszVZ55HLvegbWtnlGU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jDBq4-0001g5-TW; Sat, 14 Mar 2020 19:48:48 +0100
Date:   Sat, 14 Mar 2020 19:48:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 5/8] net: dsa: mv88e6xxx: fix Serdes link changes
Message-ID: <20200314184848.GI5388@lunn.ch>
References: <20200314101431.GF25745@shell.armlinux.org.uk>
 <E1jD3pc-0006Dj-Ld@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jD3pc-0006Dj-Ld@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 14, 2020 at 10:15:48AM +0000, Russell King wrote:
> phylink_mac_change() is supposed to be called with a 'false' argument
> if the link has gone down since it was last reported up; this is to
> ensure that link events along with renegotiation events are always
> correctly reported to userspace.
> 
> Read the BMSR once when we have an interrupt, and report the link
> latched status to phylink via phylink_mac_change().  phylink will deal
> automatically with re-reading the link state once it has processed the
> link-down event.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

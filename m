Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56A9215FFF2
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 20:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgBOTGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 14:06:33 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47970 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbgBOTGd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 14:06:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TWrGIgEuiPAPLh8KBWCw5tbVfcPLfvvlak5jA0k4A8M=; b=m4wseie/o/SpmAj857Tk7cGDHz
        boey73dbxT875HgPhxdhPCop1uveJ1XX1eCz/jmJKzyhacUjA9tKJbfLH4Ul0IU8sxDYJFEDNxm0U
        a3tMRC0wnNk7NhaGAzApFxAVH1u9ADTbbNIqJ1jla5FCVbDkd4uw78c5MlZD1Y9szCQM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j32lq-0005DO-8n; Sat, 15 Feb 2020 20:06:30 +0100
Date:   Sat, 15 Feb 2020 20:06:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 09/10] net: phylink: improve initial mac
 configuration
Message-ID: <20200215190630.GY31084@lunn.ch>
References: <20200215154839.GR25745@shell.armlinux.org.uk>
 <E1j2zhj-0003YU-TF@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j2zhj-0003YU-TF@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 15, 2020 at 03:50:03PM +0000, Russell King wrote:
> Improve the initial MAC configuration so we get a configuration which
> more represents the final operating mode, in particular with respect
> to the flow control settings.
> 
> We do this by:
> 1) more fully initialising our phy state, so we can use this as the
>    initial state for PHY based connections.
> 2) reading the fixed link state.
> 3) ensuring that in-band mode has sane pause settings for SGMII vs
>    802.3z negotiation modes.
> 
> In all three cases, we ensure that state->link is false, just in case
> any MAC drivers have other ideas by mis-using this member, and we also
> take account of manual pause mode configuration at this point.
> 
> This avoids MLO_PAUSE_AN being seen in mac_config() when operating in
> PHY, fixed mode or inband SGMII mode, thereby giving cleaner semantics
> to the pause flags.  As a result of this, the pause flags now indicate
> in a mode-independent way what is required from a mac_config()
> implementation.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

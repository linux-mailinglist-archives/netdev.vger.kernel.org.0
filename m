Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB1215FFF0
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 20:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgBOTCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 14:02:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47950 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbgBOTCg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 14:02:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OUENO4cmvdMu8DrPK5C4jg85L+rfXcztWe7XBdTGGl0=; b=1xlmcNNknHXJWz1tMSiYdbxQkB
        bG0QGqnPfl0snlxeIs20AWCLW0L9P+0Y+PShaAL2UOr6Mi+GllJvw/CklNTkzbSiShbGAhYvTpQDT
        HfJnXPvXmJHpaS2gsjPPSiTXC8ZGKETTuH2I0yMXEFuCmRjENQt+QxjPZN6YqPUJW3Fs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j32i0-0005CC-Eq; Sat, 15 Feb 2020 20:02:32 +0100
Date:   Sat, 15 Feb 2020 20:02:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 07/10] net: phylink: resolve fixed link flow
 control
Message-ID: <20200215190232.GW31084@lunn.ch>
References: <20200215154839.GR25745@shell.armlinux.org.uk>
 <E1j2zhZ-0003Y5-K7@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j2zhZ-0003Y5-K7@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 15, 2020 at 03:49:53PM +0000, Russell King wrote:
> Resolve the fixed link flow control using the recently introduced
> linkmode_resolve_pause() helper, which we use in
> phylink_get_fixed_state() only when operating in full duplex mode.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

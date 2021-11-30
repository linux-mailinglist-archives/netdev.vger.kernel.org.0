Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27C1463A92
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242171AbhK3Pxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:53:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59650 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230418AbhK3Pw2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 10:52:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=raquvrxlJWH5aEPOH47gleUfugDkT+B0zOk0j1clNJw=; b=Jt2pskyUzLM93gYMPluXjNXZ+R
        DUZZSTcka100Puc0m6zOEMetpq+6s9fz5W765V6XKMPMiaYOOfJxwix8Y/lZbSIaYPBAXss3ToCYG
        jPCnCEbhy7iSnlEu5By1q/FGhDReluV4EzV5++/tqnXGbs6LrF2e81eJEGee4Tf1oeKU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ms5N4-00F7Ho-UZ; Tue, 30 Nov 2021 16:48:42 +0100
Date:   Tue, 30 Nov 2021 16:48:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 2/5] net: dsa: replace phylink_get_interfaces()
 with phylink_get_caps()
Message-ID: <YaZH2lnTx3f4Tkie@lunn.ch>
References: <YaYiiU9nvmVugqnJ@shell.armlinux.org.uk>
 <E1ms2tV-00ECJA-2v@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ms2tV-00ECJA-2v@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 01:10:01PM +0000, Russell King (Oracle) wrote:
> Phylink needs slightly more information than phylink_get_interfaces()
> allows us to get from the DSA drivers - we need the MAC capabilities.
> Replace the phylink_get_interfaces() method with phylink_get_caps() to
> allow DSA drivers to fill in the phylink_config MAC capabilities field
> as well.

It would of been nice to say that phylink_get_interfaces() is
currently unused, and so this change does not break anything. I think
that was a discussion with the RFC?

But the code itself looks good.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

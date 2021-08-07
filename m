Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED6293E3633
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 17:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbhHGPuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 11:50:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38282 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229828AbhHGPtv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 11:49:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hMRkLC9sX1iRCwMgCksqyJpH2Qs6Prl5IMtksM3Msb0=; b=a+Kv9/L2NlWb5RJtcVgT0AdPYB
        esCRXzwCdwjzZzonljtfHsyoWjPcKPZJC7jzTG1rSqUuPCpHoBjBZmz4AUU2ewPQbCYqLoAbut1E7
        FnoEUcjLYQS5f5kAk4b6r2XCngmb1ayYX9e3xm2JrTAvzcGneoXOT9DZGCaHhXpvJ6z0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mCOZg-00GVS5-Op; Sat, 07 Aug 2021 17:49:24 +0200
Date:   Sat, 7 Aug 2021 17:49:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>, kernel-team@android.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 3/3] net: mdio-mux: Handle -EPROBE_DEFER correctly
Message-ID: <YQ6rhOq7/eBqxBYB@lunn.ch>
References: <20210804214333.927985-1-saravanak@google.com>
 <20210804214333.927985-4-saravanak@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804214333.927985-4-saravanak@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 02:43:32PM -0700, Saravana Kannan wrote:
> When registering mdiobus children, if we get an -EPROBE_DEFER, we shouldn't
> ignore it and continue registering the rest of the mdiobus children. This
> would permanently prevent the deferring child mdiobus from working instead
> of reattempting it in the future. So, if a child mdiobus needs to be
> reattempted in the future, defer the entire mdio-mux initialization.
> 
> This fixes the issue where PHYs sitting under the mdio-mux aren't
> initialized correctly if the PHY's interrupt controller is not yet ready
> when the mdio-mux is being probed. Additional context in the link below.
> 
> Link: https://lore.kernel.org/lkml/CAGETcx95kHrv8wA-O+-JtfH7H9biJEGJtijuPVN0V5dUKUAB3A@mail.gmail.com/#t
> Signed-off-by: Saravana Kannan <saravanak@google.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F48F35CF9
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 14:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfFEMhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 08:37:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58246 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727663AbfFEMhH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 08:37:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7/7P3JCHAuuiB2vCg35zQk4+bCLJOJBCLvZkIg/WITQ=; b=UGLK1R+yPSQx2k8uPrcuVg09jQ
        EH7OTbU9JhzaFJe1+2s/gLUZZUusDcN22yOoiSxNAfC3tQ+3sCnpf2KrLpXSiU5tCXq0eLGknLXx/
        KtIio9bonk1p9ZnmyKMl9yw0FhTNcaXdyWvtN6Hr4ihV7qDkDgY4n4dj9nvaN+9V9nvM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYVA6-0004PN-CN; Wed, 05 Jun 2019 14:37:02 +0200
Date:   Wed, 5 Jun 2019 14:37:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell10g: allow PHY to probe without firmware
Message-ID: <20190605123702.GI16951@lunn.ch>
References: <E1hYTO0-0000MZ-2d@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1hYTO0-0000MZ-2d@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 11:43:16AM +0100, Russell King wrote:
> Allow the PHY to probe when there is no firmware, but do not allow the
> link to come up by forcing the PHY state to PHY_HALTED in a similar way
> to phy_error().
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

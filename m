Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 363651230BC
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 16:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbfLQPpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 10:45:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57702 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727161AbfLQPpr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 10:45:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9K2oWfE66g3Y+fnei3z9HbS1Ga9E2IPeH2cr/phwm10=; b=HW9oN1e/ctjkVRY0750mAEdaVR
        5S1orA60OE2I/cooVPTD4II7pL+VS6Lm7BoOpik7LsTZCLPNIMLOri2h53ierd7xDaGFUZ4wfuJtT
        7YDYNXYmDptsXtbat5UKej/r+DotKUDmi32DeAExt60XKwGpuI7AxINE83Fe+r+nqSu4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ihF2d-0002kc-Fc; Tue, 17 Dec 2019 16:45:43 +0100
Date:   Tue, 17 Dec 2019 16:45:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 06/11] net: phy: marvell: initialise link
 partner state earlier
Message-ID: <20191217154543.GN17965@lunn.ch>
References: <20191217133827.GQ25745@shell.armlinux.org.uk>
 <E1ihD4Q-0001yt-JM@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ihD4Q-0001yt-JM@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 01:39:26PM +0000, Russell King wrote:
> Move the initialisation of the link partner state earlier, inside
> marvell_read_status_page(), so we don't have the same initialisation
> scattered amongst the other files.  This is in a similar place to
> the genphy implementation, so would result in the same behaviour if
> a PHY read error occurs.
> 
> This allows us to get rid of marvell_read_status_page_fixed(), which
> became a pointless wrapper around genphy_read_status_fixed().
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

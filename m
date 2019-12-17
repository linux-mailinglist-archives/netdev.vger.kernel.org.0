Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB521230CE
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 16:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbfLQPsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 10:48:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57738 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726858AbfLQPsZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 10:48:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LBbePmhZ6013bzG1SBOdgu9G5/uazjnz3K9pJWXDwVE=; b=orQWTzHFzLAqCxWHSNuQBnCrJO
        lfojmCh+6y0h9k4t/zzTRIezbxStpDHg+gQJ9gcm72XA/Uw1bd9h5vhIKm618Y5dsUgyZXgZntc+n
        9SRYFAIf8+QXGrbMUh9gqrJTatpQAFV6mlxCTVoYisJTDYL4Q42v1HsqEUp7bbSaLXvo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ihF5C-0002oK-OO; Tue, 17 Dec 2019 16:48:22 +0100
Date:   Tue, 17 Dec 2019 16:48:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 10/11] net: phy: marvell: use
 phy_modify_changed()
Message-ID: <20191217154822.GQ17965@lunn.ch>
References: <20191217133827.GQ25745@shell.armlinux.org.uk>
 <E1ihD4l-0001zP-48@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ihD4l-0001zP-48@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 01:39:47PM +0000, Russell King wrote:
> Use phy_modify_changed() to change the fiber advertisement register
> rather than open coding this functionality.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

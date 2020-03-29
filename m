Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27DFB196EA4
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 19:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgC2RX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 13:23:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37590 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727942AbgC2RX2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Mar 2020 13:23:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yLzrpRe1C8JqGvTplpGL0c/O8763k57nRUjRehaw4T8=; b=uFsSRKkO8spLGVmKHQDSp+ZJUn
        Y+kix6VIyPrAQIL+A/xz5kHFmJqw3/IukQnHTX1qKsL+ojPkt56Wa6TZ+F3ngXLBYELhn+oIDKd5v
        nU0jVlwlgTFrz2h85cYH5mHTT0KCxtaHLROmeDo3iJHm0NFxA0UfzSnArJu0NSNG+9Jw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jIbef-00059y-32; Sun, 29 Mar 2020 19:23:25 +0200
Date:   Sun, 29 Mar 2020 19:23:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/3] net: phylink: add separate pcs
 operations structure
Message-ID: <20200329172325.GD31812@lunn.ch>
References: <20200329160036.GB25745@shell.armlinux.org.uk>
 <E1jIaNC-0007lp-7j@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jIaNC-0007lp-7j@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 29, 2020 at 05:01:18PM +0100, Russell King wrote:
> Add a separate set of PCS operations, which MAC drivers can use to
> couple phylink with their associated MAC PCS layer.  The PCS
> operations include:
> 
> - pcs_get_state() - reads the link up/down, resolved speed, duplex
>    and pause from the PCS.
> - pcs_config() - configures the PCS for the specified mode, PHY
>    interface type, and setting the advertisement.
> - pcs_an_restart() - restarts 802.3 in-band negotiation with the
>    link partner
> - pcs_link_up() - informs the PCS that link has come up, and the
>    parameters of the link. Link parameters are used to program the
>    PCS for fixed speed and non-inband modes.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

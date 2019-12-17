Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB7E41230B9
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 16:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbfLQPon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 10:44:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57688 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727161AbfLQPon (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 10:44:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yw0q3VwSD7+GL71pRZVnHWM/zg385zQBuvGO3gSNCLw=; b=oBfqnCOZc3zQdsrl/W59x85E/L
        UHJZGHHyNivJ2mu4cixVbHY6q7UGqA4txMTEBhngnm2kyup7wPhMA6ot3GSycFsKnyC5b49FolDXC
        C4PH2vNDKwIyAcV54Hs9/3yJbVn31zjKb9g8s+wvzpLK2hLjWYAMVo2TSi8Zi27wjces=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ihF1b-0002io-RF; Tue, 17 Dec 2019 16:44:39 +0100
Date:   Tue, 17 Dec 2019 16:44:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 05/11] net: phy: marvell: rearrange to use
 genphy_read_lpa()
Message-ID: <20191217154439.GM17965@lunn.ch>
References: <20191217133827.GQ25745@shell.armlinux.org.uk>
 <E1ihD4L-0001ym-FK@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ihD4L-0001ym-FK@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 01:39:21PM +0000, Russell King wrote:
> Rearrange the Marvell PHY driver to use genphy_read_lpa() rather than
> open-coding this functionality.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

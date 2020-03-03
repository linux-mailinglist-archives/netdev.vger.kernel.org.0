Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF5E6177C69
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 17:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730416AbgCCQv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 11:51:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43996 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729156AbgCCQv2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 11:51:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=a+WqVD8htBja0GMRD9VJ/yWmaKoG57DfLlJs5pgcp3w=; b=tEUdNw26UD9VWnWknQOmnEI9Z7
        K2Y4iVi7FPk6ID2QKOb8KIFK2kfyzkzgazGnzqY7HpqKAL3CDbedQ3dj2Z9wYjVuezMs/gB0yuS1T
        Qv+q1ZLBK9gG65d/o79VwHS+NujXzMwiMueD3WzlLrKPXVEVUXgFmx6zIeInKZO0Xxo8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j9AlM-0007lO-9s; Tue, 03 Mar 2020 17:51:20 +0100
Date:   Tue, 3 Mar 2020 17:51:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: dsa: fix phylink_start()/phylink_stop() calls
Message-ID: <20200303165120.GI24912@lunn.ch>
References: <E1j993K-0005kp-87@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j993K-0005kp-87@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 03:01:46PM +0000, Russell King wrote:
> Place phylink_start()/phylink_stop() inside dsa_port_enable() and
> dsa_port_disable(), which ensures that we call phylink_stop() before
> tearing down phylink - which is a documented requirement.  Failure
> to do so can cause use-after-free bugs.
> 
> Fixes: 0e27921816ad ("net: dsa: Use PHYLINK for the CPU/DSA ports")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

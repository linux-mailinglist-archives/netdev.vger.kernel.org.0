Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6315D188A04
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 17:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgCQQSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 12:18:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41188 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbgCQQSF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 12:18:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=I91YOuyITKLz5g3zoR2SizMBv7v6YJcL8Q1pPfHTrAE=; b=G9rhkilB7Q7tIL4KCl4gvDqTBO
        xkoNX2Nei51tHNBwOuamYWK46e2h/41G2nWg9qnNLTqk//tWI5VrHvTL4F7SWxKnmn+csqtm26f/q
        kB15ykDtBUC2T83hb5JRQvnxzxxCu3k0N5hpO4enzPxZSkR2DFYEFIbfgT8GVZauZh88=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jEEun-0007bL-IQ; Tue, 17 Mar 2020 17:18:01 +0100
Date:   Tue, 17 Mar 2020 17:18:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/4] net: mdiobus: add APIs for modifying a
 MDIO device register
Message-ID: <20200317161801.GX24270@lunn.ch>
References: <20200317144906.GO25745@shell.armlinux.org.uk>
 <E1jEDa3-0008Io-6h@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jEDa3-0008Io-6h@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 02:52:31PM +0000, Russell King wrote:
> Add APIs for modifying a MDIO device register, similar to the existing
> phy_modify() group of functions, but at mdiobus level instead.  Adapt
> __phy_modify_changed() to use the new mdiobus level helper.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

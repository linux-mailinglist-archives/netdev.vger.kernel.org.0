Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D433D0060
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 19:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhGTQ4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 12:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbhGTQ4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 12:56:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674B9C061574
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 10:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6VrSyfc/kzenZzt/pZGMg0ZJJpLG3nvAIKa9l5luxTs=; b=Gg8i7G8gvve1BXewuvHzVMUrt
        g1WiI6ar7l+8xFEZ11cvumWf/jZa1Sax8DaFAIzdV4c8CM3j/dFjxiRHD0ppnROJ98ZIAezsDO46m
        HeKLmT6/9cv4AHJq9GeqMKz1hyy5YCcH0iwOd3masSN6CfPJJUgYDnys8DHf4geZK4D4gkAapR9BI
        ev/LesKXc7EcXvf42LUrQMGcJmCwELrq/rcrOliFZxJEzUB0r6FTHzYgOUSkuIFYYgzad/T0CyVYU
        mb95ApsMv5mrb3CBf7ROWoFxD4SpbEbxDmP/FeSs5CRFA2eSR2EZYJqz7ITuL3KwsotYssq4nC2Ig
        Uw3TXDgRQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46378)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1m5tfl-0006hd-Es; Tue, 20 Jul 2021 18:36:49 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1m5tfk-00075T-JT; Tue, 20 Jul 2021 18:36:48 +0100
Date:   Tue, 20 Jul 2021 18:36:48 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH net-next] net: phy: at803x: finish the phy id checking
 simplification
Message-ID: <20210720173648.GW22278@shell.armlinux.org.uk>
References: <20210720172433.995912-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720172433.995912-1-vladimir.oltean@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 08:24:33PM +0300, Vladimir Oltean wrote:
> The blamed commit was probably not tested on net-next, since it did not
> refactor the extra phy id check introduced in commit b856150c8098 ("net:
> phy: at803x: mask 1000 Base-X link mode").
> 
> Fixes: 8887ca5474bd ("net: phy: at803x: simplify custom phy id matching")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Thanks for catching this and sorry for the breakage - the humidity in
the UK is getting to me (particularly causing tiredness), so I've
obviously missed stuff. :(

Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

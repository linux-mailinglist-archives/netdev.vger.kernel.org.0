Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E7A437AAF
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 18:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbhJVQQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 12:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbhJVQQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 12:16:32 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C01BC061764;
        Fri, 22 Oct 2021 09:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3jfvma+SoFb/JGqbF3ogD4CFnp4C2wV64tpDuV2Jgnk=; b=JIe7azIZ5FUVA0hUKdYGDGzi0f
        S3tbfFyGh2bzM4xiFTMn4H0VH3lqlv4XA+cXECFG+rqNcnsmhanxswg/30BSFP3yNvXRMZho2CDtY
        CFGik5rxjFHgX4wc/u8Xs1HoS73+5VxgyT0fkQeOarPJ6LC9NLkk2Fvdt/42pfAlOJJxEKxBEVJ+B
        wa9xS+cbXp12XrGUH+2GOU6yyp9ITPlnpD+WzfBMaNfbEAtYi1MCEBt92nUoNxLY4VsScldsla+MZ
        eFlDh8VzcoIWoCZl/TDCyCm9LpIwbbzu9fzgzEdzDJbh7fQRHFUxVrPpnUsmItS9g1NpmGZl8571D
        vQI06hxA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55238)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mdxBL-0001vC-Bk; Fri, 22 Oct 2021 17:14:11 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mdxBJ-0001Ip-IQ; Fri, 22 Oct 2021 17:14:09 +0100
Date:   Fri, 22 Oct 2021 17:14:09 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [net-next PATCH v2 1/3] net: mdio: Add helper functions for
 accessing MDIO devices
Message-ID: <YXLjUZBs5VgYSiIn@shell.armlinux.org.uk>
References: <20211022155914.3347672-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022155914.3347672-1-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 11:59:12AM -0400, Sean Anderson wrote:
> This adds some helpers for accessing non-phy MDIO devices. They are
> analogous to phy_(read|write|modify), except that they take an mdio_device
> and not a phy_device.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF47438300
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 11:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhJWKAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 06:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbhJWKAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 06:00:14 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B6BC061234;
        Sat, 23 Oct 2021 02:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dHMTt1k0Cd68+zir1t9TVpYzECWPKdraKiS6FAr1kE0=; b=jFpAGPV8mZxUi3fR8OaQ1yJzGy
        ozPKJMOd7T7FKHVXLaCnw1rohhVYgbeBn1i4Iy5vBmMqojerpnIxPElHR8Za/zMpZUBQwwsoXaoob
        adtJAyv9cK9WPNjRHnlvR8W42nGbEDkaRUUrikPMMoh1O1rByRrtgF2cMNkvAkNcOfVrLgucmi5SK
        ISljpc9GkDNT7La+h+yxSSXDYPxmRDLXz/I4sr9wzcFUCXb3GAfG6dJUjCiL3T0+6XNsTA4/4Uzej
        xXgvdF4WM3WOL1IwKhb3E+MQ9Gd0ARq9Y63qvxbHU6uVNSetWXSPGanG0yuq8YuFePA1efndAMMZ/
        xUNm+ObA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55252)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1meDm1-0002Yj-3D; Sat, 23 Oct 2021 10:57:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1meDlz-00020f-GC; Sat, 23 Oct 2021 10:57:07 +0100
Date:   Sat, 23 Oct 2021 10:57:07 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v6 01/14] net: phy: at803x: replace AT803X_DEVICE_ADDR
 with MDIO_MMD_PCS
Message-ID: <YXPcczBI2Keg8i8s@shell.armlinux.org.uk>
References: <20211023095453.22615-1-luoj@codeaurora.org>
 <20211023095453.22615-2-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211023095453.22615-2-luoj@codeaurora.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 23, 2021 at 05:54:40PM +0800, Luo Jie wrote:
> Replace AT803X_DEVICE_ADDR with MDIO_MMD_PCS defined in mdio.h.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

This is still wrong. Andrew reviewed it, and then I did. I gave you a
reviewed tag as well.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

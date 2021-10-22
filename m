Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B05A437724
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 14:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbhJVMfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 08:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbhJVMfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 08:35:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB6DC061764;
        Fri, 22 Oct 2021 05:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oMgAZY+F/sdM3t95WtfAYVamdvU9COWI2QoJJs9rXhA=; b=zePx9o6jBuEgS3fYc5fORTTX3e
        pO70ymBnVsxWbVxiMS62akdvmPl6e/oHAgP6XlRfDdEo7a4iKdN2gbl7QRLexHgbkxQs20YcnTh8e
        828dYftPHDEqMGlNiOYYsmi7lfL9isK5kFP9FPvvhTwGW3gNId/j16eAhfMIXd9Aiq/ITWlVhWugt
        yTSJ5ZhMRTyiGGDAVRGZ0dM79yoYkbf3GhP1byQql83unznGncq9Mm9DB/mSPk9Wic8RRKAmpg4sA
        WK4cyZ4llIvGogO2v2ST63VvEELF0p2GLWizH/LEBBySeAlgklFCmI3jprRn9Tansc9UzaLYKqcKZ
        9ZY82Z+g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55236)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mdtjp-0001ht-2N; Fri, 22 Oct 2021 13:33:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mdtjn-0001B8-Oj; Fri, 22 Oct 2021 13:33:31 +0100
Date:   Fri, 22 Oct 2021 13:33:31 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC net-next PATCH 07/16] net: phylink: Add helpers for c22
 registers without MDIO
Message-ID: <YXKvmwwUNnIlROsv@shell.armlinux.org.uk>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-8-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004191527.1610759-8-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 03:15:18PM -0400, Sean Anderson wrote:
> Some devices expose memory-mapped c22-compliant PHYs. Because these
> devices do not have an MDIO bus, we cannot use the existing helpers.
> Refactor the existing helpers to allow supplying the values for c22
> registers directly, instead of using MDIO to access them. Only get_state
> and set_adversisement are converted, since they contain the most complex
> logic.

I think this patch is useful on its own, there are certainly cases
where being able to hold the MII bus lock while reading the BMSR/LPA
registers would be advantageous. Please can you update the patch
against net-next and submit it?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

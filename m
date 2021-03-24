Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5366A348014
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 19:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237176AbhCXSMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 14:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237181AbhCXSMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 14:12:03 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FE4C061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 11:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kWSihFYVv+l8h2tr2D0sXm3WUGx6b9JfvHdfWBqzaFA=; b=HQ4hCyUtcus8JMGMKfwRZqW6y
        LejBvkGASuXm/LddZy73QGj4OvWpcW6VZWP9hLa1afvIVc7g2oW4NcAZM9SUbRr3QHPU6u5C520kk
        SmKWHGhqivAcxIUmJyLlqhBmqffy8B8yuzReq5WYxk5USMcZjcMBiXob3YM7bHkqPqSP3A09vTV1/
        pQTeGtA/wL1sGLUxa3fb92FVEjpzDU4RIqK+0gnfIc3rPaFRkkoIzp2Ir07NQDhNwAOa02OZ+Diya
        CRqGunqqk/QMiRFLjQ8sQ6TAKx5GtFQPMysdWe9WNDwnvulU8iXWLiNzUG5dIN0JYwMxVpvkj8ixL
        r/qQ9qoWg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51676)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lP7z6-0000oF-Bp; Wed, 24 Mar 2021 18:12:00 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lP7z3-0005Fi-Rs; Wed, 24 Mar 2021 18:11:57 +0000
Date:   Wed, 24 Mar 2021 18:11:57 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org
Subject: Re: [PATCH net-next 4/7] net: phy: marvell10g: add MACTYPE
 definitions for 88X3310/88X3310P
Message-ID: <20210324181157.GH1463@shell.armlinux.org.uk>
References: <20210324165023.32352-1-kabel@kernel.org>
 <20210324165023.32352-5-kabel@kernel.org>
 <20210324165836.GF1463@shell.armlinux.org.uk>
 <20210324180909.13df1a48@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210324180909.13df1a48@thinkpad>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 06:09:09PM +0000, Marek Behún wrote:
> On Wed, 24 Mar 2021 16:58:36 +0000
> Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> 
> > On Wed, Mar 24, 2021 at 05:50:20PM +0100, Marek Behún wrote:
> > > Add all MACTYPE definitions for 88X3310/88X3310P.
> > > 
> > > In order to have consistent naming, rename
> > > MV_V2_PORT_CTRL_MACTYPE_RATE_MATCH to
> > > MV_V2_PORT_CTRL_MACTYPE_10GR_RATE_MATCH.  
> > 
> > We probably ought to note that the 88x3310 and 88x3340 will be detected
> > by this driver, but have different MACTYPE definitions.
> 
> Is 88X3340 supported? The drivers structure only defines for
>  .phy_id = MARVELL_PHY_ID_88X3310
> Do 88X3310 and 3340 have the same PHY_ID ?

Yes they do. I believe they can be distinguished by bit 3,
conventionally part of the PHY revision.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

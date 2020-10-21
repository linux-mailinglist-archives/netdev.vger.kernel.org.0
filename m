Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEC3294A82
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 11:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437019AbgJUJ1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 05:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395379AbgJUJ1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 05:27:41 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28901C0613CE
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 02:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Mc6hifh/KkZK7uwL96aGQdsHmfHXRnV++EChIv1dZG4=; b=eey3UumhtOq3hiMivvt3xLRA2
        +0ro+Yd6NA/UDCMq63EsaMaEKfjr33ceVgtBVGdDmHNa4kdYYO2jJjbf7x2jf8rfz5qeCoK6WQ64F
        5ZqONidE/eYQUXt5vC/MjgwdRXxuBtlcRBHrLc/8hcGLw0gzGc9Rr72g9H9YSxglIZVMYDzHgekra
        ZaqI7Mj65EqngrLsJN7MJjYLxcpn1dvtTkdxfk1R7kQKdx3+Ye9mLMAtLQXWiRuknXq8/N4CiI17z
        c5kThUUklJwYcJwpBoj3Cpb32EMWpvDqy0Ebxs4Uau6/cZ839wBKKHPNlX7aGGf9Ji//BH/Y/TnkS
        05L4kbV4Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:49036)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kVAPC-0000KB-0D; Wed, 21 Oct 2020 10:27:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kVAPA-0006GX-R1; Wed, 21 Oct 2020 10:27:36 +0100
Date:   Wed, 21 Oct 2020 10:27:36 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phylink: disable BMCR_ISOLATE in
 phylink_mii_c22_pcs_config
Message-ID: <20201021092736.GI1551@shell.armlinux.org.uk>
References: <20201020191249.756832-1-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020191249.756832-1-robert.hancock@calian.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 01:12:49PM -0600, Robert Hancock wrote:
> The Xilinx PCS/PMA PHY requires that BMCR_ISOLATE be disabled for proper
> operation in 1000BaseX mode. It should be safe to ensure this bit is
> disabled in phylink_mii_c22_pcs_config in all cases.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

Please re-send when netdev is open, thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

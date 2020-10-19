Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA11D293035
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 23:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732529AbgJSVJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 17:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732525AbgJSVJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 17:09:11 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F480C0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 14:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=o951XbbeK+CZtLDo7RUHGAfzJVkDE/DGsqqLGBqyB2o=; b=ULO7Vlr5HHT57oZA332Sk1JFQ
        cRVeX6bs5PolsDeD3K0+DP9TnRcJ67QOQtSo79yzyQnpmV0X/HJ1V3pb5aB0uPZxk5WPORbfESe27
        /M7VouTyvmwwwXDzFtMFwT6dh75/9guXS+WskJrSf2xEWyP/RxDTmErp1+k9ByP0FYQHi1XYLFsge
        Q/sMIRsIHH4g2Y0QEmH+I5RS/KdXJjbD16ZoUQ2KVEXhOhiXuqVzcUV8aMM4pa67LRVVLSGHWE/MR
        oJ6dR9bePJZMB5vmLFCqvSjPb0M5SZRlPtxPxrTEpEF6QzaEccVGJQ5qVIMWTJaNy9PrzIQoIZHWh
        CImTjTusg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48386)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kUcOz-0006NH-IP; Mon, 19 Oct 2020 22:09:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kUcOz-0004ZM-B4; Mon, 19 Oct 2020 22:09:09 +0100
Date:   Mon, 19 Oct 2020 22:09:09 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Robert Hancock <robert.hancock@calian.com>, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: add special handling of Finisar
 modules with 81E1111
Message-ID: <20201019210909.GX1551@shell.armlinux.org.uk>
References: <20201019204913.467287-1-robert.hancock@calian.com>
 <20201019210654.GV139700@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019210654.GV139700@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 11:06:54PM +0200, Andrew Lunn wrote:
> On Mon, Oct 19, 2020 at 02:49:13PM -0600, Robert Hancock wrote:
> > The Finisar FCLF8520P2BTL 1000BaseT SFP module uses a Marvel 81E1111 PHY
> > with a modified PHY ID, and by default does not have 1000BaseX
> > auto-negotiation enabled, which is not generally desirable with Linux
> > networking drivers.
> 
> I could be wrong, but i thought phylink used SGMII with copper SFPs,
> so that 10/100 works as well as 1G. So why is 1000BaseX an issue?
> Do you have a MAC which cannot do SGMII, only 1000BaseX?

Indeed it does.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

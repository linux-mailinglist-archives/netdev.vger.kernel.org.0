Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2101E1580
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 23:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729911AbgEYVIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 17:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729550AbgEYVII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 17:08:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C06C061A0E;
        Mon, 25 May 2020 14:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CM3xbvfT6889wPKnUUjils4zHkgMqAlAinbEADPEzjg=; b=d4fo5X/icyYj5Xn8uC1O6UBcs
        /c2uultrJSj6riGRJtx5DqN7YU3CLvhEDk+7l6i2sBln/Uqj9h8nV0uMToJK6fC/wKkPzf3bE1Y9n
        vC5FWqWJZ5CLELKEg2d3qd7dQRhxYlY6MK1YpXNkz3VTH6dst/yMtQk1POklsUVRTs/un0hYAv1yf
        W18mphu+Hgm9ivVgCqHVC5gpasHesJoqR77lR4PZ1+04lw+phtuAuf9uCVKRka1bm1tUE6LiTtw1F
        t2No96ghT8LJ2dryRg/SITKaACHnkvS5rjg+oI02tHy0SqM2PdIkOcjgrBae07BgXDztD+Lo3v0i4
        bMeYXTsxg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:44992)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jdKKD-00062L-7c; Mon, 25 May 2020 22:07:57 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jdKK7-0004fb-G0; Mon, 25 May 2020 22:07:51 +0100
Date:   Mon, 25 May 2020 22:07:51 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 01/11] net: phy: Don't report success if devices weren't
 found
Message-ID: <20200525210751.GN1551@shell.armlinux.org.uk>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-2-jeremy.linton@arm.com>
 <20200523182054.GW1551@shell.armlinux.org.uk>
 <e6e08ca4-5a6d-5ea3-0f97-946f1d403568@arm.com>
 <20200525094536.GK1551@shell.armlinux.org.uk>
 <be729566-5c63-a711-9a99-acc53d871b88@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be729566-5c63-a711-9a99-acc53d871b88@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 04:02:13PM -0500, Jeremy Linton wrote:
> > So, I think you're going to have to add a work-around to ignore bit 0,
> > which brings up the question whether this is worth it or not.
> 
> It does ignore bit 0, it gets turned into the C22 regs flag, and
> cleared/ignored in the remainder of the code (do to MMD loop indexes
> starting at 1).

However, I've already pointed out that that isn't the case in a
number of functions that I listed in another email, and I suspect
was glossed over.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up

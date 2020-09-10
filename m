Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C41264D27
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 20:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgIJSfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 14:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgIJSe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 14:34:56 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A7CC061573;
        Thu, 10 Sep 2020 11:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XvvanWtbPeA4+U1mCCCR48ZeV6gTrzWi5uy9br9sD0s=; b=qjVVztNNQjmwqqWtlblKT4jAX
        DA3Eqkgq8nyvYV+HQJTYZPBDdc6MlSJC+aHzJaa4/SePOHMWEh1xKNhlTsw0VHGwjxUuyJsdd7eEj
        C/uIDyKlOeUoWDzrXvssPlYwHK9vTLyag7q6gFXeF0bcaYteafyMgiV2BYiP1RR9Nwj7V64p//rJv
        FwtGhy0X5T+4XHC8uY95eV7hyJZyvtcEp6WhkxfHwE98aA3TPKac+9pJDhpmtvBQHRS26iOLw6m19
        UoqSnKZuzv/aaTvymhZWHqW8jKFmEdvh59SxiK1cZEK6p0DfmxTxpG+KC1jAxS4+jSOQAXwkbX+XR
        vOOwhvnog==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32988)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kGRP5-0006UZ-CL; Thu, 10 Sep 2020 19:34:39 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kGRP1-0007UP-CC; Thu, 10 Sep 2020 19:34:35 +0100
Date:   Thu, 10 Sep 2020 19:34:35 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Pavel Machek <pavel@ucw.cz>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>,
        netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 6/7] net: phy: marvell: add support
 for LEDs controlled by Marvell PHYs
Message-ID: <20200910183435.GC1551@shell.armlinux.org.uk>
References: <20200909162552.11032-1-marek.behun@nic.cz>
 <20200909162552.11032-7-marek.behun@nic.cz>
 <20200910122341.GC7907@duo.ucw.cz>
 <20200910131541.GD3316362@lunn.ch>
 <20200910182434.GA22845@duo.ucw.cz>
 <20200910183154.GF3354160@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910183154.GF3354160@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 08:31:54PM +0200, Andrew Lunn wrote:
> Generally the driver will default to the hardware reset blink
> pattern. There are a few PHY drivers which change this at probe, but
> not many. The silicon defaults are pretty good.

The "right" blink pattern can be a matter of how the hardware is
wired.  For example, if you have bi-colour LEDs and the PHY supports
special bi-colour mixing modes.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

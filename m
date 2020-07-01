Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D046A21156D
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 23:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgGAVxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 17:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgGAVxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 17:53:24 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2C0C08C5C1;
        Wed,  1 Jul 2020 14:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4xdSJvOpj+m9N4VI7fP0tRBiX3dSbcOtJ+KGlcOJQyk=; b=zCYImgRBAzb98o22jOqv6TD+u
        5snStPT5vlQpwEt3HJXuoid09Pt96m7+WQ1ttTa9mt8x4PUDZ2sPHuML0aD1vPNuKcXagB9nGk+Yg
        RoF3Pirg1q1oIg3OtqwxurrDGbjHGYuN1MeG5XTftdTZAace173EEXuiXXvx9v/B777EIM3rhqBqW
        lwH/Os/o+SQD4zj8gG+J8dUri+eMK2ZgP1WRoMvWUNBuDtp8wCVS+uj+WfEcmuD1q7QPib5JVyeGS
        O3eDZGKemUPjZwd/qc/ElvtUsgVvt3KsTSBUdyQ0FuaFrKVrEsPOkccnRzxLqkkszZ+WENzpH4uhn
        2TyKHwnjQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34124)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jqkfJ-0002BG-72; Wed, 01 Jul 2020 22:53:13 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jqkfG-00017G-AW; Wed, 01 Jul 2020 22:53:10 +0100
Date:   Wed, 1 Jul 2020 22:53:10 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: Re: [PATCH RESEND net-next v3 0/3] net: enetc: remove bootloader
 dependency
Message-ID: <20200701215310.GL1551@shell.armlinux.org.uk>
References: <20200701213433.9217-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701213433.9217-1-michael@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 01, 2020 at 11:34:30PM +0200, Michael Walle wrote:
> This is a resend of the series because the conversion to the phylink
> interface will likely take longer:
> https://lore.kernel.org/netdev/CA+h21hpBodyY8CtNH2ktRdc2FqPi=Fjp94=VVZvzSVbnvnfKVg@mail.gmail.com/

I don't think it will; I've given people notice of potential changes
back in February, and as Florian has pointed out, that's ample enough
time that it's now no problem if I push my series and it causes
breakage to drivers that haven't updated.  I've also gone way beyond
what would normally be done, fixing up almost every driver the best
I can with the exception of two - felix DSA and Mediatek.

Some of the patches have been reviewed already, Ioana at NXP is happy
with them.  There's a bit of tweaking of a couple of patches and
adding some documentation, and then they're good to go.

I'm not going to wait for Felix or Mediatek.  As I say, I've given
plenty of warning, and it's only a _suspicion_ of breakage on my
side.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

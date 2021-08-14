Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC96B3EC4CE
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 21:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbhHNTuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 15:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhHNTtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 15:49:55 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0871EC061764;
        Sat, 14 Aug 2021 12:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IcLAKSwUaSyWeX8CewShNI1+JQS2DeeaQy6TF7SHBIw=; b=enl4Ym/NxcY+je6Fqd7UkvoKr
        XBdVoUXrjWEr4rj8aE/9wVgY3aJY4BF7S96smg1b7v585l5gUH4GclOXICEOQK9eF05DYQTstOaay
        jyEROVuTOsiBVaonHXSI9tvd8hLohARihcUdkaKVSOKgyeNppXtT7Y2VDbMbTdbx5vXGYlKNJDyqC
        p2i6UN8U7VK6r3sFj+W2Qk2heY6fh9SZlWA08BIg/FmW3aLezwJqCajz072hfJZX8Hb2umsT8lWRq
        mqnChVltjyik1xxW5i0zleTUv2AFatY8QxDXBMdyOZw0+MqqR1yUlNWvaOBX/uOn5nUFy8wuS4Z7e
        eNGTFW7og==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47298)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mEzeh-0005Zg-Kp; Sat, 14 Aug 2021 20:49:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mEzef-0006Jz-7Y; Sat, 14 Aug 2021 20:49:17 +0100
Date:   Sat, 14 Aug 2021 20:49:17 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Song Yoong Siang <yoong.siang.song@intel.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] net: phy: marvell10g: Add WAKE_PHY support
 to WOL event
Message-ID: <20210814194916.GB22278@shell.armlinux.org.uk>
References: <20210813084536.182381-1-yoong.siang.song@intel.com>
 <20210814172656.GA22278@shell.armlinux.org.uk>
 <YRgFxzIB3v8wS4tF@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRgFxzIB3v8wS4tF@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 14, 2021 at 08:04:55PM +0200, Andrew Lunn wrote:
> Agreed. If the interrupt register is being used, i think we need this
> patchset to add proper interrupt support. Can you recommend a board
> they can buy off the shelf with the interrupt wired up? Or maybe Intel
> can find a hardware engineer to add a patch wire to link the interrupt
> output to a SoC pin that can do interrupts.

The only board I'm aware of with the 88x3310 interrupt wired is the
Macchiatobin double-shot. :)

I forget why I didn't implement interrupt support though - I probably
need to revisit that. Sure enough, looking at the code I was tinkering
with, adding interrupt support would certainly conflict with this
patch.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

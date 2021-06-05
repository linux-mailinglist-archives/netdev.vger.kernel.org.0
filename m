Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D368839C92F
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 16:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhFEOpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 10:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbhFEOpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 10:45:16 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D68FC061766;
        Sat,  5 Jun 2021 07:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8qQ9hzjcEJ80hbpWFC2SC7brUy2Qgi3649QBkks8BM4=; b=su0ySHjb3zrgzbUhhNycDz7m6
        58slOzwjBXxa38qG5lkXRv5SUpBcc8kxfVrHkgtom5X1t8vxk9d2bZxJTA4KRnwkwyBvEvike0GIZ
        fFCJ25AMPSw6d3hVZ25L8fLg/jfWBY+ay1s1E2cYsJHEuGEVY6q7x+kqnt7VjjZd4yUOxyzzD0Xgs
        FrDwnGA4ZF0kmKZHqxkz3SXlH9iE9zfMPbshNfwUpOk7N0sX4BNskofamX0at63vAFLTioA47Iyrc
        soMuy3m0+ayYwde/VbJezOzONuxPxrN0Qv9DXZFJz8IgQbSGOWQaM7AxC+AMPMyJOsyXQqUOUoxgW
        IEfcNrZdA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44738)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lpXU4-0006l9-4M; Sat, 05 Jun 2021 15:41:08 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lpXU1-00046j-Qa; Sat, 05 Jun 2021 15:41:05 +0100
Date:   Sat, 5 Jun 2021 15:41:05 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Igal Liberman <Igal.Liberman@freescale.com>,
        Shruti Kanetkar <Shruti@freescale.com>,
        Emil Medve <Emilian.Medve@freescale.com>,
        Scott Wood <oss@buserror.net>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Camelia Alexandra Groza (OSS)" <camelia.groza@oss.nxp.com>
Subject: Re: What is inside GPON SFP module? (Was: Re: Unsupported
 phy-connection-type sgmii-2500 in arch/powerpc/boot/dts/fsl/t1023rdb.dts)
Message-ID: <20210605144105.GZ30436@shell.armlinux.org.uk>
References: <AM6PR04MB3976B62084EC462BA02F0C4CEC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604192732.GW30436@shell.armlinux.org.uk>
 <AM6PR04MB39768A569CE3CC4EC61A8769EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <YLqLzOltcb6jan+B@lunn.ch>
 <AM6PR04MB39760B986E86BA9169DEECC5EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604233455.fwcu2chlsed2gwmu@pali>
 <20210605003306.GY30436@shell.armlinux.org.uk>
 <20210605122639.4lpox5bfppoyynl3@skbuf>
 <20210605125004.v6njqob6prb7k75k@pali>
 <80966478-8a7c-b66f-50b7-e50fc00b1784@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80966478-8a7c-b66f-50b7-e50fc00b1784@hauke-m.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 05, 2021 at 03:04:55PM +0200, Hauke Mehrtens wrote:
> Is there a list of things these GPON sticks running Linux should do better
> in the future? For example what to avoid in the EEPROM emulation handling?

That is just not worth persuing. Large ISP-companies who have plenty of
buying power have tried to get issues with GPON sticks resolved, and the
response from the GPON stick manufacturers has not been helpful. I had
contracted with a national telco over this problem in recent years, and
I know they tried their best.

If large ISP companies who are significant customers can't effect any
fixes, you can be absolutely sure that the voluntary effort around the
Linux kernel will have no effect.

Yes, we list the modules that don't work well in the kernel source, and
sometimes we name and shame them, but they don't care.

For example, there is are a few modules that take up to 60 seconds
before they respond to any I2C requests, because the I2C is entirely
emulated by the Linux kernel running on the stick, and it takes that
long for the stick to boot. Will that ever get fixed? Probably not
without a hardware redesign. Will that happen? I really doubt it, and
eevn if it did it doesn't affect the millions of sticks already out
there.

IMHO trying to get these issues fixed is pie in the sky.


-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

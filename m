Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7404A39F39C
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 12:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhFHKfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 06:35:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229626AbhFHKfj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 06:35:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9421560FF1;
        Tue,  8 Jun 2021 10:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623148426;
        bh=XOwTUXNHiXyuQDOHS+WywOHtraHWTtRBTKQNiPv3kfY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZAzz1VdVhfK67TC0BjwLvjZUVKedewmKi997aGklRltFYJHKS9pIIqS+llx5WDEEs
         l23yJbkC86T+nqm2RBo67oQuzHwJodozPuGaAjb2fTihQh62MRLHhqDWFepZYTcWuS
         dCcCI3hYZzn+hUPqzW0hHHBHg7rETOGMRg4KnXKgdihezehA0fbUMKjvQGEJJiREo+
         cBltxY2i8mVnjAvNXGdng6jjLJcFRw0cEe1bWX8wq7/eVw4OLXKIVxHtJjNpcR09zY
         RtFIGDklKuo8ASKUxQOZ7SKfft8Nl6Nsq6OQeL1viRgRPMNBXBb7D5bmHZAAS2Zz4q
         sSdqwJT0pC2/w==
Received: by pali.im (Postfix)
        id CB3577CC; Tue,  8 Jun 2021 12:33:43 +0200 (CEST)
Date:   Tue, 8 Jun 2021 12:33:43 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>,
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
Subject: Re: What is inside GPON SFP module?
Message-ID: <20210608103343.dyogfexuase5kddo@pali>
References: <20210604192732.GW30436@shell.armlinux.org.uk>
 <AM6PR04MB39768A569CE3CC4EC61A8769EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <YLqLzOltcb6jan+B@lunn.ch>
 <AM6PR04MB39760B986E86BA9169DEECC5EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604233455.fwcu2chlsed2gwmu@pali>
 <20210605003306.GY30436@shell.armlinux.org.uk>
 <20210605122639.4lpox5bfppoyynl3@skbuf>
 <20210605125004.v6njqob6prb7k75k@pali>
 <80966478-8a7c-b66f-50b7-e50fc00b1784@hauke-m.de>
 <20210605144105.GZ30436@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210605144105.GZ30436@shell.armlinux.org.uk>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday 05 June 2021 15:41:05 Russell King (Oracle) wrote:
> On Sat, Jun 05, 2021 at 03:04:55PM +0200, Hauke Mehrtens wrote:
> > Is there a list of things these GPON sticks running Linux should do better
> > in the future? For example what to avoid in the EEPROM emulation handling?
> 
> That is just not worth persuing. Large ISP-companies who have plenty of
> buying power have tried to get issues with GPON sticks resolved, and the
> response from the GPON stick manufacturers has not been helpful. I had
> contracted with a national telco over this problem in recent years, and
> I know they tried their best.
> 
> If large ISP companies who are significant customers can't effect any
> fixes, you can be absolutely sure that the voluntary effort around the
> Linux kernel will have no effect.

I see :-( So it does not make sense to try to do anything...

> Yes, we list the modules that don't work well in the kernel source, and
> sometimes we name and shame them, but they don't care.
> 
> For example, there is are a few modules that take up to 60 seconds
> before they respond to any I2C requests, because the I2C is entirely
> emulated by the Linux kernel running on the stick, and it takes that
> long for the stick to boot. Will that ever get fixed? Probably not
> without a hardware redesign. Will that happen? I really doubt it, and
> eevn if it did it doesn't affect the millions of sticks already out
> there.
> 
> IMHO trying to get these issues fixed is pie in the sky.
> 
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

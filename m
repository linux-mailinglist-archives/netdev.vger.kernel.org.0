Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6713A3ADBB3
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 22:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhFSUhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 16:37:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229475AbhFSUhp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Jun 2021 16:37:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98E22610A7;
        Sat, 19 Jun 2021 20:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624134933;
        bh=lER0y7Z4cnY2Oauv/bbe+khn3ZDuybDepS871EY7/oc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KLrc/oEyPql2ZMfLtdBlF89tQMTs0USOuhYcZkJLVQIRRmLHE0Ne4GWx2mVgmZFYv
         STnESKfAwfC3jQCOjw+SO6dN7RhAGtKtJZ7WxiCSMkUMYWkmqi/bIuRepJobtc17o5
         kmHKnFum0+UQQDUiKqFVjLy2KPlf1igSOVC/gbzEnDX6QxHgi8wlWQjbGq9xj9ahpL
         Tun6uy82t2YjFMhnrdfBHHIpdbsNo0Lkww5ZUP3+TIW4Ss1LAFRG4l5OTcmDBUdybU
         MGrT3sv9XAzkMJpSxl0GPzh1lglrwoSHUu2OO95MyBS6Y3KijWxUaXe0KsdPjY30kN
         IKtKFh07orfKg==
Received: by pali.im (Postfix)
        id 41EA71404; Sat, 19 Jun 2021 22:35:31 +0200 (CEST)
Date:   Sat, 19 Jun 2021 22:35:31 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Madalin Bucur <madalin.bucur@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
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
Subject: Re: Unsupported phy-connection-type sgmii-2500 in
 arch/powerpc/boot/dts/fsl/t1023rdb.dts
Message-ID: <20210619203531.nmhpcux5hwwve47e@pali>
References: <20210603143453.if7hgifupx5k433b@pali>
 <YLjxX/XPDoRRIvYf@lunn.ch>
 <20210603194853.ngz4jdso3kfncnj4@pali>
 <AM6PR04MB3976B62084EC462BA02F0C4CEC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604192732.GW30436@shell.armlinux.org.uk>
 <AM6PR04MB39768A569CE3CC4EC61A8769EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <YLqLzOltcb6jan+B@lunn.ch>
 <AM6PR04MB39760B986E86BA9169DEECC5EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604233455.fwcu2chlsed2gwmu@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210604233455.fwcu2chlsed2gwmu@pali>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday 05 June 2021 01:34:55 Pali Rohár wrote:
> On Friday 04 June 2021 21:47:26 Madalin Bucur wrote:
> > > -----Original Message-----
> > > From: Andrew Lunn <andrew@lunn.ch>
> > > Sent: 04 June 2021 23:24
> > > To: Madalin Bucur <madalin.bucur@nxp.com>
> > > Cc: Russell King <linux@armlinux.org.uk>; Pali Rohár <pali@kernel.org>;
> > > Igal Liberman <Igal.Liberman@freescale.com>; Shruti Kanetkar
> > > <Shruti@freescale.com>; Emil Medve <Emilian.Medve@freescale.com>; Scott
> > > Wood <oss@buserror.net>; Rob Herring <robh+dt@kernel.org>; Michael
> > > Ellerman <mpe@ellerman.id.au>; Benjamin Herrenschmidt
> > > <benh@kernel.crashing.org>; netdev@vger.kernel.org;
> > > devicetree@vger.kernel.org; linux-kernel@vger.kernel.org; Camelia
> > > Alexandra Groza (OSS) <camelia.groza@oss.nxp.com>
> > > Subject: Re: Unsupported phy-connection-type sgmii-2500 in
> > > arch/powerpc/boot/dts/fsl/t1023rdb.dts
> > > 
> > > > The "sgmii-2500" compatible in that device tree describes an SGMII HW
> > > > block, overclocked at 2.5G. Without that overclocking, it's a plain
> > > > Cisco (like) SGMII HW block. That's the reason you need to disable it's
> > > > AN setting when overclocked. With the proper Reset Configuration Word,
> > > > you could remove the overclocking and transform that into a plain
> > > "sgmii".
> > > > Thus, the dts compatible describes the HW, as it is.
> > > 
> > > It sounds like the hardware is capable of swapping between SGMII and
> > > 2500BaseX.
> > > 
> > > What we have in DT in this case is not describing the hardware, but
> > > how we configure the hardware. It is one of the few places we abuse DT
> > > for configuration.
> > > 
> > >     Andrew
> > 
> > The actual selection of this mode of operation is performed by the so called
> > Reset Configuration Word from the boot media, that aligned with the HW and
> > board design. The need to name it something other than plain "sgmii" comes
> > from the HW special need for AN to be disabled to operate.
> > 
> > Actually, the weird/non-standard hardware is described by the device tree
> > with a value that puts it in a class of its own. Instead of the overclocked
> > SGMII denomination "sgmii-2500" it could have been named just as well
> > "overclocked-nonstandard-2.5G-ethernet-no-autoneg-SGMII-hw-ip".
> > 
> > One could try to change device trees to slip configuration details, but the
> > backwards compatibility aspect renders this futile. Is there any option to
> > say "sgmii" then "autoneg disabled"?
> > 
> > Madalin
> 
> Madalin, my understanding is that "sgmii-2500" mode is unknown and
> unsupported by kernel.
> 
> List of known modes which can be specified in DTS file are defined in
> YAML schema for 'phy-connection-type' in file:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/devicetree/bindings/net/ethernet-controller.yaml?h=v5.12#n55
> 
> And there is none "sgmii-2500", so some DTS schema validator could throw
> validation error for that DTS file. I'm not sure if somebody has written
> DTS schema validator with all those things (like there are JSON schema
> or OpenAPI validators in JavaScript / HTTP world).
> 
> Plus also in linux/phy.h header file contains list of known Linux modes:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/phy.h?h=v5.12#n169
> 
> And based on all information in this email discussion, in my opinion the
> mode which HW supports matches Linux meaning of "2500base-x" key/string.
> So I would suggest to rename "sgmii-2500" in that DTS file to
> "2500base-x". Does it make sense?

Any opinion? Or should I send a patch?

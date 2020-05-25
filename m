Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18D81E1852
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388187AbgEYXqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:46:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48892 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbgEYXqa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 19:46:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CxzTlziK84zGuAleYtWVEUh2zonjBelkqBVnl4l1PQ4=; b=Im0GdbxurOBtV9pe2N3CTkq5X2
        zs45BcI2mChTEvhcaUVST5WjYbichHdOueRHIEZUQmewelI4ohZKqX0i3Is5EYGk1PZ426ypUq3W4
        g+zJW4CkgdoP+zTGy88WjUXyvi5rgUNvmL7V45fja1gcX2w95oFNFzykmPVRhZxDvWF4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdMnX-003Eom-3T; Tue, 26 May 2020 01:46:23 +0200
Date:   Tue, 26 May 2020 01:46:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, madalin.bucur@oss.nxp.com,
        calvin.johnson@oss.nxp.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC 04/11] net: phy: Handle c22 regs presence better
Message-ID: <20200525234623.GG768009@lunn.ch>
References: <20200523183731.GZ1551@shell.armlinux.org.uk>
 <f85e4d86-ff58-0ed2-785b-c51626916140@arm.com>
 <20200525100612.GM1551@shell.armlinux.org.uk>
 <63ca13e3-11ea-3ddf-e1c7-90597d4a5f8c@arm.com>
 <20200525220127.GO1551@shell.armlinux.org.uk>
 <a9490c28-ebe1-ed6d-e65e-2e1d0a06386b@arm.com>
 <20200525230946.GR1551@shell.armlinux.org.uk>
 <ab756571-b269-ba7f-8e23-053098d9f470@arm.com>
 <20200525233335.GT1551@shell.armlinux.org.uk>
 <269de1a4-57cf-b175-3184-2f4604255bf7@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <269de1a4-57cf-b175-3184-2f4604255bf7@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Right, which is what I sort of expected. Because its falling back to a
> device list of 0xFFFFFFFF, which means probe every single MMD.
> 
> Combined with the lack of filtering means that your getting a bunch of MMD
> IDs that potentially are invalid, along with any that happen to be valid.
> Its that behavior (and some others) which were what blew this set up from a
> couple lines of tweaks into this mess.
> 
> I don't really see a way to guess at all the "wrong" ids that are being
> pushed into the system. Which is why I started to think about a "strict"
> mode later in the set. Maybe at this point the only way around some of these
> bugs/side effects/etc is just a second c45 probe routine if we don't think
> its possible to implement a variable strictness scanner in this code path
> without losing phys that previously were detected.

Hi Jeremy

I really think we need to find one of those boards which have a
cortina and see what it actually does. Can you get in contact with NXP
and see if they can find one?

    Thanks
        Andrew

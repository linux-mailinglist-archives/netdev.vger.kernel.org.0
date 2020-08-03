Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF7423AB13
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 18:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgHCQ7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 12:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbgHCQ7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 12:59:03 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3666C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 09:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UlriNvX6+STsFx+IilFd2tRB1Lnp92AIhazSyvvSgzo=; b=xi+Hs7ZKWTYmM1naxSd+uN1M8
        Vfqd1bXUC9AN5rlWHLWYMuOwwX17fBn51cvwFJrChmc3GbZU7dWS8MI5uyk0NB9cPHOFr6l5CX7PK
        rKb25lCMBlbZUDzFpEfmnH9vR79MMYhycMbiVcOSkAhqwGFPVbJcovWhf8yRgT4TPjtE49W40h+XD
        RhXzRcXU+TXnpqTgte0fI81IVKO7+hyCDzJiCvjokdlR+cXLVrJXlu9qeTJ3wbe/LI2o099CyTdJn
        zLad0CeItwpUI0cbFdbimh+yTstdeY5Lj5uiQvckauGYftmNPnDTtynXdoZ8NEorussG3Uvq64giW
        97NprGr1w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47868)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k2dng-0001jY-PN; Mon, 03 Aug 2020 17:59:00 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k2dng-0003FA-7S; Mon, 03 Aug 2020 17:59:00 +0100
Date:   Mon, 3 Aug 2020 17:59:00 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Vikas Singh <vikas.singh@puresoftware.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>,
        kuldip dwivedi <kuldip.dwivedi@puresoftware.com>,
        Vikas Singh <vikas.singh@nxp.com>
Subject: Re: [PATCH 2/2] net: phy: Associate device node with fixed PHY
Message-ID: <20200803165900.GQ1551@shell.armlinux.org.uk>
References: <20200731153119.GJ1712415@lunn.ch>
 <CADvVLtUrZDGqwEPO_ApCWK1dELkUEjrH47s1CbYEYOH9XgZMRg@mail.gmail.com>
 <20200801094132.GH1551@shell.armlinux.org.uk>
 <20200801151107.GK1712415@lunn.ch>
 <AM6PR04MB3976BB0CAB0B4270FF932F62EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20200803090716.GL1551@shell.armlinux.org.uk>
 <AM6PR04MB3976284AEC94129D26300485EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20200803125742.GK1862409@lunn.ch>
 <AM6PR04MB3976D3E9BA05AB5D4EBB6AA6EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20200803150051.GA1919070@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803150051.GA1919070@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 05:00:51PM +0200, Andrew Lunn wrote:
> On Mon, Aug 03, 2020 at 02:33:56PM +0000, Madalin Bucur (OSS) wrote:
> > > -----Original Message-----
> > > From: Andrew Lunn <andrew@lunn.ch>
> > > Sent: 03 August 2020 15:58
> > > To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> > > Cc: Russell King - ARM Linux admin <linux@armlinux.org.uk>; Vikas Singh
> > > <vikas.singh@puresoftware.com>; f.fainelli@gmail.com; hkallweit1@gmail.com;
> > > netdev@vger.kernel.org; Calvin Johnson (OSS) <calvin.johnson@oss.nxp.com>;
> > > kuldip dwivedi <kuldip.dwivedi@puresoftware.com>; Vikas Singh
> > > <vikas.singh@nxp.com>
> > > Subject: Re: [PATCH 2/2] net: phy: Associate device node with fixed PHY
> > > 
> > > > I see you agree that there were and there will be many changes for a
> > > while,
> > > > It's not a complaint, I know hot it works, it's just a decision based on
> > > > required effort vs features offered vs user requirements. Lately it's
> > > been
> > > > time consuming to try to fix things in this area.
> > > 
> > > So the conclusion to all this that you are unwilling to use the
> > > correct API for this, which would be phylink, and the SFP code.  So:
> > > 
> > > NACK
> > > 
> > > 	Andrew
> > 
> > You've rejected a generic change - ACPI support for fixed link.
> > The discussion above is just an example of how it could have been (mis-)used.
> > Are you rejecting the general case or just the particular one?
> 
> So far, nobody has corrected me that the MAC is not connected to an
> SFP socket. So i see two sorts of abuse going on here:
> 
> 1) Using a fixed link with a hack to allow 10G. phylink allows 10G
>    fixed links without an hacks.
> 
> 2) Using a fixed link when not even appropriate since phylink should
>    be used to control the SFP.
> 
> Now, you can do whatever you want in your Vendor Crap tree. But there
> is no reason mainline should help you support your vendor crap tree.

+1 for everything above.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

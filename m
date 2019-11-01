Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20620EC16E
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 11:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbfKAK6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 06:58:03 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36308 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbfKAK6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 06:58:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=p5xtTztut9m7IGI6grqmZxTPCocjD5jUv95zsKCT0yg=; b=ICI/5hcyPtqJqKIMtvE5cYagm
        f/dqg4nlUyDkSdfSGCAfQpgiwKloQUtI6oinbnAzbq0ZWxyob9u4/9Ko0NObHWCQ1MZW3EMHalRyt
        OKspb+Rc6NENSRu2HoszqM8K6BS1iEIprFzG5GZQ37n2TMr5EhBIkPpUYmRsdMTyc6b1Ho6dMvdzc
        gMdBmC2w1oceLopybJxY4s0zhF2294jXFU3jTgLyqL1c0t4w8eaAZAR1tNnvjkxZOjog9XFIBNP7c
        ElbokDsJbbrpb1v61rEM/rz7nmfoBdVOWukBs7OGVW19heDE1kPL21f5XgajMyojbKu57sRTQ+F/J
        dJp03TV5A==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:50240)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iQUcq-0004NE-4J; Fri, 01 Nov 2019 10:57:52 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iQUcj-0007Tm-Gr; Fri, 01 Nov 2019 10:57:45 +0000
Date:   Fri, 1 Nov 2019 10:57:45 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Priit Laes <plaes@plaes.org>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "wens@csie.org" <wens@csie.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>
Subject: Re: sun7i-dwmac: link detection failure with 1000Mbit parters
Message-ID: <20191101105745.GJ25745@shell.armlinux.org.uk>
References: <20191030202117.GA29022@plaes.org>
 <BN8PR12MB32660687285D2C76E7CF2FF6D3630@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20191031103841.GI25745@shell.armlinux.org.uk>
 <20191101094920.GB12834@plaes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101094920.GB12834@plaes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 01, 2019 at 09:49:20AM +0000, Priit Laes wrote:
> On Thu, Oct 31, 2019 at 10:38:41AM +0000, Russell King - ARM Linux admin wrote:
> >   mii-diag -v eth0
> > 
> > would be useful to see for the case where the link has failed, without
> > replugging the ethernet cable.
> 
> mii-diag seems to be quite an useful tool, but unfortunately has not been
> packaged anymore on newer distro releases like Debian stable and latest
> Ubuntu LTS.

which is unfortunate because it's the best tool for debugging PHY
related problems.  mii-tool doesn't dump registers, and dumping the
PHY registers is extremely useful.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up

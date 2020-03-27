Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73BC9195CF3
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 18:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbgC0RfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 13:35:22 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:37382 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgC0RfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 13:35:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZBw9o6watwDnhvDMeAgnKRN69VRM8VBKTDHTKhljwTs=; b=jzfSJFSjQAp7L+DZ2FFYtMgQe
        y1mQA5paQGlunQ9gxYvq1icU474mu8+UQbPOEgHsPmTXw/BK7lO1pVuggeqq7KxgrYypZnRAQ+aLi
        yn4YzLA4cwVqKErTn0T5C4KsZ33WFGEQYyU+nLBH/S+rld8vvdLnI8GKtPg307FTcaIkMbbYX0R32
        5FGWPOL6OdpMlZ5FhK4Xke/x6/6f8CRxw0uu800ZD6wezkPSRfTnstb83e7+lmMxAltI+fKcJCUo5
        mfI98bk/JKfWSF81tWjFCbXYU6WJXQLF5Wu39TwqQa3KIFtq9hRivDbowGYHeGNBVHu/MMiNcTZrW
        LqLG9c56w==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:58714)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jHssx-0002Oj-Cz; Fri, 27 Mar 2020 17:35:11 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jHsst-0004P3-7e; Fri, 27 Mar 2020 17:35:07 +0000
Date:   Fri, 27 Mar 2020 17:35:07 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florinel Iordache <florinel.iordache@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH net-next 2/9] dt-bindings: net: add backplane
 dt bindings
Message-ID: <20200327173507.GQ25745@shell.armlinux.org.uk>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
 <1585230682-24417-3-git-send-email-florinel.iordache@nxp.com>
 <20200327010411.GM3819@lunn.ch>
 <AM0PR04MB5443185A1236F621B9EC9873FBCC0@AM0PR04MB5443.eurprd04.prod.outlook.com>
 <20200327152849.GP25745@shell.armlinux.org.uk>
 <20200327154448.GK11004@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327154448.GK11004@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 04:44:48PM +0100, Andrew Lunn wrote:
> > What worries me is the situation which I've been working on, where
> > we want access to the PCS PHYs, and we can't have the PCS PHYs
> > represented as a phylib PHY because we may have a copper PHY behind
> > the PCS PHY, and we want to be talking to the copper PHY in the
> > first instance (the PCS PHY effectivel ybecomes a slave to the
> > copper PHY.)
> 
> I guess we need to clarify what KR actually means. If we have a
> backplane with a MAC on each end, i think modelling it as a PHY could
> work.
> 
> If however, we have a MAC connected to a backplane, and on the end of
> the backplane is a traditional PHY, or an SFP cage, we have problems.
> As your point out, we cannot have two PHYs in a chain for one MAC.
> 
> But i agree with Russell. We need a general solution of how we deal
> with PCSs.

What really worries me is that we may be driving the same hardware
with two different approaches/drivers for two different applications
which isn't going to work out very well in the long run.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
